import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/note_model.dart';
import '../models/highlight_model.dart';

abstract class NotesRemoteDataSource {
  Future<List<NoteModel>> getNotesByReading(String userId, String readingId);
  Future<List<HighlightModel>> getHighlightsByReading(String userId, String readingId);
  Future<void> saveNote(NoteModel note);
  Future<void> saveHighlight(HighlightModel highlight);
  Future<void> updateNote(NoteModel note);
  Future<void> updateHighlight(HighlightModel highlight);
  Future<void> deleteNote(String noteId);
  Future<void> deleteHighlight(String highlightId);
  Future<List<NoteModel>> getAllUserNotes(String userId);
}

class NotesRemoteDataSourceImpl implements NotesRemoteDataSource {
  const NotesRemoteDataSourceImpl({required this.firestore});

  final FirebaseFirestore firestore;

  @override
  Future<List<NoteModel>> getNotesByReading(String userId, String readingId) async {
    final query = await firestore
        .collection('notes')
        .where('userId', isEqualTo: userId)
        .where('readingId', isEqualTo: readingId)
        .orderBy('createdAt', descending: true)
        .get();

    return query.docs
        .map((doc) => NoteModel.fromMap({...doc.data(), 'id': doc.id}))
        .toList();
  }

  @override
  Future<List<HighlightModel>> getHighlightsByReading(String userId, String readingId) async {
    final query = await firestore
        .collection('highlights')
        .where('userId', isEqualTo: userId)
        .where('readingId', isEqualTo: readingId)
        .orderBy('startPosition')
        .get();

    return query.docs
        .map((doc) => HighlightModel.fromMap({...doc.data(), 'id': doc.id}))
        .toList();
  }

  @override
  Future<void> saveNote(NoteModel note) async {
    final data = note.toMap();
    data.remove('id'); // Remove id from data before saving
    
    await firestore
        .collection('notes')
        .doc(note.id)
        .set(data);
  }

  @override
  Future<void> saveHighlight(HighlightModel highlight) async {
    final data = highlight.toMap();
    data.remove('id'); // Remove id from data before saving
    
    await firestore
        .collection('highlights')
        .doc(highlight.id)
        .set(data);
  }

  @override
  Future<void> updateNote(NoteModel note) async {
    final data = note.toMap();
    data.remove('id'); // Remove id from data before updating
    data['updatedAt'] = DateTime.now().millisecondsSinceEpoch;
    
    await firestore
        .collection('notes')
        .doc(note.id)
        .update(data);
  }

  @override
  Future<void> updateHighlight(HighlightModel highlight) async {
    final data = highlight.toMap();
    data.remove('id'); // Remove id from data before updating
    
    await firestore
        .collection('highlights')
        .doc(highlight.id)
        .update(data);
  }

  @override
  Future<void> deleteNote(String noteId) async {
    await firestore
        .collection('notes')
        .doc(noteId)
        .delete();
  }

  @override
  Future<void> deleteHighlight(String highlightId) async {
    await firestore
        .collection('highlights')
        .doc(highlightId)
        .delete();
  }

  @override
  Future<List<NoteModel>> getAllUserNotes(String userId) async {
    final query = await firestore
        .collection('notes')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .get();

    return query.docs
        .map((doc) => NoteModel.fromMap({...doc.data(), 'id': doc.id}))
        .toList();
  }
}