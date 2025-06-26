-- Isaac Trinket Joker
-- Special trinket with ribbon

local isaac_trinket = {
    key = "isaac_trinket",
    config = {},
    pos = { x = 3, y = 0 },
    loc_txt = {
        name = "Lucky Trinket",
        text = {
            "A trinket tied with",
            "a blue ribbon",
            "{X:mult,C:white}X1.5{} Mult if hand",
            "has {C:attention}pairs{}"
        }
    },
    cost = 7,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    rarity = 3,
    calculate = function(self, card, context)
        if context.joker_main then
            if next(context.poker_hands['Pair']) then
                return {
                    message = localize{type='variable',key='a_xmult',vars={1.5}},
                    Xmult_mod = 1.5
                }
            end
        end
    end
}

return isaac_trinket
