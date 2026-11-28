---
name: ocr-review
description: OpenCodeReviewでPR・単一コミット・未コミット差分をレビューする。既存の差分レビュー結果の採否判断、修正、限定再レビューにも使う。
---

# OCR 差分レビュー

対象に一致する既存の結果がある場合は、その原文から続ける。対象リポジトリ、修正前のHEAD、既存の未コミット差分・未追跡ファイルを控える。新規実行は原則1回。PRはbaseとheadのSHAを取得して `ocr review --from "$base_sha" --to "$head_sha"`、単一コミットは `ocr review --commit "$sha"`、未コミット差分は `ocr review` を使う。クリーンな作業ツリーでもPRにはコミット済み差分がある。対象0件なら指定範囲を確認する。

実行前に[指摘の採否・修正・検収手順](references/workflow.md)を読み、依頼された段階まで進める。
