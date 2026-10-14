import 'package:flutter/material.dart';

import 'router.dart';
import 'theme.dart';

class NewsIntelligenceApp extends StatelessWidget {
  const NewsIntelligenceApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'News Intelligence',

      debugShowCheckedModeBanner: false,

      theme: AppTheme.lightTheme,

      routerConfig: appRouter,
    );
  }
}