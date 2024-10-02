import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBService extends ChangeNotifier {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'scan_history.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE history ('
          'id INTEGER PRIMARY KEY AUTOINCREMENT, '
          'barcode TEXT, '
          'product_name TEXT, '
          'nutriscore_score TEXT, ' // Make sure this column exists
          'nutriscore_grade TEXT, '
          'image_url TEXT, '
          'scan_date TEXT' // Add scan_date if necessary
          ')',
        );
      },
    );
  }

  Future<void> insertScan(Map<String, dynamic> product) async {
    final db = await database;
    await db.insert(
      'history',
      {
        'barcode': product['code'],
        'product_name': product['product_name'],
        'nutriscore_score': product['nutriscore_score']?.toString() ?? 'N/A',
        'nutriscore_grade':
            product['nutriscore_grade']?.toUpperCase() ?? 'Unknown',
        'image_url': product['image_url'] ?? '',
        'scan_date': DateTime.now().toIso8601String(),
      },
    );
    notifyListeners();
  }

  Future<List<Map<String, dynamic>>> getScanHistory() async {
    final db = await database;
    return await db.query('history');
  }

  // New method to delete a scan by its id
  Future<void> deleteScan(int id) async {
    final db = await database;
    await db.delete(
      'history',
      where: 'id = ?',
      whereArgs: [id],
    );
    notifyListeners();
  }
}
