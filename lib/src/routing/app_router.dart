import 'package:faker_app_flutter_firebase/src/routing/go_router_refresh_stream.dart';
import 'package:faker_app_flutter_firebase/src/screens/custom_profile_screen.dart';
import 'package:faker_app_flutter_firebase/src/screens/custom_sign_in_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

enum AppRoute {
  signIn,
  profile,
}

final FirebaseAuthProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});

final goRouterProvider = Provider<GoRouter>((ref) {
  final fbAuth = ref.watch(FirebaseAuthProvider);
  return GoRouter(
    initialLocation: '/sign-in',
    debugLogDiagnostics: true,
    redirect: (context, state) {
      final isLoggedIn = fbAuth.currentUser != null;
      if (isLoggedIn) {
        if (state.uri.path == '/sign-in') {
          return '/profile';
        }
      } else {
        if (state.uri.path == '/profile') {
          return '/sign-in';
        }
      }

      return null;
    },
    refreshListenable: GoRouterRefreshStream(fbAuth.authStateChanges()),
    routes: [
      GoRoute(
        path: '/sign-in',
        name: AppRoute.signIn.name,
        builder: (context, state) => const CustomSignInScreen(),
      ),
      GoRoute(
        path: '/profile',
        name: AppRoute.profile.name,
        builder: (context, state) => const CustomProfileScreen(),
      ),
    ],
  );
});
