import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:listar/configs/config.dart';
import 'package:listar/models/model.dart';
import 'package:listar/repository/list_repository.dart';
import 'package:listar/utils/utils.dart';
import 'package:rxdart/rxdart.dart';

import 'bloc.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc() : super(InitialSearchState());
  final ListRepository listRepository = ListRepository();

  @override
  Stream<Transition<SearchEvent, SearchState>> transformEvents(
      Stream<SearchEvent> events,
      TransitionFunction<SearchEvent, SearchState> transition) {
    final nonDebounceStream = events.where((event) => event is! OnSearch);
    final debounceStream = events
        .where((event) => event is OnSearch)
        .debounceTime(Duration(milliseconds: 1500));
    return super.transformEvents(
      MergeStream([nonDebounceStream, debounceStream]),
      transition,
    );
  }

  @override
  Stream<SearchState> mapEventToState(SearchEvent event) async* {
    if (event is OnSearch) {
      if (event.keyword.isNotEmpty) {
        yield SearchLoading();

        ///Fetch API
        final ResultApiModel response = await listRepository.loadList(
          {"s": event.keyword},
        );
        if (response.success) {
          final Iterable convertList = response.data ?? [];
          final list = convertList.map((item) {
            return ProductModel.fromJson(item);
          }).toList();

          yield SearchSuccess(list: list);
        } else {
          yield SearchFail();
        }
      }
    }

    if (event is OnLoadHistory) {
      List<String> historyString = UtilPreferences.getStringList(
        Preferences.search,
      );
      if (historyString != null) {
        List<ProductModel> history;
        try {
          history = historyString.map((e) {
            return ProductModel.fromJson(jsonDecode(e));
          }).toList();
        } catch (e) {
          await UtilPreferences.remove(
            Preferences.search,
          );
          history = [];
        }
        yield LoadingHistorySuccess(list: history);
      } else {
        yield LoadingHistorySuccess(list: []);
      }
    }

    if (event is OnSaveHistory) {
      List<String> historyString = UtilPreferences.getStringList(
        Preferences.search,
      );
      if (historyString != null) {
        if (!historyString.contains(jsonEncode(event.item.toJson()))) {
          historyString.add(jsonEncode(event.item.toJson()));
          await UtilPreferences.setStringList(
            Preferences.search,
            historyString,
          );
        }
      } else {
        await UtilPreferences.setStringList(
          Preferences.search,
          [jsonEncode(event.item.toJson())],
        );
      }

      yield SaveHistorySuccess();
    }

    if (event is OnClearHistory) {
      if (event.item == null) {
        await UtilPreferences.remove(
          Preferences.search,
        );
      } else {
        List<String> historyString = UtilPreferences.getStringList(
          Preferences.search,
        );
        historyString.remove(jsonEncode(event.item.toJson()));
        await UtilPreferences.setStringList(
          Preferences.search,
          historyString,
        );
      }
      yield RemoveHistorySuccess();
    }
  }
}
