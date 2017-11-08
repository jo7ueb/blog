---
title: "Railsアプリ radvent インストールメモ"
slug: "install_radvent"
date: 2017-11-08T21:07:35+09:00
categories: ["メモ"]
tags: [""]
---

ども、ねっぽです。

そろそろアドベントカレンダーの時期が近づいてきましたね！

アドベントカレンダーといえば Qiita が定番ですが、イントラ環境で動かしたい人など向けに
Ruby on Rails 製の [radvent](https://github.com/nanonanomachine/radvent)
というアプリケーションがあり、勤務先の社内アドベントカレンダーで使われています。

<a class="embedly-card" href="https://github.com/nanonanomachine/radvent">nanonanomachine/radvent: Advent calendar app for programmers like Qiita</a><script async src="//cdn.embedly.com/widgets/platform.js" charset="UTF-8"></script>

このアプリはとても素晴らしいアプリなのですが、機能追加のリクエストとして
「新着コメントをトップページで見れるようにしてほしい」という声が上がっていました。
GitHub を見てみたところ [issue](https://github.com/nanonanomachine/radvent/issues/26)
も上がっているようでしたが、作者様ご多忙のようなので、自分で改良しようと考えました。

アプリを改良するためにはまず検証用に手元で radvent を起動してみたいところですが、
rails 初心者にはいくつかハマりどころがあったので、試行錯誤の顛末を簡単にまとめます。

## (1) ruby 環境のインストール + Rails インストール
そもそも Rails を動かすために、ruby を入れる必要があります。
まっさらの環境で ruby が入っていなかったので、下記サイトを参考にインストールしました。

<a class="embedly-card" href="https://mae.chab.in/archives/2612">rbenvでRubyを管理し、Rails開発環境を構築する | maesblog</a><script async src="//cdn.embedly.com/widgets/platform.js" charset="UTF-8"></script>

ここでポイントは、システムに入っている ruby を使うのではなく、rbenv を使うということでした。
Python もそうですが、LL言語はバージョン間の違いが激しかったりするので、rbenv や pyenv のように
柔軟にバージョンを切り替えられるシステムは必須だと感じました。

なお、 **radvent では ruby 2.1.5 が要求されている** と言うのがちょっとしたハマリポイントでした。

## (2) Javascript 実行環境のインストール
上記サイトの手順通りに Rails をインストールしたら、 `$ bundle exec rails s`
でアプリケーションを立ち上げます。
しかし、エラーが出て立ち上がってくれません。

<blockquote class="twitter-tweet" data-lang="en"><p lang="en" dir="ltr">Gem Load Error is: Could not find a JavaScript runtime.  ちーん</p>&mdash; Neppo Telewisteria (@jo7ueb) <a href="https://twitter.com/jo7ueb/status/928208875819474945?ref_src=twsrc%5Etfw">November 8, 2017</a></blockquote>
<script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>

アプリケーションの実行に Javascript 実行環境が必要なのに、インストールされていないという問題でした。
Node.js をインストールするなどの手順がありますが、今回はなるべく環境を汚したくなかったので、
`bundle install` コマンドですべてがインストールできるようにしました。

手順は Gemfile を一行コメントアウトして、 `therubyracer` というパッケージを入れるだけでした。
詳細は下記PRを見てください。

<a class="embedly-card" href="https://github.com/nanonanomachine/radvent/pull/39">add missing dependency: therubyracer by jo7ueb · Pull Request #39 · nanonanomachine/radvent</a><script async src="//cdn.embedly.com/widgets/platform.js" charset="UTF-8"></script>

## (3) 鍵の生成
次に `bundle exec rails s` をすると、鍵がないとのことで怒られてしまいます。
<blockquote class="twitter-tweet" data-lang="en"><p lang="en" dir="ltr">Unexpected error while processing request: Missing `secret_key_base` for &#39;development&#39; environment, set this value in `config/secrets.yml`</p>&mdash; Neppo Telewisteria (@jo7ueb) <a href="https://twitter.com/jo7ueb/status/928215370858602496?ref_src=twsrc%5Etfw">November 8, 2017</a></blockquote>
<script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>

友人と Google 先生の助言より、鍵生成とコンフィグファイルの生成がわかりました。
<blockquote class="twitter-tweet" data-lang="en"><p lang="ja" dir="ltr">bundle exec rake secret で鍵を生成して、config/secrets.yml をまず作ると<a href="https://t.co/sxKvYrUYHB">https://t.co/sxKvYrUYHB</a></p>&mdash; Neppo Telewisteria (@jo7ueb) <a href="https://twitter.com/jo7ueb/status/928220763982721024?ref_src=twsrc%5Etfw">November 8, 2017</a></blockquote>
<script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>

## (4) データベースの初期化
次に `bundle exec rails s` を実行すると、また別のエラーで怒られてしまいました。
<blockquote class="twitter-tweet" data-lang="en"><p lang="ja" dir="ltr">ActiveRecord::PendingMigrationError -<br><br>Migrations are pending. To resolve this issue, run:<br><br>        bin/rake db:migrate RAILS_ENV=development<br><br>はいはいやりますよ</p>&mdash; Neppo Telewisteria (@jo7ueb) <a href="https://twitter.com/jo7ueb/status/928220963988160513?ref_src=twsrc%5Etfw">November 8, 2017</a></blockquote>
<script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>

今度は何を実行すればいいかがエラーメッセージに書いてあったので、素直に実行します。
<blockquote class="twitter-tweet" data-lang="en"><p lang="en" dir="ltr">$ bundle exec rake db:migrate RAILS_ENV=development</p>&mdash; Neppo Telewisteria (@jo7ueb) <a href="https://twitter.com/jo7ueb/status/928221710800711681?ref_src=twsrc%5Etfw">November 8, 2017</a></blockquote>
<script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>

## (5) Finish!!
満を持して `bundle exec rails s` を実行したら、やっと動きました！
喜びが溢れます。
<blockquote class="twitter-tweet" data-lang="en"><p lang="ja" dir="ltr">うおおおおお、radvent 動いたあああ</p>&mdash; Neppo Telewisteria (@jo7ueb) <a href="https://twitter.com/jo7ueb/status/928222349748453376?ref_src=twsrc%5Etfw">November 8, 2017</a></blockquote>
<script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>

----
ruby 初心者には若干ハマリポイントがありましたが、なんとか手元で環境を立ち上げることができました。
次は、暇な時に色々と弄ってみて、コメント表示機能が追加できればいいな、と思います。

では。
