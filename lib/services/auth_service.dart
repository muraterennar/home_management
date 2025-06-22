import 'dart:developer' as debugConsole;
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:home_management/models/register_dto.dart';
import 'package:home_management/services/user_service.dart';
import '../l10n/app_localizations.dart';
import '../models/login_dto.dart';
import '../models/users/create_user_dto.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // AppLocalizations'a erişim için BuildContext
  BuildContext? _context;

  // Constructor'a BuildContext parametresi ekliyoruz
  AuthService({BuildContext? context}) {
    _context = context;
  }

  // Lokalizasyon erişimi için yardımcı getter
  AppLocalizations? get _l10n =>
      _context != null ? AppLocalizations.of(_context!) : null;

  // Çeviri metodu - context yoksa varsayılan mesajları kullanır
  String _getLocalizedMessage(String key, String defaultMessage) {
    if (_l10n == null) {
      return defaultMessage;
    }

    switch (key) {
      case 'firebaseAuthError':
        return _l10n!.firebaseAuthError;
      case 'networkError':
        return _l10n!.networkError;
      case 'firebaseConnectionError':
        return _l10n!.firebaseConnectionError;
      case 'unknownError':
        return _l10n!.unknownError;
      case 'userNotLoggedIn':
        return _l10n!.userNotLoggedIn;
      case 'profileUpdateError':
        return _l10n!.profileUpdateError;
      case 'emailAlreadyVerified':
        return _l10n!.emailAlreadyVerified;
      case 'emailVerificationError':
        return _l10n!.emailVerificationError;
      case 'userInfoError':
        return _l10n!.userInfoError;
      case 'logoutError':
        return _l10n!.logoutError;
      default:
        return defaultMessage;
    }
  }

  Future<UserCredential> loginWithEmail(LoginDto loginDto) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: loginDto.email,
        password: loginDto.password,
      );

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(
          '${_getLocalizedMessage('firebaseAuthError', 'FirebaseAuth error: ')}${e.message}');
    } on SocketException catch (_) {
      throw Exception(_getLocalizedMessage(
          'networkError', 'Ağ hatası: İnternet bağlantınızı kontrol edin.'));
    } on FirebaseException catch (e) {
      throw Exception(
          '${_getLocalizedMessage('firebaseConnectionError', 'Firebase bağlantı hatası: ')}${e.message}');
    } catch (e) {
      throw Exception(
          '${_getLocalizedMessage('unknownError', 'Bilinmeyen hata: ')}$e');
    }
  }

  Future<User?> registerWithEmail(RegisterDto registerDto) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: registerDto.email,
        password: registerDto.password,
      );

      var result = await updateUserProfile(
          registerDto.firstName ?? '', registerDto.photoURL ?? '');

      await sendEmailVerification();

      return _auth.currentUser;
    } on FirebaseAuthException catch (e) {
      debugConsole.log('FirebaseAuthException: ${e}');
      throw Exception(
          '${_getLocalizedMessage('firebaseAuthError', 'FirebaseAuth hatası: ')}${e.message}');
    } on SocketException catch (_) {
      debugConsole.log('SocketException: Ağ hatası');
      throw Exception(_getLocalizedMessage(
          'networkError', 'Ağ hatası: İnternet bağlantınızı kontrol edin.'));
    } on FirebaseException catch (e) {
      debugConsole.log('FirebaseException: ${e.message}');
      throw Exception(
          '${_getLocalizedMessage('firebaseConnectionError', 'Firebase bağlantı hatası: ')}${e.message}');
    } catch (e) {
      debugConsole.log('Unknown exception: $e');
      throw Exception(
          '${_getLocalizedMessage('unknownError', 'Bilinmeyen hata: ')}$e');
    }
  }

  Future<User?> updateUserProfile(String displayName, String photoURL) async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        await user.updateProfile(displayName: displayName, photoURL: photoURL);
        await user.reload();
        user = _auth.currentUser; // Reload the user to get updated info
        return user;
      } else {
        throw Exception(_getLocalizedMessage(
            'userNotLoggedIn', 'Kullanıcı oturumu açık değil.'));
      }
    } catch (e) {
      throw Exception(
          '${_getLocalizedMessage('profileUpdateError', 'Profil güncellenirken hata: ')}$e');
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw Exception(
          '${_getLocalizedMessage('firebaseAuthError', 'FirebaseAuth hatası: ')}${e.message}');
    } on SocketException catch (_) {
      throw Exception(_getLocalizedMessage(
          'networkError', 'Ağ hatası: İnternet bağlantınızı kontrol edin.'));
    } on FirebaseException catch (e) {
      throw Exception(
          '${_getLocalizedMessage('firebaseConnectionError', 'Firebase bağlantı hatası: ')}${e.message}');
    } catch (e) {}
  }

  Future<void> sendEmailVerification() async {
    try {
      User? user = _auth.currentUser;
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
      } else {
        throw Exception(_getLocalizedMessage(
            'emailAlreadyVerified', 'E-posta zaten doğrulanmış.'));
      }
    } catch (e) {
      throw Exception(
          '${_getLocalizedMessage('emailVerificationError', 'E-posta doğrulama hatası: ')}$e');
    }
  }

  Future<User?> getCurrentUser() async {
    try {
      return _auth.currentUser;
    } catch (e) {
      throw Exception(
          '${_getLocalizedMessage('userInfoError', 'Kullanıcı bilgisi alınırken hata: ')}$e');
    }
  }

  Future<void> logout() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw Exception(
          '${_getLocalizedMessage('logoutError', 'Çıkış yapılırken hata: ')}$e');
    }
  }
}
