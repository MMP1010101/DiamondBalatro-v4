-- black_judas.lua - Isaac Items: Black Judas
-- Cuando no tengas descartes y quede 1 mano, la carta desaparece y da x2 Mult

return {
    key = 'black_judas',
    loc_txt = {
        name = 'Black Judas',
        text = {
            'Cuando no tengas {C:attention}descartes{} y',
            'quede {C:attention}1 mano{}, esta carta {C:red}desaparece{}',
            'y da {X:mult,C:white}X2{} Mult permanente',
            '{C:inactive}(Sacrificio desesperado)'
        }
    },
    config = {
        extra = {
            mult_mod = 2,  -- Multiplicador que se aplica
            triggered = false  -- Flag para evitar múltiples activaciones
        }
    },
    rarity = 3, -- Rare - efecto muy poderoso pero requiere sacrificio
    cost = 8,
    unlocked = true,
    discovered = true,
    blueprint_compat = false, -- No compatible con blueprint porque se destruye
    eternal_compat = false, -- No compatible con eternal porque debe poder destruirse
    effect = "",
    cost_mult = 1.0,
    pos = { x = 0, y = 0 },
    atlas = 'od_black_judas',
    
    loc_vars = function(self, info_queue, center)
        return {vars = {center.ability.extra.mult_mod}}
    end,
    
    calculate = function(self, card, context)
        -- Verificar condiciones al inicio de cada mano jugada
        if context.before and not context.blueprint and not card.ability.extra.triggered then
            -- Verificar si no hay descartes y queda exactamente 1 mano (después de jugar esta mano quedará 0)
            if G.GAME.current_round and 
               G.GAME.current_round.discards_left <= 0 and 
               G.GAME.current_round.hands_left == 1 then
                
                print("DEBUG: Black Judas - Condiciones cumplidas: 0 descartes, 1 mano")
                card.ability.extra.triggered = true
                
                -- Efectos visuales dramáticos antes del sacrificio
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.3,
                    func = function()
                        -- Animación dramática
                        card:juice_up(1.5, 1.5)
                        
                        -- Sonidos dramáticos
                        play_sound('generic1', 1.2, 0.4)
                        play_sound('card1', 1.0, 0.6)
                        
                        -- Texto flotante dramático
                        attention_text({
                            text = "DARK SACRIFICE!",
                            scale = 1.5,
                            hold = 2.0,
                            major = card,
                            backdrop_colour = G.C.BLACK,
                            align = 'cm',
                            offset = {x = 0, y = -2}
                        })
                        
                        return true
                    end
                }))
                
                -- Aplicar el multiplicador permanente
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 1.0,
                    func = function()
                        -- Crear un Joker invisible permanente que dé el multiplicador
                        local mult_joker = create_card('Joker', G.jokers, nil, nil, nil, nil, 'j_od_black_judas_mult')
                        
                        -- Si no existe el joker de multiplicador, usar un enfoque diferente
                        if not mult_joker then
                            -- Aplicar directamente al multiplicador base del jugador
                            G.GAME.base_mult = G.GAME.base_mult * card.ability.extra.mult_mod
                            print("DEBUG: Black Judas - Multiplicador aplicado al base_mult")
                        else
                            -- Añadir el joker invisible al mazo
                            mult_joker:add_to_deck()
                            G.jokers:emplace(mult_joker)
                            print("DEBUG: Black Judas - Joker multiplicador creado")
                        end
                        
                        -- Mensaje de multiplicador aplicado
                        card_eval_status_text(card, 'extra', nil, nil, nil, {
                            message = "X" .. card.ability.extra.mult_mod .. " Mult Permanente!",
                            colour = G.C.MULT,
                            delay = 1.0
                        })
                        
                        print("DEBUG: Black Judas - Multiplicador x" .. card.ability.extra.mult_mod .. " aplicado permanentemente")
                        
                        return true
                    end
                }))
                
                -- Destruir la carta después del efecto
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 2.0,
                    func = function()
                        -- Efectos de destrucción
                        card:start_dissolve()
                        
                        -- Sonido de destrucción
                        play_sound('card1', 0.8, 0.8)
                        
                        print("DEBUG: Black Judas - Carta destruida después del sacrificio")
                        
                        return true
                    end
                }))
                
                return {
                    message = "¡SACRIFICIO OSCURO!",
                    colour = G.C.BLACK,
                    card = card
                }
            else
                -- Debug para mostrar el estado actual
                if G.GAME.current_round then
                    print("DEBUG: Black Judas - Estado actual: " .. 
                          G.GAME.current_round.discards_left .. " descartes, " .. 
                          G.GAME.current_round.hands_left .. " manos")
                end
            end
        end
        
        return nil
    end,
    
    add_to_deck = function(self, card, from_debuff)
        -- Feedback visual cuando se añade al mazo
        if card then
            card_eval_status_text(card, 'extra', nil, nil, nil, {
                message = "Esperando sacrificio...",
                colour = G.C.DARK_EDITION,
                delay = 0.45
            })
            
            print("DEBUG: Black Judas añadido al mazo - Esperando condiciones: 0 descartes, 1 mano")
        end
    end,
    
    remove_from_deck = function(self, card, from_debuff)
        -- Feedback cuando se quita del mazo (por destrucción o venta)
        if card then
            print("DEBUG: Black Judas removido del mazo")
        end
    end
}
