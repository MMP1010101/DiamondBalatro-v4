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

-- Load all items from the items folder
local function load_items()
    local items_path = mod_path .. "items/"
    
    -- List of item files to load
    local item_files = {
        "caja_azul.lua",
        "joker_isaac_diamond.lua", 
        "joker_isaac_skull.lua",
        "joker_isaac_trinket.lua"
    }
    
    -- Load each item file
    for _, file in ipairs(item_files) do
        local file_path = items_path .. file
        if NFS.getInfo(file_path) then
            local item_data = assert(loadfile(file_path))()
            if item_data then
                -- Register the joker with SMODS using correct syntax
                SMODS.Joker{
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
                
                print("Loaded Isaac item: " .. item_data.key)
            end
        else
            print("Warning: Could not find item file: " .. file)
        end
    end
end

-- Load all items when the mod initializes
load_items()

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