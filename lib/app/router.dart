import 'package:go_router/go_router.dart';

import '../features/auth/presentation/login_screen.dart';
import '../features/news/presentation/news_feed_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/login',

  routes: [
    GoRoute(
      path: '/login',

      builder: (context, state) {
        return const LoginScreen();
      },
    ),

    GoRoute(
      path: '/home',

      builder: (context, state) {
        return const NewsFeedScreen();
      },
    ),
  ],
);