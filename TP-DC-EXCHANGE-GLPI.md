# TP COMPLET - Active Directory, DNS, Exchange et GLPI

## Objectif

Mettre en place une infrastructure complète composée de :

- 1 Contrôleur de domaine Active Directory
- 1 Serveur Exchange intégré à l'AD
- 1 Serveur GLPI sous Debian
- Inventaire automatique des 3 serveurs
- Authentification LDAP
- Liaison GLPI / Exchange
- Notifications par mail

---

# Architecture

| Serveur | OS | Nom | IP |
|----------|----------|----------|----------|
| Contrôleur de domaine | Windows Server 2025 | DC-EXCHANGE | 192.168.174.250 |
| Exchange | Windows Server 2025 | EXCHANGE | 192.168.174.251 |
| GLPI | Debian 13 | GLPI | 192.168.174.134 |

Réseau :

```text
Mode : NAT
Masque : 255.255.255.0
Passerelle : 192.168.174.2
DNS : 192.168.174.250
```

---

# I - Installation du serveur DC-EXCHANGE

## 1. Installation Windows Server 2025

Version :

```text
Windows Server 2025 Standard Desktop Experience
```

Nom du serveur :

```text
DC-EXCHANGE
```

---

## 2. Configuration IP fixe

```text
Adresse IP : 192.168.174.250
Masque : 255.255.255.0
Passerelle : 192.168.174.2
DNS : 192.168.174.250
```

Vérification :

```powershell
ipconfig /all
```

---

## 3. Installation AD DS et DNS

Gestionnaire de serveur :

```text
Ajouter des rôles et fonctionnalités
```

Installer :

```text
✓ Active Directory Domain Services
✓ DNS Server
```

---

## 4. Promotion en contrôleur de domaine

Créer une nouvelle forêt :

```text
tssrprenom.local
```

Exemple :

```text
david.local
```

Définir le mot de passe DSRM puis redémarrer.

---

## 5. Vérification AD

```powershell
dcdiag
```

Ouvrir :

```text
Utilisateurs et ordinateurs Active Directory
```

Ouvrir :

```text
Gestionnaire DNS
```

---

## 6. Création d'un utilisateur administrateur

Créer :

```text
Nom : Admin
Login : admin
```

Ajouter au groupe :

```text
Domain Admins
```

---

# II - Installation du serveur EXCHANGE

## 1. Installation de Windows Server 2025

Nom :

```text
EXCHANGE
```

IP :

```text
192.168.174.251
```

DNS :

```text
192.168.174.250
```

---

## 2. Vérification réseau

Depuis EXCHANGE :

```powershell
ping 192.168.174.250
```

```powershell
nslookup dc-exchange
```

```powershell
nslookup tssrprenom.local
```

---

## 3. Intégration au domaine

Joindre :

```text
tssrprenom.local
```

Redémarrer.

Connexion :

```text
TSSRPRENOM\Administrator
```

---

## 4. Préparation Exchange

Installer les prérequis :

```powershell
Install-WindowsFeature RSAT-ADDS
```

```powershell
Install-WindowsFeature Server-Media-Foundation
```

Redémarrer.

---

## 5. Installation Exchange

Monter l'ISO Exchange.

Préparation du schéma :

```powershell
Setup.exe /PrepareSchema /IAcceptExchangeServerLicenseTerms_DiagnosticDataON
```

Préparation de l'organisation :

```powershell
Setup.exe /PrepareAD /OrganizationName:"TSSR"
```

Installation :

```powershell
Setup.exe /Mode:Install /Roles:Mailbox
```

---

## 6. Vérification Exchange

Accès :

```text
https://exchange/ecp
```

ou

```text
https://192.168.174.251/ecp
```

---

## 7. Création d'une boîte mail

Créer :

```text
admin@tssrprenom.local
```

Créer également :

```text
support@tssrprenom.local
```

```text
glpi@tssrprenom.local
```

---

# III - Installation Debian 13 GLPI

## 1. Configuration IP fixe

Modifier :

```bash
sudo nano /etc/network/interfaces
```

Configuration :

```text
auto ens33
iface ens33 inet static

address 192.168.174.134
netmask 255.255.255.0
gateway 192.168.174.2
dns-nameservers 192.168.174.250
```

Redémarrer :

```bash
sudo reboot
```

---

## 2. Vérification réseau

```bash
ping 192.168.174.250
```

```bash
ping 192.168.174.251
```

```bash
nslookup dc-exchange
```

---

# IV - Installation LAMP

Mettre à jour Debian :

```bash
sudo apt update && sudo apt upgrade -y
```

Installation :

```bash
sudo apt install apache2 mariadb-server php libapache2-mod-php php-mysql php-curl php-xml php-gd php-imap php-intl php-zip php-mbstring unzip wget -y
```

---

## Sécurisation MariaDB

```bash
sudo mysql_secure_installation
```

---

# V - Installation GLPI

## Création de la base

Connexion MariaDB :

```bash
sudo mysql
```

Créer :

```sql
CREATE DATABASE glpi;

CREATE USER 'glpi'@'localhost'
IDENTIFIED BY 'Glpi123!';

GRANT ALL PRIVILEGES
ON glpi.*
TO 'glpi'@'localhost';

FLUSH PRIVILEGES;

EXIT;
```

---

## Téléchargement

```bash
wget https://github.com/glpi-project/glpi/releases/download/10.0.18/glpi-10.0.18.tgz
```

Extraction :

```bash
tar -xzf glpi-10.0.18.tgz
```

Déplacement :

```bash
sudo mv glpi /var/www/html/
```

Permissions :

```bash
sudo chown -R www-data:www-data /var/www/html/glpi
```

Redémarrage :

```bash
sudo systemctl restart apache2
```

---

## Installation web

Accès :

```text
http://192.168.174.134/glpi
```

Suivre l'assistant.

---

# VI - Agent GLPI sur Debian

Téléchargement :

```bash
wget https://github.com/glpi-project/glpi-agent/releases/latest/download/glpi-agent-1.15-linux-installer.pl
```

Installation :

```bash
sudo perl glpi-agent-1.15-linux-installer.pl
```

Configuration :

```bash
sudo nano /etc/glpi-agent/agent.cfg
```

Ajouter :

```text
server = http://192.168.174.134/glpi/front/inventory.php
```

Inventaire :

```bash
sudo glpi-agent
```

---

# VII - Agent GLPI sur DC-EXCHANGE

Installer :

```text
GLPI-Agent Windows
```

Serveur :

```text
http://192.168.174.134/glpi/front/inventory.php
```

Test :

```powershell
"C:\Program Files\GLPI-Agent\glpi-agent.exe" --force
```

---

# VIII - Agent GLPI sur EXCHANGE

Même procédure que pour DC-EXCHANGE.

---

# IX - Vérification des remontées

Dans GLPI :

```text
Inventaire
→ Ordinateurs
```

Les machines doivent apparaître :

```text
DC-EXCHANGE
EXCHANGE
GLPI
```

---

# X - Liaison LDAP Active Directory

GLPI :

```text
Configuration
→ Authentification
→ Annuaires LDAP
```

Créer :

```text
Nom : AD-TSSR
Serveur : 192.168.174.250
Port : 389
BaseDN : DC=tssrprenom,DC=local
```

Compte :

```text
CN=Administrator,CN=Users,DC=tssrprenom,DC=local
```

Tester puis sauvegarder.

---

# XI - Collecteur de mails Exchange

GLPI :

```text
Configuration
→ Collecteurs
```

Créer :

```text
Nom : Exchange
```

Paramètres :

```text
Serveur : 192.168.174.251
Protocole : IMAP
Port : 993
SSL : Oui
Utilisateur : support@tssrprenom.local
```

Tester puis sauvegarder.

---

# XII - Notifications GLPI par Exchange

GLPI :

```text
Configuration
→ Notifications
→ Configuration
```

SMTP :

```text
Mode : SMTP
Serveur : 192.168.174.251
Port : 25
Expéditeur : glpi@tssrprenom.local
```

Tester l'envoi.

---

# Résultat attendu

✅ Domaine Active Directory opérationnel

✅ DNS fonctionnel

✅ Exchange intégré à l'Active Directory

✅ Serveur Debian 13 fonctionnel

✅ GLPI accessible en Web

✅ LDAP Active Directory opérationnel

✅ Inventaire automatique des 3 serveurs

✅ Collecteur de mails Exchange opérationnel

✅ Notifications par mail fonctionnelles

✅ Communication réseau complète entre les 3 serveurs

---

# Schéma final

```text
                    +---------------------+
                    |    DC-EXCHANGE      |
                    | 192.168.174.250     |
                    | AD DS + DNS         |
                    +----------+----------+
                               |
                               |
                               |
            +------------------+------------------+
            |                                     |
            |                                     |
+-----------+-----------+           +-------------+-----------+
|      EXCHANGE         |           |        GLPI            |
| 192.168.174.251       |           | 192.168.174.134        |
| Messagerie            |           | Inventaire             |
| IMAP / SMTP           |           | LDAP / Collecteur      |
+-----------------------+           +------------------------+
```
