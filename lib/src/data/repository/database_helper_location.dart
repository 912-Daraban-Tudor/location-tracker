import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:location_tracker/src/domain/model/location.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, 'locations.db');
    return await openDatabase(
      path,
      version: 1, 
      onCreate: _onCreate
  );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE locations (
        id INTEGER PRIMARY KEY,
        nameOfLocation TEXT,
        address TEXT,
        latitude REAL,
        longitude REAL,
        description TEXT,
        markerColor TEXT
      )
    ''');
  }


  Future<int> getNextLocationID() async {
    var dbClient = await database;
    List<Map> maps = await dbClient.rawQuery('SELECT MAX(id) + 1 as id FROM locations');
    if (maps.first['id'] == null) {
      return 1;
    }
    return maps.first['id'];
  }

  Future<int> insertLocation(Location location) async {
    var dbClient = await database;
    return await dbClient.insert('locations', location.toMap());
  }


  Future<Location> getLocation(int id) async {
    var dbClient = await database;
    List<Map> maps = await dbClient.query(
      'locations',
      columns: ['id', 'nameOfLocation', 'address', 'latitude', 'longitude', 'description', 'markerColor'],
      where: 'id = ?',
      whereArgs: [id]
    );
    if (maps.isNotEmpty) {
      return Location.fromMap(maps.first);
    }
    return Location.empty();
  }


  Future<List<Location>> getLocations() async {
    var dbClient = await database;
    List<Map> maps = await dbClient.query(
      'locations',
      columns: ['id', 'nameOfLocation', 'address', 'latitude', 'longitude', 'description', 'markerColor']
    );
    return maps.map((location) => Location.fromMap(location)).toList();
  }


  Future<int> deleteLocation(int id) async {
    var dbClient = await database;
    return await dbClient.delete(
      'locations',
      where: 'id = ?',
      whereArgs: [id]
    );
  }


  Future<int> updateLocation(Location location) async {
    var dbClient = await database;
    return await dbClient.update(
      'locations',
      location.toMap(),
      where: 'id = ?',
      whereArgs: [location.id]
    );
  }


  Future close() async {
    var dbClient = await database;
    dbClient.close();
  }
}