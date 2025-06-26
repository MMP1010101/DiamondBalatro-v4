--- MUSIC SYSTEM FOR OBJECTS DIAMOND MOD
--- Handles custom music integration for Isaac-themed mod (based on Cryptid's approach)

local music_system = {}

-- Store mod path at initialization to avoid issues later
local mod_path = SMODS.current_mod and SMODS.current_mod.path or ""

-- Configuration for custom music tracks  
music_system.config = {
    enabled = true, -- Will be auto-checked
    volume = 0.7,
    tracks = {
        -- Isaac-themed music tracks (just filenames, SMODS will find them in assets/sounds/)
        basement = "Don_t.ogg",
        caves = "Don_t.ogg", 
        depths = "Don_t.ogg",
        womb = "Don_t.ogg",
        sheol = "Don_t.ogg",
        cathedral = "Don_t.ogg",
        chest = "Don_t.ogg",
        boss = "balatrez.ogg",  -- Boss music diferente
        shop = "tienda.ogg",    -- Música específica de tienda
        secret = "Don_t.ogg"
    }
}

-- Register Isaac music tracks using SMODS.Sound (following working example)
function music_system.register_music_tracks()
    print("Registering Isaac music tracks...")
    
    -- Main menu music (replaces when in main menu)
    SMODS.Sound({
        key = "isaac_menu_music",
        path = music_system.config.tracks.basement,
        vol = music_system.config.volume,
        pitch = 1.0,
        select_music_track = function()
            return G.STAGE == G.STAGES.MAIN_MENU and music_system.config.enabled and 8
        end,
    })
    
    -- Gameplay music - Early antes (basement)
    SMODS.Sound({
        key = "isaac_basement_music", 
        path = music_system.config.tracks.basement,
        vol = music_system.config.volume,
        pitch = 1.0,
        select_music_track = function()
            return music_system.config.enabled 
                and G.GAME 
                and G.GAME.round_resets 
                and G.GAME.round_resets.ante 
                and G.GAME.round_resets.ante <= 2
                and 10 -- High priority to override default music
        end,
    })
    
    -- Caves music (antes 3-4)
    SMODS.Sound({
        key = "isaac_caves_music",
        path = music_system.config.tracks.caves,
        vol = music_system.config.volume,
        pitch = 1.0,
        select_music_track = function()
            return music_system.config.enabled
                and G.GAME
                and G.GAME.round_resets
                and G.GAME.round_resets.ante
                and G.GAME.round_resets.ante >= 3
                and G.GAME.round_resets.ante <= 4
                and 10
        end,
    })
    
    -- Depths music (antes 5-6)
    SMODS.Sound({
        key = "isaac_depths_music",
        path = music_system.config.tracks.depths,
        vol = music_system.config.volume,
        pitch = 1.0,
        select_music_track = function()
            return music_system.config.enabled
                and G.GAME
                and G.GAME.round_resets
                and G.GAME.round_resets.ante
                and G.GAME.round_resets.ante >= 5
                and G.GAME.round_resets.ante <= 6
                and 10
        end,
    })
    
    -- Womb music (antes 7-8)
    SMODS.Sound({
        key = "isaac_womb_music",
        path = music_system.config.tracks.womb,
        vol = music_system.config.volume,
        pitch = 1.0,
        select_music_track = function()
            return music_system.config.enabled
                and G.GAME
                and G.GAME.round_resets
                and G.GAME.round_resets.ante
                and G.GAME.round_resets.ante >= 7
                and G.GAME.round_resets.ante <= 8
                and 10
        end,
    })
    
    -- Sheol music (ante 9+)
    SMODS.Sound({
        key = "isaac_sheol_music",
        path = music_system.config.tracks.sheol,
        vol = music_system.config.volume,
        pitch = 1.0,
        select_music_track = function()
            return music_system.config.enabled
                and G.GAME
                and G.GAME.round_resets
                and G.GAME.round_resets.ante
                and G.GAME.round_resets.ante >= 9
                and 10
        end,
    })
    
    -- Boss music (when fighting boss blinds) - Uses balatrez.ogg
    SMODS.Sound({
        key = "isaac_boss_music",
        path = music_system.config.tracks.boss,
        vol = music_system.config.volume,
        pitch = 1.0,
        select_music_track = function()
            return music_system.config.enabled
                and G.GAME
                and G.GAME.blind
                and G.GAME.blind.boss
                and 15 -- Highest priority for boss fights
        end,
    })
    
    -- Shop music (in shop) - Uses tienda.ogg
    SMODS.Sound({
        key = "isaac_shop_music",
        path = music_system.config.tracks.shop,
        vol = music_system.config.volume,
        pitch = 1.0,
        select_music_track = function()
            return music_system.config.enabled
                and G.shop 
                and not G.shop.REMOVED
                and 12 -- High priority for shop
        end,
    })
    
    print("Isaac music tracks registered successfully!")
end

-- Initialize the music system
function music_system.init()
    -- Check if audio file exists in the correct location (assets/sounds/)
    local test_path = mod_path .. "assets/sounds/" .. music_system.config.tracks.basement
    
    if not NFS.getInfo(test_path) then
        print("⚠️ Isaac music disabled: Audio file not found in " .. test_path)
        print("💡 Place your OGG files in assets/sounds/ folder")
        music_system.config.enabled = false
        return
    end
    
    print("✅ Isaac audio file found - Music system enabled!")
    music_system.config.enabled = true
    
    -- Register all music tracks
    music_system.register_music_tracks()
    
    print("🎵 Objects Diamond Music System initialized with automatic music replacement!")
end

-- Enable/disable the music system
function music_system.toggle(enabled)
    music_system.config.enabled = enabled
    print("Isaac music " .. (enabled and "enabled" or "disabled"))
end

-- Change music volume
function music_system.set_volume(new_volume)
    music_system.config.volume = math.max(0, math.min(1, new_volume))
    print("Isaac music volume set to " .. music_system.config.volume)
end

-- Simple hook system
function music_system.setup_game_hooks()
    print("Isaac music system ready - music will change automatically!")
    print("🎵 Menu: Don_t.ogg")
    print("🎵 Ante 1-2: Don_t.ogg (Basement)") 
    print("🎵 Ante 3-4: Don_t.ogg (Caves)")
    print("🎵 Ante 5-6: Don_t.ogg (Depths)")
    print("🎵 Ante 7-8: Don_t.ogg (Womb)")
    print("🎵 Ante 9+: Don_t.ogg (Sheol)")
    print("🎵 Ciega Pequeña/Grande: Don_t.ogg")
    print("🎵 Boss fights: balatrez.ogg")
    print("🎵 Shop: tienda.ogg")
end

-- Debug function to test music files
function music_system.test_music()
    print("Testing Isaac music tracks...")
    
    for track_name, file_name in pairs(music_system.config.tracks) do
        local path = mod_path .. "assets/sounds/" .. file_name
        if NFS.getInfo(path) then
            print("✓ Found: " .. track_name .. " (" .. file_name .. ")")
        else
            print("✗ Missing: " .. track_name .. " (" .. file_name .. ")")
        end
    end
    
    print("📁 Looking in: " .. mod_path .. "assets/sounds/")
    print("💡 SMODS looks for audio files in assets/sounds/, not assets/audio/")
end

-- Global helper functions for manual control
function toggle_isaac_music()
    music_system.toggle(not music_system.config.enabled)
end

function isaac_music_volume(vol)
    music_system.set_volume(vol or 0.7)
end

-- Function to enable music once you have a valid audio file
function enable_isaac_music()
    music_system.config.enabled = true
    print("Isaac music enabled! Restart Balatro to apply changes.")
end

return music_system
