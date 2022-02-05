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
