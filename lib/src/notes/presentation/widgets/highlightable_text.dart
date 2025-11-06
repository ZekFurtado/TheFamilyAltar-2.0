import 'package:flutter/material.dart';

class HighlightableText extends StatefulWidget {
  const HighlightableText({
    super.key,
    required this.text,
    required this.style,
    required this.onTextSelected,
    this.highlights = const [],
  });

  final String text;
  final TextStyle? style;
  final Function(String selectedText, int startIndex, int endIndex) onTextSelected;
  final List<TextHighlight> highlights;

  @override
  State<HighlightableText> createState() => _HighlightableTextState();
}

class _HighlightableTextState extends State<HighlightableText> {
  @override
  Widget build(BuildContext context) {
    return SelectableText.rich(
      _buildTextSpan(),
      style: widget.style,
      onSelectionChanged: (selection, cause) {
        if (selection.isValid && !selection.isCollapsed) {
          final selectedText = widget.text.substring(
            selection.start,
            selection.end,
          );
          widget.onTextSelected(selectedText, selection.start, selection.end);
        }
      },
    );
  }

  TextSpan _buildTextSpan() {
    if (widget.highlights.isEmpty) {
      return TextSpan(text: widget.text, style: widget.style);
    }

    final spans = <TextSpan>[];
    int currentIndex = 0;

    // Sort highlights by start position
    final sortedHighlights = List<TextHighlight>.from(widget.highlights)
      ..sort((a, b) => a.startPosition.compareTo(b.startPosition));

    for (final highlight in sortedHighlights) {
      // Add text before highlight
      if (currentIndex < highlight.startPosition) {
        spans.add(TextSpan(
          text: widget.text.substring(currentIndex, highlight.startPosition),
          style: widget.style,
        ));
      }

      // Add highlighted text
      spans.add(TextSpan(
        text: widget.text.substring(highlight.startPosition, highlight.endPosition),
        style: widget.style?.copyWith(
          backgroundColor: _parseColor(highlight.color),
        ),
      ));

      currentIndex = highlight.endPosition;
    }

    // Add remaining text
    if (currentIndex < widget.text.length) {
      spans.add(TextSpan(
        text: widget.text.substring(currentIndex),
        style: widget.style,
      ));
    }

    return TextSpan(children: spans);
  }

  Color _parseColor(String colorString) {
    try {
      return Color(int.parse(colorString.replaceFirst('#', '0xff')));
    } catch (e) {
      return Colors.yellow.withValues(alpha: 0.3);
    }
  }
}

class TextHighlight {
  const TextHighlight({
    required this.startPosition,
    required this.endPosition,
    required this.color,
  });

  final int startPosition;
  final int endPosition;
  final String color;
}