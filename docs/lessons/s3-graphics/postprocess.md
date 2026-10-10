# グラフィックス基礎③ PostProcess

[シラバス](../index.md) ｜ 章の課題：3章の課題（準備中）

!!! note "準備中"
    この単元の資料は作成中です。

## 概要

---

PostProcess は「描画が終わったあとの画面全体に、もう一度手を加える」処理です。
[Lighting](lighting.md)・[Shader](shader.md) で作った絵に、最後の仕上げをかけます。

## 扱う内容

---

- **Volume** コンポーネントと Volume Profile
- **Global** モードと **Local** モード
- 代表的な効果：**Bloom** と **Vignette**
- その他の効果は [Post-processing effects（URP）](https://docs.unity3d.com/6000.3/Documentation/Manual/urp/EffectList.html) を参照

**使用シーン**：`Assets/Application/Section3-Graphics/PostProcess/PostProcess.unity`（`Global Volume` に Bloom と Vignette）

> **かけすぎに注意。** PostProcess は「効いている」と分かる時点でかけすぎなことが多いです。

## 🎬 お手本（DemoGame）で見るところ

---

画面全体にかかった PostProcess。
