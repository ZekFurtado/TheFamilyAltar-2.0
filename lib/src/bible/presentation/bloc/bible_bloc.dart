import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:developer';

import '../../domain/usecases/get_available_versions.dart';
import '../../domain/usecases/get_bible_books.dart';
import '../../domain/usecases/get_bible_chapter.dart';
import '../../domain/usecases/get_scripture_verses.dart';
import 'bible_event.dart';
import 'bible_state.dart';

class BibleBloc extends Bloc<BibleEvent, BibleState> {
  BibleBloc({
    required GetAvailableVersions getAvailableVersions,
    required GetBibleBooks getBibleBooks,
    required GetBibleChapter getBibleChapter,
    required GetScriptureVerses getScriptureVerses,
  })  : _getAvailableVersions = getAvailableVersions,
        _getBibleBooks = getBibleBooks,
        _getBibleChapter = getBibleChapter,
        _getScriptureVerses = getScriptureVerses,
        super(const BibleInitial()) {
    on<LoadAvailableVersions>(_loadAvailableVersionsHandler);
    on<SelectBibleVersion>(_selectBibleVersionHandler);
    on<LoadBibleBooks>(_loadBibleBooksHandler);
    on<LoadBibleChapter>(_loadBibleChapterHandler);
    on<NavigateToScripture>(_navigateToScriptureHandler);
    on<SearchVerses>(_searchVersesHandler);
    on<DownloadBibleVersion>(_downloadBibleVersionHandler);
    on<DeleteBibleVersion>(_deleteBibleVersionHandler);
  }

  final GetAvailableVersions _getAvailableVersions;
  final GetBibleBooks _getBibleBooks;
  final GetBibleChapter _getBibleChapter;
  final GetScriptureVerses _getScriptureVerses;

  Future<void> _loadAvailableVersionsHandler(
    LoadAvailableVersions event,
    Emitter<BibleState> emit,
  ) async {
    emit(const BibleLoading());

    final result = await _getAvailableVersions();

    result.fold(
      (failure) => emit(BibleError(failure.message)),
      (versions) => emit(BibleVersionsLoaded(
        versions: versions,
        selectedVersion: versions.isNotEmpty ? versions.first : null,
      )),
    );
  }

  Future<void> _selectBibleVersionHandler(
    SelectBibleVersion event,
    Emitter<BibleState> emit,
  ) async {
    if (state is BibleVersionsLoaded) {
      final currentState = state as BibleVersionsLoaded;
      final selectedVersion = currentState.versions
          .where((version) => version.id == event.versionId)
          .firstOrNull;
      
      if (selectedVersion != null) {
        emit(BibleVersionsLoaded(
          versions: currentState.versions,
          selectedVersion: selectedVersion,
        ));
      }
    }
  }

  Future<void> _loadBibleBooksHandler(
    LoadBibleBooks event,
    Emitter<BibleState> emit,
  ) async {
    emit(const BibleLoading());

    final result = await _getBibleBooks(
      GetBibleBooksParams(versionId: event.versionId),
    );

    result.fold(
      (failure) => emit(BibleError(failure.message)),
      (books) => emit(BibleBooksLoaded(
        books: books,
        versionId: event.versionId,
      )),
    );
  }

  Future<void> _loadBibleChapterHandler(
    LoadBibleChapter event,
    Emitter<BibleState> emit,
  ) async {
    emit(const BibleLoading());

    final result = await _getBibleChapter(
      GetBibleChapterParams(
        versionId: event.versionId,
        book: event.book,
        chapter: event.chapter,
      ),
    );

    result.fold(
      (failure) => emit(BibleError(failure.message)),
      (chapter) => emit(BibleChapterLoaded(
        chapter: chapter,
        versionId: event.versionId,
      )),
    );
  }

  Future<void> _navigateToScriptureHandler(
    NavigateToScripture event,
    Emitter<BibleState> emit,
  ) async {
    emit(const BibleLoading());

    final result = await _getScriptureVerses(
      GetScriptureVersesParams(
        versionId: event.versionId,
        reference: event.reference,
      ),
    );

    result.fold(
      (failure) => emit(BibleError(failure.message)),
      (verses) => emit(ScriptureVersesLoaded(
        verses: verses,
        versionId: event.versionId,
        reference: event.reference.displayText,
      )),
    );
  }

  Future<void> _searchVersesHandler(
    SearchVerses event,
    Emitter<BibleState> emit,
  ) async {
    emit(const BibleLoading());

    // For now, emit empty results since we haven't implemented search use case
    // TODO: Implement SearchVerses use case
    emit(BibleSearchResults(
      results: [],
      query: event.query,
      versionId: event.versionId,
    ));
  }

  Future<void> _downloadBibleVersionHandler(
    DownloadBibleVersion event,
    Emitter<BibleState> emit,
  ) async {
    // TODO: Implement download functionality
    emit(BibleVersionDownloaded(event.versionId));
  }

  Future<void> _deleteBibleVersionHandler(
    DeleteBibleVersion event,
    Emitter<BibleState> emit,
  ) async {
    // TODO: Implement delete functionality
    emit(BibleVersionDeleted(event.versionId));
  }
}