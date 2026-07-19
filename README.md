# レジュメ用テンプレート
レジュメ作成のためのLaTeXテンプレートです．
従来のテンプレートをベースにしつつuplatexへの対応や便利な設定を追加した．

> **このリポジトリは基本的にレジュメ用（`style/resume`）のテンプレートです．**
> 卒論用のスタイル（`style/thesis`）も同梱していますが，こちらはあくまで**参考程度**のものです．卒論の体裁は研究室ごとに指導教員の指示があるはずなので，まずはそちらに従ってください．このスタイルの利用を強要するものではありません．参考になりそうなら自由に使ったり，必要な部分だけ取り入れたりしてください．

## 執筆環境の選び方
次の4つの環境でコンパイルできる．迷ったらOverleafを使えばよい．

| 環境 | 向いている人 | 備考 |
|---|---|---|
| 方法1:Overleaf | まずはこれ．インストール不要 | 無料枠にはコンパイル性能の制限あり |
| 方法2:ローカル環境 | エディタ連携やオフラインで書きたい | MacTeXのインストールが必要（約5GB） |
| 方法3:Docker | PCの環境を汚したくない | パッケージ不足が起きない．イメージ約8GB |
| 方法4:Appleコンテナ | Docker Desktopを入れたくない | macOS 26以降・Apple Silicon限定（実験的） |

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
latexmkrcファイルに設定が記載されているため，以下のコマンドを実行するだけでコンパイルできる．
コンパイルは `uplatex`（→ `*.dvi`）→ `dvipdfmx`（→ `*.pdf`）の流れで行われる．

```
# ファイル名を指定してコンパイル
latexmk main.tex

# ファイル名を省略するとデフォルトのmain.texがコンパイルされる
latexmk

# （参考）卒論用の thesis.tex をコンパイルする場合はファイル名を明示する
latexmk thesis.tex
```

#### 便利なオプション

```
# コンパイル後にPDFを開く（macOS）
latexmk -pv main.tex

# 保存するたびに自動で再コンパイル（編集中に便利．Ctrl-Cで停止）
latexmk -pvc main.tex
```

リポジトリにはMakefileも用意してあり，`make`（= `latexmk main.tex`）や`make watch`（= `latexmk -pvc main.tex`）でも実行できる．
なお，`-pvc`による自動再コンパイルとSyncTeX（エディタとPDFの相互ジャンプ）はローカル環境専用の機能で，後述のDocker・Appleコンテナでのコンパイルでは利用できない．

#### 中間ファイルの掃除

`.aux` `.log` `.synctex.gz` などの中間ファイルが散らかったら以下で掃除できる．

```
# 中間ファイルのみ削除（PDFは残す）
latexmk -c

# PDFも含めて生成物をすべて削除
latexmk -C
```

ファイル名を省略するとmain.texが対象になる．`thesis.tex` を対象にする場合は `latexmk -c thesis.tex` のようにファイル名を指定する．
Makefileからは`make clean`（中間ファイルのみ）/`make distclean`（PDFも削除）で実行できる（`make clean TARGET=thesis.tex`のように対象を指定可能）．

#### うまくコンパイルできないとき

ローカル環境で日本語フォントが見つからずPDF生成（dvipdfmx）に失敗する場合がある．
本テンプレートでは和文フォントにTeX Live同梱の `haranoaji`（原ノ味フォント）を使う設定になっているため，MacTeXを入れていれば追加のフォントインストールは不要．
それでも失敗する場合は，一度 `latexmk -C` で生成物を削除してから再度コンパイルすると直ることがある．

また，「ローカルでは通るのにOverleafやコンテナでだけ失敗する」場合は，`\include{}`などで指定したファイル名の大文字小文字を疑うとよい．macOSは大文字小文字を区別しないが，Overleafやコンテナ内のLinuxは区別する．

## 方法3:Dockerで書く
LaTeX環境一式が入った公式Dockerイメージ（[texlive/texlive](https://hub.docker.com/r/texlive/texlive)）でコンパイルする方法．
PCにTeXをインストールする必要がなく，フルセットのイメージなのでパッケージ不足のトラブルも起きない．
[Docker Desktop](https://www.docker.com/products/docker-desktop/)（または互換のコンテナランタイム）をインストールし，起動した状態で使う．

```
# リポジトリのルートで実行
make docker

# 卒論（thesis.tex）をコンパイルする場合
make docker TARGET=thesis.tex
```

`make docker`は次のコマンドを実行するのと同じ（makeが無い環境ではこちらを直接実行してもよい）．

```
docker run --rm -v "$PWD:/workdir" -w /workdir texlive/texlive:latest latexmk main.tex
```

初回はイメージのダウンロード（約2.5GB，展開後約8GB）で数分待つが，2回目以降はすぐにコンパイルが始まる．
イメージは週次で更新されているので，たまに `docker pull texlive/texlive:latest` で更新するとよい．

## 方法4:Appleコンテナで書く
macOS 26以降のApple Silicon Macなら，Docker Desktopの代わりにApple公式の[containerコマンド](https://github.com/apple/container)でも方法3と同じイメージでコンパイルできる（比較的新しいツールなので実験的な位置づけ）．

```
# インストール（初回のみ）
brew install container

# コンテナサービスを起動（マシンを再起動したときにも必要）
container system start

# コンパイル（make apple でも同じ）
make container

# 卒論（thesis.tex）をコンパイルする場合
make container TARGET=thesis.tex
```

`make container`は次のコマンドを実行するのと同じ．

```
container run --rm -v "$PWD:/workdir" -w /workdir texlive/texlive:latest latexmk main.tex
```

メモリ不足でコンパイルに失敗する場合は，`container run`に`--memory 2g`を付けて実行してみる．
イメージの更新は `container images pull texlive/texlive:latest` で行う．

## テンプレートの使い方
`main.tex`に設定項目などをいくつか調整して，レジュメの中身は`\include{}`で読み込む形を推奨する．その方が管理が楽です．

### レジュメを作成する（メイン）
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

### （参考）卒論を作成する
> **注意：** 卒論用スタイル（`style/thesis`）は参考程度の位置づけです．卒論の体裁は研究室ごとに指導教員の指示があるはずなので，まずはそちらに従ってください．このスタイルの利用を強要するものではなく，参考になりそうなら自由に使ったり，必要な部分だけ取り入れたりする形で構いません．

卒業論文は章立ての文書なので，`jsbook`クラスと`style/thesis`スタイルを利用する．
`thesis.tex`の冒頭は次のようになっている．

```
\documentclass[a4paper,dvipdfmx,openany,uplatex,report]{jsbook}
\usepackage{style/thesis}
```

レジュメと違い`twocolumn`は付けない．`thesis.tex`の先頭で次のように基本情報を設定する．

```
\thesistype{卒業論文}                              % 論文種別
\title{論文タイトル}
\subtitle{サブタイトル}                            % 不要なら空のまま
\author{X12345 愛工太郎}
\supervisor{指導教員名}
\affiliation{愛知工業大学 情報科学部 情報科学科}
\date{2026年3月}
```

これらの情報をもとに`\maketitle`で表紙が生成される．
本文は章ごとに`thesis/`以下の`.tex`ファイルへ`\chapter{}`から記述し，`thesis.tex`から`\include{}`で読み込む．
`thesis/example/`には，論文の書き方の解説と`LaTeX`記法サンプルを兼ねた記述例（序論・論文執筆の作法・文章作成のための`LaTeX`記法・図表数式コードの記法・結論の5章）が用意されているので参考にすること．
画像の載せ方（サイズ・回転・トリミング・横並び・回り込み・横向きページ），表（セル結合・幅指定・数値揃え・色付き・ページまたぎ），数式，グラフ（pgfplots），ソースコード，アルゴリズムなど，多くのパターンを実例とソースコード付きで網羅している．
章番号は`quotchap`パッケージで装飾され，各ページのヘッダーに章・節のタイトル，フッターにページ番号が表示される．

参考文献は`thesis.tex`末尾の`thebibliography`環境に記述する（文献数が多い場合はBibTeXも利用可）．

#### 下書きモード
レジュメと同様に，`\ThisIsDraft`を記述すると全ページに「DRAFT」の透かしとビルド日のバージョン情報が表示される．提出時には削除すること．

#### コンパイル
`thesis.tex`はデフォルトファイル（`main.tex`）ではないので，ファイル名を明示してコンパイルする．

```
latexmk thesis.tex
```
