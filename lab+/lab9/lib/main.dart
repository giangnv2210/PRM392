import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(const LocalJsonPracticeApp());
}

class AssetMovie {
  final int id;
  final String title;
  final String genre;
  final int year;

  const AssetMovie({
    required this.id,
    required this.title,
    required this.genre,
    required this.year,
  });

  factory AssetMovie.fromJson(Map<String, dynamic> json) {
    return AssetMovie(
      id: json['id'] as int,
      title: json['title'] as String,
      genre: json['genre'] as String,
      year: json['year'] as int,
    );
  }
}

class LocalNote {
  final int id;
  final String title;
  final String note;

  const LocalNote({required this.id, required this.title, required this.note});

  factory LocalNote.fromJson(Map<String, dynamic> json) {
    return LocalNote(
      id: json['id'] as int,
      title: json['title'] as String,
      note: json['note'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{'id': id, 'title': title, 'note': note};
  }
}

class LocalJsonStorageService {
  Future<File> get dataFile async {
    final Directory directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/lab9_notes.json');
  }

  Future<List<LocalNote>> readNotes() async {
    final File file = await dataFile;

    if (!await file.exists()) {
      final List<LocalNote> starterNotes = <LocalNote>[
        const LocalNote(id: 1, title: 'Buy popcorn', note: 'For movie night'),
        const LocalNote(
          id: 2,
          title: 'Watch trailer',
          note: 'Check new sci-fi releases',
        ),
      ];
      await writeNotes(starterNotes);
      return starterNotes;
    }

    final String rawText = await file.readAsString();
    if (rawText.trim().isEmpty) {
      return <LocalNote>[];
    }

    final List<dynamic> decoded = jsonDecode(rawText) as List<dynamic>;
    return decoded
        .map((dynamic item) => LocalNote.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<void> writeNotes(List<LocalNote> notes) async {
    final File file = await dataFile;
    final String rawText = jsonEncode(
      notes.map((LocalNote note) => note.toJson()).toList(),
    );
    await file.writeAsString(rawText);
  }
}

class LocalJsonPracticeApp extends StatelessWidget {
  const LocalJsonPracticeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lab 9 Local JSON',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF3C7A4A)),
        useMaterial3: true,
      ),
      home: const JsonHomeScreen(),
    );
  }
}

class JsonHomeScreen extends StatefulWidget {
  const JsonHomeScreen({super.key});

  @override
  State<JsonHomeScreen> createState() => _JsonHomeScreenState();
}

class _JsonHomeScreenState extends State<JsonHomeScreen>
    with SingleTickerProviderStateMixin {
  late final TabController tabController;
  late final LocalJsonStorageService storageService;
  late final Future<List<AssetMovie>> assetMoviesFuture;

  List<LocalNote> savedNotes = <LocalNote>[];
  bool isLoadingLocalNotes = true;
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
    storageService = LocalJsonStorageService();
    assetMoviesFuture = loadAssetMovies();
    loadLocalNotes();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  Future<List<AssetMovie>> loadAssetMovies() async {
    final String rawJson = await rootBundle.loadString(
      'assets/data/sample_movies.json',
    );
    final List<dynamic> decoded = jsonDecode(rawJson) as List<dynamic>;
    return decoded
        .map(
          (dynamic item) => AssetMovie.fromJson(item as Map<String, dynamic>),
        )
        .toList();
  }

  Future<void> loadLocalNotes() async {
    final List<LocalNote> notes = await storageService.readNotes();

    if (!mounted) {
      return;
    }

    setState(() {
      savedNotes = notes;
      isLoadingLocalNotes = false;
    });
  }

  Future<void> saveLocalNotes({String? message}) async {
    await storageService.writeNotes(savedNotes);

    if (!mounted || message == null) {
      return;
    }

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> openNoteDialog({LocalNote? note}) async {
    final TextEditingController titleController = TextEditingController(
      text: note?.title ?? '',
    );
    final TextEditingController detailController = TextEditingController(
      text: note?.note ?? '',
    );

    final bool? shouldSave = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(note == null ? 'Add item' : 'Edit item'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: detailController,
                decoration: const InputDecoration(labelText: 'Note'),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Save'),
            ),
          ],
        );
      },
    );

    if (shouldSave != true) {
      return;
    }

    final String title = titleController.text.trim();
    final String detail = detailController.text.trim();

    if (title.isEmpty || detail.isEmpty) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Title and note are required.')),
      );
      return;
    }

    setState(() {
      if (note == null) {
        final int nextId = savedNotes.isEmpty
            ? 1
            : savedNotes
                      .map((LocalNote item) => item.id)
                      .reduce((int a, int b) => a > b ? a : b) +
                  1;

        savedNotes.add(LocalNote(id: nextId, title: title, note: detail));
      } else {
        final int index = savedNotes.indexWhere(
          (LocalNote item) => item.id == note.id,
        );
        savedNotes[index] = LocalNote(id: note.id, title: title, note: detail);
      }
    });

    await saveLocalNotes(message: 'Saved to local JSON file.');
  }

  Future<void> deleteNote(LocalNote note) async {
    final bool? confirmDelete = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete item'),
          content: Text('Delete "${note.title}"?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirmDelete != true) {
      return;
    }

    setState(() {
      savedNotes.removeWhere((LocalNote item) => item.id == note.id);
    });

    await saveLocalNotes(message: 'Item deleted and JSON updated.');
  }

  @override
  Widget build(BuildContext context) {
    final List<LocalNote> filteredNotes = savedNotes.where((LocalNote note) {
      final String keyword = searchQuery.toLowerCase();
      return note.title.toLowerCase().contains(keyword) ||
          note.note.toLowerCase().contains(keyword);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Local JSON Storage'),
        bottom: TabBar(
          controller: tabController,
          tabs: const <Tab>[
            Tab(text: 'Assets JSON'),
            Tab(text: 'Local CRUD'),
          ],
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              saveLocalNotes(message: 'Manual save completed.');
            },
            icon: const Icon(Icons.save_outlined),
            tooltip: 'Save now',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: openNoteDialog,
        child: const Icon(Icons.add),
      ),
      body: TabBarView(
        controller: tabController,
        children: <Widget>[
          FutureBuilder<List<AssetMovie>>(
            future: assetMoviesFuture,
            builder:
                (
                  BuildContext context,
                  AsyncSnapshot<List<AssetMovie>> snapshot,
                ) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return const Center(
                      child: Text('Could not load asset JSON.'),
                    );
                  }

                  final List<AssetMovie> movies =
                      snapshot.data ?? <AssetMovie>[];

                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: movies.length,
                    itemBuilder: (BuildContext context, int index) {
                      final AssetMovie movie = movies[index];

                      return Card(
                        child: ListTile(
                          leading: CircleAvatar(child: Text('${movie.id}')),
                          title: Text(movie.title),
                          subtitle: Text('${movie.genre} • ${movie.year}'),
                        ),
                      );
                    },
                  );
                },
          ),
          Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(16),
                child: TextField(
                  decoration: const InputDecoration(
                    labelText: 'Search local notes',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (String value) {
                    setState(() {
                      searchQuery = value;
                    });
                  },
                ),
              ),
              Expanded(
                child: isLoadingLocalNotes
                    ? const Center(child: CircularProgressIndicator())
                    : ListView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                        itemCount: filteredNotes.length,
                        itemBuilder: (BuildContext context, int index) {
                          final LocalNote note = filteredNotes[index];

                          return Card(
                            child: ListTile(
                              title: Text(note.title),
                              subtitle: Text(note.note),
                              leading: CircleAvatar(child: Text('${note.id}')),
                              trailing: Wrap(
                                spacing: 4,
                                children: <Widget>[
                                  IconButton(
                                    onPressed: () => openNoteDialog(note: note),
                                    icon: const Icon(Icons.edit_outlined),
                                  ),
                                  IconButton(
                                    onPressed: () => deleteNote(note),
                                    icon: const Icon(Icons.delete_outline),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
