<a name="top"></a>

<h1 align="center">
  <strong><span>Bootcamp Desarrollo de Apps Móviles</span></strong>
</h1>

---

<p align="center">
  <strong><span style="font-size:20px;">Módulo: Fundamentos iOS 🍏</span></strong>
</p>

---

<p align="center">
  <strong>Autor:</strong> Salva Moreno Sánchez
</p>

<p align="center">
  <a href="https://www.linkedin.com/in/salvador-moreno-sanchez/">
    <img src="https://img.shields.io/badge/LinkedIn-0077B5?style=for-the-badge&logo=linkedin&logoColor=white" alt="LinkedIn">
  </a>
</p>

## Índice
 
* [Herramientas](#herramientas)
* [Práctica: Dragon Ball Heroes App](#practica)
	* [Descripción](#descripcion)
	* [Requisitos](#requisitos)
		* [Obligatorios](#requisitosObligatorios)
		* [Opcionales](#requisitosOpcionales) 
	* [Características adicionales de mejora](#caracteristicas)
	* [Problemas, decisiones y resolución](#problemas)
		* [Realización del diseño de interfaces de forma programática](#problemas1)
		* [División y estructuración del código](#problemas2) 
		* [`UIStackView` y *constraints* por código](#problemas3) 
		* [Actualización del `UITableView` una vez que se llama a la API después de realizar el *login*](#problemas4)

<a name="herramientas"></a>
## Herramientas

<p align="center">

<a href="https://www.apple.com/es/ios/ios-17/">
   <img src="https://img.shields.io/badge/iOS-000000?style=for-the-badge&logo=ios&logoColor=white" alt="iOS">
 </a>
  
 <a href="https://www.swift.org/documentation/">
   <img src="https://img.shields.io/badge/swift-F54A2A?style=for-the-badge&logo=swift&logoColor=white" alt="Swift">
 </a>
  
 <a href="https://developer.apple.com/xcode/">
   <img src="https://img.shields.io/badge/Xcode-007ACC?style=for-the-badge&logo=Xcode&logoColor=white" alt="XCode">
 </a>
  
</p>

<a name="practica"></a>
## Práctica: Dragon Ball Heroes App

![Demo app gif](images/demoApp.gif)

<a name="descripcion"></a>
### Descripción

Como práctica final al módulo de *Fundamentos iOS* del *Bootcamp* en Desarrollo de Apps Móviles, se nos ha propuesto el desarrollo de una **aplicación iOS siguiendo la arquitectura MVC que consuma la *API Rest Dragon Ball* de *KeepCoding*,** con el objetivo de poner a prueba los contenidos impartidos.

<a name="requisitos"></a>
### Requisitos

<a name="requisitosObligatorios"></a>
#### Obligatorios

1. La aplicación será desarrollada siguiendo la **arquitectura MVC**.
2. No usar *storyboards*, preferiblemente `.xibs`.
3. La aplicación contará con las siguientes pantallas:
	1. **Login**, que permita identificar a un usuario.
	2. **Listado de heroes**, que liste todos los heroes. Se podrá escoger entre `UITableViewController` y `UICollectionViewController`.
	3. **Detalle de héroe**, que represente algunas de las propiedades del héroe y que contenga un botón para mostrar el listado de transformaciones.
	4. **Lista de transformaciones del héroe**, que liste todas las transformaciones disponibles para ese héroe.
4. El proyecto debe **incluir *Unit Test* para la capa de modelo**.

<a name="requisitosOpcionales"></a>
#### Opcionales

1. **Mostrar/esconder el botón de transformaciones en el detalle de héroe**. Si el héroe cuenta con transformaciones, el botón será mostrado. Si el héroe no cuenta con transformaciones, debemos esconder el botón.
2. **Detalle de transformación**, que represente algunas de las propiedades de la transformación.

<a name="caracteristicas"></a>
### Características adicionales de mejora

Ya hemos comentado los requisitos, tanto obligatorios como opcionales, para conseguir superar la práctica; sin embargo, he querido ir más allá, ya sea con contenidos dados en el módulo y que no se requieren en la práctica o investigando nuevos recursos de forma autónoma, por lo que mi aplicación posee características adicionales como:

* **Programada al 100% a través de código**, sin usar *storyboards* ni `.xibs`.
* A pesar de no ser diseñador, me gusta poner atención, en la medida de lo posible, al diseño y a la experiencia de usuario:
	* **Consulta de los *guidelines* de Apple** para el tamaño de la tipografía de elementos como los `UITextfield`.
	* **Adición de botón de eliminado de texto** en `UITextField`.
	* **Agregado de animaciones en bordes y cambio de color del fondo cuando se va a introducir texto** en los `UITextfield` (realizado con el *delegate*).
	* **Botones animados** a la hora de pulsar en ellos.
* **Prioridad a la organización del código** en un árbol de directorios que sea intuitivo y en el que cada una de las partes que lo componen sea fácil de identificar. De esta forma, conseguimos que la aplicación mantenga un sentido interno que pueda ayudarnos a entenderla en un futuro o a que podamos facilitar la labor de nuestros compañeros de trabajo una vez que sigan con el proyecto.
* Una vez desarrollado el código y su funcionalidad, se ha atendido a la **refactorización** del mismo. Se han realizado tareas de conversión a **genérico** para reutilizar el `UITableview` ya que se empleaba en dos pantallas de forma idéntica a nivel de interfaz de usuario. A continuación, muestro un ejemplo del `UITableViewDelegate` que aplica un genérico del protocolo que rige el modelo de datos:

```swift
final class ListTableViewDelegate<T: MainHeroData>: NSObject, UITableViewDelegate {
    // ...
}
```

Como comentamos, la generalización desembocó en la aplicación de dos protocolos: uno para el modelo de datos y otro para el `UIViewController` que maneja el `UITableView`.

```swift
protocol MainHeroData: Decodable {
    var id: String { get }
    var name: String { get }
    var description: String { get }
    var photo: URL { get }
}

protocol ListViewControllerProtocol: AnyObject {
    var heroData: [MainHeroData]? { get }
}
```

Y aquí dejo un ejemplo de la potencia que posee el uso de genéricos y protocolos en Swift, en el que se representa el paso de la información del modelo de datos correspondiente a la celda pulsada en el `UITableView` hacia el `UIViewController` gracias al `UITableViewDelegate`.

```swift
final class ListTableViewDelegate<T: MainHeroData>: NSObject, UITableViewDelegate {
    
    // Conexión con ViewController
    weak var viewController: ListViewControllerProtocol?
    
    // Closure/callback de envío de información al ViewController cuando se pulsa una celda
    var cellTapHandler: ((T) -> Void)?
    
    // Método para saber qué celda se está pulsando
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let heroData = viewController?.heroData {
            let model = heroData[indexPath.row]

            if let model = model as? T {
                cellTapHandler?(model)
            }
            
        }
        
        // Deseleccionar la celda
        tableView.deselectRow(at: indexPath, animated: true)

    }
}
```

* **Personalización de las celdas** del `UITableView` con `UITableViewCell`. Por código e intentando simular al detalle el prototipo dado en imágenes a representar, se ha optado hasta por agregar como `UIImageView` un *chevron* desde *SF Symbols*, que posee la funcionalidad de mejorar la experiencia de usuario al alertar de que al pulsar la celda vas a navegar a otra pantalla, para conocer cómo hacer de nuestro código algo más personal para cuando haya que realizar otro tipo de integraciones a nivel diseño ya que, en ese caso, podríamos haberlo realizado agregando la propiedad `accessoryType` a la celda y agregar aquellos elementos que, de forma predeterminada, nos ofrece *UIKit*.
* He empleado **diversos tipos de navegación** a lo largo de la aplicación para mostrar las diversas pantallas en pos de conocer su actuación. En primer lugar, y aunque no pueda parecer lo más nativo y normal en aplicaciones *iOS*, he empleado un `present` del `UINavigationController` como `.fullScreen` en su propiedad `modalPresentationStyle` para que, a la hora de ingresar a la aplicación, la pantalla aparezca desde abajo hacia arriba; así como un cierre de sesión en sentido contrario con un `dismiss`. Por otro lado, para navegar por el *stack* del `UINavigationController` he empleado `pushViewController`.
* Se ha añadido una **alerta** cuando el usuario introduce unas credenciales erróneas en la pantalla de *Login* en pos de mejorar la usabilidad de la aplicación y que el usuario reciba *feedback* del estado del sistema.
* También se han añadido **dos `UIBarButtonItem` en el listado de héroes**: uno que abre *Safari* y enlaza con la *Wikipedia* dedicada a *Dragon Ball* (funcionalidad que nos permite retener al usuario en nuestra *app* ofreciéndole más información); y otro para cerrar sesión, lo cual te hace navegar a la pantalla de *Login*.

<a name="problemas"></a>
### Problemas, decisiones y resolución

<a name="problemas1"></a>
#### Realización del diseño de interfaces de forma programática

Ha sido personal la decisión de realizar la aplicación de forma programática al completo, a pesar de que en este módulo del *Bootcamp* solo se haya impartido el diseño de interfaces a través de *storyboards* o `xibs`. 

Con el objetivo de seguir profundizando en los contenidos, me decidí a investigar sobre el diseño de interfaces con código y sin el uso de una interfaz gráfica, descubriendo que, aunque es un proceso más abstracto y, quizá, más complejo, me sentía más cómodo y, sobre todo, con la confianza de tener el control sobre toda mi aplicación.

Encuentro ventajas como mayor nivel de personalización y ajuste, comprensión más profunda de lo que hace la interfaz con respecto al uso de *storyboards* y `xibs`, y estructuración del código más flexible y mayor capacidad de acomodación a una determinada arquitectura.

Sin embargo, cabría destacar que la curva de aprendizaje es mayor. Sobre todo, por el nivel de abstracción que se necesita y la necesidad de tener asimilados conceptos como el *Autolayout* y las *constraints*, los cuales puedes ser unos obstáculos difíciles de superar en un inicio.

<a name="problemas2"></a>
#### División y estructuración del código

Evitar la acumulación de código en un único `UIViewController` representa una buena práctica. Sin embargo, surgen otros problemas a resolver como, sobre todo, la conexión y transferencia de información entre la `View` y el `Controller` una vez que el usuario ha interaccionado. Todo esto me ha llevado a investigar y documentarme en la actuación de delegados como los de `UITextField` o `UITableView`, así como la captación de las pulsaciones de botones para ejecutar acciones de navegación a través de *closures*, como ya he ejemplificado en el cuarto punto del apartado *[Características adicionales de mejora](#caracteristicas)*.

<a name="problemas3"></a>
#### `UIStackView` y *constraints* por código

Debemos hacer mención especial al *Autolayout* en *UIKit* y, en concreto, a la conformación de las *constraints* de forma programática ya que protagonizaron uno de los momentos bloqueantes en el desarrollo de la aplicación.

Fue al realizar las *constraints* correspondientes a la celda personalizada del `UITableView`. No podía conseguir el resultado que quería: una `UIImageView` a la izquierda y un `UIStackView` a la derecha. Obtenía un contenido que no se ajustaba a la celda, mientras que el compilador no lanzaba ningún error respecto a las *constraints*. ¿Cómo lo he solucionado?

Antes de nada, asegurando la buena ejecución de las *constraints* respecto a la celda. La pelea constante con estas me ha permitido comprenderlas mucho mejor.

Pero el problema estaba en la configuración del `UIStackView` que contiene a la `UIImageView` y a otro `UIStackView`, concretamente en el `aligment`. Marcándolo como `.center`, la celda actuó como se requería ya que, antes, las restricciones estaban entrando en conflicto a causa de la alineación desequilibrada de los elementos dentro del `UIStackView`. Así, en casos como estos en los que la propiedad `axis` la tenemos como `.horizontal` es recomendable partir con el `aligment` a `.center` y luego ir ajustando a las exigencias de la vista.

<a name="problemas4"></a>
#### Actualización del `UITableView` una vez que se llama a la API después de realizar el *login*

Otro problema al que me enfrenté durante el desarrollo de la práctica fue el que no se reflejaran en el `UITableView` los datos recibidos por la API después de hacer *login*. Después de depurar y, según cómo lo había desarrollado, se vio que el `UITableView` se inicializaba antes de recibir los datos de la API, debido a que llamaba a la API y, en el mismo *completion* y de manera asíncrona, presentaba la pantalla con el citado `UITableView`. Esto me llevo a solucionarlo con el uso de `NotificationCenter`, el cual avisaba cuando se recibían los datos de la API al `UIViewController` para, luego, poder actualizar el `UITableView` con los nuevos datos, lo que me llevaba a volver a reestablecer el *DataSource* y el *Delegate*.

Fue una solución de muchas, la cual, además, me permitió llevar a la práctica la suscripción a notificaciones desde un `UIViewController`; sin embargo, podría haber otras como:

* No ejecutar de manera asíncrona la llamada a la API y la presentación de la siguiente pantalla, y realizar el proceso de manera imperativa; por lo que podríamos guardar el *token* como variable del `UIViewController`, luego llamar a la API para obtener los héroes y guardarlos en el siguiente `UIViewcontroller` y, ahora sí, presentar este último. De esta forma, cargaríamos los datos en nuestro `UITableView` sin problema.
* Otra solución, y quizá la más efectiva, sea, una vez presentado el `UIViewController` que alberga el `UITableView`, llamar a la API en el método `cellForRowAt` del `UITableViewDataSource` para configurar directamente cada celda con los datos recibidos de la API.

---

[Subir ⬆️](#top)

---
