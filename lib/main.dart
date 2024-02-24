import 'package:flutter/material.dart';
import 'tools.dart';

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

// ignore: camel_case_types
class genshinWidget extends StatefulWidget {
  const genshinWidget({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _genshinwidgetState createState() => _genshinwidgetState();
}

// ignore: camel_case_types
class _genshinwidgetState extends State<genshinWidget> {
  final myClassInstance = RunScript();
  Color textColor = Colors.black;
  String _result = 'データはまだありません';
  bool isLoading = false;

  Future<void> _getgenshin(String url) async {
    String result = await myClassInstance.cmdFunction(url);
    setState(() {
      _result = result ==
              'Cannot find the wish history url! Make sure to open the wish history first!'
          ? '祈願履歴が古い、もしくは開かれていません。\n履歴を開いて再度実行してください。'
          : 'URLをクリップボードにコピーしました!\npaimon.moeに貼り付けてインポートしてください!';
      textColor = result ==
              'Cannot find the wish history url! Make sure to open the wish history first!'
          ? Colors.red
          : Colors.green;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.9,
          height: 100,
          child: Text(
            _result,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 127, 214, 255),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0), // 任意の角丸さを指定
                ),
              ),
              onPressed: () async {
                setState(() {
                  isLoading = true;
                });
                await _getgenshin(
                    "https://gist.githubusercontent.com/MadeBaruna/1d75c1d37d19eca71591ec8a31178235/raw/getlink.ps1");
                setState(() {
                  isLoading = false;
                });
              },
              child: isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(),
                    )
                  : const Text('URLを取得する'),
            ),
            const SizedBox(width: 25),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 127, 214, 255),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0), // 任意の角丸さを指定
                ),
              ),
              onPressed: () {
                launchURL(Uri.parse('https://paimon.moe/wish/import'));
              },
              child: const Text('paimon.moeを開く'),
            ),
          ],
        ),
      ],
    );
  }
}

// ignore: camel_case_types
class hsrWidget extends StatefulWidget {
  const hsrWidget({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _hsrwidgetState createState() => _hsrwidgetState();
}

// ignore: camel_case_types
class _hsrwidgetState extends State<hsrWidget> {
  final myClassInstance = RunScript();
  Color textColor = Colors.black;
  String _result = 'データはまだありません';
  bool isLoading = false;

  Future<void> _gethsr(String url) async {
    String result = await myClassInstance.cmdFunction(url);
    setState(() {
      _result = result ==
              'Please make sure to open the Warp history before running the script.'
          ? 'ガチャ履歴が古い、もしくは開かれていません。\n履歴を開いて再度実行してください。'
          : 'URLをクリップボードにコピーしました!\nSTARRAIL STATIONに貼り付けてインポートしてください!';
      textColor = result ==
              'Please make sure to open the Warp history before running the script.'
          ? Colors.red
          : Colors.green;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.9,
          height: 100,
          child: Text(
            _result,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 127, 214, 255),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0), // 任意の角丸さを指定
                ),
              ),
              onPressed: () async {
                setState(() {
                  isLoading = true;
                });
                await _gethsr(
                    "https://gist.githubusercontent.com/Star-Rail-Station/2512df54c4f35d399cc9abbde665e8f0/raw/get_warp_link_os.ps1");
                setState(() {
                  isLoading = false;
                });
              },
              child: isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(),
                    )
                  : const Text('URLを取得する'),
            ),
            const SizedBox(width: 25),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 127, 214, 255),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0), // 任意の角丸さを指定
                ),
              ),
              onPressed: () {
                launchURL(
                    Uri.parse('https://starrailstation.com/jp/warp#import'));
              },
              child: const Text('STARRAIL STATIONを開く'),
            ),
          ],
        ),
      ],
    );
  }
}
