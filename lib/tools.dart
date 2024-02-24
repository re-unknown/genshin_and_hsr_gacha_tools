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
const double windowHeight = 500;

void setupWindow() {
  // webとプラットフォームをチェック
  if (!kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
    WidgetsFlutterBinding.ensureInitialized();
    setWindowTitle('genshin and HSR gacha tools(原神&崩壊:スターレイル ガチャツール)');
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
    String result = textfull.outText.trim().split('\n').last;
    return result;
  }
}
