# Diamond Booster Pack Setup

Para que los booster packs funcionen correctamente, necesitas crear la imagen del atlas:

## Imagen Requerida:
- **Archivo:** `diamond_pack_atlas.png`
- **Ubicación:** `assets/1x/diamond_pack_atlas.png` y `assets/2x/diamond_pack_atlas.png`
- **Dimensiones:** 
  - 1x: 213x95 pixels (3 cartas horizontalmente de 71x95 cada una)
  - 2x: 426x190 pixels (3 cartas horizontalmente de 142x190 cada una)

## Posiciones en el Atlas:
- Posición (0,0): Diamond Pack Normal
- Posición (1,0): Diamond Pack Jumbo  
- Posición (2,0): Diamond Pack Mega

## Cómo Crear la Imagen:
1. Puedes usar cualquier editor de imágenes
2. Crea 3 imágenes de booster pack diferentes con temas de diamante/Isaac
3. Únelas horizontalmente en el orden especificado arriba
4. Guarda como PNG en las carpetas 1x y 2x

## Alternativa Temporal:
Mientras tanto, puedes copiar cualquier imagen de booster pack existente de otros mods y renombrarla a `diamond_pack_atlas.png`

## Funcionalidad:
- Los packs aparecerán en la tienda con sus respectivos costos
- Diamond Pack Normal: 6$ - 3 cartas, elige 1
- Jumbo Diamond Pack: 10$ - 5 cartas, elige 1  
- Mega Diamond Pack: 15$ - 5 cartas, elige 2
- Todos los packs mostrarán solo jokers de tu mod (actualmente solo Caja Azul)
