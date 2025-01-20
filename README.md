# Desarrollo de la aplicación basada en la blockchain de Ethereum y la guía de CryptoZombies

## Punto de partida

El usuario, con una dirección en la blockchain, introduce su nombre de entrenador y escoge uno de los tres elementos posibles, obteniendo así uno de los pokémon iniciales basado en el elemento escogido. El poder de este pokémon es aleatorio.

## Aspectos de la implementación en código

Tendremos un array para todos los pokémon que puedan crearse. En el array constarán: el nombre, elemento, velocidad, ataque, defensa, ataque especial y defensa especial. Podrá haber pokémon iguales. El nombre y el elemento del inicial irán definidos por la elección del usuario al inicio, al igual que su poder, que dependerá pseudoaleatoriamente del nickname que haya escogido. Inicialmente, los stats (ataque, defensa, etc.) tendrán un valor numérico del 0 al 9, sacado del valor (poder) mencionado anteriormente.

Para asociar los pokémon a las direcciones de usuario, emplearemos que intrínsecamente cada nuevo elemento (pokémon) tendrá un id correspondiente a la posición que ocupa en el array. Este id irá asociado mediante un mapping a la dirección del usuario. Después, para saber cuántos pokémon tiene un usuario, tendremos otro mapping. También habrá un mapping para asociar la dirección de la blockchain del usuario con su nombre de entrenador.

## Objetivos futuros

- Definir uso del token ERC1155
- o ERC20
- Definir el flujo de la aplicación (intentar sacarle provecho a la blockchain)
- Funciones
  ·Combates aleatorios(Pokemons creados y destruidos)
  ·Entrenar pokemons
  ·Capturar pokemons

  ## Trainer.sol
  
Este contrato extiende las funcionalidades de PokemonFactory y gestiona a los entrenadores, incluyendo registro, actualización de estadísticas y consulta de ranking.

·Características principales:
Registro de Entrenadores:

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

·Funciones Auxiliares:

  -QuickSort: Algoritmo recursivo para ordenar el ranking de entrenadores según sus victorias.

·Seguridad:

  -Modificador registrado: Verifica que el entrenador esté registrado antes de realizar ciertas acciones.

  -Modificador onlyOwner: Restringe funciones administrativas al propietario del contrato.
