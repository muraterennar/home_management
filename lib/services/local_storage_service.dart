import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:developer' as developer;

class LocalStorageService {
  static Database? _database;
  static LocalStorageService? _instance;

  LocalStorageService._internal();

  static LocalStorageService get instance {
    _instance ??= LocalStorageService._internal();
    return _instance!;
  }

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'home_management.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE cached_images (
        id TEXT PRIMARY KEY,
        original_url TEXT,
        local_path TEXT,
        sync_status INTEGER DEFAULT 0,
        created_at TEXT,
        updated_at TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE sync_queue (
        id TEXT PRIMARY KEY,
        table_name TEXT,
        operation TEXT,
        data TEXT,
        created_at TEXT,
        retry_count INTEGER DEFAULT 0
      )
    ''');
  }

  // Resim dosyasını local'e kaydet
  Future<String> saveImageLocally(File imageFile, String fileName) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final imagesDir = Directory('${directory.path}/images');

      if (!await imagesDir.exists()) {
        await imagesDir.create(recursive: true);
      }

      final localPath = '${imagesDir.path}/$fileName';
      final savedFile = await imageFile.copy(localPath);

      developer.log('Resim local\'e kaydedildi: $localPath', name: 'LocalStorageService');
      return savedFile.path;
    } catch (e) {
      developer.log('Local resim kaydetme hatası: $e', name: 'LocalStorageService');
      rethrow;
    }
  }

  // Cache'e resim bilgisi kaydet
  Future<void> cacheImageInfo({
    required String id,
    String? originalUrl,
    required String localPath,
    int syncStatus = 0,
  }) async {
    final db = await database;
    final now = DateTime.now().toIso8601String();

    await db.insert(
      'cached_images',
      {
        'id': id,
        'original_url': originalUrl,
        'local_path': localPath,
        'sync_status': syncStatus, // 0: pending, 1: synced, 2: failed
        'created_at': now,
        'updated_at': now,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Cache'den resim bilgisi al
  Future<Map<String, dynamic>?> getCachedImageInfo(String id) async {
    final db = await database;
    final results = await db.query(
      'cached_images',
      where: 'id = ?',
      whereArgs: [id],
    );

    return results.isNotEmpty ? results.first : null;
  }

  // Sync edilmemiş resimleri al
  Future<List<Map<String, dynamic>>> getUnsyncedImages() async {
    final db = await database;
    return await db.query(
      'cached_images',
      where: 'sync_status = ?',
      whereArgs: [0], // pending
    );
  }

  // Sync durumunu güncelle
  Future<void> updateSyncStatus(String id, int status, {String? onlineUrl}) async {
    final db = await database;
    final updateData = {
      'sync_status': status,
      'updated_at': DateTime.now().toIso8601String(),
    };

    if (onlineUrl != null) {
      updateData['original_url'] = onlineUrl;
    }

    await db.update(
      'cached_images',
      updateData,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Local resim dosyasını al
  Future<File?> getLocalImage(String localPath) async {
    try {
      final file = File(localPath);
      if (await file.exists()) {
        return file;
      }
      return null;
    } catch (e) {
      developer.log('Local resim okuma hatası: $e', name: 'LocalStorageService');
      return null;
    }
  }

  // Sync queue'ya işlem ekle
  Future<void> addToSyncQueue({
    required String id,
    required String tableName,
    required String operation,
    required String data,
  }) async {
    final db = await database;
    await db.insert('sync_queue', {
      'id': id,
      'table_name': tableName,
      'operation': operation,
      'data': data,
      'created_at': DateTime.now().toIso8601String(),
      'retry_count': 0,
    });
  }

  // Sync queue'dan bekleyen işlemleri al
  Future<List<Map<String, dynamic>>> getPendingSyncOperations() async {
    final db = await database;
    return await db.query('sync_queue', orderBy: 'created_at ASC');
  }

  // Sync queue'dan işlem sil
  Future<void> removeSyncOperation(String id) async {
    final db = await database;
    await db.delete('sync_queue', where: 'id = ?', whereArgs: [id]);
  }
}
