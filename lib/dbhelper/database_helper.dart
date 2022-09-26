import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../model/contact_model.dart';
import 'constant.dart';

class DataBaseHelper {


   Database? db;





  Future open() async {
    String path = join(await getDatabasesPath(), 'contact.db');

    db = await openDatabase(path, version: 1, onCreate: (db, version) async {
      await db.execute('''
   CREATE TABLE $tableContact (
   $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
   $columnName TEXT NOT NULL,
   $columnEmail TEXT NOT NULL,
   $columnPhone TEXT NOT NULL)
   ''');
    });


  }

  //CURD

  //CREATE
  Future insertContact(ContactModel contact) async {
    await open();
    return await db!.insert(tableContact, contact.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  //update
  updateContact(ContactModel contact) async {
    await open();
    return await db!.update(
      tableContact,
      contact.toMap(),
      where: '$columnId = ?',
      whereArgs: [contact.id],
    );
  }


  //READ
  Future<List<ContactModel>> getAllContact() async {
    await open();
    List<Map<String, dynamic>> maps = await db!.query(tableContact);  //hy5leny a read  el data
    return maps.isNotEmpty ?
      maps.map((e) => ContactModel.fromMap(e)).toList() : [];
  }


  //delete
  deleteContact (int id) async {
    db?.delete(tableContact,where: '$columnId=?',whereArgs: [id]);

  }


}

