import 'package:flutter/material.dart';
import 'tools.dart';
import 'genshin.dart';
import 'hsr.dart';

void main() {
  setupWindow();
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MainApp> {
  bool showgenshinWidget = true;

  void toggleWidget() {
    setState(() {
      showgenshinWidget = !showgenshinWidget; // Widgetを切り替え
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          sizeConstraints: BoxConstraints.tightFor(
            width: 180.0, // 幅を指定
            height: 50.0, // 高さを指定
          ),
        ),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: showgenshinWidget
              ? const Text(
                  'genshin wish importer\n(原神 祈願履歴インポーター)',
                )
              : const Text(
                  'HSR gacha importer\n(崩壊:スターレイル ガチャ履歴インポーター)',
                ),
          backgroundColor: showgenshinWidget
              ? const Color.fromARGB(255, 127, 214, 255)
              : const Color.fromARGB(255, 120, 99, 253),
        ),
        body: Center(
          child: showgenshinWidget ? const genshinWidget() : const hsrWidget(),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: toggleWidget,
          tooltip: 'Toggle Widget',
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(Icons.swap_horiz), // アイコン
              Text('ゲームを切り替える'), // テキストのサイズを小さくする
            ],
          ),
        ),
      ),
    );
  }
}
