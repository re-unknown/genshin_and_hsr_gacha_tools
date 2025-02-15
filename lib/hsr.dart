import 'package:flutter/material.dart';
import 'gacha_widget.dart';

class HsrWidget extends StatelessWidget {
  final Function(String) addDebugMessage;

  const HsrWidget({super.key, required this.addDebugMessage});

  @override
  Widget build(BuildContext context) {
    return GachaWidget(
      siteName: 'STARRAIL STATION',
      scriptUrl:
          "https://gist.githubusercontent.com/Star-Rail-Station/2512df54c4f35d399cc9abbde665e8f0/raw/get_warp_link_os.ps1",
      successMessage:
          'リンクをクリップボードにコピーしました!\nSTARRAIL STATIONに貼り付けてインポートしてください!',
      failureMessage: 'ガチャ履歴が古い、もしくは開かれていません。\n履歴を開いて再度実行してください。',
      importUrl: 'https://starrailstation.com/jp/warp#import',
      addDebugMessage: addDebugMessage,
    );
  }
}
