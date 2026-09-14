import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:learn/data/progress_manager.dart';
import 'package:learn/ui/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final progressManager = await ProgressManager.init();

  runApp(MyApp(progressManager: progressManager));
}

class MyApp extends StatelessWidget {
  final ProgressManager progressManager;

  const MyApp({super.key, required this.progressManager});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FlashLingo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.quicksandTextTheme(Theme.of(context).textTheme),
      ),
      home: HomeScreen(progressManager: progressManager),
    );
  }
}
