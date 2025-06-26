# Diamond Booster Pack System

He implementado un sistema de booster packs para tu mod Objects Diamond basado en cómo lo hace Pokermon. Aquí está todo lo que necesitas saber:

## ✅ Lo que se ha implementado:

### 1. Sistema de Booster Packs (`boosters/diamond_packs.lua`)
- **Diamond Pack Normal**: 6$ - Muestra 3 cartas, elige 1
- **Jumbo Diamond Pack**: 10$ - Muestra 5 cartas, elige 1  
- **Mega Diamond Pack**: 15$ - Muestra 5 cartas, elige 2

### 2. Integración en main.lua
- Sistema automático de carga de booster packs
- Localización/traducciones configuradas
- Atlas registrado para las imágenes

### 3. Funcionalidades
- Los packs aparecen automáticamente en la tienda
- Solo muestran jokers de tu mod
- Efectos visuales con partículas azul diamante
- Fondo temático azul diamante

## 🎯 Cómo expandir el sistema:

### Para agregar más jokers al pool:
En `boosters/diamond_packs.lua`, modifica esta línea:
```lua
local diamond_cards = {
    'j_od_caja_azul',  -- Tu joker actual
    'j_od_nuevo_joker', -- Agregar aquí nuevos jokers
    'j_od_otro_joker'   -- Con el prefijo j_od_
}
```

### Para agregar más tipos de packs:
Simplemente agrega más objetos al `pack_list` en el mismo archivo:
```lua
local diamond_pack_special = {
    name = "Special Diamond Pack",
    key = "diamond_pack_special_1",
    -- ... configuración similar
}

local pack_list = {diamond_pack_normal, diamond_pack_jumbo, diamond_pack_mega, diamond_pack_special}
```

## 🖼️ Assets necesarios:

Necesitas crear `diamond_pack_atlas.png` en:
- `assets/1x/diamond_pack_atlas.png` (213x95 px)
- `assets/2x/diamond_pack_atlas.png` (426x190 px)

Por ahora uso una imagen placeholder (copia de caja_azul.png).

## 🎮 Cómo probar:

1. Inicia Balatro con tu mod cargado
2. Ve a una tienda 
3. Deberías ver los Diamond Packs disponibles para comprar
4. Al abrirlos, solo mostrarán tu Caja Azul (por ahora)

## 🔄 Diferencias con Pokermon:

- Pokermon usa lógica compleja para items de evolución
- Tu implementación es más simple y directa
- Fácil de expandir cuando agregues más jokers

El sistema está listo para usar y expandir. ¡Solo necesitas crear la imagen del atlas para que se vea mejor!
