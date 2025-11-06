import '../../../../core/utils/typedef.dart';
import '../entities/note.dart';
import '../entities/highlight.dart';

abstract class NotesRepository {
  ResultFuture<List<Note>> getNotesByReading(String userId, String readingId);
  ResultFuture<List<Highlight>> getHighlightsByReading(String userId, String readingId);
  ResultVoid saveNote(Note note);
  ResultVoid saveHighlight(Highlight highlight);
  ResultVoid updateNote(Note note);
  ResultVoid updateHighlight(Highlight highlight);
  ResultVoid deleteNote(String noteId);
  ResultVoid deleteHighlight(String highlightId);
  ResultFuture<List<Note>> getAllUserNotes(String userId);
}