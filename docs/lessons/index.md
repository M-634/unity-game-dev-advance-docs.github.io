# unity-game-dev-advance

## 概要

---

3Dで制作されたDemoGameからテーマをピックアップし、各章毎にゲーム制作に必要な知識と技術を習得する脱初心者〜中級者向けの講座です。

#### 授業の流れ

1. 講義
2. 課題演習と質疑応答時間

の順で行っていく。課題については以下の資料を確認してください

- [課題について](problems/index.md)

## 目標

---

ゲーム制作において必要な本質的な知識を身につけ、自走して学び、ゲームを制作し続ける胆力を身につける。

## シラバス

---

| 章 | 単元 | 課題 |
| --- | --- | --- |
| 0章 | [授業ガイダンス](s0-guidance/setup.md) | |
| | [課題について](problems/index.md) | |
| | [授業用プロジェクトのセットアップ](s0-guidance/setup.md) | |
| | [授業用プロジェクト構成の説明](s0-guidance/project-structure.md) | |
| 1章 | [IKとFK、AnimationRigging](s1-character-camera/ik-fk.md)（準備中） | [1章の課題](problems/s1/index.md) |
| | [Cinemachineとカメラ制御](s1-character-camera/cinemachine.md)（準備中） | |
| | [Timeline(タイムライン)とカットシーン制作](s1-character-camera/timeline.md)（準備中） | |
| 2章 | [キャラクターAI](s2-ai-state/character-ai.md)（準備中） | 準備中 |
| | [C#① Interface(インターフェース)とpolymorphism（ポリモーフィズム)](s2-ai-state/interface-polymorphism.md)（準備中） | |
| | [C#② 状態管理(Stateパターン)](s2-ai-state/state-pattern.md)（準備中） | |
| 3章 | [グラフィックス基礎① Lighting](s3-graphics/lighting.md)（準備中）・[Skybox](s3-graphics/skybox.md)（準備中） | 準備中 |
| | [グラフィックス基礎② Shader](s3-graphics/shader.md)（準備中） | |
| | [グラフィックス基礎③ PostProcess](s3-graphics/postprocess.md)（準備中） | |
| | [グラフィックス基礎④ Rendering Pipeline](s3-graphics/srp.md)（準備中） | |
| 4章 | [C#③ ObserverパターンとR3（Reactive Extensions)](s4-csharp/r3.md)（準備中） | 準備中 |
| | [C#④ 設計への誘い　MVPパターン](s4-csharp/mvp.md)（準備中） | |
| 5章 | [総合演習](s5-final/final-project.md)（準備中） | 準備中 |
| 付録 | [New Input Systemの使い方](appendix/input-system.md) | |
| | [C#発展 CancellationTokenSourceとスキップ処理](appendix/unitask.md) | |

## 補足資料・付録の初稿

---

!!! note "準備中"
    以下は基礎・背景を確認するための初稿です。本文から必要な箇所へ移動して読めます。

| 資料 | 内容 |
| --- | --- |
| [アニメーションの全体像](s1-character-camera/animation-overview.md) | 時刻から姿勢と見た目へつながる流れ |
| [Rig と Avatar](s1-character-camera/rig-avatar.md) | 骨格・スキニング・リターゲット |
| [モーションの取り込み](s1-character-camera/motion-import.md) | 元データとコピー、イベントのタイミング |
| [アニメーションブレンド](s1-character-camera/animation-blend.md) | 重み・位相・部位ごとの混合 |
| [Timelineの再生・停止とスキップ](s1-character-camera/timeline-playback.md) | 終了理由・入力制限・キャンセルと後始末 |
| [Custom TrackとBinding](s1-character-camera/timeline-custom-track.md) | Transform Move Trackの実装と参照の解決 |
| [経路探索とA*](s2-ai-state/pathfinding.md) | グラフと探索の考え方 |
| [座標・法線・UV・色](s3-graphics/coordinates-color.md) | 描画の共通語 |
| [delegate・event・購読の寿命](appendix/events-lifetime.md) | 通知と登録解除の基礎 |

## 関連資料

- 前期（2D 中心）：[Unity Game Dev Tutorial](https://app.notion.com/p/unity-game-dev-tutorial-32f9854442bc8008861cdee72b6597ec)
