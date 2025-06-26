# Archivos de Música para Objects Diamond

Para que el sistema de música funcione, necesitas colocar los siguientes archivos de audio en la carpeta `assets/audio/`:

## Archivos requeridos (formato .ogg recomendado):

- `isaac_basement.ogg` - Música para antes 1-2 (nivel sótano)
- `isaac_caves.ogg` - Música para antes 3-4 (nivel cuevas) 
- `isaac_depths.ogg` - Música para antes 5-6 (nivel profundidades)
- `isaac_womb.ogg` - Música para antes 7-8 (nivel útero)
- `isaac_sheol.ogg` - Música para antes 9+ (nivel sheol)
- `isaac_boss.ogg` - Música para peleas de jefe
- `isaac_shop.ogg` - Música para la tienda
- `isaac_secret.ogg` - Música para habitaciones secretas
- `isaac_chest.ogg` - Música para niveles finales

## Notas importantes:

1. **Formato**: Usa archivos .ogg para mejor compatibilidad
2. **Tamaño**: Mantén los archivos bajo 5MB cada uno
3. **Loop**: Asegúrate de que la música haga loop perfectamente
4. **Volumen**: Normaliza el audio para evitar variaciones bruscas

## Fuentes recomendadas:

- Banda sonora oficial de The Binding of Isaac
- Música royalty-free de sitios como Freesound.org
- Composiciones propias

## Cómo probar:

1. Coloca los archivos de audio en `assets/audio/`
2. Carga el mod en Balatro
3. El sistema mostrará en consola qué archivos encontró
4. La música cambiará según el progreso del juego

## Controles adicionales:

- Para deshabilitar música: `music_system.toggle(false)`
- Para cambiar volumen: `music_system.set_volume(0.5)` (0.0 a 1.0)
- Para tocar una pista específica: `music_system.play_isaac_track("basement")`
