
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sql.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:t_pido/src/model/usuario.dart';


class ClientDatabaseProvider {
  ClientDatabaseProvider._();

  static final ClientDatabaseProvider db = ClientDatabaseProvider._();
  Database _database;

  //para evitar que abra varias conexciones una y otra vez podemos usar algo como esto..
  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await getDatabaseInstanace();
    return _database;
  }

  Future<Database> getDatabaseInstanace() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, "client.db");
    return await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE Usuario ("
          "id integer primary key,"
          "email String,"
          "empresa1 String,"
          "empresa2 String,"
          "empresa3 String,"
          "empresa4 String,"
          "empresa5 String,"
          "empresa6 String,"
          "empresa7 String,"
          "empresa8 String,"
          "empresa9 String,"
          "empresa10 String"
          ")");
    });
  }



  updateUserLocal(Usuario usuario) async {
    final db = await database;
    var response = await db.update("Usuario", usuario.toMap(),
        where: "id = ?", whereArgs: [usuario.id]);
    print("se modifico la data del user");
    return response;
  }

  Future<Usuario> getLocalData(String email) async {
    final db = await database;
    List res = await db
        .query("Usuario", where: "email LIKE ?", whereArgs: ['%$email']);
    print(res[0]);
    Usuario user = Usuario.fromMap(res[0]);

    return user;
  }

  addUserToDatabase(Usuario usuario) async {
    final db = await database;
    var table = await db.rawQuery("SELECT MAX(id)+1 as id FROM Usuario");
    int id = table.first["id"];
    usuario.id = id;
    var raw = await db.insert(
      "Usuario",
      usuario.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    print("Agregado los registros en tabla Usuario");
    return raw;
  }

  void addUserRegister(String email) {
    ClientDatabaseProvider.db.addUserToDatabase(new Usuario(
      email: email,
      empresa1: "Favorito1",
      empresa2: "Favorito2",
      empresa3: "Favorito3",
      empresa4: "Favorito4",
      empresa5: "Favorito5",
      empresa6: "Favorito6",
      empresa7: "Favorito7",
      empresa8: "Favorito8",
      empresa9: "Favorito9",
      empresa10: "Favorito10",
    ));
  }
}
