import 'package:get_it/get_it.dart';
import 'package:medivine/features/data/datasources/firebase_auth_service.dart';
import 'package:medivine/features/data/repositories/auth_repository_impl.dart';
import 'package:medivine/features/domain/repositories/auth_repository.dart';
import 'package:medivine/features/domain/usecases/login_user.dart';
import 'package:medivine/features/domain/usecases/register_user.dart';
import 'package:medivine/features/presentation/provider/auth_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:medivine/features/data/datasources/analysis_service.dart';
import 'package:medivine/features/data/repositories/save_repository_impl.dart';
import 'package:medivine/features/domain/repositories/save_repository.dart';
import 'package:medivine/features/domain/usecases/save_analysis.dart';

final sl = GetIt.instance;

void setupDependencyInjection() {
  sl.registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance);

  // Data Layer
  sl.registerLazySingleton<FirebaseAuthService>(() => FirebaseAuthService());

  // Repository Layer
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl()));

  // Use Cases
  sl.registerLazySingleton<LoginUser>(() => LoginUser(sl()));
  sl.registerLazySingleton<RegisterUser>(() => RegisterUser(sl()));

  // Providers
  sl.registerLazySingleton<AuthProvider>(() => AuthProvider(
        authService: sl(),
        loginUser: sl(),
        registerUser: sl(),
      ));

  // Analysis & Save dependencies
  sl.registerLazySingleton<GeminiAnalysisService>(() =>
      GeminiAnalysisService(apiKey: 'AIzaSyCF3dW4phZjlfayvtZvJTRXUlcHqpFqNW8'));
  sl.registerLazySingleton<SaveRepository>(() => SaveRepositoryImpl(sl()));
  sl.registerLazySingleton<SaveAnalysis>(() => SaveAnalysis(sl()));
}
