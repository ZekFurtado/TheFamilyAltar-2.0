import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/services/injection_container.dart';
import '../../domain/entities/bible_book.dart';
import '../bloc/bible_bloc.dart';
import '../bloc/bible_event.dart';
import '../bloc/bible_state.dart';
import 'bible_chapter_screen.dart';

class BibleBooksScreen extends StatelessWidget {
  const BibleBooksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<BibleBloc>()..add(const LoadAvailableVersions()),
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
          title: Text(
            "Bible",
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
          ),
          backgroundColor: Theme.of(context).colorScheme.surface,
          elevation: 0,
          actions: [
            IconButton(
              onPressed: () {
                // TODO: Navigate to Bible search
              },
              icon: Icon(
                Icons.search,
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

            if (state is BibleVersionsLoaded) {
              return Column(
                children: [
                  _buildVersionSelector(context, state),
                  Expanded(
                    child: _buildContent(context, state),
                  ),
                ],
              );
            }

            if (state is BibleBooksLoaded) {
              return _buildBooksList(context, state.books);
            }

            return _buildEmptyState(context);
          },
        ),
      ),
    );
  }

  Widget _buildVersionSelector(BuildContext context, BibleVersionsLoaded state) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
          ),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.menu_book,
            color: Theme.of(context).colorScheme.primary,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: DropdownButton<String>(
              value: state.selectedVersion?.id,
              isExpanded: true,
              underline: const SizedBox(),
              items: state.versions.map((version) {
                return DropdownMenuItem<String>(
                  value: version.id,
                  child: Text(
                    version.name,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                );
              }).toList(),
              onChanged: (versionId) {
                if (versionId != null) {
                  context.read<BibleBloc>().add(SelectBibleVersion(versionId));
                  context.read<BibleBloc>().add(LoadBibleBooks(versionId));
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context, BibleVersionsLoaded state) {
    if (state.selectedVersion != null) {
      context.read<BibleBloc>().add(LoadBibleBooks(state.selectedVersion!.id));
      return const Center(child: CircularProgressIndicator());
    }
    
    return _buildEmptyState(context);
  }

  Widget _buildBooksList(BuildContext context, List<BibleBook> books) {
    final oldTestamentBooks = books.where((book) => book.testament == Testament.oldTestament).toList();
    final newTestamentBooks = books.where((book) => book.testament == Testament.newTestament).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTestamentSection(context, "Old Testament", oldTestamentBooks),
          const SizedBox(height: 32),
          _buildTestamentSection(context, "New Testament", newTestamentBooks),
        ],
      ),
    );
  }

  Widget _buildTestamentSection(BuildContext context, String title, List<BibleBook> books) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
        ),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 2.5,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: books.length,
          itemBuilder: (context, index) {
            final book = books[index];
            return _buildBookCard(context, book);
          },
        ),
      ],
    );
  }

  Widget _buildBookCard(BuildContext context, BibleBook book) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BibleChapterScreen(book: book),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              book.name,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              '${book.chapterCount} chapters',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.menu_book_outlined,
            size: 80,
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 24),
          Text(
            "Select a Bible Version",
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              "Choose a Bible version to start reading",
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}