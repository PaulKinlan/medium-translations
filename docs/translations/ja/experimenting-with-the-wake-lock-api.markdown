
# Wake Lock APIを使った実験

今年のChrome Dev Summitの間に、私たちはケーパビリティプロジェクト、コードネームproject fugu about（←プロジェクトラベル）について初めて公に書いた。このプロジェクトの目的は、Webをアプリ開発の第一級のプラットフォームにすること、そして開発者からのフィードバックが重視されるオープンで透明な環境でそれを実現することです。

私たちが取り組んでいるAPIに対するコミュニティの積極的な反応を見ることは心強いことです。私が個人的に特に興奮しているのは*実験的* [Wake Lock API](https://w3c.github.io/wake-lock/)です。それは間違いなくまだ変わっていて、そして重い開発の下にあります、しかし最初の実装（機能フラグの後ろ）は今テストの準備ができています。ウェイクロックは、デバイスまたはオペレーティングシステムの一部の側面が省電力状態になるのを防ぎます。たとえば、システムが画面をオフにするのを防ぎます。現在、この仕様では2種類のウェイクロックを定義しています。

ユーザーが画面に表示された情報を見ることができるように、デバイスの画面がオフになるのを防ぐ**スクリーンウェイクロック**。

1. **システムウェイクロック**:アプリケーションの実行を継続できるように、デバイスのCPUがスタンバイモードに入るのを防ぎます。

すべての新しい強力なAPIとして、Wake Lock APIも安全なコンテキストでのみ利用可能です。つまり、HTTPSが必要です。

執筆時点では、ロックが背後に実装されているウェイク[chrome://flags/#enable-experimental-web-platform-features](chrome://flags/#enable-experimental-web-platform-features)フラグ🚩クロームベータ版71に開始あなたがに加入することによって、全体の進捗状況を追跡することができます[https://crbug.com/257511](https://crbug.com/257511) 。対応する[Chrome Platform Status page](https://www.chromestatus.com/feature/4636879949398016)は、他のブラウザベンダーの兆候についての情報も含まれています。

私の同僚の[Pete LePage](https://twitter.com/petele)は、APIの使い方について素晴らしい（！） [introductory article](https://developers.google.com/web/updates/2018/12/wakelock)を書いていますので、ぜひ読んでください。ここで簡単に要約すると、WakeLockType型 &quot;screen&quot;のWakeLockオブジェクトは、次のようにして取得できます。

    const wakeLock = await navigator.getWakeLock("screen");

結果のWakeLockオブジェクトはまだ何もしないことに注意してください。有効にするには、新しいWakeLockRequestを作成する必要があります。

    const request = wakeLock.createRequest();

WakeLockがアクティブになり、WakeLockTypeに応じて画面またはシステムがスリープ状態にならないようになります。同じWakeLockオブジェクトから複数のWakeLockRequestを作成できます。要求への参照を失わないようにする必要があります。 WakeLockRequestのcancel（）メソッドを呼び出すことはできません。WakeLockは、ロックが作成されたブラウザタブをユーザーが閉じるまでアクティブなままになります。

私は &quot;screen&quot;と &quot;system&quot;の両方のタイプのウェイクロックを試していて、2つの楽しいデモを作成しました。

### デモ1:話すWikipediaスクリーンセーバーのためのスクリーンウェイ###

最初のデモは &quot;screen&quot;ユースケースを紹介します。そこでは、記事がWikipediaで編集されたときにはいつでもアナウンスする話す[Wikipedia screensaver](https://tomayac.github.io/wikipedia-screensaver/dist/)ために画面がスリープしないようにします。サポートされているシステムでは、[画面を表示し続ける]チェックボックスをオンにして、スクリーンセーバーを永遠に視聴することができます（または、バッテリーが消えるまで）。 [relevant code bits](https://github.com/tomayac/wikipedia-screensaver/blob/0c19ce102f7ee519a7adc58b646c0de9d979d665/src/js/main.js#L178-L202)は以下のようになります。

    if ('getWakeLock' in navigator) {
      let wakeLockObj = null;
      
      navigator.getWakeLock('screen').then((wlObj) => {
        wakeLockObj = wlObj;
        let wakeLockRequest = null;

        const toggleWakeLock = () => {
          if (wakeLockRequest) {
            wakeLockRequest.cancel();
            wakeLockRequest = null;
            return;
          }
          wakeLockRequest = wakeLockObj.createRequest();
        };
        
        wakeLockCheckbox.addEventListener('click', () => {
          toggleWakeLock();
          return console.log(
              `Wake lock is ${
              wakeLockObj.active ? 'active' : 'not active'}`);
        });
      }).catch((err) => {
        return console.error('Could not obtain wake lock', err);
      });
    }

！ [Talking Wikipedia Screensaver (Source: [https://tomayac.github.io/wikipedia-screensaver/dist/](https://tomayac.github.io/wikipedia-screensaver/dist/) ）]（https://cdn-images-1.medium.com/max/2540/1*Botamp1KbNpUzOAoZ5scjA.png）*トーキングウィキペディアのスクリーンセーバー（出典:。 [https://tomayac.github.io/wikipedia-screensaver/dist/](https://tomayac.github.io/wikipedia-screensaver/dist/) 。）*

### デモ2:ラントラッカーのためのシステムウェイ###

2番目のデモでは、「システム」ウェイクロックを使用して、コース追跡中にジオロケーショントレースを継続的に保存することでランを追跡することを目的としたラントラッカータイプのアプリケーションプロトタイプのためにシステムを起動させます。

！ [Woman with a run tracker (Source: [Filip Mroz](https://unsplash.com/@mroz?utm_source=medium&utm_medium=referral)上[Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral) 。）]（https://cdn-images-1.medium.com/max/2000/1*4aneWM4_2Jzpp61srqlhmA.jpeg）*実行トラッカーを持つ女性（出典: [Filip Mroz](https://unsplash.com/@mroz?utm_source=medium&utm_medium=referral)上[Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral) 。）*

デモは2つの部分から構成されています。最初の部分[*Where am I 📍](https://whereami.glitch.me/) *は、実行中にあなたがあなたの携帯電話に持っているであろう実際のトラッカーアプリケーションをシミュレートします。第2部[*There Am I 🗺](https://thereami.glitch.me/) *は、システムが機能しているかどうかを確認できるコントロールダッシュボードとしてのみ機能します。たとえば、据え置きのPCで開くことができます。

！ [*Where Am I 📍* tracker application running on a Pixel 1 (Source: [https://whereami.glitch.me/](https://whereami.glitch.me/) 。）]（https://cdn-images-1.medium.com/max/6048/1*4bSQ0B9ym-WZY1VDIiqHnw.jpeg）**私はどこ📍画素1で実行されている*トラッカーアプリケーション（出典: [https://whereami.glitch.me/](https://whereami.glitch.me/) ） 。*

Privacy️プライバシーに関する警告:このデモでは、下の写真に示すように、全員の立場とそのユーザーエージェントが公に共有されています。そのため、見たくない場合はChrome Developer Toolsで[emulated position](https://developers.google.com/web/tools/chrome-devtools/device-mode/device-input-and-sensors)を使用して[emulated position](https://developers.google.com/web/tools/chrome-devtools/device-mode/device-input-and-sensors) 。移動していないときのデバッグを容易にするために、トラッカーアプリケーションはダッシュボードにハートビート信号も送信して、システムのウェイクロックがアクティブかどうかを確認します。

！ [There Am I 🗺 control dashboard running on a Pixelbook (Source: [https://thereami.glitch.me/](https://thereami.glitch.me/) 。）]（https://cdn-images-1.medium.com/max/6048/1*0rApwK_NEk18lnVV66QtlQ.jpeg）*私はPixelbook（ソース上で実行されているダッシュボードを制御🗺ありアム: [https://thereami.glitch.me/](https://thereami.glitch.me/) 。）*

ランニングを開始しようとしているとき（または* ahem *、散歩中）、* Where Am I📍*の[Start tracking]ボタンをタップすると、システムのウェイクロックが作成されます。その後、画面をオフにしてランニングに行き、戻ってきたら* There Am I🗺*コントロールダッシュボードで軌道を確認します。

Chromeのバージョンによっては、 [https://crbug.com/903831](https://crbug.com/903831)ために、これはまだAndroidでは動作しないかもしれませんが、実際にPixelbookのようなChrome OSデバイスをWiFiでカバーされた場所で持ち運ぶ場合、または携帯につなぐ場合は（少なくとも）働くかもしれない。繰り返しますが、確かに早い日です…

GitHubで両方のアプリケーションのコード、 [tomayac/wakelock-whereami](https://github.com/tomayac/wakelock-whereami)と[tomayac/wakelock-thereami](https://github.com/tomayac/wakelock-thereami)をチェックすることができます。 [relevant code snippet](https://github.com/tomayac/wakelock-whereami/blob/661fce442ada8817165f2f6202fa5b0f2cc39a2f/script.js#L18-L103)は以下に埋め込まれています。

    if ('getWakeLock' in navigator) {
      try {
        wakeLockObj = await navigator.getWakeLock('system');
        wakeLockObj.addEventListener('activechange', () => {
          wakelock.textContent =
              `The ${wakeLockObj.type} wake lock is ${
              wakeLockObj.active ? 'active' : 'not active'}.`;
        });
      }
      catch (err) {
        console.error('Could not obtain wake lock', err);
      }
    }

    const toggleWakeLock = () => {
      if (wakeLockRequest) {
        wakeLockRequest.cancel();
        wakeLockRequest = null;      
        return;
      }
      wakeLockRequest = wakeLockObj.createRequest();
    };
        
    const startTracking = () => {  
      id = navigator.geolocation.watchPosition(success, error, opt);  
    };

    track.addEventListener('click', () => {
      toggleWakeLock();    
      if (id) {
        stopTracking();
      } else {
        startTracking();
      }    
    });

### クロージング思考

Wake Lock APIがビジネスに使用できるようになるまでは、もう少し[spec fine-tuning](https://github.com/w3c/wake-lock/issues)が必要です。 WakeLockが何らかの方法でそのWakeLockRequestを公開すべきかどうか（現在は公開していません）についての議論が現在進行中です。バーコードやQRコードを提示するようなユースケースの明るさ。

ユーザー側としてのUI側では、アクティブな（特に「システム」の）ウェイクロックを忘れることは依然としてかなり簡単で、それからバッテリーの消耗や秘密の場所によるログ記録にさえ驚かれることがあります。これに対処するために、私の意見では、ユーザーエージェントはおそらく何らかのウェイクロック表示を実装する必要があり、またおそらく少なくとも*ユーザージェスチャー*を必要とするか、あるいは*許可プロンプト*を通してゲートされるべきです。

そのようなウェイクロック表示がどのように見えるかを考えると、既存の関連する状況からインスピレーションを得ることができます。 iOSでは、ステータスバーで時間を色分けして強調表示することで、特定の種類のバックグラウンドアクティビティが表示されます。

！ [Background activity notifications on iOS (Source: [https://support.apple.com/en-us/HT207354](https://support.apple.com/en-us/HT207354) ）iOSの]（https://cdn-images-1.medium.com/max/2000/1*hhs7eOCTkPb8lK49NhGmcw.png）*バックグラウンド活性の通知（出典:。 [https://support.apple.com/en-us/HT207354](https://support.apple.com/en-us/HT207354) 。）*

特に最新世代のPixel 3携帯電話がシステムレベルの通知用に「ノッチ」の右側を確保し始めているAndroidでも同様の解決策が見つかります。

！ [Background activity notifications on Android (Source: [https://arstechnica.com/?post_type=post&p=1385999](https://arstechnica.com/?post_type=post&p=1385999) ）]（https://cdn-images-1.medium.com/max/2000/1*0O_K6QlTQRE98DeIPWX_gA.jpeg）* Androidでのバックグラウンドアクティビティの通知（出典: [https://arstechnica.com/?post_type=post&p=1385999](https://arstechnica.com/?post_type=post&p=1385999) ）*

アクティブなウェイクロックのための同様の機能を想像することができます。もう少し遊びがある、macOS上では、 [Caffeine freeware tool](http://lightheadsw.com/caffeine/)はスクリーン[Caffeine freeware tool](http://lightheadsw.com/caffeine/)ようなものを実装していますが、オペレーティングシステムレベルでです。アクティブになっているときはいつでも、蒸しているコーヒーカップがmacOSメニューバーに表示されます…☕️

[project fugu 🐡](https://bugs.chromium.org/p/chromium/issues/list?can=2&q=proj-fugu&sort=m&colspec=ID%20Pri%20M%20Stars%20ReleaseBlock%20Component%20Status%20Owner%20Summary%20OS%20Modified)にとっては刺激的な時期で[project fugu 🐡](https://bugs.chromium.org/p/chromium/issues/list?can=2&q=proj-fugu&sort=m&colspec=ID%20Pri%20M%20Stars%20ReleaseBlock%20Component%20Status%20Owner%20Summary%20OS%20Modified) 、Wake Lockのような新しいAPIがロック解除できるというユースケースについてはワクワクしていますが、リスクと危険性については少し[uncomfortably excited](https://plus.google.com/+avinash/posts/h7DEiJXnTiA)も[uncomfortably excited](https://plus.google.com/+avinash/posts/h7DEiJXnTiA)ています。この魚を適切にスライスするために一緒に働きましょう！

*この記事のレビューと改善に役立った役に立つコメントについて、 [Pete LePage](https://twitter.com/petele) 、 [Jeffrey Yasskin](https://twitter.com/jyasskin) 、 [Surma](https://twitter.com/DasSurma) 、および[Harleen Batra](https://twitter.com/harleenkbatra)に感謝します。*
