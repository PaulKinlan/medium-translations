
# なぜ進歩的なWebアプリケーションを構築する:プッシュするがプッシュしないで - ビデオ書き込み

（これが私の新しいYouTube番組「Progress Progressive Web Appsを構築する理由」の2回目のエピソードをまとめたものです。ご覧になりたい場合は、ビデオを以下に埋め込みます。）

*（また、チェックアウト[write-up of the first episode](https://medium.com/dev-channel/why-build-progressive-web-apps-never-lose-a-click-out-video-write-up-74cbbc466afd)と[write-up of the third episode](https://medium.com/dev-channel/why-build-progressive-web-apps-if-its-just-a-bookmark-it-s-not-a-pwa-video-write-up-7ccca1c58034) 、または見[first episode video](https://www.youtube.com/watch?v=4UK_TDTTWnQ)と[third episode video](https://youtu.be/kENeCdS3fzU) 。）*

それを直視しましょう、ウェブ上で、プッシュ通知はちょっと遍在する煩わしさになっています。プッシュ通知の評判が悪いのは、私の意見では、私たちが人々にそれらを許可させようとしているのにも、やや*「強引」*だったからです。

<center><iframe width="560" height="315" src="https://www.youtube.com/embed/vRsVx8_94UQ" frameborder="0" allowfullscreen></iframe></center>

Mozillaを[blog post](https://blog.mozilla.org/firefox/no-notifications/)た[blog post](https://blog.mozilla.org/firefox/no-notifications/)は、 [blog post](https://blog.mozilla.org/firefox/no-notifications/)このように[blog post](https://blog.mozilla.org/firefox/no-notifications/) 。
> “Online, your attention is priceless. That’s why every site in the universe wants permission to send you notifications about new stuff. It can be distracting at best and annoying at worst.”

！ [Blog post by Mozilla announcing the option to block push notifications globally.](https://cdn-images-1.medium.com/max/2042/1*Yo8RE2bX86Bvb-YHiyy--w.jpeg) *プッシュ通知をグローバルにブロックするオプションを発表したMozillaによるブログ投稿*

特に*悪い習慣*は、一切のコンテキストなしで、ページロード時に許可ダイアログをポップアップすることです。いくつかのトラフィックの多いサイトがこれをやっているのを捕らえました。通知をプッシュするように人々を購読するには、 [PushManager interface](https://developer.mozilla.org/en-US/docs/Web/API/PushManager)を使用します。今のところ公平であるために、これは開発者が通知のコンテキストまたは予期される頻度を指定することを可能にしません。それではこれはどこに私たちを残しますか？

    const options = {
      userVisibleOnly: true,
      applicationServerKey: APPLICATION_SERVER_KEY,
      // No way to specify context or frequency ¯\_(ツ)_/¯
    };
    *const subscription = await *reg.pushManager.subscribe(*options*);

最初に、一歩前に戻って、なぜプッシュ通知が最初に必要なのかをブレインストーミングしましょう。正しくできれば、***プッシュ通知は実際にはかなり素晴らしいものです***。例えば、あなたがオークションサイトで*アウトビッド*されているかどうか、彼らはあなたに知らせることができます。彼らはあなたの故郷の*厳しい気象条件*についてあなたに警告することができます。それほど深刻ではないが、出会い系サイトで*試合があったときに彼らはあなたに通知することができる*。あるいは、あなたが興味を持っているものに対して大幅な*値下げ*があるかどうかをあなたに知らせることもできます。そしてもちろん、プッシュ通知はニュースサイトで*あなたに新しいコンテンツを知らせる*こともできます。

私が上で書いたように、プッシュ通知のコンテキストについてユーザーに知らせるためのAPIレベルの方法はありません。 optionsパラメーターでできることは、通知をuserVisibleOnlyにするかどうかのフラグを設定し、applicationServerKeyを提供することだけです。結果として、アプリケーション開発者としての私たちが私たち自身の通知のためのコンテキストを提供することが重要です。

「プログレッシブWebアプリを構築する理由」の[first episode](https://www.youtube.com/watch?v=4UK_TDTTWnQ) [🐈 AffiliCats](https://googlechromelabs.github.io/affilicats/)サンプルアプリを覚えているかもしれません。これは、猫のための素晴らしいオファーを得ることができる比較サイトをシミュレートするシンプルなアプリです。今回の新機能は、価格下落***アラートを受け取るための***ボタンです。

！ [🐈 AffiliCats app with price drop alerts (Source: [https://googlechromelabs.github.io/affilicats/](https://googlechromelabs.github.io/affilicats/) 。）]（https://cdn-images-1.medium.com/max/2000/1*BKXrEPdrTaSeSGlWpFg-Ug.png）*🐈価格の低下の警告とAffiliCatsアプリ（出典: [https://googlechromelabs.github.io/affilicats/](https://googlechromelabs.github.io/affilicats/) 。）*

あなたがそれを*非常に*初めて押したとき、通知許可プロンプトがポップアップします、そしてそれが値下げアラートに関連していることはすぐに明らかです。

！ [Permission prompt after signing up for Price Alerts.](https://cdn-images-1.medium.com/max/2000/1*dUCl2hLZNAzH_6uBnaTPRw.jpeg) * Price Alertsにサインアップした後の許可プロンプト。*

許可を与えると、アプリはダミーの通知を送信するように設定されたプッシュ通知エンドポイントにあなたを登録し、登録後数秒後に最初の通知を受け取るはずです。

！ [Push notification announcing that prices for cats are going down.](https://cdn-images-1.medium.com/max/2000/1*LXWa0wu8pGX7q_A8e3UyoA.png) *猫の値段が下がっていることを[Push notification announcing that prices for cats are going down.](https://cdn-images-1.medium.com/max/2000/1*LXWa0wu8pGX7q_A8e3UyoA.png)プッシュ通知。*

それで、あなたは見ることができます、猫のための価格が下落している、あなたは彼らが持続する間、あなたは1を手に入れる。そして私たちはそれを持っています、実際には便利なプッシュ通知です。それは*文脈*、*意味*、*タイムリー*でした。 [🐈 AffiliCats](https://googlechromelabs.github.io/affilicats/)アプリはオープンソースです[source code](https://github.com/googlechromelabs/affilicats)の実装方法を知りたい場合は、 [source code](https://github.com/googlechromelabs/affilicats)チェックしてください。プッシュ通知は大きな力であり、そして大きな力で大きな責任を負います。あなたがこの記事から一つのことを覚えていれば、私はそれが***文脈の問題***であることを願っています！

次のエピソード「なぜプログレッシブWebアプリを構築するのか」では、もう1つのPWAの超強力機能を見てみましょう。お会いできるのを楽しみにしています！それを見逃さないために、***私たちの[Medium Dev Channel](https://medium.com/dev-channel) 、Chrome Developers [YouTube channel](https://www.youtube.com/channel/UCnUYZLuoy1rq1aVMwx4aTzw) 、Twitterで[YouTube channel](https://www.youtube.com/channel/UCnUYZLuoy1rq1aVMwx4aTzw)に従って[@ChromiumDev](https://twitter.com/ChromiumDev) - そして、あなたが好きなら、私はWorld Wide Internetでほぼ普遍的に[@tomayac](https://twitter.com/tomayac)です。
