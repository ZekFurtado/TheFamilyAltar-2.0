import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/services/injection_container.dart';
import '../../../notes/domain/entities/note.dart';
import '../../../notes/presentation/bloc/notes_bloc.dart';
import '../../../notes/presentation/bloc/notes_event.dart';
import '../../../notes/presentation/bloc/notes_state.dart';
import '../../../notes/presentation/widgets/highlightable_text.dart';
import '../../../notes/presentation/widgets/notes_bottom_sheet.dart';
import '../../../notes/presentation/widgets/notes_list.dart';
import '../../../bible/presentation/widgets/clickable_scripture_text.dart';
import '../../domain/entities/daily_reading.dart';
import '../bloc/home_bloc.dart';

class ReadingDetailScreen extends StatefulWidget {
  const ReadingDetailScreen({
    super.key,
    required this.reading,
    this.userId,
  });

  final DailyReading reading;
  final String? userId;

  @override
  State<ReadingDetailScreen> createState() => _ReadingDetailScreenState();
}

class _ReadingDetailScreenState extends State<ReadingDetailScreen> {
  Timer? _timer;
  bool _hasMarkedComplete = false;

  @override
  void initState() {
    super.initState();
    _startReadingTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startReadingTimer() {
    _timer = Timer(const Duration(seconds: 30), () {
      if (!_hasMarkedComplete && widget.userId != null) {
        context.read<HomeBloc>().add(
              MarkReadingComplete(
                userId: widget.userId!,
                readDate:
                    DateTime.now(), // Use current date for streak tracking
              ),
            );
        _hasMarkedComplete = true;
      }
    });
  }

  String get _readingId => '${DateTime.now().month}-${DateTime.now().day}';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<NotesBloc>()..add(
        LoadNotesAndHighlights(
          userId: widget.userId ?? '',
          readingId: _readingId,
        ),
      ),
      child: Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Text(
          "Daily Reading",
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
              if (widget.userId == null) {
                // _showLoginRequiredDialog(context);
              } else {
                _showNotesBottomSheet(context);
              }
            },
            icon: Icon(
              Icons.note_add,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<HomeBloc, HomeState>(
            listener: (context, state) {
              if (state is ReadingMarkedComplete) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text("Reading completed! Streak updated."),
                    backgroundColor: Colors.green,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            },
          ),
          BlocListener<NotesBloc, NotesState>(
            listener: (context, state) {
              print(state);
              if (state is NoteAdded || state is HighlightAdded) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Note saved successfully!"),
                    backgroundColor: Colors.green,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
                // No need to manually reload - BLoC handles it automatically
              } else if (state is NotesError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.red,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              } else if (state is NoteRemoved || state is HighlightRemoved) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text("Note deleted successfully!"),
                    backgroundColor: Colors.orange,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
                // Reload notes and highlights for deletions
                context.read<NotesBloc>().add(
                      LoadNotesAndHighlights(
                        userId: widget.userId ?? '',
                        readingId: _readingId,
                      ),
                    );
              }
            },
          ),
        ],
        child: SingleChildScrollView(
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
                    Text(
                      widget.reading.title,
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium
                          ?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Theme.of(context)
                              .colorScheme
                              .outline
                              .withValues(alpha: 0.2),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Make the scripture reference clickable
                          ClickableScriptureText(
                            text: widget.reading.scripture,
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                          ),
                          const SizedBox(height: 8),
                          // Keep scripture text as regular text with potential scripture references clickable
                          ClickableScriptureText(
                            text: widget.reading.scriptureText,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  fontStyle: FontStyle.italic,
                                  color: Theme.of(context).colorScheme.onSurface,
                                  height: 1.5,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              BlocBuilder<NotesBloc, NotesState>(
                builder: (context, notesState) {
                  final highlights = notesState is NotesLoaded
                      ? notesState.highlights
                          .map((h) => TextHighlight(
                                startPosition: h.startPosition,
                                endPosition: h.endPosition,
                                color: h.color,
                              ))
                          .toList()
                      : <TextHighlight>[];

                  return _buildClickableSection(
                    context: context,
                    title: "Today's Message",
                    content: widget.reading.sermonContent,
                    icon: Icons.auto_stories,
                  );
                },
              ),
              const SizedBox(height: 24),
              BlocBuilder<NotesBloc, NotesState>(
                builder: (context, notesState) {
                  final highlights = notesState is NotesLoaded
                      ? notesState.highlights
                          .map((h) => TextHighlight(
                                startPosition: h.startPosition,
                                endPosition: h.endPosition,
                                color: h.color,
                              ))
                          .toList()
                      : <TextHighlight>[];

                  return _buildScriptureSection(
                    context: context,
                    title: "Scriptures for Today",
                    content: widget.reading.scripturesForDay.join('\n\n'),
                    icon: Icons.menu_book,
                    highlights: highlights,
                  );
                },
              ),
              const SizedBox(height: 24),
              _buildClickableSection(
                context: context,
                title: "Sermon Reference",
                content: widget.reading.sermonReference,
                icon: Icons.link,
              ),
              const SizedBox(height: 24),
              BlocBuilder<NotesBloc, NotesState>(
                builder: (context, notesState) {
                  if (widget.userId == null) {
                    // return _buildLoginPromptSection(context);
                    return Container(); // Return empty container instead of login prompt
                  }
                  
                  print("notesState in BlocBuilder:");
                  print(notesState);
                  if (notesState is NotesLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (notesState is NotesLoaded) {
                    return _buildNotesSection(context, notesState.notes);
                  }

                  return _buildNotesSection(context, []);
                },
              ),
              const SizedBox(height: 32),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .colorScheme
                      .surfaceContainerHighest
                      .withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.attribution,
                      size: 16,
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withValues(alpha: 0.6),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Content provided by Voice of God Recordings Inc.',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withValues(alpha: 0.6),
                            fontSize: 11,
                          ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
      ),
    );
  }

  Widget _buildSection({
    required BuildContext context,
    required String title,
    required String content,
    required IconData icon,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: Theme.of(context).colorScheme.primary,
                size: 24,
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.primary,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            content,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                  height: 1.6,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildClickableSection({
    required BuildContext context,
    required String title,
    required String content,
    required IconData icon,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: Theme.of(context).colorScheme.primary,
                size: 24,
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.primary,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ClickableScriptureText(
            text: content,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                  height: 1.6,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildHighlightableSection({
    required BuildContext context,
    required String title,
    required String content,
    required IconData icon,
    required List<TextHighlight> highlights,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: Theme.of(context).colorScheme.primary,
                size: 24,
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.primary,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          HighlightableText(
            text: content,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                  height: 1.6,
                ),
            highlights: highlights,
            onTextSelected: (selectedText, startIndex, endIndex) {
              if (widget.userId == null) {
                // _showLoginRequiredDialog(context);
              } else {
                _showNotesBottomSheet(
                  context,
                  selectedText: selectedText,
                  startPosition: startIndex,
                  endPosition: endIndex,
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildHighlightableClickableSection({
    required BuildContext context,
    required String title,
    required String content,
    required IconData icon,
    required List<TextHighlight> highlights,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: Theme.of(context).colorScheme.primary,
                size: 24,
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.primary,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ClickableScriptureText(
            text: content,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                  height: 1.6,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildScriptureSection({
    required BuildContext context,
    required String title,
    required String content,
    required IconData icon,
    required List<TextHighlight> highlights,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: Theme.of(context).colorScheme.primary,
                size: 24,
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.primary,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ClickableScriptureText(
            text: content,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                  height: 1.6,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotesSection(BuildContext context, List<Note> notes) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.notes,
                color: Theme.of(context).colorScheme.primary,
                size: 24,
              ),
              const SizedBox(width: 12),
              Text(
                'My Notes',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.primary,
                    ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.cloud_sync,
                      size: 14,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Synced',
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          NotesList(
            notes: notes,
            userId: widget.userId,
            readingId: _readingId,
          ),
        ],
      ),
    );
  }

  // Widget _buildLoginPromptSection(BuildContext context) {
  //   return Container(
  //     width: double.infinity,
  //     padding: const EdgeInsets.all(20),
  //     decoration: BoxDecoration(
  //       color: Theme.of(context).colorScheme.surface,
  //       borderRadius: BorderRadius.circular(16),
  //       border: Border.all(
  //         color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
  //       ),
  //     ),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Row(
  //           children: [
  //             Icon(
  //               Icons.notes_outlined,
  //               color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
  //               size: 24,
  //             ),
  //             const SizedBox(width: 12),
  //             Text(
  //               'My Notes',
  //               style: Theme.of(context).textTheme.titleLarge?.copyWith(
  //                     fontWeight: FontWeight.w600,
  //                     color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
  //                   ),
  //             ),
  //           ],
  //         ),
  //         const SizedBox(height: 16),
  //         Container(
  //           width: double.infinity,
  //           padding: const EdgeInsets.all(16),
  //           decoration: BoxDecoration(
  //             color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.3),
  //             borderRadius: BorderRadius.circular(12),
  //           ),
  //           child: Column(
  //             children: [
  //               Icon(
  //                 Icons.account_circle_outlined,
  //                 size: 48,
  //                 color: Theme.of(context).colorScheme.primary,
  //               ),
  //               const SizedBox(height: 12),
  //               Text(
  //                 'Sign in to save notes and highlights',
  //                 style: Theme.of(context).textTheme.titleMedium?.copyWith(
  //                   fontWeight: FontWeight.w600,
  //                 ),
  //                 textAlign: TextAlign.center,
  //               ),
  //               const SizedBox(height: 8),
  //               Text(
  //                 'Create highlights, save personal reflections, and sync your notes across all devices.',
  //                 style: Theme.of(context).textTheme.bodyMedium?.copyWith(
  //                   color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
  //                 ),
  //                 textAlign: TextAlign.center,
  //               ),
  //               const SizedBox(height: 16),
  //               SizedBox(
  //                 width: double.infinity,
  //                 child: ElevatedButton(
  //                   onPressed: () {
  //                     Navigator.pushNamed(context, '/login');
  //                   },
  //                   style: ElevatedButton.styleFrom(
  //                     backgroundColor: Theme.of(context).colorScheme.primary,
  //                     foregroundColor: Theme.of(context).colorScheme.onPrimary,
  //                     padding: const EdgeInsets.symmetric(vertical: 12),
  //                     shape: RoundedRectangleBorder(
  //                       borderRadius: BorderRadius.circular(8),
  //                     ),
  //                   ),
  //                   child: const Text(
  //                     'Sign In',
  //                     style: TextStyle(fontWeight: FontWeight.w600),
  //                   ),
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  void _showNotesBottomSheet(
    BuildContext context, {
    String? selectedText,
    int? startPosition,
    int? endPosition,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => NotesBottomSheet(
        userId: widget.userId ?? '',
        readingId: _readingId,
        selectedText: selectedText,
        startPosition: startPosition,
        endPosition: endPosition,
      ),
    );
  }

  // void _showLoginRequiredDialog(BuildContext context) {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: const Row(
  //           children: [
  //             Icon(Icons.account_circle_outlined, size: 24),
  //             SizedBox(width: 8),
  //             Text('Sign In Required'),
  //           ],
  //         ),
  //         content: const Text(
  //           'To save notes and highlights, please sign in to your account. Your notes will be synced across all your devices.',
  //         ),
  //         actions: [
  //           TextButton(
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //             child: const Text('Cancel'),
  //           ),
  //           ElevatedButton(
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //               Navigator.pushNamed(context, '/login');
  //             },
  //             child: const Text('Sign In'),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }
}
