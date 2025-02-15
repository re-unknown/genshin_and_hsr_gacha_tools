import 'package:flutter/material.dart';
import 'tools.dart';

// ignore: camel_case_types
class hsrWidget extends StatefulWidget {
  final Function(String) addDebugMessage; // デバッグメッセージを追加するためのコールバック

  const hsrWidget({super.key, required this.addDebugMessage});

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
    widget.addDebugMessage(result); // PowerShellの結果をデバッグメッセージに追加
    setState(() {
      _result = result ==
              'Please make sure to open the Warp history before running the script.'
          ? 'ガチャ履歴が古い、もしくは開かれていません。\n履歴を開いて再度実行してください。'
          : 'リンクをクリップボードにコピーしました!\nSTARRAIL STATIONに貼り付けてインポートしてください!';
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
                launchURL(
                    Uri.parse('https://starrailstation.com/jp/warp#import'));
              },
              child: const Text('2.STARRAIL STATIONを開く'),
            ),
          ],
        ),
      ],
    );
  }
}
