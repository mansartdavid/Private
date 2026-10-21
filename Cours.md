# 📚 TSSR - Base de Connaissances

## 🏠 Accueil

```text
TSSR-Knowledge-Base/
│
├── README.md
├── ROADMAP.md
├── REAC_TSSR.md
├── Journal_De_Bord.md
│
├── 00_Introduction/
│
├── 01_Materiel/
│
├── 02_Windows_Client/
│
├── 03_Windows_Server/
│
├── 04_Linux/
│
├── 05_Reseau/
│
├── 06_Active_Directory/
│
├── # 🖥️ Chapitre 07 - Virtualisation VMware

> La virtualisation permet d'exécuter plusieurs systèmes d'exploitation sur une même machine physique.
>
> C'est une compétence essentielle pour un Technicien Supérieur Systèmes et Réseaux (TSSR), car elle permet de créer des laboratoires, tester des configurations et simuler des infrastructures professionnelles.

---

# 🎯 Objectifs du chapitre

À la fin de ce chapitre, tu devras être capable de :

- Comprendre le principe de la virtualisation
- Installer VMware Workstation
- Créer une machine virtuelle
- Configurer les réseaux VMware
- Utiliser les snapshots
- Construire un laboratoire TSSR complet
- Dépanner les problèmes courants

---

# 📚 1. Qu'est-ce que la virtualisation ?

La virtualisation consiste à créer des ordinateurs virtuels à l'intérieur d'un ordinateur physique.

Un seul PC peut ainsi héberger :

- Windows 11
- Windows Server
- Debian
- Ubuntu
- Kali Linux

en même temps.

---

## Exemple

```text
PC Physique
│
├── VMware Workstation
│
├── Windows Server
├── Windows 11
├── Debian 13
└── Kali Linux
```

---

# 📚 2. Hyperviseur

Un hyperviseur est un logiciel permettant de créer et gérer des machines virtuelles.

## Exemples

- VMware Workstation
- VirtualBox
- Hyper-V
- VMware ESXi
- Proxmox

---

# 📚 3. Pourquoi utiliser VMware ?

## Avantages

✅ Tester sans risque

✅ Faire des sauvegardes rapides

✅ Créer des laboratoires

✅ Simuler une entreprise

✅ Apprendre Active Directory

✅ Réaliser des TP réseau

✅ Installer plusieurs systèmes

---

## Inconvénients

❌ Consomme beaucoup de RAM

❌ Consomme du stockage

❌ Utilise le processeur

---

# 📚 4. Machine Virtuelle (VM)

Une machine virtuelle est un ordinateur simulé.

Elle possède :

- Processeur virtuel
- Mémoire virtuelle
- Disque virtuel
- Carte réseau virtuelle

---

## Exemple

```text
VM : DC01

CPU : 2 vCPU
RAM : 4 Go
Disque : 60 Go
OS : Windows Server
```

---

# 📚 5. Ressources d'une VM

## CPU

Nombre de cœurs attribués.

Exemple :

```text
1 cœur
2 cœurs
4 cœurs
```

---

## RAM

Mémoire disponible pour la VM.

Exemple :

```text
2 Go
4 Go
8 Go
```

---

## Stockage

Espace disque de la machine virtuelle.

Exemple :

```text
40 Go
60 Go
100 Go
```

---

# 📚 6. Réseaux VMware

La partie réseau est l'une des plus importantes pour le TSSR.

---

## Bridged

La VM apparaît directement sur le réseau local.

```text
BOX
│
├── PC
├── Téléphone
└── VM
```

La VM reçoit une adresse IP du réseau.

Exemple :

```text
192.168.1.50
```

---

## NAT

La VM utilise la connexion Internet du PC.

```text
BOX
   │
PC Hôte
   │
 VM
```

La VM peut sortir sur Internet.

Elle est souvent isolée du réseau local.

---

## Host-Only

Communication uniquement entre :

- le PC hôte
- les machines virtuelles

Pas d'accès Internet.

```text
PC
 │
 ├── VM1
 ├── VM2
 └── VM3
```

---

# 📚 7. Snapshots

Un snapshot est une photographie de la VM à un instant donné.

---

## Exemple

```text
Windows Server propre
      │
 Snapshot
      │
Installation AD
      │
Erreur
      │
Retour Snapshot
```

---

## Avantages

- Gain de temps
- Retour arrière rapide
- Sécurité

---

# 📚 8. VMware Tools

VMware Tools améliore :

- Les performances
- La souris
- La vidéo
- Le copier/coller
- Le partage de fichiers

---

## Installation

Dans VMware :

```text
VM
└── Install VMware Tools
```

---

# 📚 9. Laboratoire TSSR conseillé

## Infrastructure

```text
VMnet1 (Host-Only)

├── DC01
│   ├── AD
│   ├── DNS
│   └── DHCP
│
├── SRV01
│
├── WIN11-01
│
└── DEBIAN01
```

---

## Objectifs

Apprendre :

- Active Directory
- DNS
- DHCP
- Linux
- Réseau
- Scripts

---

# 📚 10. Bonnes pratiques

## Nommer les VM

Utiliser une convention.

Exemple :

```text
DC01
SRV01
WIN11-01
DEBIAN01
CLIENT01
```

---

## Organiser les snapshots

Exemple :

```text
Installation
Configuration réseau
DHCP
AD
GPO
```

---

## Sauvegarder les VM

Stocker les VM sur :

- SSD secondaire
- NAS
- Disque externe

---

# 📚 11. Problèmes fréquents

## Pas d'Internet

Vérifier :

```text
NAT
Passerelle
DNS
```

---

## Pas de communication entre VM

Vérifier :

```text
Adresse IP
Masque
Pare-feu
VMnet
```

---

## VM lente

Vérifier :

```text
RAM suffisante
SSD
Nombre de VM ouvertes
```

---

# 📚 12. Commandes utiles

## Windows

Afficher la configuration réseau :

```powershell
ipconfig /all
```

Tester la connexion :

```powershell
ping 8.8.8.8
```

Résoudre les noms DNS :

```powershell
nslookup google.fr
```

---

## Linux

Afficher les interfaces :

```bash
ip addr
```

Tester une connexion :

```bash
ping 8.8.8.8
```

Afficher les routes :

```bash
ip route
```

---

# 📝 Résumé

## À retenir

✅ VMware permet de créer des ordinateurs virtuels.

✅ Une VM possède son propre système d'exploitation.

✅ Les modes réseau principaux sont :

- Bridged
- NAT
- Host-Only

✅ Les snapshots permettent un retour arrière rapide.

✅ VMware est l'outil principal pour construire un laboratoire TSSR.

✅ Un bon labo VMware permet de pratiquer :

- Windows Server
- Active Directory
- Réseau
- Linux
- Docker
- Cybersécurité

---

# 🎓 Questions de révision

1. Qu'est-ce qu'une machine virtuelle ?
2. Quelle différence entre NAT et Bridged ?
3. À quoi sert un snapshot ?
4. Qu'est-ce qu'un hyperviseur ?
5. Pourquoi installer VMware Tools ?
6. Quel mode réseau utiliser pour un laboratoire isolé ?
7. Quel mode réseau permet à une VM d'obtenir une IP du réseau local ?
8. Pourquoi la virtualisation est-elle importante pour un TSSR ?
│
├── 08_Stockage/
│
├── 09_Sauvegarde/
│
├── 10_Scripting/
│
├── 11_Supervision/
│
├── 12_Cybersecurite/
│
├── 13_Docker_Conteneurs/
│
├── 14_Cloud/
│
├── 15_IA/
│
├── 16_Examens/
│
├── Glossaires/
│
├── Cheatsheets/
│
├── Labs/
│
└── Templates/
```

---

# 📖 00 - Introduction

```text
00_Introduction/
├── Metier_TSSR.md
├── Organisation_Formation.md
├── Methodologie_De_Travail.md
├── Cycle_De_Vie_Dun_Incident.md
└── Documentation_Technique.md
```

---

# 🖥️ 01 - Matériel

```text
01_Materiel/
├── Architecture_Ordinateur.md
├── CPU.md
├── GPU.md
├── RAM.md
├── Carte_Mere.md
├── BIOS_UEFI.md
├── Stockage_SSD_HDD.md
├── Alimentations.md
├── Evolution_Des_FLOPS.md
└── Depannage_Materiel.md
```

---

# 💻 02 - Windows Client

```text
02_Windows_Client/
├── Installation_Windows_11.md
├── Comptes_Utilisateurs.md
├── Gestion_Des_Pilotes.md
├── Gestion_Des_Disques.md
├── Services_Windows.md
├── Registre_Windows.md
├── Commandes_CPL.md
├── Commandes_MSC.md
├── Outils_Administrateur.md
├── Maintenance.md
└── Depannage.md
```

---

# 🏢 03 - Windows Server

```text
03_Windows_Server/
├── Installation_Server.md
├── Gestion_Des_Roles.md
├── DHCP.md
├── DNS.md
├── Serveur_De_Fichiers.md
├── Impression.md
├── WSUS.md
└── Bonnes_Pratiques.md
```

---

# 🐧 04 - Linux

```text
04_Linux/
├── Installation_Debian.md
├── Systeme_De_Fichiers.md
├── Gestion_Des_Utilisateurs.md
├── Droits_Linux.md
├── Gestion_Des_Services.md
├── SSH.md
├── Journalctl.md
├── Apt.md
├── Commandes_Essentielles.md
└── Depannage_Linux.md
```

---

# 🌐 05 - Réseau

```text
05_Reseau/
├── Introduction_Reseaux.md
├── Modele_OSI.md
├── TCP_IP.md
├── IPv4.md
├── IPv6.md
├── DHCP.md
├── DNS.md
├── NAT.md
├── VLAN.md
├── VPN.md
├── Routage.md
├── Commutation.md
├── WiFi.md
├── Outils_Diagnostic.md
├── Packet_Tracer.md
└── Exercices.md
```

---

# 🏢 06 - Active Directory

```text
06_Active_Directory/
├── Installation_AD.md
├── Domaine.md
├── Controleur_De_Domaine.md
├── Utilisateurs.md
├── Groupes.md
├── OU.md
├── GPO.md
├── LDAP.md
├── DNS_AD.md
├── Bonnes_Pratiques.md
└── TP_Complets.md
```

---

# 🖥️ 07 - Virtualisation VMware

```text
07_Virtualisation_VMware/
├── VMware_Workstation.md
├── Machines_Virtuelles.md
├── Snapshots.md
├── Reseaux_VMware.md
├── NAT.md
├── Bridged.md
├── Host_Only.md
├── Laboratoire_TSSR.md
└── Procedures_VMware.md
```

---

# 💾 08 - Stockage

```text
08_Stockage/
├── HDD.md
├── SSD.md
├── NVMe.md
├── RAID.md
├── NAS.md
├── SAN.md
└── Bonnes_Pratiques.md
```

---

# 🔄 09 - Sauvegarde

```text
09_Sauvegarde/
├── Strategie_321.md
├── Sauvegardes_Locales.md
├── Sauvegardes_Cloud.md
├── Restaurations.md
└── PRA_PCA.md
```

---

# ⚙️ 10 - Scripting

```text
10_Scripting/
├── Introduction.md
│
├── PowerShell/
│   ├── Bases.md
│   ├── Variables.md
│   ├── Boucles.md
│   ├── Fonctions.md
│   └── Scripts_TSSR.md
│
└── Bash/
    ├── Bases.md
    ├── Variables.md
    ├── Boucles.md
    ├── Fonctions.md
    └── Scripts_Linux.md
```

---

# 📈 11 - Supervision

```text
11_Supervision/
├── Introduction.md
├── Centreon.md
├── Zabbix.md
├── Grafana.md
├── Logs.md
└── Alertes.md
```

---

# 🔐 12 - Cybersécurité

```text
12_Cybersecurite/
├── Sensibilisation.md
├── Authentification.md
├── MFA.md
├── PareFeu.md
├── Antivirus.md
├── EDR.md
├── Gestion_Des_Patchs.md
├── Vulnérabilités.md
├── Phishing.md
└── Bonnes_Pratiques.md
```

---

# 🐳 13 - Docker & Conteneurs

```text
13_Docker_Conteneurs/
├── Introduction_Docker.md
├── Installation.md
├── Images.md
├── Conteneurs.md
├── Volumes.md
├── Reseaux.md
├── Docker_Compose.md
├── Portainer.md
└── TP_Docker.md
```

---

# ☁️ 14 - Cloud

```text
14_Cloud/
├── Introduction.md
├── SaaS.md
├── PaaS.md
├── IaaS.md
├── Azure.md
├── AWS.md
├── Microsoft_365.md
└── Bonnes_Pratiques.md
```

---

# 🤖 15 - Intelligence Artificielle

```text
15_IA/
├── Introduction_IA.md
├── Glossaire_IA.md
├── LLM.md
├── RAG.md
├── Agents.md
├── Prompt_Engineering.md
├── Ollama.md
├── Llama.md
├── OpenWebUI.md
├── IA_Locale.md
├── Cybersecurite_Et_IA.md
├── IA_Pour_TSSR.md
└── Evolution_Des_FLOPS.md
```

---

# 🎓 16 - Examens

```text
16_Examens/
├── REAC_Resume.md
├── Questions_Frequentes.md
├── Mise_En_Situation.md
├── Grilles_De_Revision.md
├── Fiches_Memo.md
└── Journal_De_Progression.md
```

---

# 📚 Glossaires

```text
Glossaires/
├── Glossaire_IA.md
├── Glossaire_Reseau.md
├── Glossaire_Windows.md
├── Glossaire_Linux.md
├── Glossaire_Cyber.md
└── Glossaire_VMware.md
```

---

# ⚡ Cheatsheets

```text
Cheatsheets/
├── Linux.md
├── PowerShell.md
├── Docker.md
├── VMware.md
├── Reseau.md
├── ActiveDirectory.md
└── Cyber.md
```

---

# 🧪 Laboratoires

```text
Labs/
├── Lab_01_AD_DNS_DHCP.md
├── Lab_02_VMware.md
├── Lab_03_Docker.md
├── Lab_04_Linux.md
├── Lab_05_Reseau.md
├── Lab_06_Cyber.md
└── Lab_07_IA_Locale.md
```

---

# 📄 Templates

```text
Templates/
├── Template_Procedure.md
├── Template_Incident.md
├── Template_Lab.md
├── Template_Fiche_De_Revision.md
└── Template_Glossaire.md
```

---

## 🎯 Objectif

Construire une base de connaissances personnelle couvrant l'ensemble du programme TSSR :

- Windows
- Linux
- Réseau
- Active Directory
- VMware
- Docker
- Cybersécurité
- Cloud
- Intelligence Artificielle

afin de disposer d'un référentiel unique pour les cours, les TP, les révisions et la préparation à l'examen.
