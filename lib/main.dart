import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const LivrosApp());
}

class LivrosApp extends StatelessWidget {
  const LivrosApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Busca de Livros',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.deepPurple,
        appBarTheme: const AppBarTheme(centerTitle: true),
      ),
      home: const HomeScreen(),
    );
  }
}