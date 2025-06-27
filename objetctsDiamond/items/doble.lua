-- 20/20 Joker
-- Aplica el efecto blueprint a 2 Jokers aleatorios

local doble_joker = {
    object_type = "Joker",
    name = "doble",
    key = "doble",
    config = {},
    pos = { x = 0, y = 0 },
    loc_txt = {
        name = "20/20",
        text = {
            "Aplica el efecto {C:dark_edition}Blueprint{}",
            "a {C:attention}2{} Jokers aleatorios",
            "(excepto a sí mismo)"
        }
    },
    cost = 8,
    unlocked = true,
    discovered = true,
    blueprint_compat = false, -- No puede ser blueprinted
    eternal_compat = true,
    effect = "Blueprint Random",
    cost_mult = 1.0,
    rarity = 3, -- Legendary
    atlas = "od_doble"
}

-- Función calculate del Doble Joker
doble_joker.calculate = function(self, card, context)
    -- Solo procesar durante la evaluación de jokers
    if context.joker_main then
        -- Obtener todos los jokers válidos (excluyendo este)
        local other_jokers = {}
        for i = 1, #G.jokers.cards do
            local other_joker = G.jokers.cards[i]
            if other_joker ~= card and not other_joker.debuff then
                table.insert(other_jokers, other_joker)
            end
        end
        
        -- Si hay jokers disponibles
        if #other_jokers > 0 then
            -- Determinar cuántos jokers copiar (máximo 2, o todos los disponibles si hay menos)
            local num_to_copy = math.min(2, #other_jokers)
            
            -- Seleccionar jokers aleatorios
            local selected_jokers = {}
            local temp_jokers = {}
            for i, j in ipairs(other_jokers) do
                temp_jokers[i] = j
            end
            
            for i = 1, num_to_copy do
                local random_index = pseudorandom('doble'..G.GAME.round_resets.ante, 1, #temp_jokers)
                table.insert(selected_jokers, temp_jokers[random_index])
                table.remove(temp_jokers, random_index)
            end
            
            -- Aplicar el efecto de cada joker seleccionado
            local ret = {}
            for _, target_joker in ipairs(selected_jokers) do
                -- Usar el método exacto de Blueprint
                if target_joker and target_joker ~= card and target_joker.config.center.blueprint_compat then
                    local old_context_blueprint = context.blueprint
                    context.blueprint = (context.blueprint and (context.blueprint + 1)) or 1
                    local old_context_blueprint_card = context.blueprint_card
                    context.blueprint_card = context.blueprint_card or card
                    
                    local eval = target_joker:calculate_joker(context)
                    
                    -- Restaurar contexto
                    context.blueprint = old_context_blueprint
                    context.blueprint_card = old_context_blueprint_card
                    
                    if eval then
                        -- Ajustar la carta de efectos
                        eval.card = card
                        eval.colour = G.C.BLUE
                        
                        -- Mostrar qué joker se está copiando
                        card_eval_status_text(card, 'extra', nil, nil, nil, {
                            message = "Copiando: " .. (target_joker.config.center.name or "Joker"),
                            colour = G.C.BLUE,
                            card = target_joker
                        })
                        
                        -- Acumular efectos
                        if eval.mult_mod then
                            ret.mult_mod = (ret.mult_mod or 0) + eval.mult_mod
                        end
                        if eval.chip_mod then  
                            ret.chip_mod = (ret.chip_mod or 0) + eval.chip_mod
                        end
                        if eval.Xmult_mod then
                            ret.Xmult_mod = (ret.Xmult_mod or 1) * eval.Xmult_mod
                        end
                        if eval.x_mult then
                            ret.x_mult = (ret.x_mult or 1) * eval.x_mult
                        end
                        
                        -- También manejar otros efectos
                        if eval.dollars then
                            ret.dollars = (ret.dollars or 0) + eval.dollars
                        end
                    end
                end
            end
            
            -- Retornar efectos acumulados si hay alguno
            if ret.mult_mod or ret.chip_mod or ret.Xmult_mod or ret.x_mult or ret.dollars then
                return ret
            end
        end
    end
end

return doble_joker
