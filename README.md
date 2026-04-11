# レジュメ/卒論用テンプレート
レジュメ，および卒論のためのLaTeXテンプレートです．
従来のテンプレートをベースにしつつuplatexへの対応や便利な設定を追加した

## 方法1:Overleafで書く
ブラウザ上でLaTeXの開発ができる[Overleaf](https://www.overleaf.com/)の利用を推奨する．
無料で利用できるサービスだが，コンパイルの性能には制限があるので，巨大な画像を使ったりページ数が増えてくると制限に引っ掛かる可能性がある．（一般的な卒論くらいのサイズであれば無料枠で十分に使えるはず）

1. [Overleaf](https://www.overleaf.com/)のアカウントを作成し，ログイン
2. このリポジトリをダウンロードする（`Code`→`Download ZIP`からダウンロードできる）
3. Overleafで`新規プロジェクト`→`プロジェクトのアップロード`でGithubからダウンロードしたZIPファイルをアップロードする
4. Overleafの`設定`→`コンパイラ`→`LaTex`に設定（デフォルトは`pdfLaTeX`になっている）
5. 原稿を書く

## 方法2:ローカル環境で書く
LaTeXをローカルでビルドできる環境を構築する．

### 1. MacTeXをインストールする
homebrewを使ってインストールする．

```
$ brew install --cask mactex-no-gui
```
インストールしたら，一度ターミナルを終了して，再度開き直す．

### 2. コンパイルする
latexmkコマンドでPDFを生成できる．
latexmkrcファイルに設定が記載されているため，以下のコマンドを実行するだけでコンパイルできる

```
# ファイル名を指定してコンパイル
latexmk main.tex

# または、デフォルト設定でコンパイル（main.texが自動的に選択されます）
latexmk
```
## テンプレートの使い方
`main.tex`に設定項目などをいくつか調整して，レジュメや論文の中身は`\include{}`で読み込む形を推奨する．その方が管理が楽です．

### レジュメを作成する
レジュメは2段組で2ページのスタイル．
`main.tex`にも記載があるが，次のように記載するとレジュメ用のスタイルになる．

```
\documentclass[a4paper,dvipdfmx,uplatex,twocolumn]{jsarticle}
\usepackage{style/resume}
...
...
```

`documentclass`の中に`twocolumn`が入っているのを忘れずに．
スタイルは`style/resume`を利用する．

### 卒論を作成する
