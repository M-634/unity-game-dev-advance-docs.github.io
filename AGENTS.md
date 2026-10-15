# AGENTS.md

このファイルは Codex と Claude Code の共通ガイドです。共通ルールはここだけを編集し、`CLAUDE.md` は `@AGENTS.md` で読み込みます。

## 作業分担と共同作業

- ユーザー：Unity の `Assets/Application/` 以下の演習シーン・スクリプト・アセットを制作。
- Claude Code：Unity の `Assets/_DemoGame/` 以下の完成見本ゲームを制作。
- Codex：このリポジトリの講義本文・課題・補足資料・図解・教材サイトを整備。
- ユーザーから担当変更の指定がない限り、担当外の実装は参照にとどめ、必要な変更を担当者向けに整理する。
- 作業前に `git status` と対象ファイルの現状を確認する。既存の未コミット変更を勝手に戻さない。同じファイルの並行編集を避ける。
- 作成中のシーンについて、未確定のファイル名・秒数・Hierarchy・完成済みの挙動を事実として書かない。構成案と確認済みの事実を区別する。
- `.claude` と `.codex` は各ツール固有の設定を置く。共通ルールは本ファイル、共通の実行処理は `src/docs.py` に集約し、重複コピーを作らない。

## このリポジトリについて

日本語で行う Unity ゲーム開発授業（後期）の教材です。Markdown で書き、MkDocs Material で静的サイトにして GitHub Pages に公開しています。アプリケーションのコードはありません。成果物は `docs/lessons/` 以下の授業ページで、ページの本文はすべて日本語で書きます。

授業で扱う Unity プロジェクトは別の git リポジトリで、ローカルの `.local/unity-game-dev-advance/` に置いてあります（`.local/` は gitignore 済み）。ページに書くシーンのパス、スクリプト名、アセット名は、このプロジェクトを読んで確認してください。この資料リポジトリから Unity のビルドやデプロイはしません。教材サイトのローカルビルドは行います。

## コマンド

仮想環境は `.venv/`（Windows）にあります。依存関係は `src/requirements.txt` でバージョンを固定しています。MkDocs 2.0 はテーマやプラグインと互換性がないため、あえて 1.x に留めています。

```bash
# インストール
.venv/Scripts/python.exe -m pip install -r src/requirements.txt

# http://127.0.0.1:8000 でライブプレビュー（.claude/launch.json にも "mkdocs" として定義済み）
.venv/Scripts/python.exe src/docs.py serve

# output/docs にビルド（CI と同じ処理）。リンク切れや nav に載っていないページがないかログを確認する
.venv/Scripts/python.exe src/docs.py build
```

テストやリンターはありません。自動チェックは `mkdocs build` の警告だけです。

デプロイ：`master` への push で `docs/lessons/**`、`mkdocs.yml`、`src/**` のいずれかが変わると、`.github/workflows/deploy-docs.yml` がビルドして GitHub Pages に公開します。

## 構成

- `mkdocs.yml` — `docs_dir` は `docs/lessons` なので、公開されるのはその中だけです。`nav` は手書きです。**新しいページは `nav` に追加するまでサイトに表示されません。** ページの名前を変えたり移動したりしたときは、`nav` とそのページへの相対リンクをすべて更新してください。
- `docs/lessons/` — 公開ページ。
  - `index.md`（シラバス）、`assets.md`、`s0-guidance/`（環境構築とプロジェクト構成）
  - `s1-character-camera/` … `s5-final/` — 章ごとに 1 フォルダ。講義ページと補足資料ページが入ります
  - `appendix/` — 単独の付録
  - `problems/` — 課題。`problems/index.md`、章ごとの一覧 `problems/sN/index.md`、1 ページ 1 問の `problems/sN/sN-M.md`
  - 画像は使うページと同じ階層の `images/` フォルダに置き、相対パス（`images/foo.png`）で参照します。
- `docs/templates/` — `lecture.md` と `assignment.md` のひな形。`docs_dir` の外なので公開されません。新しいページはここから作ります。
- `src/overrides/` — MkDocs Material の `custom_dir`。同梱した `mermaid.min.js` と iframe-worker の shim が入っています。

## オフラインの制約

ビルドしたサイトは、ネットワークなしで `file://` から開いても動く必要があります（zip でも配布するため）。そのため `mkdocs.yml` では `use_directory_urls: false`、`font: false`、`offline` プラグインを設定し、Mermaid と検索用の shim は CDN ではなく `src/overrides/assets/javascripts/` から読み込んでいます。外部 CDN、Google Fonts、リモートのスクリプトから読み込むものは追加しないでください。必要なものは `src/overrides/` に同梱します。

## ページの書き方

レイアウトの参考ページ：`s1-character-camera/ik-fk.md` と `s1-character-camera/cinemachine.md`。

- 講義ページは H1 で始め、次にシラバスと章の課題へ戻るリンク行、その次に `## 概要` を置きます。H2/H3 の見出しの後には `---` の区切り線を入れます。
- 概要は機能名からではなく、ゲームでプレイヤーや開発者が困る問題から書き始めます。
- 「この単元の問い：」の行（このページの問い／今週の問い などの言い換えも含む）は入れません。
- 手を動かす演習がある講義ページには、**使用シーン** と **完成見本** の行を持つ `## 演習の準備` の表を置きます。
- シーン名：`〇〇_Work.unity` は学生が作業するシーン、`〇〇_Sample.unity` は完成版（模範解答）です。パスは `Assets/Application/SectionN-…/` から省略せずに書きます。
- 授業では `Assets/_DemoGame/` のアセットを直接使いません。`_DemoGame` は学生が編集してはいけない完成済みのショーケースです。複数の単元で共通利用する素材とシーンテンプレートは `Assets/Application/_CommonSectionAssets/` にまとめ、共通スクリプトは `Section.Common` などの名前空間を使います。単元固有の素材は `Assets/Application/SectionN-…/` 以下に置き、スクリプトは対応する名前空間（例：`Section1.AnimationRigging`）に入れます。ページでは `Application` 側の素材を案内し、共通素材を単元ごとに丸ごとコピーする手順にはしません。学生は共通素材の元ファイルを上書きせず、改造が必要な場合は講師の指示に従って単元用のコピーなどを作ります。
- 課題ページのタイトルは `N−M★★☆☆☆　<タイトル>`（全角数字、星 5 段階の難易度）です。上下に同じパンくずリンク行を置き、`### 推奨条件`（`・` の箇条書きを `text` のコードブロックで囲む）と `### 提出方法` のセクションを入れます。`nav` には星を除いたタイトルを書きます。
- 図は Mermaid のコードブロック（`pymdownx.superfences` のカスタムフェンス）で書きます。図の後には、図の内容を言葉で説明する文を続けます。
- 使える Markdown 拡張：admonition、`pymdownx.details`、タスクリスト、`attr_list`、`md_in_html`、表。

