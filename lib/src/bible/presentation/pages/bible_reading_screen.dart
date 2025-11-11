import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/services/injection_container.dart';
import '../../domain/entities/bible_book.dart';
import '../../domain/entities/bible_verse.dart';
import '../bloc/bible_bloc.dart';
import '../bloc/bible_event.dart';
import '../bloc/bible_state.dart';

class BibleReadingScreen extends StatelessWidget {
  const BibleReadingScreen({
    super.key,
    required this.book,
    required this.chapter,
    required this.versionId,
  });

  final BibleBook book;
  final int chapter;
  final String versionId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<BibleBloc>()
        ..add(LoadBibleChapter(
          versionId: versionId,
          book: book.name,
          chapter: chapter,
        )),
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
          title: Text(
            '${book.name} $chapter',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
          ),
          backgroundColor: Theme.of(context).colorScheme.surface,
          elevation: 0,
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              Icons.arrow_back,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {
                // TODO: Add bookmarking functionality
              },
              icon: Icon(
                Icons.bookmark_border,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            IconButton(
              onPressed: () {
                // TODO: Add sharing functionality
              },
              icon: Icon(
                Icons.share,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ],
        ),
        body: BlocConsumer<BibleBloc, BibleState>(
          listener: (context, state) {
            if (state is BibleError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is BibleLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is BibleChapterLoaded) {
              return _buildChapterContent(context, state.chapter.verses);
            }

            return _buildErrorState(context);
          },
        ),
        bottomNavigationBar: _buildNavigationBar(context),
      ),
    );
  }

  Widget _buildChapterContent(BuildContext context, List<BibleVerse> verses) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Theme.of(context)
                  .colorScheme
                  .primaryContainer
                  .withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.menu_book,
                      color: Theme.of(context).colorScheme.primary,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      '${book.name} Chapter $chapter',
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'King James Version',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          ...verses.map((verse) => _buildVerseWidget(context, verse)),
          const SizedBox(height: 24),
          _buildChapterNavigation(context),
        ],
      ),
    );
  }

  Widget _buildVerseWidget(BuildContext context, BibleVerse verse) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Text(
                verse.verse.toString(),
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: SelectableText(
              verse.text,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                    height: 1.6,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChapterNavigation(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (chapter > 1)
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => BibleReadingScreen(
                    book: book,
                    chapter: chapter - 1,
                    versionId: versionId,
                  ),
                ),
              );
            },
            icon: const Icon(Icons.arrow_back),
            label: Text('Chapter ${chapter - 1}'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
              foregroundColor: Theme.of(context).colorScheme.onSurface,
            ),
          )
        else
          const SizedBox(),
        if (chapter < book.chapterCount)
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => BibleReadingScreen(
                    book: book,
                    chapter: chapter + 1,
                    versionId: versionId,
                  ),
                ),
              );
            },
            icon: const Icon(Icons.arrow_forward),
            label: Text('Chapter ${chapter + 1}'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
            ),
          )
        else
          const SizedBox(),
      ],
    );
  }

  Widget _buildNavigationBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            onPressed: () {
              // TODO: Add note functionality
            },
            icon: Icon(
              Icons.note_add_outlined,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          IconButton(
            onPressed: () {
              // TODO: Add highlight functionality
            },
            icon: Icon(
              Icons.highlight_outlined,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          IconButton(
            onPressed: () {
              // TODO: Add bookmark functionality
            },
            icon: Icon(
              Icons.bookmark_outline,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          IconButton(
            onPressed: () {
              // TODO: Add font size adjustment
            },
            icon: Icon(
              Icons.text_fields,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 80,
            color: Theme.of(context).colorScheme.error,
          ),
          const SizedBox(height: 24),
          Text(
            "Unable to Load Chapter",
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.error,
                ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              "Please check your connection and try again",
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              context.read<BibleBloc>().add(LoadBibleChapter(
                    versionId: versionId,
                    book: book.name,
                    chapter: chapter,
                  ));
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}