import 'package:flutter/material.dart';

import '../../domain/entities/article.dart';

class ArticleCard extends StatelessWidget {
  const ArticleCard({
    super.key,
    required this.article,
    required this.onTap,
  });

  final Article article;
  final VoidCallback onTap;

  @override
  Widget build(
    BuildContext context,
  ) {
    return Card(
      clipBehavior:
          Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding:
              const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              _buildImage(),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      article.sourceName,
                      maxLines: 1,
                      overflow:
                          TextOverflow.ellipsis,
                      style: Theme.of(
                        context,
                      )
                          .textTheme
                          .labelMedium
                          ?.copyWith(
                            fontWeight:
                                FontWeight.w600,
                            color: Theme.of(
                              context,
                            )
                                .colorScheme
                                .primary,
                          ),
                    ),

                    const SizedBox(height: 6),

                    Text(
                      article.title,
                      maxLines: 3,
                      overflow:
                          TextOverflow.ellipsis,
                      style: Theme.of(
                        context,
                      )
                          .textTheme
                          .titleMedium
                          ?.copyWith(
                            fontWeight:
                                FontWeight.w700,
                          ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      article.description,
                      maxLines: 2,
                      overflow:
                          TextOverflow.ellipsis,
                      style: Theme.of(
                        context,
                      )
                          .textTheme
                          .bodySmall
                          ?.copyWith(
                            color:
                                Colors.grey.shade600,
                            height: 1.4,
                          ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      _formatDate(
                        article.publishedAt,
                      ),
                      style: Theme.of(
                        context,
                      )
                          .textTheme
                          .labelSmall
                          ?.copyWith(
                            color:
                                Colors.grey.shade500,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImage() {
    return ClipRRect(
      borderRadius:
          BorderRadius.circular(12),
      child: SizedBox(
        width: 110,
        height: 120,
        child: article.imageUrl.isEmpty
            ? Container(
                color:
                    Colors.grey.shade200,
                child: const Icon(
                  Icons.image_not_supported,
                ),
              )
            : Image.network(
                article.imageUrl,
                fit: BoxFit.cover,
                errorBuilder:
                    (
                  context,
                  error,
                  stackTrace,
                ) {
                  return Container(
                    color:
                        Colors.grey.shade200,
                    child: const Icon(
                      Icons.broken_image_outlined,
                    ),
                  );
                },
              ),
      ),
    );
  }

  String _formatDate(
    DateTime date,
  ) {
    final now = DateTime.now();

    final difference =
        now.difference(date);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes} min ago';
    }

    if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    }

    return '${date.day}/${date.month}/${date.year}';
  }
}