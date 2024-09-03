import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'media.db');
    return await openDatabase(
      path,
      version: 3, // Update version to 3
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE user_media (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            user_id INTEGER NOT NULL,
            file_path TEXT NOT NULL,
            media_type TEXT NOT NULL,
            timestamp TEXT NOT NULL
          )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 3) {
          await db.execute('ALTER TABLE user_media ADD COLUMN timestamp TEXT NOT NULL');
        }
      },
    );
  }

  Future<void> insertMedia(int userId, String filePath, String mediaType) async {
    final db = await database;
    final timestamp = DateTime.now().toIso8601String(); // Get current timestamp

    await db.insert(
      'user_media',
      {
        'user_id': userId,
        'file_path': filePath,
        'media_type': mediaType,
        'timestamp': timestamp,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    // Push to the backend without the timestamp
    await _pushMediaToBackend(userId, filePath, mediaType);
  }

  Future<void> _pushMediaToBackend(int userId, String filePath, String mediaType) async {
    var uri = Uri.parse('http://apps.qubators.biz/reachoutworlddc/media_capture.php');
    var request = http.MultipartRequest('POST', uri);

    request.fields['user_id'] = userId.toString();
    request.fields['media_type'] = mediaType;
    request.files.add(await http.MultipartFile.fromPath('media', filePath));

    try {
      var response = await request.send();
      if (response.statusCode == 200) {
        var responseData = await response.stream.bytesToString();
        var jsonResponse = jsonDecode(responseData);
        if (jsonResponse['status'] == 'success') {
          print('Media uploaded successfully: ${jsonResponse['file_path']}');
        } else {
          print('Failed to upload media: ${jsonResponse['message']}');
        }
      } else {
        print('Server error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error uploading media to backend: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getMedia() async {
    final db = await database;
    return await db.query('user_media');
  }

  Future<void> deleteMedia(int id) async {
    final db = await database;
    await db.delete(
      'user_media',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}

