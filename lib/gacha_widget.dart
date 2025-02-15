import 'package:flutter/material.dart';
import 'tools.dart';

class GachaWidget extends StatefulWidget {
  final String siteName;
  final String scriptUrl;
  final String successMessage;
  final String failureMessage;
  final String importUrl;
  final Function(String) addDebugMessage;

  const GachaWidget({
    Key? key,
    required this.siteName,
    required this.scriptUrl,
    required this.successMessage,
    required this.failureMessage,
    required this.importUrl,
    required this.addDebugMessage,
  }) : super(key: key);

  @override
  GachaWidgetState createState() => GachaWidgetState();
}

class GachaWidgetState extends State<GachaWidget> {
  final myClassInstance = RunScript();
  Color textColor = Colors.black;
  String _result = '「1.リンクを取得する」を押して\nリンクを取得してください!';
  bool isLoading = false;
  bool isCancelled = false;

  Future<void> _getGachaLink(String url) async {
    isCancelled = false;
    String result = await myClassInstance.cmdFunction(url);

    // キャンセルされた場合はメッセージを優先して表示
    if (myClassInstance.isCancelled) {
      setState(() {
        _result = '処理がキャンセルされました'; // キャンセルメッセージを設定
        textColor = Colors.black; // テキストカラーをリセット
      });
      return;
    }

    widget.addDebugMessage(result);
    setState(() {
      _result =
          result.contains('Cannot find') || result.contains('Please make sure')
              ? widget.failureMessage
              : widget.successMessage;
      textColor =
          result.contains('Cannot find') || result.contains('Please make sure')
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
          height: 60,
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
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 127, 214, 255),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                minimumSize: Size(150, 50), // ボタンの最小サイズを設定
              ),
              onPressed: () async {
                if (isLoading) {
                  myClassInstance.cancel();
                  setState(() {
                    isLoading = false;
                    _result = '処理がキャンセルされました'; // キャンセルメッセージを設定
                    textColor = Colors.black;
                  });
                  return;
                }
                setState(() {
                  isLoading = true;
                });
                await _getGachaLink(widget.scriptUrl);
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
                  : const Text('1.リンクを取得する'),
            ),
            const SizedBox(width: 25),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 127, 214, 255),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                minimumSize: Size(150, 50), // ボタンの最小サイズを設定
              ),
              onPressed: () {
                launchURL(Uri.parse(widget.importUrl));
              },
              child: Text('2.${widget.siteName}を開く'),
            ),
          ],
        ),
      ],
    );
  }
}
