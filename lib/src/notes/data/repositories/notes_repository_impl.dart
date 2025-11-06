import 'package:dartz/dartz.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/utils/typedef.dart';
import '../../domain/entities/note.dart';
import '../../domain/entities/highlight.dart';
import '../../domain/repositories/notes_repository.dart';
import '../datasources/notes_remote_data_source.dart';
import '../models/note_model.dart';
import '../models/highlight_model.dart';

class NotesRepositoryImpl implements NotesRepository {
  const NotesRepositoryImpl({
    required this.remoteDataSource,
  });

  final NotesRemoteDataSource remoteDataSource;

  @override
  ResultFuture<List<Note>> getNotesByReading(String userId, String readingId) async {
    try {
      final result = await remoteDataSource.getNotesByReading(userId, readingId);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    }
  }

  @override
  ResultFuture<List<Highlight>> getHighlightsByReading(String userId, String readingId) async {
    try {
      final result = await remoteDataSource.getHighlightsByReading(userId, readingId);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    }
  }

  @override
  ResultVoid saveNote(Note note) async {
    try {
      await remoteDataSource.saveNote(NoteModel.fromEntity(note));
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    }
  }

  @override
  ResultVoid saveHighlight(Highlight highlight) async {
    try {
      await remoteDataSource.saveHighlight(HighlightModel.fromEntity(highlight));
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    }
  }

  @override
  ResultVoid updateNote(Note note) async {
    try {
      await remoteDataSource.updateNote(NoteModel.fromEntity(note));
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    }
  }

  @override
  ResultVoid updateHighlight(Highlight highlight) async {
    try {
      await remoteDataSource.updateHighlight(HighlightModel.fromEntity(highlight));
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    }
  }

  @override
  ResultVoid deleteNote(String noteId) async {
    try {
      await remoteDataSource.deleteNote(noteId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    }
  }

  @override
  ResultVoid deleteHighlight(String highlightId) async {
    try {
      await remoteDataSource.deleteHighlight(highlightId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    }
  }

  @override
  ResultFuture<List<Note>> getAllUserNotes(String userId) async {
    try {
      final result = await remoteDataSource.getAllUserNotes(userId);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    }
  }
}