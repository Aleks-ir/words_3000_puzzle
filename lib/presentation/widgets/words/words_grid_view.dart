import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:word_study_puzzle/common/constants/app_colors.dart';
import 'package:word_study_puzzle/domain/models/word.dart';
import 'package:word_study_puzzle/presentation/widgets/words/words_grid_view_item.dart';

class WordsGridView extends StatelessWidget {
  final List<Word> words;
  final ScrollController? controller;
  final Map<Word, int?> selectedItems;
  final int countSelectedItems;
  final bool isListView;
  final Function(Word, int?) pressCallback;
  final Function(Word, int?) doublePressCallback;
  final Color? backgroundColor;
  final Color selectedBackgroundColor;
  final Color selectedIconColor;
  final Color splashColor;

  final random = Random();

  WordsGridView(
      {required this.words,
      this.controller,
      required this.selectedItems,
      required this.countSelectedItems,
      required this.isListView,
      required this.pressCallback,
      required this.doublePressCallback,
      this.backgroundColor,
      this.selectedBackgroundColor = const Color(AppColors.color3),
      this.selectedIconColor = const Color(AppColors.whiteDefault),
      this.splashColor = const Color(AppColors.color5),
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    return MasonryGridView.count(
        itemCount: words.length,
        controller: controller,
        padding:
            const EdgeInsets.only(top: 110, bottom: 100, left: 10, right: 10),
        crossAxisCount: isListView ? 1 : isPortrait ? 2 : 3,
        mainAxisSpacing: 5,
        crossAxisSpacing: 2,
        itemBuilder: (context, index) {
          final word = words[index];
          final imagesUrl = words[index].imageUrlList;
          final indexUrl = _getIndexUrl(imagesUrl,
              selectedItems.containsKey(word) ? selectedItems[word] : null);
          return WordsGridViewItem(
            title: words[index].title,
            imageUrl:
                indexUrl != null ? words[index].imageUrlList[indexUrl] : '',
            pressCallback: () {
              pressCallback(words[index], indexUrl);
            },
            doublePressCallback: () {
              doublePressCallback(words[index], indexUrl);
            },
            isSelected: selectedItems.containsKey(words[index]),
          );
        });
  }

  int? _getIndexUrl(List<String> imageUrlList, int? selectedIndexUrl) {
    if (imageUrlList.isEmpty) {
      return null;
    }
    if (selectedIndexUrl != null) {
      return selectedIndexUrl;
    } else if (imageUrlList.length == 1) {
      return 0;
    }
    return random.nextInt(imageUrlList.length - 1);
  }
}
