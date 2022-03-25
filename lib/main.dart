import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:word_study_puzzle/presentation/pages/home_page.dart';

import 'app_local_data.dart';
import 'common/constants/app_colors.dart';
import 'common/constants/box_names.dart';
import 'data/dto/category_dto.dart';
import 'data/dto/history_dto.dart';
import 'data/dto/settings_dto.dart';
import 'data/dto/word_dto.dart';
import 'injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  initHive();
  runApp(const App());
}


void initHive() async {
  await Hive.initFlutter();
  Hive.registerAdapter(CategoryDtoAdapter());
  Hive.registerAdapter(WordDtoAdapter());
  Hive.registerAdapter(SettingsDtoAdapter());
  Hive.registerAdapter(HistoryDtoAdapter());
  await Hive.openBox(BoxNames.history);
  await Hive.openBox(BoxNames.categories);
  await Hive.openBox(BoxNames.settings).then((box) => di.sl<AppLocalData>().initLocalData(box));
}


class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    Hive.box(BoxNames.categories).compact();
    Hive.box(BoxNames.history).compact();
    Hive.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return
        //MaterialApp(home: Scaffold(body: Center(child: Text('fdfgdfg')),));
        MaterialApp(
            theme:
            //ThemeData.dark(),
            ThemeData(
                floatingActionButtonTheme: const FloatingActionButtonThemeData(
                  foregroundColor: Color(AppColors.color2),
                  backgroundColor: Color(AppColors.whiteDefault),
                ),
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(const Color(AppColors.color2)),
                ),
              ),
    ),
            home: const HomePage());
  }
}
