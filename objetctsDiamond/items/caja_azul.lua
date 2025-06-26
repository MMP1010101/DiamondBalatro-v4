-- Caja Azul Joker
-- Blue box item from Isaac

local isaac_cube = {
    object_type = "Joker",
    name = "caja_azul",
    key = "caja_azul",
    config = {},
    pos = { x = 0, y = 0 },
    loc_txt = {
        name = "Caja Azul",
        text = {
            "{C:mult}+4{} Mult",
            "Cuando se vende, da recompensa",
            "basada en el {C:attention}Ante{} actual"
        }
    },
    cost = 6,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    effect = "",
    cost_mult = 1.0,
    rarity = 2,
    atlas = "od_caja_azul",
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                message = localize{type='variable',key='a_mult',vars={4}},
                mult_mod = 4
            }
        end
        
        if context.selling_self then
            local ante = G.GAME.round_resets.ante or 1
            local rewards = {
                [1] = {type = "money", amount = 8},
                [2] = {type = "joker", rarity = 1},
                [3] = {type = "money", amount = 15},
                [4] = {type = "tarot", count = 2},
                [5] = {type = "money", amount = 25},
                [6] = {type = "planet", count = 1},
                [7] = {type = "money", amount = 35},
                [8] = {type = "spectral", count = 1},
                [9] = {type = "money", amount = 50},
                [10] = {type = "joker", rarity = 2},
                [11] = {type = "money", amount = 60},
                [12] = {type = "voucher", count = 1},
                [13] = {type = "money", amount = 80},
                [14] = {type = "joker", rarity = 3},
                [15] = {type = "money", amount = 100}
            }
            
            local reward = rewards[math.min(ante, 15)] or rewards[15]
            
            if reward.type == "money" then
                ease_dollars(reward.amount)
                card_eval_status_text(card, 'extra', nil, nil, nil, {message = "$"..reward.amount})
            elseif reward.type == "joker" then
                G.E_MANAGER:add_event(Event({func = function()
                    local new_card = create_card('Joker', G.jokers, nil, reward.rarity)
                    new_card:add_to_deck()
                    G.jokers:emplace(new_card)
                    return true
                end}))
                card_eval_status_text(card, 'extra', nil, nil, nil, {message = "Joker!"})
            elseif reward.type == "tarot" then
                for i = 1, reward.count do
                    G.E_MANAGER:add_event(Event({func = function()
                        local new_card = create_card('Tarot', G.consumeables)
                        new_card:add_to_deck()
                        G.consumeables:emplace(new_card)
                        return true
                    end}))
                end
                card_eval_status_text(card, 'extra', nil, nil, nil, {message = reward.count.." Tarot"})
            elseif reward.type == "planet" then
                G.E_MANAGER:add_event(Event({func = function()
                    local new_card = create_card('Planet', G.consumeables)
                    new_card:add_to_deck()
                    G.consumeables:emplace(new_card)
                    return true
                end}))
                card_eval_status_text(card, 'extra', nil, nil, nil, {message = "Planet!"})
            elseif reward.type == "spectral" then
                G.E_MANAGER:add_event(Event({func = function()
                    local new_card = create_card('Spectral', G.consumeables)
                    new_card:add_to_deck()
                    G.consumeables:emplace(new_card)
                    return true
                end}))
                card_eval_status_text(card, 'extra', nil, nil, nil, {message = "Spectral!"})
            elseif reward.type == "voucher" then
                G.E_MANAGER:add_event(Event({func = function()
                    local voucher = get_next_voucher_key()
                    if voucher then
                        G.GAME.used_vouchers[voucher] = true
                        card_eval_status_text(card, 'extra', nil, nil, nil, {message = "Voucher!"})
                    end
                    return true
                end}))
            end
        end
    end
}

return isaac_cube
