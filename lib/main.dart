import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'views/home_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: LocalNetworkTransferApp()));
}

class LocalNetworkTransferApp extends StatelessWidget {
  const LocalNetworkTransferApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Local Phone & Printer Transfer',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2563EB),
          brightness: Brightness.light,
        ),
        cardTheme: const CardThemeData(elevation: 1, margin: EdgeInsets.zero),
      ),
      home: const HomeView(),
    );
  }
}
