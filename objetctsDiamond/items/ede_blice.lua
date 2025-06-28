-- ede_blice.lua - Isaac Items: The D6
-- Te da un ítem al iniciar una nueva partida si tienes esta carta

return {
    key = 'ede_blice',
    loc_txt = {
        name = 'The D6',
        text = {
            'Al {C:attention}iniciar{} una nueva partida',
            'o {C:attention}reiniciar con R{}, te da',
            '{C:blue}1 Joker{} y {C:green}1 consumible{} al azar',
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
        -- Debug para ver qué contextos se están disparando
        if context.joker_main then
            print("DEBUG: context.joker_main disparado, hands_played: " .. (G.GAME.current_round.hands_played or "nil") .. ", item_given: " .. tostring(card.ability.extra.item_given))
        end
        return nil
    end,
    
    add_to_deck = function(self, card, from_debuff)
        -- Activar inmediatamente cuando se añade al mazo al inicio de partida
        print("DEBUG: add_to_deck llamado, from_debuff: " .. tostring(from_debuff) .. ", item_given: " .. tostring(card.ability.extra.item_given))
        
        -- Añadir un pequeño delay para asegurar que G.consumeables y G.jokers estén disponibles
        if not card.ability.extra.item_given then
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.1,
                func = function()
                    -- Lista de ítems consumibles que puede dar
                    local possible_items = {
                        'c_fool', 'c_magician', 'c_high_priestess', 'c_empress', 'c_emperor',
                        'c_hierophant', 'c_lovers', 'c_chariot', 'c_justice', 'c_hermit',
                        'c_wheel_of_fortune', 'c_strength', 'c_hanged_man', 'c_death',
                        'c_temperance', 'c_devil', 'c_tower', 'c_star', 'c_moon', 'c_sun',
                        'c_judgement', 'c_world'
                    }
                    
                    -- Lista de jokers comunes que puede dar
                    local possible_jokers = {
                        'j_joker', 'j_greedy_joker', 'j_lusty_joker', 'j_wrathful_joker',
                        'j_gluttonous_joker', 'j_jolly', 'j_zany', 'j_mad', 'j_crazy',
                        'j_droll', 'j_sly', 'j_wily', 'j_clever', 'j_devious',
                        'j_crafty', 'j_half', 'j_stencil', 'j_four_fingers',
                        'j_mime', 'j_credit_card', 'j_ceremonial', 'j_banner',
                        'j_mystic_summit', 'j_marble', 'j_loyalty_card', 'j_8_ball',
                        'j_misprint', 'j_dusk', 'j_raised_fist', 'j_chaos',
                        'j_fibonacci', 'j_steel_joker', 'j_scary_face', 'j_abstract',
                        'j_delayed_grat', 'j_hack', 'j_pareidolia', 'j_gros_michel',
                        'j_even_steven', 'j_odd_todd', 'j_scholar', 'j_business',
                        'j_supernova', 'j_ride_the_bus', 'j_space', 'j_egg',
                        'j_burglar', 'j_blackboard', 'j_runner', 'j_ice_cream',
                        'j_dna', 'j_splash', 'j_blue_joker', 'j_sixth_sense',
                        'j_constellation', 'j_hiker', 'j_faceless', 'j_green_joker',
                        'j_superposition', 'j_todo_list', 'j_cavendish', 'j_card_sharp',
                        'j_red_card', 'j_madness', 'j_square', 'j_seance',
                        'j_riff_raff', 'j_vampire', 'j_shortcut', 'j_hologram',
                        'j_vagabond', 'j_baron', 'j_cloud_9', 'j_rocket',
                        'j_obelisk', 'j_midas_mask', 'j_luchador', 'j_photograph',
                        'j_gift', 'j_turtle_bean', 'j_erosion', 'j_reserved_parking',
                        'j_mail', 'j_to_the_moon', 'j_hallucination', 'j_fortune_teller',
                        'j_juggler', 'j_drunkard', 'j_stone', 'j_golden',
                        'j_lucky_cat', 'j_baseball', 'j_bull', 'j_diet_cola',
                        'j_trading', 'j_flash', 'j_popcorn', 'j_trousers',
                        'j_ancient', 'j_ramen', 'j_walkie_talkie', 'j_selzer',
                        'j_castle', 'j_smiley', 'j_campfire', 'j_golden_ticket',
                        'j_mr_bones', 'j_acrobat', 'j_sock_and_buskin', 'j_swashbuckler',
                        'j_troubadour', 'j_certificate', 'j_smeared', 'j_throwback',
                        'j_hanging_chad', 'j_rough_gem', 'j_bloodstone', 'j_arrowhead',
                        'j_onyx_agate', 'j_glass', 'j_ring_master', 'j_flower_pot',
                        'j_blueprint', 'j_wee', 'j_merry_andy', 'j_oops',
                        'j_idol', 'j_seeing_double', 'j_matador', 'j_hit_the_road',
                        'j_duo', 'j_trio', 'j_family', 'j_order', 'j_tribe'
                    }
                    
                    -- Elegir un ítem aleatorio
                    local chosen_item = pseudorandom_element(possible_items, pseudoseed('ede_blice_item'))
                    
                    -- Elegir un joker aleatorio
                    local chosen_joker = pseudorandom_element(possible_jokers, pseudoseed('ede_blice_joker'))
                    
                    local items_created = 0
                    
                    -- Crear el consumible
                    if chosen_item and G.consumeables then
                        local consumable = create_card('Tarot', G.consumeables, nil, nil, nil, nil, chosen_item, 'ede_blice')
                        if consumable then
                            consumable:add_to_deck()
                            G.consumeables:emplace(consumable)
                            items_created = items_created + 1
                            print("DEBUG: Creado consumible: " .. chosen_item)
                        end
                    end
                    
                    -- Crear el joker
                    if chosen_joker and G.jokers then
                        local joker = create_card('Joker', G.jokers, nil, nil, nil, nil, chosen_joker, 'ede_blice')
                        if joker then
                            joker:add_to_deck()
                            G.jokers:emplace(joker)
                            items_created = items_created + 1
                            print("DEBUG: Creado joker: " .. chosen_joker)
                        end
                    end
                    
                    -- Solo marcar como usado si se crearon ítems exitosamente
                    if items_created > 0 then
                        card.ability.extra.item_given = true
                        print("DEBUG: ede_blice activado! Items creados: " .. items_created)
                        
                        -- Feedback visual
                        card_eval_status_text(card, 'extra', nil, nil, nil, {
                            message = "¡Ítems otorgados!",
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
                    else
                        print("DEBUG: No se pudieron crear ítems")
                    end
                    
                    return true
                end
            }))
        else
            print("DEBUG: Item ya fue dado anteriormente")
        end
    end,
    
    remove_from_deck = function(self, card, from_debuff)
        -- Resetear el estado si se quita la carta
        if card and card.ability and card.ability.extra then
            card.ability.extra.item_given = false
        end
    end
}
