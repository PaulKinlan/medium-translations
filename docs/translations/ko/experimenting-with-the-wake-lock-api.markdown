
# Wake Lock API 실험

올해 Chrome Dev Summit에서 우리는 기능 프로젝트 인 코드 명 프로젝트 fugu 🐡 (← the project label)에 대해 공개적으로 공개했습니다. 이 프로젝트의 목적은 개발자 피드백에 중점을 둔 개방적이고 투명한 환경에서 웹을 앱 개발을위한 첫 번째 플랫폼으로 만들고 그렇게하는 것입니다.

우리가 작업하고있는 API에 대한 커뮤니티의 긍정적 인 반응을 볼 수있어서 고무적이며 개인적으로 특히 흥분한 것은 실험적인 [Wake Lock API](https://w3c.github.io/wake-lock/) 입니다. 그것은 확실히 변하고 무겁게 개발되고 있지만 첫 번째 구현 (기능 플래그 뒤에)은 이제 테스트 할 준비가되었습니다. 웨이크 잠금 장치는 장치 또는 운영 체제의 일부 측면이 절전 상태가되는 것을 방지합니다 (예 : 시스템이 화면을 끌 수 없도록 방지). 현재 사양에서는 두 가지 유형의 대기 모드 잠금을 정의합니다.

1. ** 화면 깨우기 잠금 **은 사용자가 화면에 표시된 정보를 계속 볼 수 있도록 장치의 화면이 꺼지는 것을 방지합니다.

1. 시스템의 CPU가 대기 모드로 들어가서 응용 프로그램을 계속 실행할 수 없게하는 ** 시스템 가동 후 잠금 **.

새로운 강력한 API 인 Wake Lock API는 보안 컨텍스트에서만 사용할 수 있습니다. 즉, HTTPS가 필요합니다.

작성 시점에 [chrome://flags/#enable-experimental-web-platform-features](chrome://flags/#enable-experimental-web-platform-features) 플래그 뒤에 크롬 북 베타 71부터 깨우기 잠금이 구현됩니다. [https://crbug.com/257511](https://crbug.com/257511) 에 가입하면 전반적인 진행 상황을 추적 할 수 있습니다. 해당 [Chrome Platform Status page](https://www.chromestatus.com/feature/4636879949398016) 에는 다른 브라우저 공급 업체의 표지판에 대한 정보도 들어 있습니다.

동료 [Pete LePage](https://twitter.com/petele) 은 API 사용 방법에 대해 (!) [introductory article](https://developers.google.com/web/updates/2018/12/wakelock) 을 작성 했으므로 꼭 읽으십시오. 여기서 간략하게 간단하게 요약하면 WakeLockType 유형 &quot;screen&quot;의 aWakeLock 객체는 다음과 같이 얻을 수 있습니다.

    const wakeLock = await navigator.getWakeLock("screen");

결과 WakeLock 객체는 아직 아무 것도하지 않습니다. 그것을 활성화하기 위해서는 새로운 WakeLockRequest를 생성해야합니다 :

    const request = wakeLock.createRequest();

지금 WakeLock이 활성화되어 있고 WakeLockType에 따라 화면이나 시스템이 잠자기 상태가되는 ... ☕ 같은 WakeLock 객체에서 여러 개의 WakeLockRequest를 만들 수 있습니다. 요청에 대한 참조를 잃지 않도록하십시오. WakeLockRequest의 cancel () 메소드를 호출 할 수 없으며 사용자가 잠금이 생성 된 브라우저 탭을 닫을 때까지 WakeLock은 활성 상태를 유지합니다.

두 가지 유형의 웨이크 잠금 장치 ( &quot;화면&quot;및 &quot;시스템&quot;)를 실험 해본 결과 두 가지 재미있는 데모가 만들어졌습니다.

### 데모 1 : 말하기 Wikipedia 스크린 세이버에 대한 화면 깨우기 잠금

첫 번째 데모는 Wikipedia에서 기사가 편집 될 때마다 발표하는 [Wikipedia screensaver](https://tomayac.github.io/wikipedia-screensaver/dist/) 에 대해 잠자는 화면을 방지하는 &quot;화면&quot;유스 케이스를 보여줍니다. 지원되는 시스템에서는 &quot;화면을 켜기&quot;확인란을 선택하고 스크린 세이버를 영원히보고 (또는 배터리가 우리가 할 때까지)들을 수 있습니다. [relevant code bits](https://github.com/tomayac/wikipedia-screensaver/blob/0c19ce102f7ee519a7adc58b646c0de9d979d665/src/js/main.js#L178-L202) 은 다음과 같습니다.

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

! [Talking Wikipedia Screensaver (Source: [https://tomayac.github.io/wikipedia-screensaver/dist/](https://tomayac.github.io/wikipedia-screensaver/dist/) ).] (https://cdn-images-1.medium.com/max/2540/1*Botamp1KbNpUzOAoZ5scjA.png) * Wikipedia 스크린 세이버 이야기 (출처 : [https://tomayac.github.io/wikipedia-screensaver/dist/](https://tomayac.github.io/wikipedia-screensaver/dist/) ). *

### 데모 2 : 실행 추적 프로그램의 시스템 깨우기 잠금

두 번째 데모는 &quot;시스템&quot;웨이크 잠금 장치를 사용하여 코스가 진행되는 동안 지리적 위치 추적을 지속적으로 저장하여 실행 추적을 유지하는 런처 추적 응용 프로그램 프로토 타입에 대해 시스템을 깨운 상태로 유지합니다.

! [Woman with a run tracker (Source: [Filip Mroz](https://unsplash.com/@mroz?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral) ).] (https://cdn-images-1.medium.com/max/2000/1*4aneWM4_2Jzpp61srqlhmA.jpeg) * 실행 추적자가있는 여성 (출처 : [Filip Mroz](https://unsplash.com/@mroz?utm_source=medium&utm_medium=referral) , [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral) ) *

데모는 두 부분으로 구성되어 있습니다. 첫 번째 부분 인 [*Where am I 📍](https://whereami.glitch.me/) *은 실행 중에 휴대 전화에있는 실제 추적기 응용 프로그램을 시뮬레이트합니다. 두 번째 부분 인 [*There Am I 🗺](https://thereami.glitch.me/) *은 단순히 시스템이 작동 하는지를 볼 수있는 제어 대시 보드 역할을합니다. 예를 들어 고정 된 PC에서 열어 볼 수 있습니다.

! [*Where Am I 📍* tracker application running on a Pixel 1 (Source: [https://whereami.glitch.me/](https://whereami.glitch.me/) ).] (https://cdn-images-1.medium.com/max/6048/1*4bSQ0B9ym-WZY1VDIiqHnw.jpeg) ** Pixel 1 (출처 : [https://whereami.glitch.me/](https://whereami.glitch.me/) )에서 실행중인 추적 응용 프로그램은 어디 [https://whereami.glitch.me/](https://whereami.glitch.me/) . *

⚠️ 개인 정보 경고 :이 데모에서는 모든 사용자의 위치와 사용자 에이전트가 아래 사진과 같이 공개적으로 공유되므로 보지 않으려면 Chrome 개발자 도구를 통해 [emulated position](https://developers.google.com/web/tools/chrome-devtools/device-mode/device-input-and-sensors) 을 사용하십시오. 이동하지 않을 때 디버깅을 쉽게하기 위해 트래커 어플리케이션은 하트 비트 신호를 대시 보드로 전송하여 시스템 웨이크 잠금 장치가 활성 상태인지 확인합니다.

! [There Am I 🗺 control dashboard running on a Pixelbook (Source: [https://thereami.glitch.me/](https://thereami.glitch.me/) ).] (https://cdn-images-1.medium.com/max/6048/1*0rApwK_NEk18lnVV66QtlQ.jpeg) * Pixelbook (출처 : [https://thereami.glitch.me/](https://thereami.glitch.me/) )에서 실행중인 제어 대시 보드가 있습니까?

러닝을 시작할 때 (* ahem *, 걷기), * &#39;어디에서 냐&#39;에서 &#39;추적 시작&#39;버튼을 누르면 시스템 잠자기 잠금이 생성됩니다. 그런 다음 화면을 끄고 달리기를 할 수 있습니다. 다시 돌아올 때, 궤도를 확인하십시오.

[https://crbug.com/903831](https://crbug.com/903831) 으로 인해 Chrome 버전에 따라 아직 Android에서는 작동하지 않을 수 있지만 실제로 Wi-Fi로 덮힌 지역이나 휴대 전화에 연결된 Pixelbook과 같은 Chrome OS 기기를 휴대하고 있다면 적어도 아마도) 작동합니다. 다시 말하지만, 그것은 확실히 초기 단계입니다 ...

GitHub : [tomayac/wakelock-whereami](https://github.com/tomayac/wakelock-whereami) 및 [tomayac/wakelock-thereami](https://github.com/tomayac/wakelock-thereami) 에서 두 응용 프로그램의 코드를 확인할 수 있습니다. [relevant code snippet](https://github.com/tomayac/wakelock-whereami/blob/661fce442ada8817165f2f6202fa5b0f2cc39a2f/script.js#L18-L103) 는 아래에 임베디드되어 있습니다.

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

###

Wake Lock API가 비즈니스 준비가 될 때까지 [spec fine-tuning](https://github.com/w3c/wake-lock/issues) 이 조금 더 필요합니다. 현재 WakeLock이 WakeLockRequests를 어떻게 든 드러내는 지 여부에 대한 논의가 진행 중입니다 (현재는 그렇지 않습니다). 또한 화면 깨우기 잠금을 옵션 설정과 결합하여 최대 화면을 요청하는 것이 좋은지와 같은 다른 질문도 진행되고 있습니다 바코드 또는 QR 코드 제시와 같은 사용 사례의 밝기.

UI 측면에서는 사용자로서 활성 (특히 &quot;시스템&quot;) 후류 잠금을 잊어 버린 다음 배수 된 배터리 또는 비밀 위치 로깅에 놀랄 수 있습니다. 이 문제를 해결하기 위해서 사용자 에이전트는 일종의 wake lock 표시를 구현할 필요가있을 것이며 어쩌면 최소한 * 사용자 제스처 *가 필요하거나 어쩌면 * 권한 프롬프트 *를 통해 게이팅되어야 할 수도 있습니다.

그러한 웨이크 잠금 표시가 어떻게 보이는지 생각하면 기존의 관련 상황에서 영감을 얻을 수 있습니다. iOS에서 상태 표시 줄의 시간 강조 표시를 통해 특정 유형의 백그라운드 활동이 표시됩니다.

! [Background activity notifications on iOS (Source: [https://support.apple.com/en-us/HT207354](https://support.apple.com/en-us/HT207354) ).] (https://cdn-images-1.medium.com/max/2000/1*hhs7eOCTkPb8lK49NhGmcw.png) * iOS의 백그라운드 활동 알림 (출처 : [https://support.apple.com/en-us/HT207354](https://support.apple.com/en-us/HT207354) ). *

안드로이드에서도 이와 유사한 솔루션을 찾을 수 있는데, 특히 최신 세대의 Pixel 3 폰이 시스템 레벨 알림을 위해 &quot;노치&quot;의 오른쪽을 예약하기 시작했습니다.

! [Background activity notifications on Android (Source: [https://arstechnica.com/?post_type=post&p=1385999](https://arstechnica.com/?post_type=post&p=1385999) )] (https://cdn-images-1.medium.com/max/2000/1*0O_K6QlTQRE98DeIPWX_gA.jpeg) * Android에서 백그라운드 활동 알림 (출처 : [https://arstechnica.com/?post_type=post&p=1385999](https://arstechnica.com/?post_type=post&p=1385999) ) *

활성 웨이크 로크와 유사한 기능을 상상할 수 있습니다. 약간 더 장난 [Caffeine freeware tool](http://lightheadsw.com/caffeine/) , macOS에서 [Caffeine freeware tool](http://lightheadsw.com/caffeine/) 는 화면 깨우기 잠금과 같은 것을 구현하지만 운영 체제 수준에서 구현됩니다. 그것이 활동적 일 때마다, 김이 나는 커피 잔은 macOS 메뉴 바에 보여집니다 ... ☕️

[project fugu 🐡](https://bugs.chromium.org/p/chromium/issues/list?can=2&q=proj-fugu&sort=m&colspec=ID%20Pri%20M%20Stars%20ReleaseBlock%20Component%20Status%20Owner%20Summary%20OS%20Modified) 대한 흥미 진진한 시간이며 Wake Lock과 같은 새로운 유스 케이스 API에 대해 기쁘게 생각합니다. 또한 위험과 위험에 대해 약간의 [uncomfortably excited](https://plus.google.com/+avinash/posts/h7DEiJXnTiA) 이 있습니다. 이 물고기를 제대로 조각 내기 위해 함께 노력합시다!

* this [Pete LePage](https://twitter.com/petele) , [Jeffrey Yasskin](https://twitter.com/jyasskin) , [Surma](https://twitter.com/DasSurma) 및 [Harleen Batra](https://twitter.com/harleenkbatra) 에 감사의 [Pete LePage](https://twitter.com/petele) 을 전합니다.이 기사에 대한 리뷰와 도움이 된 의견은 도움이되었습니다. *
