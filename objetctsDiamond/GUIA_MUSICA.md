# 🎵 GUÍA FÁCIL: Música Isaac en Balatro

## ✅ ¿El mod funciona?

Si ves estos mensajes en el log, ¡funciona!:
```
Objects Diamond Music System initialized!
Setting up simplified music hooks...
✓ Found: basement (Don_t.ogg)
```

## 🎮 CÓMO USAR LA CONSOLA (Muy fácil)

### Paso 1: Abrir la consola
- Presiona la tecla **`/`** (barra diagonal) durante el juego
- Se abrirá una ventana negra en la parte inferior

### Paso 2: Escribir comandos
Escribe cualquiera de estos comandos y presiona **Enter**:

```lua
play_isaac_music()          -- ▶️ Reproduce música del basement
isaac_boss_music()          -- 👹 Música de jefe
isaac_shop_music()          -- 🛒 Música de tienda  
isaac_caves_music()         -- 🕳️ Música de cuevas
stop_isaac_music()          -- ⏹️ Detener música
```

### Paso 3: Cerrar la consola
- Presiona **`/`** otra vez para cerrar

## 🎵 EJEMPLO DE USO

1. Inicia Balatro con el mod
2. Presiona **`/`** 
3. Escribe: `play_isaac_music()`
4. Presiona **Enter**
5. ¡Debería sonar tu música!

## 🔧 SOLUCIÓN DE PROBLEMAS

### ❌ "No se reproduce música"
1. Verifica que el archivo `Don_t.ogg` esté en: 
   `C:\Users\salva\AppData\Roaming\Balatro\Mods\objetctsDiamond\assets\audio\Don_t.ogg`

2. Prueba estos comandos en orden:
   ```lua
   stop_isaac_music()
   play_isaac_music()
   ```

### ❌ "Error de formato de audio"
- Convierte tu archivo a formato `.ogg` usando un conversor online
- Asegúrate de que sea mono o estéreo (no surround)

### ❌ "No encuentro la consola"
- La tecla `/` está junto a la tecla **Shift derecho**
- Si no funciona, prueba **Shift + /**

## 🎯 COMANDOS ÚTILES ADICIONALES

```lua
-- Ver estado del sistema
music_system.test_music()

-- Cambiar volumen (0.0 a 1.0)
music_system.set_volume(0.5)

-- Activar/desactivar
music_system.toggle(false)  -- desactivar
music_system.toggle(true)   -- activar

-- Reproducir pistas específicas
music_system.play_isaac_track("basement")
music_system.play_isaac_track("boss")
music_system.play_isaac_track("shop")
music_system.play_isaac_track("caves")
music_system.play_isaac_track("depths")
music_system.play_isaac_track("womb")
music_system.play_isaac_track("sheol")
```

## 🆘 SI NADA FUNCIONA

Escribe este comando para ver información de debug:
```lua
music_system.test_music()
```

Esto te dirá si encuentra tu archivo de música.
