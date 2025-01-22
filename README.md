# Desarrollo de la aplicación basada en la blockchain de Ethereum y la guía de CryptoZombies  


## Influencia conceptual

Mencionar que lo proporcionado por esta plataforma pertenece a la version de solidity 0.4.25 la cual es bastante antigua. Por lo que en cuestion de paradigmas de programacion hemos tenido que actualizar muchas cosas a parte de tener que adaptarlas a nuestra aplicacion. Aunque las buenas practicas y las cosas basicas han representado una guia estupenda.

Para definir las bases de nuestra aplicacion de desarrollo Web3 nos hemos basado en los tutoriales de Cryptozombies los caules tienen 5 lecciones de las que hemos sacado lo siguiente:
- Lec 1: Funcionamiento basico de solidity, patron de diseño de la fabrica de pokemons. Aleteoriedad basica.
- Lec 2: Fucnionamiento un poco mas avanzado y interaccion con direcciones de la blockchain, visibilidad de las funciones, Storage vs Memory.
- Lec 3: Conceptos blockchain: inmutabilidad y gas. Incorporacion del contrato Ownable. Funciones con gestion de tiempo.
- Lec 5: Implementacion del ERC 721 que ha servido para tener una intuicion de como incorporar las interfazes de los estandar y las ventajas que estos nos ofrecen. 

## Punto de partida

El usuario, con una dirección en la blockchain, introduce su nombre de entrenador y escoge uno de los tres elementos posibles, obteniendo así uno de los pokémon iniciales basado en el elemento escogido. El poder de este pokémon es aleatorio.

## Aspectos de la implementación en código del punto de partida

Tendremos un array para todos los pokémon que puedan crearse. En el array constarán: el nombre, elemento, velocidad, ataque, defensa, ataque especial y defensa especial. Podrá haber pokémon iguales. El nombre y el elemento del inicial irán definidos por la elección del usuario al inicio, al igual que su poder, que dependerá pseudoaleatoriamente del nickname que haya escogido. Inicialmente, los stats (ataque, defensa, etc.) tendrán un valor numérico del 0 al 9, sacado del valor (poder) mencionado anteriormente.

Para asociar los pokémon a las direcciones de usuario, emplearemos que intrínsecamente cada nuevo elemento (pokémon) tendrá un id correspondiente a la posición que ocupa en el array. Este id irá asociado mediante un mapping a la dirección del usuario. Después, para saber cuántos pokémon tiene un usuario, tendremos otro mapping. También habrá un mapping para asociar la dirección de la blockchain del usuario con su nombre de entrenador.

## Objetivos futuros

- Definir uso del token ERC1155
- Especificar virtudes de desarrollar la aplicacion en la blockchain ethereum en cunato a privacidad y identidad digital.
- Definir el flujo de la aplicación (intentar sacarle provecho a la blockchain): Batallas, niveles, capturas, etc..
- Funciones:
  - Ataques del pokmon (atq. atq-esp. def y def-esp. ) que puede utilizar en el combate.
  - Combates aleatorios(Pokemons creados y destruidos)
  - Combates contra Entrenadores
  - Definir habilidades en funcion del nivel
  - Capturar pokemons

## Token ERC1155
Es nuestra mejor opcion ya que auna las caracteristicas del token ERC20(token fungible) y ERC721(NFT) Entonces es conveniente xq se pueden mintear(acuñar) pokemons unicos, pero que se puden repetir, Ejemplo práctico:
Existen Charizards y Squirtels pues estos son una especie unica pero en la que pude haber varios Charizards y Squirtels.  

## Batallas contra Entrenadores
En cuanto a la lógica de las batallas, entre Pokémon, he pensado en implementar algo parecido a el juego de pistolero donde dos personas se enfrentan y en un momento sincronizados eligen una de las tres opciones siguientes; defenderse, cargar y disparar. Para disparar previamente has de haber cargado en algún turno anterior y si disparas y el otro no se protege le quitas vida. Para implementarlo con los stats que ya tengo de los Pokémon seria;
- la accion de disparar va relacionada con el ataque o el ataque especial o ambas.
- el caso de defenderse va relacionado tmb con la defensa especial, defensa normal o ambas.
- la velocidad sirve para decidir quien ataca primero cuando los dos combatientes eligen atacar
- el elemento añadira un daño extra a los ataques (normales/especiales) de fuego vs agua, se potencia agua, fuego vs tierra, se potencia fuego, tierra vs agua se potencai agua. En el resto de los casos donde se combaten entre pokemons del mismo elemento no se potencia ninguno.  

Por utlimo, se tendria que añadir un timepo de enfriamiento en caso de derrota ha dicho pokemon, añadir una variable de vida para cada pokemon, idear un sistema de emparejamiento para las batallas por nivel. Variable estado para saber si esta en batalla y limite de tiempo para las batallas.
Cuando se gana tambien habra un intercambio de monedas del juego, el perdedor le debera pagar al gandor.  

## Trainer.sol
  
Este contrato extiende las funcionalidades de PokemonFactory y gestiona a los entrenadores, incluyendo registro, actualización de estadísticas y consulta de ranking.

Características principales:

·Registro de Entrenadores:

  -Función registrarEntrenador: Permite a los usuarios registrarse como entrenadores asignándoles un nombre único.
  Emite el evento EntrenadorRegistrado para notificar el registro.
  Gestión del Nombre de Entrenador:
  
  -Función cambiarNombre: Permite a un entrenador registrado cambiar su nombre.
  Emite el evento CambioDeNombre al realizar el cambio.
  Consulta de Datos:
  
  -Función consultarEntrenador: Retorna la información del entrenador, como victorias, derrotas y nombre, utilizando su dirección.
  Actualización de Estadísticas:
  
  -Función actualizarVictorias: Permite al administrador (onlyOwner) actualizar las victorias o derrotas de un entrenador.
  Ranking de Entrenadores:
  
  -Función obtenerRanking: Devuelve una lista de entrenadores ordenados por número de victorias usando el algoritmo QuickSort.

  -Función eliminarEntrenador: Eliminar un entrenador y todos sus Pokémon asociados usando la funcion auxiliar de compactarArrayPokemons.

·Funciones Auxiliares:

  -QuickSort: Algoritmo recursivo para ordenar el ranking de entrenadores según sus victorias.

  -compactarArrayPokemons: Elimina los huecos en el array de Pokémon después de la eliminación de los Pokémons.

·Seguridad:

  -Modificador registrado: Verifica que el entrenador esté registrado antes de realizar ciertas acciones.

  -Modificador onlyOwner: Restringe funciones administrativas al propietario del contrato.

## Adquisicion de pokemons 
Una forma sera comprnadolos por PokeCoins, los cuales se obtendran al ganar batallas.


## Futuras mejoras
Chainlink VRF para números aleatorios