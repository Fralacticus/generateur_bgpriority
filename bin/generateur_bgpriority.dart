import 'package:image/image.dart';
import "dart:io";
import 'dart:convert';

int main(List<String> arguments) {

  int couleurPrio = 4281204937; //#C9002E

  String chemin_assets = arguments[0];
  String nomDossier_bgpriority = r"bgpriority";

  // Vérification si le dossier existe
  Directory dossier_bgpriority = Directory(chemin_assets + r"\" + nomDossier_bgpriority);
  if(dossier_bgpriority.existsSync() == false){
    throw "Le dossier n'existe pas : ${dossier_bgpriority.path}";
  }

  // Vidage du dossier des fichiers json
  List<FileSystemEntity> listeFichiers_bgpriority  = dossier_bgpriority.listSync().where((element) => FileSystemEntity.isFileSync(element.path) && element.path.split('.').last == "json").toList();
  listeFichiers_bgpriority.forEach((fichiers) {
    fichiers.deleteSync(recursive: true);
  });

  // Lecture fichiers png
  List<FileSystemEntity>  listeFichiers_png  = dossier_bgpriority.listSync().where((element) => FileSystemEntity.isFileSync(element.path) && element.path.split('.').last == "png").toList();

  // Traitement de chaque fichier png
  listeFichiers_png.forEach((fichier) {
    Image pngOrigi = decodePng( File(fichier.path).readAsBytesSync())!;
    if(!estConforme(pngOrigi)){
      throw "L'image nest pas conforme : ${fichier.path}";
    }
    List<List<int>> imgDecoupe = decouperImage(pngOrigi);
    List<bool>listePriorite =  genererPriorite(imgDecoupe, couleurPrio);
    String jsonPriorite = genererJson(listePriorite);
    File(dossier_bgpriority.path + r"\" + fichier.path.split(r'\').last.split(r'.').first + ".json").writeAsStringSync(jsonPriorite);
  });

  return 0;
}

bool estConforme(Image image){
  if (image.width %8 != 0 || image.length % 8 != 0){
    return false;
  }
  return true;
}

String genererJson(List<bool> liste){
  JsonEncoder encoder = JsonEncoder.withIndent('  ');
  String listeJson = encoder.convert(liste);
  return listeJson;
}

List<List<int>> decouperImage(Image inputImage) {
  Image image = inputImage ;
  List<List<int>> pieceList = [];
  for (int y = 0; y < image.height-7; y +=8){
    for (int x = 0 ; x < image.width-7; x+=8){
      List<int> couleurs = [];
      int finy = y+8;
      int finx= x+8;
      for (int i = y; i < finy; i++){
        for(int j = x; j <finx; j++){
          couleurs.add(image.getPixel(j, i));
        }
      }
      pieceList.add(couleurs);
    }
  }
  return pieceList;
}

List<bool> genererPriorite(List<List<int>> listeCouleurs, int couleurCherche){
  List<bool> listePriorite = [];
  for(List<int> couleurs in listeCouleurs){
    List<int> inventaire = couleurs.toSet().toList();
    if(inventaire.length == 1 && inventaire.first == couleurCherche){
      listePriorite.add(true);
    }
    else{
      listePriorite.add(false);
    }
  }
  return listePriorite;
}