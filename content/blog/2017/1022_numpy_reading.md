---
title: "実録！コードリーディング入門 ~ NumPy rollaxis & transpose 編 ~ を公開したよ"
slug: "NumPy_code_reading"
date: 2017-10-22T17:45:46+09:00
categories: ["プログラミング"]
tags: ["NumPy","コードリーディング"]
---

ども、ねっぽです。

この度、Qiita に **[「実録！コードリーディング入門 ~ NumPy rollaxis & transpose 編 ~」](https://qiita.com/jo7ueb/items/25ede2bd48c4a2b322e2)**
と題して、2つの記事を投稿しました。
これは、個人的な興味から [`numpy.rollaxis`](https://docs.scipy.org/doc/numpy-1.13.0/reference/generated/numpy.rollaxis.html) と
[`numpy.transpose`](https://docs.scipy.org/doc/numpy-1.13.0/reference/generated/numpy.transpose.html)
の実装について、コードリーディングを行った際の過程を詳らかに記したものです。

ソフトウェア開発に携わっていると、どうしてもコードを読む機会が出てきますが
大規模なソフトウェアの場合、どこから読めばいいのか、どう読んでいけばいいのかが
わからず、呆然としてしまう場合があります。

この記事では、UNIX系の環境ならどこにでも入っている find & grep & less
の3コマンドを駆使して、コードを読み解いていく過程を、なるべく手順を省かずに
まとめています。
この記事が、コードリーディングに悩めるエンジニアの人の目に止まって、
役に立ってくれることを願うばかりです。

[前編](https://qiita.com/jo7ueb/items/25ede2bd48c4a2b322e2) と
[後編](https://qiita.com/jo7ueb/items/ba8a004cde262b0a0626) に分かれていますので
まずは前編から目を通していただけると幸いです！

----
このブログと Qiita の使い分けが非常に悩ましいです。
Qiita のほうが SEO が効いていたり、ユーザー間のつながりがうまく作られているので
技術系の記事や論文読みのメモを Qiita に書いて、こちらのブログでは主に勉強会の
参加メモ等を書こうかなとは思っています。

いい感じの使い分けがあったら、ぜひ教えていただけるとうれしいです！
