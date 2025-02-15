import 'package:flutter/material.dart';
import 'package:window_size/window_size.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/foundation.dart';
import 'package:process_run/shell.dart';
import 'dart:io';

void launchURL(url) async {
  if (!await launchUrl(url)) {
    throw Exception('Could not launch $url');
  }
}

//ウィンドウサイズを変更
const double windowWidth = 700;
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
  setWindowTitle('$game ガチャ履歴インポートツール');
}

class RunScript {
  get textColor => null;

  Future<String> cmdFunction(var wishurl) async {
    var wishUrl = wishurl;
    var tempDir = await Directory.systemTemp.createTemp('process_run_example');
    var scriptFile = File('${tempDir.path}/getlink.ps1');
    var request = await HttpClient().getUrl(Uri.parse(wishUrl));
    var response = await request.close();
    await scriptFile
        .writeAsBytes(await response.expand((chunk) => chunk).toList());
    var shell = Shell(
        workingDirectory: tempDir.path,
        environment: {'PSExecutionPolicyPreference': 'Bypass'});
    var textfull = await shell.run('powershell .\\getlink.ps1');

    // 全ての出力を返す
    return textfull.outText.trim();
  }
}
