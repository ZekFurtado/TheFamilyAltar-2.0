import 'package:equatable/equatable.dart';

class OnboardingSlide extends Equatable {
  const OnboardingSlide({
    required this.title,
    required this.description,
    required this.imagePath,
  });

  final String title;
  final String description;
  final String imagePath;

  @override
  List<Object?> get props => [title, description, imagePath];
}