import 'package:book/data/sample_books.dart';
import 'package:book/models/reader_models.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  List<ReaderBook> _books = <ReaderBook>[];
  final Map<String, int> _currentChapterByBook = <String, int>{};
  final Map<String, List<ChapterBookmark>> _bookmarksByBook =
      <String, List<ChapterBookmark>>{};
  bool _isLoading = true;
  String? _loadError;

  @override
  void initState() {
    super.initState();
    _loadBooks();
  }

  Future<void> _loadBooks() async {
    try {
      final List<ReaderBook> books = await loadSampleBooks();

      if (!mounted) {
        return;
      }

      setState(() {
        _books = books;
        _currentChapterByBook.clear();
        _bookmarksByBook.clear();

        for (final ReaderBook book in books) {
          _currentChapterByBook[book.id] = 0;
          _bookmarksByBook[book.id] = <ChapterBookmark>[];
        }

        _isLoading = false;
      });
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _loadError = error.toString();
        _isLoading = false;
      });
    }
  }

  Widget _buildHome() {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_loadError != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Pocket Library')),
        body: Padding(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: Text(
              'Could not load the bundled book.\n\n$_loadError',
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }

    return LibraryScreen(
      books: _books,
      currentChapterByBook: _currentChapterByBook,
      bookmarksByBook: _bookmarksByBook,
      onOpenBook: _openBook,
    );
  }

  void _openBook(ReaderBook book) {
    _navigatorKey.currentState!.push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) => ReaderScreen(
          book: book,
          initialChapterIndex: _currentChapterByBook[book.id] ?? 0,
          initialBookmarks: List<ChapterBookmark>.from(
            _bookmarksByBook[book.id] ?? <ChapterBookmark>[],
          ),
          onChapterChanged: (int chapterIndex) {
            setState(() {
              _currentChapterByBook[book.id] = chapterIndex;
            });
          },
          onBookmarksChanged: (List<ChapterBookmark> bookmarks) {
            setState(() {
              _bookmarksByBook[book.id] = List<ChapterBookmark>.from(bookmarks);
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Book Reader',
      debugShowCheckedModeBanner: false,
      navigatorKey: _navigatorKey,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF44617B)),
        scaffoldBackgroundColor: const Color(0xFFF7F2EA),
        useMaterial3: true,
      ),
      home: _buildHome(),
    );
  }
}

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({
    required this.books,
    required this.currentChapterByBook,
    required this.bookmarksByBook,
    required this.onOpenBook,
    super.key,
  });

  final List<ReaderBook> books;
  final Map<String, int> currentChapterByBook;
  final Map<String, List<ChapterBookmark>> bookmarksByBook;
  final ValueChanged<ReaderBook> onOpenBook;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pocket Library'), centerTitle: false),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: <Widget>[
          Text(
            'Choose a book and keep your place with quick bookmarks.',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 16),
          for (final ReaderBook book in books)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: _BookCard(
                book: book,
                currentChapterIndex: currentChapterByBook[book.id] ?? 0,
                bookmarkCount: bookmarksByBook[book.id]?.length ?? 0,
                onTap: () => onOpenBook(book),
              ),
            ),
        ],
      ),
    );
  }
}

class _BookCard extends StatelessWidget {
  const _BookCard({
    required this.book,
    required this.currentChapterIndex,
    required this.bookmarkCount,
    required this.onTap,
  });

  final ReaderBook book;
  final int currentChapterIndex;
  final int bookmarkCount;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final BookChapter currentChapter = book.chapters[currentChapterIndex];

    return Card(
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: 72,
                    height: 104,
                    decoration: BoxDecoration(
                      color: book.coverColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.all(12),
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        book.title,
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          book.title,
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          book.author,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          book.description,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: <Widget>[
                  _InfoChip(
                    icon: Icons.menu_book_outlined,
                    label: '${book.chapterCount} chapters',
                  ),
                  _InfoChip(
                    icon: Icons.bookmark_outline,
                    label: '$bookmarkCount bookmarks',
                  ),
                  _InfoChip(
                    icon: Icons.history_edu_outlined,
                    label: 'Continue: ${currentChapter.title}',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(icon, size: 18),
          const SizedBox(width: 8),
          Text(label),
        ],
      ),
    );
  }
}

class ReaderScreen extends StatefulWidget {
  const ReaderScreen({
    required this.book,
    required this.initialChapterIndex,
    required this.initialBookmarks,
    required this.onChapterChanged,
    required this.onBookmarksChanged,
    super.key,
  });

  final ReaderBook book;
  final int initialChapterIndex;
  final List<ChapterBookmark> initialBookmarks;
  final ValueChanged<int> onChapterChanged;
  final ValueChanged<List<ChapterBookmark>> onBookmarksChanged;

  @override
  State<ReaderScreen> createState() => _ReaderScreenState();
}

class _ReaderScreenState extends State<ReaderScreen> {
  late int _currentChapterIndex;
  late List<ChapterBookmark> _bookmarks;

  @override
  void initState() {
    super.initState();
    _currentChapterIndex = widget.initialChapterIndex;
    _bookmarks = List<ChapterBookmark>.from(widget.initialBookmarks);
  }

  BookChapter get _currentChapter => widget.book.chapters[_currentChapterIndex];

  bool get _isCurrentChapterBookmarked {
    return _bookmarks.any(
      (ChapterBookmark bookmark) =>
          bookmark.chapterIndex == _currentChapterIndex,
    );
  }

  void _jumpToChapter(int index) {
    if (index < 0 || index >= widget.book.chapterCount) {
      return;
    }

    setState(() {
      _currentChapterIndex = index;
    });
    widget.onChapterChanged(index);
  }

  void _toggleBookmark() {
    final int existingIndex = _bookmarks.indexWhere(
      (ChapterBookmark bookmark) =>
          bookmark.chapterIndex == _currentChapterIndex,
    );

    setState(() {
      if (existingIndex >= 0) {
        _bookmarks.removeAt(existingIndex);
      } else {
        _bookmarks.add(
          ChapterBookmark(
            id: '${widget.book.id}-${_currentChapterIndex + 1}',
            bookId: widget.book.id,
            chapterIndex: _currentChapterIndex,
            chapterTitle: _currentChapter.title,
            excerpt: _currentChapter.preview,
            createdAt: DateTime.now(),
          ),
        );
        _bookmarks.sort(
          (ChapterBookmark a, ChapterBookmark b) =>
              a.chapterIndex.compareTo(b.chapterIndex),
        );
      }
    });

    widget.onBookmarksChanged(List<ChapterBookmark>.from(_bookmarks));

    final String message = _isCurrentChapterBookmarked
        ? 'Bookmark added for ${_currentChapter.title}.'
        : 'Bookmark removed from ${_currentChapter.title}.';

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _showContentsSheet() async {
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (BuildContext context) {
        return SafeArea(
          child: ListView.builder(
            itemCount: widget.book.chapterCount,
            itemBuilder: (BuildContext context, int index) {
              final BookChapter chapter = widget.book.chapters[index];
              final bool isCurrent = index == _currentChapterIndex;

              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: isCurrent
                      ? widget.book.coverColor
                      : Theme.of(context).colorScheme.surfaceContainerHighest,
                  foregroundColor: isCurrent ? Colors.white : null,
                  child: Text('${index + 1}'),
                ),
                title: Text(chapter.title),
                subtitle: Text(
                  chapter.preview,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: isCurrent ? const Icon(Icons.play_arrow) : null,
                onTap: () {
                  Navigator.of(context).pop();
                  _jumpToChapter(index);
                },
              );
            },
          ),
        );
      },
    );
  }

  Future<void> _showBookmarksSheet() async {
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (BuildContext context) {
        if (_bookmarks.isEmpty) {
          return const SafeArea(
            child: SizedBox(
              height: 180,
              child: Center(
                child: Text(
                  'No bookmarks yet. Save a chapter to return later.',
                ),
              ),
            ),
          );
        }

        return SafeArea(
          child: ListView(
            children: _bookmarks.map((ChapterBookmark bookmark) {
              return ListTile(
                leading: const Icon(Icons.bookmark),
                title: Text(bookmark.chapterTitle),
                subtitle: Text(
                  bookmark.excerpt,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: IconButton(
                  tooltip: 'Remove bookmark',
                  onPressed: () {
                    setState(() {
                      _bookmarks.removeWhere(
                        (ChapterBookmark item) =>
                            item.chapterIndex == bookmark.chapterIndex,
                      );
                    });
                    widget.onBookmarksChanged(
                      List<ChapterBookmark>.from(_bookmarks),
                    );
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(Icons.delete_outline),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  _jumpToChapter(bookmark.chapterIndex);
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool hasPreviousChapter = _currentChapterIndex > 0;
    final bool hasNextChapter =
        _currentChapterIndex < widget.book.chapterCount - 1;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(widget.book.title),
            Text(
              'Chapter ${_currentChapterIndex + 1} of ${widget.book.chapterCount}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
        actions: <Widget>[
          IconButton(
            tooltip: 'Table of contents',
            onPressed: _showContentsSheet,
            icon: const Icon(Icons.list_alt),
          ),
          IconButton(
            tooltip: 'Bookmarks',
            onPressed: _showBookmarksSheet,
            icon: const Icon(Icons.collections_bookmark_outlined),
          ),
          IconButton(
            tooltip: _isCurrentChapterBookmarked
                ? 'Remove bookmark'
                : 'Add bookmark',
            onPressed: _toggleBookmark,
            icon: Icon(
              _isCurrentChapterBookmarked
                  ? Icons.bookmark
                  : Icons.bookmark_border,
            ),
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Container(
            width: double.infinity,
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  widget.book.author,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 6),
                Text(
                  _currentChapter.title,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
              child: SelectableText(
                _currentChapter.content,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  height: 1.8,
                  color: const Color(0xFF1F1E1B),
                ),
              ),
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: FilledButton.tonalIcon(
                      onPressed: hasPreviousChapter
                          ? () => _jumpToChapter(_currentChapterIndex - 1)
                          : null,
                      icon: const Icon(Icons.arrow_back),
                      label: const Text('Previous'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: hasNextChapter
                          ? () => _jumpToChapter(_currentChapterIndex + 1)
                          : null,
                      icon: const Icon(Icons.arrow_forward),
                      label: const Text('Next'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
