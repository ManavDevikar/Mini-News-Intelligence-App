import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../domain/entities/article.dart';
import '../../../favorites/presentation/controllers/favorites_controller.dart';

class ArticleDetailScreen extends ConsumerWidget {
  const ArticleDetailScreen({
    super.key,
    required this.article,
  });

  final Article article;

  Future<void> _openArticle() async {
    final uri = Uri.tryParse(article.url);

    if (uri == null) {
      return;
    }

    if (!await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    )) {
      return;
    }
  }

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    // Get the current list of favorite articles.
    final favorites = ref.watch(
      favoritesControllerProvider,
    );

    // Check whether the current article is already saved.
    final isFavorite = favorites.any(
      (item) => item.id == article.id,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Article'),

        // Favorite button
        actions: [
          IconButton(
            tooltip: isFavorite
                ? 'Remove from favorites'
                : 'Save to favorites',
            onPressed: () async {
              await ref
                  .read(
                    favoritesControllerProvider
                        .notifier,
                  )
                  .toggleFavorite(article);

              // Show feedback to the user
              if (!context.mounted) {
                return;
              }

              ScaffoldMessenger.of(context)
                  .hideCurrentSnackBar();

              ScaffoldMessenger.of(context)
                  .showSnackBar(
                SnackBar(
                  content: Text(
                    isFavorite
                        ? 'Removed from favorites'
                        : 'Added to favorites',
                  ),
                  behavior:
                      SnackBarBehavior.floating,
                  duration:
                      const Duration(seconds: 2),
                ),
              );
            },
            icon: Icon(
              isFavorite
                  ? Icons.bookmark
                  : Icons.bookmark_border,
            ),
          ),
        ],
      ),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            _buildImage(),

            Padding(
              padding:
                  const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    article.sourceName,
                    style: Theme.of(context)
                        .textTheme
                        .labelLarge
                        ?.copyWith(
                          color: Theme.of(context)
                              .colorScheme
                              .primary,
                          fontWeight:
                              FontWeight.w600,
                        ),
                  ),

                  const SizedBox(
                    height: 12,
                  ),

                  Text(
                    article.title,
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall
                        ?.copyWith(
                          fontWeight:
                              FontWeight.w700,
                          height: 1.2,
                        ),
                  ),

                  const SizedBox(
                    height: 12,
                  ),

                  Text(
                    _formatDate(
                      article.publishedAt,
                    ),
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(
                          color: Colors.grey,
                        ),
                  ),

                  const SizedBox(
                    height: 24,
                  ),

                  Text(
                    article.description,
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(
                          height: 1.6,
                          fontWeight:
                              FontWeight.w500,
                        ),
                  ),

                  const SizedBox(
                    height: 20,
                  ),

                  Text(
                    article.content,
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(
                          height: 1.7,
                        ),
                  ),

                  const SizedBox(
                    height: 32,
                  ),

                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton.icon(
                      onPressed: _openArticle,
                      icon: const Icon(
                        Icons.open_in_new,
                      ),
                      label: const Text(
                        'Read Full Article',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage() {
    if (article.imageUrl.isEmpty) {
      return Container(
        height: 240,
        width: double.infinity,
        color: Colors.grey.shade200,
        child: const Icon(
          Icons.image_not_supported_outlined,
          size: 50,
        ),
      );
    }

    return Image.network(
      article.imageUrl,
      height: 240,
      width: double.infinity,
      fit: BoxFit.cover,
      errorBuilder: (
        context,
        error,
        stackTrace,
      ) {
        return Container(
          height: 240,
          width: double.infinity,
          color: Colors.grey.shade200,
          child: const Icon(
            Icons.broken_image_outlined,
            size: 50,
          ),
        );
      },
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}