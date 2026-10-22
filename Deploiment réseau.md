RIS Remote Installation Services 
WDS + MDT WDS : Tuyau (Porte conteneur) + Cerveau (automatisation, pilotes, logiciels)
Fin du MDT : MS à stoppé MDT  

### *WDS pour déployer uniquement du Windows !*

### PXE : Preboot eXectution Environnement
Standard permetant à une station de démarer depuis le reseau, même sans ISO
1 - Client > demande requete DHCP
2 - DHCP > reponse avec IP et option PXE
3 - Client > Contact WDS et DL programme

1 - DORA :  
Discover - demande adresse IP
Offer - Envoie de l'adresse   
Request - demande MaJ
Acknowlegde - MaJ terminée

2 - tranfert TFTP  
3 - Exeution NBP  
4 - chargement image de démarrage (WinPE)  

Besoin WDS  
  
ADDS  
DNS  
DHCP  
Stockage  

Fichier à avoir  
  - Boot.win : image de démarage  
  - Install.win : Image d'installation

