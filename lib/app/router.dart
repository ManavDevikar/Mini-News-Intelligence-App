import 'package:go_router/go_router.dart';

import '../features/auth/presentation/screens/login_screen.dart';
import '../features/news/domain/entities/article.dart';
import '../features/news/presentation/screens/article_detail_screen.dart';
import '../features/news/presentation/screens/news_feed_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/login',

  routes: [
    // Login Screen
    GoRoute(
      path: '/login',
      builder: (context, state) {
        return const LoginScreen();
      },
    ),

    // News Feed Screen
    GoRoute(
      path: '/home',
      builder: (context, state) {
        return const NewsFeedScreen();
      },
    ),

    // Article Detail Screen
    GoRoute(
      path: '/article',
      builder: (context, state) {
        final article = state.extra as Article;

        return ArticleDetailScreen(
          article: article,
        );
      },
    ),
  ],
);