import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import '../../domain/entities/scripture_reference.dart';
import '../pages/bible_verse_screen.dart';

class _ScriptureMatch {
  final int start;
  final int end;
  final String reference;
  final ScriptureReference scriptureRef;
  
  _ScriptureMatch({
    required this.start,
    required this.end,
    required this.reference,
    required this.scriptureRef,
  });
}

class ClickableScriptureText extends StatelessWidget {
  const ClickableScriptureText({
    super.key,
    required this.text,
    this.style,
  });

  final String text;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    final spans = _parseTextForScriptures(text, context);
    
    return RichText(
      text: TextSpan(
        children: spans,
        style: style ?? Theme.of(context).textTheme.bodyLarge?.copyWith(
          color: Theme.of(context).colorScheme.onSurface,
          height: 1.6,
        ),
      ),
    );
  }

  List<TextSpan> _parseTextForScriptures(String text, BuildContext context) {
    final List<TextSpan> spans = [];
    
    // Enhanced regex patterns to match various scripture reference formats
    final List<RegExp> scripturePatterns = [
      // Pattern 1: "John 3:16" or "1 John 3:16-18" or "2 Corinthians 5:17"
      RegExp(r'\b(\d?\s?[A-Za-z]+(?:\s+[A-Za-z]+)?)\s+(\d+):(\d+)(?:-(\d+))?\b', caseSensitive: false),
      // Pattern 2: "John 3" (chapter only)
      RegExp(r'\b(\d?\s?[A-Za-z]+(?:\s+[A-Za-z]+)?)\s+(\d+)\b(?!:)', caseSensitive: false),
      // Pattern 3: Roman numerals like "II Timothy 3:16"
      RegExp(r'\b([IVX]+\s+[A-Za-z]+)\s+(\d+):(\d+)(?:-(\d+))?\b', caseSensitive: false),
    ];
    
    // Collect all matches with their positions
    List<_ScriptureMatch> allMatches = [];
    
    for (final pattern in scripturePatterns) {
      for (final match in pattern.allMatches(text)) {
        final reference = text.substring(match.start, match.end);
        final scriptureRef = ScriptureReference.parse(reference);
        
        if (scriptureRef != null) {
          allMatches.add(_ScriptureMatch(
            start: match.start,
            end: match.end,
            reference: reference,
            scriptureRef: scriptureRef,
          ));
        }
      }
    }
    
    // Sort matches by start position and remove overlaps
    allMatches.sort((a, b) => a.start.compareTo(b.start));
    final List<_ScriptureMatch> nonOverlappingMatches = [];
    
    for (final match in allMatches) {
      if (nonOverlappingMatches.isEmpty || 
          nonOverlappingMatches.last.end <= match.start) {
        nonOverlappingMatches.add(match);
      }
    }
    
    int lastIndex = 0;
    
    for (final match in nonOverlappingMatches) {
      // Add text before the scripture reference
      if (match.start > lastIndex) {
        spans.add(TextSpan(
          text: text.substring(lastIndex, match.start),
        ));
      }
      
      // Add clickable scripture reference
      spans.add(TextSpan(
        text: match.reference,
        style: TextStyle(
          color: Theme.of(context).colorScheme.primary,
          decoration: TextDecoration.underline,
          decorationColor: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.w600,
        ),
        recognizer: TapGestureRecognizer()
          ..onTap = () => _navigateToScripture(context, match.scriptureRef),
      ));
      
      lastIndex = match.end;
    }
    
    // Add remaining text
    if (lastIndex < text.length) {
      spans.add(TextSpan(
        text: text.substring(lastIndex),
      ));
    }
    
    // If no scripture references found, return the original text
    if (spans.isEmpty) {
      spans.add(TextSpan(text: text));
    }
    
    return spans;
  }

  void _navigateToScripture(BuildContext context, ScriptureReference reference) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BibleVerseScreen(
          reference: reference,
          versionId: 'kjv', // Default to KJV
        ),
      ),
    );
  }
}

