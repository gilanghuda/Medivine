import 'package:go_router/go_router.dart';
import 'package:medivine/features/presentation/screens/authScreen/role_screen.dart';
import 'package:medivine/features/presentation/screens/navbar/home_screen.dart';
import 'package:medivine/features/presentation/screens/authScreen/signin_screen.dart';
import 'package:medivine/features/presentation/screens/authScreen/signup_screen.dart';
import 'package:medivine/features/presentation/screens/onBoarding/on_boarding_screen.dart';
import 'package:medivine/features/presentation/screens/profil_screen.dart';
import 'package:medivine/features/presentation/provider/auth_provider.dart';
import 'package:medivine/features/presentation/screens/scanScreen/camera_screen.dart';
import 'package:medivine/features/presentation/screens/scanScreen/analisis_screen.dart';
import 'package:provider/provider.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/signup',
        builder: (context, state) => const SignupScreen(),
      ),
      GoRoute(
        path: '/signin',
        name: 'signin',
        builder: (context, state) => const SigninScreen(),
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfilScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnBoardingScreen(),
      ),
      GoRoute(
        path: '/chooseRole',
        builder: (context, state) => const RoleScreen(),
      ),
      GoRoute(
        path: '/scan',
        builder: (context, state) => CameraScreen(),
      ),
      GoRoute(
        path: '/analisis',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          return AnalisisScreen(
            imagePath: extra?['imagePath'],
            result: extra?['result'],
          );
        },
      )
    ],
    redirect: (context, state) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final isLoggedIn = authProvider.currentUser != null;
      final isOnboarding = state.matchedLocation == '/onboarding';

      // if (!isLoggedIn && !isOnboarding) {
      //   return '/signup';
      // }
      if (isLoggedIn && isOnboarding) {
        return '/';
      }
      return null;
    },
  );
}
