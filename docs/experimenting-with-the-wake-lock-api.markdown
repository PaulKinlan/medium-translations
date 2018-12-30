
# Experimenting with the Wake Lock API

During this year’s Chrome Dev Summit, we wrote for the first time publicly about our capabilities project, code-named project fugu 🐡 (← the project label). The purpose of the project is to make the web a first class platform for developing apps, and to do so in an open and transparent environment where the emphasis is on developer feedback.

It’s encouraging to see the community’s positive response to the APIs that we’re working on, and one that I’m personally especially excited about is the *experimental* [Wake Lock API](https://w3c.github.io/wake-lock/). It will definitely still change and is under heavy development, but a first implementation (behind a feature flag) is now ready for testing. A wake lock prevents some aspect of the device or operating system from entering a power-saving state, for example, preventing the system from turning off the screen. Currently, the specification defines two types of wake locks:

1. A **screen wake lock** which prevents a device’s screen from turning off so that the user can still see the information displayed on the screen.

1. A **system wake lock** which prevents a device’s CPU from entering a standby mode so that applications can continue running.

As all new powerful APIs, the Wake Lock API as well is only available in secure contexts, that is, it requires HTTPS.

At the time of writing, wake locks are implemented behind the [chrome://flags/#enable-experimental-web-platform-features](chrome://flags/#enable-experimental-web-platform-features) flag 🚩 starting in Chrome Beta 71. You can track the overall progress by subscribing to [https://crbug.com/257511](https://crbug.com/257511). The corresponding [Chrome Platform Status page](https://www.chromestatus.com/feature/4636879949398016) contains info about other browser vendors’ signs, too.

My colleague [Pete LePage](https://twitter.com/petele) has written a great(!) [introductory article](https://developers.google.com/web/updates/2018/12/wakelock) on how to use the API, so definitely go read it. Just to briefly recap here, aWakeLock object of the WakeLockType type "screen" can be obtained like this:

    const wakeLock = await navigator.getWakeLock("screen");

Note that the resulting WakeLock object does not do anything yet; in order to activate it, you need to create a new WakeLockRequest:

    const request = wakeLock.createRequest();

Only now the WakeLock is active and your screen or system—depending on the WakeLockType—are being prevented from sleeping… ☕ You can create several WakeLockRequests from the same WakeLock object, just be sure not to lose the reference to the request, else, you never can call the WakeLockRequest’s cancel() method and the WakeLock will remain active until the user closes the browser tab the lock was created from.

I have been experimenting with both types of wake locks—"screen" and "system"—and have created two fun demos.

### Demo 1: Screen Wake Lock for a Talking Wikipedia Screensaver

The first demo showcases the "screen" use case, where I prevent the screen from sleeping for a talking [Wikipedia screensaver](https://tomayac.github.io/wikipedia-screensaver/dist/) that announces whenever an article has been edited on Wikipedia. On supported systems, you can check the “Keep screen on” checkbox and watch and listen to the screensaver forever (or till battery do us part). The [relevant code bits](https://github.com/tomayac/wikipedia-screensaver/blob/0c19ce102f7ee519a7adc58b646c0de9d979d665/src/js/main.js#L178-L202) can be seen below:

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

![Talking Wikipedia Screensaver (Source: [https://tomayac.github.io/wikipedia-screensaver/dist/](https://tomayac.github.io/wikipedia-screensaver/dist/)).](https://cdn-images-1.medium.com/max/2540/1*Botamp1KbNpUzOAoZ5scjA.png)*Talking Wikipedia Screensaver (Source: [https://tomayac.github.io/wikipedia-screensaver/dist/](https://tomayac.github.io/wikipedia-screensaver/dist/)).*

### Demo 2: System Wake Lock for a Run Tracker

The second demo uses a "system" wake lock to keep the system awake for a run tracker kind of application prototype where the idea is to keep track of one’s runs by continuously storing the geolocation traces during a course.

![Woman with a run tracker (Source: [Filip Mroz](https://unsplash.com/@mroz?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)).](https://cdn-images-1.medium.com/max/2000/1*4aneWM4_2Jzpp61srqlhmA.jpeg)*Woman with a run tracker (Source: [Filip Mroz](https://unsplash.com/@mroz?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)).*

The demo consists of two parts. The first part [*Where am I 📍](https://whereami.glitch.me/)* simulates the actual tracker application that you would have on your phone while running. The second part [*There Am I 🗺](https://thereami.glitch.me/) *serves simply as a control dashboard where you can see if the system is working. You could, for example, have it open on a stationary PC.

![*Where Am I 📍* tracker application running on a Pixel 1 (Source: [https://whereami.glitch.me/](https://whereami.glitch.me/)).](https://cdn-images-1.medium.com/max/6048/1*4bSQ0B9ym-WZY1VDIiqHnw.jpeg)**Where Am I 📍* tracker application running on a Pixel 1 (Source: [https://whereami.glitch.me/](https://whereami.glitch.me/)).*

⚠️ Privacy warning: for this demo, everyone’s position and their user agent are publicly shared as shown on the photo below, so if you do not want to be seen, use an [emulated position](https://developers.google.com/web/tools/chrome-devtools/device-mode/device-input-and-sensors) via Chrome Developer Tools. To make debugging easier when not moving, the tracker application also sends a heartbeat signal to the dashboard to check if the system wake lock is active.

![There Am I 🗺 control dashboard running on a Pixelbook (Source: [https://thereami.glitch.me/](https://thereami.glitch.me/)).](https://cdn-images-1.medium.com/max/6048/1*0rApwK_NEk18lnVV66QtlQ.jpeg)*There Am I 🗺 control dashboard running on a Pixelbook (Source: [https://thereami.glitch.me/](https://thereami.glitch.me/)).*

When you are about to start a run (or, *ahem*, a walk), you can tap the “Start tracking” button in *Where Am I 📍*, which will create a system wake lock. You can then turn the screen off, go for a run, and when you come back, check your trajectory on the *There Am I 🗺* control dashboard.

Depending on your version of Chrome, due to [https://crbug.com/903831](https://crbug.com/903831), this might not work on Android yet, but if you actually carry a Chrome OS device like a Pixelbook around in a WiFi-covered area or tethered to your phone, it should (or at least might) work. Again, it is early days for sure…

You can check out the code of both applications on GitHub: [tomayac/wakelock-whereami](https://github.com/tomayac/wakelock-whereami) and [tomayac/wakelock-thereami](https://github.com/tomayac/wakelock-thereami). The [relevant code snippet](https://github.com/tomayac/wakelock-whereami/blob/661fce442ada8817165f2f6202fa5b0f2cc39a2f/script.js#L18-L103) is embedded below:

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

### Closing Thoughts

Until the Wake Lock API is ready for business, a little more [spec fine-tuning](https://github.com/w3c/wake-lock/issues) is needed. Some discussion is currently ongoing around whether or not a WakeLock should expose its WakeLockRequests somehow (currently it does not), but also other questions like whether it is a good idea to couple a screen wake lock with an optional setting to also request the maximum screen brightness for use cases like presenting barcodes or QR codes.

On the UI side—as a user—it is still pretty easy to forget about an active (especially "system") wake lock and then be surprised by a drained battery or even secret location logging. To deal with this, user agents in my opinion probably need to implement some sort of wake lock indication and possibly should also at least require a *user gesture* or maybe even be gated through a *permission prompt*.

Thinking of how such a wake lock indication could look like, we can take inspiration from existing related situations. On iOS, certain types of background activity are surfaced through colored highlighting of the time in the status bar:

![Background activity notifications on iOS (Source: [https://support.apple.com/en-us/HT207354](https://support.apple.com/en-us/HT207354)).](https://cdn-images-1.medium.com/max/2000/1*hhs7eOCTkPb8lK49NhGmcw.png)*Background activity notifications on iOS (Source: [https://support.apple.com/en-us/HT207354](https://support.apple.com/en-us/HT207354)).*

A similar solution can be found on Android, where especially the latest generation of Pixel 3 phones have started to reserve the right side of the “notch” for system-level notifications:

![Background activity notifications on Android (Source: [https://arstechnica.com/?post_type=post&p=1385999](https://arstechnica.com/?post_type=post&p=1385999))](https://cdn-images-1.medium.com/max/2000/1*0O_K6QlTQRE98DeIPWX_gA.jpeg)*Background activity notifications on Android (Source: [https://arstechnica.com/?post_type=post&p=1385999](https://arstechnica.com/?post_type=post&p=1385999))*

One could imagine a similar feature for active wake locks. Somewhat more playful, on macOS, the [Caffeine freeware tool](http://lightheadsw.com/caffeine/) implements something like a screen wake lock, but at the operating system level. Whenever it is active, a steaming coffee cup is shown in the macOS Menu Bar… ☕️

It is exciting times for [project fugu 🐡](https://bugs.chromium.org/p/chromium/issues/list?can=2&q=proj-fugu&sort=m&colspec=ID%20Pri%20M%20Stars%20ReleaseBlock%20Component%20Status%20Owner%20Summary%20OS%20Modified) and I am thrilled about the new use cases APIs like Wake Lock can unlock, but also a little [uncomfortably excited](https://plus.google.com/+avinash/posts/h7DEiJXnTiA) about the risks and dangers. Let us work together to slice this fish properly!

*🙏 I would like to thank [Pete LePage](https://twitter.com/petele), [Jeffrey Yasskin](https://twitter.com/jyasskin), [Surma](https://twitter.com/DasSurma), and [Harleen Batra](https://twitter.com/harleenkbatra) for their reviews of this article and their helpful comments that have helped improve it.*
