import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leeds_library/domain/repositories/books_repository.dart';

import 'categories_event.dart';
import 'categories_state.dart';

class CategoriesBloc extends Bloc<CategoriesEvent, CategoriesState> {
  final BooksRepository booksRepository;


  CategoriesBloc({required this.booksRepository}) : super(CategoriesInitialState()) {
    on<LoadCategoriesEvent>(_onLoadBooks);

  }

  Future<void> _onLoadBooks(LoadCategoriesEvent event, Emitter<CategoriesState> emit) async {
    try {
      if (state is CategoriesInitialState) return;

      final categories = booksRepository.catetories;

    //  emit(BooksStreamState(categories, filteredBooksStream));

      booksRepository.booksStream.listen((books) {
       // _allBooks = books;
       // _applyFilter();
      });
    } catch (e) {
      emit(CategoriesErrorState("Не вдалося завантажити книги"));
    }
  }



  @override
  Future<void> close() {

    return super.close();
  }


}
