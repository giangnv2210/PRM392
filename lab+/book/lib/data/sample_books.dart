import 'package:book/models/reader_models.dart';
import 'package:flutter/services.dart';

Future<List<ReaderBook>> loadSampleBooks() async {
  final List<BookChapter> chapters = await Future.wait(<Future<BookChapter>>[
    _loadChapter(
      assetPath: 'assets/books/triet_hoc_mac_lenin/chapter_1.txt',
      title: 'Chuong 1. Khai luan ve triet hoc va triet hoc Mac - Lenin',
    ),
    _loadChapter(
      assetPath: 'assets/books/triet_hoc_mac_lenin/chapter_2.txt',
      title: 'Chuong 2. Chu nghia duy vat bien chung',
    ),
    _loadChapter(
      assetPath: 'assets/books/triet_hoc_mac_lenin/chapter_3.txt',
      title: 'Chuong 3. Chu nghia duy vat lich su',
    ),
  ]);

  return <ReaderBook>[
    ReaderBook(
      id: 'giao-trinh-triet-hoc-mac-lenin-2021',
      title: 'Giao trinh Triet hoc Mac - Lenin',
      author: 'Bo Giao duc va Dao tao',
      description:
          'Mock data extracted from the 2021 textbook PDF, bundled as 3 readable chapters in the app.',
      coverColor: const Color(0xFF7B3434),
      chapters: chapters,
    ),
  ];
}

Future<BookChapter> _loadChapter({
  required String assetPath,
  required String title,
}) async {
  final String content = await rootBundle.loadString(assetPath);

  return BookChapter(title: title, content: content.trim());
}
