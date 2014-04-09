# Pengo Island

## Historia

Pengo Island es un pequeño juego de plataformas creado como proyecto del primer curso de computación 
en la carrera de Ingeniería en la Universidad de Chile.

Creamos este juego (con otros cuatro amigos) como tributo a otro gran juego de nuestras infancias, [Pengo!](http://en.wikipedia.org/wiki/Pengo).

Este juego no pretende ser un video juego profesional. En cambio nos sirvió para aprender los fundamentos de programación estructurada en Pascal y los conceptos básicos de programación de juegos.

## Licencia

El juego está bajo al licencia GPL Versión 3. Una copia de esta se incluye en el archivo license.txt.

## Idea del juego

En este juego tu manejas a Pengo, el simpático pingüino protagonista del juego de igual nombre. Pengo debe rescatar a su amigo Rockford (el protagonista de [BoulderDash](http://en.wikipedia.org/wiki/Boulder_Dash)) que fue raptado por DOH, el jefe final de [Arkanoid](http://en.wikipedia.org/wiki/Arkanoid).

En cada etapa Pengo debe recoger una gema y una llave que le permitirán abrir la puerta que le conduce al próximo nivel. En cada uno de estos niveles deberá enfrentar a focas, hombres de nieve, cangrejos y esquimales. Pengo puede defenderse de sus enemigos disparando bolas de nieve y llegar a otras plataformas saltando.

## Contenido

En ese repositorio están todos los archivos originales escritos en pascal. Además se incluyen los archivos de nivel (archivos .PNG), la música (CANO.64) y los ejecutables.

En la carpeta manual se incluye el informe original que se presento al final del curso para la evaluación. Contiene código HTML escrito en 1994 (una verdadera reliquía) con los gráficos originales del juego y las instrucciónes para jugar.

## Compilación e instalación

El juego requiere ser compilado con Turbopascal 5.0 para DOS. Además requiere de la engine de juegos MAPOCHO creada para efectos del curso. Esta engine viene incluida en los archivos.

No se requiere de instalación. Simplemente se debe ejecutar el archivo PI.BAT desde DOS o desde DosBOX en sistemas Linux.

## Teclado y trucos

El juego usa las flechas de dirección para mover a pengo. Usa la barra espaciadora para lanzar una bola de nieve y la tecla CONTROL para saltar.

- '@' activa el modo _cheat_ (trucos)
- 'o' y 'p' desplazan por la pantalla para ver el nivel sin mover al personaje
- 's' enciende/apaga la música
- '+' avanza de nivel.

## Modificación de los gráficos

El engine original de juegos incluía un editor de sprites y un editor de niveles. Lamentablemente no conservamos una copia de estos y no es posible modificar los graficos ni los niveles a menos que alguien haga ingeniería inversa de los archivos (pull-request bienvenidos).

La idea original del juego incluía más enemigos y obstaculos de los que se aprecian en el juego. Los sprites de estos figuran dentro del archivo de datos y es posible verlos si uno modifica el código original de Pengo Island. Pueden ver por ejemplo al Oso Polar o los Tiburones.

## Autores

- Graficos: Alejandro Vera, Denis Fuenzalida, Felipe de Toro.
- Sonido: Nicolas Loira
- Niveles: Alejandro Vera, Denis Fuenzalida, Felipe de Toro
- Código: Alejandro Vera, Nicolas Loira, Denis Fuenzalida, Felipe de Toro.

## Contacto

- Alejandro Vera: [twitter](https://twitter.com/almejo) [github](https://github.com/almejo)
- Denis Fuenzalida: [twitter](https://twitter.com/dfuenzal) [github](https://github.com/dfuenzalida)

## Agradecimientos

Agradecemos a los profesores de catedra y profesores auxiliares que enseñaron lo necesario para crear este juego, especificamente por el engine de juegos. Agradecimientos especiales a Oscar Mapocho y Kurt Schwarze.
