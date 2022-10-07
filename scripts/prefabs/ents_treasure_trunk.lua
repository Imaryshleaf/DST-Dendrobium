local assets = {
	Asset("ANIM", "anim/treasure_x_marks_spot.zip" ),
	Asset("ATLAS", "images/map_icons/treasure_x_marks_spot.xml"),
	Asset("IMAGE", "images/map_icons/treasure_x_marks_spot.tex"),
}
local prefabs = {
	"collapse_small",
}

SetSharedLootTable( 'TreasureLoots',
{

 {'ash', 0.1},
 {'ash', 0.1},
 {'ash', 0.1},
		------
	{'bluegem',     0.1},
	{'redgem',     0.05},
			-------
		 {'charcoal', 0.1},
		 {'charcoal', 0.1},
			{'flint', 0.1},
					--------
				{'houndstooth', 0.1},
				{'houndstooth', 0.1},
					{'boneshard', 0.1},
						----------
					{'horn', 0.05},
					-- {'goldenaxe', 0.05},
					-- {'goldenpickaxe', 0.05},
					-- {'goldenshovel', 0.05},
					-- {'umbrella', 0.05},
					-- {'trunkvest_winter', 0.05},
					-- {'trunkvest_summer', 0.05},
})

local RandomItem1 = ---------- Slot 1 [Non Fresh 1 & Fresh 1] : Non Stackable : Creature+Tools
{	{item1 = {	"canary", --- Fresh
				"robin",  --- Fresh
				"robin_winter",  --- Fresh
				"crow", --- Fresh
				"rabbit", --[[Fresh]]	}, count = 1},
}
local RandomItem2 = ---------- Slot 2 [Fresh 2] : Stackable
{	{item2 = {	"bee", 
				"killerbee",
				"eel",
				"butterfly",
				"mosquito",
				"fish",	}, count = {1, 2}},
}
local RandomItem3 = ---------- Slot 3 [Fresh 3] : Stackable
{	{item3 = {	"bird_egg",
				"froglegs",
				"ice",
				"acorn",
				"cutlichen",
				"foliage",
				"succulent_picked",
				"goatmilk",
				"red_cap",
				"blue_cap",
				"green_cap",
				"lightbulb",
				"petals_evil",	}, count = {2, 4}},
}
local RandomItem4 = ---------- Slot 4 [Fresh 4] : Stackable : Foods/Other/Rare
{	{item4 = {	"spoiled_food",
				"wetgoop",
				"powcake",
				"monsterlasagna",
				"yotp_food3",
				"yotp_food1",
				"meatballs",
				"honeyham",
				"taffy",
				"unagi",
				"honey",
				"royal_jelly", 	-- Fresh Rare
				"wormlight",	--[[ Fresh Rare]]	}, count = {1, 1}},
}
local RandomItem5 = ---------- Slot 5 [Non Fresh 1] : Stackable : Common
{	{item5 = {	"twigs",
				"rocks",
				"cutgrass",
				"cutreeds",
				"flint",
				"log",
				"nitre",
				"marble",
				"goldnugget",	}, count = {10, 10}},
}
local RandomItem6 = ---------- Slot 6 [Non Fresh 6] : Stackable : Hunt
{	{item6 = {	"pigskin",
				"tentaclespots",
				"stinger",
				"feather_crow",
				"feather_robin",
				"feather_robin_winter",
				"feather_canary",
				"silk",
				"beefalowool",
				"manrabbit_tail",
				"coontail",	
				"nightmarefuel",	}, count = {5, 5}},
}
local RandomItem7 = ---------- Slot 7 [Non Fresh 7] : Stackable : Revinable+Other
{	{item7 = {	"rope",
				"cutstone",
				"boards",
				"papyrus",	
				"waxpaper",	
				"marblebean",	
				---
				"charcoal",
				"ash",
				"boneshard",
				"honeycomb",
				"furtuft",
				"glommerfuel",
				"bandage",
				"healingsalve",
				--[["glommerwings",]]	}, count = {10, 10}},
}
local RandomItem8 = ---------- Slot 8 [Non Fresh 8] : Stackable : Rare+Gems+Other
{	{item8 = {	"moonrocknugget",
				"beardhair",
				"slurper_pelt",
				"slurtleslime",
				"steelwool",
				"lightninggoathorn",
				"gears",
				"thulecite",
				"thulecite_pieces",
				"mandrake",
				"wall_ruins_item",
				"shroom_skin",
				"livinglog",
				---
				"redgem", -- Gems
				"bluegem",  -- Gems
				"greengem", -- Gems
				"purplegem", -- Gems
				"yellowgem", -- Gems
				"orangegem", -- Gems
				"opalpreciousgem", --[[Gems]]	}, count = {3, 3}},
}
local RandomItem9 = ---------- Slot 9 [Fresh & Non Fresh 9] : Non Stackable : Rare+War+Other
{	{item9 = {		"dragonflychest_blueprint",
					"dragonflyfurnace_blueprint",
					"red_mushroomhat_blueprint",
					"green_mushroomhat_blueprint",
					"blue_mushroomhat_blueprint",
					"mushroom_light2_blueprint",
					"sleepbomb_blueprint",
					"bundlewrap_blueprint",
					"townportal_blueprint",
					"rabbithouse_blueprint",
					"deserthat_blueprint",	
					---
					"spear_wathgrithr", 
					"wathgrithrhat", 
					"spear", 
					"nightstick", 
					"armorgrass", 
					"armorwood", 
					"armormarble", 
					"footballhat", 
					"boomerang", 
					"beemine", 
					"trap_teeth", 
					"staff_tornado", 
					"armordragonfly", 
					"armorruins", 
					"ruinshat", 
					"ruins_bat", 
					"eyeturret_item", 
					---
					"panflute",
					"onemanband",
					"armor_sanity",
					"batbat",
					"nightsword",
					"armorslurper",
					---
					"amulet",
					"blueamulet",
					"purpleamulet",
					"firestaff",
					"icestaff",
					"telestaff",
					"orangeamulet",
					"yellowamulet",
					"greenamulet",
					"orangestaff",
					"yellowstaff",
					"greenstaff",
					-- "opalstaff", -- Error occurred 
					"multitool_axe_pickaxe",
					--- My Book
					"book_birds",
					"book_gardening",
					"book_sleep",
					"book_brimstone",
					"book_tentacles", }, count = 1},
}

local function dig_up(inst, chopper)
local treasure_chest = SpawnPrefab("treasurechest")
	  treasure_chest.Transform:SetPosition(inst:GetPosition():Get())

	-- Cave Minotaur
    local Keys = {}
    for i, _ in ipairs(RandomItem1)	do	table.insert(Keys, i)	end --- First Slot
	for i, _ in ipairs(RandomItem2)	do	table.insert(Keys, i)	end
	for i, _ in ipairs(RandomItem3)	do	table.insert(Keys, i)	end
	for i, _ in ipairs(RandomItem4)	do	table.insert(Keys, i)	end
	for i, _ in ipairs(RandomItem5)	do	table.insert(Keys, i)	end
	for i, _ in ipairs(RandomItem6)	do	table.insert(Keys, i)	end
	for i, _ in ipairs(RandomItem7)	do	table.insert(Keys, i)	end
	for i, _ in ipairs(RandomItem8)	do	table.insert(Keys, i)	end
	for i, _ in ipairs(RandomItem9)	do	table.insert(Keys, i)	end --- Last Slot
    Keys = PickSome((1), Keys)
    for _, i in ipairs(Keys) do
        local loot1 = RandomItem1[i]
        local item1 = SpawnPrefab(loot1.item1[math.random(#loot1.item1)])
        if item1 ~= nil then
            if type(loot1.count) == "table" and item1.components.stackable ~= nil then
                item1.components.stackable:SetStackSize(math.random(loot1.count[1], loot1.count[2]))
            end
            treasure_chest.components.container:GiveItem(item1)
			end
        end
	for _, i in ipairs(Keys) do
		local loot2 = RandomItem2[i]
		local item2 = SpawnPrefab(loot2.item2[math.random(#loot2.item2)])
        if item2 ~= nil then
            if type(loot2.count) == "table" and item2.components.stackable ~= nil then
                item2.components.stackable:SetStackSize(math.random(loot2.count[1], loot2.count[2]))
            end
            treasure_chest.components.container:GiveItem(item2)
        end
    end	
	for _, i in ipairs(Keys) do
		local loot3 = RandomItem3[i]
		local item3 = SpawnPrefab(loot3.item3[math.random(#loot3.item3)])
        if item3 ~= nil then
            if type(loot3.count) == "table" and item3.components.stackable ~= nil then
                item3.components.stackable:SetStackSize(math.random(loot3.count[1], loot3.count[2]))
            end
            treasure_chest.components.container:GiveItem(item3)
        end
    end	
	for _, i in ipairs(Keys) do
		local loot4 = RandomItem4[i]
		local item4 = SpawnPrefab(loot4.item4[math.random(#loot4.item4)])
        if item4 ~= nil then
            if type(loot4.count) == "table" and item4.components.stackable ~= nil then
                item4.components.stackable:SetStackSize(math.random(loot4.count[1], loot4.count[2]))
            end
            treasure_chest.components.container:GiveItem(item4)
        end
    end	
	for _, i in ipairs(Keys) do
		local loot5 = RandomItem5[i]
		local item5 = SpawnPrefab(loot5.item5[math.random(#loot5.item5)])
        if item5 ~= nil then
            if type(loot5.count) == "table" and item5.components.stackable ~= nil then
                item5.components.stackable:SetStackSize(math.random(loot5.count[1], loot5.count[2]))
            end
            treasure_chest.components.container:GiveItem(item5)
        end
    end	
	for _, i in ipairs(Keys) do
		local loot6 = RandomItem6[i]
		local item6 = SpawnPrefab(loot6.item6[math.random(#loot6.item6)])
        if item6 ~= nil then
            if type(loot6.count) == "table" and item6.components.stackable ~= nil then
                item6.components.stackable:SetStackSize(math.random(loot6.count[1], loot6.count[2]))
            end
            treasure_chest.components.container:GiveItem(item6)
        end
    end	
	for _, i in ipairs(Keys) do
		local loot7 = RandomItem7[i]
		local item7 = SpawnPrefab(loot7.item7[math.random(#loot7.item7)])
        if item7 ~= nil then
            if type(loot7.count) == "table" and item7.components.stackable ~= nil then
                item7.components.stackable:SetStackSize(math.random(loot7.count[1], loot7.count[2]))
            end
            treasure_chest.components.container:GiveItem(item7)
        end
    end	
	for _, i in ipairs(Keys) do
		local loot8 = RandomItem8[i]
		local item8 = SpawnPrefab(loot8.item8[math.random(#loot8.item8)])
        if item8 ~= nil then
            if type(loot8.count) == "table" and item8.components.stackable ~= nil then
                item8.components.stackable:SetStackSize(math.random(loot8.count[1], loot8.count[2]))
            end
            treasure_chest.components.container:GiveItem(item8)
        end
    end	
	for _, i in ipairs(Keys) do
		local loot9 = RandomItem9[i]
		local item9 = SpawnPrefab(loot9.item9[math.random(#loot9.item9)])
        if item9 ~= nil then
            if type(loot9.count) == "table" and item9.components.stackable ~= nil then
                item9.components.stackable:SetStackSize(math.random(loot9.count[1], loot9.count[2]))
            end
            treasure_chest.components.container:GiveItem(item9)
        end
    end
	
	-- Spawn Fx
	SpawnPrefab("small_puff").Transform:SetPosition(inst:GetPosition():Get())
	SpawnPrefab("collapse_small").Transform:SetPosition(inst:GetPosition():Get())

	-- Dig up twice
	inst:Remove()

	-- Drop the loot
	if inst.components.lootdropper then
		inst.components.lootdropper:DropLoot()
	end

-- Guardian
local x,y,z = inst.Transform:GetWorldPosition()
local Spider_1 = SpawnPrefab("spider")
local offset1 = FindWalkableOffset(inst:GetPosition(), 30*DEGREES,	7, 30, false, false)
		Spider_1.Transform:SetPosition(x + offset1.x, y + offset1.y, z + offset1.z)
		SpawnPrefab("collapse_small").Transform:SetPosition(Spider_1:GetPosition():Get()) 
		Spider_1.SoundEmitter:PlaySound("dontstarve/maxwell/shadowmax_appear")
		
local Spider_2 = SpawnPrefab("spider")
local offset2 = FindWalkableOffset(inst:GetPosition(), 60*DEGREES,	7, 30, false, false)
		Spider_2.Transform:SetPosition(x + offset2.x, y + offset2.y, z + offset2.z)
		SpawnPrefab("collapse_small").Transform:SetPosition(Spider_2:GetPosition():Get()) 
		Spider_2.SoundEmitter:PlaySound("dontstarve/maxwell/shadowmax_appear")
		
local Spider_3 = SpawnPrefab("spider")
local offset3 = FindWalkableOffset(inst:GetPosition(), 90*DEGREES,	7, 30, false, false)
		Spider_3.Transform:SetPosition(x + offset3.x, y + offset3.y, z + offset3.z)
		SpawnPrefab("collapse_small").Transform:SetPosition(Spider_3:GetPosition():Get()) 
		Spider_3.SoundEmitter:PlaySound("dontstarve/maxwell/shadowmax_appear")

local Spider_4 = SpawnPrefab("spider")
local offset4 = FindWalkableOffset(inst:GetPosition(), 120*DEGREES,	7, 30, false, false)
		Spider_4.Transform:SetPosition(x + offset4.x, y + offset4.y, z + offset4.z)
		SpawnPrefab("collapse_small").Transform:SetPosition(Spider_4:GetPosition():Get()) 
		Spider_4.SoundEmitter:PlaySound("dontstarve/maxwell/shadowmax_appear")
		
local Spider_5 = SpawnPrefab("spider")
local offset5 = FindWalkableOffset(inst:GetPosition(), 150*DEGREES,	7, 30, false, false)
		Spider_5.Transform:SetPosition(x + offset5.x, y + offset5.y, z + offset5.z)
		SpawnPrefab("collapse_small").Transform:SetPosition(Spider_5:GetPosition():Get()) 
		Spider_5.SoundEmitter:PlaySound("dontstarve/maxwell/shadowmax_appear")
		
local Spider_6 = SpawnPrefab("spider")
local offset6 = FindWalkableOffset(inst:GetPosition(), 180*DEGREES,	7, 30, false, false)
		Spider_6.Transform:SetPosition(x + offset6.x, y + offset6.y, z + offset6.z)
		SpawnPrefab("collapse_small").Transform:SetPosition(Spider_6:GetPosition():Get()) 
		Spider_6.SoundEmitter:PlaySound("dontstarve/maxwell/shadowmax_appear")
		
local Spider_7 = SpawnPrefab("spider")
local offset7 = FindWalkableOffset(inst:GetPosition(), 210*DEGREES,	7, 30, false, false)
		Spider_7.Transform:SetPosition(x + offset7.x, y + offset7.y, z + offset7.z)
		SpawnPrefab("collapse_small").Transform:SetPosition(Spider_7:GetPosition():Get()) 
		Spider_7.SoundEmitter:PlaySound("dontstarve/maxwell/shadowmax_appear")
		
local Spider_8 = SpawnPrefab("spider")
local offset8 = FindWalkableOffset(inst:GetPosition(), 240*DEGREES,	7, 30, false, false)
		Spider_8.Transform:SetPosition(x + offset8.x, y + offset8.y, z + offset8.z)
		SpawnPrefab("collapse_small").Transform:SetPosition(Spider_8:GetPosition():Get()) 
		Spider_8.SoundEmitter:PlaySound("dontstarve/maxwell/shadowmax_appear")
		
local Spider_9 = SpawnPrefab("spider")
local offset9 = FindWalkableOffset(inst:GetPosition(), 240*DEGREES,	7, 30, false, false)
		Spider_9.Transform:SetPosition(x + offset9.x, y + offset9.y, z + offset9.z)
		SpawnPrefab("collapse_small").Transform:SetPosition(Spider_9:GetPosition():Get()) 
		Spider_9.SoundEmitter:PlaySound("dontstarve/maxwell/shadowmax_appear")

local Spider_10 = SpawnPrefab("spider")
local offset10 = FindWalkableOffset(inst:GetPosition(), 270*DEGREES, 7, 30, false, false)
		Spider_10.Transform:SetPosition(x + offset10.x, y + offset10.y, z + offset10.z)
		SpawnPrefab("collapse_small").Transform:SetPosition(Spider_10:GetPosition():Get()) 
		Spider_10.SoundEmitter:PlaySound("dontstarve/maxwell/shadowmax_appear")
		
local Spider_11 = SpawnPrefab("spider")
local offset11 = FindWalkableOffset(inst:GetPosition(), 300*DEGREES, 7, 30, false, false)
		Spider_11.Transform:SetPosition(x + offset11.x, y + offset11.y, z + offset11.z)
		SpawnPrefab("collapse_small").Transform:SetPosition(Spider_11:GetPosition():Get()) 
		Spider_11.SoundEmitter:PlaySound("dontstarve/maxwell/shadowmax_appear")
		
local Spider_12 = SpawnPrefab("spider")
local offset12 = FindWalkableOffset(inst:GetPosition(), 330*DEGREES, 7, 30, false, false)
		Spider_12.Transform:SetPosition(x + offset12.x, y + offset12.y, z + offset12.z)
		SpawnPrefab("collapse_small").Transform:SetPosition(Spider_12:GetPosition():Get()) 
		Spider_12.SoundEmitter:PlaySound("dontstarve/maxwell/shadowmax_appear")
		
local Spider_13 = SpawnPrefab("spider_warrior")
local offset13 = FindWalkableOffset(inst:GetPosition(), 360*DEGREES, 7, 30, false, false)
		Spider_13.Transform:SetPosition(x + offset13.x, y + offset13.y, z + offset13.z)
		SpawnPrefab("collapse_small").Transform:SetPosition(Spider_13:GetPosition():Get()) 
		Spider_13.SoundEmitter:PlaySound("dontstarve/maxwell/shadowmax_appear")

--[[ 
-- Guardian
local x,y,z = inst.Transform:GetWorldPosition()
local Batbat_1 = SpawnPrefab("batbat")
local offset1 = FindWalkableOffset(inst:GetPosition(), 30*DEGREES,	7, 30, false, false)
		Batbat_1.Transform:SetPosition(x + offset1.x, y + offset1.y, z + offset1.z)
		SpawnPrefab("collapse_small").Transform:SetPosition(Batbat_1:GetPosition():Get()) 
		Batbat_1.SoundEmitter:PlaySound("dontstarve/maxwell/shadowmax_appear")
		
local Batbat_2 = SpawnPrefab("batbat")
local offset2 = FindWalkableOffset(inst:GetPosition(), 60*DEGREES,	7, 30, false, false)
		Batbat_2.Transform:SetPosition(x + offset2.x, y + offset2.y, z + offset2.z)
		SpawnPrefab("collapse_small").Transform:SetPosition(Batbat_2:GetPosition():Get()) 
		Batbat_2.SoundEmitter:PlaySound("dontstarve/maxwell/shadowmax_appear")
		
local Batbat_3 = SpawnPrefab("batbat")
local offset3 = FindWalkableOffset(inst:GetPosition(), 90*DEGREES,	7, 30, false, false)
		Batbat_3.Transform:SetPosition(x + offset3.x, y + offset3.y, z + offset3.z)
		SpawnPrefab("collapse_small").Transform:SetPosition(Batbat_3:GetPosition():Get()) 
		Batbat_3.SoundEmitter:PlaySound("dontstarve/maxwell/shadowmax_appear")

local Batbat_4 = SpawnPrefab("batbat")
local offset4 = FindWalkableOffset(inst:GetPosition(), 120*DEGREES,	7, 30, false, false)
		Batbat_4.Transform:SetPosition(x + offset4.x, y + offset4.y, z + offset4.z)
		SpawnPrefab("collapse_small").Transform:SetPosition(Batbat_4:GetPosition():Get()) 
		Batbat_4.SoundEmitter:PlaySound("dontstarve/maxwell/shadowmax_appear")
		
local Batbat_5 = SpawnPrefab("batbat")
local offset5 = FindWalkableOffset(inst:GetPosition(), 150*DEGREES,	7, 30, false, false)
		Batbat_5.Transform:SetPosition(x + offset5.x, y + offset5.y, z + offset5.z)
		SpawnPrefab("collapse_small").Transform:SetPosition(Batbat_5:GetPosition():Get()) 
		Batbat_5.SoundEmitter:PlaySound("dontstarve/maxwell/shadowmax_appear")
		
local Batbat_6 = SpawnPrefab("batbat")
local offset6 = FindWalkableOffset(inst:GetPosition(), 180*DEGREES,	7, 30, false, false)
		Batbat_6.Transform:SetPosition(x + offset6.x, y + offset6.y, z + offset6.z)
		SpawnPrefab("collapse_small").Transform:SetPosition(Batbat_6:GetPosition():Get()) 
		Batbat_6.SoundEmitter:PlaySound("dontstarve/maxwell/shadowmax_appear")
		
local Batbat_7 = SpawnPrefab("batbat")
local offset7 = FindWalkableOffset(inst:GetPosition(), 210*DEGREES,	7, 30, false, false)
		Batbat_7.Transform:SetPosition(x + offset7.x, y + offset7.y, z + offset7.z)
		SpawnPrefab("collapse_small").Transform:SetPosition(Batbat_7:GetPosition():Get()) 
		Batbat_7.SoundEmitter:PlaySound("dontstarve/maxwell/shadowmax_appear")
		
local Batbat_8 = SpawnPrefab("batbat")
local offset8 = FindWalkableOffset(inst:GetPosition(), 240*DEGREES,	7, 30, false, false)
		Batbat_8.Transform:SetPosition(x + offset8.x, y + offset8.y, z + offset8.z)
		SpawnPrefab("collapse_small").Transform:SetPosition(Batbat_8:GetPosition():Get()) 
		Batbat_8.SoundEmitter:PlaySound("dontstarve/maxwell/shadowmax_appear")
		
local Batbat_9 = SpawnPrefab("batbat")
local offset9 = FindWalkableOffset(inst:GetPosition(), 240*DEGREES,	7, 30, false, false)
		Batbat_9.Transform:SetPosition(x + offset9.x, y + offset9.y, z + offset9.z)
		SpawnPrefab("collapse_small").Transform:SetPosition(Batbat_9:GetPosition():Get()) 
		Batbat_9.SoundEmitter:PlaySound("dontstarve/maxwell/shadowmax_appear")

local Batbat_10 = SpawnPrefab("batbat")
local offset10 = FindWalkableOffset(inst:GetPosition(), 270*DEGREES, 7, 30, false, false)
		Batbat_10.Transform:SetPosition(x + offset10.x, y + offset10.y, z + offset10.z)
		SpawnPrefab("collapse_small").Transform:SetPosition(Batbat_10:GetPosition():Get()) 
		Batbat_10.SoundEmitter:PlaySound("dontstarve/maxwell/shadowmax_appear")
		
local Batbat_11 = SpawnPrefab("batbat")
local offset11 = FindWalkableOffset(inst:GetPosition(), 300*DEGREES, 7, 30, false, false)
		Batbat_11.Transform:SetPosition(x + offset11.x, y + offset11.y, z + offset11.z)
		SpawnPrefab("collapse_small").Transform:SetPosition(Batbat_11:GetPosition():Get()) 
		Batbat_11.SoundEmitter:PlaySound("dontstarve/maxwell/shadowmax_appear")
		
local Batbat_12 = SpawnPrefab("batbat")
local offset12 = FindWalkableOffset(inst:GetPosition(), 330*DEGREES, 7, 30, false, false)
		Batbat_12.Transform:SetPosition(x + offset12.x, y + offset12.y, z + offset12.z)
		SpawnPrefab("collapse_small").Transform:SetPosition(Batbat_12:GetPosition():Get()) 
		Batbat_12.SoundEmitter:PlaySound("dontstarve/maxwell/shadowmax_appear")
		
local Batbat_13 = SpawnPrefab("ghost")
local offset13 = FindWalkableOffset(inst:GetPosition(), 360*DEGREES, 7, 30, false, false)
		Batbat_13.Transform:SetPosition(x + offset13.x, y + offset13.y, z + offset13.z)
		SpawnPrefab("collapse_small").Transform:SetPosition(Batbat_13:GetPosition():Get()) 
		Batbat_13.SoundEmitter:PlaySound("dontstarve/maxwell/shadowmax_appear")
]]

end

local function onsave(inst, data)
	if inst.revealed then
		data.revealed = inst.revealed
	end
end
local function onload(inst, data)
    if data and data.revealed and data.revealed == true then
    	inst:Reveal(inst)
    end
end

local function OnNear(inst)
	inst.components.colourtweener:StartTween({1,1,1,1}, 0)
end
local function OnFar(inst)
	inst.components.colourtweener:StartTween({.2,.2,.2,.1}, 0)
end

local function fn(Sim)
	local inst = CreateEntity()
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	inst.entity:Hide()
	
	inst.entity:AddMiniMapEntity()
	inst.MiniMapEntity:SetIcon("treasure_x_marks_spot.tex")
	
    inst.AnimState:SetBank("x_marks_spot")
    inst.AnimState:SetBuild("treasure_x_marks_spot")
    inst.AnimState:PlayAnimation("anim")
	
	inst.MiniMapEntity:SetDrawOverFogOfWar(true)
	
	inst:AddTag("NOCLICK")

	inst.entity:SetPristine()
	if not TheWorld.ismastersim then
        return inst
    end	

	inst:AddComponent("maprevealer")
	inst.components.maprevealer.revealperiod = 3
	inst.components.maprevealer:Start()
 	
    inst:AddComponent("inspectable")
	
	inst:AddComponent("lootdropper")
	inst.components.lootdropper:SetChanceLootTable('TreasureLoots')
	
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.DIG)
	inst.components.workable:SetOnFinishCallback(dig_up)
	inst.components.workable:SetWorkLeft(1)

	inst:AddComponent("playerprox")
	inst.components.playerprox:SetDist(2, 2)
	inst.components.playerprox:SetOnPlayerNear(OnNear)
	inst.components.playerprox:SetOnPlayerFar(OnFar)
	inst:AddComponent("colourtweener")
	inst:DoTaskInTime(1 , function(imst)
		inst.components.colourtweener:StartTween({.2,.2,.2,.1}, 0)
	end)

    inst.revealed = false

    inst.Reveal = function(inst)
    	inst.revealed = true
    	inst.entity:Show()
    	inst.MiniMapEntity:SetEnabled(true)
    	inst:RemoveTag("NOCLICK")
	end

	inst.IsRevealed = function(inst)
		return inst.revealed
	end

	inst.OnSave = onsave
	inst.OnLoad = onload
	
	inst.SetTreasureHunt = function(inst)
		inst:Reveal()
	end

    return inst
end

return Prefab("treasure_trunk", fn, assets, prefabs )