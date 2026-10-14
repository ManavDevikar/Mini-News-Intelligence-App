import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../news/presentation/widgets/article_card.dart';
import '../controllers/search_controller.dart';

class SearchScreen
    extends ConsumerStatefulWidget {
  const SearchScreen({
    super.key,
  });

  @override
  ConsumerState<SearchScreen>
      createState() =>
          _SearchScreenState();
}

class _SearchScreenState
    extends ConsumerState<
        SearchScreen> {
  late final TextEditingController
      _searchController;

  @override
  void initState() {
    super.initState();

    _searchController =
        TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();

    super.dispose();
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    final searchState =
        ref.watch(
      searchControllerProvider,
    );

    final controller =
        ref.read(
      searchControllerProvider
          .notifier,
    );

    return Scaffold(
      appBar: AppBar(
        title:
            const Text('Search News'),
      ),

      body: Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.all(16),
            child: TextField(
              controller:
                  _searchController,

              onChanged:
                  controller.search,

              decoration:
                  InputDecoration(
                hintText:
                    'Search news...',

                prefixIcon:
                    const Icon(
                  Icons.search,
                ),

                suffixIcon:
                    _searchController
                            .text
                            .isNotEmpty
                        ? IconButton(
                            onPressed: () {
                              _searchController
                                  .clear();

                              controller
                                  .clear();

                              setState(() {});
                            },
                            icon:
                                const Icon(
                              Icons.clear,
                            ),
                          )
                        : null,

                border:
                    OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(
                    16,
                  ),
                ),
              ),
            ),
          ),

          Expanded(
            child: searchState.when(
              data: (articles) {
                if (articles
                    .isEmpty) {
                  return const Center(
                    child: Text(
                      'Search for news articles',
                    ),
                  );
                }

                return ListView.separated(
                  padding:
                      const EdgeInsets
                          .symmetric(
                    horizontal: 16,
                  ),

                  itemCount:
                      articles.length,

                  separatorBuilder:
                      (
                    context,
                    index,
                  ) {
                    return const SizedBox(
                      height: 12,
                    );
                  },

                  itemBuilder:
                      (
                    context,
                    index,
                  ) {
                    final article =
                        articles[index];

                    return ArticleCard(
                      article: article,
                      onTap: () {
                        context.push(
                          '/article',
                          extra: article,
                        );
                      },
                    );
                  },
                );
              },

              loading: () {
                return const Center(
                  child:
                      CircularProgressIndicator(),
                );
              },

              error: (
                error,
                stackTrace,
              ) {
                return Center(
                  child: Padding(
                    padding:
                        const EdgeInsets.all(
                      24,
                    ),
                    child: Column(
                      mainAxisAlignment:
                          MainAxisAlignment
                              .center,
                      children: [
                        const Icon(
                          Icons
                              .cloud_off,
                          size: 48,
                        ),

                        const SizedBox(
                          height: 16,
                        ),

                        const Text(
                          'Search failed',
                          style:
                              TextStyle(
                            fontSize: 18,
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),

                        const SizedBox(
                          height: 8,
                        ),

                        Text(
                          error.toString(),
                          textAlign:
                              TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}