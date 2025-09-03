// ignore_for_file: use_build_context_synchronously, await_only_futures

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:medivine/features/data/datasources/firebase_auth_service.dart';
import 'package:medivine/features/data/models/user_model.dart';
import 'package:medivine/features/domain/usecases/login_user.dart';
import 'package:medivine/features/domain/usecases/register_user.dart';
import 'package:go_router/go_router.dart';

class AuthProvider with ChangeNotifier {
  final LoginUser loginUser;
  final RegisterUser registerUser;
  final FirebaseAuthService authService;

  String? _userId;
  UserModel? _currentUser;
  UserModel? get currentUser => _currentUser;

  AuthProvider({
    required this.authService,
    required this.loginUser,
    required this.registerUser,
  });

  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> login(
      String email, String password, BuildContext context) async {
    _setLoading(true);
    _clearError();
    try {
      await loginUser(LoginParams(email: email, password: password));
      await getCurrentUserProfile();
      context.go('/');
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> register(
      String email, String password, BuildContext context) async {
    _setLoading(true);
    _clearError();
    try {
      await registerUser(RegisterParams(email: email, password: password));
      await getCurrentUserProfile();
      // Pindah ke role screen hanya jika tidak ada error
      if (_errorMessage == null) {
        context.go('/chooseRole');
      }
      // Proses simpan profil user dilakukan setelah pilih gender di RoleScreen
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> logout(BuildContext context) async {
    _setLoading(true);
    _clearError();
    try {
      await authService.signOut();
      context.go('/signin');
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> getCurrentUserProfile() async {
    final firebaseUser = authService.getCurrentUser();
    if (firebaseUser != null) {
      _currentUser = UserModel(
        id: firebaseUser.uid,
        email: firebaseUser.email ?? '',
      );
      _userId = firebaseUser.uid;
    } else {
      _currentUser = null;
      _userId = null;
    }
    notifyListeners();
  }

  Future<void> saveUserProfile(String gender) async {
    if (_currentUser == null) return;
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(_currentUser!.id)
          .set({
        'email': _currentUser!.email,
        'gender': gender,
      }, SetOptions(merge: true));
    } catch (e) {
      _setError(e.toString());
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String message) {
    _errorMessage = message;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
  }
}
