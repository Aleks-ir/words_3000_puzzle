import 'package:hive/hive.dart';
import 'package:word_study_puzzle/domain/models/settings.dart';

part 'settings_dto.g.dart';

@HiveType(typeId: 1)
class SettingsDto {
  @HiveField(0)
  final bool hasLocalData;
  @HiveField(1)
  final String theme;
  @HiveField(2)
  final bool isVibration;
  @HiveField(3)
  final bool isNotification;
  @HiveField(4)
  final String timeNotification;
  @HiveField(5)
  final int wordToExploreCount;
  @HiveField(6)
  final int puzzleCount;
  @HiveField(7)
  final String selectedCategory;

  SettingsDto(
      {required this.hasLocalData,
      required this.theme,
      required this.isVibration,
      required this.isNotification,
      required this.timeNotification,
      required this.wordToExploreCount,
      required this.puzzleCount,
      required this.selectedCategory});

  factory SettingsDto.fromDomain(Settings settings) {
    return SettingsDto(
        hasLocalData: settings.hasLocalData,
        theme: settings.theme,
        isVibration: settings.isVibration,
        isNotification: settings.isNotification,
        timeNotification: settings.timeNotification,
        wordToExploreCount: settings.wordToExploreCount,
        puzzleCount: settings.puzzleCount,
        selectedCategory: settings.selectedCategory);
  }

  Settings toDomain() {
    return Settings(
        hasLocalData: hasLocalData,
        theme: theme,
        isVibration: isVibration,
        isNotification: isNotification,
        timeNotification: timeNotification,
        wordToExploreCount: wordToExploreCount,
        puzzleCount: puzzleCount,
        selectedCategory: selectedCategory);
  }

  SettingsDto copyWith(
      {bool? hasLocalData,
      String? theme,
      bool? isVibration,
      bool? isNotification,
      String? timeNotification,
      int? wordCount,
      int? starCount,
      String? selectedCategory}) {
    return SettingsDto(
        hasLocalData: hasLocalData ?? this.hasLocalData,
        theme: theme ?? this.theme,
        isVibration: isVibration ?? this.isVibration,
        isNotification: isNotification ?? this.isNotification,
        timeNotification: timeNotification ?? this.timeNotification,
        wordToExploreCount: wordCount ?? this.wordToExploreCount,
        puzzleCount: starCount ?? this.puzzleCount,
        selectedCategory: selectedCategory ?? this.selectedCategory);
  }

  @override
  String toString() {
    return 'SettingsDto{hasLocalData: $hasLocalData, theme: $theme, isVibration: $isVibration, isNotification: $isNotification, timeNotification: $timeNotification, wordCount: $wordToExploreCount, starCount: $puzzleCount, selectedCategory: $selectedCategory}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SettingsDto &&
          runtimeType == other.runtimeType &&
          hasLocalData == other.hasLocalData &&
          theme == other.theme &&
          isVibration == other.isVibration &&
          isNotification == other.isNotification &&
          timeNotification == other.timeNotification &&
          wordToExploreCount == other.wordToExploreCount &&
          puzzleCount == other.puzzleCount &&
          selectedCategory == other.selectedCategory;

  @override
  int get hashCode =>
      hasLocalData.hashCode ^
      theme.hashCode ^
      isVibration.hashCode ^
      isNotification.hashCode ^
      timeNotification.hashCode ^
      wordToExploreCount.hashCode ^
      puzzleCount.hashCode ^
      selectedCategory.hashCode;
}
