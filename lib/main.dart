import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';
import 'features/presentation/provider/auth_provider.dart';
import 'features/domain/usecases/save_analysis.dart';
import 'features/presentation/provider/analisis_provider.dart';
import 'di/injection_container.dart' as di;
import 'features/presentation/router/app_route.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  di.setupDependencyInjection();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(
            authService: di.sl(),
            loginUser: di.sl(),
            registerUser: di.sl(),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) {
            final provider = AnalisisProvider(
              apiKey: 'AIzaSyCF3dW4phZjlfayvtZvJTRXUlcHqpFqNW8',
            );
            provider.setSaveAnalysisUsecase(di.sl<SaveAnalysis>());
            return provider;
          },
        ),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'Informal Study Jam Eps.2',
        theme: ThemeData(primarySwatch: Colors.blue),
        routerConfig: AppRouter.router,
      ),
    );
  }
}
