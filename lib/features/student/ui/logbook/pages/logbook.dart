import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sitama/core/shared/widgets/common/error_content.dart';
import 'package:sitama/features/student/domain/entities/log_book_entity.dart';
import 'package:sitama/features/student/ui/logbook/widgets/student_log_book_card.dart';
import 'package:sitama/core/shared/widgets/common/search_field.dart';
import 'package:sitama/features/student/ui/logbook/bloc/log_book_student_cubit.dart';
import 'package:sitama/features/student/ui/logbook/bloc/log_book_student_state.dart';
import 'package:sitama/features/student/ui/logbook/widgets/add_log_book.dart';
import 'package:sitama/features/student/ui/logbook/widgets/filter_dilog.dart';

class LogBookPage extends StatefulWidget {
  const LogBookPage({super.key});

  @override
  State<LogBookPage> createState() => _LogBookPageState();
}

class _LogBookPageState extends State<LogBookPage> with AutomaticKeepAliveClientMixin {
  String _search = '';
  SortMode _sortMode = SortMode.newest;

  @override
  bool get wantKeepAlive => true;  
  bool _wasError = false;

  List<LogBookEntity> _getSortedAndFilteredLogBooks(List<LogBookEntity> logBooks) {
    var filteredBooks = logBooks.where((logBook) {
      return logBook.title.toLowerCase().contains(_search.toLowerCase());
    }).toList();

    filteredBooks.sort((a, b) {
      if (_sortMode == SortMode.newest) {
        return b.date.compareTo(a.date);
      } else {
        return a.date.compareTo(b.date);
      }
    });

    return filteredBooks;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final theme = Theme.of(context);

    return Scaffold(
      body: BlocProvider(
        create: (context) => LogBookStudentCubit()..displayLogBook(),
        child: BlocBuilder<LogBookStudentCubit, LogBookStudentState>(
          builder: (context, state) {
            // Update error state
            if (state is LoadLogBookFailure) {
              _wasError = true;
            } else if (state is LogBookLoaded) {
              _wasError = false;
            }

            if (state is LogBookLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is LoadLogBookFailure) {
              return ErrorContent(
                errorMessage: state.errorMessage,
                onRetry: () => context.read<LogBookStudentCubit>().displayLogBook(),
                wasError: _wasError,
              );
            }
            if (state is LogBookLoaded) {
              final sortedAndFilteredLogBooks = 
                _getSortedAndFilteredLogBooks(state.logBookEntity.log_books);

              return CustomScrollView(
                slivers: [
                  SliverAppBar(
                    floating: false,
                    snap: false,
                    pinned: true,
                    elevation: 0,
                    backgroundColor: theme.colorScheme.surface,
                    title: Text(
                      'LogBook',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface, 
                      ),
                    ),
                    centerTitle: true,
                    actions: [
                      IconButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => const AddLogBook(),
                          );
                        },
                        icon: Icon(
                          Icons.add,
                          color: theme.colorScheme.onSurface, 
                        ),
                      )
                    ],
                    bottom: PreferredSize(
                      preferredSize: const Size.fromHeight(80),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Row(
                          children: [
                            Expanded(
                              child: SearchField(
                                onChanged: (value) {
                                  setState(() {
                                    _search = value;
                                  });
                                },
                                onFilterPressed: () {},
                              ),
                            ),
                            const SizedBox(width: 10),
                            SortFilterButton(
                              onSortModeChanged: (SortMode newMode) {
                                setState(() {
                                  _sortMode = newMode;
                                });
                              },
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => LogBookCard(
                        item: LogBookItem(
                          id: sortedAndFilteredLogBooks[index].id,
                          title: sortedAndFilteredLogBooks[index].title,
                          date: sortedAndFilteredLogBooks[index].date,
                          lecturerNote: sortedAndFilteredLogBooks[index].lecturer_note,
                          description: sortedAndFilteredLogBooks[index].activity,
                          curentPage: 2,
                        ),
                      ),
                      childCount: sortedAndFilteredLogBooks.length,
                    ),
                  ),
                ],
              );
            }
            if (state is LoadLogBookFailure) {
              return Center(child: Text(state.errorMessage));
            }
            return Container();
          },
        ),
      ),
    );
  }
}