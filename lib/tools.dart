import 'package:flutter/material.dart';
import 'package:window_size/window_size.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/foundation.dart';
import 'package:process_run/shell.dart';
import 'dart:io';

const String ver = 'v2.0.0';

void launchURL(url) async {
  if (!await launchUrl(url)) {
    throw Exception('Could not launch $url');
  }
}

//ウィンドウサイズを変更
const double windowWidth = 750;
const double windowHeight = 400;

void setupWindow() {
  // webとプラットフォームをチェック
  if (!kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
    WidgetsFlutterBinding.ensureInitialized();
    setWindowTitle('原神 ガチャ履歴インポートツール');
    setWindowMinSize(const Size(windowWidth, windowHeight));
    setWindowMaxSize(const Size(windowWidth, windowHeight));
    getCurrentScreen().then((screen) {
      setWindowFrame(Rect.fromCenter(
        center: screen!.frame.center,
        width: windowWidth,
        height: windowHeight,
      ));
    });
  }
}

void updateWindowTitle(String game) {
  setWindowTitle('$game ガチャ履歴インポートツール $ver');
}

class RunScript {
  bool isCancelled = false; // キャンセルフラグ
  Shell? shell; // Shellインスタンスを保持

  void cancel() {
    isCancelled = true; // キャンセルフラグを立てる
    shell?.kill(); // Shellの処理をキャンセル
  }

  Future<String> cmdFunction(var wishurl) async {
    isCancelled = false; // 初期化
    var wishUrl = wishurl;
    var tempDir = await Directory.systemTemp.createTemp('process_run_example');
    var scriptFile = File('${tempDir.path}/getlink.ps1');
    var request = await HttpClient().getUrl(Uri.parse(wishUrl));
    var response = await request.close();
    await scriptFile
        .writeAsBytes(await response.expand((chunk) => chunk).toList());

    shell = Shell(
      workingDirectory: tempDir.path,
      environment: {'PSExecutionPolicyPreference': 'Bypass'},
    );

    // スクリプトの実行前にキャンセルされたか確認
    if (isCancelled) return '処理がキャンセルされました';

    try {
      var textfull = await shell!.run('powershell .\\getlink.ps1');

      // キャンセルされた場合は処理を中断
      if (isCancelled) return '処理がキャンセルされました';

      // 全ての出力を返す
      return textfull.outText.trim();
    } catch (e) {
      // ShellExceptionをキャッチして適切なメッセージを返す
      if (e is ShellException) {
        return '処理がキャンセルされました: ${e.message}';
      }
      // その他の例外を再スロー
      rethrow;
    }
  }
}
