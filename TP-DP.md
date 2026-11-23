# TP COMPLET - Déploiement d'une Infrastructure Microsoft Exchange Server SE et GLPI

## Formation TSSR
### Version : Novembre 2026

---

# Sommaire

1. Présentation du projet
2. Objectifs pédagogiques
3. Architecture de l'infrastructure
4. Plan d'adressage IP
5. Prérequis matériels
6. Déploiement de la VM1 : Contrôleur de domaine
7. Installation d'Active Directory
8. Installation du service DNS
9. Vérifications du domaine
10. Déploiement de la VM2 : Exchange Server SE
11. Préparation du serveur Exchange
12. Installation d'Exchange Server SE
13. Création des utilisateurs et boîtes aux lettres
14. Validation de la messagerie
15. Déploiement de la VM3 : Debian 12
16. Installation du serveur LAMP
17. Installation de GLPI
18. Installation de GLPI Inventory
19. Installation des agents d'inventaire
20. Vérifications finales
21. Conclusion

---

# 1. Présentation du projet

Dans le cadre de la formation Technicien Supérieur Systèmes et Réseaux (TSSR), ce TP a pour objectif de mettre en œuvre une infrastructure complète représentant le système d'information d'une PME.

Cette infrastructure permettra :

- la centralisation des comptes utilisateurs ;
- l'authentification sur un domaine Active Directory ;
- la résolution DNS interne ;
- la gestion d'une messagerie professionnelle avec Exchange Server SE ;
- l'inventaire automatisé du parc informatique ;
- la gestion des actifs informatiques via GLPI.

L'infrastructure est déployée sous VMware Workstation avec un réseau NAT.

---

# 2. Objectifs pédagogiques

À l'issue du TP, l'apprenant sera capable de :

- Installer Windows Server 2025.
- Déployer un domaine Active Directory.
- Configurer le service DNS.
- Installer Exchange Server SE.
- Créer des utilisateurs et des boîtes aux lettres.
- Installer Debian 12.
- Déployer une architecture LAMP.
- Installer GLPI.
- Mettre en œuvre GLPI Inventory.
- Réaliser un inventaire automatique des équipements.

---

# 3. Architecture de l'infrastructure

```text
Domaine : lab.local

VMnet8 NAT
192.168.174.0/24

                         +----------------------+
                         |     DC-EXCHANGE      |
                         | 192.168.174.250      |
                         | Windows Server 2025  |
                         | Active Directory     |
                         | DNS                  |
                         +----------+-----------+
                                    |
                                    |
                                    |
              +---------------------+---------------------+
              |                                           |
              |                                           |
              v                                           v

     +----------------------+              +----------------------+
     |       EXCHANGE       |              |         GLPI         |
     | 192.168.174.251      |              | 192.168.174.134      |
     | Windows Server 2025  |              | Debian 12            |
     | Exchange Server SE   |              | Apache2              |
     | OWA / ECP            |              | MariaDB              |
     +----------------------+              | PHP                  |
                                            | GLPI                |
                                            | GLPI Inventory      |
                                            +----------------------+
```

---

# 4. Plan d'adressage IP

| Équipement | Adresse |
|------------|----------|
| DC-EXCHANGE | 192.168.174.250 |
| EXCHANGE | 192.168.174.251 |
| GLPI | 192.168.174.134 |
| Passerelle VMware NAT | 192.168.174.2 |
| Domaine | lab.local |

Masque réseau :

```text
255.255.255.0
```

---

# 5. Prérequis matériels

## VM1 - DC-EXCHANGE

```text
2 vCPU
8 Go RAM
60 Go SSD
Windows Server 2025 
```

## VM2 - EXCHANGE

```text
4 vCPU
16 Go RAM
60 Go SSD
Windows Server 2025 
```

## VM3 - GLPI

```text
1 vCPU
2 Go RAM
20 Go SSD
Debian 13
```

---

# 6. Déploiement de la VM1 : DC-EXCHANGE

Installer Windows Server 2025.

Définir :

```text
Nom : DC-EXCHANGE
```

Configuration IP :

```text
IP : 192.168.174.250
Masque : 255.255.255.0
Passerelle : 192.168.174.2
DNS : 192.168.174.250
```

Renommer le serveur :

```powershell
Rename-Computer -NewName "DC-EXCHANGE" -Restart
```

---

# 7. Installation d'Active Directory

Installer le rôle :

```powershell
Install-WindowsFeature AD-Domain-Services -IncludeManagementTools
```

Créer la forêt Active Directory :

```powershell
Install-ADDSForest `
-DomainName "lab.local" `
-DomainNetbiosName "LAB"
```

Valider puis laisser le serveur redémarrer.

---

# 8. Installation du service DNS

Le rôle DNS est installé automatiquement avec Active Directory.

Créer les enregistrements A suivants :

```text
dc-exchange.lab.local -> 192.168.174.250
exchange.lab.local    -> 192.168.174.251
glpi.lab.local        -> 192.168.174.134
```

---

# 9. Vérifications du domaine

Exécuter :

```powershell
dcdiag
```

Tester la résolution DNS :

```powershell
nslookup exchange.lab.local
```

```powershell
nslookup glpi.lab.local
```

Afficher les informations du domaine :

```powershell
Get-ADDomain
```

---

# 10. Déploiement de la VM2 : EXCHANGE

Installer Windows Server 2025.

Configurer :

```text
Nom : EXCHANGE

IP : 192.168.174.251
Masque : 255.255.255.0
Passerelle : 192.168.174.2
DNS : 192.168.174.250
```

Renommer :

```powershell
Rename-Computer -NewName "EXCHANGE" -Restart
```

Joindre le domaine :

```powershell
Add-Computer -DomainName "lab.local" -Restart
```

---

# 11. Préparation du serveur Exchange

Installer les composants nécessaires :

```powershell
Install-WindowsFeature `
Server-Media-Foundation,
RSAT-ADDS,
Web-Server,
Web-Basic-Auth,
Web-Windows-Auth,
Web-Metabase,
Web-Net-Ext45,
Web-ISAPI-Ext,
Web-ISAPI-Filter,
Web-Asp-Net45,
Web-Mgmt-Console
```

Redémarrer :

```powershell
Restart-Computer
```

Installer Microsoft Edge WebView2 Runtime.

---

# 12. Installation d'Exchange Server SE

Monter l'image ISO d'Exchange Server SE.

Depuis une console PowerShell administrateur :

Préparation du schéma :

```powershell
Setup.exe /PrepareSchema /IAcceptExchangeServerLicenseTerms_DiagnosticDataON
```

Préparation de l'organisation :

```powershell
Setup.exe /PrepareAD /OrganizationName:"LAB" /IAcceptExchangeServerLicenseTerms_DiagnosticDataON
```

Préparation des domaines :

```powershell
Setup.exe /PrepareAllDomains /IAcceptExchangeServerLicenseTerms_DiagnosticDataON
```

Lancer ensuite l'installation graphique :

```powershell
Setup.exe
```

Sélectionner :

```text
Mailbox Role
```

Attendre la fin de l'installation.

---

# 13. Création des utilisateurs et boîtes aux lettres

Créer un utilisateur :

```powershell
New-ADUser `
-Name "David Mansart" `
-GivenName "David" `
-Surname "Mansart" `
-SamAccountName "dmansart" `
-UserPrincipalName "david@lab.local" `
-AccountPassword (ConvertTo-SecureString "Azerty1" -AsPlainText -Force) `
-Enabled $true
```

Activer la boîte aux lettres :

```powershell
Enable-Mailbox -Identity dmansart
```

Vérifier :

```powershell
Get-Mailbox
```

---

# 14. Validation de la messagerie

Accéder à la console Exchange :

```text
https://exchange.lab.local/ecp
```

Accéder à Outlook Web Access :

```text
https://exchange.lab.local/owa
```

Effectuer un test d'envoi et de réception de message.

---

# 15. Déploiement de la VM3 : GLPI

Installer Debian 12.

Configurer :

```text
Nom : GLPI

IP : 192.168.174.134
Masque : 255.255.255.0
Passerelle : 192.168.174.2
DNS : 192.168.174.250
```

Mettre à jour le système :

```bash
apt update
apt full-upgrade -y
```

---

# 16. Installation du serveur LAMP

Installer Apache :

```bash
apt install apache2 -y
```

Installer MariaDB :

```bash
apt install mariadb-server -y
```

Installer PHP :

```bash
apt install php php-mysql php-curl php-gd php-intl php-bz2 php-imap php-mbstring php-xml php-zip libapache2-mod-php -y
```

Vérifier :

```bash
systemctl status apache2
```

```bash
systemctl status mariadb
```

---

# 17. Installation de GLPI

SCRIPT :   
  
<div style="border:1px solid#ccc; padding:10px; border-radius:5px;">
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
</div>  
  
Redémarrer Apache :

```bash
systemctl restart apache2
```

Accès :

```text
http://glpi.lab.local/glpi
```

---

# 18. Installation de GLPI Inventory

Depuis GLPI :

```text
Administration
→ Marketplace
→ GLPI Inventory
```

Installer puis activer le plugin.

---

# 19. Installation des agents d'inventaire

## Sur DC-EXCHANGE

Installer GLPI Agent.

Renseigner :

```text
http://glpi.lab.local/glpi/front/inventory.php
```

Lancer un inventaire :

```cmd
glpi-agent.exe --force
```

## Sur EXCHANGE

Installer GLPI Agent.

Configurer :

```text
http://glpi.lab.local/glpi/front/inventory.php
```

Lancer :

```cmd
glpi-agent.exe --force
```

## Sur GLPI

Installer :

```bash
apt install glpi-agent -y
```

Éditer :

```bash
nano /etc/glpi-agent/agent.cfg
```

Ajouter :

```text
server = http://127.0.0.1/glpi/front/inventory.php
```

Redémarrer :

```bash
systemctl restart glpi-agent
```

---

# 20. Vérifications finales

## Active Directory

```powershell
Get-ADUser -Filter '*'
```

## Exchange

```powershell*Get-Mailbox
```

```powershell
*et-ExchangeServer
```

*# GLPI

Vérifier la*présence des équipements :

```*ext
DC-EXCHANGE
EX*HANGE
GLPI
```

Val*der les inventaires.

---

#*21. Conclusion

Cette infrastructu*e met*en œuvre les principaux services*rencontrés en*entreprise :

- Authentification c*ntralisée Active*Directory
- Rés*lution DNS
- Gestion des utilisate*rs
- Messagerie Exchange Server SE*- Interface OWA
- Invent*ire automatique du*parc
- Gestion des actifs avec GLP*

*e laboratoire constitue un environ*ement complet permettant de démont*er les compétences attendues d'un *echnicien Supérieur S*stèmes et Réseaux.
``*
