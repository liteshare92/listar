import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:listar/models/model.dart';
import 'package:listar/repository/repository.dart';

import 'bloc.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  CategoryBloc() : super(InitialCategoryState());

  final CategoryRepository categoryRepository = CategoryRepository();

  @override
  Stream<CategoryState> mapEventToState(event) async* {
    if (event is OnLoadCategory) {
      yield CategoryLoading();

      ///Fetch API
      final ResultApiModel result = await categoryRepository.loadCategory();
      if (result.success) {
        final Iterable refactorCategory = result?.data ?? [];
        final listCategory = refactorCategory.map((item) {
          return CategoryModel.fromJson(item);
        }).toList();

        ///Sync UI
        yield CategoryLoadSuccess(category: listCategory);
      } else {
        yield CategoryLoadFail();
      }
    }
  }
}
