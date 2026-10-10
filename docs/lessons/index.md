# unity-game-dev-advance

## 概要

---

3Dで制作されたDemoGameからテーマをピックアップし、各章毎にゲーム制作に必要な知識と技術を習得する脱初心者〜中級者向けの講座です。

#### 授業の流れ

1. 各章の授業の目的の確認
2. 講義
3. 課題

の順で行っていく。最後の課題は授業時間内でも取り組める時間を設けます。

課題の提出については、授業中に先生に直接見せるか、次の授業前までに授業用のslack チャンネルで報告してください。＊提出指定がないものもあります。

- 課題の決まり：[課題について](problems/index.md)
- 前期（2D 中心）：[Unity Game Dev Tutorial](https://app.notion.com/p/unity-game-dev-tutorial-32f9854442bc8008861cdee72b6597ec)
- 使用バージョン：Unity 6000.3.19f1 / URP 17.3

## 目標

---

ゲーム制作において必要な本質的な知識を身につけ、自走して学び、ゲームを制作し続ける胆力を身につける。

## シラバス

---

| 章 | 単元 | 課題 |
| --- | --- | --- |
| 0章 | [授業ガイダンス](s0-guidance/setup.md) | [課題について](problems/index.md) |
| 1章 | [IKとFK、AnimationRigging](s1-character-camera/ik-fk.md) | [1章の課題](problems/s1/index.md) |
| | [Cinemachineとカメラ制御](s1-character-camera/cinemachine.md) | |
| | [Timeline(タイムライン)とカットシーン制作](s1-character-camera/timeline.md) | |
| 2章 | [キャラクターAI](s2-ai-state/character-ai.md)（準備中） | 準備中 |
| | [C#① Interface(インターフェース)とpolymorphism（ポリモーフィズム)](s2-ai-state/interface-polymorphism.md)（準備中） | |
| | [C#② 状態管理(Stateパターン)](s2-ai-state/state-pattern.md)（準備中） | |
| 3章 | グラフィックス基礎① [Lighting](s3-graphics/lighting.md)（準備中）・[Skybox](s3-graphics/skybox.md)（準備中） | 準備中 |
| | [グラフィックス基礎② Shader](s3-graphics/shader.md)（準備中） | |
| | [グラフィックス基礎③ PostProcess](s3-graphics/postprocess.md)（準備中） | |
| | [グラフィックス基礎④ Rendering Pipeline](s3-graphics/srp.md)（準備中） | |
| 4章 | [C#③ ObserverパターンとR3（Reactive Extensions)](s4-csharp/r3.md)（準備中） | 準備中 |
| | [C#④ 設計への誘い　MVPパターン](s4-csharp/mvp.md)（準備中） | |
| 5章 | [総合演習](s5-final/final-project.md)（準備中） | 準備中 |
| 付録 | [New Input Systemの使い方](appendix/input-system.md) | |
| | [C#発展 CancellationTokenSourceとスキップ処理](appendix/unitask.md) | |

## 0章 ガイダンス

---

- [課題について](problems/index.md)
- [授業用プロジェクトのセットアップ](s0-guidance/setup.md)
- [授業用プロジェクト構成の説明](s0-guidance/project-structure.md)

各単元を独立して扱い、課題は章ごとにまとめます。

## 1章 3Dキャラクターの動作とカメラ制御

---

**IK・FK／Animation Rigging**：関節の動きと目標位置の関係を学び、手を箱や灯火に合わせる仕組みを確認します。関連する補足資料は主教材のページ内から参照できます。

- [IKとFK、AnimationRigging](s1-character-camera/ik-fk.md)

**Cinemachine／カメラ制御**：手で書いたカメラの困りごとを体験し、Cinemachine で追従・壁の回避・TPS / FPS の切り替え・画面の揺れを作ります。

- [Cinemachineとカメラ制御](s1-character-camera/cinemachine.md)

課題：[1章の課題](problems/s1/index.md)

## 2章 キャラクターAIとState管理

---

## 3章 グラフィックスとゲームの絵作り

---

- [Lighting](s3-graphics/lighting.md)（準備中）
- [SkyBox](s3-graphics/skybox.md)（準備中）
- [Shader(シェーダー)](s3-graphics/shader.md)（準備中）
- [PostProcess(ポストプロセス)](s3-graphics/postprocess.md)（準備中）
- [SRP(Scriptable Render Pipeline)](s3-graphics/srp.md)（準備中）

## 4章 C#の応用

---

## 5章 総合演習

---

## 付録

---

- [New Input Systemの使い方](appendix/input-system.md)
- [C#発展 CancellationTokenSourceとスキップ処理](appendix/unitask.md)
