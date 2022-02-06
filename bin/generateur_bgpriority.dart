import 'package:image/image.dart';
import "dart:io";
import 'dart:convert';

int main(List<String> arguments) {
  print("Début du programme generateur_bgpriority\n");
  int couleurPrio = 4281204937; //#C9002E

  String chemin_assets = arguments[0];
  String nomDossier_bgpriority = r"bgpriority";

  // Vérification si le dossier existe
  stdout.write("1) Vérification existence dossier bgpriority ... ");
  Directory dossier_bgpriority = Directory(chemin_assets + r"\" + nomDossier_bgpriority);
  if(dossier_bgpriority.existsSync() == false){
    throw "Le dossier n'existe pas : ${dossier_bgpriority.path}";
  }
  stdout.writeln("OK");

  // Vidage du dossier des fichiers json
  stdout.writeln("2) Suppression des fichiers .json :");
  List<FileSystemEntity> listeFichiers_bgpriority  = dossier_bgpriority.listSync().where((element) => FileSystemEntity.isFileSync(element.path) && element.path.split('.').last == "json").toList();
  listeFichiers_bgpriority.forEach((fichiers) {
    stdout.write("Supression de ${fichiers.path} ... ");
    fichiers.deleteSync(recursive: true);
    stdout.writeln("Supprimé");
  });


  // Lecture fichiers png
  stdout.write("3) Inventaire des fichiers .png du dossier bgpriority ... ");
  List<FileSystemEntity>  listeFichiers_png  = dossier_bgpriority.listSync().where((element) => FileSystemEntity.isFileSync(element.path) && element.path.split('.').last == "png").toList();
  stdout.writeln("Fait");

  // Traitement de chaque fichier png
  stdout.writeln("4) Traitements et Génération des fichiers de priorité :");
  listeFichiers_png.forEach((fichier) {
    stdout.write("${fichier.path} ... ");
    Image pngOrigi = decodePng( File(fichier.path).readAsBytesSync())!;
    if(!estConforme(pngOrigi)){
      throw "L'image nest pas conforme : ${fichier.path}";
    }
    List<List<int>> imgDecoupe = decouperImage(pngOrigi);
    List<bool>listePriorite =  genererPriorite(imgDecoupe, couleurPrio);
    String jsonPriorite = genererJson(listePriorite);
    String cheminSortie = dossier_bgpriority.path + r"\" + fichier.path.split(r'\').last.split(r'.').first + ".json";
    File(cheminSortie).writeAsStringSync(jsonPriorite);
    stdout.writeln("Traité");
  });

  print("\nProgramme terminé !");
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