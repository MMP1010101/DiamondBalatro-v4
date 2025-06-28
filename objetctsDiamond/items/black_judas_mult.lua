-- black_judas_mult.lua - Joker invisible que da el multiplicador permanente de Black Judas
-- Este joker se crea automáticamente cuando Black Judas se sacrifica

return {
    key = 'black_judas_mult',
    loc_txt = {
        name = 'Dark Power',
        text = {
            '{X:mult,C:white}X2{} Mult',
            '{C:inactive}(Poder de Black Judas)'
        }
    },
    config = {
        extra = {
            x_mult = 2  -- Multiplicador que otorga
        }
    },
    rarity = 4, -- Legendary - porque es permanente y poderoso
    cost = 0, -- No se puede comprar
    unlocked = false, -- No aparece normalmente
    discovered = false, -- Invisible en colección
    blueprint_compat = true,
    eternal_compat = true,
    effect = "",
    cost_mult = 1.0,
    pos = { x = 0, y = 0 },
    atlas = 'od_black_judas', -- Usa la misma imagen que Black Judas
    
    loc_vars = function(self, info_queue, center)
        return {vars = {center.ability.extra.x_mult}}
    end,
    
    calculate = function(self, card, context)
        -- Dar multiplicador en cada mano jugada
        if context.joker_main then
            return {
                x_mult = card.ability.extra.x_mult,
                colour = G.C.MULT,
                card = card
            }
        end
        
        return nil
    end,
    
    add_to_deck = function(self, card, from_debuff)
        -- Feedback visual cuando se añade (aunque sea invisible)
        if card then
            print("DEBUG: Dark Power (Black Judas multiplicador) añadido - X" .. card.ability.extra.x_mult .. " Mult permanente")
        end
    end,
    
    remove_from_deck = function(self, card, from_debuff)
        -- Log cuando se quita
        if card then
            print("DEBUG: Dark Power removido del mazo")
        end
    end
}
