import 'package:flutter/material.dart';
import 'scanner_page.dart';

void main() {
  runApp(const DocumentScannerApp());
}

class DocumentScannerApp extends StatelessWidget {
  const DocumentScannerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DocScan Pro',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
          centerTitle: true,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color(0xFF2196F3),
          foregroundColor: Colors.white,
        ),
        cardTheme: CardThemeData(  // Changed from CardTheme to CardThemeData
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      home: const ScannerPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}