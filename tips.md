# Mémo : L'Encapsulation des Données dans le Modèle OSI

L'**encapsulation** est le mécanisme par lequel les données descendent les couches du modèle OSI (de l'application vers le câble physique). À chaque étape, chaque couche ajoute ses propres informations de contrôle sous forme d'une **en-tête (Header)** et parfois d'un **pied de page (Trailer)**, enveloppant la donnée de la couche précédente comme des poupées russes.

Lors de la réception, le processus inverse s'appelle la **désencapsulation** (ou décapsulation).

## Le voyage d'une donnée (Descente)

| Étape / Couche | Nom de l'unité de donnée (PDU) | Action d'encapsulation | Exemple concret |
| :--- | :--- | :--- | :--- |
| **7. Application**<br>**6. Présentation**<br>**5. Session** | **Données** (Data) | La donnée brute est générée par le logiciel, formatée et préparée. | Un message de chat ou une requête HTTP. |
| **4. Transport** | **Segment** (TCP) ou **Datagramme** (UDP) | Ajout d'une en-tête de transport contenant les **ports source et destination** (ex: port 443 pour le HTTPS) pour identifier l'application. | Découpage des grosses données en morceaux. |
| **3. Réseau** | **Paquet** (Packet) Routeurs | Ajout d'une en-tête réseau contenant les **adresses IP source et destination** pour permettre le routage sur Internet. | Le segment devient un paquet IP. |
| **2. Liaison de donnée** | **Trame** (Frame) Switch| Ajout d'une en-tête avec les **adresses MAC source et destination** (matériel local) + un pied de page (FCS) pour vérifier les erreurs. | Le paquet devient une trame Ethernet ou Wi-Fi. |
| **1. Physique** | **Bits** Cables | La trame est convertie en une suite de **0 et de 1** (impulsions électriques, lumineuses ou ondes radio). | Envoi des signaux sur le câble ou dans l'air. |

## L'analogie de la lettre postale
Pour mieux comprendre, imagine que tu écris une lettre :
1. **Donnée :** Tu rédiges le texte de ta lettre.
2. **Transport :** Tu ajoutes une mention pour savoir à quel service de l'entreprise elle s'adresse (ex: "Ressources Humaines").
3. **Réseau :** Tu glisses le tout dans une enveloppe avec l'adresse postale complète (ton adresse et celle du destinataire).
4. **Liaison :** La poste locale met ta lettre dans un sac postal spécifique pour le prochain centre de tri.

### IEEE  
802.3 (Ethernet, RG45, 8P8C)  
802.11 (WiFi)

# Modèle OSI - Moyen mnémotechnique

Le moyen mnémotechnique **« Pour Le Réseau, Tout Se Passe Automatiquement »** permet de retenir dans l'ordre les **7 couches du modèle OSI** (de bas en haut, de la couche 1 à la couche 7).

## Correspondance des 7 couches (de bas en haut)

| Lettre | Couche | Rôle principal |
|----------|----------|----------|
| **P** | **Couche 1 : Physique** | Câbles, signaux électriques ou optiques, transmission des bits |
| **L** | **Couche 2 : Liaison de données** | Adresses MAC, trames, commutateurs (switchs) |
| **R** | **Couche 3 : Réseau** | Adressage IP, routage, paquets |
| **T** | **Couche 4 : Transport** | TCP, UDP, segments, gestion des erreurs |
| **S** | **Couche 5 : Session** | Ouverture, maintien et fermeture des sessions de communication |
| **P** | **Couche 6 : Présentation** | Chiffrement, encodage, compression et formatage des données |
| **A** | **Couche 7 : Application** | Interface avec les logiciels utilisateurs (HTTP, DNS, FTP, SMTP, etc.) |

## Phrase mnémotechnique

```text
Pour Le Réseau, Tout Se Passe Automatiquement
```

Correspondance :

```text
P → Physique
L → Liaison de données
R → Réseau
T → Transport
S → Session
P → Présentation
A → Application
```

---

## Variante humoristique (de haut en bas)

⚠️ À retenir uniquement comme moyen mnémotechnique informel.

```text
A - Ah,
P - Petite
S - Salope,
T - Tu
R - Recraches
L - La
P - Purée
```

Correspondance :

```text
Application
Présentation
Session
Transport
Réseau
Liaison de données
Physique
```

---

## Astuce TSSR

Pour l'examen ou les exercices réseau, il est généralement recommandé d'utiliser :

```text
Pour Le Réseau, Tout Se Passe Automatiquement
```

Cette version est professionnelle et permet de réciter les couches OSI du niveau physique jusqu'à l'application.


