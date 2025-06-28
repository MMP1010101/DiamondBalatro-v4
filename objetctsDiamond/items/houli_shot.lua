-- houli_shot.lua - Isaac Items: Holy Shot
-- Eleva el Mult a la potencia de 3, pero solo cada 1 de 4 tiradas

return {
    key = 'houli_shot',
    loc_txt = {
        name = 'Holy Shot',
        text = {
            '{C:green}1 en 4{} probabilidad de elevar',
            'el {C:mult}Mult{} a la potencia de {C:attention}3',
            '{C:inactive}(Mult^3 - Disparo divino)'
        }
    },
    config = {
        extra = {
            power = 3,
            odds = 4
        }
    },
    rarity = 2, -- Uncommon - porque es aleatorio y no siempre activo
    cost = 5,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    effect = "",
    cost_mult = 1.0,
    pos = { x = 0, y = 0 },
    atlas = 'od_houli_shot',
    
    loc_vars = function(self, info_queue, center)
        return {vars = {G.GAME.probabilities.normal or 1, center.ability.extra.odds, center.ability.extra.power}}
    end,
    
    calculate = function(self, card, context)
        -- Solo activar en el contexto principal de jokers
        if context.joker_main then
            -- Verificar probabilidad 1 en 4
            if pseudorandom('houli_shot') < G.GAME.probabilities.normal / card.ability.extra.odds then
                -- Buscar el multiplicador actual
                local current_mult = 0
                
                if context.hand_mult and context.hand_mult > 1 then
                    current_mult = context.hand_mult
                elseif not context.hand_mult or context.hand_mult <= 1 then
                    current_mult = 4  -- Multiplicador base para activar
                end
                
                -- Solo aplicar si hay multiplicador válido
                if current_mult and current_mult > 1 then
                    -- Calcular el nuevo multiplicador elevado
                    local elevated_mult = current_mult ^ card.ability.extra.power
                    local mult_difference = elevated_mult - current_mult
                    
                    -- Solo aplicar si la diferencia es mayor a 0
                    if mult_difference > 0 then
                        print("DEBUG houli_shot - ¡ACTIVADO! " .. current_mult .. "^3 = " .. elevated_mult .. " (+" .. mult_difference .. ")")
                        
                        -- Animación épica
                        G.E_MANAGER:add_event(Event({
                            func = function()
                                -- Efecto de juice masivo
                                card:juice_up(1.5, 1.5)
                                
                                -- Sonidos divinos
                                play_sound('gold_seal', 1.2, 0.5)
                                play_sound('multhit1', 1.3, 0.7)
                                
                                -- Efecto de destellos
                                for i = 1, 8 do
                                    G.E_MANAGER:add_event(Event({
                                        trigger = 'after',
                                        delay = 0.05 * i,
                                        func = function()
                                            card:juice_up(0.3, 0.3)
                                            if i % 2 == 0 then
                                                play_sound('chips1', 1 + (i * 0.1), 0.4)
                                            end
                                            return true
                                        end
                                    }))
                                end
                                
                                -- Texto flotante especial
                                attention_text({
                                    text = "¡DISPARO DIVINO!",
                                    scale = 1.4,
                                    hold = 1.2,
                                    major = card,
                                    backdrop_colour = G.C.BLUE,
                                    align = 'cm',
                                    offset = {x = 0, y = -2}
                                })
                                
                                -- Mostrar la elevación
                                G.E_MANAGER:add_event(Event({
                                    trigger = 'after',
                                    delay = 0.3,
                                    func = function()
                                        attention_text({
                                            text = current_mult .. "^3 = " .. elevated_mult,
                                            scale = 1.6,
                                            hold = 1,
                                            major = card,
                                            backdrop_colour = G.C.MULT,
                                            align = 'cm',
                                            offset = {x = 0, y = -3}
                                        })
                                        return true
                                    end
                                }))
                                
                                return true
                            end
                        }))
                        
                        return {
                            message = localize('k_mult') .. " DIVINO!",
                            mult_mod = mult_difference,
                            colour = G.C.BLUE,
                            card = card
                        }
                    else
                        print("DEBUG houli_shot - Activado pero multiplicador muy bajo")
                    end
                else
                    print("DEBUG houli_shot - Activado pero sin multiplicador válido")
                end
            else
                -- No se activó la probabilidad, mostrar feedback sutil
                if pseudorandom('houli_shot_miss') < 0.1 then -- 10% chance de mostrar mensaje
                    card_eval_status_text(card, 'extra', nil, nil, nil, {
                        message = "Fallido...",
                        colour = G.C.UI.TEXT_INACTIVE,
                        delay = 0.3
                    })
                end
            end
        end
        return nil
    end,
    
    add_to_deck = function(self, card, from_debuff)
        -- Feedback visual cuando se añade al mazo
        if card then
            card_eval_status_text(card, 'extra', nil, nil, nil, {
                message = "¡Disparo santo!",
                colour = G.C.BLUE,
                delay = 0.45
            })
            
            print("DEBUG: houli_shot añadido al mazo - 1/4 chance de Mult^3")
        end
    end,
    
    remove_from_deck = function(self, card, from_debuff)
        -- Feedback cuando se quita del mazo
        if card then
            print("DEBUG: houli_shot removido del mazo")
        end
    end
}
