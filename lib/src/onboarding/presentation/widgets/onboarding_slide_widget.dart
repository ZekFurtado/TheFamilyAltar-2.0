import 'package:flutter/material.dart';
import 'package:thefamilyaltar/src/onboarding/domain/entities/onboarding_slide.dart';

class OnboardingSlideWidget extends StatelessWidget {
  const OnboardingSlideWidget({required this.slide, super.key});

  final OnboardingSlide slide;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            _getIconFromPath(slide.imagePath),
            size: 120,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: 48),
          Text(
            slide.title,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Text(
            slide.description,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  IconData _getIconFromPath(String path) {
    switch (path) {
      case 'daily_reading':
        return Icons.menu_book;
      case 'streak':
        return Icons.local_fire_department;
      case 'bible':
        return Icons.church;
      default:
        return Icons.info;
    }
  }
}