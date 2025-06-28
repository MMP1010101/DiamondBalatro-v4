-- god_head.lua - Isaac Items: Godhead
-- Da un multiplicador de x3

return {
    key = 'god_head',
    loc_txt = {
        name = 'Godhead',
        text = {
            'Eleva el {C:mult}Mult{} a la potencia de {C:attention}2',
            '{C:inactive}(Mult^2 - Poder divino)'
        }
    },
    config = {
        extra = {
            power = 2
        }
    },
    rarity = 3, -- Rare - porque x3 mult es muy poderoso
    cost = 8,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    effect = "",
    cost_mult = 1.0,
    pos = { x = 0, y = 0 },
    atlas = 'od_god_head',
    
    loc_vars = function(self, info_queue, center)
        return {vars = {center.ability.extra.power}}
    end,
    
    calculate = function(self, card, context)
        -- Solo activar en el contexto principal de jokers
        if context.joker_main then
            -- Buscar el multiplicador actual desde diferentes fuentes
            local current_mult = 0
            
            -- Primer intento: desde el contexto directo (más confiable en joker_main)
            if context.hand_mult and context.hand_mult > 1 then
                current_mult = context.hand_mult
                print("DEBUG god_head - Mult desde context.hand_mult: " .. current_mult)
            
            -- Segundo intento: multiplicador mínimo si no hay uno válido
            elseif not context.hand_mult or context.hand_mult <= 1 then
                -- En joker_main sin hand_mult válido, usar mult mínimo decente
                current_mult = 4  
                print("DEBUG god_head - Usando mult base para joker_main: " .. current_mult)
            end
            
            -- Solo aplicar si hay multiplicador y la diferencia es significativa
            if current_mult and current_mult > 1 then
                -- Calcular el nuevo multiplicador elevado
                local elevated_mult = current_mult ^ card.ability.extra.power
                local mult_difference = elevated_mult - current_mult
                
                print("DEBUG god_head - Calculando en joker_main: " .. current_mult .. "^2 = " .. elevated_mult .. " (+" .. mult_difference .. ")")
                
                -- Solo aplicar si la diferencia es mayor a 0
                if mult_difference > 0 then
                    print("DEBUG god_head - Activando efecto con diferencia: +" .. mult_difference)
                    
                    -- Animación impresionante mejorada
                G.E_MANAGER:add_event(Event({
                    func = function()
                        -- Efecto de juice masivo
                        card:juice_up(2, 2)
                        
                        -- Sonidos épicos
                        play_sound('gold_seal', 1.5, 0.6)
                        play_sound('multhit1', 1.2, 0.8)
                        play_sound('timpani', 1, 0.5)
                        
                        -- Efecto de halo dorado con animación circular
                        for i = 1, 15 do
                            G.E_MANAGER:add_event(Event({
                                trigger = 'after',
                                delay = 0.03 * i,
                                func = function()
                                    -- Animación de pulso
                                    card:juice_up(0.4, 0.4)
                                    
                                    -- Sonido gradual
                                    if i % 3 == 0 then
                                        play_sound('chips1', 1 + (i * 0.05), 0.3)
                                    end
                                    
                                    return true
                                end
                            }))
                        end
                        
                        -- Texto flotante épico
                        attention_text({
                            text = "¡PODER DIVINO!",
                            scale = 1.5,
                            hold = 1,
                            major = card,
                            backdrop_colour = G.C.GOLD,
                            align = 'cm',
                            offset = {x = 0, y = -2}
                        })
                        
                        -- Efecto adicional mostrando la elevación
                        G.E_MANAGER:add_event(Event({
                            trigger = 'after',
                            delay = 0.2,
                            func = function()
                                attention_text({
                                    text = current_mult .. "^2 = " .. elevated_mult,
                                    scale = 1.8,
                                    hold = 1.2,
                                    major = card,
                                    backdrop_colour = G.C.MULT,
                                    align = 'cm',
                                    offset = {x = 0, y = -3.5}
                                })
                                return true
                            end
                        }))
                        
                        return true
                    end
                }))
                
                return {
                    message = localize('k_mult') .. " elevado!",
                    mult_mod = mult_difference,
                    colour = G.C.MULT,
                    card = card
                }
                else
                    print("DEBUG god_head - Multiplicador demasiado bajo, no se activa (evita crash)")
                end
            else
                print("DEBUG god_head - No se encontró multiplicador válido en joker_main")
            end
        end
        return nil
    end,
    
    add_to_deck = function(self, card, from_debuff)
        -- Feedback visual cuando se añade al mazo
        if card then
            card_eval_status_text(card, 'extra', nil, nil, nil, {
                message = "¡Poder divino!",
                colour = G.C.MULT,
                delay = 0.45
            })
            
            print("DEBUG: god_head añadido al mazo - X2 Mult activado")
        end
    end,
    
    remove_from_deck = function(self, card, from_debuff)
        -- Feedback cuando se quita del mazo
        if card then
            print("DEBUG: god_head removido del mazo")
        end
    end
}
