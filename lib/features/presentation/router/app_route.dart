import 'package:go_router/go_router.dart';
import 'package:medivine/features/presentation/screens/authScreen/role_screen.dart';
import 'package:medivine/features/presentation/screens/konsultasiScreen/all_doctor.dart';
import 'package:medivine/features/presentation/screens/konsultasiScreen/chat_screen.dart';
import 'package:medivine/features/presentation/screens/konsultasiScreen/hasil_diagnosis.dart';
import 'package:medivine/features/presentation/screens/konsultasiScreen/recommendation_%20doctor_screen.dart';
import 'package:medivine/features/presentation/screens/konsultasiScreen/select_docter_screen.dart';
import 'package:medivine/features/presentation/screens/konsultasiScreen/transactions_screen.dart';
import 'package:medivine/features/presentation/screens/navbar/detail_artikel_screen.dart';
import 'package:medivine/features/presentation/screens/navbar/home_screen.dart';
import 'package:medivine/features/presentation/screens/authScreen/signin_screen.dart';
import 'package:medivine/features/presentation/screens/authScreen/signup_screen.dart';
import 'package:medivine/features/presentation/screens/navbar/notification_screen.dart';
import 'package:medivine/features/presentation/screens/onBoarding/on_boarding_screen.dart';
import 'package:medivine/features/presentation/screens/profil_screen.dart';
import 'package:medivine/features/presentation/provider/auth_provider.dart';
import 'package:medivine/features/presentation/screens/scanScreen/camera_screen.dart';
import 'package:medivine/features/presentation/screens/scanScreen/analisis_screen.dart';
import 'package:medivine/features/presentation/screens/konsultasiScreen/list_chat_screen.dart';
import 'package:medivine/features/presentation/screens/konsultasiScreen/doctor_chat_screen.dart';
import 'package:provider/provider.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) {
          final auth = Provider.of<AuthProvider>(context, listen: false);
          if (auth.currentUser != null) {
            return const HomeScreen();
          } else {
            return const OnBoardingScreen();
          }
        },
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
      ),
      GoRoute(
        path: '/recommendation-doctors',
        builder: (context, state) => RecommendationDoctorScreen(),
      ),
      GoRoute(
        path: '/all-doctors',
        builder: (context, state) => AllDoctorsScreen(),
      ),
      GoRoute(
        path: '/select-doctor/:doctorId',
        builder: (context, state) {
          final doctorId = state.pathParameters['doctorId'] ?? '';
          return SelectDoctorScreen(doctorId: doctorId);
        },
      ),
      GoRoute(
        path: '/payment-confirmation/:doctorId',
        builder: (context, state) {
          final doctorId = state.pathParameters['doctorId'] ?? '';
          final extra = state.extra as Map<String, dynamic>?;
          final isAnonymous = extra?['isAnonymous'] ?? false;
          return TransactionDoctorScreen(
              doctorId: doctorId, isAnonymous: isAnonymous);
        },
      ),
      GoRoute(
        path: '/chat-screen/:doctorId',
        builder: (context, state) {
          final doctorId = state.pathParameters['doctorId'] ?? '';
          final extra = state.extra as Map<String, dynamic>?;
          final isAnonymous = extra?['isAnonymous'] ?? false;
          return ChatScreen(doctorId: doctorId, isAnonymous: isAnonymous);
        },
      ),
      GoRoute(
        path: '/doctor-chat/:userId',
        builder: (context, state) {
          final userId = state.pathParameters['userId'] ?? '';
          return DoctorChatScreen(userId: userId);
        },
      ),
      GoRoute(
        path: '/list-chat',
        builder: (context, state) => const ListChatScreen(),
      ),
      GoRoute(
        path: '/notifications',
        builder: (context, state) => const NotificationScreen(),
      ),
      GoRoute(
        path: '/hasildiagnosis',
        builder: (context, state) => const HasilDiagnosisScreen(),
      ),
      GoRoute(
        path: '/detail-artikel',
        builder: (context, state) => const DetailArtikelScreen(),
      ),
    ],
  );
}
