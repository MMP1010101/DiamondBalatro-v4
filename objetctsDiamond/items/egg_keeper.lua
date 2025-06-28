-- egg_keeper.lua - Isaac Items: Keeper's Egg
-- Hace que el interés sea infinito (sin límite)

return {
    key = 'egg_keeper',
    loc_txt = {
        name = "Keeper's Egg",
        text = {
            'El {C:attention}interés{} no tiene límite',
            'Ganas {C:money}$1{} por cada {C:money}$5{} que tengas',
            '{C:green}sin límite máximo',
            '{C:inactive}(Interés infinito)'
        }
    },
    config = {
        extra = {}
    },
    rarity = 2, -- Uncommon
    cost = 6,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    effect = "",
    cost_mult = 1.0,
    pos = { x = 0, y = 0 },
    atlas = 'od_egg_keeper',
    
    loc_vars = function(self, info_queue, center)
        return {}
    end,
    
    calculate = function(self, card, context)
        -- Interceptar el contexto de final de ronda para modificar el interés
        if context.end_of_round and not context.individual and not context.repetition then
            -- El interés normalmente se calcula aquí, pero necesitamos interceptar antes
            if G.GAME and G.GAME.dollars then
                -- Calcular interés infinito (normalmente limitado a $5)
                local normal_interest = math.min(math.floor(G.GAME.dollars / 5), 5) -- Interés normal (máximo $5)
                local infinite_interest = math.floor(G.GAME.dollars / 5) -- Interés infinito
                local extra_interest = infinite_interest - normal_interest
                
                if extra_interest > 0 then
                    -- Dar el interés extra que supera el límite normal
                    ease_dollars(extra_interest)
                    
                    -- Feedback visual
                    card_eval_status_text(card, 'dollars', extra_interest, nil, nil, {
                        message = "¡Interés infinito!",
                        colour = G.C.MONEY,
                        delay = 0.45
                    })
                    
                    print("DEBUG: egg_keeper - Interés extra dado: $" .. extra_interest .. " (total: $" .. infinite_interest .. ")")
                    
                    return {
                        message = localize('k_plus_dollars'),
                        dollars = extra_interest,
                        colour = G.C.MONEY
                    }
                end
            end
        end
        return nil
    end,
    
    add_to_deck = function(self, card, from_debuff)
        -- Feedback visual cuando se añade al mazo
        if card then
            card_eval_status_text(card, 'extra', nil, nil, nil, {
                message = "¡Interés infinito!",
                colour = G.C.MONEY,
                delay = 0.45
            })
            
            print("DEBUG: egg_keeper añadido al mazo - Interés infinito activado")
        end
    end,
    
    remove_from_deck = function(self, card, from_debuff)
        -- Feedback cuando se quita del mazo
        if card then
            print("DEBUG: egg_keeper removido del mazo - Interés vuelve a normal")
        end
    end
}
