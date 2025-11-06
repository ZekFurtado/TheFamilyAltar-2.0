import 'package:equatable/equatable.dart';

import '../../domain/entities/note.dart';
import '../../domain/entities/highlight.dart';

abstract class NotesEvent extends Equatable {
  const NotesEvent();

  @override
  List<Object?> get props => [];
}

class LoadNotesAndHighlights extends NotesEvent {
  const LoadNotesAndHighlights({
    required this.userId,
    required this.readingId,
  });

  final String userId;
  final String readingId;

  @override
  List<Object> get props => [userId, readingId];
}

class AddNote extends NotesEvent {
  const AddNote({required this.note, required this.userId, required this.readingId});

  final Note note;
  final String userId;
  final String readingId;

  @override
  List<Object> get props => [note];
}

class AddHighlight extends NotesEvent {
  const AddHighlight({required this.highlight, required this.userId, required this.readingId});

  final Highlight highlight;
  final String userId;
  final String readingId;

  @override
  List<Object> get props => [highlight, userId, readingId];
}

class UpdateNote extends NotesEvent {
  const UpdateNote({required this.note});

  final Note note;

  @override
  List<Object> get props => [note];
}

class UpdateHighlight extends NotesEvent {
  const UpdateHighlight({required this.highlight});

  final Highlight highlight;

  @override
  List<Object> get props => [highlight];
}

class RemoveNote extends NotesEvent {
  const RemoveNote({required this.noteId});

  final String noteId;

  @override
  List<Object> get props => [noteId];
}

class RemoveHighlight extends NotesEvent {
  const RemoveHighlight({required this.highlightId});

  final String highlightId;

  @override
  List<Object> get props => [highlightId];
}