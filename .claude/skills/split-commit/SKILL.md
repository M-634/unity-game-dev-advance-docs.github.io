---
name: split-commit
description: 未コミットの差分（未追跡ファイルを含む）を作業単位に分け、ユーザーがコピペで実行する `git add` と `git commit -m "[add|fix|update] ..."` のコマンド列を表で表示する。ユーザーが「分割コミット」「コミットのコマンドを出して」と言ったときや /split-commit で使う。
---

# 分割コミットのコマンドを表示する

AI はコミットも push もしない（AGENTS.md のルール）。このスキルでやるのは、**ユーザーがコピペして実行するコマンドを表示するところまで**。`git add`・`git commit`・`git push` は自分では実行しない。

## 1. 差分を集める

対象は 2 つのリポジトリ。ユーザーが片方だけを指定したら、そちらだけを扱う。

- 資料リポジトリ：このリポジトリのルート
- Unity リポジトリ：`.local/`（git のルートは `.local/`。Unity プロジェクトはその下の `unity-game-dev-advance/`）

それぞれで次を実行する。

```bash
git status --porcelain=v1 --untracked-files=all
git diff --stat
git diff --cached --stat
```

- **未追跡ファイル（`??`）を必ず含める。** 2026-10-17 に、未追跡ファイルが漏れて移動先のファイルが push されない事故があった。
- すでにステージ済み（`git status` の 1 列目が空白でない）のファイルがあれば、最初に伝える。ステージ済みのファイルは次の `git commit` に必ず入るので、それを含むコミットを 1 番目に置く。別のコミットに入れたいときは、最初に `git restore --staged -- <path>` を表示する。
- 1 つのファイルに目的の違う変更が混ざっていて分けられないときは、そのファイルを主な目的のコミットに入れ、メッセージかその下の説明でそう伝える（`git add -p` は対話式なので表示しない）。
- 中身が分からないファイルは `git diff -- <path>` で中身を読んでから分類する。推測で分けない。

## 2. 作業単位に分ける

- 1 コミットにまとめるのは「同じ目的の変更」。例：1 つの講義ページとその画像、1 つの機能のスクリプトと Prefab、1 つの設定変更。
- Unity のアセットは **本体と `.meta` を必ず同じコミットに入れる**。フォルダを追加したら、フォルダの `.meta` も入れる。
- 移動・名前変更は、**移動元の削除と移動先の追加を同じコミットに入れる**。片方だけのコミットを作らない。
- `mkdocs.yml` の `nav` の変更は、追加・変更したページと同じコミットに入れる。
- 次のものはコミットに入れず、表の外で「入れていないファイル」として理由を添えて示す：作業用の一時ファイル（`.py`、`.json`、メモ、スクリーンショットなど）、エディタやビルドが生成するもの、目的が分からないもの。
- 全ファイルが、ちょうど 1 つのコミットか「入れていないファイル」のどちらかに入っていることを確かめる。

## 3. コミットメッセージ

- 英語で書き、先頭に接頭辞を 1 つ付ける。接頭辞と本文の間は半角スペース 1 つ。
  - `[add]`：新しいファイル・機能・ページを追加した
  - `[fix]`：誤り・不具合・壊れたリンクなどを直した
  - `[update]`：既存の内容を改善・追記・整理した（削除や移動も含む）
- 本文は命令形の短い 1 行（例：`[add] Timeline work and sample scenes`）。72 文字以内。ピリオドは付けない。

## 4. 表示する形

出力は **1 つの表だけ** にまとめる。表の前後の説明は、注意点（ステージ済みのファイル、壊れた参照、入れていないファイルなど）を短い箇条書きで添える程度にする。コマンドをコードブロックで並べ直さない。

表の列：`#`、`リポジトリ`（資料 / Unity）、`メッセージ`、`数`（ファイル数）、`コマンド`

- 行の順番は実行順。資料リポジトリのコミット、Unity リポジトリのコミット、確認、push の順に並べる。
- `コマンド` 列は 1 行で、`git add` が成功したときだけ `git commit` が走るようにつなぎ、インラインコードで書く。つなぎ方はユーザーのシェルに合わせる。
  - Windows（PowerShell 5.1。`&&` が使えない）：`git add -A -- <paths>; if ($?) { git commit -m "<message>" }`
  - Mac / Linux / Git Bash（zsh・bash）：`git add -A -- <paths> && git commit -m "<message>"`
  - どちらか分からないときは、作業環境の OS（Platform）で決める。win32 なら PowerShell 形式にする。
- 作業フォルダは資料リポジトリのルートとする。Unity リポジトリは `git -C .local/unity-game-dev-advance` を付け、パスは Unity プロジェクトから見た相対パス（`Assets/...`、`ProjectSettings/...`）で書く。パスを短くするため。
- `git add` には `-A --` を付けてパスを列挙する（削除や移動元も確実にステージするため）。スペースを含むパスは `"` で囲む。
- フォルダの中身をすべて同じコミットに入れるときだけ、フォルダのパスでまとめてよい。一部だけ入れるときはファイルを列挙する。
- 最後の行に、確認（`status` が空か）と push の行を入れる。`メッセージ` 列には「確認」「push」と書く。Unity は確認の行で何も表示されないこと（または「入れていないファイル」だけが残ること）を確かめてから push する。

例（Windows の PowerShell 形式）：

| # | リポジトリ | メッセージ | 数 | コマンド |
|---|---|---|---|---|
| 1 | 資料 | `[update] Timeline lecture page` | 3 | `git add -A -- docs/lessons/s1-character-camera/timeline.md mkdocs.yml; if ($?) { git commit -m "[update] Timeline lecture page" }` |
| 2 | Unity | `[add] Timeline work and sample scenes` | 4 | `git -C .local/unity-game-dev-advance add -A -- Assets/Application/Section1-CharacterCamera/Timeline/Sample; if ($?) { git -C .local/unity-game-dev-advance commit -m "[add] Timeline work and sample scenes" }` |
| 3 | 資料 | 確認 | – | `git status --short --untracked-files=all` |
| 4 | Unity | 確認 | – | `git -C .local/unity-game-dev-advance status --short --untracked-files=all` |
| 5 | Unity | push | – | `git -C .local/unity-game-dev-advance push origin master` |
| 6 | 資料 | push | – | `git push origin master` |

## 5. 表示する前の確認

- 表示したパスがすべて実在するか、削除されたものなら `git status` に出ているかを照合する。
- 講義ページが Unity のパスを参照している場合は、そのパスが Unity リポジトリにコミットされる予定か、`origin/master` にすでにあるかを確かめる。どちらでもなければ警告する。
- 最後に、コミットの数・ファイルの合計数・「入れていないファイル」の数を 1 行で示す。
