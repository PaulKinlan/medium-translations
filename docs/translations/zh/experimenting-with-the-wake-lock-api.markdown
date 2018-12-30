
# 尝试使用唤醒锁API

在今年的Chrome开发者峰会期间，我们首次公开撰写了我们的能力项目，代号为项目fugu🐡（←项目标签）。该项目的目的是使网络成为开发应用程序的一流平台，并在开放和透明的环境中进行，重点在于开发人员的反馈。

看到社区对我们正在开发的API做出积极响应是令人鼓舞的，而我个人特别兴奋的是*实验性* [Wake Lock API](https://w3c.github.io/wake-lock/) 。它肯定会发生变化，并且正在大力发展，但第一个实现（在功能标志后面）现在可以进行测试了。唤醒锁定可防止设备或操作系统的某些方面进入省电状态，例如，防止系统关闭屏幕。目前，该规范定义了两种类型的唤醒锁:

1. **屏幕唤醒锁**，可防止设备的屏幕关闭，以便用户仍然可以看到屏幕上显示的信息。

1. **系统唤醒锁**，可防止设备的CPU进入待机模式，以便应用程序可以继续运行。

作为所有新的强大API，Wake Lock API也只能在安全的上下文中使用，也就是说，它需要HTTPS。

在撰写本文时，唤醒锁在[chrome://flags/#enable-experimental-web-platform-features](chrome://flags/#enable-experimental-web-platform-features)标志后面实施 - 从Chrome Beta 71开始。您可以通过订阅[https://crbug.com/257511](https://crbug.com/257511)来跟踪整体进度。相应的[Chrome Platform Status page](https://www.chromestatus.com/feature/4636879949398016)包含有关其他浏览器供应商标志的信息。

我的同事[Pete LePage](https://twitter.com/petele)写了[introductory article](https://developers.google.com/web/updates/2018/12/wakelock)关于如何使用API的伟大的（！） [introductory article](https://developers.google.com/web/updates/2018/12/wakelock) ，所以一定要去阅读它。简要回顾一下，WakeLockType类型“screen”的aWakeLock对象可以像这样获得:

    const wakeLock = await navigator.getWakeLock("screen");

请注意，生成的WakeLock对象尚未执行任何操作;为了激活它，您需要创建一个新的WakeLockRequest:

    const request = wakeLock.createRequest();

只是现在WakeLock处于活动状态，并且您的屏幕或系统（取决于WakeLockType）被阻止睡眠...☕您可以从同一个WakeLock对象创建多个WakeLockRequests，但请确保不要丢失对请求的引用，否则，您永远不能调用WakeLockRequest的cancel（）方法，并且WakeLock将保持活动状态，直到用户关闭创建锁的浏览器选项卡。

我一直在尝试两种类型的唤醒锁 - “屏幕”和“系统” - 并创建了两个有趣的演示。

### 演示1:用于###维基百科屏幕保护程序的屏幕唤醒锁定

第一个演示展示了“屏幕”用例，我在这里阻止屏幕睡觉，因为每当在维基百科上编辑文章时，会发布一个会说话的[Wikipedia screensaver](https://tomayac.github.io/wikipedia-screensaver/dist/) 。在支持的系统上，您可以选中“保持屏幕开启”复选框，并永远观看和收听屏幕保护程序（或直到电池让我们分开）。 [relevant code bits](https://github.com/tomayac/wikipedia-screensaver/blob/0c19ce102f7ee519a7adc58b646c0de9d979d665/src/js/main.js#L178-L202)如下所示:

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

！ [Talking Wikipedia Screensaver (Source: [https://tomayac.github.io/wikipedia-screensaver/dist/](https://tomayac.github.io/wikipedia-screensaver/dist/) ）。]（https://cdn-images-1.medium.com/max/2540/1*Botamp1KbNpUzOAoZ5scjA.png）*会说话的维基百科屏幕保护程序（来源: [https://tomayac.github.io/wikipedia-screensaver/dist/](https://tomayac.github.io/wikipedia-screensaver/dist/) ）。*

### 演示2:运行跟踪器的系统唤醒锁定

第二个演示使用“系统”唤醒锁定来保持系统唤醒运行跟踪器类型的应用程序原型，其中的想法是通过在课程中连续存储地理位置跟踪来跟踪一个人的运行。

！ [Woman with a run tracker (Source: [Filip Mroz](https://unsplash.com/@mroz?utm_source=medium&utm_medium=referral)在[Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral) 。]（https://cdn-images-1.medium.com/max/2000/1*4aneWM4_2Jzpp61srqlhmA.jpeg）*带跑步跟踪器的女人（来源: [Filip Mroz](https://unsplash.com/@mroz?utm_source=medium&utm_medium=referral)上的[Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral) ）。*

该演示由两部分组成。第一部分[*Where am I 📍](https://whereami.glitch.me/) *模拟了运行时手机上的实际跟踪器应用程序。第二部分[*There Am I 🗺](https://thereami.glitch.me/) * [*There Am I 🗺](https://thereami.glitch.me/)作控制仪表板，您可以在其中查看系统是否正常工作。例如，您可以在固定的PC上打开它。

！ [*Where Am I 📍* tracker application running on a Pixel 1 (Source: [https://whereami.glitch.me/](https://whereami.glitch.me/) ）。]（https://cdn-images-1.medium.com/max/6048/1*4bSQ0B9ym-WZY1VDIiqHnw.jpeg) **我在哪里跟踪器应用程序在像素1上运行（来源: [https://whereami.glitch.me/](https://whereami.glitch.me/) ） *。

⚠️隐私警告:对于此演示，每个人的位置和他们的用户代理都是公开共享的，如下图所示，因此如果您不想看到， [emulated position](https://developers.google.com/web/tools/chrome-devtools/device-mode/device-input-and-sensors)通过Chrome开发者工具使用[emulated position](https://developers.google.com/web/tools/chrome-devtools/device-mode/device-input-and-sensors) 。为了在不移动时使调试更容易，跟踪器应用程序还向仪表板发送心跳信号，以检查系统唤醒锁是否处于活动状态。

！ [There Am I 🗺 control dashboard running on a Pixelbook (Source: [https://thereami.glitch.me/](https://thereami.glitch.me/) ）。]（https://cdn-images-1.medium.com/max/6048/1*0rApwK_NEk18lnVV66QtlQ.jpeg）*我在Pixelbook上运行控制仪表板（来源: [https://thereami.glitch.me/](https://thereami.glitch.me/) ）。*

当您即将开始跑步（或者，* ahem *，散步）时，您可以点击* Where Am I📍*中的“开始跟踪”按钮，这将创建系统唤醒锁定。然后，您可以关闭屏幕，进行运行，当您回来时，请在* There Am I🗺*控制仪表板上检查您的轨迹。

由于[https://crbug.com/903831](https://crbug.com/903831) ，这取决于您的Chrome版本，这可能不适用于Android，但如果您实际上在WiFi覆盖的区域内携带像Pixelbook这样的Chrome操作系统设备，或者系在手机上，则应该（至少）可能）工作。再次，它确实是早期的......

您可以在GitHub上查看这两个应用程序的代码: [tomayac/wakelock-whereami](https://github.com/tomayac/wakelock-whereami)和[tomayac/wakelock-thereami](https://github.com/tomayac/wakelock-thereami) 。 [relevant code snippet](https://github.com/tomayac/wakelock-whereami/blob/661fce442ada8817165f2f6202fa5b0f2cc39a2f/script.js#L18-L103)嵌入在下面:

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

### 结束思想

在Wake Lock API为业务做好准备之前，需要更多的[spec fine-tuning](https://github.com/w3c/wake-lock/issues) 。关于WakeLock是否应以某种方式暴露其WakeLockRequests（目前尚未公开），目前正在进行一些讨论，还有其他一些问题，例如将屏幕唤醒锁与可选设置耦合以同时请求最大屏幕是否是个好主意用于呈现条形码或QR码等用例的亮度。

在UI方面 - 作为用户 - 它仍然很容易忘记一个活动的（特别是“系统”）唤醒锁，然后对耗尽的电池或甚至秘密位置记录感到惊讶。为了解决这个问题，我认为用户代理可能需要实现某种类型的唤醒锁定指示，并且可能还应该至少需要*用户手势*，甚至可能通过*权限提示*进行门控。

考虑到如此唤醒锁定指示的样子，我们可以从现有的相关情况中获取灵感。在iOS上，某些类型的背景活动通过状态栏中时间的彩色突出显示:

！ [Background activity notifications on iOS (Source: [https://support.apple.com/en-us/HT207354](https://support.apple.com/en-us/HT207354) ）。]（https://cdn-images-1.medium.com/max/2000/1*hhs7eOCTkPb8lK49NhGmcw.png）* iOS上的背景活动通知（来源: [https://support.apple.com/en-us/HT207354](https://support.apple.com/en-us/HT207354) ）。*

在Android上可以找到类似的解决方案，尤其是最新一代的Pixel 3手机已开始为系统级通知保留“缺口”的右侧:

！ [Background activity notifications on Android (Source: [https://arstechnica.com/?post_type=post&p=1385999](https://arstechnica.com/?post_type=post&p=1385999) ）]（https://cdn-images-1.medium.com/max/2000/1*0O_K6QlTQRE98DeIPWX_gA.jpeg）* Android上的背景活动通知（来源: [https://arstechnica.com/?post_type=post&p=1385999](https://arstechnica.com/?post_type=post&p=1385999) ）*

人们可以想象主动唤醒锁的类似功能。更有趣的是，在macOS上， [Caffeine freeware tool](http://lightheadsw.com/caffeine/)实现了类似屏幕唤醒锁的功能，但在操作系统级别。每当它处于活动状态时，macOS菜单栏中会显示一个热气腾腾的咖啡杯......☕️

对于[project fugu 🐡](https://bugs.chromium.org/p/chromium/issues/list?can=2&q=proj-fugu&sort=m&colspec=ID%20Pri%20M%20Stars%20ReleaseBlock%20Component%20Status%20Owner%20Summary%20OS%20Modified) ，这是激动人心的时刻，我很高兴看到像Wake Lock这样的新用例API可以解锁，但也有一些关于风险和危险的[uncomfortably excited](https://plus.google.com/+avinash/posts/h7DEiJXnTiA) 。让我们一起努力切好鱼！

*🙏我要感谢[Pete LePage](https://twitter.com/petele) ， [Jeffrey Yasskin](https://twitter.com/jyasskin) ， [Surma](https://twitter.com/DasSurma)和[Harleen Batra](https://twitter.com/harleenkbatra)对本文的评论以及有助于改进它的有用评论。*
