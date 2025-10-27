part of 'onboarding_bloc.dart';

abstract class OnboardingEvent extends Equatable {
  const OnboardingEvent();

  @override
  List<Object> get props => [];
}

class CacheFirstTimerEvent extends OnboardingEvent {
  const CacheFirstTimerEvent();
}

class CheckIfUserIsFirstTimerEvent extends OnboardingEvent {
  const CheckIfUserIsFirstTimerEvent();
}