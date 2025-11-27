import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hocado/app/routing/app_routes.dart';
import 'package:hocado/app/provider/provider.dart';
import 'package:hocado/data/models/models.dart';
import 'package:hocado/presentation/views/screens.dart';
import 'package:hocado/presentation/main_scaffold.dart';

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen((_) => notifyListeners());
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

final goRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);
  final authService = ref.watch(authServiceProvider);

  return GoRouter(
    initialLocation: '/home',
    // lắng nghe sự thay đổi trạng thái auth để re-route
    refreshListenable: GoRouterRefreshStream(
      authService.authStateChanges(),
    ),

    // logic chuyển hướng
    redirect: (context, state) {
      final loggedIn = authState.value != null;
      final loggingIn =
          state.matchedLocation == '/sign-in' ||
          state.matchedLocation == '/sign-up';

      // nếu chưa đăng nhập và đang cố vào trang cần đăng nhập
      if (!loggedIn && !loggingIn) {
        return '/sign-in';
      }

      // nếu đã đăng nhập và đang ở trang sign in/sign up, chuyển hướng đến home
      if (loggedIn && loggingIn) {
        return '/home';
      }

      // nếu không thuộc các trường hợp trên thì không cần chuyển hướng
      return null;
    },
    routes: [
      GoRoute(
        path: '/sign-in',
        name: AppRoutes.signIn.name,
        builder: (context, state) => SignInScreen(),
      ),
      GoRoute(
        path: '/sign-up',
        name: AppRoutes.signUp.name,
        builder: (context, state) => SignUpScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) => MainScaffold(child: child),
        routes: [
          GoRoute(
            path: '/home',
            name: AppRoutes.home.name,
            builder: (context, state) => HomeScreen(),
          ),
          GoRoute(
            path: '/decks',
            name: AppRoutes.decks.name,
            builder: (context, state) => DecksScreen(),
          ),
          GoRoute(
            path: '/users/:uid',
            name: AppRoutes.profile.name,
            builder: (context, state) {
              final uid = state.pathParameters['uid']!;
              return ProfileScreen(userId: uid);
            },
          ),
        ],
      ),
      GoRoute(
        path: '/create',
        name: AppRoutes.createDecks.name,
        builder: (context, state) {
          final flashcards = state.extra as List<Flashcard>?;
          return CreateDeckScreen(flashcards: flashcards);
        },
      ),
      GoRoute(
        path: '/decks/:did',
        name: AppRoutes.detailDeck.name,
        builder: (context, state) {
          final did = state.pathParameters['did']!;
          return DetailDeckScreen(deckId: did);
        },
      ),
      GoRoute(
        path: '/decks/:did/edit',
        name: AppRoutes.editDeck.name,
        builder: (context, state) {
          final did = state.pathParameters['did'];
          return CreateDeckScreen(did: did);
        },
      ),
      GoRoute(
        path: '/decks/:did/learning-settings',
        name: AppRoutes.learningSettings.name,
        builder: (context, state) {
          final did = state.pathParameters['did']!;
          final mode = state.uri.queryParameters['mode'];
          return LearningSettingsScreen(did: did, mode: mode ?? 'learn');
        },
      ),
      GoRoute(
        path: '/decks/:did/learn',
        name: AppRoutes.learnDeck.name,
        builder: (context, state) {
          final settings = state.extra as LearningSettings;
          final did = state.pathParameters['did']!;
          return LearnScreen(
            did: did,
            settings: settings,
          );
        },
      ),
      GoRoute(
        path: '/decks/:did/test',
        name: AppRoutes.testDeck.name,
        builder: (context, state) {
          final settings = state.extra as LearningSettings;
          final did = state.pathParameters['did']!;
          return TestScreen(
            did: did,
            settings: settings,
          );
        },
      ),
      GoRoute(
        path: '/search',
        name: AppRoutes.search.name,
        builder: (context, state) => SearchScreen(),
      ),
    ],

    // Optional: Xử lý lỗi khi không tìm thấy route
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Trang không tồn tại: ${state.error}'),
      ),
    ),
  );
});
