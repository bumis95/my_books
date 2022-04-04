import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_books/blocs/books_bloc/books_bloc.dart';
import 'package:my_books/blocs/home_bloc/home_bloc.dart';
import 'package:my_books/di/locator.dart';
import 'package:my_books/presentation/ui_components/book_list_item.dart';

import '../../domain/entities/book.dart';
import '../../domain/usecases/firestore/get_books_by_id_usecase.dart';
import '../../domain/usecases/firestore/get_favourite_book_stream_usecase.dart';
import '../../domain/usecases/firestore/get_favourite_books_stream_usecase.dart';

class FavouriteBooksScreen extends StatelessWidget {
  const FavouriteBooksScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BooksBloc(
        getFavouriteBookStreamUseCase: getIt<GetFavouriteBookStreamUseCase>(),
      ),
      child: const BooksView(),
    );
  }
}

class BooksView extends StatelessWidget {
  const BooksView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade100,
      body: BlocConsumer<BooksBloc, BooksState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state is ShowingBooksState) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: StreamBuilder<QuerySnapshot>(
                  stream: getIt<GetFavouriteBooksStreamUseCase>()
                      .getFavouriteBooks(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return const Text("Something went wrong");
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    var idList =
                        snapshot.requireData.docs.map((e) => e.id).toList();

                    return FutureBuilder<List<Book>>(
                        future:
                            getIt<GetBooksByIDUseCase>().getBooksByID(idList),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            var books = snapshot.requireData;

                            return ListView.separated(
                              itemCount: books.length,
                              separatorBuilder: (context, index) =>
                                  const SizedBox(height: 10),
                              itemBuilder: (context, index) => BookListItem(
                                book: books[index],
                                onTap: () {
                                  BlocProvider.of<HomeBloc>(context).add(
                                    BookClickedEvent(bookID: books[index].id),
                                  );
                                },
                              ),
                            );
                          } else if (snapshot.hasError) {
                            return const Text("Something went wrong");
                          } else {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                        });
                  },
                ),
              ),
            );
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}