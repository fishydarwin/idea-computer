import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:idea_computer/widget/idea_widget.dart';
import 'package:idea_computer/widget/self_refreshing_network_image.dart';
import 'package:path_provider/path_provider.dart';

class Idea {

  final int id;
  String prompt;

  SelfRefreshingNetworkImage? image;
  String? imageUrl;

  Idea({required this.id, required this.prompt, this.image, this.imageUrl});

  void load() async {
    // get directory
    final directory = await getApplicationDocumentsDirectory();
    var path = directory.path;

    // read metadata
    var metadataFile = File('$path/$id.properties');
    Stream<String> lines = metadataFile.openRead()
        .transform(utf8.decoder)
        .transform(const LineSplitter());

    try {
      await for (var line in lines) {
        var lineSplit = line.split("="); //TODO: sketchy split without limit
        if (lineSplit[0] == "prompt") {
          prompt = lineSplit[1];
        } else if (lineSplit[0] == "image") {
          image = IdeaWidget.safeNetworkImage(lineSplit[1]);
          imageUrl = lineSplit[1];
        }
      }
    } catch (e) { /* we can ignore this */ }
  }

  void save() async {
    // get directory
    final directory = await getApplicationDocumentsDirectory();
    var path = directory.path;

    // write metadata
    var file = File('$path/$id.properties');
    var sink = file.openWrite();
    sink.writeln('prompt=$prompt');
    if (image != null) sink.writeln('image=$imageUrl');
    sink.close();
  }

}
