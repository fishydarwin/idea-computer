import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:idea_computer/widget/idea_widget.dart';

import '../domain/idea.dart';
import '../main.dart';
import '../repository/idea_repo.dart';

class IdeaScreen extends StatefulWidget {
  final Idea idea;
  const IdeaScreen({super.key, required this.idea});

  @override
  State<StatefulWidget> createState() => _IdeaScreenState();
}

class _IdeaScreenState extends State<IdeaScreen> {

  Idea? idea;

  @override
  void initState() {
    super.initState();
    idea = widget.idea;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ICApp.appBar(context),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            /// Main Content
            Text(
              "Generated Idea #${idea!.id}",
              style: GoogleFonts.montserrat(
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
                    idea!.prompt.split(', ').join("\n"),
                    style: GoogleFonts.montserrat(
                        textStyle: Theme.of(context).textTheme.titleLarge,
                        fontWeight: FontWeight.w700
                    )
                )
              ],
            ),

            /// Image Options
            const SizedBox(height: 16),
            if (idea!.image != null)
              idea!.image!,

            if (idea!.image == null)
              const Text("Image was not generated for this prompt."),
            if (idea!.image == null)
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    String url = ICApp.generatedImageURL(
                        idea!.prompt.split(", ").join('_')
                    );

                    idea!.image = IdeaWidget.safeNetworkImage(url);
                    idea!.imageUrl = url;
                    IdeaRepository.add(idea!);
                  });
                },
                child: const Text("Generate Image"),
              ),

            /// Remove
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                IdeaRepository.remove(idea!);
                Navigator.pop(context);
              },
              child: const Text("Delete Idea"),
            ),
          ]
        )
      )
    );
  }
}
