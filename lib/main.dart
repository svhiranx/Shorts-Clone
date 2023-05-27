import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shortsclone/models/provider.dart';
import 'package:shortsclone/screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => VideoProvider(),
          ),
          ChangeNotifierProvider(
            create: (_) => PageProvider(),
          )
        ],
        builder: (context, child) => MaterialApp(
              theme: ThemeData(
                textTheme: GoogleFonts.dmSansTextTheme(),
                colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
                useMaterial3: true,
              ),
              home: const HomeScreen(),
            ));
  }
}
