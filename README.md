# b2broot
## Born to be root project
This project helps you to setup a VM.

## VirtualBox
VirtualBox(VM) est un ordi virtuel, capable d'heberger un systheme d'exploitation.
La VM utilise :
* La vitesse de calcule(CPU).<br/>
* La memoir vive(RAM).<br/>
* L'espace de stockage(disc dur).<br/>

L'avantage d'avoir une VM est :
* Avoir plusieurs systeme d'exploitation sur un ordinateur phisique.<br/>
* Fourni un environement pour tester des progammes infectes.<br/>
La VM prend les ressourses directement sur l'ordinateur hote a l'aide de logical volume manager(LVM).

### Logical Volume Manager(LVM)
LVM permet de faire un partitionnement des disque pour allouer des ressours suffisante pour faire fonctionner la VM.
L'avantage de LVM est de pouvoir redimensionner les partission de disque sans reformater la partition de la VM.

### AppArmor
AppArmor est un logiciel de securite .
Il permet a l'administrateur systeme (root?) d'associer, a chaque programme testé dans la VM, 
un profil limitant l'accee (l'accée a l'appareil photo par exemple).
Il peu aussi restreindre les capacites du programme testé, pour limiter l'impacte d'un progamme malveillant sur la VM.

### Apt et Aptitude
dpkg(debian package) est un outil qui permet d'intaller des progammes.
dpkg ne gere pas les dépendances, pour cela on a la commande apt(advanced Package Tool), qui instale les dépendance manquantes, indispensable pour que le programme fonctionne.
Aptitude, c'est la meme chose mais avec une interface graphique en plus.

### SSH
SSH(Secure SHell) est un protocole d'administration a distance qui permet aux utilisateurs de controler
et de modifier leurs serveurs sur internet grace a un mecanisme d'authentification crypté.
SSH utilise les modes de chiffrements :
* Chiffrement symetrique, methode qui utilise la meme cle secrete pour le dechiffrement.<br/>
* Chiffrement asymetrique, methode qui utilise deux cles de chiffrement. La cle publique, et la cle privee.<br/>

### SSH
UFW(Uncomplicated Firewall) et un logiciel qui permet d'ouvir et fermer les ports que nous voulons autoriser.

### SUDO(SwitchUser DO)
Permet à un utilisateur normal d'exécuter des commandes avec les privilèges de superutilisateur.

### libram-pwquality

#### Instalation de debien
* Allez dans setting -> storage -> empty -> opticale device -> choose a disk file -> debian<br/>
* Cliquer sur la fleche show pour lancer la VM<br/>
* Cliquer sur installer<br/>
* Langue/region/clavier -> etats-unis<br/>
* Nom de machine -> nibernar42<br/>
* Domaine -> vide<br/>
* Mdp superutilisateur(root) -> *85g/<br/>
* Nom d'utilisateur -> niberbar<br/>
* Login de l'utilisateur -> nibernar<br/>
* Mdp de l'utilisateur -> lolo*999<br/>

#### Partitionner les disques
* Choisir la méthode de partitionnement -> assisté -utiliser tout un disque ave LVM chiffré<br/>
* Choisir partition/ home séparée<br/>
* Ecrire les modifications sur les disaues et configurer LVM -> oui<br/>
* Phrase secrete de chiffrement -> nibernarnibernar<br/>
* Quantité d'espace sur le groupw de volume 8Gb<br/>
* Terminer le partitionnement et appliquer les changement -> oui<br/>

#### Configuration de l'outil de gestion des paquets (APT)
* Miroir de l'archive debian -> deb.debian.ogr<br/>
* Mandataire HTTP -> vide<br/>
* Etude statistique -> non<br/>
* Selection des logiciels par defaut<br/>
* Instalation de GRand Unification Bootloader (GRUB) -> oui<br/>
* Phéripherique d'intalation de GRUB -> /dev/sda(...)<br/>

une fois debian lancé :
* Entrer la phrase secrete de chiffrement -> *******<br/>
* Entrer le login -> ******<br/>

#### Configuration de la VM
Passer en mode Super User -> (su) puis rentrer le mdp root.
Intalation des packages :
* apt update (met a jour la liste des paquets)<br/>
* apt upggrade (met a jour les paquetes si necessaire)<br/>
* apt install sudo<br/>
* apt install ssh<br/>
* apt install ufw<br/>
* apt install vim<br/>
* apt install libpam-pwquality<br/>

* Activer le port forwarding dans setting -> network -> advanced<br/>
* Retourner dans le terminal et taper la commande : hostname -I (10.0.2.15) pour recuperer<br/>
* L'adresse IP de notre VM<br/>
* Taper la commande : ifconfig | grep 'inet' pour retrouver l'ip de l'ordi (127.0.0.1)<br/>
* Retourner dans setting -> network -> advanced -> port forwarding et entrer les donnees suivantes (tableau).<br/>

#### Configuration de SSH
* Dans le terminal, editer le fichier de config /etc/ssh/sshd_config -> vim/etc/ssh/sshd_config<br/>
	- ligne 14 : "#port 22" -> "port 4242"<br/>
	- ligne 32 : "#permitRootLogin prohibit-password" -> "PermitRpptLogin no"<br/>
* Dans le terminal, editer le fichier de config /etc/ssh/ssh_config -> vim/etc/ssh/ssh_config<br/>
	- ligne 38 : "#port22" -> "port 4242"<br/>
* Reboot ssh avec la commande -> /etc/init.d/ssh reload<br/>
* Commande de ssh :
    - virifier l'etat de ssh -> systemctl status sshd<br/>
    - Se conntecter a la vm depuis notre machine hote -> ssh <login>@<ip de l'ordi> -p 4242<br/>
    - Stopper une VM -> sudo shutdown now<br/>
    - Pour trouver l'ip de l'ordi -> ifconfig | grep 'inet'<br/>

#### Editer le fichier sudo
* Passer en mode su.<br/>
* Taper la commande sudo visudo (l'editeur nano s'ouvre)<br/>

Rajouter les lignes suivantes :	
* Defaults	badpass_message="Wrong password" (envoyer un message d'erreur quand on rentre un mauvais mdp).<br/>
* Defaults	requirettty (interdit l'execution de la commande sudo à partir d'autre chose qu'une console ou d'un terminal. ex : un scripte 	shell)<br/>
* Defaults	passwd_tries=3 (limite le nombre de chance pour entrer un mauvais mdp)<br/>
* Defaults	log_input, log_output (permet d'avoir une trace des utilisations sudo dans le fichier sudo.log)<br/>
* Defaults	iolog_dir="/var/log/sudo" (presise l'emplacement ou envoyer les traces des utilistations sudo)<br/>
* Defaults	logfile="/var/log/sudo/sudo.log" (creer le fichier de log)<br/>

#### La variable d'environement PATH
La viariable PATH est utiliser pour localiser les commandes dans l'arborescence des repertoires.
Par exemple, si on a pas defini la variable PATH et qu'on souhaite copier un fichier avec la commande 'cp', on doit taper le chemin d'accée de la commande cp (usr/bin/cp).

Une fois le fichier sudo executé, revenir en arriere et aller a la racine de l'arboressance -> /
entrer n'importe quel commande avec sudo (sudo ls) le fichier sudo.log va etre créer.
pour voir le ficher sudo.log -> /var/log/sudo  -> cat sudo.log

#### Créer un groupe d'utilisateur.
* Commande -> sudo groupadd <nom_du_group> (sudo groupadd user42)	crée un groupe d'utilisateur<br/>
* Commande -> sudo adduser <login> <nom_du_groupe> (sudo adduser nibernar user42)	ajoute l'utilisateur nibernar au groupe user42<br/>
* Commande -> sudo adduser <login> sudo (sudo adduser nibernar sudo)		ajoute l'utilisateur au groupe sudo<br/>
* Commande -> groups   pour voir les groupes d'utilisateurs.<br/>

#### Activer et ajouter des regles a UfW
* Commande -> sudo ufw enable				active le firewall ufw.<br/>
* Commande -> sudo ufw allow 4242			ouvrir le port 4242.<br/>
* Commande -> sudo systemctl enable ufw		permet le lancement de ufw au demarage.<br/>

#### Changer la politique de mots de passe fort
* Aller dans l'arborescence -> /<br/>
* Passer en mode root.<br/>
* Editer le fichier common-password <br/>
    - /etc -> vim login.defs a la ligne 160
	- PASS_MAX_DAYS 9999 -> PASS_MAX_DAYS 30		mots de passe expire tous les 30 jours
	- PASS_MIN_DAYS 0 -> PASS_MIN_DAYS 2			nombre mini de jours avant de pouvoir modifier un nouveau mots de passe
	- PASS_WARN_AGE 7 -> (pas de changement)		envoie un avertissement 7 jours avant que le mdp expire.
* Editer le fichier common-password -> /etc/pam.d -> vim common-password a la ligne 25.<br/>
	- passwords	requisite	pam_pwquality.so	-> retry=3			3 tentatives pour trouver le mdp
    - minlen=10		mdp de 10 char mini.
    - ucredit=-1		une maj mini.
    - dcredit=-1		un chiffre mini.
    - maxrepeat=3		pas plus de 3 char consecutifs identique
    - difok=7			minimum de 7 variations entre l'ancien et le nouveau mdp.
    - reject_username	interdiction de mettre le username dans le mdp.
    - enforce_for_root	regle s'applique aussi a root.
une fois les regles du nouveau mdp etablie, changer les mdp avec la commande -> passwd <user>

### Script bash (Monitoring.sh)
Dès le lancement de notre serveur, un scripte ecrira des informations toutes les 10 minutes sur tous les terminaux.

### Recuperer la siniature de la vm
shasum /sgoinfre/Perso/nibernar/born2beroot/born2beroot.vdi