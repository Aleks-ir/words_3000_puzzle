import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:intl/intl.dart';
import 'package:word_study_puzzle/common/constants/word_status.dart';
import 'package:word_study_puzzle/domain/models/history.dart';
import 'package:word_study_puzzle/domain/models/word.dart';
import 'package:word_study_puzzle/domain/usecases/history/fetch_all_histories_usecase.dart';
import 'package:word_study_puzzle/domain/usecases/history/fetch_history_usecase.dart';
import 'package:word_study_puzzle/domain/usecases/words/fetch_all_words_usecase.dart';

part 'stats_bloc.freezed.dart';

part 'stats_event.dart';

part 'stats_state.dart';

class StatsBloc extends Bloc<StatsEvent, StatsState> {
  DateTime currentDate = DateTime.now();
  double dayExploredRate = 0;
  double categoryExploredRate = 0;

  final FetchAllHistoriesUsecase fetchAllHistoriesUsecase;
  final FetchHistoryUsecase fetchHistoryUsecase;
  final FetchAllWordsUsecase fetchAllWordsUsecase;

  StatsBloc({
    required this.fetchAllHistoriesUsecase,
    required this.fetchHistoryUsecase,
    required this.fetchAllWordsUsecase,
  }) : super(StatsState.initState());

  @override
  Stream<StatsState> mapEventToState(StatsEvent event) async* {
    yield* event.map(
      initExploredRate: _initExploredRate,
      fetchHistoriesByMonths: _fetchHistoriesByMonths,
    );
  }

  Stream<StatsState> _initExploredRate(InitExploredRate event) async* {
    final errorOrWords = await fetchAllWordsUsecase();
    if(errorOrWords.isRight()){
      final words = errorOrWords.getOrElse(() => []);
      dayExploredRate = _countCategoryExploredRate(words);
    }
    final date = DateFormat('yyyy-MM-dd').format(currentDate);
    final errorOrHistory = await fetchHistoryUsecase(date);
    if(errorOrHistory.isRight()){
      final history = errorOrHistory.getOrElse(() => History(date: ''));
      dayExploredRate = _countDayExploredRate(history);
    }
  }

  double _countDayExploredRate(History history) {
    if (history.wordExploringCount == 0) {
      return 0;
    } else {
      return history.wordExploringCount / history.wordToExploreCount;
    }
  }

  double _countCategoryExploredRate(List<Word> words) {
    final exploredWordCount = words.where((word) => word.status == WordStatus.explored).length;
    if (exploredWordCount == 0 || words.isEmpty) {
      return 0;
    } else {
      return exploredWordCount / words.length;
    }
  }

  Stream<StatsState> _fetchHistoriesByMonths(
      FetchHistoriesByMonths event) async* {
    final errorOrSuccess = await fetchAllHistoriesUsecase();
    yield errorOrSuccess.fold((error) => StatsState.error(error.message),
        (allHistories) {
      if (allHistories.isEmpty) {
        return StatsState.empty();
      } else {
        final historiesByMonths = _selectHistoriesByMonth(allHistories);
        return StatsState.loaded(historiesByMonths);
      }
    });
  }

  Map<int, List<History>> _selectHistoriesByMonth(List<History> allHistories) {
    final Map<int, List<History>> historiesByMonths = {};
    for (var history in allHistories) {
      final date = DateTime.parse(history.date);
      if (currentDate.year == date.year) {
        if (historiesByMonths[date.month] != null) {
          historiesByMonths[date.month]?.add(history);
        } else {
          historiesByMonths[date.month] = [history];
        }
      }
    }
    return historiesByMonths;
  }
}
