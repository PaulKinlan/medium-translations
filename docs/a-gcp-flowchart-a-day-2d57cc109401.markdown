

# A GCP flowchart a day

I believe GCP endeavors to be simple to use but inevitably there will be times when choices will have to be made re what path or product is right for your use case. Thus flowcharts are a thing that comes into it&#x2019;s own when a decision needs to he made.

GCP has produced a number of flowcharts this year (2017) covering a variety of use cases&#x00a0;. Not sure how to manage your encryption keys? which interconnect path&#x00a0;? compute or storage type?&#x00a0;.. well GCP has a flowchart to help. I have a few favourites but they are all well worth looking at.

Here I&#x2019;ve collected a few of my favourite GCP flowcharts for your delectation. ( I know I do like that word &#xd83d;&#xde00; ) Plus I wanted to have one place I could find them&#x00a0;. I&#x2019;ve included a link to the original doc or blog that accompanied each flowchart&#x00a0;. So not dillying or dallying hope you find this collection of flowcharts as handy as I do.

*Attribution: All graphics & flowcharts ( apart from the original authentication flowchart that has now been replaced) cheerfully copied from the Google [Cloud platform](http://cloud.google.com) or [blog site](https://cloudplatform.googleblog.com/)*

## Which compute option ?

GCP has a continuum of compute options which can be graphically depicted as:

![](https://cdn-images-1.medium.com/max/2000/1*iIVxT1UOHL7Q08vEGgf4EA.png)

It may be obvious at either end of the continuum which option you choose but the decision becomes less straight forward in the middle so flowchart to the rescue :

![](https://cdn-images-1.medium.com/max/2000/1*OV12s1M9O3OcEn2cwdtmEA.png)

The compute flowchart with accompanying words can be found [here](https://cloudplatform.googleblog.com/2017/07/choosing-the-right-compute-option-in-GCP-a-decision-tree.html?m=1)

## What Storage type?

Data data data data data! ( Sung to the 60&#x2019;s [Batman theme music](https://www.youtube.com/watch?v=1qP-NglUeZU)) . I struggle to think of any application where data isn&#x2019;t a thing . The myriad ways you can store your data is probably after considering the security controls needed the most important decision you need to make. GCP has your back with a great flowchart and tables ( I love tables too) which can be found [here](https://cloud.google.com/storage-options/)

![](https://cdn-images-1.medium.com/max/2560/1*uAxoEkgJPmD_TUbcObfKeA.png)

## Which Network Tier?

GCP&#x2019;s network even if I say so myself is fantastic but it&#x2019;s recognised that not every use case needs to optimize for performance and cost may be the driver. So welcome to Network tiers.

![](https://cdn-images-1.medium.com/max/2314/1*JnDFATWt5-7DgQusex4BeQ.png)

You can see the funky animated gif for the above image [here](https://2.bp.blogspot.com/-Za3HWtGbQK8/WZ3TuWoVxzI/AAAAAAAAETc/bkqmGj9TBXYGTMO6naL3t_pRh_LIz7XtACK4BGAYYCw/s1600/image2.gif)

![](https://cdn-images-1.medium.com/max/2000/1*T9rgSuECrT8dD_1mAoLmmA.png)

The words that go with the above can be found [here](https://cloudplatform.googleblog.com/2017/08/introducing-Network-Service-Tiers-your-cloud-network-your-way.html)

## How to manage encryption keys

GCP has a continuum of ways for you to manage your encryption keys graphically depicted as

![](https://cdn-images-1.medium.com/max/2000/1*S0jLynxxTVyymSyyAt4V3w.png)

Yes I know that the continuum graphic alone is probably all you need but when the announcement for the KMS service was made they produced a flow chart and I Just had to include it here

![](https://cdn-images-1.medium.com/max/2000/1*LTWOlTPPGXIWSPmJEoBVRQ.png)

The words that go with the above can be found [here ](https://cloudplatform.googleblog.com/2017/01/managing-encryption-keys-in-the-cloud-introducing-Google-Cloud-Key-Management-Service.html?m=1)and a nice table that compliments the flow chart can be found [here ](https://cloud.google.com/security/encryption-at-rest/)at the Encryption at rest landing page . ( Everything you ever wanted to know about Encryption at rest on GCP and more !)

## Which Authentication option ?

I&#x2019;m going to sneak in here a flowchart of my own as GCP doesn&#x2019;t have one for this yet!! ( hint hint!)

Update Dec 2nd 2017:

[Neal Mueller](undefined) responded to my hint about wanting a GCP flowchart for Authentication and it&#x2019;s so much prettier than my version &#xd83d;&#xde0a; see updated flowchart below! Thanks Neal.

So just to make sure we are on the same page authentication identifies who you are ! This flowchart is focused on wether its identity &#x2014; > application ( deployed on GCP) or identity &#x2014; > direct access to GCP

![](https://cdn-images-1.medium.com/max/2336/1*Uw6w0_X8X29jhpfMgW58Sw.png)

and as I haven&#x2019;t written the words to go with this flowchart I&#x2019;ve left you a few links instead:

[Firebase Authentication](https://firebase.google.com/docs/auth/)

[Service Accounts](https://cloud.google.com/iam/docs/service-accounts)

[GAE User authentication options](https://cloud.google.com/appengine/docs/standard/python/oauth/)

[Cloud IoT using JSON Web Tokens](https://cloud.google.com/iot/docs/how-tos/credentials/jwts)

[Cloud Identity](https://support.google.com/a/answer/7319251?hl=en)

Part II has more flowcharts and can be found [here](https://medium.com/@grapesfrog/more-gcp-flowcharts-for-your-delectation-36b63ebb72ce)
