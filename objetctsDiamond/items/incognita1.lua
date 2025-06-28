-- incognita1.lua - Isaac Items: Incognita
-- Automáticamente abre un Diamond Pack después de vencer la ciega pequeña

return {
    key = 'incognita1',
    loc_txt = {
        name = 'More Options',
        text = {
            'Después de vencer la {C:attention}Small Blind{}',
            'automáticamente abre un {C:attention}Diamond Pack',
            '{C:inactive}(Solo ciega pequeña)'
        }
    },
    config = {
        extra = {
            pack_opened_this_round = false  -- Flag para evitar múltiples packs
        }
    },
    rarity = 2, -- Uncommon - efecto útil pero no gamebreaking
    cost = 7,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    effect = "",
    cost_mult = 1.0,
    pos = { x = 0, y = 0 },
    atlas = 'od_incognita1',
    
    loc_vars = function(self, info_queue, center)
        return {}
    end,
    
    calculate = function(self, card, context)
        -- Activar después de vencer SOLO la ciega pequeña (small blind)
        if context.end_of_round and not context.individual and not context.repetition then
            -- Verificar que acabamos de vencer la small blind
            local is_small_blind = false
            
            if G.GAME.blind and G.GAME.blind.config and G.GAME.blind.config.blind then
                local blind_info = G.GAME.blind.config.blind
                -- Small blind: no boss y nombre contiene "Small Blind"
                if blind_info.boss == nil and blind_info.name and tostring(blind_info.name):find("Small Blind") then
                    is_small_blind = true
                end
            end
            
            print("DEBUG: incognita1 - Verificando small blind: " .. tostring(is_small_blind))
            if G.GAME.blind and G.GAME.blind.config and G.GAME.blind.config.blind then
                local blind_info = G.GAME.blind.config.blind
                print("DEBUG: Ciega actual - boss: " .. tostring(blind_info.boss) .. ", name: " .. tostring(blind_info.name))
            end
            
            if is_small_blind then
                print("DEBUG: incognita1 - Detectada small blind vencida")
                
                -- Solo abrir pack si no se ha abierto ya en esta ronda
                if not card.ability.extra.pack_opened_this_round then
                    card.ability.extra.pack_opened_this_round = true
                    
                    print("DEBUG: incognita1 - Small blind vencida, abriendo Diamond Pack")
                    
                    -- Crear y abrir el Diamond Pack automáticamente
                    G.E_MANAGER:add_event(Event({
                        trigger = 'after',
                        delay = 0.5,
                        func = function()
                            -- Animación de la carta
                            card:juice_up(1.2, 1.2)
                            
                            -- Sonidos misteriosos
                            play_sound('card1', 1.0, 0.6)
                            play_sound('generic1', 0.8, 0.5)
                            
                            -- Texto flotante
                            attention_text({
                                text = "¡MORE OPTIONS!",
                                scale = 1.4,
                                hold = 1.5,
                                major = card,
                                backdrop_colour = G.C.BLUE,
                                align = 'cm',
                                offset = {x = 0, y = -2}
                            })
                            
                            return true
                        end
                    }))
                    
                    -- Crear el Diamond Pack
                    G.E_MANAGER:add_event(Event({
                        trigger = 'after',
                        delay = 1.0,
                        func = function()
                            -- Crear el pack usando el sistema estándar de Balatro
                            local pack_key = 'p_od_diamond_pack_normal_1'
                            print("DEBUG: Creando pack con key: " .. pack_key)
                            
                            -- Verificar que el pack existe
                            if G.P_CENTERS[pack_key] then
                                print("DEBUG: Pack encontrado en G.P_CENTERS")
                                
                                -- Crear el pack de manera más directa
                                local pack = Card(G.play.T.x + G.play.T.w/2 - G.CARD_W*1.27/2,
                                                G.play.T.y + G.play.T.h/2-G.CARD_H*1.27/2, 
                                                G.CARD_W*1.27, G.CARD_H*1.27, 
                                                G.P_CARDS.empty, G.P_CENTERS[pack_key])
                                
                                pack.cost = 0 -- Gratis porque es automático
                                pack.from_tag = true
                                G.play:emplace(pack)
                                pack:start_materialize()
                                
                                -- Sonido de aparición del pack
                                play_sound('card1', 1.2, 0.7)
                                print("DEBUG: Pack creado y materializado")
                                
                                -- Abrir automáticamente después de un momento
                                G.E_MANAGER:add_event(Event({
                                    trigger = 'after',
                                    delay = 1.0,
                                    func = function()
                                        if pack and pack.area then
                                            pack:open()
                                            print("DEBUG: Pack abierto automáticamente")
                                        else
                                            print("DEBUG: Error - pack no válido para abrir")
                                        end
                                        return true
                                    end
                                }))
                            else
                                print("DEBUG: ERROR - Pack " .. pack_key .. " no encontrado en G.P_CENTERS")
                                -- Listar packs disponibles para debug
                                print("DEBUG: Packs disponibles:")
                                for k, v in pairs(G.P_CENTERS) do
                                    if k:match("p_od_") then
                                        print("  - " .. k)
                                    end
                                end
                            end
                            
                            return true
                        end
                    }))
                    
                    return {
                        message = "¡Small Blind vencida!",
                        colour = G.C.BLUE,
                        card = card
                    }
                else
                    print("DEBUG: incognita1 - Pack ya abierto esta ronda")
                end
            else
                print("DEBUG: incognita1 - No es small blind")
            end
        end
        
        -- Resetear el flag al inicio de nueva ronda
        if context.setting_blind then
            card.ability.extra.pack_opened_this_round = false
            print("DEBUG: incognita1 - Flag reseteado para nueva ronda")
        end
        
        return nil
    end,
    
    add_to_deck = function(self, card, from_debuff)
        -- Feedback visual cuando se añade al mazo
        if card then
            card_eval_status_text(card, 'extra', nil, nil, nil, {
                message = "¿Misterio?",
                colour = G.C.PURPLE,
                delay = 0.45
            })
            
            print("DEBUG: incognita1 añadido al mazo - Pack automático activado")
        end
    end,
    
    remove_from_deck = function(self, card, from_debuff)
        -- Feedback cuando se quita del mazo
        if card then
            print("DEBUG: incognita1 removido del mazo")
        end
    end
}
