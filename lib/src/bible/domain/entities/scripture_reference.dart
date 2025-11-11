import 'package:equatable/equatable.dart';

class ScriptureReference extends Equatable {
  const ScriptureReference({
    required this.book,
    required this.chapter,
    this.startVerse,
    this.endVerse,
  });

  final String book;
  final int chapter;
  final int? startVerse;
  final int? endVerse;

  String get displayText {
    if (startVerse == null) {
      return '$book $chapter';
    } else if (endVerse == null || endVerse == startVerse) {
      return '$book $chapter:$startVerse';
    } else {
      return '$book $chapter:$startVerse-$endVerse';
    }
  }

  static ScriptureReference? parse(String reference) {
    // Remove extra whitespace and normalize
    final normalized = reference.trim();
    
    // Multiple patterns to match various scripture reference formats
    final List<RegExp> patterns = [
      // Pattern 1: "John 3:16" or "1 John 3:16-18" or "2 Corinthians 5:17"
      RegExp(r'^(\d?\s?[A-Za-z]+(?:\s+[A-Za-z]+)?)\s+(\d+):(\d+)(?:-(\d+))?$', caseSensitive: false),
      // Pattern 2: "John 3" (chapter only)
      RegExp(r'^(\d?\s?[A-Za-z]+(?:\s+[A-Za-z]+)?)\s+(\d+)$', caseSensitive: false),
      // Pattern 3: Roman numerals like "II Timothy 3:16"
      RegExp(r'^([IVX]+\s+[A-Za-z]+)\s+(\d+)(?::(\d+))?(?:-(\d+))?$', caseSensitive: false),
      // Pattern 4: Handle "St. John", "Mt.", "Mk." abbreviations
      RegExp(r'^(St\.\s*|Mt\.\s*|Mk\.\s*|Lk\.\s*)?(\d?\s?[A-Za-z]+(?:\s+[A-Za-z]+)?)\s+(\d+)(?::(\d+))?(?:-(\d+))?$', caseSensitive: false),
    ];
    
    for (final pattern in patterns) {
      final match = pattern.firstMatch(normalized);
      if (match != null) {
        String? book;
        String? chapterStr;
        String? startVerseStr;
        String? endVerseStr;
        
        try {
          if (pattern == patterns[0]) {
            // Pattern 1: "John 3:16" or "1 John 3:16-18" or "2 Corinthians 5:17"
            book = match.group(1)?.trim();
            chapterStr = match.group(2);
            startVerseStr = match.groupCount >= 3 ? match.group(3) : null;
            endVerseStr = match.groupCount >= 4 ? match.group(4) : null;
          } else if (pattern == patterns[1]) {
            // Pattern 2: "John 3" (chapter only)
            book = match.group(1)?.trim();
            chapterStr = match.group(2);
            startVerseStr = null;
            endVerseStr = null;
          } else if (pattern == patterns[2]) {
            // Pattern 3: Roman numerals like "II Timothy 3:16"
            book = match.group(1)?.trim();
            chapterStr = match.group(2);
            startVerseStr = match.groupCount >= 3 ? match.group(3) : null;
            endVerseStr = match.groupCount >= 4 ? match.group(4) : null;
          } else {
            // Pattern 4 with prefix
            final prefix = match.group(1);
            book = match.group(2)?.trim();
            chapterStr = match.groupCount >= 3 ? match.group(3) : null;
            startVerseStr = match.groupCount >= 4 ? match.group(4) : null;
            endVerseStr = match.groupCount >= 5 ? match.group(5) : null;
            
            if (prefix != null && book != null) {
              book = (prefix + book).trim();
            }
          }
        } catch (e) {
          // Skip this pattern if group access fails
          continue;
        }
        
        if (book == null || chapterStr == null) continue;
        
        // Convert Roman numerals to Arabic numbers
        book = _convertRomanNumerals(book);
        
        // Normalize book names
        book = _normalizeBookName(book);
        
        final chapter = int.tryParse(chapterStr);
        if (chapter == null) continue;
        
        final startVerse = startVerseStr != null ? int.tryParse(startVerseStr) : null;
        final endVerse = endVerseStr != null ? int.tryParse(endVerseStr) : null;
        
        return ScriptureReference(
          book: book,
          chapter: chapter,
          startVerse: startVerse,
          endVerse: endVerse,
        );
      }
    }
    
    return null;
  }
  
  static String _convertRomanNumerals(String text) {
    final romanToArabic = {
      'I': '1',
      'II': '2',
      'III': '3',
      'IV': '4',
      'V': '5',
    };
    
    for (final entry in romanToArabic.entries) {
      if (text.startsWith('${entry.key} ')) {
        return text.replaceFirst('${entry.key} ', '${entry.value} ');
      }
    }
    
    return text;
  }
  
  static String _normalizeBookName(String bookName) {
    // Map common abbreviations to full names
    final abbreviationMap = {
      'gen': 'Genesis',
      'ex': 'Exodus',
      'exo': 'Exodus',
      'lev': 'Leviticus',
      'num': 'Numbers',
      'deut': 'Deuteronomy',
      'josh': 'Joshua',
      'judg': 'Judges',
      'ruth': 'Ruth',
      '1 sam': '1 Samuel',
      '2 sam': '2 Samuel',
      '1 ki': '1 Kings',
      '1 kings': '1 Kings',
      '2 ki': '2 Kings',
      '2 kings': '2 Kings',
      'ps': 'Psalms',
      'psalm': 'Psalms',
      'prov': 'Proverbs',
      'eccl': 'Ecclesiastes',
      'song': 'Song of Solomon',
      'isa': 'Isaiah',
      'jer': 'Jeremiah',
      'lam': 'Lamentations',
      'ezek': 'Ezekiel',
      'dan': 'Daniel',
      'hos': 'Hosea',
      'joel': 'Joel',
      'amos': 'Amos',
      'obad': 'Obadiah',
      'jonah': 'Jonah',
      'mic': 'Micah',
      'nah': 'Nahum',
      'hab': 'Habakkuk',
      'zeph': 'Zephaniah',
      'hag': 'Haggai',
      'zech': 'Zechariah',
      'mal': 'Malachi',
      'matt': 'Matthew',
      'mk': 'Mark',
      'mark': 'Mark',
      'lk': 'Luke',
      'luke': 'Luke',
      'jn': 'John',
      'john': 'John',
      'acts': 'Acts',
      'rom': 'Romans',
      '1 cor': '1 Corinthians',
      '2 cor': '2 Corinthians',
      'gal': 'Galatians',
      'eph': 'Ephesians',
      'phil': 'Philippians',
      'col': 'Colossians',
      '1 thess': '1 Thessalonians',
      '2 thess': '2 Thessalonians',
      '1 tim': '1 Timothy',
      '2 tim': '2 Timothy',
      'titus': 'Titus',
      'philem': 'Philemon',
      'heb': 'Hebrews',
      'jas': 'James',
      'james': 'James',
      '1 pet': '1 Peter',
      '2 pet': '2 Peter',
      '1 jn': '1 John',
      '2 jn': '2 John',
      '3 jn': '3 John',
      'jude': 'Jude',
      'rev': 'Revelation',
    };
    
    final normalized = bookName.toLowerCase().trim();
    return abbreviationMap[normalized] ?? bookName;
  }

  @override
  List<Object?> get props => [
        book,
        chapter,
        startVerse,
        endVerse,
      ];
}