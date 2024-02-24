<<<<<<< HEAD
## 機能

このコードは、Flutterアプリケーション内で使用される2つの`ElevatedButton`ウィジェットのスタイルと動作を定義しています。

### ボタンのスタイル

- ボタンの背景色は`Color.fromARGB(255, 127, 214, 255)`を使用して、明るい水色に設定されています。
- ボタンの形状は`RoundedRectangleBorder`を使用しており、角丸の半径は`BorderRadius.circular(10.0)`で指定されています。

### ボタンの動作

- 最初のボタンを押すと、`isLoading`ステートが`true`に設定され、非同期関数`_gethsr`が実行されます。
- `_gethsr`関数は引数として指定されたURLからデータを取得する処理を行い、完了すると`isLoading`ステートを`false`に戻します。
- `isLoading`ステートが`true`の間は、ボタン内に`CircularProgressIndicator`が表示され、処理完了後は`'URLを取得する'`というテキストが表示されます。

### 使用方法

このボタンは、ユーザーがデータを取得するためにインターフェース上で操作できるように設計されています。ボタンが押されると、指定されたスクリプトを実行してデータを取得し、ボタンのラベルを更新して処理の状態をユーザーに通知します。
=======
# genshin_and_hsr_gacha_tools

A new Flutter project.
>>>>>>> origin/main
