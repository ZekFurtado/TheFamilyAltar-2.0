import 'package:equatable/equatable.dart';
import '../../domain/entities/scripture_reference.dart';

abstract class BibleEvent extends Equatable {
  const BibleEvent();

  @override
  List<Object?> get props => [];
}

class LoadAvailableVersions extends BibleEvent {
  const LoadAvailableVersions();
}

class SelectBibleVersion extends BibleEvent {
  const SelectBibleVersion(this.versionId);
  
  final String versionId;

  @override
  List<Object?> get props => [versionId];
}

class LoadBibleBooks extends BibleEvent {
  const LoadBibleBooks(this.versionId);
  
  final String versionId;

  @override
  List<Object?> get props => [versionId];
}

class LoadBibleChapter extends BibleEvent {
  const LoadBibleChapter({
    required this.versionId,
    required this.book,
    required this.chapter,
  });
  
  final String versionId;
  final String book;
  final int chapter;

  @override
  List<Object?> get props => [versionId, book, chapter];
}

class NavigateToScripture extends BibleEvent {
  const NavigateToScripture({
    required this.versionId,
    required this.reference,
  });
  
  final String versionId;
  final ScriptureReference reference;

  @override
  List<Object?> get props => [versionId, reference];
}

class SearchVerses extends BibleEvent {
  const SearchVerses({
    required this.versionId,
    required this.query,
    this.book,
  });
  
  final String versionId;
  final String query;
  final String? book;

  @override
  List<Object?> get props => [versionId, query, book];
}

class DownloadBibleVersion extends BibleEvent {
  const DownloadBibleVersion(this.versionId);
  
  final String versionId;

  @override
  List<Object?> get props => [versionId];
}

class DeleteBibleVersion extends BibleEvent {
  const DeleteBibleVersion(this.versionId);
  
  final String versionId;

  @override
  List<Object?> get props => [versionId];
}