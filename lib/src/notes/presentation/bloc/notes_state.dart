import 'package:equatable/equatable.dart';

import '../../domain/entities/note.dart';
import '../../domain/entities/highlight.dart';

abstract class NotesState extends Equatable {
  const NotesState();

  @override
  List<Object?> get props => [];
}

class NotesInitial extends NotesState {
  const NotesInitial();
}

class NotesLoading extends NotesState {
  const NotesLoading();
}

class NotesLoaded extends NotesState {
  const NotesLoaded({
    required this.notes,
    required this.highlights,
  });

  final List<Note> notes;
  final List<Highlight> highlights;

  @override
  List<Object> get props => [notes, highlights];
}

class NotesError extends NotesState {
  const NotesError({required this.message});

  final String message;

  @override
  List<Object> get props => [message];
}

class NoteAdded extends NotesState {
  const NoteAdded();
}

class HighlightAdded extends NotesState {
  const HighlightAdded();
}

class NoteUpdated extends NotesState {
  const NoteUpdated();
}

class HighlightUpdated extends NotesState {
  const HighlightUpdated();
}

class NoteRemoved extends NotesState {
  const NoteRemoved();
}

class HighlightRemoved extends NotesState {
  const HighlightRemoved();
}