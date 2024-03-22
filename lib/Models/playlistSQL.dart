// -- Connexion + création BD
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'package:path/path.dart';

class PlaylistProviderSQL {
  static const databaseName =
      "Playlist.db"; // nom du fichier qui contient la BD

  late Database db;

  Future open() async {
    // la base de données en tant qu’objet
    // -- il faut récupérer le dossier dans lequel est stocké le fichier de la BD
    final documentsDirectory = await getDatabasesPath();
    // --- construire le path complet -> ajouter le nom du fichier à la fin
    final path = join(documentsDirectory, databaseName);
    // --- supprimer la BD déjà existante si besoin
    // await deleteDatabase(path,);
    // --- puis il faut ouvrir la BD
    db = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      // la BD n'existe pas, on la crée
      await db.execute('''
CREATE TABLE playlist (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  nom TEXT NOT NULL,
  son TEXT
)
''');

// -- éventuellement y ajouter quelques données
      await db.execute(
          "INSERT INTO playlist(id, nom, son) VALUES('Playlist-1')");
    });
  }
}
