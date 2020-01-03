# Flutter pokedex

**Descarga la 
[app](https://raw.githubusercontent.com/jalector/flutter_pokedex/master/repo/pokedex.apk)**
## Inspiración para la aplicación
Flutter pokedex es una aplicación de practica. Esta basada en la idea de una pokedex que aparece en la serie de anime Pokémon. Pokemón es una serie de anime de la decada de los 90 en la que aparecen diferentes criaturas que tienen diferentes habilidades, tamaños y tipos. De la cual la enciclopedia en la que se describen la naturaleza, altura, tipo, y peso se le llama pokedex. 

## Contenido
La aplicación puede mostrar siete de las ocho generaciones de pokemón, en las cuales se pueden realizar varias acciones: 

- Ver los pokémon por generación (Kanto, Johto, Hoenn...)
- Ver los pokémon por tipo
- Filtrar dentro de la pantalla de pokedex los pokemons por nombre o tipo

Dentro de la aplicación se puede cambiar el tema de toda la aplicación dentro del menu lateral hasta la parte de abajo. 

## Estrategias para desarrollar la aplicación

En flutter pokedex he tradado de hacerlo lo más limpio posible, usando pattern, para el cambio del uso del tema, para mantener los pokémon que deben ser mostrado se usa un solo stream en toda la app, haciendo uso de bloc pattern. 

Me he apoyado en los widget que es han publicado en Youtube por Flutter que tienen cómo titulo **Flutter Widget on the Week**, además de otras listas de reproducción como **Flutter in focus** que tienen en su canal de [Youtube](https://www.youtube.com/flutterdev).  

La aplicación hace uso de [OrientationBuilder](https://api.flutter.dev/flutter/widgets/OrientationBuilder-class.html), que ayuda a distribuir la información de manera diferente según lo que se necesite.

Hago uso de bibliotecas para varias cosas, como los son para el video: 
- [http](https://pub.dev/packages/http)
- [video_player](https://pub.dev/packages/video_player)
- [flutter_launcher_icons](https://pub.dev/packages/flutter_launcher_icons)
- [rxdart](https://pub.dev/packages/rxdart)
- [provider](https://pub.dev/packages/provider)
- [shared_preferences](https://pub.dev/packages/shared_preferences)


## Screenshots
### Home page
![Home page](repo/image01.png)
![Pokedex page](repo/image02.png)
![Side menu](repo/image03.png)
![Search page](repo/image04.png)
![Pokemon detail page](repo/image05.png)
![Pokemon detail page](repo/image06.png)

### Horizontal view
![Horizontal home page](repo/image07.png)
![Horizontal home page](repo/image08.png)
![Horizontal pokedex page](repo/image09.png)
![Horizontal pokemon detail page](repo/image10.png)
![Horizontal pokemon detail page](repo/image11.png)
![Horizontal pokemon detail page](repo/image12.png)

### Theme changed
![Horizontal Theme changed page](repo/image13.png)
![Horizontal Theme changed page](repo/image14.png)
![Horizontal Theme changed page](repo/image15.png)
![Horizontal Theme changed page](repo/image16.png)
![Horizontal Theme changed page](repo/image17.png)
![Horizontal Theme changed page](repo/image18.png)
![Horizontal Theme changed page](repo/image19.png)

### Seach page
![Horizontal page](repo/image20.png)
![Horizontal page](repo/image21.png)


## Resouces
- [Pokemon Go Hub](https://pokemongohub.net/)
- [Pokemon Fusion](https://pokemon.alexonsager.net/)
- [Flutter](https://flutter.dev/)