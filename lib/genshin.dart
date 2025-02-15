import 'package:flutter/material.dart';
import 'gacha_widget.dart';

class GenshinWidget extends StatelessWidget {
  final Function(String) addDebugMessage;

  const GenshinWidget({Key? key, required this.addDebugMessage})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GachaWidget(
      siteName: 'paimon.moe',
      scriptUrl:
          "https://gist.githubusercontent.com/MadeBaruna/1d75c1d37d19eca71591ec8a31178235/raw/getlink.ps1",
      successMessage: 'リンクをクリップボードにコピーしました!\npaimon.moeに貼り付けてインポートしてください!',
      failureMessage: '祈願履歴が古い、もしくは開かれていません。\n履歴を開いて再度実行してください。',
      importUrl: 'https://paimon.moe/wish/import',
      addDebugMessage: addDebugMessage,
    );
  }
}
