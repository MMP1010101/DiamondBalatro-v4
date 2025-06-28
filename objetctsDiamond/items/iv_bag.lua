-- iv_bag.lua - Isaac Items: IV Bag
-- Quita 2 descartes y 1 mano pero ganas $20

return {
    key = 'iv_bag',
    loc_txt = {
        name = 'IV Bag',
        text = {
            '{C:red}-2{} Descartes, {C:red}-1{} Mano',
            'pero ganas {C:money}$15{} cada ronda',
            '{C:inactive}(Sacrificio por dinero constante)'
        }
    },
    config = {
        extra = {
            money_per_round = 15,  -- Dinero que da cada ronda
            hands_applied = false,  -- Flag para aplicar penalty de manos/descartes solo una vez
        }
    },
    rarity = 2, -- Uncommon - trade-off interesante
    cost = 6,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    effect = "",
    cost_mult = 1.0,
    pos = { x = 0, y = 0 },
    atlas = 'od_iv_bag',
    
    loc_vars = function(self, info_queue, center)
        return {}
    end,
    
    calculate = function(self, card, context)
        -- Dar dinero al final de cada ronda
        if context.end_of_round and not context.individual and not context.repetition then
            -- Dar dinero cada ronda
            ease_dollars(card.ability.extra.money_per_round)
            
            -- Efectos visuales y sonoros
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.3,
                func = function()
                    -- Animación de la carta
                    card:juice_up(1.2, 1.2)
                    
                    -- Sonidos médicos
                    play_sound('coin2', 1.0, 0.7)
                    play_sound('generic1', 0.8, 0.5)
                    
                    -- Texto flotante
                    attention_text({
                        text = "BLOOD MONEY",
                        scale = 1.1,
                        hold = 1.0,
                        major = card,
                        backdrop_colour = G.C.RED,
                        align = 'cm',
                        offset = {x = 0, y = -2}
                    })
                    
                    return true
                end
            }))
            
            print("DEBUG: IV Bag - Dinero por ronda: +$" .. card.ability.extra.money_per_round)
            
            return {
                message = "+$" .. card.ability.extra.money_per_round,
                colour = G.C.MONEY,
                card = card
            }
        end
        
        return nil
    end,
    
    add_to_deck = function(self, card, from_debuff)
        -- Aplicar el penalty de manos y descartes solo una vez
        if card and not card.ability.extra.hands_applied then
            card.ability.extra.hands_applied = true
            
            -- Reducir manos y descartes en la ronda actual
            if G.GAME.current_round then
                G.GAME.current_round.hands_left = math.max(0, G.GAME.current_round.hands_left - 1)
                G.GAME.current_round.discards_left = math.max(0, G.GAME.current_round.discards_left - 2)
            end
            
            -- Aplicar modificadores permanentes para futuras rondas
            G.GAME.round_resets.hands = G.GAME.round_resets.hands - 1
            G.GAME.round_resets.discards = G.GAME.round_resets.discards - 2
            
            -- Efectos visuales inmediatos
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.3,
                func = function()
                    -- Animación de la carta
                    card:juice_up(1.3, 1.3)
                    
                    -- Sonidos médicos/dramáticos
                    play_sound('card1', 1.0, 0.6)
                    play_sound('generic1', 0.8, 0.5)
                    
                    -- Texto flotante del efecto
                    attention_text({
                        text = "IV CONNECTED",
                        scale = 1.2,
                        hold = 1.2,
                        major = card,
                        backdrop_colour = G.C.RED,
                        align = 'cm',
                        offset = {x = 0, y = -2}
                    })
                    
                    return true
                end
            }))
            
            -- Mostrar penalty de manos/descartes
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.6,
                func = function()
                    card_eval_status_text(card, 'extra', nil, nil, nil, {
                        message = "-1 Mano, -2 Descartes",
                        colour = G.C.RED,
                        delay = 0.6
                    })
                    return true
                end
            }))
            
            -- Mostrar beneficio constante
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.9,
                func = function()
                    card_eval_status_text(card, 'extra', nil, nil, nil, {
                        message = "+$15 cada ronda",
                        colour = G.C.MONEY,
                        delay = 0.6
                    })
                    return true
                end
            }))
            
            print("DEBUG: IV Bag añadido - Penalty aplicado: -1 Mano, -2 Descartes. Beneficio: +$15 cada ronda")
        end
    end,
    
    remove_from_deck = function(self, card, from_debuff)
        -- Al remover, restaurar las manos y descartes (si es posible)
        if card then
            -- Restaurar modificadores permanentes
            G.GAME.round_resets.hands = G.GAME.round_resets.hands + 1
            G.GAME.round_resets.discards = G.GAME.round_resets.discards + 2
            
            -- Restaurar en la ronda actual si está activa
            if G.GAME.current_round then
                G.GAME.current_round.hands_left = G.GAME.current_round.hands_left + 1
                G.GAME.current_round.discards_left = G.GAME.current_round.discards_left + 2
            end
            
            print("DEBUG: IV Bag removido - Manos y descartes restaurados")
        end
    end
}
