-- Dead Day - Isaac Item
-- Acumula 0.5 Mult cada vez que puntúa, se reinicia al descartar o jugar otra mano

return {
    key = "dead_day",
    loc_txt = {
        name = "Dead Day",
        text = {
            "Gana {C:mult}+0.5{} Mult por cada carta",
            "que {C:attention}puntúe{} o se {C:blue}descarte{}",
            "Se {C:red}reinicia{} al final",
            "de cada {C:attention}ciega{}",
            "{C:inactive}(Mult actual: {C:mult}+#1#{C:inactive})"
        }
    },
    config = {
        extra = {
            mult_gain = 0.5,
            current_mult = 0,
            scored_this_hand = false
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
    atlas = "od_dead_day",
    
    calculate = function(self, card, context)
        -- Dar el multiplicador acumulado cuando se evalúan los jokers
        if context.joker_main then
            if card.ability.extra.current_mult > 0 then
                return {
                    message = localize{type='variable', key='a_mult', vars={card.ability.extra.current_mult}},
                    mult_mod = card.ability.extra.current_mult,
                    colour = G.C.MULT
                }
            end
        end
        
        -- Acumular multiplicador cuando cualquier carta puntúa
        if context.individual and context.cardarea == G.play and not context.blueprint then
            -- Se activa por cada carta que puntúe
            card.ability.extra.current_mult = card.ability.extra.current_mult + card.ability.extra.mult_gain
            card.ability.extra.scored_this_hand = true
            
            -- Mensaje visual con el total actual
            card_eval_status_text(card, 'extra', nil, nil, nil, {
                message = "+0.5 Mult (Total: " .. card.ability.extra.current_mult .. ")",
                colour = G.C.MULT
            })
            
            -- Efecto visual para forzar actualización
            G.E_MANAGER:add_event(Event({
                func = function()
                    card:juice_up(0.8, 0.8)
                    -- Forzar recálculo de la descripción
                    if card.children and card.children.center then
                        card.children.center:juice_up(0.1, 0.1)
                    end
                    return true
                end
            }))
        end
        
        -- TAMBIÉN acumular multiplicador cuando se descarta cualquier carta
        if context.discard and context.other_card and not context.blueprint then
            -- Se activa por cada carta descartada
            card.ability.extra.current_mult = card.ability.extra.current_mult + card.ability.extra.mult_gain
            
            -- Mensaje visual con el total actual
            card_eval_status_text(card, 'extra', nil, nil, nil, {
                message = "+0.5 Mult (Total: " .. card.ability.extra.current_mult .. ")",
                colour = G.C.BLUE
            })
            
            -- Efecto visual para forzar actualización
            G.E_MANAGER:add_event(Event({
                func = function()
                    card:juice_up(0.8, 0.8)
                    -- Forzar recálculo de la descripción
                    if card.children and card.children.center then
                        card.children.center:juice_up(0.1, 0.1)
                    end
                    return true
                end
            }))
        end
        
        -- Reiniciar solo al final de la ronda cuando se gana/pierde
        if context.end_of_round and not context.individual and not context.repetition and not context.blueprint then
            if card.ability.extra.current_mult > 0 then
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 1.0,
                    func = function()
                        card.ability.extra.current_mult = 0
                        card.ability.extra.scored_this_hand = false
                        
                        -- Mensaje visual de reinicio
                        card_eval_status_text(card, 'extra', nil, nil, nil, {
                            message = "¡Nuevo día!",
                            colour = G.C.GOLD
                        })
                        
                        -- Efecto visual
                        card:juice_up(0.8, 0.8)
                        return true
                    end
                }))
            end
        end
    end,
    
    -- Función para mostrar las variables en la descripción
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.current_mult or 0 } }
    end,
    
    -- Función simple para variables
    loc_def = function(self, card)
        return { card.ability.extra.current_mult or 0 }
    end,
    
    -- Función para cuando la carta se añade al deck
    add_to_deck = function(self, card, from_debuff)
        -- Asegurar que empiece sin multiplicador
        card.ability.extra.current_mult = 0
        card.ability.extra.scored_this_hand = false
    end,
    
    -- Función para cuando se vende la carta
    remove_from_deck = function(self, card, from_debuff)
        -- Resetear todo
        card.ability.extra.current_mult = 0
        card.ability.extra.scored_this_hand = false
    end
}
