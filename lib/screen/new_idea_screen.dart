import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:idea_computer/main.dart';
import 'package:idea_computer/repository/idea_repo.dart';
import 'package:idea_computer/widget/idea_widget.dart';

import '../domain/idea.dart';

class NewIdeaScreen extends StatefulWidget {
  const NewIdeaScreen({super.key});

  @override
  State<StatefulWidget> createState() => _NewIdeaScreenState();
}

class _NewIdeaScreenState extends State<NewIdeaScreen> {

  Future<String> _loadNounsList() async {
    return await rootBundle.loadString('assets/nouns-list.txt');
  }

  Future<String> _loadColorsList() async {
    return await rootBundle.loadString('assets/colors-list.txt');
  }

  Future<String> _loadAdjectivesList() async {
    return await rootBundle.loadString('assets/adjectives-list.txt');
  }

  Future<List<String>> _generateRandomPrompt() async {
    String nounsRaw = await _loadNounsList();
    List<String> nounsList = nounsRaw.split("\n");

    String colorsRaw = await _loadColorsList();
    List<String> colorsList = colorsRaw.split("\n");

    String adjectivesRaw = await _loadAdjectivesList();
    List<String> adjectivesList = adjectivesRaw.split("\n");

    Random random = Random();
    return [
      colorsList[random.nextInt(colorsList.length)],
      adjectivesList[random.nextInt(adjectivesList.length)],
      nounsList[random.nextInt(nounsList.length)],
    ];
  }

  Future<List<String>>? _prompt;

  /// Init
  @override
  void initState() {
    super.initState();
    _prompt = _generateRandomPrompt();
  }

  /// Build
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ICApp.appBar(context),
      body: FutureBuilder<List<String>>(
        future: _prompt,
        builder: (context, snapshot) {
          return snapshot.hasData
              ?
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    /// PROMPT
                    Text(
                        "Here's a random prompt:",
                        style: GoogleFonts.alice(
                            textStyle: Theme.of(context).textTheme.titleLarge,
                        )
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.format_quote,
                          size: 72,
                        ),
                        Text(
                            snapshot.data!.join("\n"),
                            style: GoogleFonts.montserrat(
                              textStyle: Theme.of(context).textTheme.titleLarge,
                              fontWeight: FontWeight.w700
                            )
                        )
                      ],
                    ),

                    /// GENERATE IMAGE
                    const SizedBox(height: 64),
                    Text(
                        "Like it? Generate an image!",
                        style: GoogleFonts.montserrat(
                          textStyle: Theme.of(context).textTheme.bodyMedium,
                        ),
                    ),
                    ElevatedButton(
                        onPressed: () {
                          String url =
                            ICApp.generatedImageURL(snapshot.data!.join("_"));

                          IdeaRepository.add(Idea(
                            id: IdeaRepository.nextId(),
                            prompt: snapshot.data!.join(", "),
                            image: IdeaWidget.safeNetworkImage(url),
                            imageUrl: url
                          ));

                          Navigator.pop(context);
                        },
                        child: const Text("Generate Image"),
                    ),

                    /// JUST SAVE
                    const SizedBox(height: 16),
                    Text(
                        "... or just save the prompt.",
                        style: GoogleFonts.montserrat(
                          textStyle: Theme.of(context).textTheme.bodyMedium,
                        )
                    ),
                    ElevatedButton(
                      onPressed: () {
                        IdeaRepository.add(Idea(
                          id: IdeaRepository.nextId(),
                          prompt: snapshot.data!.join(", ")
                        ));

                        Navigator.pop(context);
                      },
                      child: const Text("Save Prompt"),
                    ),

                    /// SKIP PROMPT
                    const SizedBox(height: 64),
                    Text(
                        "Don't like it?",
                        style: GoogleFonts.montserrat(
                          textStyle: Theme.of(context).textTheme.bodyMedium,
                        )
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _prompt = _generateRandomPrompt();
                        });
                      },
                      child: const Text("Try a New Prompt"),
                    ),
                  ]
                )
              )
              :
              const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator.adaptive(),
                  Text("Generating a new prompt...")
                ],
              );
        }
      ),
    );
  }
}
