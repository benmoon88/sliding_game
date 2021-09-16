import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'gamescreen.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [SystemUiOverlay.bottom]);
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  runApp(SlidingPuzzle());
}

class SlidingPuzzle extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: "Sliding Puzzle",
    debugShowCheckedModeBanner: false,
    home: GameScreen(),
  );
}

// RunApp() calls SlidingPuzzle() calls Board() creates _BoardState()