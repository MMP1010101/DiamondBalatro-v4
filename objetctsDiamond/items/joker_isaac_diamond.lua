-- Isaac Diamond Joker
-- Precious diamond from Isaac

local isaac_diamond = {
    key = "isaac_diamond",
    config = {},
    pos = { x = 1, y = 0 },
    loc_txt = {
        name = "Sacred Diamond",
        text = {
            "A brilliant diamond that",
            "reflects divine light",
            "{C:mult}+8{} Mult"
        }
    },
    cost = 8,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    rarity = 3,
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                message = localize{type='variable',key='a_mult',vars={8}},
                mult_mod = 8
            }
        end
    end
}

return isaac_diamond
