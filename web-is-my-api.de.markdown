
# Das Web ist meine API

Michael Mahemoff hat mir viel über die Möglichkeiten des Webs beigebracht. Bevor ich mit Mike arbeitete, habe ich im Web aufgebaut und die Vorteile wie Linkbarkeit und Entdeckung verstanden, aber ich hatte nie wirklich ein vollständiges Bild davon, was möglich wäre.

Eine Sache, die Mike sagte, war &quot; [the Web is my API](http://softwareas.com/cors-scraping-and-microformats/) &quot;, wo er über die Möglichkeit sprach, Ihre Site und Ihre Daten auf einer Seite über Mikroformate und andere strukturierte Daten verfügbar zu machen und direkt von einem anderen Browserkontext darauf zugreifen zu können und die CORS-API:
> *Anyway, what’s cool about this is you can treat the web as an API. The Web is my API. “Scraping a web page” may sound dirtier than “consuming a web service”, but it’s the cleaner approach in principle. A website sitting in your browser is a perfectly human-readable depiction of a resource your program can get hold of, so it’s an API that’s self-documenting. The best kind of API. But a whole HTML document is a lot to chew on, so we need to make sure it’s structured nicely, and that’s where microformats come in, gloriously defining lightweight standards for declaring info in your web page. There’s another HTML5 tie-in here, because we now have a similar concept in the standard, microdata.*

Es war ungefähr zur gleichen Zeit, als ich anfing, an [Web Intents](https://en.wikipedia.org/wiki/Web_Intents) zu arbeiten, dessen Geist ähnlich war - den Benutzern Zugriff auf Daten und Dienste anderer Herkunft geben - aber es war viel komplexer. Ich wollte die Erkennung von Diensten ermöglichen und dann mit diesen Seiten interagieren. Und Mike wollte das Internet nutzen, um Zugang zu Daten und Diensten zu erhalten. Es blieb bei mir. [Even if I did forget the original attribution](https://twitter.com/Paul_Kinlan/status/913000817170534400) .

Vor kurzem habe ich für Nordic JS einen Vortrag gehalten, in dem ich hervorgehoben habe, dass wir nicht wirklich wirklich miteinander verknüpfte Dienste im Web bauen. Dies bedeutet, dass eine Website in einen Drittanbieter-Service integriert werden kann, indem alle API-Anforderungen über ihren Server an den Remote-Service weitergeleitet werden und alle damit verbundenen Komplexitäten verwaltet werden.

! [] (https://cdn-images-1.medium.com/max/3722/0*Jd47FtqFCJXhbgsl.png)

Es funktioniert, wir haben das gesamte Web damit erstellt, aber es kann unglaublich komplex sein, wenn Sie Authentifizierung, Autorisierung, Transportprotokolle und verschiedene RPC-Methoden (REST, GraphQL usw.) in Betracht ziehen. Mike schlug etwas viel eleganteres vor: Mit CORS-fähigen Websites und etwas JavaScript können wir über die Site direkt mit dem Remote-Service sprechen.

! [] (https://cdn-images-1.medium.com/max/3692/0*KgbwcYLreomSROnt.png)

Es gab ein paar Probleme, die dazwischen aufgetaucht sind. Das Hauptproblem ist, dass CORS zwar in Browsern weitgehend unterstützt wird, aber von Entwicklern selten verwendet wird. CORS ist ein Schutz, den wir im Web benötigen, aber es ist schwierig einzurichten und zu debuggen, und das &quot;Web als API&quot; wurde nicht wirklich zu sehr in Anspruch genommen.

! [] (https://cdn-images-1.medium.com/max/3722/0*jyMa-EsQmFK91tLS.png)

Wir bewegen uns in eine Welt, in der Sites mit JS im Client generiert werden und Sitzungen und Status für den Benutzer vollständig auf dem Client verwaltet werden.

Wir müssen immer noch die Möglichkeit haben, von unseren Websites zu einem Remote-Service zu kommunizieren, und ich glaube nach wie vor fest daran, dass wir unsere Integrationen mit anderen Websites und Apps dezentralisieren müssen. Als Erstes müssen wir jedoch unsere Websites und Apps miteinander verbinden Das ist mehr als nur ein Link. Wir benötigen unsere Websites, um ihre Fähigkeiten und Funktionen anderen Fenstern des Benutzersystems direkt zur Verfügung zu stellen.

Jede Website sollte in der Lage sein, eine API, über deren Kontrolle der Eigentümer der Website verfügt, direkt anderen Kunden zugänglich zu machen.

! [] (https://cdn-images-1.medium.com/max/3714/0*JH7n-YAUHjYL5ZT1.png)

Die gute Nachricht ist, dass wir dies bereits tun können. Wir haben die Primitive seit mindestens 7 Jahren (postMessage und MessageChannel) auf der Plattform und seit window.open für immer, aber wir verwenden diese Tools nicht, um mit Websites zu interagieren Aus ähnlichen Gründen, warum wir CORS nicht verwenden: Es ist schwierig und es ist fast unmöglich, eine vernünftige API zu definieren, die einfach und konsistent zu verwenden ist und für die nicht jeder Dienst benötigt, mit dem Sie interagieren möchten .

Die Plattform ermöglicht Ihnen nur die Kommunikation zwischen Standorten mithilfe von Messaging Passing. Dies bedeutet, dass Sie als Dienstbesitzer, wenn Sie eine API erstellen möchten, eine Zustandsmaschine erstellen müssen, die Nachrichten in einen bestimmten Zustand serialisiert, darauf reagiert und anschließend eine Nachricht an den Client zurück und Sie müssen eine Bibliothek erstellen, die das für den Entwickler tut, der Ihren Dienst verwendet. Es ist unglaublich komplex und umständlich und ich glaube, es ist einer der Hauptgründe, warum wir keine stärkere Akzeptanz von Web Workers und clientseitigen APIs gesehen haben

! [] (https://cdn-images-1.medium.com/max/4000/0*HhFsfGhCBJTHe_7k.png)

Wir haben eine Bibliothek, die hilft: [Comlink](https://github.com/GoogleChromeLabs/comlink) .

Comlink ist eine kleine API, die die MessageChannel- und postMessage-APIs zu einer API zusammenfasst, die aussieht, als würden Sie im lokalen Kontext entfernte Klassen und Funktionen instantiieren. Zum Beispiel:

**Webseite**

    // Set up.
    const worker = w.open('somesite');
    const api = Comlink.proxy(w);
    // Use the API.
    const work = await new api.Test();
    const str = await work.say('Yo!'); 
    console.log(str);

** Web Worker **

    class Test { 
      say() { 
        return `Hi ${this.x++}, ${msg}`;
      }
    } 
    // Expose the API to anyone who connects. 
    Comlink.expose({Test}, window);

! [] (https://cdn-images-1.medium.com/max/4000/0*-yw_nnvqOxwACgiH.png)

Wir stellen eine API für den Dienst bereit, wir verbrauchen die API im Client über einen Proxy.

## Gibt es ein besseres Beispiel?

Ich habe ein [site that subscribes to a pubsubhubbub endpoint and when it recieves a ping it sends a JSON message](https://rss-to-web-push.glitch.me/) für einen benutzerdefinierten Endpunkt erstellt. Ich wollte die Push-Benachrichtigungsinfrastruktur für diese kleine App nicht verwalten. Eine andere Website, die ich erstellt habe ( [https://webpush.rocks/](https://paul.kinlan.me/the-web-is-my-api/webpush.rocks) ), kann all das tun.

Aber wie bekomme ich die Abonnement-URL (die Daten, die ich zum Versenden von Benachrichtigungen verwenden muss) im Client von webpush.rocks zurück auf meine Website?

Als ich diese Site ursprünglich erstellte, konnten Sie den Benutzer lediglich die Site öffnen lassen und dann die URL kopieren und zwischen den Seiten einfügen. Warum nicht einfach eine API verfügbar machen, die eine Site verwenden könnte? Das ist, was ich tat.

webpush.rocks definiert eine API mit dem Namen PushManager, die über eine einzige Methode auf der abonnement-ID verfügt. Wenn die Seite geladen wird, wird diese API für das Fenster wie folgt verfügbar gemacht:

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

Die API interagiert mit der PushSubscriptionManager-API im DOM und gibt eine benutzerdefinierte URL an die aufrufende Site zurück. Das Wichtigste dabei ist, dass ich, weil es asynchron läuft, warten kann, dass der Benutzer die Aktion ausführen möchte (oder nicht).

Zurück auf der aufrufenden Client-Site (der App, die die Abonnement-ID abrufen möchte). Wenn ein Benutzer auf den Link klickt, erhalten wir einen Verweis auf das Fenster, das wir gerade geöffnet haben, und schließen unseren Comlink-Proxy an. Die Service-API ist jetzt für unseren Client verfügbar, und wir können die PushManager-API wie einen lokalen Service instanziieren, aber sie interagiert im anderen Fenster mit dem Remote-Instanz-Service.

    let endpointWindow = window.open('', 'endpointUrlWindow');
    let pushAPI = Comlink.proxy(endpointWindow); 
    let pm = await new pushAPI.PushManager(); 
    let id = await pm.subscriptionId(); 
    // Update the UI. 
    endpointUrlEl.value = id;

Hier ist ein sehr kurzes Video von dem, was passiert. Es ist eine sehr einfache und leichte Interaktion, es öffnet den Dienst und erhält dann die erforderliche ID.

<center><iframe width="560" height="315" src="https://www.youtube.com/embed/vTYZXx31EHc" frameborder="0" allowfullscreen></iframe></center>

Als Service Provider habe ich eine eingeschränkte Funktionalität, die nur auf dem Client verfügbar ist, für eine andere Site verfügbar gemacht. Ich kann sie absichern und gleichzeitig die Zustimmung des Benutzers anfordern, bevor ich die Daten an den Benutzer zurücksende API verwenden.

* Das Web ist die API. *

Zu Recht lassen wir nicht zu, dass Websites das DOM oder den Status eines anderen Ursprungs untersuchen oder manipulieren. Ich stelle jedoch fest, dass Sie die wichtigsten Informationen verfügbar machen können, wenn Sie die Dienste und Funktionen Ihrer Website und die Art und Weise, wie Benutzer damit interagieren, kontrollieren können und Dienste für jeden Kunden, der Ihren Dienst sicher verwenden möchte (Sie haben die Kontrolle) und es Ihnen ermöglicht:

* Konzentriere dich auf das, was du gut kannst.

* Schnelle Datenübertragung zwischen Sites und Apps, da sich alles im Client befindet

* IPC auch offline.

* Code im Ursprungskontext ausführen

## Welche APIs sollten Websites ## ?

Dies ist etwas, das ich gerne näher erkunden möchte. Ich habe ein paar grundlegende Funktionen für einen Push-Benachrichtigungsdienst bereitgestellt, da dies die Absicht der Website ist, aber das Wichtigste für mich war, dass ich die Kontrolle hatte, welche Teile des DOM ich anderen Entwicklern zurückgeben wollte.

Ich möchte an einen Ort gelangen, an dem jede Site eine konsistente API für Benutzer verfügbar machen und andere Funktionen und Dienste entdecken kann.

Jeder Websitebesitzer könnte seinem Service nur die Kernfunktionalität zur Verfügung stellen, sodass wir CRUD-basierte Vorgänge ausführen können. Wir könnten komplexe Interaktionen haben.

Wir könnten zu einem Web gelangen, in dem wir Unix-ähnliche Dienste haben, die eine Sache gut machen, und ein Benutzer sie auf dem Client zusammenführt.

Jeder Standort könnte ein VDOM einer Teilmenge der Seite verfügbar machen, die vom Service-Besitzer definiert wird, sodass wir auf konsistente Weise Daten auf der Basis des DOM zwischen Standorten sicher verschieben können.

Ich könnte mir vorstellen, dass wir einen schnellen Zugriff auf alle schema.org-basierten Objekte oder andere strukturierte Daten auf der Seite wünschen (sie könnten dynamisch generiert werden), wie Mike es in seinem ursprünglichen Beitrag getan hat.

[Comlink](https://github.com/GoogleChromeLabs/comlink) wir die Möglichkeit, Dienste schnell und einfach auf den Plattformprimitiven, die es seit Jahren gibt, [Comlink](https://github.com/GoogleChromeLabs/comlink) zu machen und zu nutzen. Endlich haben wir eine Menge der Teile, die es uns ermöglichen, das Web zur API zu machen.

* Das Web ist meine API. Machen Sie es auch Ihnen. *

* Ursprünglich bei [paul.kinlan.me](https://paul.kinlan.me/the-web-is-my-api/) . *
