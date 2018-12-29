
# 为什么要构建渐进式Web应用程序:推送，但不要过分！ - 视频写作

（这是我的新YouTube节目“为什么要构建渐进式网络应用程序”的第二集的写作。如果您更喜欢观看，则视频嵌入在下方。）

*（另请查看[write-up of the first episode](https://medium.com/dev-channel/why-build-progressive-web-apps-never-lose-a-click-out-video-write-up-74cbbc466afd)和[write-up of the third episode](https://medium.com/dev-channel/why-build-progressive-web-apps-if-its-just-a-bookmark-it-s-not-a-pwa-video-write-up-7ccca1c58034) ，或观看[first episode video](https://www.youtube.com/watch?v=4UK_TDTTWnQ)和[third episode video](https://youtu.be/kENeCdS3fzU) 。）*

让我们面对现实，在网络上，推送通知已经成为一种无所不在的烦恼。在我看来，推送通知声誉不佳的原因是，我们在尝试让人们允许的时候，有点过于“咄咄逼人”。

<center><iframe width="560" height="315" src="https://www.youtube.com/embed/vRsVx8_94UQ" frameborder="0" allowfullscreen></iframe></center>

在Mozilla上的人们在[blog post](https://blog.mozilla.org/firefox/no-notifications/)就像这样[blog post](https://blog.mozilla.org/firefox/no-notifications/) :
> “Online, your attention is priceless. That’s why every site in the universe wants permission to send you notifications about new stuff. It can be distracting at best and annoying at worst.”

！ [Blog post by Mozilla announcing the option to block push notifications globally.](https://cdn-images-1.medium.com/max/2042/1*Yo8RE2bX86Bvb-YHiyy--w.jpeg) * Mozilla的博客文章宣布了阻止全球推送通知的选项。*

一个特别*糟糕的做法*是在页面加载时弹出权限对话框，根本没有任何上下文。已经抓住了几个高流量站点。要订阅人们推送通知，请使用[PushManager interface](https://developer.mozilla.org/en-US/docs/Web/API/PushManager) 。现在公平地说，这不允许开发人员指定上下文或预期的通知频率。那么这又给我们留下了什么？

    const options = {
      userVisibleOnly: true,
      applicationServerKey: APPLICATION_SERVER_KEY,
      // No way to specify context or frequency ¯\_(ツ)_/¯
    };
    *const subscription = await *reg.pushManager.subscribe(*options*);

首先，也许让我们退后一步，集思广益，为什么我们首先想要推送通知。如果做得好，***推送通知实际上非常棒***。例如，如果您在拍卖网站上*出价*，他们可以通知您。他们可以提醒您家乡的恶劣天气*。不太严肃的说明，当你在约会网站上有*匹配时，他们可以通知你。或者他们可以让你知道你感兴趣的东西是否有显着的*价格下降*当然，推送通知也可以*通知你新闻网站上的新内容*。

正如我上面所写，API级别无法告知用户推送通知的上下文。使用options参数可以做的就是设置一个标志，通知是否应该是userVisibleOnly，并提供applicationServerKey。因此，我们作为应用程序开发人员自己为我们的通知提供上下文至关重要。

也许你还记得[🐈 AffiliCats](https://googlechromelabs.github.io/affilicats/)从示例应用程序[first episode](https://www.youtube.com/watch?v=4UK_TDTTWnQ)的“为什么要建立进Web Apps中。”这是一个简单的应用程序，模拟比较网站，在这里你可以为猫享受超值优惠。这次是什么新的***按钮获得价格下降***警报。

！ [🐈 AffiliCats app with price drop alerts (Source: [https://googlechromelabs.github.io/affilicats/](https://googlechromelabs.github.io/affilicats/) ）。]（https://cdn-images-1.medium.com/max/2000/1*BKXrEPdrTaSeSGlWpFg-Ug.png）*🐈具有价格下降警报的AffiliCats应用程序（来源: [https://googlechromelabs.github.io/affilicats/](https://googlechromelabs.github.io/affilicats/) ）。*

当您第一次按*非常*时，会弹出通知权限提示，并立即清楚它与价格下降警报相关。

！ [Permission prompt after signing up for Price Alerts.](https://cdn-images-1.medium.com/max/2000/1*dUCl2hLZNAzH_6uBnaTPRw.jpeg) *注册价格提醒后的许可提示。*

如果您授予权限，应用程序会将您订阅到配置为发送虚拟通知的推送通知端点，并且在订阅后几秒钟后，您应该收到第一个通知。

！ [Push notification announcing that prices for cats are going down.](https://cdn-images-1.medium.com/max/2000/1*LXWa0wu8pGX7q_A8e3UyoA.png) *推送通知，宣布猫的价格正在下降。*

所以你可以看到，猫的价格正在下降，你最好在他们持续时获得一个。我们有它，一个实际有用的推送通知。这是*上下文*，*有意义*，*及时*。 [🐈 AffiliCats](https://googlechromelabs.github.io/affilicats/)应用程序是开源的，如果你想看看它是如何实现的，请查看[source code](https://github.com/googlechromelabs/affilicats) 。推送通知是一种强大的力量，强大的功能带来了巨大的责任。如果你记得这篇文章中的一件事，我希望它的背景很重要***！

在下一集*“为什么要构建渐进式网络应用程序”中，*我们看看另一个PWA超级大国:*添加到主屏幕*！期待阅读我们见到你！为了不错过它，***订阅我们的[Medium Dev Channel](https://medium.com/dev-channel) ，Chrome开发者[YouTube channel](https://www.youtube.com/channel/UCnUYZLuoy1rq1aVMwx4aTzw) ，在Twitter上关注[@ChromiumDev](https://twitter.com/ChromiumDev) - 如果你愿意，我几乎普遍在万维网上使用[@tomayac](https://twitter.com/tomayac) 。
