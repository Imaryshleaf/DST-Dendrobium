Assets = {
    -- Basic
    Asset( "IMAGE", "images/saveslot_portraits/dendrobium.tex" ),
    Asset( "ATLAS", "images/saveslot_portraits/dendrobium.xml" ),
    Asset( "IMAGE", "images/selectscreen_portraits/dendrobium.tex" ),
    Asset( "ATLAS", "images/selectscreen_portraits/dendrobium.xml" ),
    Asset( "IMAGE", "images/selectscreen_portraits/dendrobium_silho.tex" ),
    Asset( "ATLAS", "images/selectscreen_portraits/dendrobium_silho.xml" ),
    Asset( "IMAGE", "bigportraits/dendrobium.tex" ),
    Asset( "ATLAS", "bigportraits/dendrobium.xml" ),
	Asset( "IMAGE", "images/map_icons/dendrobium.tex" ),
	Asset( "ATLAS", "images/map_icons/dendrobium.xml" ),
	Asset( "IMAGE", "images/avatars/avatar_dendrobium.tex" ),
    Asset( "ATLAS", "images/avatars/avatar_dendrobium.xml" ),
	Asset( "IMAGE", "images/avatars/avatar_ghost_dendrobium.tex" ),
    Asset( "ATLAS", "images/avatars/avatar_ghost_dendrobium.xml" ),
	Asset( "IMAGE", "images/avatars/self_inspect_dendrobium.tex" ),
    Asset( "ATLAS", "images/avatars/self_inspect_dendrobium.xml" ),
	Asset( "IMAGE", "images/names_dendrobium.tex" ),
    Asset( "ATLAS", "images/names_dendrobium.xml" ),
	Asset( "IMAGE", "images/names_gold_dendrobium.tex" ),
    Asset( "ATLAS", "images/names_gold_dendrobium.xml" ),
    Asset( "IMAGE", "bigportraits/dendrobium_none.tex" ),
    Asset( "ATLAS", "bigportraits/dendrobium_none.xml" ),
    -- Widgets
    Asset( "ANIM", "anim/badges/energy_badge.zip" ),
    Asset( "ANIM", "anim/badges/shield_badge.zip" ),
    Asset( "ANIM", "anim/badges/treasure_badge.zip" ),
    Asset( "ANIM", "anim/badges/bloom_badge.zip" ),
    Asset( "ANIM", "anim/badges/magic_badge.zip" ),
    Asset( "ANIM", "anim/badges/quantum_badge.zip" ),
	Asset( "ANIM", "anim/badges/hitcount_badge.zip" ),
    -- Actions
    Asset("ANIM", "anim/actions/action_dodge.zip"),
    Asset("ANIM", "anim/actions/action_leap.zip"),
    Asset("ANIM", "anim/actions/action_bloom.zip"),
    Asset("ANIM", "anim/actions/action_mindcontrol.zip"),
}
PrefabFiles = {
	"dendrobium",
	"dendrobium_none",
    -- Inventory Items
	"item_scythe",
	"item_soul_orb",
	"item_noctilucous_jade",
	-- Entities
	"treasure_trunk",
	-- Fx
	"fx_dark_shield",
	"fx_fire_ring",
	"fx_spin_electric",
	"fx_elec_charged",
	"fx_dark_forcefield",
	"fx_dawn_light",
	"fx_ice_splash",
	"fx_lightning",
	"fx_explodes",
}
--------------------------------------------
local require = GLOBAL.require

-- General
local STRINGS = GLOBAL.STRINGS
local TUNING = GLOBAL.TUNING

-- Actions
local BufferedAction = GLOBAL.BufferedAction

-- Stategraphs
local State = GLOBAL.State
local FRAMES = GLOBAL.FRAMES
local ACTIONS = GLOBAL.ACTIONS
local TimeEvent = GLOBAL.TimeEvent
local EQUIPSLOTS = GLOBAL.EQUIPSLOTS
local EventHandler = GLOBAL.EventHandler
local ActionHandler = GLOBAL.ActionHandler

-- Recipes
local resolvefilepath = GLOBAL.resolvefilepath
local Ingredient = GLOBAL.Ingredient
local RECIPETABS = GLOBAL.RECIPETABS
local TECH = GLOBAL.TECH

-- Others
local Profile = GLOBAL.Profile
local TheInput = GLOBAL.TheInput
local TheWorld = GLOBAL.TheWorld
local ThePlayer = GLOBAL.ThePlayer

-- Misc
modimport("character/utils/env.lua")
use "character/utils/mod_env"(env)
use "character/utils/widgets/controls"
use "character/utils/screens/chatinputscreen"
use "character/utils/screens/consolescreen"
use "character/utils/actions/pickup"
use "character/utils/components/inits"
modimport("modimporter.lua")

-- Minimap Icons 
AddMinimapAtlas("images/map_icons/dendrobium.xml")
AddMinimapAtlas("images/map_icons/treasure_x_marks_spot.xml")

-- Inventory items
STRINGS.NAMES.SOUL_ORB = "Soul Orb"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.SOUL_ORB = "Soul Orb from the Dead"
STRINGS.NAMES.NOCTILUCOUS_JADE = "Noctilucous Jade"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.NOCTILUCOUS_JADE = "A rare mineral that glimmers in the dark"
STRINGS.NAMES.DENDROBIUM_SCYTHE = "Scythe"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.DENDROBIUM_SCYTHE = "Scythe!"

-- Describe something
STRINGS.NAMES.TREASURE_TRUNK = "X Mark"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.TREASURE_TRUNK = "Something hidden underneath"

-- Random Talk
STRINGS.DENDROBIUM_RANDOM_TALK_DAYTIME = {
	"Another new day", 
	"Another day, another adventure",
}
STRINGS.DENDROBIUM_RANDOM_TALK_DUSKTIME = {
	"Darkness will coming soon", 
	"Twilight will soon bring darkness", 
}
STRINGS.DENDROBIUM_RANDOM_TALK_NIGHTTIME = {
	"Here we go again, the night",
	"Hello darkness",
	"Goodbye twilight",
}

-- Recipetabs, ingredients and recipes
STRINGS.TABS.DENDROBIUM = "Dendrobium"
RECIPETABS['DENDROBIUM'] = {str = "DENDROBIUM", sort = 12, icon = "dendrobium.tex", icon_atlas = "images/dendrobium.xml"}

AddRecipe("dendrobium_scythe", {
	Ingredient("spear", 1),
	Ingredient(CHARACTER_INGREDIENT.HEALTH, 20),
	Ingredient(CHARACTER_INGREDIENT.SANITY, 15),
}, 
	RECIPETABS.DENDROBIUM, 
	TECH.NONE, nil, nil, nil, nil, nil, 
	"images/inventoryimages/scythe.xml", 
	"scythe.tex",
	{ builder_tag = "Dendrobium" }
)

--- Tags 
local DANGER_CANT_TAGS = { "player", "companion", "alignwall", "stalkerminion", "shadowminion" }
local DANGER_MUST_TAGS = { "monster", "werepig", "frog" }

--- Conditions 
local function IsValidVictim(victim) return victim ~= nil and not (victim:HasTag("veggie") or victim:HasTag("structure") or victim:HasTag("wall") or victim:HasTag("balloon") or victim:HasTag("soulless") or victim:HasTag("chess") or victim:HasTag("shadow") or victim:HasTag("shadowcreature") or victim:HasTag("shadowminion") or victim:HasTag("shadowchesspiece") or victim:HasTag("groundspike") or victim:HasTag("smashable")) and victim.components.combat ~= nil and victim.components.health ~= nil end
local function TagListToCast(inst) return not inst:HasTag("playerghost") and not inst.sneakatk_isactive and not (inst.sg:HasStateTag("sleeping") or inst.sg:HasStateTag("resting")) end
local function TagListToHide(inst) return not inst:HasTag("playerghost") and not (inst.sg:HasStateTag("sleeping") or inst.sg:HasStateTag("resting")) end
local function IsNotEnough(inst, typestr, amount)
	if typestr == "energy" then
		if inst.components.orchidacite then
			if inst.components.orchidacite.min_energy < amount then
				return true
			end
		end
	end
end

--- Cost 
local function DoDeltaCost(inst, typestr, amount)
	if typestr == "sanity" then
		if inst.components.sanity then
			return inst.components.sanity:DoDelta(amount)
		end
	end
	if typestr == "hunger" then
		if inst.components.hunger then
			return inst.components.hunger:DoDelta(amount)
		end
	end
	if typestr == "health" then
		if inst.components.health then
			return inst.components.health:DoDelta(amount)
		end
	end
	if typestr == "energy" then
		if inst.components.orchidacite then
			return inst.components.orchidacite:DoDelta("energy", amount)
		end
	end
end

--- Random talk 
AddPrefabPostInit("dendrobium", function(inst)
	inst:WatchWorldState("startday", function(inst)
		return inst.components.talker:Say(STRINGS.DENDROBIUM_RANDOM_TALK_DAYTIME[math.random(#STRINGS.DENDROBIUM_RANDOM_TALK_DAYTIME)], 2);
	end)
	inst:WatchWorldState("startdusk", function(inst)
		return inst.components.talker:Say(STRINGS.DENDROBIUM_RANDOM_TALK_DUSKTIME[math.random(#STRINGS.DENDROBIUM_RANDOM_TALK_DUSKTIME)], 2);
	end)
	inst:WatchWorldState("startnight", function(inst)
		return inst.components.talker:Say(STRINGS.DENDROBIUM_RANDOM_TALK_NIGHTTIME[math.random(#STRINGS.DENDROBIUM_RANDOM_TALK_NIGHTTIME)], 2);
	end)
end)

--- Hit power and damage boost
AddPrefabPostInit("dendrobium", function(inst)
	inst.hit_type = 0
	inst.hit_count = 0
	local hunger_current = inst.components.hunger.current/3
	inst:ListenForEvent("onhitother", function(inst, data)
	inst.hit_count = inst.hit_count + 1
	local other = data.target
		-- Normal
		if inst.hit_type == 0 then
		if inst.hit_count < 6 then
		inst.hitcount_badge:GetAnimState():PlayAnimation("hit_count_normal_"..(inst.hit_count).."")
		if inst.hit_count == 1 then
			if IsValidVictim(other) and not inst.components.health:IsDead() then
				inst.components.health:DoDelta(2)
			end
		elseif inst.hit_count == 2 then
			if IsValidVictim(other) then
				other.components.health:DoDelta(-2)
			end
		elseif inst.hit_count == 3 then
			if IsValidVictim(other) and other.components.burnable then
				other.components.burnable:Ignite()
			end
			if IsValidVictim(other) and other.components.burnable and other.components.burnable:IsBurning() then
				other.components.burnable:Extinguish()
			end
		elseif inst.hit_count == 4 then
			if IsValidVictim(other) and other.components.freezable then
				other.components.freezable:AddColdness(.5)
			end
		elseif inst.hit_count == 5 then
			if IsValidVictim(other) and inst.components.sanity then
				inst.components.sanity:DoDelta(1)
			end
		end
		else 
		inst.hit_count = inst.hit_count * 0
		inst.hitcount_badge:GetAnimState():PlayAnimation("empty")
		if IsValidVictim(other) then
			local fx2 = SpawnPrefab("fx_fire_ring") fx2.Transform:SetScale(0.5, 0.5, 0.5) fx2.Transform:SetPosition(other:GetPosition():Get())
			other.components.health:DoDelta(-hunger_current)
		end end end
		-- Heal
		if inst.hit_type == 1 then
		if inst.hit_count < 6 then
		inst.hitcount_badge:GetAnimState():PlayAnimation("hit_count_heal_"..(inst.hit_count).."")
		if not inst.components.health:IsDead() then
		if inst.hit_count == 1 then
			if IsValidVictim(other) then
				inst.components.health:DoDelta(1)
			end
		elseif inst.hit_count == 2 then
			if IsValidVictim(other) then
				inst.components.health:DoDelta(0)
			end
		elseif inst.hit_count == 3 then
			if IsValidVictim(other) then
				inst.components.health:DoDelta(1)
			end
		elseif inst.hit_count == 4 then
			if IsValidVictim(other) then
				inst.components.health:DoDelta(0)
			end
		elseif inst.hit_count == 5 then
			if IsValidVictim(other) then
				inst.components.health:DoDelta(1)
			end
		end end
		else 
		inst.hit_count = inst.hit_count * 0
		inst.hitcount_badge:GetAnimState():PlayAnimation("empty")
		if IsValidVictim(other) and not inst.components.health:IsDead() then
			local fx2 = SpawnPrefab("fx_fire_ring") fx2.Transform:SetScale(0.5, 0.5, 0.5) fx2.Transform:SetPosition(other:GetPosition():Get())
			other.components.health:DoDelta(-hunger_current)
		if other:HasTag("largecreature") then
			inst.components.health:DoDelta(other.components.combat.defaultdamage/50)
		elseif other:HasTag("smallcreature") then
			inst.components.health:DoDelta(other.components.combat.defaultdamage/25)
		end end end end
		-- Fire
		if inst.hit_type == 2 then
		if inst.hit_count < 6 then
		inst.hitcount_badge:GetAnimState():PlayAnimation("hit_count_fire_"..(inst.hit_count).."")
		if IsValidVictim(other) and other.components.burnable then
			other.components.burnable:Ignite()
		end
		if IsValidVictim(other) and other.components.burnable and other.components.burnable:IsBurning() then
			other.components.burnable:Extinguish()
		end
		if inst.hit_count == 1 then
			if IsValidVictim(other) and not other.components.health:IsDead() then
				other.components.health:DoDelta(-2)
			end
		elseif inst.hit_count == 2 then
			if IsValidVictim(other) and not other.components.health:IsDead() then
				other.components.health:DoDelta(-2)
			end
		elseif inst.hit_count == 3 then
			if IsValidVictim(other) and not other.components.health:IsDead() then
				other.components.health:DoDelta(-2)
			end
		elseif inst.hit_count == 4 then
			if IsValidVictim(other) and not other.components.health:IsDead() then
				other.components.health:DoDelta(-2)
			end
		elseif inst.hit_count == 5 then
			if IsValidVictim(other) and not other.components.health:IsDead() then
				other.components.health:DoDelta(-2)
			end
		end
		else
		inst.hit_count = inst.hit_count * 0
		inst.hitcount_badge:GetAnimState():PlayAnimation("empty")
		if IsValidVictim(other) then
			local fx2 = SpawnPrefab("fx_exploded_small") fx2.Transform:SetScale(0.7, 0.7, 0.7) fx2.Transform:SetPosition(other:GetPosition():Get())
			other.components.health:DoDelta(-hunger_current)
		end end end
		-- Ice
		if inst.hit_type == 3 then
		if inst.hit_count < 6 then
		inst.hitcount_badge:GetAnimState():PlayAnimation("hit_count_ice_"..(inst.hit_count).."")
		if inst.hit_count == 1 then
			if IsValidVictim(other) and other.components.freezable then
				other.components.freezable:AddColdness(0.2)
				other.components.freezable:SpawnShatterFX()
			end
		elseif inst.hit_count == 2 then
			if IsValidVictim(other) and other.components.freezable then
				other.components.freezable:AddColdness(0.4)
				other.components.freezable:SpawnShatterFX()
			end
		elseif inst.hit_count == 3 then
			if IsValidVictim(other) and other.components.freezable then
				other.components.freezable:AddColdness(0.6)
				other.components.freezable:SpawnShatterFX()
			end
		elseif inst.hit_count == 4 then
			if IsValidVictim(other) and other.components.freezable then
				other.components.freezable:AddColdness(0.8)
				other.components.freezable:SpawnShatterFX()
			end
		elseif inst.hit_count == 5 then
			if IsValidVictim(other) and other.components.freezable then
				other.components.freezable:AddColdness(1)
				other.components.freezable:SpawnShatterFX()
			end
		end
		else
		inst.hit_count = inst.hit_count * 0
		inst.hitcount_badge:GetAnimState():PlayAnimation("empty")
		if IsValidVictim(other) then
			local fx2 = SpawnPrefab("splash") fx2.Transform:SetScale(1.2, 1.2, 1.2) fx2.Transform:SetPosition(other:GetPosition():Get())
			other.components.health:DoDelta(-hunger_current)
			if IsValidVictim(other) and other.components.freezable then
				other.components.freezable:AddColdness(3)
				other.components.freezable:SpawnShatterFX()
			end
		end end end
		-- Shadow
		if inst.hit_type == 4 then
		if inst.hit_count < 6 then
		inst.hitcount_badge:GetAnimState():PlayAnimation("hit_count_shadow_"..(inst.hit_count).."")
		SpawnPrefab("statue_transition_2").Transform:SetPosition(other:GetPosition():Get())
		if inst.hit_count == 1 then
			if IsValidVictim(other) and inst.components.sanity then
				inst.components.sanity:DoDelta(1)
			end
		elseif inst.hit_count == 2 then
			if IsValidVictim(other) and inst.components.sanity then
				inst.components.sanity:DoDelta(0)
			end
		elseif inst.hit_count == 3 then
			if IsValidVictim(other) and inst.components.sanity then
				inst.components.sanity:DoDelta(1)
			end
		elseif inst.hit_count == 4 then
			if IsValidVictim(other) and inst.components.sanity then
				inst.components.sanity:DoDelta(0)
			end
		elseif inst.hit_count == 5 then
			if IsValidVictim(other) and inst.components.sanity then
				inst.components.sanity:DoDelta(1)
			end
		end
		else
		inst.hit_count = inst.hit_count * 0
		inst.hitcount_badge:GetAnimState():PlayAnimation("empty")
		if IsValidVictim(other) then
			SpawnPrefab("statue_transition").Transform:SetPosition(other:GetPosition():Get())
			SpawnPrefab("statue_transition_2").Transform:SetPosition(other:GetPosition():Get())
			other.components.health:DoDelta(-hunger_current)
			if inst.components.sanity then
				inst.components.sanity:DoDelta(5)
			end
		end end end
	end)
end)

--- Widget click skills (Sneak attack)
local function SneakAttack(inst, data)
	local other = data.target
	if IsValidVictim(other) then
	if not inst:HasTag("SecondForm") then
		if inst.components.explevel:Level1Backstab() then
			inst.components.talker:Say("Backstab Successful!\n- [ [1/8] | Damage: 125")
			other.components.health:DoDelta(-125)
			DoDeltaCost(inst, "sanity", 12)
		elseif inst.components.explevel:Level2Backstab() then
			inst.components.talker:Say("Backstab Successful!\n- [ [2/8] | Damage: 150")
			other.components.health:DoDelta(-150)
			DoDeltaCost(inst, "sanity", 16)
		elseif inst.components.explevel:Level3Backstab() then
			inst.components.talker:Say("Backstab Successful!\n- [ [3/8] | Damage: 175")
			other.components.health:DoDelta(-175)
			DoDeltaCost(inst, "sanity", 20)
		elseif inst.components.explevel:Level4Backstab() then
			inst.components.talker:Say("Backstab Successful!\n- [ [4/8] | Damage: 200")
			other.components.health:DoDelta(-200)
			DoDeltaCost(inst, "sanity", 25)
		elseif inst.components.explevel:Level5Backstab() then
			inst.components.talker:Say("Backstab Successful!\n- [ [5/8] | Damage: 250")
			other.components.health:DoDelta(-250)
			DoDeltaCost(inst, "sanity", 28)
		elseif inst.components.explevel:Level6Backstab() then
			inst.components.talker:Say("Backstab Successful!\n- [ [6/8] | Damage: 275")
			other.components.health:DoDelta(-275)
			DoDeltaCost(inst, "sanity", 33)
		elseif inst.components.explevel:Level7Backstab() then
			inst.components.talker:Say("Backstab Successful!\n- [ [7/8] | Damage: 300")
			other.components.health:DoDelta(-300)
			DoDeltaCost(inst, "sanity", 35)
		elseif inst.components.explevel:LevelMaxBackstab() then
			inst.components.talker:Say("Backstab Successful!\n- [ [8/8] | Damage: 325")
			other.components.health:DoDelta(-325)
			DoDeltaCost(inst, "sanity", 37)
		end
	elseif inst:HasTag("SecondForm") then
	if other.components.freezable then
		if inst.components.explevel:Level1Backstab() then
			inst.components.talker:Say("Backstab Successful!\n- [ [1/8] | Damage: 150")
			other.components.health:DoDelta(-150)
			other.components.freezable:AddColdness(1)
			DoDeltaCost(inst, "sanity", 15)
		elseif inst.components.explevel:Level2Backstab() then
			inst.components.talker:Say("Backstab Successful!\n- [ [2/8] | Damage: 200")
			other.components.health:DoDelta(-200)
			other.components.freezable:AddColdness(2)
			DoDeltaCost(inst, "sanity", 18)
		elseif inst.components.explevel:Level3Backstab() then
			inst.components.talker:Say("Backstab Successful!\n- [ [3/8] | Damage: 250")
			other.components.health:DoDelta(-250)
			other.components.freezable:AddColdness(3)
			DoDeltaCost(inst, "sanity", 22)
		elseif inst.components.explevel:Level4Backstab() then
			inst.components.talker:Say("Backstab Successful!\n- [ [4/8] | Damage: 300")
			other.components.health:DoDelta(-300)
			other.components.freezable:AddColdness(4)
			DoDeltaCost(inst, "sanity", 25)
		elseif inst.components.explevel:Level5Backstab() then
			inst.components.talker:Say("Backstab Successful!\n- [ [5/8] | Damage: 350")
			other.components.health:DoDelta(-350)
			other.components.freezable:AddColdness(5)
			DoDeltaCost(inst, "sanity", 30)
		elseif inst.components.explevel:Level6Backstab() then
			inst.components.talker:Say("Backstab Successful!\n- [ [6/8] | Damage: 400")
			other.components.health:DoDelta(-400)
			other.components.freezable:AddColdness(6)
			DoDeltaCost(inst, "sanity", 33)
		elseif inst.components.explevel:Level7Backstab() then
			inst.components.talker:Say("Backstab Successful!\n- [ [7/8] | Damage: 450")
			other.components.health:DoDelta(-450)
			other.components.freezable:AddColdness(7)
			DoDeltaCost(inst, "sanity", 35)
		elseif inst.components.explevel:LevelMaxBackstab() then
			inst.components.talker:Say("Backstab Successful!\n- [ [8/8] | Damage: 500")
			other.components.health:DoDelta(-500)
			other.components.freezable:AddColdness(8)
			DoDeltaCost(inst, "sanity", 40)
		end
	else
	-- Do ignite instead
		if other.components.burnable then other.components.burnable:Ignite() end
		if other.components.burnable:IsBurning() then other.components.burnable:Extinguish() end
		if inst.components.explevel:Level1Backstab() then
			inst.components.talker:Say("Backstab Successful!\n- [ [1/8] | Damage: 150")
			other.components.health:DoDelta(-150)
			DoDeltaCost(inst, "sanity", 15)
		elseif inst.components.explevel:Level2Backstab() then
			inst.components.talker:Say("Backstab Successful!\n- [ [2/8] | Damage: 200")
			other.components.health:DoDelta(-200)
			DoDeltaCost(inst, "sanity", 18)
		elseif inst.components.explevel:Level3Backstab() then
			inst.components.talker:Say("Backstab Successful!\n- [ [3/8] | Damage: 250.")
			other.components.health:DoDelta(-250)
			DoDeltaCost(inst, "sanity", 22)
		elseif inst.components.explevel:Level4Backstab() then
			inst.components.talker:Say("Backstab Successful!\n- [ [4/8] | Damage: 300")
			other.components.health:DoDelta(-300)
			DoDeltaCost(inst, "sanity", 25)
		elseif inst.components.explevel:Level5Backstab() then
			inst.components.talker:Say("Backstab Successful!\n- [ [5/8] | Damage: 350")
			other.components.health:DoDelta(-350)
			DoDeltaCost(inst, "sanity", 30)
		elseif inst.components.explevel:Level6Backstab() then
			inst.components.talker:Say("Backstab Successful!\n- [ [6/8] | Damage: 400")
			other.components.health:DoDelta(-400)
			DoDeltaCost(inst, "sanity", 33)
		elseif inst.components.explevel:Level7Backstab() then
			inst.components.talker:Say("Backstab Successful!\n- [ [7/8] | Damage: 450")
			other.components.health:DoDelta(-450)
			DoDeltaCost(inst, "sanity", 35)
		elseif inst.components.explevel:LevelMaxBackstab() then
			inst.components.talker:Say("Backstab Successful!\n- [ [8/8] | Damage: 500")
			other.components.health:DoDelta(-500)
			DoDeltaCost(inst, "sanity", 40)
		end
	end end
	if inst.timerInShadow ~= nil then
		inst.timerInShadow:Cancel()
		inst.timerInShadow = nil
	end
	inst:RemoveTag("insomniac")
	inst:RemoveTag("notarget")
	inst.sneakatk_isactive = false
	inst:RemoveEventCallback("onhitother", SneakAttack)
	inst.components.colourtweener:StartTween({1,1,1,1}, 0)
	SpawnPrefab("statue_transition").Transform:SetPosition(other:GetPosition():Get())
	SpawnPrefab("statue_transition_2").Transform:SetPosition(other:GetPosition():Get())
	end
end
local function Unhide(inst)
	if inst.sneakatk_isactive then
		inst:RemoveTag("insomniac")
		inst:RemoveTag("notarget")
		inst.sneakatk_isactive = false
		inst.components.colourtweener:StartTween({1,1,1,1}, 0)
	local fx1=SpawnPrefab("fx_dark_shield");fx1.Transform:SetScale(.3, .3, .3);fx1.Transform:SetPosition(inst:GetPosition():Get())
	local fx2=SpawnPrefab("statue_transition_2");fx2.Transform:SetScale(1.1, 1.1, 1.1);fx2.Transform:SetPosition(inst:GetPosition():Get())
		inst:RemoveEventCallback("attacked", Unhide)
		inst:RemoveEventCallback("onhitother", SneakAttack)
	end
end
local function Hide(inst)
	if not inst.sneakatk_isactive then
	inst:AddTag("insomniac")
		inst:AddTag("notarget")
		inst.sneakatk_isactive = true
		inst.components.colourtweener:StartTween({.3,.3,.3,.2}, 0)
	local fx1=SpawnPrefab("fx_dark_shield");fx1.Transform:SetScale(.3, .3, .3);fx1.Transform:SetPosition(inst:GetPosition():Get())
	local fx2=SpawnPrefab("statue_transition_2");fx2.Transform:SetScale(1.1, 1.1, 1.1);fx2.Transform:SetPosition(inst:GetPosition():Get())
		inst:ListenForEvent("attacked", Unhide)
		inst:ListenForEvent("onhitother", SneakAttack)
	end
end
AddPrefabPostInit("dendrobium", function(inst)
	if TagListToHide(inst) then
		inst:ListenForEvent("sneakattack_skill", function(inst)
			if inst.components.explevel:Level0Backstab() then
				return inst.components.talker:Say("No enough Exp!");
			end
			if inst.components.hunger.current < 100 then
				return inst.components.talker:Say("I'm hungry, I need food!");
			end
			if inst.components.sanity.current < 40 then
				return inst.components.talker:Say("I can't do that, I need sleep!");
			end
			if IsNotEnough(inst, "energy", 7) then
				return inst.components.talker:Say("No enough energy to do that");
			end
			if not inst.sneakatk_isactive then
			if inst.sg:HasStateTag("moving") then
				DoDeltaCost(inst, "energy", -2) inst.sg:GoToState("repelled") else inst.sg:GoToState("startchanneling")
			end
			Hide(inst)
			DoDeltaCost(inst, "energy", -7)
			if inst.components.explevel:Level1Backstab() then
				inst.components.talker:Say("Backstab\n- [ [1/8] | READY ] -")
				DoDeltaCost(inst, "sanity", -10)
			elseif inst.components.explevel:Level2Backstab() then
				inst.components.talker:Say("Backstab\n- [ [2/8] | READY ] -")
				DoDeltaCost(inst, "sanity", -14)
			elseif inst.components.explevel:Level3Backstab() then
				inst.components.talker:Say("Backstab\n- [ [3/8] | READY ] -")
				DoDeltaCost(inst, "sanity", -18)
			elseif inst.components.explevel:Level4Backstab() then
				inst.components.talker:Say("Backstab\n- [ [4/8] | READY ] -")
				DoDeltaCost(inst, "sanity", -22)
			elseif inst.components.explevel:Level5Backstab() then
				inst.components.talker:Say("Backstab\n- [ [5/8] | READY ] -")
				DoDeltaCost(inst, "sanity", -26)
			elseif inst.components.explevel:Level6Backstab() then
				inst.components.talker:Say("Backstab\n- [ [6/8] | READY ] -")
				DoDeltaCost(inst, "sanity", -30)
			elseif inst.components.explevel:Level7Backstab() then
				inst.components.talker:Say("Backstab\n- [ [7/8] | READY ] -")
				DoDeltaCost(inst, "sanity", -32)
			elseif inst.components.explevel:LevelMaxBackstab() then
				inst.components.talker:Say("Backstab\n- [ [8/8] | READY ] -")
				DoDeltaCost(inst, "sanity", -35)
			end
			inst.timerInShadow = inst:DoTaskInTime(20, function() Unhide(inst) end)
			elseif inst.sneakatk_isactive then
			Unhide(inst)
			if inst.components.explevel:Level1Backstab() then
				inst.components.talker:Say("Backstab\n- [ [1/8] | CANCEL ] -")
				DoDeltaCost(inst, "sanity", 8)
			elseif inst.components.explevel:Level2Backstab() then
				inst.components.talker:Say("Backstab\n- [ [2/8] | CANCEL ] -")
				DoDeltaCost(inst, "sanity", 12)
			elseif inst.components.explevel:Level3Backstab() then
				inst.components.talker:Say("Backstab\n- [ [3/8] | CANCEL ] -")
				DoDeltaCost(inst, "sanity", 16)
			elseif inst.components.explevel:Level4Backstab() then
				inst.components.talker:Say("Backstab\n- [ [4/8] | CANCEL ] -")
				DoDeltaCost(inst, "sanity", 20)
			elseif inst.components.explevel:Level5Backstab() then
				inst.components.talker:Say("Backstab\n- [ [5/8] | CANCEL ] -")
				DoDeltaCost(inst, "sanity", 24)
			elseif inst.components.explevel:Level6Backstab() then
				inst.components.talker:Say("Backstab\n- [ [6/8] | CANCEL ] -")
				DoDeltaCost(inst, "sanity", 28)
			elseif inst.components.explevel:Level7Backstab() then
				inst.components.talker:Say("Backstab\n- [ [7/8] | CANCEL ] -")
				DoDeltaCost(inst, "sanity", 30)
			elseif inst.components.explevel:LevelMaxBackstab() then
				inst.components.talker:Say("Backstab\n- [ [8/8] | CANCEL ] -")
				DoDeltaCost(inst, "sanity", 32)
			end
			if inst.timerInShadow ~= nil then
				inst.timerInShadow:Cancel()
				inst.timerInShadow = nil
			end end
		end)
	end
end)

--- Widget click skills (Bedroll)
local function RestTick(inst)
    local isstarving = false
    local HUNGER_REST_PER_TICK = 0
    local SANITY_REST_PER_TICK = 1
    local HEALTH_REST_PER_TICK = 1
	local SLEEP_TEMP_PER_TICK = 1
	local SLEEP_TARGET_TEMP = 27
    if inst.components.hunger ~= nil then
        inst.components.hunger:DoDelta(HUNGER_REST_PER_TICK, true, true)
        isstarving = inst.components.hunger:IsStarving()
    end
    if inst.components.sanity ~= nil and inst.components.sanity:GetPercentWithPenalty() < 1 then
        inst.components.sanity:DoDelta(SANITY_REST_PER_TICK, true)
    end
    if not isstarving and inst.components.health ~= nil then
        inst.components.health:DoDelta(HEALTH_REST_PER_TICK, true, nil, true)
    end
    if inst.components.temperature ~= nil then
        if inst.components.temperature:GetCurrent() < SLEEP_TARGET_TEMP then
            inst.components.temperature:SetTemperature(inst.components.temperature:GetCurrent() + SLEEP_TEMP_PER_TICK)
        elseif inst.components.temperature:GetCurrent() > SLEEP_TARGET_TEMP then
            inst.components.temperature:SetTemperature(inst.components.temperature:GetCurrent() - SLEEP_TEMP_PER_TICK)
        end
    end
    if isstarving then
		inst.sg:GoToState("restingwake")
		inst.isresting = false
    end
end
local function attackdrest(inst)
	if inst.resttask ~= nil then inst.resttask:Cancel() inst.resttask = nil end
	if inst.warncheck ~= nil then inst.warncheck:Cancel() inst.warncheck = nil end
	inst:RemoveEventCallback("attacked", attackdrest)
end
AddPrefabPostInit("dendrobium", function(inst)
	inst:ListenForEvent("sleep_skill", function(inst)
		local x,y,z = inst.Transform:GetWorldPosition()
		local warning = TheSim:FindEntities(x, y, z, 17, nil, DANGER_CANT_TAGS, DANGER_MUST_TAGS)
		if inst.components.sanity.current < 20 then
			return inst.components.talker:Say("I can't do that, it is too dangerous to rest now!");
		end
		if #warning > 0 then
			return inst.components.talker:Say("I can't do that, it is too dangerous to rest here!")
		else
			if not inst.sneakatk_isactive then
				if not inst.sg:HasStateTag("resting") then
					inst.isresting = true
					inst.sg:GoToState("resting")
					inst:ListenForEvent("attacked", attackdrest)
					if inst.resttask ~= nil then inst.resttask:Cancel() end
					inst.resttask = inst:DoPeriodicTask(1, function(inst) RestTick(inst) end)
				elseif inst.sg:HasStateTag("resting") and inst.isresting then
					inst.isresting = false
					inst.sg:GoToState("restingwake")
					inst:RemoveEventCallback("attacked", attackdrest)
					if inst.resttask ~= nil then inst.resttask:Cancel() inst.resttask = nil end
				end
			end
		end
	end)
end)

--- Widget click skills (Bedroll)
AddPrefabPostInit("dendrobium", function(inst)
	inst:ListenForEvent("transform_skill", function(inst)
		if not inst.transformS then
			inst.transformS = true
			
			inst:DoTaskInTime(20, function() 
				inst.transformS = false 
			
			end)
		end
	end)
end)

--- Key press skills (Level info)
AddModRPCHandler("dendrobium", "LevelInfo", function(inst)
	if TagListToCast(inst) and not inst.iscasting then
	inst.iscasting = true
	local maxp=math.floor(inst.components.explevel.max_levelxp-0)
	local curxp=math.floor(inst.components.explevel.min_levelxp-0)
	local totalexp = ""..math.floor(curxp*inst.components.explevel.max_levelxp/maxp)..""
	if inst.components.explevel:Level1() then
		inst.components.talker:Say("[ Level: 0 ]\n[ Exp : "..(totalexp).." ]", 5)
	elseif inst.components.explevel:Level2() then
		inst.components.talker:Say("[ Level: 1 ]\n[ Exp : "..(totalexp).." ]", 5)
	elseif inst.components.explevel:Level3() then
		inst.components.talker:Say("[ Level: 2 ]\n[ Exp : "..(totalexp).." ]", 5)
	elseif inst.components.explevel:Level4() then
		inst.components.talker:Say("[ Level: 3 ]\n[ Exp : "..(totalexp).." ]", 5)
	elseif inst.components.explevel:Level5() then
		inst.components.talker:Say("[ Level: 4 ]\n[ Exp : "..(totalexp).." ]", 5)
	elseif inst.components.explevel:Level6() then
		inst.components.talker:Say("[ Level: 5 ]\n[ Exp : "..(totalexp).." ]", 5)
	elseif inst.components.explevel:Level7() then
		inst.components.talker:Say("[ Level: 6 ]\n[ Exp : "..(totalexp).." ]", 5)
	elseif inst.components.explevel:Level8() then
		inst.components.talker:Say("[ Level: 7 ]\n[ Exp : "..(totalexp).." ]", 5)
	elseif inst.components.explevel:Level9() then
		inst.components.talker:Say("[ Level: 8 ]\n[ Exp : "..(totalexp).." ]", 5)
	elseif inst.components.explevel:Level10() then
		inst.components.talker:Say("[ Level: 9 ]\n[ Exp : "..(totalexp).." ]", 5)
	elseif inst.components.explevel:Level11() then
		inst.components.talker:Say("[ Level: 10 ]\n[ Exp : "..(totalexp).." ]", 5)
	elseif inst.components.explevel:Level12() then
		inst.components.talker:Say("[ Level: 11 ]\n[ Exp : "..(totalexp).." ]", 5)
	elseif inst.components.explevel:Level13() then
		inst.components.talker:Say("[ Level: 12 ]\n[ Exp : "..(totalexp).." ]", 5)
	elseif inst.components.explevel:Level14() then
		inst.components.talker:Say("[ Level: 13 ]\n[ Exp : "..(totalexp).." ]", 5)
	elseif inst.components.explevel:Level15() then
		inst.components.talker:Say("[ Level: 14 ]\n[ Exp : "..(totalexp).." ]", 5)
	elseif inst.components.explevel:Level16() then
		inst.components.talker:Say("[ Level: 15 ]\n[ Exp : "..(totalexp).." ]", 5)
	elseif inst.components.explevel:Level17() then
		inst.components.talker:Say("[ Level: 16 ]\n[ Exp : "..(totalexp).." ]", 5)
	elseif inst.components.explevel:Level18() then
		inst.components.talker:Say("[ Level: 17 ]\n[ Exp : "..(totalexp).." ]", 5)
	elseif inst.components.explevel:Level19() then
		inst.components.talker:Say("[ Level: 18 ]\n[ Exp : "..(totalexp).." ]", 5)
	elseif inst.components.explevel:Level20() then
		inst.components.talker:Say("[ Level: 19 ]\n[ Exp : "..(totalexp).." ]", 5)
	elseif inst.components.explevel:Level21() then
		inst.components.talker:Say("[ Level: 20 ]\n[ Exp : "..(totalexp).." ]", 5)
	elseif inst.components.explevel:Level22() then
		inst.components.talker:Say("[ Level: 21 ]\n[ Exp : "..(totalexp).." ]", 5)
	elseif inst.components.explevel:Level23() then
		inst.components.talker:Say("[ Level: 22 ]\n[ Exp : "..(totalexp).." ]", 5)
	elseif inst.components.explevel:Level24() then
		inst.components.talker:Say("[ Level: 23 ]\n[ Exp : "..(totalexp).." ]", 5)
	elseif inst.components.explevel:Level25() then
		inst.components.talker:Say("[ Level: 24 ]\n[ Exp : "..(totalexp).." ]", 5)
	elseif inst.components.explevel:Level26() then
		inst.components.talker:Say("[ Level: 25 ]\n[ Exp : "..(totalexp).." ]", 5)
	elseif inst.components.explevel:Level27() then
		inst.components.talker:Say("[ Level: 26 ]\n[ Exp : "..(totalexp).." ]", 5)
	elseif inst.components.explevel:Level28() then
		inst.components.talker:Say("[ Level: 27 ]\n[ Exp : "..(totalexp).." ]", 5)
	elseif inst.components.explevel:Level29() then
		inst.components.talker:Say("[ Level: 28 ]\n[ Exp : "..(totalexp).." ]", 5)
	elseif inst.components.explevel:Level30() then
		inst.components.talker:Say("[ Level: 29 ]\n[ Exp : "..(totalexp).." ]", 5)
	elseif inst.components.explevel:Level31() then
		inst.components.talker:Say("[ Level: 30 ]\n[ Exp : "..(totalexp).." ]", 5)
	elseif inst.components.explevel:Level32() then
		inst.components.talker:Say("[ Level: 31 ]\n[ Exp : "..(totalexp).." ]", 5)
	elseif inst.components.explevel:Level33() then
		inst.components.talker:Say("[ Level: 32 ]\n[ Exp : "..(totalexp).." ]", 5)
	elseif inst.components.explevel:Level34() then
		inst.components.talker:Say("[ Level: 33 ]\n[ Exp : "..(totalexp).." ]", 5)
	elseif inst.components.explevel:Level35() then
		inst.components.talker:Say("[ Level: 34 ]\n[ Exp : "..(totalexp).." ]", 5)
	elseif inst.components.explevel:Level36() then
		inst.components.talker:Say("[ Level: 35 ]\n[ Exp : "..(totalexp).." ]", 5)
	elseif inst.components.explevel:Level37() then
		inst.components.talker:Say("[ Level: 36 ]\n[ Exp : "..(totalexp).." ]", 5)
	elseif inst.components.explevel:Level38() then
		inst.components.talker:Say("[ Level: 37 ]\n[ Exp : "..(totalexp).." ]", 5)
	elseif inst.components.explevel:Level39() then
		inst.components.talker:Say("[ Level: 38 ]\n[ Exp : "..(totalexp).." ]", 5)
	elseif inst.components.explevel:Level40() then
		inst.components.talker:Say("[ Level: 39 ]\n[ Exp : "..(totalexp).." ]", 5)
	elseif inst.components.explevel:Level41() then
		inst.components.talker:Say("[ Level: 40 ]\n[ Exp : "..(totalexp).." ]", 5)
	elseif inst.components.explevel:Level42() then
		inst.components.talker:Say("[ Level: 41 ]\n[ Exp : "..(totalexp).." ]", 5)
	elseif inst.components.explevel:Level43() then
		inst.components.talker:Say("[ Level: 42 ]\n[ Exp : "..(totalexp).." ]", 5)
	elseif inst.components.explevel:Level44() then
		inst.components.talker:Say("[ Level: 43 ]\n[ Exp : "..(totalexp).." ]", 5)
	elseif inst.components.explevel:Level45() then
		inst.components.talker:Say("[ Level: 44 ]\n[ Exp : "..(totalexp).." ]", 5)
	elseif inst.components.explevel:Level46() then
		inst.components.talker:Say("[ Level: 45 ]\n[ Exp : "..(totalexp).." ]", 5)
	elseif inst.components.explevel:Level47() then
		inst.components.talker:Say("[ Level: 46 ]\n[ Exp : "..(totalexp).." ]", 5)
	elseif inst.components.explevel:Level48() then
		inst.components.talker:Say("[ Level: 47 ]\n[ Exp : "..(totalexp).." ]", 5)
	elseif inst.components.explevel:Level49() then
		inst.components.talker:Say("[ Level: 48 ]\n[ Exp : "..(totalexp).." ]", 5)
	elseif inst.components.explevel:Level50() then
		inst.components.talker:Say("[ Level: 49 ]\n[ Exp : "..(totalexp).." ]", 5)
	elseif inst.components.explevel:Level51() then
		inst.components.talker:Say("[ Level: 50 ]\n[ Exp : "..(totalexp).." ]", 5)
	elseif inst.components.explevel:Level52() then
		inst.components.talker:Say("[ Level: 51 ]\n[ Exp : "..(totalexp).." ]", 5)
	elseif inst.components.explevel:Level53() then
		inst.components.talker:Say("[ Level: 52 ]\n[ Exp : "..(totalexp).." ]", 5)
	elseif inst.components.explevel:Level54() then
		inst.components.talker:Say("[ Level: 53 ]\n[ Exp : "..(totalexp).." ]", 5)
	elseif inst.components.explevel:Level55() then
		inst.components.talker:Say("[ Level: 54 ]\n[ Exp : "..(totalexp).." ]", 5)
	elseif inst.components.explevel:Level56() then
		inst.components.talker:Say("[ Level: 55 ]\n[ Exp : "..(totalexp).." ]", 5)
	elseif inst.components.explevel:Level57() then
		inst.components.talker:Say("[ Level: 56 ]\n[ Exp : "..(totalexp).." ]", 5)
	elseif inst.components.explevel:Level58() then
		inst.components.talker:Say("[ Level: 57 ]\n[ Exp : "..(totalexp).." ]", 5)
	elseif inst.components.explevel:Level59() then
		inst.components.talker:Say("[ Level: 58 ]\n[ Exp : "..(totalexp).." ]", 5)
	elseif inst.components.explevel:Level60() then
		inst.components.talker:Say("[ Level: 59 ]\n[ Exp : "..(totalexp).." ]", 5)
	elseif inst.components.explevel:Level61() then
		inst.components.talker:Say("[ Level: 60 ]\n[ Exp : "..(totalexp).." ]", 5)
	elseif inst.components.explevel:Level62() then
		inst.components.talker:Say("[ Level: 01 ]\n[ Exp : "..(totalexp).." ]", 5)
	elseif inst.components.explevel:Level63() then
		inst.components.talker:Say("[ Level: 62 ]\n[ Exp : "..(totalexp).." ]", 5)
	elseif inst.components.explevel:Level64() then
		inst.components.talker:Say("[ Level: 63 ]\n[ Exp : "..(totalexp).." ]", 5)
	elseif inst.components.explevel:Level65() then
		inst.components.talker:Say("[ Level: 64 ]\n[ Exp : "..(totalexp).." ]", 5)
	elseif inst.components.explevel:Level66() then
		inst.components.talker:Say("[ Level: 65 ]\n[ Exp : "..(totalexp).." ]", 5)
	elseif inst.components.explevel:Level67() then
		inst.components.talker:Say("[ Level: 66 ]\n[ Exp : "..(totalexp).." ]", 5)
	elseif inst.components.explevel:Level68() then
		inst.components.talker:Say("[ Level: 67 ]\n[ Exp : "..(totalexp).." ]", 5)
	elseif inst.components.explevel:Level69() then
		inst.components.talker:Say("[ Level: 68 ]\n[ Exp : "..(totalexp).." ]", 5)
	elseif inst.components.explevel:Level70() then
		inst.components.talker:Say("[ Level: 69 ]\n[ Exp : "..(totalexp).." ]", 5)
	elseif inst.components.explevel:Level71() then
		inst.components.talker:Say("[ Level: 70 ]\n[ Exp : "..(totalexp).." ]", 5)
	elseif inst.components.explevel:Level72() then
		inst.components.talker:Say("[ Level: 71 ]\n[ Exp : "..(totalexp).." ]", 5)
	elseif inst.components.explevel:Level73() then
		inst.components.talker:Say("[ Level: 72 ]\n[ Exp : "..(totalexp).." ]", 5)
	elseif inst.components.explevel:Level74() then
		inst.components.talker:Say("[ Level: 73 ]\n[ Exp : "..(totalexp).." ]", 5)
	elseif inst.components.explevel:Level75() then
		inst.components.talker:Say("[ Level: 74 ]\n[ Exp : "..(totalexp).." ]", 5)
	elseif inst.components.explevel:Level76() then
		inst.components.talker:Say("[ Level: 75 ]\n[ Exp : "..(totalexp).." ]", 5)
	elseif inst.components.explevel:Level77() then
		inst.components.talker:Say("[ Level: 76 ]\n[ Exp : "..(totalexp).." ]", 5)
	elseif inst.components.explevel:Level78() then
		inst.components.talker:Say("[ Level: 77 ]\n[ Exp : "..(totalexp).." ]", 5)
	elseif inst.components.explevel:Level79() then
		inst.components.talker:Say("[ Level: 78 ]]\n[ Exp : "..(totalexp).." ]", 5)
	elseif inst.components.explevel:Level80() then
		inst.components.talker:Say("[ Level: 79 ]\n[ Exp : "..(totalexp).." ]", 5)
	elseif inst.components.explevel:LevelMax() then
		inst.components.talker:Say("[ Level: 80 ]\n[ Exp : "..(totalexp).." ]", 5)
	end 
		inst:DoTaskInTime(0.5, function() inst.iscasting = false end)
	end
end)

--- Key press skills (Spell switch)
AddModRPCHandler("dendrobium", "SpellSwitcher", function(inst) 
	if TagListToCast(inst) and not inst.iscasting then
	inst.iscasting = true
	if  inst.spellpower_count == (0) then
		DoDeltaCost(inst, "energy", -1)
		inst.spellpower_count = inst.spellpower_count + 1
		inst.components.talker:Say("Spell Power \n[ - [1/4] - ]", 2)
	elseif inst.spellpower_count == (1) then
		DoDeltaCost(inst, "energy", -1)
		inst.spellpower_count = inst.spellpower_count + 1
		inst.components.talker:Say("Spell Power \n[ - [2/4] - ]", 2)
	elseif inst.spellpower_count == (2) then
		DoDeltaCost(inst, "energy", -1)
		inst.spellpower_count = inst.spellpower_count + 1
		inst.components.talker:Say("Spell Power \n[ - [3/4] - ]", 2)
	elseif inst.spellpower_count == (3) then
		DoDeltaCost(inst, "energy", -1)
		inst.spellpower_count = inst.spellpower_count + 1
		inst.components.talker:Say("Spell Power \n[ - [4/4] - ]", 2)
	elseif inst.spellpower_count == (4) then
		DoDeltaCost(inst, "energy", -1)
		inst.spellpower_count = inst.spellpower_count - 4
		inst.components.talker:Say("Spell Power \n[ - [OFF] - ]", 2)
	end 
		inst:DoTaskInTime(0.5, function() inst.iscasting = false end)
	end
end)

--- Key press skills (Switch hit power type)
AddModRPCHandler("dendrobium", "HitType", function(inst)
	if TagListToCast(inst) and not inst.iscasting then
	inst.iscasting = true
	if inst.hit_type == 0 then
		DoDeltaCost(inst, "energy", -1)
		inst.hit_type = inst.hit_type + 1
		inst.hit_count = inst.hit_count * 0
		inst.hitcount_badge:GetAnimState():PlayAnimation("empty")
		inst.components.talker:Say("Heal Attack\n[ - [1/4] - ]", 2)
	elseif inst.hit_type == 1 then
		DoDeltaCost(inst, "energy", -1)
		inst.hit_type = inst.hit_type + 1
		inst.hit_count = inst.hit_count * 0
		inst.hitcount_badge:GetAnimState():PlayAnimation("empty")
		inst.components.talker:Say("Fire Attack\n[ - [2/4] - ]", 2)
	elseif inst.hit_type == 2 then
		DoDeltaCost(inst, "energy", -1)
		inst.hit_type = inst.hit_type + 1
		inst.hit_count = inst.hit_count * 0
		inst.hitcount_badge:GetAnimState():PlayAnimation("empty")
		inst.components.talker:Say("Ice Attack\n[ - [3/4] - ]", 2)
	elseif inst.hit_type == 3 then
		DoDeltaCost(inst, "energy", -1)
		inst.hit_type = inst.hit_type + 1
		inst.hit_count = inst.hit_count * 0
		inst.hitcount_badge:GetAnimState():PlayAnimation("empty")
		inst.components.talker:Say("Shadow Attack\n[ - [4/4] - ]", 2)
	elseif inst.hit_type == 4 then
		DoDeltaCost(inst, "energy", -1)
		inst.hit_type = inst.hit_type * 0
		inst.hit_count = inst.hit_count * 0
		inst.hitcount_badge:GetAnimState():PlayAnimation("empty")
		inst.components.talker:Say("Normal Attack\n[ - [0/0] - ]", 2)
	end 
		inst:DoTaskInTime(0.5, function() inst.iscasting = false end)
	end
end)

-- Character keyhandler (Required in modinfo.lua)
TUNING.DENDROBIUM = {}
TUNING.DENDROBIUM.KEY_1 = GetModConfigData("Key1") -- [Z]
TUNING.DENDROBIUM.KEY_2 = GetModConfigData("Key2") -- [V]
TUNING.DENDROBIUM.KEY_3 = GetModConfigData("Key3") -- [X]

-- General
STRINGS.CHARACTERS.GENERIC.DESCRIBE.DENDROBIUM = {
	GENERIC = "Hello!",
	ATTACKER = "The Evil.",
	MURDERER = "The Killers.",
	REVIVER = "Friend of ghost.",
	GHOST = "Want to use a heart.",
}
STRINGS.CHARACTER_TITLES.dendrobium = "The Last Fallen Knight"
STRINGS.CHARACTER_NAMES.dendrobium = "Dendrobium"
STRINGS.CHARACTER_DESCRIPTIONS.dendrobium = "*Can hit harder when full\n*Blessed with unique abilities\n*Randomized"
STRINGS.CHARACTER_QUOTES.dendrobium = "\"Nothing can stop me!\""
STRINGS.CHARACTERS.DENDROBIUM = require "speech_dendrobium"
STRINGS.NAMES.DENDROBIUM = "Dendrobium"

-- Add mod character to mod character list. Also specify a gender. Possible genders are MALE, FEMALE, ROBOT, NEUTRAL, and PLURAL.
AddModCharacter("dendrobium", "FEMALE")