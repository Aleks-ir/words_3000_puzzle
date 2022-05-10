import 'dart:convert';

import 'package:word_study_puzzle/common/constants/word_status.dart';
import 'package:word_study_puzzle/data/dto/category_dto.dart';
import 'package:word_study_puzzle/data/dto/word_dto.dart';
import 'package:word_study_puzzle/domain/repositories/category_repository.dart';

import '../../domain/datasources/local/local.dart';


class CategoryRepositoryImpl implements CategoryRepository {
  CategoryRepositoryImpl(
      {required this.categoryDatabase, required this.dataAssets});

  final Database categoryDatabase;
  final DataAssets dataAssets;

  @override
  List<CategoryDto> getAllCategories() {
    try {
      final categoriesDto = categoryDatabase
          .getAll()
          .map((category) => category as CategoryDto)
          .toList();
      return categoriesDto;
    } catch (_) {
      rethrow;
    }
  }

  @override
  Future<CategoryDto> getCategory(String id) async {
    try {
      final categoryDto = await categoryDatabase.get(id) as CategoryDto;
      return categoryDto;
    } catch (_) {
      rethrow;
    }
  }

  @override
  Future addUpdateCategory(String id, CategoryDto categoryDto) async {
    try {
      await categoryDatabase.addUpdate(id, categoryDto);
    } catch (_) {
      rethrow;
    }
  }

  @override
  Future resetExploredCategory(String id, CategoryDto categoryDto) async {
    try {
      final List<WordDto> words = [];
      for(var word in categoryDto.wordList){
        words.add(word.copyWith(status: WordStatus.unexplored));
      }
      await categoryDatabase.addUpdate(id, categoryDto.copyWith(wordList: words));
    } catch (_) {
      rethrow;
    }
  }

  @override
  Future deleteCategory(String id) async {
    try {
      await categoryDatabase.delete(id);
    } catch (_) {
      rethrow;
    }
  }

  @override
  Future addCategoryWithDataFromAsset(
      String path, CategoryDto categoryDto) async {
    try {
      List<WordDto> wordList = [];
      final String wordsJson = await dataAssets.loadStringAsset(path);
      final titleList = json.decode(wordsJson);
      for(String title in titleList){
        wordList.add(WordDto(title: title));
      }
      await categoryDatabase.addUpdate(
          categoryDto.title, categoryDto.copyWith(wordList: wordList, ));
    } catch (_) {
      rethrow;
    }
  }
}
