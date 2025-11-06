import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/delete_highlight.dart';
import '../../domain/usecases/delete_note.dart';
import '../../domain/usecases/get_highlights_by_reading.dart';
import '../../domain/usecases/get_notes_by_reading.dart';
import '../../domain/usecases/save_highlight.dart';
import '../../domain/usecases/save_note.dart';
import 'notes_event.dart';
import 'notes_state.dart';

class NotesBloc extends Bloc<NotesEvent, NotesState> {
  NotesBloc({
    required GetNotesByReading getNotesByReading,
    required GetHighlightsByReading getHighlightsByReading,
    required SaveNote saveNote,
    required SaveHighlight saveHighlight,
    required DeleteNote deleteNote,
    required DeleteHighlight deleteHighlight,
  })  : _getNotesByReading = getNotesByReading,
        _getHighlightsByReading = getHighlightsByReading,
        _saveNote = saveNote,
        _saveHighlight = saveHighlight,
        _deleteNote = deleteNote,
        _deleteHighlight = deleteHighlight,
        super(const NotesInitial()) {
    on<LoadNotesAndHighlights>(_onLoadNotesAndHighlights);
    on<AddNote>(_onAddNote);
    on<AddHighlight>(_onAddHighlight);
    on<UpdateNote>(_onUpdateNote);
    on<UpdateHighlight>(_onUpdateHighlight);
    on<RemoveNote>(_onRemoveNote);
    on<RemoveHighlight>(_onRemoveHighlight);
  }

  final GetNotesByReading _getNotesByReading;
  final GetHighlightsByReading _getHighlightsByReading;
  final SaveNote _saveNote;
  final SaveHighlight _saveHighlight;
  final DeleteNote _deleteNote;
  final DeleteHighlight _deleteHighlight;

  Future<void> _onLoadNotesAndHighlights(
    LoadNotesAndHighlights event,
    Emitter<NotesState> emit,
  ) async {
    emit(const NotesLoading());

    final notesResult = await _getNotesByReading(
      GetNotesByReadingParams(
        userId: event.userId,
        readingId: event.readingId,
      ),
    );

    final highlightsResult = await _getHighlightsByReading(
      GetHighlightsByReadingParams(
        userId: event.userId,
        readingId: event.readingId,
      ),
    );

    notesResult.fold(
      (failure) => emit(NotesError(message: failure.message)),
      (notes) {
        highlightsResult.fold(
          (failure) => emit(NotesError(message: failure.message)),
          (highlights) =>
              emit(NotesLoaded(notes: notes, highlights: highlights)),
        );
      },
    );
  }

  Future<void> _onAddNote(
    AddNote event,
    Emitter<NotesState> emit,
  ) async {
    final result = await _saveNote(event.note);

    result.fold(
      (failure) => emit(NotesError(message: failure.message)),
      (_) async {
        emit(const NoteAdded());
        // Automatically reload the notes after adding
        await _reloadNotesAndHighlights(event.userId, event.readingId, emit);
      },
    );
  }

  Future<void> _onAddHighlight(
    AddHighlight event,
    Emitter<NotesState> emit,
  ) async {
    final result = await _saveHighlight(event.highlight);

    result.fold(
      (failure) => emit(NotesError(message: failure.message)),
      (_) async {
        emit(const HighlightAdded());
        // Automatically reload the notes after adding
        await _reloadNotesAndHighlights(
            event.userId, event.readingId, emit);
      },
    );
  }

  Future<void> _onUpdateNote(
    UpdateNote event,
    Emitter<NotesState> emit,
  ) async {
    final result = await _saveNote(event.note);

    result.fold(
      (failure) => emit(NotesError(message: failure.message)),
      (_) => emit(const NoteUpdated()),
    );
  }

  Future<void> _onUpdateHighlight(
    UpdateHighlight event,
    Emitter<NotesState> emit,
  ) async {
    final result = await _saveHighlight(event.highlight);

    result.fold(
      (failure) => emit(NotesError(message: failure.message)),
      (_) => emit(const HighlightUpdated()),
    );
  }

  Future<void> _onRemoveNote(
    RemoveNote event,
    Emitter<NotesState> emit,
  ) async {
    final result = await _deleteNote(event.noteId);

    result.fold(
      (failure) => emit(NotesError(message: failure.message)),
      (_) async {
        emit(const NoteRemoved());
        // We need userId and readingId to reload, so we'll handle this in the UI
      },
    );
  }

  Future<void> _onRemoveHighlight(
    RemoveHighlight event,
    Emitter<NotesState> emit,
  ) async {
    final result = await _deleteHighlight(event.highlightId);

    result.fold(
      (failure) => emit(NotesError(message: failure.message)),
      (_) => emit(const HighlightRemoved()),
    );
  }

  Future<void> _reloadNotesAndHighlights(
    String userId,
    String readingId,
    Emitter<NotesState> emit,
  ) async {
    final notesResult = await _getNotesByReading(
      GetNotesByReadingParams(
        userId: userId,
        readingId: readingId,
      ),
    );

    final highlightsResult = await _getHighlightsByReading(
      GetHighlightsByReadingParams(
        userId: userId,
        readingId: readingId,
      ),
    );

    notesResult.fold(
      (failure) => emit(NotesError(message: failure.message)),
      (notes) {
        highlightsResult.fold(
          (failure) => emit(NotesError(message: failure.message)),
          (highlights) =>
              emit(NotesLoaded(notes: notes, highlights: highlights)),
        );
      },
    );
  }
}
