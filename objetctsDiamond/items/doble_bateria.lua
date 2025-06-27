-- Doble Batería - Isaac Item
-- Te da una etiqueta doble cada vez que saltas una ciega

return {
    key = "doble_bateria",
    loc_txt = {
        name = "Doble Batería",
        text = {
            "Cuando {C:attention}saltas{} una ciega,",
            "ganas una {C:attention}etiqueta doble{}"
        }
    },
    config = {
        extra = {
            skips_used = 0
        }
    },
    rarity = 2, -- Uncommon
    cost = 6,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    effect = "",
    cost_mult = 1.0,
    pos = {x = 0, y = 0},
    atlas = "od_doble_bateria",
    
    calculate = function(self, card, context)
        -- Detectar cuando se salta una ciega (múltiples contextos para mayor compatibilidad)
        if (context.skip_blind or context.skipping_booster or context.end_of_round) and not context.blueprint then
            -- Verificar que realmente se saltó una ciega
            if G.GAME.current_round and G.GAME.current_round.hands_left and G.GAME.current_round.hands_left > 0 then
                -- Solo activar si se saltó la ciega actual
                if context.skip_blind then
                    -- Crear una etiqueta doble
                    G.E_MANAGER:add_event(Event({
                        trigger = 'after',
                        delay = 0.5,
                        func = function()
                            -- Añadir etiqueta doble
                            local tag = Tag('tag_double')
                            if tag then
                                add_tag(tag)
                                
                                -- Mensaje visual
                                card_eval_status_text(card, 'extra', nil, nil, nil, {
                                    message = "¡Etiqueta Doble!",
                                    colour = G.C.GOLD,
                                    instant = true
                                })
                                
                                -- Efecto visual
                                card:juice_up(1.2, 1.2)
                                
                                -- Contador de saltos (opcional, para estadísticas)
                                card.ability.extra.skips_used = card.ability.extra.skips_used + 1
                            end
                            return true
                        end
                    }))
                end
            end
        end
        
        -- Método alternativo: detectar cuando termina una ronda sin haber jugado todas las manos
        if context.end_of_round and not context.blueprint and not context.repetition then
            -- Verificar si se saltó (si quedan manos sin usar)
            if G.GAME.current_round and G.GAME.current_round.hands_left and G.GAME.current_round.hands_left > 0 then
                -- Esta lógica se activaría al saltar
                -- Ya manejado arriba
            end
        end
    end,
    
    -- Función que se ejecuta cuando la carta se añade al deck
    add_to_deck = function(self, card, from_debuff)
        -- Inicializar contador
        card.ability.extra.skips_used = 0
    end,
    
    -- Función que se ejecuta cuando la carta se vende
    remove_from_deck = function(self, card, from_debuff)
        -- Resetear contador
        card.ability.extra.skips_used = 0
    end,
    
    -- Función para mostrar las variables en la descripción
    loc_def = function(self, card)
        return {
            card.ability.extra.skips_used or 0
        }
    end
}
