-- mushroom.lua - Isaac Items: Mushroom
-- +1 descarte, +1 mano, +$3 al final de ronda, +3 Mult

return {
    key = 'mushroom',
    loc_txt = {
        name = 'Mushroom',
        text = {
            '{C:blue}+1{} mano, {C:red}+1{} descarte',
            '{C:mult}+3{} Mult, {C:money}+$3{} al final de ronda',
            '{C:inactive}(Pequeño pero poderoso)'
        }
    },
    config = {
        extra = {
            mult = 3,
            money = 3,
            h_plays = 1,
            discards = 1,
            money_given_this_round = false  -- Flag para evitar duplicados
        }
    },
    rarity = 2, -- Uncommon - bonificaciones moderadas pero múltiples
    cost = 6,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    effect = "",
    cost_mult = 1.0,
    pos = { x = 0, y = 0 },
    atlas = 'od_mushroom',
    
    loc_vars = function(self, info_queue, center)
        return {vars = {center.ability.extra.h_plays, center.ability.extra.discards, center.ability.extra.mult, center.ability.extra.money}}
    end,
    
    calculate = function(self, card, context)
        -- Dar multiplicador sumativo durante la mano
        if context.joker_main then
            return {
                message = localize('k_mult'),
                mult_mod = card.ability.extra.mult,
                colour = G.C.MULT,
                card = card
            }
        end
        
        -- Dar dinero al final de la ronda
        if context.end_of_round and not context.individual and not context.repetition then
            -- Solo dar dinero si no se ha dado ya en esta ronda
            if not card.ability.extra.money_given_this_round then
                card.ability.extra.money_given_this_round = true
                
                -- Efectos visuales del dinero ganado
                G.E_MANAGER:add_event(Event({
                    func = function()
                        -- Animación de crecimiento
                        card:juice_up(0.7, 0.7)
                        
                        -- Sonidos de dinero
                        play_sound('coin1', 1.2, 0.6)
                        
                        -- Texto flotante mostrando el dinero ganado
                        attention_text({
                            text = "+$" .. card.ability.extra.money,
                            scale = 1.3,
                            hold = 0.8,
                            major = card,
                            backdrop_colour = G.C.MONEY,
                            align = 'cm',
                            offset = {x = 0, y = -1.5}
                        })
                        
                        return true
                    end
                }))
                
                return {
                    message = localize('$') .. card.ability.extra.money,
                    dollars = card.ability.extra.money,
                    colour = G.C.MONEY,
                    card = card
                }
            end
        end
        
        -- Resetear el flag al inicio de nueva ronda
        if context.setting_blind and not card.ability.extra.money_given_this_round then
            card.ability.extra.money_given_this_round = false
        end
        
        return nil
    end,
    
    add_to_deck = function(self, card, from_debuff)
        -- Aumentar manos y descartes cuando se añade al mazo
        if card then
            G.GAME.round_resets.hands = G.GAME.round_resets.hands + card.ability.extra.h_plays
            G.GAME.round_resets.discards = G.GAME.round_resets.discards + card.ability.extra.discards
            
            -- Aplicar a la ronda actual también
            ease_hands_played(card.ability.extra.h_plays)
            ease_discard(card.ability.extra.discards)
            
            -- Feedback visual
            card_eval_status_text(card, 'extra', nil, nil, nil, {
                message = "¡Potenciado!",
                colour = G.C.GREEN,
                delay = 0.45
            })
            
            print("DEBUG: mushroom añadido - +" .. card.ability.extra.h_plays .. " mano, +" .. card.ability.extra.discards .. " descarte")
        end
    end,
    
    remove_from_deck = function(self, card, from_debuff)
        -- Quitar manos y descartes cuando se remueve del mazo
        if card then
            G.GAME.round_resets.hands = G.GAME.round_resets.hands - card.ability.extra.h_plays
            G.GAME.round_resets.discards = G.GAME.round_resets.discards - card.ability.extra.discards
            
            -- Asegurarse de que no bajen de los mínimos
            if G.GAME.round_resets.hands < 3 then
                G.GAME.round_resets.hands = 3
            end
            if G.GAME.round_resets.discards < 3 then
                G.GAME.round_resets.discards = 3
            end
            
            print("DEBUG: mushroom removido del mazo")
        end
    end
}
