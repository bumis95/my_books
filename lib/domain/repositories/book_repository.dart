import 'package:my_books/domain/entities/book.dart';

abstract class BookRepository {
  Future<Book?> getBookByID(String id);

  Stream<bool> checkBookLike({
    required String userID,
    required String bookID,
  });

  Stream<List<Book>> getFavouriteBooks({required String userID});

  Stream<List<Book>> getAllBooks();

  Future<List<Book>> getPopularBooks();

  Future<List<Book>> getNewBooks();

  Stream<List<Book>> getFilteredBooks(List<String> genres);

  Stream<List<Book>> getBooksByQuery(String query);

  Future<void> addBookToFavourite({
    required String userID,
    required String bookID,
  });

  Future<void> deleteBookFromFavourite({
    required String userID,
    required String bookID,
  });
}
