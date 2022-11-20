-- Mod name
name = "Dendrobium"

-- Mod desc
description = "An imanginary girl from forgotten kingdom."

-- The author who develop this mod
author = "The last fallen knight"

-- Mod version
version = "2.0.0.4"

-- This is the URL name of the mod's thread on the forum; the part after the ? and before the first & in the url
forumthread = ""

-- This lets other players know if your mod is out of date, update it to match the current version in the game
api_version = 10
priority = 0.10

-- Compatible with Don't Starve Together
dst_compatible = true

-- Not compatible with Don't Starve
dont_starve_compatible = false
reign_of_giants_compatible = false
shipwrecked_compatible = false
hamlet_compatible = false

-- Character mods are required by all clients
all_clients_require_mod = true
client_only_mod = false
server_only_mod = true

-- Mod icon
icon_atlas = "modicon.xml"
icon = "modicon.tex"

-- The mod's tags displayed on the server KeySelections
server_filter_tags = { "character" }

-- Mod name+
folder_name = folder_name or ""
if not folder_name:find("workshop-") then
    name = name..". Project"
end

-- Mod key configs
local ListOfKeys = {
	"A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", 	
	"PERIOD", "SLASH", "SEMICOLON", "TILDE", 	
	"1", "2", "3", "4", "5", "6", "7", "8", "9", "0", 
	"F1", "F2", "F3", "F4", "F5", "F6", "F7", "F8", "F9", "F10", "F11", "F12", 
	"INSERT", "DELETE",	"HOME", "END", "PAGEUP", "PAGEDOWN", "MINUS", "EQUALS", "BACKSPACE", "CAPSLOCK", "SCROLLOCK", "BACKSLASH",
}
local KeySelections = {}
local string = ""
for i = 1, #ListOfKeys do
	KeySelections[i] = {description = "Key "..string.upper(ListOfKeys[i]), data = "KEY_"..string.upper(ListOfKeys[i])}
end

configuration_options = {
	{
		name = "Key1",
		label = "Level Information",
		hover = "Check what level and how much exp earned",
		options = KeySelections,
		default = "KEY_Z",	
	},
	{
		name = "Key2",
		label = "Spell Switcher",
		hover = "Change Dendrobium spell power type",
		options = KeySelections,
		default = "KEY_V",	
	},
	{
		name = "Key3",
		label = "Hit Type",
		hover = "Change Dendrobium hit type",
		options = KeySelections,
		default = "KEY_X",	
	}
}



























