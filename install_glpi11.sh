#!/bin/bash
# ============================================================
#  Script d'installation automatisée de GLPI 11.0.2
#  Système cible : Debian 13
#  Auteur       : Généré automatiquement
# ============================================================

set -euo pipefail

# ---------- Couleurs ----------
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'
CYAN='\033[0;36m'; BOLD='\033[1m'; NC='\033[0m'

log()     { echo -e "${GREEN}[OK]${NC} $*"; }
info()    { echo -e "${CYAN}[INFO]${NC} $*"; }
warn()    { echo -e "${YELLOW}[WARN]${NC} $*"; }
error()   { echo -e "${RED}[ERREUR]${NC} $*"; exit 1; }
section() { echo -e "\n${BOLD}${CYAN}>>> $* ${NC}\n"; }

# ---------- Vérification root ----------
[[ $EUID -ne 0 ]] && error "Ce script doit être exécuté en tant que root (sudo)."

# ============================================================
#  PARAMÈTRES — modifiez ces valeurs avant de lancer le script
# ============================================================
DB_NAME="glpi"
DB_USER="ambre"
DB_PASS="Azerty1"          # ⚠️  Changez ce mot de passe !
SERVER_IP=""               # Sera détecté automatiquement si vide
GLPI_VERSION="11.0.2"
GLPI_URL="https://github.com/glpi-project/glpi/releases/download/${GLPI_VERSION}/glpi-${GLPI_VERSION}.tgz"
GLPI_ARCHIVE="/tmp/glpi-${GLPI_VERSION}.tgz"
GLPI_DIR="/var/www/html/glpi"
VHOST_CONF="/etc/apache2/sites-available/glpi.conf"
PHP_SOCK="/run/php/php8.4-fpm.sock"

# ============================================================
#  DÉTECTION DE L'IP
# ============================================================
detect_ip() {
    if [[ -z "$SERVER_IP" ]]; then
        SERVER_IP=$(hostname -I | awk '{print $1}')
        info "IP détectée automatiquement : $SERVER_IP"
    fi
}

# ============================================================
#  ÉTAPE 1 — Mise à jour du système
# ============================================================
step1_update() {
    section "ÉTAPE 1 — Mise à jour du système"
    apt-get update -qq && apt-get upgrade -y -qq
    log "Système mis à jour."
}

# ============================================================
#  ÉTAPE 2 — Installation LAMP + extensions PHP
# ============================================================
step2_lamp() {
    section "ÉTAPE 2 — Installation LAMP + extensions PHP"
    apt-get install -y apache2 php mariadb-server
    apt-get install -y \
        php-xml php-common php-json php-mysql php-mbstring \
        php-curl php-gd php-intl php-zip php-bz2 php-apcu \
        php-ldap php-fpm php-bcmath
    log "LAMP et extensions PHP installés."
}

# ============================================================
#  ÉTAPE 3 — Sécurisation et configuration de MariaDB
# ============================================================
step3_mariadb() {
    section "ÉTAPE 3 — Configuration de MariaDB"

    # Sécurisation non-interactive (équivalent mariadb-secure-installation)
    mysql -u root <<EOF
-- Supprimer les utilisateurs anonymes
DELETE FROM mysql.user WHERE User='';
-- Désactiver l'accès root à distance
DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');
-- Supprimer la base de test
DROP DATABASE IF EXISTS test;
DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';
-- Appliquer les changements
FLUSH PRIVILEGES;
EOF
    log "MariaDB sécurisé."

    # Création de la base et de l'utilisateur GLPI
    mysql -u root <<EOF
CREATE DATABASE IF NOT EXISTS ${DB_NAME} CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER IF NOT EXISTS '${DB_USER}'@'localhost' IDENTIFIED BY '${DB_PASS}';
GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO '${DB_USER}'@'localhost';
FLUSH PRIVILEGES;
EOF
    log "Base de données '${DB_NAME}' et utilisateur '${DB_USER}' créés."
}

# ============================================================
#  ÉTAPE 4 — Téléchargement et extraction de GLPI
# ============================================================
step4_download() {
    section "ÉTAPE 4 — Téléchargement de GLPI ${GLPI_VERSION}"

    if [[ -f "$GLPI_ARCHIVE" ]]; then
        warn "Archive déjà présente, téléchargement ignoré."
    else
        wget -q --show-progress -O "$GLPI_ARCHIVE" "$GLPI_URL" \
            || error "Échec du téléchargement depuis $GLPI_URL"
    fi

    tar -xzf "$GLPI_ARCHIVE" -C /var/www/html/
    log "GLPI extrait dans /var/www/html/"

    chmod 755 -R /var/www/html/
    chown www-data:www-data -R /var/www/html/
    log "Permissions appliquées."
}

# ============================================================
#  ÉTAPE 5 — Configuration Apache (VirtualHost)
# ============================================================
step5_apache() {
    section "ÉTAPE 5 — Configuration Apache"
    detect_ip

    cat > "$VHOST_CONF" <<VHOST
<VirtualHost *:80>
    ServerName glpi
    ServerAlias ${SERVER_IP}
    DocumentRoot /var/www/html

    Alias /glpi /var/www/html/glpi/public

    <Directory /var/www/html/glpi/public>
        Options -Indexes +FollowSymLinks
        Require all granted
        RewriteEngine On
        RewriteBase /glpi/
        RewriteCond %{REQUEST_FILENAME} !-f
        RewriteCond %{REQUEST_FILENAME} !-d
        RewriteRule ^ index.php [QSA,L]
    </Directory>

    <FilesMatch \.php$>
        SetHandler "proxy:unix:${PHP_SOCK}|fcgi://localhost"
    </FilesMatch>

    ErrorLog \${APACHE_LOG_DIR}/glpi_error.log
    CustomLog \${APACHE_LOG_DIR}/glpi_access.log combined
</VirtualHost>
VHOST

    log "VirtualHost créé : $VHOST_CONF"

    # Activation des modules et du site
    a2enmod proxy_fcgi setenvif
    a2enmod rewrite

    # Activation de la conf php-fpm (gère plusieurs versions)
    PHP_FPM_CONF=$(ls /etc/apache2/conf-available/php*-fpm.conf 2>/dev/null | head -1)
    if [[ -n "$PHP_FPM_CONF" ]]; then
        a2enconf "$(basename "$PHP_FPM_CONF" .conf)"
        log "Conf PHP-FPM activée : $PHP_FPM_CONF"
    else
        warn "Aucune conf php*-fpm trouvée — vérifiez manuellement avec 'a2enconf php*-fpm'."
    fi

    a2dissite 000-default.conf 2>/dev/null || true
    a2ensite glpi.conf
    log "Site GLPI activé, site par défaut désactivé."
}

# ============================================================
#  ÉTAPE 6 — Redémarrage des services
# ============================================================
step6_restart() {
    section "ÉTAPE 6 — Redémarrage des services"
    systemctl restart apache2 mariadb php8.4-fpm 2>/dev/null || \
        systemctl restart apache2 mariadb
    log "Apache, MariaDB (et PHP-FPM si disponible) redémarrés."
}

# ============================================================
#  RÉCAPITULATIF FINAL
# ============================================================
summary() {
    detect_ip
    echo ""
    echo -e "${BOLD}${GREEN}╔══════════════════════════════════════════════════╗"
    echo -e "║       ✅  Installation GLPI terminée !           ║"
    echo -e "╚══════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "  🌐  URL d'accès     : ${CYAN}http://${SERVER_IP}/glpi${NC}"
    echo -e "  🗄️   Base de données : ${YELLOW}${DB_NAME}${NC}"
    echo -e "  👤  Utilisateur DB  : ${YELLOW}${DB_USER}${NC}"
    echo -e "  🔑  Mot de passe DB : ${YELLOW}${DB_PASS}${NC}"
    echo ""
    echo -e "  ➡️  Finalisez l'installation via l'interface web."
    echo -e "  ⚠️  Supprimez le répertoire install/ après la configuration :"
    echo -e "      ${CYAN}rm -rf ${GLPI_DIR}/install${NC}"
    echo ""
}

# ============================================================
#  POINT D'ENTRÉE
# ============================================================
main() {
    echo -e "${BOLD}${CYAN}"
    echo "  ╔═══════════════════════════════════════════╗"
    echo "  ║   Installation GLPI ${GLPI_VERSION} — Debian 13   ║"
    echo "  ╚═══════════════════════════════════════════╝"
    echo -e "${NC}"

    step1_update
    step2_lamp
    step3_mariadb
    step4_download
    step5_apache
    step6_restart
    summary
}

main "$@"
