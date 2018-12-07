
# Le Web est mon API

Michael Mahemoff m&#39;a beaucoup appris sur les possibilités du Web. Avant de travailler avec Mike, je construisais sur le Web et je comprenais les avantages tels que la liaison et la découverte, mais je n’avais jamais vraiment une idée complète de ce qui serait possible.

Mike a parlé de « [the Web is my API](http://softwareas.com/cors-scraping-and-microformats/) », où il a parlé de la possibilité d&#39;exposer votre site et vos données dans une page via des microformats et d&#39;autres données structurées et de pouvoir y accéder directement depuis un autre contexte de navigateur, à l&#39;aide d&#39;un simple XMLHttpRequest et l&#39;API CORS:
> *Anyway, what’s cool about this is you can treat the web as an API. The Web is my API. “Scraping a web page” may sound dirtier than “consuming a web service”, but it’s the cleaner approach in principle. A website sitting in your browser is a perfectly human-readable depiction of a resource your program can get hold of, so it’s an API that’s self-documenting. The best kind of API. But a whole HTML document is a lot to chew on, so we need to make sure it’s structured nicely, and that’s where microformats come in, gloriously defining lightweight standards for declaring info in your web page. There’s another HTML5 tie-in here, because we now have a similar concept in the standard, microdata.*

C’est à peu près à la même époque que je commençais à travailler sur [Web Intents](https://en.wikipedia.org/wiki/Web_Intents) , dont l’esprit était similaire: donner aux utilisateurs l’accès à des données et à des services d’une autre origine, mais c’était beaucoup plus complexe. Je souhaitais activer la découverte de services, puis interagir avec ces pages. Et Mike souhaitait passer du Web à l’accès aux données et aux services. Ça m&#39;a pris. [Even if I did forget the original attribution](https://twitter.com/Paul_Kinlan/status/913000817170534400) .

J&#39;ai récemment parlé pour Nordic JS. J&#39;ai souligné que nous ne construisions pas vraiment de véritables services interconnectés sur le Web et que, lorsque nous le faisions, nous suivions un modèle d&#39;interactions essentiellement entre serveurs. C’est-à-dire qu’un site Web s’intégrera avec un service tiers en acheminant toutes les demandes d’API par le biais de leur serveur vers le service distant et en gérant toutes les complexités qui s’y accompagnent.

! [] (https://cdn-images-1.medium.com/max/3722/0*Jd47FtqFCJXhbgsl.png)

Cela fonctionne, nous avons tout le Web construit avec cela, mais cela peut être incroyablement complexe si vous considérez authentification, autorisation, protocoles de transport et différentes méthodes RPC (REST, GraphQL, etc.). Mike proposait quelque chose de beaucoup plus élégant: avec les sites activés par CORS et un peu de JavaScript, nous pouvons parler directement au service distant en utilisant le site.

! [] (https://cdn-images-1.medium.com/max/3692/0*KgbwcYLreomSROnt.png)

Il y a eu quelques problèmes qui se sont posés entre les deux. Le problème principal est que, même si CORS est largement pris en charge par les navigateurs, les développeurs l’utilisent rarement. CORS est une protection dont nous avons besoin sur le Web, mais il est difficile à configurer et à déboguer, et le «Web en tant qu’API» n’a pas vraiment été trop poussé.

! [] (https://cdn-images-1.medium.com/max/3722/0*jyMa-EsQmFK91tLS.png)

Nous nous dirigeons vers un monde où les sites sont générés dans le client avec JS et où les sessions et l&#39;état de l&#39;utilisateur sont gérés entièrement sur le client.

Nous devons toujours pouvoir communiquer entre nos sites et un service distant, et je suis toujours convaincu que nous devons décentraliser nos intégrations avec d&#39;autres sites et applications, mais la première chose que nous devons faire est de connecter nos sites et applications ensemble dans loin qui est plus qu&#39;un simple lien. Nous avons besoin que nos sites exposent leurs capacités et fonctionnalités directement aux autres fenêtres du système des utilisateurs.

Chaque site Web doit pouvoir exposer une API que le propriétaire du site contrôle directement aux autres clients.

!] []

La bonne nouvelle est que nous pouvons déjà le faire. Nous avons les primitives sur la plateforme depuis au moins 7 ans (postMessage et MessageChannel) et depuis toujours window.open, mais nous n&#39;utilisons pas ces outils pour interagir avec les sites. pour des raisons similaires, pourquoi nous n’utilisons pas CORS: C’est difficile et il est presque impossible de définir une API simple, cohérente à utiliser et qui ne nécessite pas d’immenses bibliothèques tierces pour chaque service avec lequel vous souhaitez interagir. .

La plateforme ne vous permet de communiquer qu&#39;entre sites utilisant la transmission de messagerie, ce qui signifie qu&#39;en tant que propriétaire de service, si vous souhaitez créer une API, vous devez créer une machine à états qui sérialise les messages dans un état, y message au client et vous devez ensuite créer une bibliothèque qui le fait pour le développeur qui utilise votre service. C&#39;est incroyablement complexe et compliqué, et je pense que c&#39;est l&#39;une des principales raisons pour lesquelles nous n&#39;avons pas vu davantage d&#39;adoption des travailleurs Web et des API côté client.

! [] (https://cdn-images-1.medium.com/max/4000/0*HhFsfGhCBJTHe_7k.png)

Nous avons une bibliothèque qui aide: [Comlink](https://github.com/GoogleChromeLabs/comlink) .

Comlink est une petite API qui résume les API MessageChannel et postMessage en une API qui ressemble à une instanciation de classes et de fonctions distantes dans le contexte local. Par exemple:

**Site Internet**

    // Set up.
    const worker = w.open('somesite');
    const api = Comlink.proxy(w);
    // Use the API.
    const work = await new api.Test();
    const str = await work.say('Yo!'); 
    console.log(str);

** Travailleur Web **

    class Test { 
      say() { 
        return `Hi ${this.x++}, ${msg}`;
      }
    } 
    // Expose the API to anyone who connects. 
    Comlink.expose({Test}, window);

! [] (https://cdn-images-1.medium.com/max/4000/0*-yw_nnvqOxwACgiH.png)

Nous exposons une API sur le service, nous la consommons dans le client via un proxy.

## Y a-t-il un meilleur exemple?

J&#39;ai construit un [site that subscribes to a pubsubhubbub endpoint and when it recieves a ping it sends a JSON message](https://rss-to-web-push.glitch.me/) sur un noeud final défini par l&#39;utilisateur. Je ne voulais pas gérer l&#39;infrastructure de notification push pour cette petite application, un autre site que j&#39;ai construit ( [https://webpush.rocks/](https://paul.kinlan.me/the-web-is-my-api/webpush.rocks) ) peut faire tout cela, je veux juste utiliser une intégration avec ce service

Mais comment puis-je obtenir l&#39;URL d&#39;abonnement (la donnée dont j&#39;ai besoin pour pouvoir envoyer des notifications) conservée dans le client de webpush.rocks sur mon site?

Lorsque j&#39;ai initialement créé ce site, tout ce que vous pouviez faire était de laisser l&#39;utilisateur l&#39;ouvrir, puis de copier et coller l&#39;URL entre les pages. Pourquoi ne pas simplement exposer une API que tout site pourrait utiliser? C&#39;est ce que j&#39;ai fait.

webpush.rocks définit une API appelée PushManager qui possède une seule méthode sur subscriptionId. Lors du chargement de la page, cette API est exposée à la fenêtre comme suit:

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

L&#39;API interagit avec l&#39;API PushSubscriptionManager dans le DOM et renvoie une URL personnalisée au site appelant. La chose importante ici est que, comme il fonctionne de manière asynchrone, je peux attendre que l’utilisateur vérifie qu’il souhaite exécuter l’action (ou non).

Retour sur le site client appelant (l&#39;application qui veut obtenir le subscriptionId). Lorsqu&#39;un utilisateur clique sur le lien, nous obtenons une référence à la fenêtre que nous venons d&#39;ouvrir et y connectons notre proxy Comlink. L&#39;API de service est maintenant exposée à notre client et nous pouvons instancier celle-ci comme s&#39;il s&#39;agissait d&#39;un service local, mais tout cela interagit avec le service d&#39;instance distant dans l&#39;autre fenêtre.

    let endpointWindow = window.open('', 'endpointUrlWindow');
    let pushAPI = Comlink.proxy(endpointWindow); 
    let pm = await new pushAPI.PushManager(); 
    let id = await pm.subscriptionId(); 
    // Update the UI. 
    endpointUrlEl.value = id;

Voici une vidéo très rapide de ce qui se passe. Une interaction très simple et légère, elle ouvre le service et obtient ensuite l&#39;ID dont il a besoin.

<center><iframe width="560" height="315" src="https://www.youtube.com/embed/vTYZXx31EHc" frameborder="0" allowfullscreen></iframe></center>

En tant que fournisseur de services, j&#39;ai exposé à un autre site un ensemble limité de fonctionnalités disponibles uniquement sur le client. Je peux le sécuriser et demander le consentement de l&#39;utilisateur en même temps avant de renvoyer les données à l&#39;utilisateur, le tout avec un simple message. utiliser l&#39;API.

* Le Web est l&#39;API. *

À juste titre, nous ne laissons pas les sites inspecter ou manipuler le DOM ou l’état d’une autre origine, mais j’affirme que si vous avez le contrôle sur les services et les fonctionnalités de votre site et sur la façon dont les utilisateurs y travaillent, vous pouvez exposer les informations les plus importantes et des services à tout client souhaitant utiliser votre service en toute sécurité (vous en avez le contrôle) et cela vous permet de:

* Focus sur ce que vous êtes bon.

* Transfert rapide de données entre sites et applications, car tout est dans le client.

* IPC même hors connexion.

* Exécuter du code dans le contexte d&#39;origine

## Quelle API les sites doivent-ils exposer?

C&#39;est quelque chose que j&#39;aimerais explorer davantage. J&#39;ai exposé certaines fonctionnalités de base à un service de notifications push, car telle était l&#39;intention du site, mais ce qui importait pour moi, c&#39;était de pouvoir contrôler les parties du DOM que je voulais redonner aux autres développeurs.

J&#39;aimerais arriver à un endroit où chaque site peut présenter aux utilisateurs une API cohérente et un moyen de découvrir d&#39;autres fonctionnalités et services.

Chaque propriétaire de site peut exposer uniquement la fonctionnalité principale à son service afin que nous puissions effectuer des opérations CRUD. Nous pourrions avoir des interactions complexes.

Nous pourrions accéder à un site Web sur lequel Unix ressemble à un service qui fait bien les choses et que l’utilisateur connecte au client.

Chaque site peut exposer une VDOM d&#39;un sous-ensemble de la page définie par le propriétaire du service, de manière à ce que nous ayons un moyen cohérent d&#39;extraire des données de déplacement basées sur le DOM entre sites de manière sécurisée.

J&#39;imagine que nous pourrions souhaiter un accès rapide à tous les objets basés sur schema.org ou à d&#39;autres données structurées sur la page (ils pourraient être générés de manière dynamique), comme Mike l&#39;avait fait dans son message d&#39;origine.

[Comlink](https://github.com/GoogleChromeLabs/comlink) nous offre un moyen d&#39;exposer et de consommer des services rapidement et facilement en plus des primitives de plate-forme [Comlink](https://github.com/GoogleChromeLabs/comlink) depuis des années. Nous disposons enfin de nombreux éléments nous permettant de faire du Web l’API.

* Le Web est mon API. Faites-le vôtre aussi. *

* Publié à l&#39;origine à [paul.kinlan.me](https://paul.kinlan.me/the-web-is-my-api/) . *
