import 'package:medivine/features/domain/entities/user.dart';
import 'package:medivine/features/domain/repositories/auth_repository.dart';

import '../datasources/firebase_auth_service.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuthService firebaseAuthService;

  AuthRepositoryImpl(this.firebaseAuthService);

  @override
  Future<UserEntity> login(String email, String password) async {
    final user = await firebaseAuthService.login(email, password);
    return UserEntity(id: user.id, email: user.email);
  }

  @override
  Future<UserEntity> register(String email, String password) async {
    final user = await firebaseAuthService.register(email, password);
    return UserEntity(id: user.id, email: user.email);
  }
}
