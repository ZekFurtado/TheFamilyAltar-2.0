import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/note.dart';
import '../../domain/entities/highlight.dart';
import '../bloc/notes_bloc.dart';
import '../bloc/notes_event.dart';

class NotesBottomSheet extends StatefulWidget {
  const NotesBottomSheet({
    super.key,
    required this.userId,
    required this.readingId,
    this.selectedText,
    this.startPosition,
    this.endPosition,
  });

  final String userId;
  final String readingId;
  final String? selectedText;
  final int? startPosition;
  final int? endPosition;

  @override
  State<NotesBottomSheet> createState() => _NotesBottomSheetState();
}

class _NotesBottomSheetState extends State<NotesBottomSheet> {
  final _noteController = TextEditingController();
  Color _selectedColor = Colors.yellow;
  bool _addHighlight = false;

  final List<Color> _highlightColors = [
    Colors.yellow,
    Colors.green,
    Colors.blue,
    Colors.orange,
    Colors.pink,
  ];

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.note_add,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Text(
                'Add Note',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close),
              ),
            ],
          ),
          
          if (widget.selectedText != null) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Selected Text:',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '"${widget.selectedText}"',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Checkbox(
                  value: _addHighlight,
                  onChanged: (value) => setState(() => _addHighlight = value ?? false),
                ),
                const Text('Highlight this text'),
              ],
            ),
            if (_addHighlight) ...[
              const SizedBox(height: 12),
              Text(
                'Highlight Color:',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: _highlightColors.map((color) {
                  final isSelected = _selectedColor == color;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedColor = color),
                    child: Container(
                      margin: const EdgeInsets.only(right: 8),
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.7),
                        shape: BoxShape.circle,
                        border: isSelected
                            ? Border.all(
                                color: Theme.of(context).colorScheme.primary,
                                width: 3,
                              )
                            : null,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ],
          
          const SizedBox(height: 16),
          TextField(
            controller: _noteController,
            maxLines: 4,
            decoration: InputDecoration(
              hintText: 'Write your note here...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.cloud_sync,
                  size: 16,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Notes are automatically synced across all your devices',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _saveNote,
              child: const Text('Save Note'),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
        ],
      ),
    );
  }

  void _saveNote() {
    if (_noteController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a note')),
      );
      return;
    }

    final now = DateTime.now();
    final noteId = '${widget.userId}_${widget.readingId}_${now.millisecondsSinceEpoch}';

    // Save highlight if selected
    if (_addHighlight && widget.selectedText != null) {
      final highlightId = '${noteId}_highlight';
      final highlight = Highlight(
        id: highlightId,
        userId: widget.userId,
        readingId: widget.readingId,
        selectedText: widget.selectedText!,
        startPosition: widget.startPosition!,
        endPosition: widget.endPosition!,
        color: '#${_selectedColor.toARGB32().toRadixString(16).substring(2)}',
        createdAt: now,
        note: _noteController.text.trim(),
      );

      context.read<NotesBloc>().add(AddHighlight(
        highlight: highlight,
        userId: widget.userId,
        readingId: widget.readingId,
      ));
    }

    // Always save the note
    final note = Note(
      id: noteId,
      userId: widget.userId,
      readingId: widget.readingId,
      content: _noteController.text.trim(),
      createdAt: now,
      updatedAt: now,
      highlightedText: widget.selectedText,
      textPosition: widget.startPosition,
      highlightColor: _addHighlight ? '#${_selectedColor.toARGB32().toRadixString(16).substring(2)}' : null,
    );

    context.read<NotesBloc>().add(AddNote(note: note, userId: widget.userId, readingId: widget.readingId));
    Navigator.pop(context);
  }
}