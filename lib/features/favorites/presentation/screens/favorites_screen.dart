import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../news/presentation/widgets/article_card.dart';
import '../controllers/favorites_controller.dart';

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favorites = ref.watch(favoritesControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Favorites')),

      body: favorites.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.bookmark_border, size: 60),
                  SizedBox(height: 16),
                  Text('No saved articles'),
                ],
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),

              itemCount: favorites.length,

              separatorBuilder: (context, index) {
                return const SizedBox(height: 12);
              },

              itemBuilder: (context, index) {
                final article = favorites[index];

                return ArticleCard(
                  article: article,
                  onTap: () {
                    context.push('/article', extra: article);
                  },
                );
              },
            ),
    );
  }
}
