import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

import '../domain/idea.dart';

class IdeaRepository {

  static int _lastId = 0;
  static final Map<int, Idea> _ideas = <int, Idea> {};
  static nextId() => _lastId++;

  static Idea? get(int id) => _ideas[id];
  static int length() => _ideas.length;
  static Idea? at(int index) =>
      _ideas.entries.elementAt(_ideas.length - index - 1).value;
  static List<Idea> ordered() =>
      _ideas.entries.map((e) => e.value).toList().reversed.toList();

  static void add(Idea idea) {
    _ideas[idea.id] = idea;
    save();
  }

  static void remove(Idea idea) {
    _ideas.remove(idea.id);
    save();
  }

  static bool loaded = false;
  static Future<bool> load() async {

    final directory = await getApplicationDocumentsDirectory();
    var path = directory.path;

    // load file list
    var fileList = File('$path/__all_ideas.properties');
    if (!fileList.existsSync()) {
      loaded = true;
      return loaded;
    }

    Stream<String> lines = fileList.openRead()
        .transform(utf8.decoder)
        .transform(const LineSplitter());

    bool readFirstLine = false;
    try {
      await for (var line in lines) {
        if (!readFirstLine) {
          _lastId = int.parse(line);
          readFirstLine = true;
        } else {
          // load each idea
          Idea idea = Idea(id: int.parse(line), prompt: "");
          idea.load();
          _ideas[idea.id] = idea;
        }
      }
    } catch (e) { /* we can ignore this */ }
    loaded = true;
    return loaded;
  }

  static void save() async {
    // get directory
    final directory = await getApplicationDocumentsDirectory();
    var path = directory.path;

    // save all ideas
    for (Idea idea in _ideas.values) {
      idea.save();
    }

    // write all files
    var file = File('$path/__all_ideas.properties');
    var sink = file.openWrite();
    sink.writeln(_lastId);
    for (int ideaId in _ideas.keys) {
      sink.writeln(ideaId);
    }
    sink.close();
  }

}
