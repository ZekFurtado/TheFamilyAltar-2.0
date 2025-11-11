import 'dart:convert';
import 'dart:developer';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/bible_book_model.dart';
import '../models/bible_chapter_model.dart';
import '../models/bible_verse_model.dart';
import '../models/bible_version_model.dart';
import '../../domain/entities/bible_book.dart';
import '../../domain/entities/bible_version.dart';
import '../../domain/entities/scripture_reference.dart';

abstract class BibleLocalDataSource {
  Future<List<BibleVersionModel>> getAvailableVersions();
  Future<List<BibleBookModel>> getBooks(String versionId);
  Future<BibleChapterModel> getChapter({
    required String versionId,
    required String book,
    required int chapter,
  });
  Future<List<BibleVerseModel>> getVerses({
    required String versionId,
    required ScriptureReference reference,
  });
  Future<List<BibleVerseModel>> searchVerses({
    required String versionId,
    required String query,
    String? book,
  });
  Future<void> downloadVersion(String versionId);
  Future<void> deleteVersion(String versionId);
  Future<BibleVersionModel?> getSelectedVersion();
  Future<void> setSelectedVersion(String versionId);
}

class BibleLocalDataSourceImpl implements BibleLocalDataSource {
  const BibleLocalDataSourceImpl(this._prefs);

  final SharedPreferences _prefs;

  static const String _selectedVersionKey = 'selected_bible_version';
  static const String _downloadedVersionsKey = 'downloaded_bible_versions';

  @override
  Future<List<BibleVersionModel>> getAvailableVersions() async {
    try {
      final downloadedVersions = _prefs.getStringList(_downloadedVersionsKey) ?? [];
      
      // Default KJV version
      final kjvVersion = BibleVersionModel(
        id: 'kjv',
        name: 'King James Version',
        abbreviation: 'KJV',
        type: BibleVersionType.kjv,
        language: 'English',
        isDownloaded: downloadedVersions.contains('kjv'),
      );

      final nkjvVersion = BibleVersionModel(
        id: 'nkjv',
        name: 'New King James Version',
        abbreviation: 'NKJV',
        type: BibleVersionType.nkjv,
        language: 'English',
        isDownloaded: downloadedVersions.contains('nkjv'),
      );

      return [kjvVersion, nkjvVersion];
    } catch (e) {
      log('Error getting available versions: $e');
      throw Exception('Failed to get available versions');
    }
  }

  @override
  Future<List<BibleBookModel>> getBooks(String versionId) async {
    try {
      return _getBibleBooks();
    } catch (e) {
      log('Error getting books: $e');
      throw Exception('Failed to get books');
    }
  }

  @override
  Future<BibleChapterModel> getChapter({
    required String versionId,
    required String book,
    required int chapter,
  }) async {
    try {
      // For demo purposes, return sample verses
      // In a real implementation, this would read from a local database or JSON files
      final verses = await _getChapterVerses(book, chapter, versionId);
      
      return BibleChapterModel(
        book: book,
        chapterNumber: chapter,
        verses: verses,
      );
    } catch (e) {
      log('Error getting chapter: $e');
      throw Exception('Failed to get chapter $book $chapter');
    }
  }

  @override
  Future<List<BibleVerseModel>> getVerses({
    required String versionId,
    required ScriptureReference reference,
  }) async {
    try {
      final verses = await _getChapterVerses(reference.book, reference.chapter, versionId);
      
      if (reference.startVerse == null) {
        return verses;
      }
      
      final startIndex = (reference.startVerse! - 1).clamp(0, verses.length - 1);
      final endIndex = reference.endVerse != null 
          ? (reference.endVerse! - 1).clamp(0, verses.length - 1)
          : startIndex;
      
      return verses.sublist(startIndex, endIndex + 1);
    } catch (e) {
      log('Error getting verses: $e');
      throw Exception('Failed to get verses for ${reference.displayText}');
    }
  }

  @override
  Future<List<BibleVerseModel>> searchVerses({
    required String versionId,
    required String query,
    String? book,
  }) async {
    try {
      // Simple search implementation - in a real app this would be more sophisticated
      final results = <BibleVerseModel>[];
      
      if (book != null) {
        // Search within specific book
        final bookData = _getBibleBookByName(book);
        if (bookData != null) {
          for (int chapter = 1; chapter <= bookData.chapterCount; chapter++) {
            final verses = await _getChapterVerses(book, chapter, versionId);
            results.addAll(verses.where((verse) => 
                verse.text.toLowerCase().contains(query.toLowerCase())));
          }
        }
      }
      
      return results.take(50).toList(); // Limit results
    } catch (e) {
      log('Error searching verses: $e');
      throw Exception('Failed to search verses');
    }
  }

  @override
  Future<void> downloadVersion(String versionId) async {
    try {
      final downloadedVersions = _prefs.getStringList(_downloadedVersionsKey) ?? [];
      if (!downloadedVersions.contains(versionId)) {
        downloadedVersions.add(versionId);
        await _prefs.setStringList(_downloadedVersionsKey, downloadedVersions);
      }
    } catch (e) {
      log('Error downloading version: $e');
      throw Exception('Failed to download version $versionId');
    }
  }

  @override
  Future<void> deleteVersion(String versionId) async {
    try {
      final downloadedVersions = _prefs.getStringList(_downloadedVersionsKey) ?? [];
      downloadedVersions.remove(versionId);
      await _prefs.setStringList(_downloadedVersionsKey, downloadedVersions);
    } catch (e) {
      log('Error deleting version: $e');
      throw Exception('Failed to delete version $versionId');
    }
  }

  @override
  Future<BibleVersionModel?> getSelectedVersion() async {
    try {
      final selectedId = _prefs.getString(_selectedVersionKey);
      if (selectedId == null) return null;
      
      final versions = await getAvailableVersions();
      return versions.cast<BibleVersionModel?>().firstWhere(
        (version) => version?.id == selectedId,
        orElse: () => null,
      );
    } catch (e) {
      log('Error getting selected version: $e');
      return null;
    }
  }

  @override
  Future<void> setSelectedVersion(String versionId) async {
    try {
      await _prefs.setString(_selectedVersionKey, versionId);
    } catch (e) {
      log('Error setting selected version: $e');
      throw Exception('Failed to set selected version');
    }
  }

  List<BibleBookModel> _getBibleBooks() {
    return [
      // Old Testament
      BibleBookModel(id: 1, name: 'Genesis', shortName: 'Gen', chapterCount: 50, testament: Testament.oldTestament, order: 1),
      BibleBookModel(id: 2, name: 'Exodus', shortName: 'Exo', chapterCount: 40, testament: Testament.oldTestament, order: 2),
      BibleBookModel(id: 3, name: 'Leviticus', shortName: 'Lev', chapterCount: 27, testament: Testament.oldTestament, order: 3),
      BibleBookModel(id: 4, name: 'Numbers', shortName: 'Num', chapterCount: 36, testament: Testament.oldTestament, order: 4),
      BibleBookModel(id: 5, name: 'Deuteronomy', shortName: 'Deu', chapterCount: 34, testament: Testament.oldTestament, order: 5),
      BibleBookModel(id: 6, name: 'Joshua', shortName: 'Jos', chapterCount: 24, testament: Testament.oldTestament, order: 6),
      BibleBookModel(id: 7, name: 'Judges', shortName: 'Jdg', chapterCount: 21, testament: Testament.oldTestament, order: 7),
      BibleBookModel(id: 8, name: 'Ruth', shortName: 'Rut', chapterCount: 4, testament: Testament.oldTestament, order: 8),
      BibleBookModel(id: 9, name: '1 Samuel', shortName: '1Sa', chapterCount: 31, testament: Testament.oldTestament, order: 9),
      BibleBookModel(id: 10, name: '2 Samuel', shortName: '2Sa', chapterCount: 24, testament: Testament.oldTestament, order: 10),
      BibleBookModel(id: 11, name: '1 Kings', shortName: '1Ki', chapterCount: 22, testament: Testament.oldTestament, order: 11),
      BibleBookModel(id: 12, name: '2 Kings', shortName: '2Ki', chapterCount: 25, testament: Testament.oldTestament, order: 12),
      BibleBookModel(id: 13, name: '1 Chronicles', shortName: '1Ch', chapterCount: 29, testament: Testament.oldTestament, order: 13),
      BibleBookModel(id: 14, name: '2 Chronicles', shortName: '2Ch', chapterCount: 36, testament: Testament.oldTestament, order: 14),
      BibleBookModel(id: 15, name: 'Ezra', shortName: 'Ezr', chapterCount: 10, testament: Testament.oldTestament, order: 15),
      BibleBookModel(id: 16, name: 'Nehemiah', shortName: 'Neh', chapterCount: 13, testament: Testament.oldTestament, order: 16),
      BibleBookModel(id: 17, name: 'Esther', shortName: 'Est', chapterCount: 10, testament: Testament.oldTestament, order: 17),
      BibleBookModel(id: 18, name: 'Job', shortName: 'Job', chapterCount: 42, testament: Testament.oldTestament, order: 18),
      BibleBookModel(id: 19, name: 'Psalms', shortName: 'Psa', chapterCount: 150, testament: Testament.oldTestament, order: 19),
      BibleBookModel(id: 20, name: 'Proverbs', shortName: 'Pro', chapterCount: 31, testament: Testament.oldTestament, order: 20),
      BibleBookModel(id: 21, name: 'Ecclesiastes', shortName: 'Ecc', chapterCount: 12, testament: Testament.oldTestament, order: 21),
      BibleBookModel(id: 22, name: 'Song of Solomon', shortName: 'Son', chapterCount: 8, testament: Testament.oldTestament, order: 22),
      BibleBookModel(id: 23, name: 'Isaiah', shortName: 'Isa', chapterCount: 66, testament: Testament.oldTestament, order: 23),
      BibleBookModel(id: 24, name: 'Jeremiah', shortName: 'Jer', chapterCount: 52, testament: Testament.oldTestament, order: 24),
      BibleBookModel(id: 25, name: 'Lamentations', shortName: 'Lam', chapterCount: 5, testament: Testament.oldTestament, order: 25),
      BibleBookModel(id: 26, name: 'Ezekiel', shortName: 'Eze', chapterCount: 48, testament: Testament.oldTestament, order: 26),
      BibleBookModel(id: 27, name: 'Daniel', shortName: 'Dan', chapterCount: 12, testament: Testament.oldTestament, order: 27),
      BibleBookModel(id: 28, name: 'Hosea', shortName: 'Hos', chapterCount: 14, testament: Testament.oldTestament, order: 28),
      BibleBookModel(id: 29, name: 'Joel', shortName: 'Joe', chapterCount: 3, testament: Testament.oldTestament, order: 29),
      BibleBookModel(id: 30, name: 'Amos', shortName: 'Amo', chapterCount: 9, testament: Testament.oldTestament, order: 30),
      BibleBookModel(id: 31, name: 'Obadiah', shortName: 'Oba', chapterCount: 1, testament: Testament.oldTestament, order: 31),
      BibleBookModel(id: 32, name: 'Jonah', shortName: 'Jon', chapterCount: 4, testament: Testament.oldTestament, order: 32),
      BibleBookModel(id: 33, name: 'Micah', shortName: 'Mic', chapterCount: 7, testament: Testament.oldTestament, order: 33),
      BibleBookModel(id: 34, name: 'Nahum', shortName: 'Nah', chapterCount: 3, testament: Testament.oldTestament, order: 34),
      BibleBookModel(id: 35, name: 'Habakkuk', shortName: 'Hab', chapterCount: 3, testament: Testament.oldTestament, order: 35),
      BibleBookModel(id: 36, name: 'Zephaniah', shortName: 'Zep', chapterCount: 3, testament: Testament.oldTestament, order: 36),
      BibleBookModel(id: 37, name: 'Haggai', shortName: 'Hag', chapterCount: 2, testament: Testament.oldTestament, order: 37),
      BibleBookModel(id: 38, name: 'Zechariah', shortName: 'Zec', chapterCount: 14, testament: Testament.oldTestament, order: 38),
      BibleBookModel(id: 39, name: 'Malachi', shortName: 'Mal', chapterCount: 4, testament: Testament.oldTestament, order: 39),

      // New Testament
      BibleBookModel(id: 40, name: 'Matthew', shortName: 'Mat', chapterCount: 28, testament: Testament.newTestament, order: 40),
      BibleBookModel(id: 41, name: 'Mark', shortName: 'Mar', chapterCount: 16, testament: Testament.newTestament, order: 41),
      BibleBookModel(id: 42, name: 'Luke', shortName: 'Luk', chapterCount: 24, testament: Testament.newTestament, order: 42),
      BibleBookModel(id: 43, name: 'John', shortName: 'Joh', chapterCount: 21, testament: Testament.newTestament, order: 43),
      BibleBookModel(id: 44, name: 'Acts', shortName: 'Act', chapterCount: 28, testament: Testament.newTestament, order: 44),
      BibleBookModel(id: 45, name: 'Romans', shortName: 'Rom', chapterCount: 16, testament: Testament.newTestament, order: 45),
      BibleBookModel(id: 46, name: '1 Corinthians', shortName: '1Co', chapterCount: 16, testament: Testament.newTestament, order: 46),
      BibleBookModel(id: 47, name: '2 Corinthians', shortName: '2Co', chapterCount: 13, testament: Testament.newTestament, order: 47),
      BibleBookModel(id: 48, name: 'Galatians', shortName: 'Gal', chapterCount: 6, testament: Testament.newTestament, order: 48),
      BibleBookModel(id: 49, name: 'Ephesians', shortName: 'Eph', chapterCount: 6, testament: Testament.newTestament, order: 49),
      BibleBookModel(id: 50, name: 'Philippians', shortName: 'Phi', chapterCount: 4, testament: Testament.newTestament, order: 50),
      BibleBookModel(id: 51, name: 'Colossians', shortName: 'Col', chapterCount: 4, testament: Testament.newTestament, order: 51),
      BibleBookModel(id: 52, name: '1 Thessalonians', shortName: '1Th', chapterCount: 5, testament: Testament.newTestament, order: 52),
      BibleBookModel(id: 53, name: '2 Thessalonians', shortName: '2Th', chapterCount: 3, testament: Testament.newTestament, order: 53),
      BibleBookModel(id: 54, name: '1 Timothy', shortName: '1Ti', chapterCount: 6, testament: Testament.newTestament, order: 54),
      BibleBookModel(id: 55, name: '2 Timothy', shortName: '2Ti', chapterCount: 4, testament: Testament.newTestament, order: 55),
      BibleBookModel(id: 56, name: 'Titus', shortName: 'Tit', chapterCount: 3, testament: Testament.newTestament, order: 56),
      BibleBookModel(id: 57, name: 'Philemon', shortName: 'Phm', chapterCount: 1, testament: Testament.newTestament, order: 57),
      BibleBookModel(id: 58, name: 'Hebrews', shortName: 'Heb', chapterCount: 13, testament: Testament.newTestament, order: 58),
      BibleBookModel(id: 59, name: 'James', shortName: 'Jam', chapterCount: 5, testament: Testament.newTestament, order: 59),
      BibleBookModel(id: 60, name: '1 Peter', shortName: '1Pe', chapterCount: 5, testament: Testament.newTestament, order: 60),
      BibleBookModel(id: 61, name: '2 Peter', shortName: '2Pe', chapterCount: 3, testament: Testament.newTestament, order: 61),
      BibleBookModel(id: 62, name: '1 John', shortName: '1Jo', chapterCount: 5, testament: Testament.newTestament, order: 62),
      BibleBookModel(id: 63, name: '2 John', shortName: '2Jo', chapterCount: 1, testament: Testament.newTestament, order: 63),
      BibleBookModel(id: 64, name: '3 John', shortName: '3Jo', chapterCount: 1, testament: Testament.newTestament, order: 64),
      BibleBookModel(id: 65, name: 'Jude', shortName: 'Jud', chapterCount: 1, testament: Testament.newTestament, order: 65),
      BibleBookModel(id: 66, name: 'Revelation', shortName: 'Rev', chapterCount: 22, testament: Testament.newTestament, order: 66),
    ];
  }

  BibleBookModel? _getBibleBookByName(String name) {
    final books = _getBibleBooks();
    try {
      return books.firstWhere(
        (book) => book.name.toLowerCase() == name.toLowerCase() ||
                   book.shortName.toLowerCase() == name.toLowerCase(),
      );
    } catch (e) {
      return null;
    }
  }

  Future<List<BibleVerseModel>> _getChapterVerses(String book, int chapter, String versionId) async {
    // For demo purposes, return sample verses
    // In a real implementation, you would read from a local database or JSON files
    
    if (book.toLowerCase() == 'john' && chapter == 3) {
      return [
        BibleVerseModel(book: 'John', chapter: 3, verse: 1, text: 'There was a man of the Pharisees, named Nicodemus, a ruler of the Jews:'),
        BibleVerseModel(book: 'John', chapter: 3, verse: 2, text: 'The same came to Jesus by night, and said unto him, Rabbi, we know that thou art a teacher come from God: for no man can do these miracles that thou doest, except God be with him.'),
        BibleVerseModel(book: 'John', chapter: 3, verse: 3, text: 'Jesus answered and said unto him, Verily, verily, I say unto thee, Except a man be born again, he cannot see the kingdom of God.'),
        BibleVerseModel(book: 'John', chapter: 3, verse: 4, text: 'Nicodemus saith unto him, How can a man be born when he is old? can he enter the second time into his mother\'s womb, and be born?'),
        BibleVerseModel(book: 'John', chapter: 3, verse: 5, text: 'Jesus answered, Verily, verily, I say unto thee, Except a man be born of water and of the Spirit, he cannot enter into the kingdom of God.'),
        BibleVerseModel(book: 'John', chapter: 3, verse: 6, text: 'That which is born of the flesh is flesh; and that which is born of the Spirit is spirit.'),
        BibleVerseModel(book: 'John', chapter: 3, verse: 7, text: 'Marvel not that I said unto thee, Ye must be born again.'),
        BibleVerseModel(book: 'John', chapter: 3, verse: 8, text: 'The wind bloweth where it listeth, and thou hearest the sound thereof, but canst not tell whence it cometh, and whither it goeth: so is every one that is born of the Spirit.'),
        BibleVerseModel(book: 'John', chapter: 3, verse: 9, text: 'Nicodemus answered and said unto him, How can these things be?'),
        BibleVerseModel(book: 'John', chapter: 3, verse: 10, text: 'Jesus answered and said unto him, Art thou a master of Israel, and knowest not these things?'),
        BibleVerseModel(book: 'John', chapter: 3, verse: 11, text: 'Verily, verily, I say unto thee, We speak that we do know, and testify that we have seen; and ye receive not our witness.'),
        BibleVerseModel(book: 'John', chapter: 3, verse: 12, text: 'If I have told you earthly things, and ye believe not, how shall ye believe, if I tell you of heavenly things?'),
        BibleVerseModel(book: 'John', chapter: 3, verse: 13, text: 'And no man hath ascended up to heaven, but he that came down from heaven, even the Son of man which is in heaven.'),
        BibleVerseModel(book: 'John', chapter: 3, verse: 14, text: 'And as Moses lifted up the serpent in the wilderness, even so must the Son of man be lifted up:'),
        BibleVerseModel(book: 'John', chapter: 3, verse: 15, text: 'That whosoever believeth in him should not perish, but have eternal life.'),
        const BibleVerseModel(book: 'John', chapter: 3, verse: 16, text: 'For God so loved the world, that he gave his only begotten Son, that whosoever believeth in him should not perish, but have everlasting life.'),
        BibleVerseModel(book: 'John', chapter: 3, verse: 17, text: 'For God sent not his Son into the world to condemn the world; but that the world through him might be saved.'),
        BibleVerseModel(book: 'John', chapter: 3, verse: 18, text: 'He that believeth on him is not condemned: but he that believeth not is condemned already, because he hath not believed in the name of the only begotten Son of God.'),
        BibleVerseModel(book: 'John', chapter: 3, verse: 19, text: 'And this is the condemnation, that light is come into the world, and men loved darkness rather than light, because their deeds were evil.'),
        BibleVerseModel(book: 'John', chapter: 3, verse: 20, text: 'For every one that doeth evil hateth the light, neither cometh to the light, lest his deeds should be reproved.'),
        BibleVerseModel(book: 'John', chapter: 3, verse: 21, text: 'But he that doeth truth cometh to the light, that his deeds may be made manifest, that they are wrought in God.'),
      ];
    }
    
    // Return sample verses for other books/chapters
    return List.generate(
      10, // Generate 10 sample verses
      (index) => BibleVerseModel(
        book: book,
        chapter: chapter,
        verse: index + 1,
        text: 'Sample verse ${index + 1} from $book chapter $chapter. This is placeholder text that would be replaced with actual Bible content in a production app.',
      ),
    );
  }
}