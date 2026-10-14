import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../auth/presentation/controllers/auth_controller.dart';
import '../controllers/news_controller.dart';
import '../widgets/article_card.dart';

class NewsFeedScreen extends ConsumerStatefulWidget {
  const NewsFeedScreen({super.key});

  @override
  ConsumerState<NewsFeedScreen> createState() => _NewsFeedScreenState();
}

class _NewsFeedScreenState extends ConsumerState<NewsFeedScreen> {
  final ScrollController _scrollController = ScrollController();

  final categories = const [
    'business',
    'technology',
    'science',
    'health',
    'sports',
    'entertainment',
  ];

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (!_scrollController.hasClients) {
      return;
    }

    final position = _scrollController.position;

    if (position.pixels >= position.maxScrollExtent - 400) {
      ref.read(newsControllerProvider.notifier).loadMore();
    }
  }

  Future<void> _logout() async {
    await ref.read(authControllerProvider.notifier).logout();

    if (!mounted) {
      return;
    }

    context.go('/login');
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to logout?'),
          actionsPadding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton(
                  onPressed: () {
                    Navigator.of(dialogContext).pop();
                  },
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 12),
                FilledButton(
                  style: FilledButton.styleFrom(
                    minimumSize: const Size(0, 44),
                    backgroundColor: Theme.of(context).colorScheme.error,
                    foregroundColor: Theme.of(context).colorScheme.onError,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                  ),
                  onPressed: () {
                    Navigator.of(dialogContext).pop();

                    _logout();
                  },
                  child: const Text('Logout'),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final newsState = ref.watch(newsControllerProvider);

    final controller = ref.read(newsControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('News Intelligence'),
        actions: [
          IconButton(
            tooltip: 'Search',
            onPressed: () {
              context.push('/search');
            },
            icon: const Icon(Icons.search),
          ),
          IconButton(
            tooltip: 'Favorites',
            onPressed: () {
              context.push('/favorites');
            },
            icon: const Icon(Icons.bookmark_outline),
          ),
          IconButton(
            tooltip: 'Logout',
            onPressed: () {
              _showLogoutDialog(context);
            },
            icon: const Icon(Icons.logout_rounded),
          ),
        ],
      ),

      body: Column(
        children: [
          _buildCategories(controller),

          Expanded(
            child: newsState.when(
              loading: () {
                return const Center(child: CircularProgressIndicator());
              },

              error: (error, stackTrace) {
                return _buildError(error.toString());
              },

              data: (articles) {
                if (articles.isEmpty) {
                  return const Center(child: Text('No news available.'));
                }

                return RefreshIndicator(
                  onRefresh: controller.refreshNews,

                  child: ListView.separated(
                    controller: _scrollController,

                    padding: const EdgeInsets.all(16),

                    itemCount:
                        articles.length + (controller.isLoadingMore ? 1 : 0),

                    separatorBuilder: (context, index) {
                      return const SizedBox(height: 12);
                    },

                    itemBuilder: (context, index) {
                      if (index >= articles.length) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(16),
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }

                      final article = articles[index];

                      return ArticleCard(
                        article: article,
                        onTap: () {
                          context.push('/article', extra: article);
                        },
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategories(NewsController controller) {
    return SizedBox(
      height: 52,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,

        padding: const EdgeInsets.symmetric(horizontal: 16),

        itemCount: categories.length,

        separatorBuilder: (context, index) {
          return const SizedBox(width: 8);
        },

        itemBuilder: (context, index) {
          final category = categories[index];

          final isSelected = controller.selectedCategory == category;

          return ChoiceChip(
            label: Text(_capitalize(category)),

            selected: isSelected,

            onSelected: (_) {
              controller.changeCategory(category);
            },
          );
        },
      ),
    );
  }

  Widget _buildError(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.cloud_off_outlined, size: 48),

            const SizedBox(height: 16),

            const Text(
              'Unable to load news',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            Text(message, textAlign: TextAlign.center),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                ref.read(newsControllerProvider.notifier).refreshNews();
              },
              child: const Text('Try again'),
            ),
          ],
        ),
      ),
    );
  }

  String _capitalize(String value) {
    return value[0].toUpperCase() + value.substring(1);
  }
}
