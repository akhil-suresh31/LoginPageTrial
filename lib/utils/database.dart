import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:path/path.dart';
import 'package:login_page_t1/model/user.dart';

class DBProvider{
  DBProvider._();
  static final DBProvider db= DBProvider._();
  static Database _database;
  
  Future<Database> get database async{
    if(_database != null)
      return _database;
    
    _database = await initDB();
    return _database;
  }
  
  initDB() async{
    return await openDatabase(
      join(await getDatabasesPath(),'user_table.db'),
      onCreate: (db,version) async {
        await db.execute('''CREATE TABLE users(username TEXT PRIMARY KEY,password TEXT) ''');
      },
      version: 1,

    );
  }

  newUser(User user) async{
    final db = await database;
    var res = await db.insert('users', user.ToMap(),conflictAlgorithm: ConflictAlgorithm.replace,);
    return res;
  }

  Future<dynamic> getUser() async {
    final db = await database;
    var res = await db.rawQuery('SELECT COUNT(*) FROM users');
    print(res);
  }

  allUsers() async{
    final db = await database;
    List<Map> res = await db.rawQuery('SELECT * FROM users');
    print(res);
  }

  existUser(User user) async{
    final db= await database;
    List<Map> res= await db.rawQuery('SELECT * FROM users WHERE username = ?',[user.username]);
    if(res.isEmpty){
      print("no such user :" );
      print(user.username);

    }
    else
      {
        if(res[0]['password'] == user.password) {
          print("login successful!!!");

        }
        else{
          print("wrong password");
          print("right pass : "+res.toString());
          //print(res.runtimeType);

        }
      }
  }

  deleteDb() async{
    print(await getDatabasesPath());
    await deleteDatabase(join(await getDatabasesPath(),'user_table.db'));
  }

}