import 'package:flutter/material.dart';
import 'tools.dart';
import 'genshin.dart';
import 'hsr.dart';
import 'zzz.dart'; // ZZZウィジェットをインポート

void main() {
  setupWindow();
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MainApp> {
  bool showGenshinWidget = true;
  bool showHsrWidget = false;
  bool showZzzWidget = false; // ZZZウィジェットの表示状態
  List<String> debugMessages = [];
  final ScrollController _scrollController = ScrollController();
  bool showDebugMessages = false;

  void toggleWidget() {
    setState(() {
      if (showGenshinWidget) {
        showGenshinWidget = false;
        showHsrWidget = true;
        showZzzWidget = false;
        updateWindowTitle('崩壊:スターレイル');
      } else if (showHsrWidget) {
        showGenshinWidget = false;
        showHsrWidget = false;
        showZzzWidget = true;
        updateWindowTitle('ZZZ');
      } else {
        showGenshinWidget = true;
        showHsrWidget = false;
        showZzzWidget = false;
        updateWindowTitle('原神');
      }
    });
  }

  void addDebugMessage(String message) {
    setState(() {
      debugMessages.add(message);
    });
    if (showDebugMessages) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
        }
      });
    }
  }

  void toggleDebugMessages() {
    setState(() {
      showDebugMessages = !showDebugMessages;
    });
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
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          sizeConstraints: BoxConstraints.tightFor(
            width: 180.0,
            height: 50.0,
          ),
        ),
      ),
      home: Scaffold(
        appBar: AppBar(
          toolbarHeight: 40,
          title: showGenshinWidget
              ? const Text('原神 ガチャ履歴インポートツール')
              : showHsrWidget
                  ? const Text('崩壊:スターレイル ガチャ履歴インポートツール')
                  : const Text('ZZZ ガチャ履歴インポートツール'),
          backgroundColor: showGenshinWidget
              ? const Color.fromARGB(255, 127, 214, 255)
              : showHsrWidget
                  ? const Color.fromARGB(255, 157, 142, 252)
                  : const Color.fromARGB(255, 255, 172, 63), // ZZZ用の色
          actions: [
            TextButton(
              onPressed: () {
                toggleDebugMessages(); // 表示状態を切り替え
                if (showDebugMessages) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (_scrollController.hasClients) {
                      _scrollController
                          .jumpTo(_scrollController.position.maxScrollExtent);
                    }
                  });
                }
              },
              child: const Text(
                'デバッグ',
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
            const SizedBox(width: 5),
            TextButton(
              onPressed: toggleWidget,
              child: Row(
                children: [
                  const Icon(Icons.swap_horiz, color: Colors.white, size: 24),
                  const SizedBox(width: 4),
                  Text(
                    showGenshinWidget
                        ? 'HSR'
                        : showHsrWidget
                            ? 'ZZZ'
                            : '原神',
                    style: const TextStyle(color: Colors.white, fontSize: 24),
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
              if (showGenshinWidget)
                GenshinWidget(addDebugMessage: addDebugMessage),
              if (showHsrWidget) HsrWidget(addDebugMessage: addDebugMessage),
              if (showZzzWidget)
                ZzzWidget(addDebugMessage: addDebugMessage), // ZZZウィジェットを表示
              const SizedBox(height: 10),
              if (showDebugMessages)
                Expanded(
                  child: Container(
                    color: Colors.grey[200], // 薄い灰色
                    child: ListView.builder(
                      controller: _scrollController,
                      itemCount: debugMessages.length,
                      itemBuilder: (context, index) {
                        return Text(debugMessages[index]);
                      },
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
