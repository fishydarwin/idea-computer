import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:idea_computer/domain/idea.dart';
import 'package:idea_computer/widget/self_refreshing_network_image.dart';

class IdeaWidget extends StatefulWidget {
  final Idea idea;
  const IdeaWidget({super.key, required this.idea});

  @override
  State<StatefulWidget> createState() => _IdeaWidgetState();

  static SelfRefreshingNetworkImage safeNetworkImage(String url) {
    return SelfRefreshingNetworkImage(url: url);
  }
}

class _IdeaWidgetState extends State<IdeaWidget>{

  Idea? idea;

  @override
  void initState() {
    super.initState();
    idea = widget.idea;
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget> [
          Row(
            children: [
              Icon(
                Icons.textsms_rounded,
                size: 20,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 4),
              Text(
                idea!.prompt,
                style: Theme.of(context).textTheme.titleLarge,
              )
            ],
          ),
          Text(
            "Generated Idea #${idea!.id}",
            style: GoogleFonts.montserrat(),
          ),
          if (idea!.image != null)
            Center(
              child: idea!.image!
            )
          else const Text('Image was not generated for this prompt.'),
        ],
      ),
    );
  }

}