-- Descarte - Isaac Item
-- Te da 3 descartes adicionales

return {
    key = "descarte",
    loc_txt = {
        name = "Descarte",
        text = {
            "{C:red}+#1#{} descartes",
            "{C:inactive}(Descartes actuales: #2#){}"
        }
    },
    config = {
        extra = {
            discards = 3
        }
    },
    rarity = 1, -- Common
    cost = 4,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    effect = "",
    cost_mult = 1.0,
    pos = {x = 0, y = 0},
    atlas = "od_descarte",
    
    calculate = function(self, card, context)
        -- Aplicar descartes adicionales al inicio de cada ronda
        if context.setting_blind and not context.blueprint then
            G.GAME.current_round.discards_left = G.GAME.current_round.discards_left + card.ability.extra.discards
            
            -- Mensaje visual
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.5,
                func = function()
                    card_eval_status_text(card, 'extra', nil, nil, nil, {
                        message = "+3 Descartes!",
                        colour = G.C.RED,
                        instant = true
                    })
                    card:juice_up(1.0, 1.0)
                    return true
                end
            }))
        end
    end,
    
    -- Función que se ejecuta cuando la carta se añade al deck
    add_to_deck = function(self, card, from_debuff)
        -- Añadir 3 descartes cuando se obtiene la carta (solo si hay una ronda activa)
        if G.GAME and G.GAME.current_round and G.GAME.current_round.discards_left then
            G.GAME.current_round.discards_left = G.GAME.current_round.discards_left + card.ability.extra.discards
            
            -- Mensaje visual
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.2,
                func = function()
                    card_eval_status_text(card, 'extra', nil, nil, nil, {
                        message = "+3 Descartes!",
                        colour = G.C.RED,
                        instant = true
                    })
                    card:juice_up(1.2, 1.2)
                    return true
                end
            }))
        end
    end,
    
    -- Función que se ejecuta cuando la carta se vende
    remove_from_deck = function(self, card, from_debuff)
        -- Quitar 3 descartes cuando se vende la carta (solo si hay una ronda activa)
        if G.GAME and G.GAME.current_round and G.GAME.current_round.discards_left then
            G.GAME.current_round.discards_left = math.max(0, G.GAME.current_round.discards_left - card.ability.extra.discards)
            
            -- Mensaje visual
            card_eval_status_text(card, 'extra', nil, nil, nil, {
                message = "-3 Descartes",
                colour = G.C.RED
            })
        end
    end,
    
    -- Función para mostrar las variables en la descripción
    loc_def = function(self, card)
        local current_discards = 0
        if G.GAME and G.GAME.current_round and G.GAME.current_round.discards_left then
            current_discards = G.GAME.current_round.discards_left
        end
        
        return {
            card.ability.extra.discards,
            current_discards
        }
    end,
    
    -- Función personalizada para generar la UI con información dinámica
    generate_ui = function(self, info_queue, card, desc_nodes, specific_vars, full_UI_table)
        local current_discards = 0
        if G.GAME and G.GAME.current_round and G.GAME.current_round.discards_left then
            current_discards = G.GAME.current_round.discards_left
        end
        
        local vars = {card.ability.extra.discards, current_discards}
        
        local desc_key = self.key
        if specific_vars and specific_vars.debuffed then
            desc_key = desc_key..'_debuffed'
        end
        
        local loc_colour = G.C.WHITE
        if current_discards >= 5 then
            loc_colour = G.C.GREEN
        elseif current_discards >= 3 then
            loc_colour = G.C.GOLD
        elseif current_discards <= 1 then
            loc_colour = G.C.RED
        end
        
        -- Obtener la descripción base
        local desc_text = self.loc_txt.text
        
        local first_pass = true
        for _, v in ipairs(desc_text) do
            if not first_pass then
                loc_colour = G.C.WHITE
            end
            first_pass = false
            desc_nodes[#desc_nodes+1] = {}
            localize{type = 'other', key = v, nodes = desc_nodes[#desc_nodes], vars = vars, default_colours = {loc_colour}}
        end
    end
}
