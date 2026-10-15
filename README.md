# Unity ゲーム開発（後期）講義資料

3Dゲームの制作を通して、脱初心者〜中級者向けの知識と技術を学ぶ授業の資料リポジトリです。完成見本『LUMEN』から題材を取り出し、単元ごとの演習と講義資料につなげます。

## リポジトリの構成

- `docs/lessons/`：公開する講義資料・補足資料・課題。
- `docs/templates/`：講義と課題のひな形。
- `mkdocs.yml`：教材サイトの目次と表示設定。
- `src/overrides/`：教材サイトの表示やオフライン動作を支えるファイル。
- `.local/unity-game-dev-advance/`：参照用の Unity プロジェクト（別 Git リポジトリ。このリポジトリでは管理対象外）。

資料は日本語の Markdown で作成し、MkDocs Material でサイト化します。GitHub Pages での閲覧に加え、配布ファイルをオフラインで閲覧できる構成です。

## 教材の構成

| 章 | テーマ |
| --- | --- |
| 0章 | ガイダンス・環境構築・プロジェクト構成 |
| 1章 | 3Dキャラクターの動作とカメラ制御 |
| 2章 | キャラクターAIとState管理 |
| 3章 | グラフィックスとゲームの絵作り |
| 4章 | C#の応用（R3・MVP） |
| 5章 | 総合演習 |
| 付録 | Input System・UniTask関連の補足 |

学生が作業する場所は `Assets/Application/` 以下です。共通素材とシーンテンプレートは `Assets/Application/_CommonSectionAssets/`、単元固有のシーンと素材は `Assets/Application/SectionN-…/` に分けます。共通素材の元ファイルは上書きせず、各単元の演習から利用します。`Assets/_DemoGame/` は完成形を参照する展示として扱います。講義資料では演習用の `*_Work.unity` と完成見本の `*_Sample.unity` を区別して案内します。

教材の執筆規約と確認コマンドは [AGENTS.md](AGENTS.md)、授業の目次は [シラバス](docs/lessons/index.md) を参照してください。
