local assets = {
	-- Seasonal skins
	Asset( "ANIM", "character/skins/dendrobium.zip" ), --- Autumn
	Asset( "ANIM", "character/skins/dendrobium_black.zip" ), --- Fullmoon
	Asset( "ANIM", "character/skins/dendrobium_blue.zip" ),  --- Wet
	Asset( "ANIM", "character/skins/dendrobium_red.zip" ), --- Rage
	Asset( "ANIM", "character/skins/dendrobium_aquatic.zip" ), --- Winter
	Asset( "ANIM", "character/skins/dendrobium_green.zip" ), --- Bloom
	Asset( "ANIM", "character/skins/dendrobium_purple.zip" ),  --- Spring
	Asset( "ANIM", "character/skins/dendrobium_sun.zip" ), --- Summer
	Asset( "ANIM", "character/skins/dendrobium_original.zip" ),

	--Seasonal skins2
	Asset( "ANIM", "character/skins/dendrobium_2nd.zip" ), --- Autumn
	Asset( "ANIM", "character/skins/dendrobium_black_2nd.zip" ), --- Fullmoon
	Asset( "ANIM", "character/skins/dendrobium_blue_2nd.zip" ),  --- Wet
	Asset( "ANIM", "character/skins/dendrobium_red_2nd.zip" ), --- Rage
	Asset( "ANIM", "character/skins/dendrobium_aquatic_2nd.zip" ), --- Winter
	Asset( "ANIM", "character/skins/dendrobium_green_2nd.zip" ), --- Bloom
	Asset( "ANIM", "character/skins/dendrobium_purple_2nd.zip" ),  --- Spring
	Asset( "ANIM", "character/skins/dendrobium_sun_2nd.zip" ), --- Summer
	Asset( "ANIM", "character/skins/dendrobium_original_2nd.zip" ),

	-- Ghost skins
	Asset( "ANIM", "character/skins/ghost_dendrobium_build.zip" ),
}

local skins = {
	normal_skin = "dendrobium",
	ghost_skin = "ghost_dendrobium_build",
}

return CreatePrefabSkin("dendrobium_none", {
	base_prefab = "dendrobium",
	type = "base",
	assets = assets,
	skins = skins, 
	skin_tags = {"DENDROBIUM", "CHARACTER", "BASE"},
	build_name = "dendrobium",
	rarity = "Common",
})