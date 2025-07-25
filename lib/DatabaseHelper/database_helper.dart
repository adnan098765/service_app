import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('users.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        phoneNumber TEXT NOT NULL UNIQUE,
        customerId INTEGER NOT NULL,
        token TEXT
      )
    ''');
  }

  Future<void> createUser(String phoneNumber, int customerId, String? token) async {
    final db = await database;
    await db.insert(
      'users',
      {
        'phoneNumber': phoneNumber,
        'customerId': customerId,
        'token': token,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    debugPrint('[DatabaseHelper] Created/Updated user: $phoneNumber, customerId: $customerId, token: $token');
  }

  Future<Map<String, dynamic>?> getUser(String phoneNumber) async {
    final db = await database;
    final maps = await db.query(
      'users',
      where: 'phoneNumber = ?',
      whereArgs: [phoneNumber],
    );
    if (maps.isNotEmpty) {
      debugPrint('[DatabaseHelper] Found user: $phoneNumber, data: ${maps.first}');
      return maps.first;
    }
    debugPrint('[DatabaseHelper] No user found for: $phoneNumber');
    return null;
  }

  Future<bool> checkUserExists(String phoneNumber) async {
    final db = await database;
    final maps = await db.query(
      'users',
      where: 'phoneNumber = ?',
      whereArgs: [phoneNumber],
    );
    final exists = maps.isNotEmpty;
    debugPrint('[DatabaseHelper] checkUserExists: $phoneNumber → $exists');
    return exists;
  }

  Future<void> updateUserToken(String phoneNumber, String token) async {
    final db = await database;
    await db.update(
      'users',
      {'token': token},
      where: 'phoneNumber = ?',
      whereArgs: [phoneNumber],
    );
    debugPrint('[DatabaseHelper] Updated token for $phoneNumber: $token');
  }

  Future<void> clearDatabase() async {
    final db = await database;
    await db.delete('users');
    debugPrint('[DatabaseHelper] Cleared all user data');
  }

  Future<void> close() async {
    final db = await database;
    await db.close();
    _database = null;
  }
}