import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:thefamilyaltar/src/onboarding/domain/usecases/cache_first_timer.dart';
import 'package:thefamilyaltar/src/onboarding/domain/usecases/check_if_user_is_first_timer.dart';

part 'onboarding_event.dart';
part 'onboarding_state.dart';

class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  OnboardingBloc({
    required CacheFirstTimer cacheFirstTimer,
    required CheckIfUserIsFirstTimer checkIfUserIsFirstTimer,
  })  : _cacheFirstTimer = cacheFirstTimer,
        _checkIfUserIsFirstTimer = checkIfUserIsFirstTimer,
        super(const OnboardingInitial()) {
    on<CacheFirstTimerEvent>(_cacheFirstTimerHandler);
    on<CheckIfUserIsFirstTimerEvent>(_checkIfUserIsFirstTimerHandler);
  }

  final CacheFirstTimer _cacheFirstTimer;
  final CheckIfUserIsFirstTimer _checkIfUserIsFirstTimer;

  Future<void> _cacheFirstTimerHandler(
    CacheFirstTimerEvent event,
    Emitter<OnboardingState> emit,
  ) async {
    emit(const CachingFirstTimer());

    final result = await _cacheFirstTimer();

    result.fold(
      (failure) => emit(OnboardingError(failure.message)),
      (_) => emit(const UserCached()),
    );
  }

  Future<void> _checkIfUserIsFirstTimerHandler(
    CheckIfUserIsFirstTimerEvent event,
    Emitter<OnboardingState> emit,
  ) async {
    emit(const CheckingIfUserIsFirstTimer());

    final result = await _checkIfUserIsFirstTimer();

    result.fold(
      (failure) => emit(OnboardingError(failure.message)),
      (isFirstTimer) => emit(OnboardingStatus(isFirstTimer: isFirstTimer)),
    );
  }
}