-- Isaac Skull Joker
-- Mysterious skull from the depths

local isaac_skull = {
    key = "isaac_skull",
    config = {},
    pos = { x = 2, y = 0 },
    loc_txt = {
        name = "Cursed Skull",
        text = {
            "A haunted skull from",
            "the basement's depths",
            "{C:chips}+30{} Chips"
        }
    },
    cost = 5,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    rarity = 2,
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                message = localize{type='variable',key='a_chips',vars={30}},
                chip_mod = 30
            }
        end
    end
}

return isaac_skull
