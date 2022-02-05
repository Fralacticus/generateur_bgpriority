# Modifications du projet **gb-studio**
Dans le projet : [https://github.com/chrismaltby/gb-studio](https://github.com/chrismaltby/gb-studio)

Chemin du fichier modifié : **gb-studio\src\lib\compiler\compileData.js**


Insertion au début du fichier :
```javascript
import fs from 'fs';
```
Insertion plus loin dans le fichier...
```js
if (fs.existsSync(`${projectRoot}/assets/bgpriority/${background.name}_priority.json`)) {
	const listeJson = fs.readFileSync(`${projectRoot}/assets/bgpriority/${background.name}_priority.json`,'UTF-8');
	const liste = JSON.parse(listeJson);
	for(let i = 0; i <liste.length ; i++){
		if(liste[i] == true){
			background.tileColors[i] = background.tileColors[i] + 128;
		}
	}
}		
```
... qui se situe juste avant le code existant :
```javascript
// Determine tilemap attrs
const tilemapAttrData = padArrayEnd(
	background.tileColors || [],
	tilemapData.length,
	0
);
```

![launch_site with priority in red](https://github.com/Fralacticus/generateur_bgpriority/blob/main/captures/launch_site_avec_priorite.png)

Utiliser la couleur suivante pour coloriser un bloc de pixels de 8x8 :    ![#C9002E](https://via.placeholder.com/15/C9002E/000000?text=+) `#C9002E`

Ajouter le dossier **bgpriority** dans le dossier assets (gb-studio fonctionne de manière traditionnelle si le dossier n'existe pas) :
```
📂projet
 ┣ 📂assets
   ┣ 📂avatars
   ┣ 📂backgrounds
   ┣ 📂bgpriority
   ┣ 📂emotes
   ┣ 📂fonts
   ┣ 📂music
   ┣ 📂sprites
   ┗ 📂ui
 ┣ 📂build
   ┗ [...]
```

Pour chaque fichier .png du dossier backgrounds pour lequel on veut gérer la priorité par tuile :
- Dans le dossier bgpriority, copier le fichier .png original (où créer un fichier .png de même longueur et largeur)
- Le nommer en suffixant le nom original par "_priority" (exemple : pour launch_site.png > launch_site_priority.png)

Le but est de pouvoir ajouter la propriété "Priorité d'une tuile sur les objets" (background per tile priority) aux tuiles. Quand elle est activée, un objet siruté sur une tuile priorisée est affiché au dessus de la couleur 0 et en dessous des couleurs 1,2 et 3 de la palette de cette tuile.
Cela se concrétise par fixer à 1 le bit n°7 de l'attribut d'une tuile, comme l'indique la documentation :
[https://gbdev.gg8.se/wiki/articles/Video_Display#VRAM_Sprite_Attribute_Table_.28OAM.29](https://gbdev.gg8.se/wiki/articles/Video_Display#VRAM_Sprite_Attribute_Table_.28OAM.29)
```
 Bit 0-2  Background Palette number  (BGP0-7)
 Bit 3    Tile VRAM Bank number      (0=Bank 0, 1=Bank 1)
 Bit 4    Not used
 Bit 5    Horizontal Flip            (0=Normal, 1=Mirror horizontally)
 Bit 6    Vertical Flip              (0=Normal, 1=Mirror vertically)
 Bit 7    BG-to-OAM Priority         (0=Use OAM priority bit, 1=BG Priority)
 ```
 
 ![harry potter behind wall](https://github.com/Fralacticus/generateur_bgpriority/blob/main/captures/harry_potter_move.gif)
