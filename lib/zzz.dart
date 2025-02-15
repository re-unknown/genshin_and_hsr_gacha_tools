import 'package:flutter/material.dart';
import 'gacha_widget.dart';

class ZzzWidget extends StatelessWidget {
  final Function(String) addDebugMessage;

  const ZzzWidget({Key? key, required this.addDebugMessage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GachaWidget(
      siteName: 'ZZZツールボックス',
      scriptUrl:
          "https://zzz.rng.moe/scripts/get_signal_link_os.ps1", //ZZZ用のスクリプトURL
      successMessage: 'ZZZのリンクをクリップボードにコピーしました!\nZZZツールボックスに貼り付けてインポートしてください!',
      failureMessage: 'ZZZの履歴が古い、もしくは開かれていません。\n履歴を開いて再度実行してください。',
      importUrl: 'https://zzz.rng.moe/ja/tracker/import', //ZZZのインポートURL
      addDebugMessage: addDebugMessage,
    );
  }
}
