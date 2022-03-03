import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqlite_api.dart';

import 'item_provider.dart';

class ItemList with ChangeNotifier {
  List<Item> _items = [];
  String table = 'items';
  String dbName = 'items.db';
  int currentLastId = -1;

  Future<Database> database() async {
    final dbPath = await sql.getDatabasesPath();
    return sql.openDatabase(path.join(dbPath, dbName), onCreate: (db, version) {
      return db.execute(
          'CREATE TABLE items(id INTEGER PRIMARY KEY, title TEXT, description TEXT)');
    }, version: 1);
  }

  Future<void> fetchAndSetItems() async {
    final db = await database();
    final tableData = await db.query(table, orderBy: 'id');
    if (tableData.isNotEmpty) {
      _items = tableData
          .map((e) => Item(
              id: e['id'] as int,
              title: e['title'] as String,
              description: e['description'] as String))
          .toList();
      currentLastId = _items.last.id;
    }
    notifyListeners();
  }

  List<Item> get items => [..._items];

  void addItem(Item val) {
    final itemIdx = _items.indexWhere((element) => element.id == val.id);
    if (itemIdx < 0) {
      currentLastId += 1;
      val.id = currentLastId;
      _items.add(val);
      notifyListeners();
      insert(val.toMap());
    }
  }

  void updateItem(Item val) {
    final itemIdx = _items.indexWhere((element) => element.id == val.id);
    if (itemIdx >= 0) {
      _items[itemIdx] = val;
      notifyListeners();
      update(val.id, val.toMap());
    }
  }

  void deleteItem(Item val) {
    final itemIdx = _items.indexWhere((element) => element.id == val.id);
    if (itemIdx >= 0) {
      _items.removeAt(itemIdx);
      notifyListeners();
      delete(val.id);
    }
  }

  Future<int> insert(Map<String, dynamic> values) async {
    final db = await database();
    return db.insert(table, values,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
  }

  Future<void> update(int id, Map<String, dynamic> values) async {
    final db = await database();
    await db.update(table, values, where: 'id = ?', whereArgs: [id]);
  }

  Future<void> delete(int id) async {
    final db = await database();
    await db.delete(table, where: 'id = ?', whereArgs: [id]);
  }
}
