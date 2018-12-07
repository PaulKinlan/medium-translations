
# ウェブは私のAPIです

Michael Mahemoffはウェブの可能性について多くのことを教えてくれました。 Mikeと一緒に作業する前に、私はWeb上に構築しました。リンク可能性や発見などの利点を理解しましたが、可能なことを完全に把握することはできませんでした。

マイク氏が言ったことの1つは、マイクロフォーマットやその他の構造化されたデータを使ってページ内の自分のサイトとデータを公開し、別の別のブラウザコンテキストから直接アクセスできることについて話した &quot; [the Web is my API](http://softwareas.com/cors-scraping-and-microformats/) &quot; [the Web is my API](http://softwareas.com/cors-scraping-and-microformats/)た。単純なXMLHttpRequest CORS API:
> *Anyway, what’s cool about this is you can treat the web as an API. The Web is my API. “Scraping a web page” may sound dirtier than “consuming a web service”, but it’s the cleaner approach in principle. A website sitting in your browser is a perfectly human-readable depiction of a resource your program can get hold of, so it’s an API that’s self-documenting. The best kind of API. But a whole HTML document is a lot to chew on, so we need to make sure it’s structured nicely, and that’s where microformats come in, gloriously defining lightweight standards for declaring info in your web page. There’s another HTML5 tie-in here, because we now have a similar concept in the standard, microdata.*

私は[Web Intents](https://en.wikipedia.org/wiki/Web_Intents)でいたのとほぼ同じ時期[Web Intents](https://en.wikipedia.org/wiki/Web_Intents)の精神は類似していました。ユーザーが別の起源のデータやサービスにアクセスできるようにしましたが、もっと複雑でした。私はサービスの発見を可能にし、その後それらのページとやりとりしたいと思っていました。 MikeはWebをデータとサービスへのアクセスを提供するように動かすことを望んでいました。それは私と一緒にたどり着いた。 [Even if I did forget the original attribution](https://twitter.com/Paul_Kinlan/status/913000817170534400) 。

私は最近、ノルディックJSの話をしました。ここでは、ウェブ上でtruley相互接続されたサービスを実際にビルドしないことを強調しました。つまり、Webサイトは、サーバーを介してリモートサービスにすべてのAPIリクエストをルーティングし、それに伴うすべての複雑さを管理することによって、サードパーティサービスと統合します。

！[]（https://cdn-images-1.medium.com/max/3722/0*Jd47FtqFCJXhbgsl.png）

これは動作しますが、これを使ってウェブ全体を構築していますが、認証、承認、トランスポートプロトコル、RPCメソッド（REST、GraphQLなど）を考慮すると非常に複雑になります。マイク氏は、CORS対応のサイトとJavaScriptを使用して、サイトを使用してリモートサービスと直接話すことができるという、より洗練されたものを提案していました。

！[]（https://cdn-images-1.medium.com/max/3692/0*KgbwcYLreomSROnt.png）

その間にいくつかの問題が発生しました。主な問題は、CORSがブラウザで広くサポートされているにもかかわらず、開発者はそれをめったに使用しないことです。 CORSはウェブ上で必要な保護機能ですが、セットアップとデバッグは難しく、「WebとしてのAPI」はあまりにも多くのことを押し進めていません。

！[]（https://cdn-images-1.medium.com/max/3722/0*jyMa-EsQmFK91tLS.png）

私たちは、JSを使用してクライアントでサイトが生成され、ユーザーのセッションと状態がクライアント上で完全に管理される世界へと移行しています。

私たちはまだサイトからリモートサービスに通信する能力が必要ですが、私は他のサイトやアプリケーションとの統合を分散させる必要があると強く信じていますが、最初に行うことは、サイトとアプリケーションをそれは単なるリンク以上のものです。私たちのサイトでは、機能と機能をユーザーシステムの他のウィンドウに直接公開する必要があります。

すべてのウェブサイトは、サイトの所有者が管理しているAPIを他のクライアントに直接公開することができます。

！[]（https://cdn-images-1.medium.com/max/3714/0*JH7n-YAUHjYL5ZT1.png）

良いニュースは、私たちは既にそれを行うことができます、我々は少なくとも7年間（postMessageとMessageChannel）のプラットフォーム上のプリミティブを持っていて、window.open以来永遠に持っていましたが、これらのツールをサイトと対話するために使用しませんCORSを使用しない同様の理由で、CORSを使用しない理由は簡単です。シンプルで使いやすいAPIを定義することは難しく、相互作用したいサービスごとに巨大なサードパーティのライブラリを必要としません。

プラットフォームでは、メッセージングパッシングを使用してサイト間で通信することができます。つまり、APIを作成する場合はサービス所有者として、メッセージをある状態にシリアル化して反応させ、メッセージをクライアントに返してから、サービスを利用する開発者用のライブラリを作成する必要があります。信じられないほど複雑で畳み込まれている私は、WebワーカーとクライアントサイドAPIの採用が増えていない主な理由の1つです

！[]（https://cdn-images-1.medium.com/max/4000/0*HhFsfGhCBJTHe_7k.png）

[Comlink](https://github.com/GoogleChromeLabs/comlink)役立つ図書館があります。

Comlinkは、ローカルのコンテキストでリモートクラスや関数をインスタンス化しているように見えるAPIにMessageChannel APIとpostMessage APIを抽象化する小さなAPIです。例えば:

**ウェブサイト**

    // Set up.
    const worker = w.open('somesite');
    const api = Comlink.proxy(w);
    // Use the API.
    const work = await new api.Test();
    const str = await work.say('Yo!'); 
    console.log(str);

**ウェブワーカー**

    class Test { 
      say() { 
        return `Hi ${this.x++}, ${msg}`;
      }
    } 
    // Expose the API to anyone who connects. 
    Comlink.expose({Test}, window);

！[]（https://cdn-images-1.medium.com/max/4000/0*-yw_nnvqOxwACgiH.png）

サービスにAPIを公開し、プロキシ経由でクライアントでAPIを使用します。

## 良い例はありますか？

私はユーザー定義のエンドポイントに[site that subscribes to a pubsubhubbub endpoint and when it recieves a ping it sends a JSON message](https://rss-to-web-push.glitch.me/)を構築しました。私はこの小さなアプリケーションのためのプッシュ通知インフラストラクチャを管理したくなかった、私が構築した別のサイト（ [https://webpush.rocks/](https://paul.kinlan.me/the-web-is-my-api/webpush.rocks) ）はすべてそれを行うことができます、私はそのサービスと統合したいです。

しかし、webpush.rocksのクライアントに保持されているサブスクリプションURL（通知を送信するために必要なデータ）を自分のサイトに戻すにはどうすればよいですか？

最初にこのサイトを構築したときに、ユーザーがサイトを開いてページ間にURLをコピー＆ペーストできるようにするだけでした。どのサイトでも使用できるAPIを公開してみませんか？それが私のしたことです。

webpush.rocksは、その上にsubscriptionIdという単一のメソッドを持つPushManagerというAPIを定義します。ページが読み込まれると、次のようにしてこのAPIがウィンドウに表示されます。

    class PushManager {
      constructor() { } 
      async subscriptionId() { 
        //global var ick... 
        let reg = await navigator.serviceWorker.getRegistration();
        let sub = await reg.pushManager.getSubscription();
        if(sub) { 
          return `${location.origin}/send?id=${sub.endpoint}`;
        } 
        else { 
          return ``; 
        }
      } 
    } 

    Comlink.expose({PushManager}, window);

APIはDOMのPushSubscriptionManager APIとやり取りし、呼び出し元のサイトにカスタムURLを返します。ここで重要なことは、非同期に実行されているため、ユーザー検証を待つことができます（または実行しないことです）。

呼び出し元のクライアントサイト（サブスクリプションIDを取得するアプリ）に戻ります。ユーザーがリンクをクリックすると、直前に開いたウィンドウへの参照が取得され、Comlinkプロキシが接続されます。サービスAPIは現在、クライアントに公開されており、ローカルサービスのようにPushManager APIをインスタンス化できますが、すべてが他のウィンドウのリモートインスタンスサービスとやりとりしています。

    let endpointWindow = window.open('', 'endpointUrlWindow');
    let pushAPI = Comlink.proxy(endpointWindow); 
    let pm = await new pushAPI.PushManager(); 
    let id = await pm.subscriptionId(); 
    // Update the UI. 
    endpointUrlEl.value = id;

ここでは、起こっていることの非常に簡単なビデオです。非常にシンプルで軽量なやり取りで、サービスを開き、必要なIDを取得します。

<center><iframe width="560" height="315" src="https://www.youtube.com/embed/vTYZXx31EHc" frameborder="0" allowfullscreen></iframe></center>

サービスプロバイダとして、私はクライアント上でのみ利用可能な制約付きの機能を他のサイトに公開しており、データをユーザーに返す前に、その情報を安全にしてユーザーの同意を求めることができますAPIを使用する。

* WebはAPIです。*

正に、私たちはサイトがDOMや別の起源の状態を検査したり操作したりすることを許可しませんが、サイトのサービスと機能を管理し、ユーザーがどのように関与しているかを制御すれば、 （あなたが管理している）あなたのサービスを安全に使用したいクライアントへのサービスを提供します。

*あなたが上手であることに焦点を当てる。

*サイトとアプリがクライアント内にあるため、データ転送が高速になります。

*オフラインでもIPC。

*原点コンテキストでコードを実行する

## サイトにはどのようなAPIが公開されるべきですか？

これは私がもっと探求したいものです。プッシュ通知サービスには基本的な機能がいくつか公開されていましたが、これはサイトの目的であるため、私にとって重要なのは、DOMのどの部分を他の開発者に還元したいのかということでした。

私は、すべてのサイトが一貫性のあるAPIをユーザーに公開し、他の機能やサービスを発見する方法を模索しています。

各サイトの所有者は、CRUDベースの操作を実行できるように、コア機能だけをサービスに公開することができます。私たちは複雑な相互作用を持つことができました。

一つのことをうまくやっているユーザーのようなサービスをWeb上に置くことができ、ユーザはクライアント上でそれらをまとめてパイプすることができます。

各サイトは、サービス所有者によって定義されたページのサブセットのVDOMを公開することができるため、サイト間のDOMに基づいて移動データを安全に引き出す一貫した方法が得られます。

Mikeが元の投稿のように、schema.orgベースのオブジェクトやページ上の他の構造化データ（動的に生成される可能性があります）にすばやくアクセスしたいと思うかもしれません。

[Comlink](https://github.com/GoogleChromeLabs/comlink)は、長年にわたり存在してきたプラットフォームプリミティブの上にサービスを迅速かつ簡単に公開し、消費する方法を提供します。私たちは最終的に、WebをAPIにするための多くの部分を用意しています。

* Webは私のAPIです。それもあなたのものにしてください。

*原作は[paul.kinlan.me](https://paul.kinlan.me/the-web-is-my-api/)公開されてい[paul.kinlan.me](https://paul.kinlan.me/the-web-is-my-api/) 。*
