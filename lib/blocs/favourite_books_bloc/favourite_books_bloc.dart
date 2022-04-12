import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:my_books/domain/usecases/firestore/check_book_like_usecase.dart';
import 'package:my_books/domain/usecases/firestore/get_favourite_books_usecase.dart';

import '../../domain/entities/book.dart';

part 'favourite_books_event.dart';
part 'favourite_books_state.dart';

class FavouriteBooksBloc
    extends Bloc<FavouriteBooksEvent, FavouriteBooksState> {
  final CheckBookLikeUseCase checkBookLikeUseCase;
  final GetFavouriteBooksUseCase getFavouriteBooksUseCase;

  FavouriteBooksBloc({
    required this.checkBookLikeUseCase,
    required this.getFavouriteBooksUseCase,
  }) : super(InitialState()) {
    on<InitialEvent>((event, emit) async {
      var stream = getFavouriteBooksUseCase.getFavouriteBooks();
      emit(ShowingBooksState(bookStream: stream));
    });
  }
}
