import 'dart:async';

import 'package:flat_list/flat_list.dart';
import 'package:flutter/material.dart';
import 'package:idea_computer/repository/idea_repo.dart';
import 'package:idea_computer/screen/idea_screen.dart';
import 'package:idea_computer/screen/new_idea_screen.dart';
import 'package:idea_computer/widget/idea_widget.dart';

import 'domain/idea.dart';
import 'main.dart';

class ICHomePage extends StatefulWidget {
  const ICHomePage({super.key});

  @override
  State<StatefulWidget> createState() => _ICHomePageState();
}

class _ICHomePageState extends State<ICHomePage> {

  FutureOr _whenReturning(dynamic value) {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      /// App Bar
      appBar: ICApp.appBar(context),

      /// Body
      body:
      Align(
        alignment: Alignment.topCenter,
        child: IdeaRepository.length() > 0
          ?
          FlatList(
              data: IdeaRepository.ordered(),
              buildItem: (idea, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                            IdeaScreen(idea: idea),
                      ),
                    ).then(_whenReturning);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    child: IdeaWidget(idea: idea)
                  ),
                );
              }
          )
          :
          const Center(
            child: Text("No ideas have been generated yet... (>_<)"),
          )
      ),

      /// Floating Button
      floatingActionButton: ICApp.floatingActionButton(context,
       () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const NewIdeaScreen(),
          ),
        ).then(_whenReturning);
       }, const Icon(Icons.playlist_add), "New Idea"),

    );
  }
}
