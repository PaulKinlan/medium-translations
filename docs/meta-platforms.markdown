
# Rise of the meta-platforms and the new &#x2018;web browser&#x2019;

Originally published at paul.kinlan.me.

[The Web is a platform](https://paul.kinlan.me/this-is-the-web-platform/), [not everyone agrees](https://adactio.com/journal/6692).

I go one step further and classify the web as a &#x2018;meta-platform&#x2019; &#x2014; A platform on one or many platforms.

A meta-platform can only be used and consumed by using another platform and in most cases it is not a purely first-class citizen on those platforms: iOS and Android; Windows and Linux. Yes, HTML with CSS and JavaScript have all be used as tools for creating apps that are &#x2018;native&#x2019; and &#x2018;one&#x2019; with the underlying hardware (ChromeOS and FirefoxOS both spring to mind) but fundamentally the way we consume the web is on the back of other platforms.

I have been thinking a lot recently about how meta-platforms operate and how they enable reach and scale that are unavailable just by building for individual platforms, but to get there there are trade-offs and there *is massive competition* that we as Web Developers need to be aware of.

Every single platform **has** to have a good web browser, on Desktop Microsoft [reported that the Browser was the most used application](http://www.slideshare.net/thebeebs/ie9-the-story-so-far/4), on Mobile, the iPhone was sold partly on [being a web surfing device of desktop class](http://www.apple.com/pr/library/2007/01/09Apple-Reinvents-the-Phone-with-iPhone.html). We as web developers have grown up used to this fact and I think a little complacent.

![](https://cdn-images-1.medium.com/max/4000/0*FvsVQjA2damRcXL-.jpg)

Assume there are two billion mobile devices, all with at least one browser. Then it looks like a pretty compelling place to deploy content, news, apps and services&#x2026;

However looking at the other apps, specifically messaging apps, then it becomes a lot more interesting.

![](https://cdn-images-1.medium.com/max/4000/0*FGlLBp5l3pxC_lIy.jpg)

The question is: Why do I classify these as meta-platforms? And why do I think they are important?

Good question. They all have overt or nascent content and app platforms. These platforms allow for discovery and now importantly, hosting.

Looking at Content, it is interesting to look at how this is currently playing out. Many of the platforms on mobile are choosing to host content within their own app experience and this is interesting for many reasons, and in my opinion a direct and compelling threat to the web.

![](https://cdn-images-1.medium.com/max/4000/0*W14h8ePqdRP9YO9d.jpg)

I&#x2019;ve quickly added Apple News in here as well which right now is an unknown quantity in terms of both usage and traffic, but if it takes off, nearly the entirety of the Apple mobile ecosystem will have it available and at that point it is a significant player.

But what do these platforms offer over the web?

* Access to an active and engaged user-base

* Instant loading of content

* Monetization and ads.

* Pervasive availability (offline access).

They all seem to centralize on one core theme and target a failing of the web and web developers.

![](https://cdn-images-1.medium.com/max/4000/0*5EGDH9d8zUm1H0bX.jpg)

Performance is the number one selling point for each of these new content platforms. Each offering services that make it easy to load instantly for the user whilst offloading the technical constraints and work that hosting on the web entails but still offering compelling monetization options.

Try Facebook Instant articles and tell me that the performance doesn&#x2019;t feel better.

We can make sites and apps fast, and it is not crazy hard to do. Granted, it is not easy either. I am not actually sure where the issue is but we see so many sites and apps not caring about the basics of performance.

Performance isn&#x2019;t the only focus of these platforms, many of the messaging apps are also starting to become richer application platforms.

Currently if you look at [Facebook&#x2019;s Messanger App platform](https://developers.facebook.com/products/messenger), it requires an install from the Play Store or App Store to get the integrated (albeit simple &#x2018;Replies&#x2019;) app running. But will it for ever?

I am would happily wager that React is a long-term bet to enable a consistent platform for app delivery through the Facebook platform, and here is why:

1. [Apple](http://adcdownload.apple.com/Documentation/License_Agreements__Apple_Developer_Program/Apple_Developer_Program_Agreement_20150909.pdf) now allow apps to dynamically update their JS so long as it doesn&#x2019;t significantly change the functionality of their apps.

![](https://cdn-images-1.medium.com/max/2356/0*KOxmGOB4wmtKN4Nt.png)

1. React and [React Native](https://facebook.github.io/react-native/) are starting to abstract the structure and rendering of components on platforms away from the developer.

1. [React-CSS](http://reactcss.com/) and [React-Style](https://github.com/js-next/react-style) have started to abstract CSS and styling away from the developer.

That leaves us with JavaScript and an abstract rendering platform that optimizes natively for the device the user is on. Write once, run natively anywhere on Facebook.

If that is not happening already, I would be trying to make it happen.

[WeChat](https://paul.kinlan.me/rise-of-the-meta-platforms/open.weixin.qq.com) is another example of a lot of activity in this area and whilst I find it hard to follow due to language constraints, their API access for China is quite comprehensive.

Yes, a lot of these platforms are nascent but they offer features that we don&#x2019;t yet have available in the browser. Each of these platforms offer different and non-standard API&#x2019;s, tools and capabilities, but they all are very applicable to platform that they run on.

If you look across FB, Kik and others you will see that Identity (obviously) plays a strong role (i.e, understanding who the user is) and Messaging and Social (again, makes total sense) but there are other areas where capabilities are being expanded: Payments is a big potential area ([WeChat in China has this covered](https://open.weixin.qq.com/cgi-bin/showdocument?action=dir_list&t=resource/res_list&verify=1&id=open1419317784&token=&lang=zh_CN)), and Device Access (the host app grants access once to a feature and then all apps in their platform can use it) is starting to get explored.

Admittedly the cost of business development might be high to run your own store, but if you have the active and engaged users and a compelling way to either drive traffic or make money for the developer then it is an enticing opportunity.

![](https://cdn-images-1.medium.com/max/4000/0*_NMyqRGfKe-87UIK.jpg)

No, seriously. Where is the Web?

The web is incredibly lumpy. There are humps and bumps as each browser supports different features and capabilities at different times based on their own internal priorities. This is both a blessing (tremendous reach) and a curse as it we need to (rightly) employ progressive enhancement techniques so that we can cater for every user in the world.

If you are a business and you have to make a choice, it is now not just iOS or Android and maybe Web, but now Facebook (and others), who have a Billion Daily Active Users on their platform across iOS and Android (and desktop) pretty much guaranteeing a steady and consistently stable platform. What is your choice? I don&#x2019;t think it is clear any more.

![](https://cdn-images-1.medium.com/max/4000/0*jACc5tsRHFVVUBpu.jpg)

## What is the web to do?

It&#x2019;s a long-term game.

For hosting plain content I believe there is an open battle now on between &#x201c;platforms&#x201d; (Apple News, Facebook etc) and the Web as we know it. We as web developers need to adapt and adapt quickly if we want to ensure that content is created and consumed on the web.

For apps, this area is nascent at the moment and there are a lot of popular apps that have billions of users that can build compelling integrations that give developers and businesses access to all their engaged users. Time will tell how this plays out, but if the ability to deploy instantly and manage payments comes to Facebook, like WeChat in China I think there is a very real threat to the web as an app platform.

Today, we who deploy on the web need to deeply focus on:

* Performance &#x2014; everything should be instant

* Frictionless engagement &#x2014; take the link and give user value

* Presence on the device &#x2014; make apps feel like apps.

For the future of app platforms, especially around messaging platforms, I am not sure what the future holds.

I have more thoughts that I will share in upcoming posts.
