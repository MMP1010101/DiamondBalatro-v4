-- Diamond Booster Pack
-- Pack que permite elegir cartas del mod Diamond

local create_diamond_card = function(self, card, i)
    print("DEBUG: Creating diamond card " .. i) -- Debug print
    -- Lista de todas las cartas Isaac disponibles en el mod
    local diamond_cards = {
        'j_od_caja_azul',
        'j_od_doble',
        'j_od_clavos',
        'j_od_corona',
        'j_od_dead_day',
        'j_od_descarte',
        'j_od_doble_bateria',
        'j_od_ede_blice',
        'j_od_egg_keeper',
        'j_od_god_head',
        'j_od_mushroom',
        'j_od_houli_shot',
        'j_od_incognita1'
    }
    
    -- Seleccionar una carta aleatoria de la lista
    local card_key = pseudorandom_element(diamond_cards, pseudoseed('diamond_pack'))
    print("DEBUG: Creating card with key: " .. card_key) -- Debug print
    
    -- Crear carta del tipo Joker SOLAMENTE (sin cartas de baraja)
    local created_card = create_card("Joker", G.pack_cards, nil, nil, true, true, card_key, nil)
    
    return created_card
end

local diamond_background = function(self)
    -- Color azul diamante para el fondo
    ease_background_colour{new_colour = {0.2, 0.4, 0.8, 1}, contrast = 3}
end

local diamond_particles = function(self)
    G.booster_pack_sparkles = Particles(1, 1, 0,0, {
        timer = 0.015,
        scale = 0.1,
        initialize = true,
        lifespan = 3,
        speed = 0.2,
        padding = -1,
        attach = G.ROOM_ATTACH,
        colours = {{0.4, 0.6, 1, 1}, {0.6, 0.8, 1, 1}, {1, 1, 1, 1}}, -- Colores azul diamante
        fill = true
    })
    G.booster_pack_sparkles.fade_alpha = 1
    G.booster_pack_sparkles:fade(1, 0)
end

-- Pack normal de Diamond (solo ítems Isaac)
local diamond_pack_normal = {
    name = "Diamond Pack",
    key = "diamond_pack_normal_1", -- Sin el prefijo p_od_
    kind = "Buffoon", -- Tipo de pack para jokers únicamente
    atlas = "od_diamond_pack", -- Usar el atlas de diamond_pack_atlas.png
    pos = { x = 0, y = 0 }, -- Posición estándar
    config = { extra = 3, choose = 1 }, -- 3 ítems Isaac, elige 1
    cost = 1, -- Reducido para testing
    order = 1,
    weight = 100, -- SUPER AUMENTADO para testing
    draw_hand = false, -- NO mostrar cartas de baraja
    unlocked = true,
    discovered = true,
    create_card = create_diamond_card,
    loc_vars = function(self, info_queue, card)
        return { vars = { card.config.center.config.choose, card.ability.extra } }
    end,
    group_key = "k_diamond_pack",
    ease_background_colour = diamond_background,
    particles = diamond_particles
}

-- Solo un pack en la lista
local pack_list = {diamond_pack_normal}

print("DEBUG: Diamond booster packs loaded! Pack count: " .. #pack_list)

return {
    name = "Diamond Packs",
    list = pack_list
}
