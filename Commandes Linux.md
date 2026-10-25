# Debian / GLPI - Mémo rapide

## Réseau

```bash
hostname -I
```
➡️ Affiche l'adresse IP.

```bash
ip a
```
➡️ Affiche les interfaces réseau et IP.

```bash
ip route
```
➡️ Affiche la passerelle par défaut.

---

## SSH

```bash
ssh utilisateur@IP
```
➡️ Connexion distante sécurisée.

---

## GLPI

```bash
find /var/www -name cron.php
```
➡️ Recherche le fichier cron GLPI.

```bash
php /var/www/html/glpi/front/cron.php
```
➡️ Exécute le cron manuellement.

```bash
su -s /bin/bash www-data -c "php /var/www/html/glpi/front/cron.php"
```
➡️ Exécute le cron avec l'utilisateur web.

```bash
su -s /bin/bash www-data -c "php /var/www/html/glpi/front/cron.php --force"
```
➡️ Force l'exécution des tâches GLPI.

---

## Cron

```bash
crontab -e
```
➡️ Modifier les tâches planifiées.

```bash
crontab -l
```
➡️ Afficher les tâches planifiées.

```bash
*/5 * * * * su -s /bin/bash www-dat* -c "php /var/www/html/glpi/front/*ron.php" >/dev/null 2>&1
```
➡️ Ex*cute GLPI toutes les 5 minutes.

-*-

## Service Cron

```bash
system*tl status cron
```
➡️ Vérifier l'é*at du service.

```bash
systemctl *tart cron
```
➡️ Démarrer le servi*e.

```bash
systemctl restart cron*```
➡️ Redémarrer le service.

```*ash
systemctl enable cron
```
➡️ D*marrer automatiquement au boot.

`*`bash
journalctl -u cron -f
```
➡️*Voir les exécutions cron en direct*

---

## Apache

```bash
systemct* status apache2
```
➡️ Vérifier Ap*che.

```bash
systemctl restart ap*che2
```
➡️ Redémarrer Apache.

--*

## MariaDB

```bash
systemctl st*tus mariadb
```
➡️ Vérifier MariaD*.

```bash
systemctl restart maria*b
```
➡️ Redémarrer MariaDB.

---
*## Système

```bash
df -h
```
➡️ U*ilisation des disques.

```bash
fr*e -h
```
➡️ Utilisation de la RAM.*
```bash
journalctl -xe
```
➡️ Der*ières erreurs système.

---

## Ar*êt / Redémarrage

```bash
poweroff*```
➡️ Arrêter proprement Debian.
*```bash
shutdown -h now
```
➡️ Arr*t immédiat.

```bash
reboot
```
➡️*Redémarrer Debian.

---

## Piège *lassique 😄

```bash
crontab -l
``*
✅ Afficher les tâches cron

```ba*h
crontab -1
```
❌ Er*eur (1 ≠ l)
````*
