import 'package:equatable/equatable.dart';
import '../../domain/entities/bible_book.dart';
import '../../domain/entities/bible_chapter.dart';
import '../../domain/entities/bible_version.dart';
import '../../domain/entities/bible_verse.dart';

abstract class BibleState extends Equatable {
  const BibleState();

  @override
  List<Object?> get props => [];
}

class BibleInitial extends BibleState {
  const BibleInitial();
}

class BibleLoading extends BibleState {
  const BibleLoading();
}

class BibleVersionsLoaded extends BibleState {
  const BibleVersionsLoaded({
    required this.versions,
    this.selectedVersion,
  });

  final List<BibleVersion> versions;
  final BibleVersion? selectedVersion;

  @override
  List<Object?> get props => [versions, selectedVersion];
}

class BibleBooksLoaded extends BibleState {
  const BibleBooksLoaded({
    required this.books,
    required this.versionId,
  });

  final List<BibleBook> books;
  final String versionId;

  @override
  List<Object?> get props => [books, versionId];
}

class BibleChapterLoaded extends BibleState {
  const BibleChapterLoaded({
    required this.chapter,
    required this.versionId,
  });

  final BibleChapter chapter;
  final String versionId;

  @override
  List<Object?> get props => [chapter, versionId];
}

class ScriptureVersesLoaded extends BibleState {
  const ScriptureVersesLoaded({
    required this.verses,
    required this.versionId,
    required this.reference,
  });

  final List<BibleVerse> verses;
  final String versionId;
  final String reference;

  @override
  List<Object?> get props => [verses, versionId, reference];
}

class BibleSearchResults extends BibleState {
  const BibleSearchResults({
    required this.results,
    required this.query,
    required this.versionId,
  });

  final List<BibleVerse> results;
  final String query;
  final String versionId;

  @override
  List<Object?> get props => [results, query, versionId];
}

class BibleVersionDownloaded extends BibleState {
  const BibleVersionDownloaded(this.versionId);

  final String versionId;

  @override
  List<Object?> get props => [versionId];
}

class BibleVersionDeleted extends BibleState {
  const BibleVersionDeleted(this.versionId);

  final String versionId;

  @override
  List<Object?> get props => [versionId];
}

class BibleError extends BibleState {
  const BibleError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}