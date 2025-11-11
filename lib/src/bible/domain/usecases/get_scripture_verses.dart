import 'package:equatable/equatable.dart';

import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/typedef.dart';
import '../entities/bible_verse.dart';
import '../entities/scripture_reference.dart';
import '../repositories/bible_repository.dart';

class GetScriptureVerses extends UseCaseWithParams<List<BibleVerse>, GetScriptureVersesParams> {
  const GetScriptureVerses(this._repository);

  final BibleRepository _repository;

  @override
  ResultFuture<List<BibleVerse>> call(GetScriptureVersesParams params) async {
    return _repository.getVerses(
      versionId: params.versionId,
      reference: params.reference,
    );
  }
}

class GetScriptureVersesParams extends Equatable {
  const GetScriptureVersesParams({
    required this.versionId,
    required this.reference,
  });

  final String versionId;
  final ScriptureReference reference;

  @override
  List<Object?> get props => [versionId, reference];
}