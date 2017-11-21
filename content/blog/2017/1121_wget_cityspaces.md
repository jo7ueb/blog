---
title: "wget で認証突破！ Cityspaces データセットをダウンロードする"
slug: "1121_wget_cityspaces"
date: 2017-11-21T20:11:10+09:00
categories: [""]
tags: [""]
---

ごぶさたです、ねっぽです。

最近、自宅の計算用マシンが息を吹き返しました。
システムを入れていたSSDがしばらく前に死亡し、以降ほったらかしになっていたのですが、
ようやくやる気が出てとりあえずOSが立ち上がってGPUを使った計算ができるようにまでは
復旧させられました。
今後は、計算用マシンを活用してCNNの実装実験とかを色々やってみたいなと思っています。

さて、ディープラーニングで何か遊ぼうとした時に、データセットが必須となります。
今回は、 [Cityspases Dataset](https://www.cityscapes-dataset.com) を入手して
Semantic Segmentation の実験の準備をしたいと思います。

<a class="embedly-card" href="https://www.cityscapes-dataset.com/">Cityscapes Dataset</a><script async src="//cdn.embedly.com/widgets/platform.js" charset="UTF-8"></script>

この手のデータセットは数十GBのファイルをダウンロードする必要があり、基本的には
データセットを使うマシン上で直接DLしたいものです。
GUIを立ち上げてブラウザで落としてもいいのですが、ここはせっかくなので **wgetで**
データを落としてみたいと思います。

すると、ここで問題になるのが、 **Cityspases のダウンロードにはユーザー認証が必要** ということで、
忘備録をかねてメモを残します。

## Step 1. ユーザー認証ログイン
ここのパスワード認証の仕組みをまとめると、以下のようになっています。

 1. ユーザーがフォームにメールアドレスとパスワードを記載する
 2. 送信ボタンを押すと、メールアドレスとパスワードが POST メソッドでサーバに送信される
 3. 認証成功すると、ダウンロードページに遷移し、その際に認証情報が Cookie に保存される
 4. ダウンロード時は、Cookie の認証情報を見て、サーバが認証ユーザであることを確認する

 Cookie を使った認証になっているので、まず Cookie の取得を行う必要があります。
 これも wget で行うことができます！
コマンドは以下のとおりです。

```
$ wget --keep-session-cookies --save-cookies=cookies.txt --post-data 'username=XXXXXX&password=XXXXXX&submit=Login' https://www.cityscapes-dataset.com/login/
```

ここで、POST で送信するデータは、ユーザネーム、パスワードだけでなく `submit=Login` も必要な点がポイントです。
これを省いた場合、うまく認証されませんでした。
適切な POST データを送らないと、当然ではありますが弾かれてしまうようです。

ここで疑問になるのが、どのようなPOSTデータを送っているかということですが、これは Web ブラウザで実際に
ログインして、そこで送った POST データを使うのが良いです。
今時のブラウザであれば、開発者向けのデバッグツールが付属しており、何を送ったかがわかるようになっています。
ちなみに、Vivaldi であれば右クリックから、「検証」をクリックです。
多分 Chrome も同じです。

正常に認証されると、以下のようなレスポンスが返ってきます。
ダウンロードページにリダイレクトされているのが、成功の証です。

```
$ wget --keep-session-cookies --save-cookies=cookies.txt --post-data 'username=XXXXXX&password=XXXXXX&submit=Login' https://www.cityscapes-dataset.com/login/
--2017-11-21 19:29:39--  https://www.cityscapes-dataset.com/login/
Loaded CA certificate '/etc/ssl/certs/ca-certificates.crt'
Resolving www.cityscapes-dataset.com... 139.19.217.8
Connecting to www.cityscapes-dataset.com|139.19.217.8|:443... connected.
HTTP request sent, awaiting response... 302 Found
Location: https://www.cityscapes-dataset.com/downloads/ [following]
--2017-11-21 19:29:41--  https://www.cityscapes-dataset.com/downloads/
Reusing existing connection to www.cityscapes-dataset.com:443.
HTTP request sent, awaiting response... 200 OK
Length: 8280 (8.1K) [text/html]
Saving to: ‘index.html’

index.html                       100%[=========================================================>]   8.09K  --.-KB/s    in 0.001s

2017-11-21 19:29:42 (13.9 MB/s) - ‘index.html’ saved [40740]
```

## Step.2: ダウンロード
ここまで来たら、Cookie の認証情報を使って、実際にダウンロードするのみです。
下記のコマンドで実行します。

```
$ wget --load-cookies cookies.txt --content-disposition https://www.cityscapes-dataset.com/file-handling/?packageID=XXXX (1-4 をいれる)
````

ダウンロードするファイルはいくつかありますが、とりあえず4種類取っておけば
一通り Semantic Segmentation を試せると思われます。
全部で60GB弱ありますので、気長に待ちましょう。

----

今回はこれで以上です。
また何か書けるネタがあれば随時更新していきたいと思います。

では。
