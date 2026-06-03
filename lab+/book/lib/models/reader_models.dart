import 'package:flutter/material.dart';

class ReaderBook {
  const ReaderBook({
    required this.id,
    required this.title,
    required this.author,
    required this.description,
    required this.coverColor,
    required this.chapters,
  });

  final String id;
  final String title;
  final String author;
  final String description;
  final Color coverColor;
  final List<BookChapter> chapters;

  int get chapterCount => chapters.length;
}

class BookChapter {
  const BookChapter({required this.title, required this.content});

  final String title;
  final String content;

  String get preview {
    final List<String> words = content.split(RegExp(r'\s+'));
    if (words.length <= 18) {
      return content;
    }

    return '${words.take(18).join(' ')}...';
  }
}

class ChapterBookmark {
  const ChapterBookmark({
    required this.id,
    required this.bookId,
    required this.chapterIndex,
    required this.chapterTitle,
    required this.excerpt,
    required this.createdAt,
  });

  final String id;
  final String bookId;
  final int chapterIndex;
  final String chapterTitle;
  final String excerpt;
  final DateTime createdAt;
}
