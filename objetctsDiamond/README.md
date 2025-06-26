# Objects Diamond - Isaac Items

Un mod para Balatro que añade ítems temáticos de Isaac con una estructura de archivos organizada.

## Estructura del Mod

```
objetctsDiamond/
├── main.lua              # Archivo principal que carga todos los ítems
├── manifest.json         # Configuración del mod
├── README.md             # Este archivo
├── assets/               # Sprites y recursos
└── items/                # Carpeta organizada con todos los ítems
    ├── joker_isaac_cube.lua      # Cubo negro misterioso
    ├── joker_isaac_diamond.lua   # Diamante sagrado
    ├── joker_isaac_skull.lua     # Calavera maldita
    └── joker_isaac_trinket.lua   # Amuleto de la suerte
```

## Ítems Incluidos

### Isaac's Cube (Cubo de Isaac)
- **Rareza:** Rara
- **Costo:** 6
- **Efecto:** +4 Mult
- Un cubo negro misterioso de las profundidades del sótano.

### Sacred Diamond (Diamante Sagrado)
- **Rareza:** Épica
- **Costo:** 8
- **Efecto:** +8 Mult
- Un diamante brillante que refleja la luz divina.

### Cursed Skull (Calavera Maldita)
- **Rareza:** Rara
- **Costo:** 5
- **Efecto:** +30 Chips
- Una calavera embrujada de las profundidades del sótano.

### Lucky Trinket (Amuleto de la Suerte)
- **Rareza:** Épica
- **Costo:** 7
- **Efecto:** X1.5 Mult si la mano contiene cartas Lucky
- Un amuleto atado con una cinta azul.

## Instalación

1. Asegúrate de tener Steamodded instalado
2. Copia la carpeta `objetctsDiamond` a tu directorio de mods de Balatro
3. Reinicia el juego

## Desarrollo

Este mod utiliza una estructura organizada donde cada ítem está en su propio archivo `.lua` dentro de la carpeta `items/`. Esto facilita el mantenimiento y la adición de nuevos ítems.

Para añadir un nuevo ítem:
1. Crea un nuevo archivo `.lua` en la carpeta `items/`
2. Añade el nombre del archivo a la lista `item_files` en `main.lua`
3. El ítem se cargará automáticamente

## Autor

salva

## Versión

1.0.0
