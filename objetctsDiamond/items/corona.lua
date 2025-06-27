-- Corona - Isaac Item
-- Empieza con 4x Mult, baja 1x por cada mano o descarte usado

return {
    key = "corona",
    loc_txt = {
        name = "Corona",
        text = {
            "{X:mult,C:white}X#1#{} Mult",
            "Pierde {X:mult,C:white}X1{} Mult cada vez",
            "que uses una {C:blue}mano{} o {C:red}descarte{}",
            "Se {C:gold}restaura a X5{} al ganar cada {C:attention}ciega{}",
            "{C:inactive}(Mínimo {X:mult,C:white}X1{C:inactive} Mult)"
        }
    },
    config = {
        extra = {
            x_mult = 5,
            min_mult = 1
        }
    },
    rarity = 3, -- Rare
    cost = 8,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    effect = "",
    cost_mult = 1.0,
    pos = {x = 0, y = 0},
    atlas = "od_corona",
    
    calculate = function(self, card, context)
        -- Dar el multiplicador cuando se evalúan los jokers
        if context.joker_main then
            return {
                message = localize{type='variable', key='a_xmult', vars={card.ability.extra.x_mult}},
                Xmult_mod = card.ability.extra.x_mult,
                colour = G.C.MULT,
                card = card
            }
        end
        
        -- Resetear multiplicador cuando se gana cualquier ciega
        -- Usar múltiples contextos para asegurar que funcione
        if (context.end_of_round or context.setting_blind or context.first_hand_drawn) and not context.blueprint then
            -- Verificar si hemos avanzado a una nueva ciega
            if not card.ability.corona_last_ante then
                card.ability.corona_last_ante = G.GAME.round_resets.ante or 1
                card.ability.corona_last_round = G.GAME.round_resets.blind_states.Small or 1
            end
            
            local current_ante = G.GAME.round_resets.ante or 1
            local current_round = G.GAME.round_resets.blind_states.Small or 1
            
            -- Si el ante o la ronda han cambiado, resetear la corona
            if (current_ante > card.ability.corona_last_ante or 
                current_round > card.ability.corona_last_round) and
                card.ability.extra.x_mult < 5 then
                
                card.ability.extra.x_mult = 5
                card.ability.corona_last_ante = current_ante
                card.ability.corona_last_round = current_round
                
                -- Mensaje visual de reinicio mejorado
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.2,
                    func = function()
                        card_eval_status_text(card, 'extra', nil, nil, nil, {
                            message = "¡CORONA RESTAURADA! X5",
                            colour = G.C.GOLD,
                            instant = true
                        })
                        card:juice_up(1.5, 1.5)
                        return true
                    end
                }))
            end
        end
        
        -- Método alternativo: resetear cuando se inicia una nueva ciega
        if context.setting_blind and not context.blueprint then
            if card.ability.extra.x_mult < 5 then
                card.ability.extra.x_mult = 5
                
                -- Mensaje visual de reinicio mejorado
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.5,
                    func = function()
                        card_eval_status_text(card, 'extra', nil, nil, nil, {
                            message = "¡CORONA RESTAURADA! X5",
                            colour = G.C.GOLD,
                            instant = true
                        })
                        card:juice_up(1.5, 1.5)
                        return true
                    end
                }))
            end
        end
        
        -- Reducir multiplicador cuando se usa una mano
        if context.before and not context.blueprint then
            if card.ability.extra.x_mult > card.ability.extra.min_mult then
                local old_mult = card.ability.extra.x_mult
                card.ability.extra.x_mult = card.ability.extra.x_mult - 1
                
                -- Mensaje visual mejorado
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.1,
                    func = function()
                        card_eval_status_text(card, 'extra', nil, nil, nil, {
                            message = "X" .. old_mult .. " → X" .. card.ability.extra.x_mult,
                            colour = G.C.RED,
                            instant = true
                        })
                        card:juice_up(0.8, 0.8)
                        return true
                    end
                }))
            end
        end
        
        -- También reducir cuando se hace un descarte
        if context.discard and not context.blueprint then
            -- Solo activar una vez por descarte (cuando no hay other_card)
            if not context.other_card and card.ability.extra.x_mult > card.ability.extra.min_mult then
                local old_mult = card.ability.extra.x_mult
                card.ability.extra.x_mult = card.ability.extra.x_mult - 1
                
                -- Mensaje visual mejorado
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.1,
                    func = function()
                        card_eval_status_text(card, 'extra', nil, nil, nil, {
                            message = "X" .. old_mult .. " → X" .. card.ability.extra.x_mult,
                            colour = G.C.RED,
                            instant = true
                        })
                        card:juice_up(0.8, 0.8)
                        return true
                    end
                }))
            end
        end
    end,
    
    -- Función para mostrar las variables en la descripción
    loc_def = function(self, card)
        return {
            card.ability.extra.x_mult
        }
    end,
    
    -- Función personalizada para generar la UI con información dinámica
    generate_ui = function(self, info_queue, card, desc_nodes, specific_vars, full_UI_table)
        local vars = {card.ability.extra.x_mult}
        local desc_key = self.key
        
        if specific_vars and specific_vars.debuffed then
            desc_key = desc_key..'_debuffed'
        end
        
        local loc_colour = G.C.WHITE
        if card.ability.extra.x_mult >= 5 then
            loc_colour = G.C.GOLD
        elseif card.ability.extra.x_mult <= 1 then
            loc_colour = G.C.RED
        elseif card.ability.extra.x_mult >= 3 then
            loc_colour = G.C.GREEN
        end
        
        -- Obtener la descripción base
        local desc_text = self.loc_txt.text
        
        -- Añadir información adicional del estado actual
        local extended_desc = {}
        for i, line in ipairs(desc_text) do
            table.insert(extended_desc, line)
        end
        
        local current_status = ""
        if card.ability.extra.x_mult >= 5 then
            current_status = "{C:gold}¡CORONA AL MÁXIMO!{}"
        elseif card.ability.extra.x_mult <= 1 then
            current_status = "{C:red}Corona agotada{}"
        else
            current_status = "{C:attention}Corona debilitándose{}"
        end
        
        table.insert(extended_desc, current_status)
        
        local first_pass = true
        for _, v in ipairs(extended_desc) do
            if not first_pass then
                loc_colour = G.C.WHITE
            end
            first_pass = false
            desc_nodes[#desc_nodes+1] = {}
            localize{type = 'other', key = v, nodes = desc_nodes[#desc_nodes], vars = vars, default_colours = {loc_colour}}
        end
    end,
    
    -- Función para cuando la carta se añade al deck
    add_to_deck = function(self, card, from_debuff)
        -- Asegurar que empiece con 5x mult
        card.ability.extra.x_mult = 5
        -- Inicializar variables de seguimiento
        card.ability.corona_last_ante = G.GAME.round_resets.ante or 1
        card.ability.corona_last_round = G.GAME.round_resets.blind_states.Small or 1
    end,
    
    -- Función para cuando se vende la carta (opcional, para debugging)
    remove_from_deck = function(self, card, from_debuff)
        -- Resetear el multiplicador por si se vuelve a usar
        card.ability.extra.x_mult = 5
    end
}
