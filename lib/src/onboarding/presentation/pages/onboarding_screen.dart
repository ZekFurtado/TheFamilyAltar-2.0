import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:thefamilyaltar/core/services/injection_container.dart';
import 'package:thefamilyaltar/src/onboarding/domain/entities/onboarding_slide.dart';
import 'package:thefamilyaltar/src/onboarding/presentation/bloc/onboarding_bloc.dart';
import 'package:thefamilyaltar/src/onboarding/presentation/widgets/onboarding_slide_widget.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  final List<OnboardingSlide> _slides = const [
    OnboardingSlide(
      title: 'Daily Scripture Readings',
      description: 'Discover daily scripture readings from The Family Altar. Each day brings new wisdom and spiritual nourishment to guide your faith journey.',
      imagePath: 'daily_reading',
    ),
    OnboardingSlide(
      title: 'Build Your Reading Streak',
      description: 'Stay consistent with your daily readings and build lasting habits. Track your progress and celebrate milestones on your spiritual journey.',
      imagePath: 'streak',
    ),
    OnboardingSlide(
      title: 'Complete Bible Access',
      description: 'Access the full KJV and NKJV Bible with offline support. Bookmark verses, take notes, and deepen your understanding of God\'s word.',
      imagePath: 'bible',
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<OnboardingBloc>(),
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: SafeArea(
          child: Column(
            children: [
              // Top bar with Skip button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        context.read<OnboardingBloc>().add(
                              const CacheFirstTimerEvent(),
                            );
                      },
                      child: Text(
                        'Skip',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 8,
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: _slides.length,
                  onPageChanged: (index) {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    return OnboardingSlideWidget(slide: _slides[index]);
                  },
                ),
              ),
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          _slides.length,
                          (index) => AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: const EdgeInsets.symmetric(horizontal: 4.0),
                            height: 8.0,
                            width: _currentIndex == index ? 24.0 : 8.0,
                            decoration: BoxDecoration(
                              color: _currentIndex == index
                                  ? Theme.of(context).colorScheme.primary
                                  : Theme.of(context).colorScheme.outline,
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                      Row(
                        children: [
                          if (_currentIndex > 0)
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () {
                                  _pageController.previousPage(
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeInOut,
                                  );
                                },
                                child: const Text('Previous'),
                              ),
                            )
                          else
                            const Expanded(child: SizedBox()),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _currentIndex == _slides.length - 1
                                ? BlocConsumer<OnboardingBloc, OnboardingState>(
                                    listener: (context, state) {
                                      if (state is UserCached) {
                                        Navigator.of(context).pushReplacementNamed('/login');
                                      } else if (state is OnboardingError) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text(state.message)),
                                        );
                                      }
                                    },
                                    builder: (context, state) {
                                      return ElevatedButton(
                                        onPressed: state is CachingFirstTimer
                                            ? null
                                            : () {
                                                context.read<OnboardingBloc>().add(
                                                      const CacheFirstTimerEvent(),
                                                    );
                                              },
                                        child: state is CachingFirstTimer
                                            ? const SizedBox(
                                                height: 16,
                                                width: 16,
                                                child: CircularProgressIndicator(
                                                  strokeWidth: 2,
                                                ),
                                              )
                                            : const Text('Get Started'),
                                      );
                                    },
                                  )
                                : ElevatedButton(
                                    onPressed: () {
                                      _pageController.nextPage(
                                        duration: const Duration(milliseconds: 300),
                                        curve: Curves.easeInOut,
                                      );
                                    },
                                    child: const Text('Next'),
                                  ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}