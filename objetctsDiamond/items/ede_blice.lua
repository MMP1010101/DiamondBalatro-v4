-- ede_blice.lua - Isaac Items: The D6
-- Te da un ítem al iniciar una nueva partida si tienes esta carta

return {
    key = 'ede_blice',
    loc_txt = {
        name = 'The D6',
        text = {
            'Al {C:attention}iniciar{} una nueva partida,',
            'te da un {C:green}ítem consumible{} aleatorio',
            '{C:inactive}(Solo si tienes esta carta)'
        }
    },
    config = {
        extra = {
            item_given = false -- Para trackear si ya se dio el ítem
        }
    },
    rarity = 1, -- Common
    cost = 4,
    unlocked = true,
    discovered = true,
    blueprint_compat = false, -- No se puede copiar porque es un efecto único
    eternal_compat = true,
    effect = "",
    cost_mult = 1.0,
    pos = { x = 0, y = 0 },
    atlas = 'od_ede_blice',
    
    loc_vars = function(self, info_queue, center)
        return {}
    end,
    
    calculate = function(self, card, context)
        -- El efecto principal se maneja en add_to_deck
        return nil
    end,
    
    add_to_deck = function(self, card, from_debuff)
        -- Hook para detectar cuando se inicia una nueva partida
        if G.GAME and G.GAME.round == 0 and not card.ability.extra.item_given then
            -- Lista de ítems consumibles que puede dar
            local possible_items = {
                'c_fool', 'c_magician', 'c_high_priestess', 'c_empress', 'c_emperor',
                'c_hierophant', 'c_lovers', 'c_chariot', 'c_justice', 'c_hermit',
                'c_wheel_of_fortune', 'c_strength', 'c_hanged_man', 'c_death',
                'c_temperance', 'c_devil', 'c_tower', 'c_star', 'c_moon', 'c_sun',
                'c_judgement', 'c_world'
            }
            
            -- Elegir un ítem aleatorio
            local chosen_item = pseudorandom_element(possible_items, pseudoseed('ede_blice'))
            
            -- Crear el consumible
            if chosen_item then
                local consumable = create_card('Tarot', G.consumeables, nil, nil, nil, nil, chosen_item, 'ede_blice')
                consumable:add_to_deck()
                G.consumeables:emplace(consumable)
                
                -- Marcar que ya se dio el ítem
                card.ability.extra.item_given = true
                
                -- Feedback visual
                card_eval_status_text(card, 'extra', nil, nil, nil, {
                    message = "¡Ítem otorgado!",
                    colour = G.C.GREEN,
                    delay = 0.45
                })
                
                -- Efecto de partículas
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.2,
                    func = function()
                        attention_text({
                            text = "The D6!",
                            scale = 1.3,
                            hold = 1.4,
                            cover = card,
                            align = 'cm',
                            offset = {x = 0, y = -0.05},
                            major = card
                        })
                        return true
                    end
                }))
            end
        end
    end,
    
    remove_from_deck = function(self, card, from_debuff)
        -- Resetear el estado si se quita la carta
        if card and card.ability and card.ability.extra then
            card.ability.extra.item_given = false
        end
    end
}
