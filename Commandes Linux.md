# Commandes Debian / GLPI

## Réseau

```bash
hostname -I
```

```bash
ip a
```

```bash
ip route
```

---

## SSH

```bash
ssh utilisateur@IP
```

Exemple :

```bash
ssh root@192.168.0.181
```

---

## Recherche du cron GLPI

```bash
find /var/www -name cron.php
```

---

## Test du cron GLPI

```bash
php /var/www/html/glpi/front/cron.php
```

```bash
su -s /bin/bash www-data -c "php /var/www/html/glpi/front/cron.php"
```

```bash
su -s /bin/bash www-data -c "php /var/www/html/glpi/front/cron.php --force"
```

---

## Gestion du cron

```bash
crontab -e
```

```bash
crontab -l
```

---

## Cron GLPI

```bash
*/5** * * * su -s /bin/bash www-data -* "*hp /var/www/html/glpi/front/cron.p*p" >/dev/null 2>&1
```

---

## Se*vice cron

```bash
systemctl statu* cron
```

```bash
systemctl start*cron
```

```bash
systemctl restar* cron
```

```bash
systemctl enabl* cron
```

---

## Surveillance du*cron

```bash
journalctl -u cron -*
```

---

## Services

```bash
sy*temctl status apache2
```

```bash*systemctl restart apache2
```

```*ash
systemctl status mariadb
```

*``bash
systemctl*restart mariadb
```

---

## Resso*rces système

```bash
df -h
```

`*`bash
free -*
```

```bash
journalctl -xe
```

*--

## Arrêt / Redémarrage

```bas*
poweroff
``*

```bash
shutdown -h now
```

```*ash
reboot
```
