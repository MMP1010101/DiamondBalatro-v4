-- libra.lua - Isaac Items: Libra
-- Equilibra las fichas y el multiplicador cuando se calcula

return {
    key = 'libra',
    loc_txt = {
        name = 'Libra',
        text = {
            'Cuando se calcula una mano,',
            '{C:attention}equilibra{} las {C:chips}Fichas{} y el {C:mult}Mult{}',
            'al valor promedio de ambos',
            '{C:inactive}(Balance perfecto)'
        }
    },
    config = {
        extra = {}
    },
    rarity = 2, -- Uncommon - efecto único y útil
    cost = 6,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    effect = "",
    cost_mult = 1.0,
    pos = { x = 0, y = 0 },
    atlas = 'od_libra',
    
    loc_vars = function(self, info_queue, center)
        return {}
    end,
    
    calculate = function(self, card, context)
        -- Equilibrar fichas y mult cuando se calcula la mano
        if context.joker_main then
            print("DEBUG: Libra - Contexto joker_main activado")
            
            -- En Balatro, las fichas y mult se pasan de manera diferente
            -- Necesitamos acceder a las variables globales o del estado del juego
            local current_chips = 0
            local current_mult = 0
            
            -- Intentar obtener valores de diferentes fuentes
            if context.full_hand then
                current_chips = context.full_hand.chips or 0
                current_mult = context.full_hand.mult or 0
                print("DEBUG: Libra - Obtenido de full_hand: Fichas=" .. current_chips .. ", Mult=" .. current_mult)
            end
            
            -- Si aún no tenemos valores, usar variables del contexto de scoring
            if current_chips == 0 and current_mult == 0 then
                -- Buscar en el contexto de scoring
                current_chips = hand_chips or 0
                current_mult = mult or 0
                print("DEBUG: Libra - Obtenido de variables globales: Fichas=" .. current_chips .. ", Mult=" .. current_mult)
            end
            
            -- Si todavía no hay valores, usar estimaciones basadas en la mano actual
            if current_chips == 0 and current_mult == 0 and G.play and G.play.cards then
                -- Calcular chips básicos de la mano
                current_chips = 20 + (#G.play.cards * 5) -- Estimación básica
                current_mult = 4 -- Mult base
                print("DEBUG: Libra - Valores estimados: Fichas=" .. current_chips .. ", Mult=" .. current_mult)
            end
            
            print("DEBUG: Libra - Valores finales: Fichas=" .. current_chips .. ", Mult=" .. current_mult)
            
            -- Calcular el promedio de fichas y mult
            local average = math.floor((current_chips + current_mult) / 2)
            
            -- Solo equilibrar si hay diferencia significativa y valores válidos
            if current_chips > 0 and current_mult > 0 and math.abs(current_chips - current_mult) > 5 then
                print("DEBUG: Libra - Equilibrando: Fichas=" .. current_chips .. ", Mult=" .. current_mult .. " -> Promedio=" .. average)
                
                -- Efectos visuales
                card:juice_up(1.3, 1.3)
                play_sound('generic1', 1.0, 0.8)
                
                -- Calcular las diferencias para equilibrar
                local chip_diff = average - current_chips
                local mult_diff = average - current_mult
                
                return {
                    chips = chip_diff,
                    mult = mult_diff,
                    message = "¡Equilibrado! " .. average,
                    colour = G.C.BLUE,
                    card = card
                }
            else
                if current_chips > 0 and current_mult > 0 then
                    print("DEBUG: Libra - Diferencia pequeña (" .. math.abs(current_chips - current_mult) .. "), no equilibrando")
                else
                    print("DEBUG: Libra - Valores no válidos para equilibrar")
                end
            end
        end
        
        return nil
    end,
    
    add_to_deck = function(self, card, from_debuff)
        -- Feedback visual cuando se añade al mazo
        if card then
            card_eval_status_text(card, 'extra', nil, nil, nil, {
                message = "Equilibrio activado",
                colour = G.C.BLUE,
                delay = 0.45
            })
            
            print("DEBUG: Libra añadido al mazo - Equilibrará fichas y mult")
        end
    end,
    
    remove_from_deck = function(self, card, from_debuff)
        -- Feedback cuando se quita del mazo
        if card then
            print("DEBUG: Libra removido del mazo")
        end
    end
}
