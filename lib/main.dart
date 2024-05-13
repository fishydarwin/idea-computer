import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:idea_computer/repository/idea_repo.dart';

import 'homepage.dart';

void main() {
  runApp(const ICApp());
}

class ICApp extends StatefulWidget {
  const ICApp({super.key});

  @override
  State<StatefulWidget> createState() => _ICAppState();

  /// Static Appbar Generator since it's used everywhere
  static AppBar appBar(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Theme.of(context).colorScheme.background,
      title: Container(
        padding: const EdgeInsets.all(8),
        child: Row(
          children: <Widget> [

            /// Navigation button/logo
            if (Navigator.canPop(context))
              SizedBox(
                width: 32,
                child: IconButton(
                  onPressed: () => Navigator.pop(context),
                  padding: const EdgeInsets.all(0),
                  icon: Icon(
                    Icons.arrow_back,
                    color: Theme.of(context).colorScheme.primary,
                    size: 32,
                  ),
                ),
              ),
            if (!Navigator.canPop(context))
              Icon(
                Icons.brush,
                color: Theme.of(context).colorScheme.primary,
                size: 32,
              ),

            /// Little padding
            const SizedBox(width: 10),

            /// App Title
            Text(
              "idea computer",
              style: GoogleFonts.rozhaOne(
                  textStyle: Theme.of(context).textTheme.headlineMedium,
                  fontWeight: FontWeight.w600
              ),
            ),

          ],
        ),
      ),
    );
  }

  /// Floating Button helper method
  static FloatingActionButton floatingActionButton(
      BuildContext context, Function()? pressAction,
      Icon icon, String? tooltip)
  {
    return FloatingActionButton(
      foregroundColor: Theme.of(context).colorScheme.inversePrimary,
      backgroundColor: Theme.of(context).colorScheme.primary,
      shape: const CircleBorder(),
      onPressed: pressAction,
      tooltip: tooltip,
      child: icon,
    );
  }

  /// URL that provides the Generated Image.
  static String generatedImageURL(String prompt) =>
      "http://167.235.58.49:5020/generated/$prompt";

}

class _ICAppState extends State<ICApp> {

  bool loaded = false;

  @override
  void initState() {
    super.initState();
    IdeaRepository.load().then((value) => setState(() {
      loaded = value;
    }));
  }

  @override
  Widget build(BuildContext context) {

    if (!loaded) {
      return MaterialApp(
        title: 'Idea Computer',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.red.shade900),
          useMaterial3: true,
          textTheme: GoogleFonts.aliceTextTheme(),
        ),
        home: const Center(
          child: CircularProgressIndicator(),
        ),
        debugShowCheckedModeBanner: false,
      );
    }

    // make material app
    return MaterialApp(
      title: 'Idea Computer',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red.shade900),
        useMaterial3: true,
        textTheme: GoogleFonts.aliceTextTheme(),
      ),
      home: const ICHomePage(),
      debugShowCheckedModeBanner: false,
    );

  }
}
