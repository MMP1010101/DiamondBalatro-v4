-- Clavos - Isaac Item
-- Da 1.1x multiplicador por cada carta puntuada

return {
    key = "clavos",
    loc_txt = {
        name = "Clavos",
        text = {
            "{X:mult,C:white}X#1#{} Mult por cada",
            "carta {C:attention}puntuada{}",
            "{C:inactive}(Con cartas actuales: {X:mult,C:white}X#2#{C:inactive})"
        }
    },
    config = {
        extra = {
            x_mult_per_card = 1.1,
            x_mult = 1
        }
    },
    rarity = 1, -- Common
    cost = 6,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    effect = "",
    cost_mult = 1.0,
    pos = {x = 0, y = 0},
    atlas = "od_clavos",
    
    calculate = function(self, card, context)
        -- Actualizar el multiplicador basado en las cartas puntuadas
        if context.joker_main and context.scoring_hand then
            local scoring_cards = #context.scoring_hand
            if scoring_cards > 0 then
                -- Calcular el multiplicador: 1.1 elevado a la potencia del número de cartas puntuadas
                local mult_value = card.ability.extra.x_mult_per_card ^ scoring_cards
                
                return {
                    message = "X" .. mult_value .. " (" .. scoring_cards .. " cartas)",
                    Xmult_mod = mult_value,
                    colour = G.C.MULT,
                    card = card
                }
            end
        end
        
        -- Actualizar el valor mostrado en la descripción
        if context.end_of_round and not context.individual and not context.repetition then
            -- Este contexto se usa para actualizar la descripción de la carta
            local last_scoring_cards = G.GAME.last_hand_played and #G.GAME.last_hand_played or 5
            card.ability.extra.x_mult = card.ability.extra.x_mult_per_card ^ last_scoring_cards
        end
    end,
    
    -- Función para mostrar las variables en la descripción
    loc_def = function(self, card)
        local scoring_cards = 0
        if G.hand and G.hand.highlighted then
            scoring_cards = #G.hand.highlighted
        elseif G.GAME.last_hand_played then
            scoring_cards = #G.GAME.last_hand_played
        else
            scoring_cards = 5 -- Valor por defecto
        end
        
        local current_mult = card.ability.extra.x_mult_per_card ^ math.max(1, scoring_cards)
        
        return {
            card.ability.extra.x_mult_per_card,
            current_mult
        }
    end,
    
    -- Función personalizada para generar la UI con información dinámica
    generate_ui = function(self, info_queue, card, desc_nodes, specific_vars, full_UI_table)
        local scoring_cards = 0
        if G.hand and G.hand.highlighted then
            scoring_cards = #G.hand.highlighted
        elseif G.GAME.last_hand_played then
            scoring_cards = #G.GAME.last_hand_played
        else
            scoring_cards = 5 -- Valor por defecto
        end
        
        local current_mult = card.ability.extra.x_mult_per_card ^ math.max(1, scoring_cards)
        local vars = {card.ability.extra.x_mult_per_card, current_mult}
        
        local desc_key = self.key
        if specific_vars and specific_vars.debuffed then
            desc_key = desc_key..'_debuffed'
        end
        
        local loc_colour = G.C.WHITE
        if current_mult >= 2 then
            loc_colour = G.C.GREEN
        elseif current_mult >= 1.5 then
            loc_colour = G.C.GOLD
        end
        
        -- Obtener la descripción base
        local desc_text = self.loc_txt.text
        
        -- Añadir información adicional
        local extended_desc = {}
        for i, line in ipairs(desc_text) do
            table.insert(extended_desc, line)
        end
        
        -- Añadir información específica sobre cartas seleccionadas/puntuadas
        if scoring_cards > 0 then
            local card_info = "{C:attention}" .. scoring_cards .. " cartas{} = {X:mult,C:white}X" .. string.format("%.2f", current_mult) .. "{} Mult"
            table.insert(extended_desc, card_info)
        end
        
        local first_pass = true
        for _, v in ipairs(extended_desc) do
            if not first_pass then
                loc_colour = G.C.WHITE
            end
            first_pass = false
            desc_nodes[#desc_nodes+1] = {}
            localize{type = 'other', key = v, nodes = desc_nodes[#desc_nodes], vars = vars, default_colours = {loc_colour}}
        end
    end
}
