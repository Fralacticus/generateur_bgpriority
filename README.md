# Fichier modifié
Dans le projet : [https://github.com/chrismaltby/gb-studio](https://github.com/chrismaltby/gb-studio)
Chemin du fichier modifié : **gb-studio\src\lib\compiler\compileData.js**


Insertion au début du fichier :
```dart
import fs from 'fs';
```
Insertion plus loin dans le fichier...
```dart
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
```js
// Determine tilemap attrs
const tilemapAttrData = padArrayEnd(
	background.tileColors || [],
	tilemapData.length,
	0
);
```
