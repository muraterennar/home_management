import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:developer' as developer;
import 'local_storage_service.dart';
import 'dart:convert';

class SyncService {
  static SyncService? _instance;
  final LocalStorageService _localStorage = LocalStorageService.instance;

  SyncService._internal();

  static SyncService get instance {
    _instance ??= SyncService._internal();
    return _instance!;
  }

  // İnternet bağlantısını kontrol et
  Future<bool> hasInternetConnection() async {
    try {
      final connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
        return false;
      }

      // Gerçek internet bağlantısını test et
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (e) {
      developer.log('İnternet bağlantısı kontrolü hatası: $e', name: 'SyncService');
      return false;
    }
  }

  // Resimleri Supabase'e yükle
  Future<String?> uploadImageToSupabase(File imageFile, String fileName) async {
    try {
      if (!await hasInternetConnection()) {
        developer.log('İnternet bağlantısı yok, resim yüklenemedi', name: 'SyncService');
        return null;
      }

      const bucket = 'home-management';
      final path = 'public/$fileName';

      final storage = Supabase.instance.client.storage;
      final res = await storage
          .from(bucket)
          .upload(path, imageFile, fileOptions: const FileOptions(cacheControl: '3600', upsert: false));

      if (res != null && res.isNotEmpty) {
        final publicURL = storage.from(bucket).getPublicUrl(path);
        developer.log('Resim Supabase\'e yüklendi: $publicURL', name: 'SyncService');
        return publicURL;
      }

      return null;
    } catch (e) {
      developer.log('Supabase resim yükleme hatası: $e', name: 'SyncService');
      return null;
    }
  }

  // Hibrit resim yükleme: önce local, sonra Supabase
  Future<Map<String, String>> saveImageHybrid(File imageFile, String fileName) async {
    final results = <String, String>{};

    try {
      // 1. Önce local'e kaydet
      final localPath = await _localStorage.saveImageLocally(imageFile, fileName);
      results['localPath'] = localPath;

      // 2. Cache'e kaydet (pending status ile)
      final imageId = DateTime.now().millisecondsSinceEpoch.toString();
      await _localStorage.cacheImageInfo(
        id: imageId,
        localPath: localPath,
        syncStatus: 0, // pending
      );

      // 3. İnternet varsa Supabase'e yükle
      if (await hasInternetConnection()) {
        final onlineUrl = await uploadImageToSupabase(imageFile, fileName);
        if (onlineUrl != null) {
          results['onlineUrl'] = onlineUrl;
          // Sync durumunu güncelle
          await _localStorage.updateSyncStatus(imageId, 1, onlineUrl: onlineUrl);
        } else {
          // Başarısız, sync queue'ya ekle
          await _localStorage.addToSyncQueue(
            id: imageId,
            tableName: 'images',
            operation: 'upload',
            data: jsonEncode({
              'fileName': fileName,
              'localPath': localPath,
            }),
          );
        }
      } else {
        // İnternet yok, sync queue'ya ekle
        await _localStorage.addToSyncQueue(
          id: imageId,
          tableName: 'images',
          operation: 'upload',
          data: jsonEncode({
            'fileName': fileName,
            'localPath': localPath,
          }),
        );
      }

      results['imageId'] = imageId;

    } catch (e) {
      developer.log('Hibrit resim kaydetme hatası: $e', name: 'SyncService');
      rethrow;
    }

    return results;
  }

  // Bekleyen sync işlemlerini gerçekleştir
  Future<void> processPendingSyncs() async {
    if (!await hasInternetConnection()) {
      developer.log('İnternet bağlantısı yok, sync işlemi atlandı', name: 'SyncService');
      return;
    }

    try {
      final pendingOperations = await _localStorage.getPendingSyncOperations();

      for (final operation in pendingOperations) {
        await _processSyncOperation(operation);
      }
    } catch (e) {
      developer.log('Sync işlemi hatası: $e', name: 'SyncService');
    }
  }

  Future<void> _processSyncOperation(Map<String, dynamic> operation) async {
    try {
      final data = jsonDecode(operation['data']);

      if (operation['table_name'] == 'images' && operation['operation'] == 'upload') {
        final fileName = data['fileName'] as String;
        final localPath = data['localPath'] as String;

        final localFile = await _localStorage.getLocalImage(localPath);
        if (localFile != null) {
          final onlineUrl = await uploadImageToSupabase(localFile, fileName);

          if (onlineUrl != null) {
            // Başarılı, sync durumunu güncelle ve queue'dan kaldır
            await _localStorage.updateSyncStatus(operation['id'], 1, onlineUrl: onlineUrl);
            await _localStorage.removeSyncOperation(operation['id']);
            developer.log('Sync başarılı: ${operation['id']}', name: 'SyncService');
          } else {
            developer.log('Sync başarısız: ${operation['id']}', name: 'SyncService');
          }
        }
      }
    } catch (e) {
      developer.log('Sync operation hatası: $e', name: 'SyncService');
    }
  }

  // Resim URL'ini al (hibrit: önce online, sonra local)
  Future<String?> getImageUrl(String imageId) async {
    try {
      final cachedInfo = await _localStorage.getCachedImageInfo(imageId);

      if (cachedInfo != null) {
        // Eğer online URL varsa ve internet bağlantısı varsa, onu kullan
        if (cachedInfo['original_url'] != null && await hasInternetConnection()) {
          return cachedInfo['original_url'];
        }

        // Yoksa local dosyayı kullan
        final localFile = await _localStorage.getLocalImage(cachedInfo['local_path']);
        if (localFile != null) {
          return cachedInfo['local_path']; // Local path'i döndür
        }
      }

      return null;
    } catch (e) {
      developer.log('Resim URL alma hatası: $e', name: 'SyncService');
      return null;
    }
  }
}
