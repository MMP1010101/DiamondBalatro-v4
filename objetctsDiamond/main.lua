--- STEAMODDED HEADER
--- MOD_NAME: Objects Diamond - Isaac Items
--- MOD_ID: ObjectsDiamond
--- MOD_AUTHOR: [salva]
--- MOD_DESCRIPTION: Isaac-themed items for Balatro, organized structure
--- BADGE_COLOUR: 967BB6
--- PREFIX: od

----------------------------------------------
------------MOD CODE -------------------------

-- Initialize the mod
local mod_id = "ObjectsDiamond"
local mod_path = SMODS.current_mod.path

-- Load music system
local music_system = assert(loadfile(mod_path .. "music.lua"))()

-- Register atlases for sprites
SMODS.Atlas{
    key = "od_caja_azul",
    path = "caja_azul.png",
    px = 71,
    py = 95
}

SMODS.Atlas{
    key = "od_doble",
    path = "doble.png",
    px = 71,
    py = 95
}

SMODS.Atlas{
    key = "od_clavos",
    path = "clavos.png",
    px = 71,
    py = 95
}

SMODS.Atlas{
    key = "od_corona",
    path = "corona.png",
    px = 71,
    py = 95
}

SMODS.Atlas{
    key = "od_dead_day",
    path = "dead_day.png",
    px = 71,
    py = 95
}

SMODS.Atlas{
    key = "od_descarte",
    path = "descartes.png",
    px = 71,
    py = 95
}

SMODS.Atlas{
    key = "od_doble_bateria",
    path = "doble_bateria.png",
    px = 71,
    py = 95
}

SMODS.Atlas{
    key = "od_ede_blice",
    path = "ede_blice.png",
    px = 71,
    py = 95
}

SMODS.Atlas{
    key = "od_egg_keeper",
    path = "egg_keper.png",
    px = 71,
    py = 95
}

SMODS.Atlas{
    key = "od_god_head",
    path = "godheat.png",
    px = 71,
    py = 95
}

SMODS.Atlas{
    key = "od_mushroom",
    path = "hongo.png",
    px = 71,
    py = 95
}

SMODS.Atlas{
    key = "od_houli_shot",
    path = "houli_shot.png",
    px = 71,
    py = 95
}

SMODS.Atlas{
    key = "od_incognita1",
    path = "incognita1.png",
    px = 71,
    py = 95
}

SMODS.Atlas{
    key = "od_iv_bag",
    path = "iv_bag.png",
    px = 71,
    py = 95
}

SMODS.Atlas{
    key = "od_black_judas",
    path = "judas.png",
    px = 71,
    py = 95
}

SMODS.Atlas{
    key = "od_libra",
    path = "libra.png",
    px = 71,
    py = 95
}

-- Register atlas for booster pack
SMODS.Atlas{
    key = "od_diamond_pack",
    path = "diamond_pack_atlas.png",
    px = 57,  -- ¡DIMENSIONES CORRECTAS!
    py = 93   -- ¡DIMENSIONES CORRECTAS!
}


-- Load all items from the items folder
local function load_items()
    local items_path = mod_path .. "items/"
    
    -- List of item files to load
    local item_files = {
        "caja_azul.lua",
        "doble.lua",
        "clavos.lua",
        "corona.lua",
        "dead_day.lua",
        "descarte.lua",
        "doble_bateria.lua",
        "ede_blice.lua",
        "egg_keeper.lua",
        "god_head.lua",
        "mushroom.lua",
        "houli_shot.lua",
        "incognita1.lua",
        "iv_bag.lua",
        "black_judas.lua",
        "black_judas_mult.lua",
        "libra.lua"
    }
    
    -- Load each item file
    for _, file in ipairs(item_files) do
        local file_path = items_path .. file
        if NFS.getInfo(file_path) then
            local item_data = assert(loadfile(file_path))()
            if item_data then
                -- Register the joker with SMODS using correct syntax
                local joker_def = {
                    key = item_data.key,
                    loc_txt = item_data.loc_txt,
                    config = item_data.config,
                    rarity = item_data.rarity,
                    cost = item_data.cost,
                    unlocked = item_data.unlocked,
                    discovered = item_data.discovered,
                    blueprint_compat = item_data.blueprint_compat,
                    eternal_compat = item_data.eternal_compat,
                    effect = item_data.effect,
                    cost_mult = item_data.cost_mult,
                    pos = item_data.pos,
                    atlas = item_data.atlas,
                    calculate = item_data.calculate
                }
                
                -- Añadir funciones opcionales si existen
                if item_data.loc_def then
                    joker_def.loc_def = item_data.loc_def
                end
                -- Comentamos generate_ui temporalmente para evitar crashes
                -- if item_data.generate_ui then
                --     joker_def.generate_ui = item_data.generate_ui
                -- end
                if item_data.add_to_deck then
                    joker_def.add_to_deck = item_data.add_to_deck
                end
                if item_data.remove_from_deck then
                    joker_def.remove_from_deck = item_data.remove_from_deck
                end
                if item_data.loc_vars then
                    joker_def.loc_vars = item_data.loc_vars
                end
                
                SMODS.Joker(joker_def)
                
                print("Loaded Isaac item: " .. item_data.key)
            end
        else
            print("Warning: Could not find item file: " .. file)
        end
    end
end

-- Load booster packs from boosters folder
local function load_boosters()
    local boosters_path = mod_path .. "boosters/"
    
    -- Check if boosters directory exists
    if NFS.getInfo(boosters_path) then
        local booster_files = NFS.getDirectoryItems(boosters_path)
        
        for _, file in ipairs(booster_files) do
            if file:match("%.lua$") then
                print("Loading booster file: " .. file)
                local booster_data, load_error = SMODS.load_file("boosters/" .. file)
                
                if load_error then
                    print("Error loading booster " .. file .. ": " .. load_error)
                elseif booster_data then
                    local curr_booster = booster_data()
                    if curr_booster and curr_booster.init then 
                        curr_booster:init() 
                    end
                    
                    -- Register each booster pack in the list
                    if curr_booster and curr_booster.list then
                        for i, pack in ipairs(curr_booster.list) do
                            pack.discovered = true -- Para testing, puedes cambiar esto después
                            SMODS.Booster(pack)
                            print("Registered booster pack: " .. pack.name .. " (key: " .. pack.key .. ")")
                        end
                    end
                end
            end
        end
    else
        print("Boosters directory not found: " .. boosters_path)
    end
end

-- Load localization for booster packs
local function setup_booster_localization()
    -- Add localization for the booster packs
    G.localization.misc.dictionary["k_diamond_pack"] = "Diamond Pack"
    
    G.localization.descriptions["Other"] = G.localization.descriptions["Other"] or {}
    
    G.localization.descriptions["Other"]["p_od_diamond_pack_normal_1"] = {
        name = "Diamond Pack",
        text = {
            "Choose {C:attention}#1#{} of up to",
            "{C:attention}#2#{} {C:attention}Isaac Items{} to",
            "add to your collection"
        }
    }
end

-- Load all items when the mod initializes
load_items()

-- Setup booster pack localization
setup_booster_localization()

-- Load booster packs
load_boosters()

-- Initialize music system
if music_system then
    music_system.init()
    
    -- Only setup hooks if music system is enabled
    if music_system.config.enabled then
        music_system.setup_game_hooks()
        
        -- Test music files (optional, remove in production)
        music_system.test_music()
    end
end

print("Objects Diamond - Isaac Items mod loaded successfully!")

----------------------------------------------
------------MOD CODE END---------------------