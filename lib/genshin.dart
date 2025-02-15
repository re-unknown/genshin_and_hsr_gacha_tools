import 'package:flutter/material.dart';
import 'tools.dart';

// ignore: camel_case_types
class genshinWidget extends StatefulWidget {
  final Function(String) addDebugMessage; // デバッグメッセージを追加するためのコールバック

  const genshinWidget({super.key, required this.addDebugMessage});

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
    widget.addDebugMessage(result); // PowerShellの結果をデバッグメッセージに追加
    setState(() {
      _result = result ==
              'Cannot find the wish history url! Make sure to open the wish history first!'
          ? '祈願履歴が古い、もしくは開かれていません。\n履歴を開いて再度実行してください。'
          : 'リンクをクリップボードにコピーしました!\npaimon.moeに貼り付けてインポートしてください!';
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
                      width: 30,
                      height: 30,
                      child: CircularProgressIndicator(),
                    )
                  : const Text('1.リンクを取得する'),
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
              child: const Text('2.paimon.moeを開く'),
            ),
          ],
        ),
      ],
    );
  }
}
