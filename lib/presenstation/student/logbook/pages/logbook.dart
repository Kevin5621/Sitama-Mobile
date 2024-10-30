import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sistem_magang/common/widgets/search_field.dart';
import 'package:sistem_magang/common/widgets/student_log_book_card.dart';
import 'package:sistem_magang/domain/entities/log_book_entity.dart';
import 'package:sistem_magang/presenstation/student/logbook/bloc/log_book_student_cubit.dart';
import 'package:sistem_magang/presenstation/student/logbook/bloc/log_book_student_state.dart';
import 'package:sistem_magang/presenstation/student/logbook/widgets/add_log_book.dart';

class LogBookPage extends StatefulWidget {
  const LogBookPage({super.key});

  @override
  State<LogBookPage> createState() => _LogBookPageState();
}

class _LogBookPageState extends State<LogBookPage> {
  String _search = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(context),
      body: BlocProvider(
        create: (context) => LogBookStudentCubit()..displayLogBook(),
        child: BlocBuilder<LogBookStudentCubit, LogBookStudentState>(
          builder: (context, state) {
            if (state is LogBookLoading) {
              return Center(child: CircularProgressIndicator());
            }
            if (state is LogBookLoaded) {
              List<LogBookEntity> logBooks =
                  state.logBookEntity.log_books.where((logBook) {
                var search =
                    logBook.title.toLowerCase().contains(_search.toLowerCase());
                return search;
              }).toList();
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
                          SizedBox(width: 10),
                          Icon(Icons.filter_list_outlined),
                        ],
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(child: SizedBox(height: 20)),
                  _listLogBook(logBooks),
                ],
              );
            }
            if (state is LoadLogBookFailure) {
              return Text(state.errorMessage);
            }
            return Container();
          },
        ),
      ),
    );
  }

  AppBar _appBar(BuildContext context) {
    return AppBar(
      toolbarHeight: 80.0,
      title: Text(
        'Log Book',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
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
          icon: Icon(Icons.add),
        )
      ],
      backgroundColor: Colors.transparent,
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