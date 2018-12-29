
왜 프로그레시브 웹 앱을 빌드해야 # ? Push, but Do not Pushy! - 비디오 기록

(이것은 새로운 YouTube 쇼 &quot;왜 프로그레시브 웹 앱을 만드세요&quot;의 두 번째 에피소드의 글입니다. 시청을 원할 경우 아래에 비디오가 포함되어 있습니다.)

* (또한 아웃 확인 [write-up of the first episode](https://medium.com/dev-channel/why-build-progressive-web-apps-never-lose-a-click-out-video-write-up-74cbbc466afd) 과 [write-up of the third episode](https://medium.com/dev-channel/why-build-progressive-web-apps-if-its-just-a-bookmark-it-s-not-a-pwa-video-write-up-7ccca1c58034) 하거나 시청 [first episode video](https://www.youtube.com/watch?v=4UK_TDTTWnQ) 과 [third episode video](https://youtu.be/kENeCdS3fzU) .) *

웹에서 푸시 알림이 편재하는 성가신 부분이되었습니다. 푸시 알림의 나쁜 평판에 대한 이유는 내 의견으로는 우리가 사람들에게 허락을 얻으려고 노력하는 데 너무 성급하게 반응했기 때문입니다.

<center><iframe width="560" height="315" src="https://www.youtube.com/embed/vRsVx8_94UQ" frameborder="0" allowfullscreen></iframe></center>

Mozilla의 사람들은 [blog post](https://blog.mozilla.org/firefox/no-notifications/) 다음과 같이 표현했습니다.
> “Online, your attention is priceless. That’s why every site in the universe wants permission to send you notifications about new stuff. It can be distracting at best and annoying at worst.”

! [Blog post by Mozilla announcing the option to block push notifications globally.](https://cdn-images-1.medium.com/max/2042/1*Yo8RE2bX86Bvb-YHiyy--w.jpeg) * 전세계에서 푸시 알림을 차단하는 옵션을 발표하는 Mozilla의 블로그 게시물 *

특히 나쁜 습관은 컨텍스트없이 페이지로드시 권한 대화 상자를 팝업하는 것입니다. 많은 트래픽이 발생하는 사이트가이 작업을 포착했습니다. 알림을 푸시하도록 사람들을 구독하려면 [PushManager interface](https://developer.mozilla.org/en-US/docs/Web/API/PushManager) 을 사용합니다. 이제 공평하게 말하면 개발자가 알림의 컨텍스트 또는 예상되는 빈도를 지정할 수 없습니다. 그럼 우리가 어디에서 떠나나요?

    const options = {
      userVisibleOnly: true,
      applicationServerKey: APPLICATION_SERVER_KEY,
      // No way to specify context or frequency ¯\_(ツ)_/¯
    };
    *const subscription = await *reg.pushManager.subscribe(*options*);

먼저, 한 걸음 물러서서 우선 푸시 알림을 원하는 이유를 생각해 봅시다. 올바르게 완료되면 *** 푸시 알림은 실제로 매우 훌륭합니다 ***. 예를 들어, 경매장에서 * 비싼 값을 매겼다면 그 사실을 알려줄 수 있습니다. 그들은 당신의 고향에서 * 혹독한 기상 조건에 대해 경고합니다. 덜 진지한 메모에서는 데이트 사이트 *에 * 일치하는 사람을 알릴 수 있습니다. 또는 관심있는 내용에 대해 가격이 많이 떨어지는 지 여부를 알려줄 수 있습니다. 물론 푸시 알림도 뉴스 사이트에서 새 콘텐츠를 알릴 수 있습니다.

위에서 쓴 것처럼 API 수준에서는 푸시 알림의 컨텍스트에 대해 사용자에게 알릴 방법이 없습니다. options 매개 변수로 할 수있는 일은 통지가 userVisibleOnly 여야하는지 여부를 나타내는 플래그를 설정하고 applicationServerKey를 제공하는 것입니다. 결과적으로 우리는 애플리케이션 개발자로서 우리의 통보 문맥을 스스로 제공해야합니다.

어쩌면 당신은 [🐈 AffiliCats](https://googlechromelabs.github.io/affilicats/) [first episode](https://www.youtube.com/watch?v=4UK_TDTTWnQ) 의 &quot;Progressive Web Apps를 만든 이유&quot;의 [🐈 AffiliCats](https://googlechromelabs.github.io/affilicats/) 샘플 앱을 기억할 것입니다. 고양이를위한 훌륭한 제안을 얻을 수있는 비교 사이트를 시뮬레이션하는 간단한 앱입니다. 이번에는 가격 하락 *** 알림을 받기위한 *** 버튼이 새로 추가되었습니다.

! [🐈 AffiliCats app with price drop alerts (Source: [https://googlechromelabs.github.io/affilicats/](https://googlechromelabs.github.io/affilicats/) ).] (https://cdn-images-1.medium.com/max/2000/1*BKXrEPdrTaSeSGlWpFg-Ug.png) * 가격 하락 경고가있는 AffiliCats 앱 (출처 : [https://googlechromelabs.github.io/affilicats/](https://googlechromelabs.github.io/affilicats/) ). *

* 매우 * 처음으로이 버튼을 누르면 알림 사용 권한 팝업창이 나타나 가격 하락 경고와 관련이 있다는 것을 즉시 알 수 있습니다.

! [Permission prompt after signing up for Price Alerts.](https://cdn-images-1.medium.com/max/2000/1*dUCl2hLZNAzH_6uBnaTPRw.jpeg) * 가격 경고에 가입 한 후 사용 권한 확인. *

권한을 부여하면 응용 프로그램이 더미 알림을 보내도록 구성된 밀어 넣기 알림 끝점에 가입하고 구독 후 몇 초 후에 첫 번째 알림을 받게됩니다.

! [Push notification announcing that prices for cats are going down.](https://cdn-images-1.medium.com/max/2000/1*LXWa0wu8pGX7q_A8e3UyoA.png) * 고양이 가격이 내려 가고 있음을 알리는 푸시 알림 *

그래서 당신은 고양이의 가격이 떨어지고 있다는 것을 알 수 있습니다. 실제로 유용한 푸시 알림 기능이 있습니다. * 문맥 적 *, * 의미있는 *, * 적시 *였습니다. [🐈 AffiliCats](https://googlechromelabs.github.io/affilicats/) 앱은 오픈 소스입니다. 어떻게 구현되는지보고 싶으면 [source code](https://github.com/googlechromelabs/affilicats) 을 확인하십시오. 푸시 알림은 큰 힘이며 위대한 힘은 큰 책임입니다. 이 글에서 한 가지를 기억한다면, 나는 그것이 *** 상황에 달려 있기를 바란다. ***!

다음 에피소드에서 &quot;왜 프로 그레시브 웹 앱을 만드십시오&quot;* 다른 PWA 슈퍼 파워를 살펴 봅니다 : * 홈 화면에 추가 *! 우리가 당신을보고 독서를 기대합니다! 그것을 놓치지 않기 위해서, *** 우리의 [Medium Dev Channel](https://medium.com/dev-channel) , 크롬 개발자 [YouTube channel](https://www.youtube.com/channel/UCnUYZLuoy1rq1aVMwx4aTzw) , Twitter의 [@ChromiumDev](https://twitter.com/ChromiumDev) 에 ***을 구독하십시오. 그리고 원한다면 거의 월드 와이드 인터넷에서 [@tomayac](https://twitter.com/tomayac) 입니다.
