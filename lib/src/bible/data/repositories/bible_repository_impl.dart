import 'package:dartz/dartz.dart';
import 'dart:developer';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/utils/typedef.dart';
import '../../domain/entities/bible_book.dart';
import '../../domain/entities/bible_chapter.dart';
import '../../domain/entities/bible_version.dart';
import '../../domain/entities/bible_verse.dart';
import '../../domain/entities/scripture_reference.dart';
import '../../domain/repositories/bible_repository.dart';
import '../datasources/bible_local_data_source.dart';

class BibleRepositoryImpl implements BibleRepository {
  const BibleRepositoryImpl({required this.localDataSource});

  final BibleLocalDataSource localDataSource;

  @override
  ResultFuture<List<BibleVersion>> getAvailableVersions() async {
    try {
      final result = await localDataSource.getAvailableVersions();
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } catch (e, s) {
      log('BibleRepositoryImpl.getAvailableVersions error: $e\nStackTrace: $s');
      return Left(ServerFailure(message: e.toString(), statusCode: '500'));
    }
  }

  @override
  ResultFuture<List<BibleBook>> getBooks(String versionId) async {
    try {
      final result = await localDataSource.getBooks(versionId);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } catch (e, s) {
      log('BibleRepositoryImpl.getBooks error: $e\nStackTrace: $s');
      return Left(ServerFailure(message: e.toString(), statusCode: '500'));
    }
  }

  @override
  ResultFuture<BibleChapter> getChapter({
    required String versionId,
    required String book,
    required int chapter,
  }) async {
    try {
      final result = await localDataSource.getChapter(
        versionId: versionId,
        book: book,
        chapter: chapter,
      );
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } catch (e, s) {
      log('BibleRepositoryImpl.getChapter error: $e\nStackTrace: $s');
      return Left(ServerFailure(message: e.toString(), statusCode: '500'));
    }
  }

  @override
  ResultFuture<List<BibleVerse>> getVerses({
    required String versionId,
    required ScriptureReference reference,
  }) async {
    try {
      final result = await localDataSource.getVerses(
        versionId: versionId,
        reference: reference,
      );
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } catch (e, s) {
      log('BibleRepositoryImpl.getVerses error: $e\nStackTrace: $s');
      return Left(ServerFailure(message: e.toString(), statusCode: '500'));
    }
  }

  @override
  ResultFuture<List<BibleVerse>> searchVerses({
    required String versionId,
    required String query,
    String? book,
  }) async {
    try {
      final result = await localDataSource.searchVerses(
        versionId: versionId,
        query: query,
        book: book,
      );
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } catch (e, s) {
      log('BibleRepositoryImpl.searchVerses error: $e\nStackTrace: $s');
      return Left(ServerFailure(message: e.toString(), statusCode: '500'));
    }
  }

  @override
  ResultFuture<void> downloadVersion(String versionId) async {
    try {
      await localDataSource.downloadVersion(versionId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } catch (e, s) {
      log('BibleRepositoryImpl.downloadVersion error: $e\nStackTrace: $s');
      return Left(ServerFailure(message: e.toString(), statusCode: '500'));
    }
  }

  @override
  ResultFuture<void> deleteVersion(String versionId) async {
    try {
      await localDataSource.deleteVersion(versionId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } catch (e, s) {
      log('BibleRepositoryImpl.deleteVersion error: $e\nStackTrace: $s');
      return Left(ServerFailure(message: e.toString(), statusCode: '500'));
    }
  }

  @override
  ResultFuture<BibleVersion?> getSelectedVersion() async {
    try {
      final result = await localDataSource.getSelectedVersion();
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } catch (e, s) {
      log('BibleRepositoryImpl.getSelectedVersion error: $e\nStackTrace: $s');
      return Left(ServerFailure(message: e.toString(), statusCode: '500'));
    }
  }

  @override
  ResultVoid setSelectedVersion(String versionId) async {
    try {
      await localDataSource.setSelectedVersion(versionId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } catch (e, s) {
      log('BibleRepositoryImpl.setSelectedVersion error: $e\nStackTrace: $s');
      return Left(ServerFailure(message: e.toString(), statusCode: '500'));
    }
  }
}