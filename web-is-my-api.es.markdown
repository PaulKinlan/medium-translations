
# La web es mi API

Michael Mahemoff me enseñó mucho sobre las posibilidades de la web. Antes de trabajar con Mike, construí en la web y comprendí los beneficios como la capacidad de conexión y el descubrimiento, pero nunca tuve una idea completa de lo que sería posible.

Una cosa que dijo Mike fue &quot; [the Web is my API](http://softwareas.com/cors-scraping-and-microformats/) &quot;, donde habló sobre la posibilidad de exponer su sitio y sus datos en una página a través de microformatos y otros datos estructurados, y de poder acceder directamente desde otro contexto de otro navegador, utilizando un simple XMLHttpRequest y la API CORS:
> *Anyway, what’s cool about this is you can treat the web as an API. The Web is my API. “Scraping a web page” may sound dirtier than “consuming a web service”, but it’s the cleaner approach in principle. A website sitting in your browser is a perfectly human-readable depiction of a resource your program can get hold of, so it’s an API that’s self-documenting. The best kind of API. But a whole HTML document is a lot to chew on, so we need to make sure it’s structured nicely, and that’s where microformats come in, gloriously defining lightweight standards for declaring info in your web page. There’s another HTML5 tie-in here, because we now have a similar concept in the standard, microdata.*

Fue casi al mismo tiempo que comencé a trabajar en [Web Intents](https://en.wikipedia.org/wiki/Web_Intents) , [Web Intents](https://en.wikipedia.org/wiki/Web_Intents) espíritu era similar: dar a los usuarios acceso a datos y servicios de otro origen, pero era mucho más complejo. Quería habilitar el descubrimiento de servicios y luego interactuar con esas páginas. Y Mike quería mover la web para proporcionar acceso a datos y servicios. Se quedó conmigo. [Even if I did forget the original attribution](https://twitter.com/Paul_Kinlan/status/913000817170534400) .

Hace poco hablé con Nordic JS, donde resalté que no construimos realmente servicios interconectados realmente en la web, y cuando lo hacemos sigue un modelo de interacciones principalmente entre servidores. Ese es un sitio web que se integrará con un servicio de terceros enrutando todas las solicitudes de API a través de su servidor al servicio remoto y administrando todas las complejidades que vienen con eso.

! [] (https://cdn-images-1.medium.com/max/3722/0*Jd47FtqFCJXhbgsl.png)

Funciona, hemos construido toda la web con esto, pero puede ser increíblemente complejo si se consideran los protocolos de autenticación, autorización, transporte y diferentes métodos RPC (REST, GraphQL, etc.). Mike estaba proponiendo algo mucho más elegante, que con los sitios habilitados para CORS y un poco de JavaScript, podemos hablar directamente con el servicio remoto mediante el uso del sitio.

! [] (https://cdn-images-1.medium.com/max/3692/0*KgbwcYLreomSROnt.png)

Ha habido un par de problemas que surgieron en el medio. El problema principal es que a pesar de que CORS es ampliamente compatible con los navegadores, los desarrolladores rara vez lo usan. CORS es una protección que necesitamos en la web, pero es difícil de configurar y depurar, y la &quot;Web como API&quot; no ha sido demasiado presionada.

! [] (https://cdn-images-1.medium.com/max/3722/0*jyMa-EsQmFK91tLS.png)

Nos estamos moviendo a un mundo donde los sitios se generan en el cliente con JS y las sesiones y el estado para el usuario se administran completamente en el cliente.

Todavía necesitamos la capacidad de comunicarnos desde nuestros sitios a un servicio remoto, y aún creo firmemente que necesitamos descentralizar nuestras integraciones con otros sitios y aplicaciones, pero lo primero que debemos hacer es conectar nuestros sitios y aplicaciones en forma conjunta. de distancia eso es más que un simple enlace. Necesitamos que nuestros sitios expongan sus capacidades y funcionalidad directamente a otras ventanas en el sistema de los usuarios.

Cada sitio web debe poder exponer una API que el propietario del sitio tiene control, directamente a otros clientes.

! [] (https://cdn-images-1.medium.com/max/3714/0*JH7n-YAUHjYL5ZT1.png)

La buena noticia es que ya podemos hacerlo, hemos tenido los primitivos en la plataforma durante al menos 7 años (postMessage y MessageChannel), y desde siempre en window.open, pero no utilizamos estas herramientas para interactuar con los sitios. por razones similares por las que no usamos CORS: es difícil y es casi imposible definir una API sana que sea simple y coherente de usar y que no requiera el ingreso de bibliotecas de terceros para cada servicio con el que quieras interactuar .

La plataforma solo le permite comunicarse entre sitios mediante el paso de mensajes, lo que significa que, como propietario de un servicio, si desea crear una API, debe crear una máquina de estado que serialice los mensajes en algún estado, reaccione a ella y luego envíe envíe un mensaje al cliente y luego tendrá que crear una biblioteca que haga eso para el desarrollador que consume su servicio. Es increíblemente complejo y complicado, y creo que es una de las razones principales por las que no hemos visto una mayor adopción de los Trabajadores Web y las API del lado del cliente.

! [] (https://cdn-images-1.medium.com/max/4000/0*HhFsfGhCBJTHe_7k.png)

Tenemos una biblioteca que ayuda: [Comlink](https://github.com/GoogleChromeLabs/comlink) .

Comlink es una pequeña API que abstrae las API de MessageChannel y postMessage en una API que parece que está instanciando clases y funciones remotas en el contexto local. Por ejemplo:

**Sitio web**

    // Set up.
    const worker = w.open('somesite');
    const api = Comlink.proxy(w);
    // Use the API.
    const work = await new api.Test();
    const str = await work.say('Yo!'); 
    console.log(str);

** Trabajador web **

    class Test { 
      say() { 
        return `Hi ${this.x++}, ${msg}`;
      }
    } 
    // Expose the API to anyone who connects. 
    Comlink.expose({Test}, window);

! [] (https://cdn-images-1.medium.com/max/4000/0*-yw_nnvqOxwACgiH.png)

Exponemos una API en el servicio, consumimos la API en el cliente a través de un proxy.

## ¿Hay un mejor ejemplo?

Construí un [site that subscribes to a pubsubhubbub endpoint and when it recieves a ping it sends a JSON message](https://rss-to-web-push.glitch.me/) a un punto final definido por el usuario. No quería administrar la infraestructura de notificación de inserción para esta pequeña aplicación, otro sitio que construí ( [https://webpush.rocks/](https://paul.kinlan.me/the-web-is-my-api/webpush.rocks) ) puede hacer todo eso, solo quiero utilizar la integración con ese servicio

Pero, ¿cómo obtengo la URL de suscripción (la parte de datos que necesito para poder enviar notificaciones) que se guarda en el cliente de webpush.rocks de nuevo en mi sitio?

Cuando inicialmente creé este sitio, todo lo que podía hacer era dejar que el usuario abriera el sitio y luego copiar y pegar la URL entre las páginas. ¿Por qué no solo exponer una API que cualquier sitio podría usar? Eso fue lo que hice.

webpush.rocks define una API llamada PushManager que tiene un solo método en él. Cuando la página se carga, expone esta API a la ventana de la siguiente manera:

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

La API interactúa con la API PushSubscriptionManager en el DOM y devuelve una URL personalizada al sitio de llamada. Lo importante aquí es que, dado que se ejecuta de forma asíncrona, puedo esperar a que el usuario verifique que desean realizar la acción (o no).

De vuelta en el sitio del cliente que realiza la llamada (la aplicación que desea obtener el ID de suscripción). Cuando un usuario hace clic en el enlace, obtenemos una referencia a la ventana que acabamos de abrir y conectamos nuestro proxy Comlink. La API de servicio ahora está expuesta a nuestro cliente y podemos instanciar la API de PushManager como si fuera un servicio local, pero todo está interactuando con el servicio de instancia remota en la otra ventana.

    let endpointWindow = window.open('', 'endpointUrlWindow');
    let pushAPI = Comlink.proxy(endpointWindow); 
    let pm = await new pushAPI.PushManager(); 
    let id = await pm.subscriptionId(); 
    // Update the UI. 
    endpointUrlEl.value = id;

Aquí hay un video muy rápido de lo que está sucediendo. Una interacción muy simple y liviana, abre el servicio y luego obtiene la identificación que necesita.

<center><iframe width="560" height="315" src="https://www.youtube.com/embed/vTYZXx31EHc" frameborder="0" allowfullscreen></iframe></center>

Como proveedor de servicios, he expuesto un conjunto restringido de funciones que solo están disponibles en el cliente a otro sitio y puedo asegurarlas y solicitar el consentimiento del usuario al mismo tiempo antes de devolver los datos al usuario, todo con una utilizar la API.

* La web es la API. *

Con toda razón, no permitimos que los sitios inspeccionen o manipulen el DOM o el estado de otro origen, pero creo que si tiene control sobre los servicios y la funcionalidad de su sitio y cómo los usuarios se involucran con él, puede exponer la información más importante. y servicios a cualquier cliente que quiera usar su servicio de forma segura (usted tiene el control) y le permite:

* Enfócate en aquello en lo que eres bueno.

* Transferencia rápida de datos entre sitios y aplicaciones porque está todo en el cliente.

* IPC incluso cuando está fuera de línea.

* Ejecutar código en el contexto de origen.

## ¿Qué API deberían exponer los sitios?

Esto es algo que me gustaría explorar más. Expuse algunas funciones básicas a un servicio de Notificaciones Push porque esa es la intención del sitio, pero lo importante para mí fue que tenía el control de las partes del DOM que quería devolver a otros desarrolladores.

Me gustaría llegar a un lugar donde cada sitio pueda exponer una API consistente a los usuarios y una forma de descubrir otras funcionalidades y servicios.

Cada propietario del sitio podría exponer la funcionalidad principal a su servicio para que podamos realizar operaciones basadas en CRUD. Podríamos tener interacciones complejas.

Podríamos llegar a una web en la que tengamos servicios similares a Unix que hagan una cosa bien y un usuario los coloque juntos en el cliente.

Cada sitio podría exponer un VDOM de un subconjunto de la página que está definido por el propietario del servicio para que tengamos una forma consistente de extraer datos de movimiento basados ​​en el DOM entre sitios de forma segura.

Podría imaginar que podríamos querer un acceso rápido a todos los objetos basados ​​en schema.org u otros datos estructurados en la página (podrían generarse dinámicamente) como lo hizo Mike en su publicación original.

[Comlink](https://github.com/GoogleChromeLabs/comlink) nos brinda una manera de exponer y consumir servicios de manera rápida y sencilla sobre las primitivas de la plataforma que han existido durante años. Finalmente tenemos muchas de las piezas en su lugar que nos permiten convertir la Web en la API.

* La web es mi API. Hazlo tuyo también. *

* Publicado originalmente en [paul.kinlan.me](https://paul.kinlan.me/the-web-is-my-api/) . *
