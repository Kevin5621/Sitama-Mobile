import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sistem_magang/common/widgets/search_field.dart';
import 'package:sistem_magang/common/widgets/student_log_book_card.dart';
import 'package:sistem_magang/domain/entities/log_book_entity.dart';
import 'package:sistem_magang/presenstation/student/logbook/bloc/log_book_student_cubit.dart';
import 'package:sistem_magang/presenstation/student/logbook/bloc/log_book_student_state.dart';
import 'package:sistem_magang/presenstation/student/logbook/widgets/add_log_book.dart';
import 'package:sistem_magang/presenstation/student/logbook/widgets/filter_dilog.dart';

class LogBookPage extends StatefulWidget {
  const LogBookPage({super.key});

  @override
  State<LogBookPage> createState() => _LogBookPageState();
}

class _LogBookPageState extends State<LogBookPage> {
  String _search = '';
  SortMode _sortMode = SortMode.newest;

  // Function to sort logbooks
  List<LogBookEntity> _getSortedAndFilteredLogBooks(List<LogBookEntity> logBooks) {
    // Filter berdasarkan pencarian
    var filteredBooks = logBooks.where((logBook) {
      return logBook.title.toLowerCase().contains(_search.toLowerCase());
    }).toList();

    // Urutkan berdasarkan tanggal
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
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: _appBar(theme),
      body: BlocProvider(
        create: (context) => LogBookStudentCubit()..displayLogBook(),
        child: BlocBuilder<LogBookStudentCubit, LogBookStudentState>(
          builder: (context, state) {
            if (state is LogBookLoading) {
              return Center(child: CircularProgressIndicator());
            }
            if (state is LogBookLoaded) {
              final sortedAndFilteredLogBooks = 
                _getSortedAndFilteredLogBooks(state.logBookEntity.log_books);
              
              return CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(child: SizedBox(height: 12)),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
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
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(child: SizedBox(height: 20)),
                  _listLogBook(sortedAndFilteredLogBooks),
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

  AppBar _appBar(ThemeData theme) {
    return AppBar(
      toolbarHeight: 80.0,
      title: Text(
        'LogBook',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: theme.colorScheme.onBackground, // Mengatur warna teks sesuai theme
        ),
      ),
      centerTitle: true,
      automaticallyImplyLeading: false,
      actions: [
        IconButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                return AddLogBook();
              },
            );
          },
          icon: Icon(
            Icons.add,
            color: theme.colorScheme.onBackground, 
          ),
        )
      ],
      backgroundColor: Colors.transparent,
      iconTheme: IconThemeData(
        color: theme.colorScheme.onBackground, 
      ),
    );
  }

  SliverList _listLogBook(List<LogBookEntity> logBooks) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) => LogBookCard(
          item: LogBookItem(
            id: logBooks[index].id,
            title: logBooks[index].title,
            date: logBooks[index].date,
            description: logBooks[index].activity,
            curentPage: 2,
          ),
        ),
        childCount: logBooks.length,
      ),
    );
  }
}