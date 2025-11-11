import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/typedef.dart';
import '../entities/bible_version.dart';
import '../repositories/bible_repository.dart';

class GetAvailableVersions extends UseCaseWithoutParams<List<BibleVersion>> {
  const GetAvailableVersions(this._repository);

  final BibleRepository _repository;

  @override
  ResultFuture<List<BibleVersion>> call() async {
    return _repository.getAvailableVersions();
  }
}