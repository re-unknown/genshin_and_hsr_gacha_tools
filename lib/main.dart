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
  List<String> debugMessages = []; // デバッグメッセージを保持するリスト
  final ScrollController _scrollController = ScrollController(); // スクロールコントローラー
  bool showDebugMessages = false; // デバッグメッセージの表示フラグ

  void toggleWidget() {
    setState(() {
      showgenshinWidget = !showgenshinWidget; // Widgetを切り替え
      // ウィンドウタイトルを現在のゲームウィジェットに合わせて変更
      updateWindowTitle(showgenshinWidget ? '原神' : '崩壊:スターレイル');
    });
  }

  void addDebugMessage(String message) {
    setState(() {
      debugMessages.add(message);
    });
    // スクロールを最下部に移動
    if (showDebugMessages) {
      // デバッグメッセージが表示されている場合のみスクロール
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
        }
      });
    }
  }

  void toggleDebugMessages() {
    setState(() {
      showDebugMessages = !showDebugMessages; // デバッグメッセージの表示フラグを切り替え
    });
    // デバッグメッセージが表示される場合、スクロールを最下部に移動
    if (showDebugMessages) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
        }
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose(); // スクロールコントローラーを解放
    super.dispose();
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
          toolbarHeight: 40, // 高さを少し拡張
          title: showgenshinWidget
              ? const Text(
                  '原神 ガチャ履歴インポートツール',
                )
              : const Text(
                  '崩壊:スターレイル ガチャ履歴インポートツール',
                ),
          backgroundColor: showgenshinWidget
              ? const Color.fromARGB(255, 127, 214, 255)
              : const Color.fromARGB(255, 157, 142, 252),
          actions: [
            TextButton(
              onPressed: toggleWidget, // Widgetを切り替える
              child: Row(
                children: [
                  const Icon(Icons.swap_horiz,
                      color: Colors.white, size: 24), // アイコン
                  const SizedBox(width: 8), // アイコンとテキストの間にスペースを追加
                  Text(
                    showgenshinWidget ? 'HSR' : '原神',
                    style: const TextStyle(
                        color: Colors.white, fontSize: 24), // テキストの色を白に設定
                  ),
                ],
              ),
            ),
          ],
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              showgenshinWidget
                  ? genshinWidget(addDebugMessage: addDebugMessage)
                  : hsrWidget(addDebugMessage: addDebugMessage),
              const SizedBox(height: 20),
              // デバッグメッセージを表示するボタン
              ElevatedButton(
                onPressed: toggleDebugMessages,
                child:
                    Text(showDebugMessages ? 'デバッグメッセージを隠す' : 'デバッグメッセージを表示'),
              ),
              const SizedBox(height: 20),
              // デバッグメッセージを表示
              if (showDebugMessages) // フラグに基づいて表示
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController, // スクロールコントローラーを設定
                    itemCount: debugMessages.length,
                    itemBuilder: (context, index) {
                      return Text(debugMessages[index]);
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
