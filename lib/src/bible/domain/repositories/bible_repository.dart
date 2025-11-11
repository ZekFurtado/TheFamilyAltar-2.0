import '../../../../core/utils/typedef.dart';
import '../entities/bible_book.dart';
import '../entities/bible_chapter.dart';
import '../entities/bible_version.dart';
import '../entities/bible_verse.dart';
import '../entities/scripture_reference.dart';

abstract class BibleRepository {
  ResultFuture<List<BibleVersion>> getAvailableVersions();
  
  ResultFuture<List<BibleBook>> getBooks(String versionId);
  
  ResultFuture<BibleChapter> getChapter({
    required String versionId,
    required String book,
    required int chapter,
  });
  
  ResultFuture<List<BibleVerse>> getVerses({
    required String versionId,
    required ScriptureReference reference,
  });
  
  ResultFuture<List<BibleVerse>> searchVerses({
    required String versionId,
    required String query,
    String? book,
  });
  
  ResultFuture<void> downloadVersion(String versionId);
  
  ResultFuture<void> deleteVersion(String versionId);
  
  ResultFuture<BibleVersion?> getSelectedVersion();
  
  ResultVoid setSelectedVersion(String versionId);
}