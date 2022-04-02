import 'package:word_study_puzzle/common/exception.dart';
import 'package:word_study_puzzle/data/dto/history_dto.dart';
import 'package:word_study_puzzle/domain/datasources/local/database.dart';
import 'package:word_study_puzzle/domain/repositories/history_repository.dart';

class HistoryRepositoryImpl implements HistoryRepository {
  HistoryRepositoryImpl({required this.historyDatabase});

  final Database historyDatabase;


  @override
  List<HistoryDto> getAllHistories() {
    try {
      final historiesDto =
      historyDatabase.getAll().map((history) => history as HistoryDto).toList();
      return historiesDto;
    }
    catch (e) {
      if (e is NoRecordsException) {
        return [];
      }
      rethrow;
    }
  }


  @override
  Future<HistoryDto> getHistory(String id) async {
    try {
      final historyDto = await historyDatabase.get(id) as HistoryDto;
      return historyDto;
    } catch (_) {
      rethrow;
    }
  }


  @override
  Future addUpdateHistory(String id, HistoryDto history) async {
    try {
      await historyDatabase.addUpdate(id, history);
    } catch (_) {
      rethrow;
    }
  }

}
