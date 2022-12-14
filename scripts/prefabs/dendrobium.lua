local MakePlayerCharacter = require "prefabs/player_common"
local assets = {
    Asset("SCRIPT", "scripts/prefabs/player_common.lua"),
	--- Image Buttons
	Asset( "IMAGE", "character/skills/buttons/bloom_domain.tex" ),
    Asset( "ATLAS", "character/skills/buttons/bloom_domain.xml" ),
	Asset( "IMAGE", "character/skills/buttons/healing_domain.tex" ),
    Asset( "ATLAS", "character/skills/buttons/healing_domain.xml" ),
	Asset( "IMAGE", "character/skills/buttons/shadow_guardian.tex" ),
    Asset( "ATLAS", "character/skills/buttons/shadow_guardian.xml" ),
	Asset( "IMAGE", "character/skills/buttons/shadow_worker.tex" ),
    Asset( "ATLAS", "character/skills/buttons/shadow_worker.xml" ),
	Asset( "IMAGE", "character/skills/buttons/sneak_attack.tex" ),
    Asset( "ATLAS", "character/skills/buttons/sneak_attack.xml" ),
	Asset( "IMAGE", "character/skills/buttons/treasure_tracker.tex" ),
    Asset( "ATLAS", "character/skills/buttons/treasure_tracker.xml" ),
}

TUNING.DENDROBIUM_HEALTH = 100
TUNING.DENDROBIUM_HUNGER = 300
TUNING.DENDROBIUM_SANITY = 100
TUNING.GAMEMODE_STARTING_ITEMS.DEFAULT.DENDROBIUM = { "lantern" }

local start_inv = { "" }
for k, v in pairs(TUNING.GAMEMODE_STARTING_ITEMS) do
    start_inv[string.lower(k)] = v.DENDROBIUM
end
local prefabs = FlattenTree(start_inv, true)

-- Apply Exp from kill
local function ApplyExpLevel(inst, data)
	local maxp=math.floor(inst.components.explevel.max_levelxp-0)
	local curxp=math.floor(inst.components.explevel.min_levelxp-0)
	local totalexp = ""..math.floor(curxp*inst.components.explevel.max_levelxp/maxp)..""

	local health_percent = inst.components.health:GetPercent()
	local sanity_percent = inst.components.sanity:GetPercent()
	local shield_percent = inst.components.orchidacite:GetPercent("shield")

	if inst.components.explevel.min_levelxp <= 30376 then
		inst.components.talker:Say("[ Exp : "..(totalexp).."/30376 ]")
	end

	if inst.components.explevel:Level1() then
		inst.components.health.maxhealth = math.ceil (100)
		inst.components.sanity.max = math.ceil (100)	
		inst.components.orchidacite.max_shield = math.ceil (10)

	elseif inst.components.explevel:Level2() then
		inst.components.health.maxhealth = math.ceil (105)
		inst.components.sanity.max = math.ceil (100)	
		inst.components.orchidacite.max_shield = math.ceil (10)	

	elseif inst.components.explevel:Level3() then
		inst.components.health.maxhealth = math.ceil (105)
		inst.components.sanity.max = math.ceil (105)	
		inst.components.orchidacite.max_shield = math.ceil (10)	

	elseif inst.components.explevel:Level4() then
		inst.components.health.maxhealth = math.ceil (105)
		inst.components.sanity.max = math.ceil (105)	
		inst.components.orchidacite.max_shield = math.ceil (10)	

	elseif inst.components.explevel:Level5() then
		inst.components.health.maxhealth = math.ceil (110)
		inst.components.sanity.max = math.ceil (110)	
		inst.components.orchidacite.max_shield = math.ceil (10)	

	elseif inst.components.explevel:Level6() then
		inst.components.health.maxhealth = math.ceil (110)
		inst.components.sanity.max = math.ceil (110)	
		inst.components.orchidacite.max_shield = math.ceil (10)

	elseif inst.components.explevel:Level7() then
		inst.components.health.maxhealth = math.ceil (110)
		inst.components.sanity.max = math.ceil (115)
		inst.components.orchidacite.max_shield = math.ceil (10)

	elseif inst.components.explevel:Level8() then
		inst.components.health.maxhealth = math.ceil (115)
		inst.components.sanity.max = math.ceil (115)
		inst.components.orchidacite.max_shield = math.ceil (10)	

	elseif inst.components.explevel:Level9() then
		inst.components.health.maxhealth = math.ceil (115)
		inst.components.sanity.max = math.ceil (120)
		inst.components.orchidacite.max_shield = math.ceil (10)	

	elseif inst.components.explevel:Level10() then
		inst.components.health.maxhealth = math.ceil (115)
		inst.components.sanity.max = math.ceil (120)
		inst.components.orchidacite.max_shield = math.ceil (10)	

	elseif inst.components.explevel:Level11()then
		inst.components.health.maxhealth = math.ceil (120)
		inst.components.sanity.max = math.ceil (125)
		inst.components.orchidacite.max_shield = math.ceil (30)	

	elseif inst.components.explevel:Level12() then
		inst.components.health.maxhealth = math.ceil (120)
		inst.components.sanity.max = math.ceil (125)
		inst.components.orchidacite.max_shield = math.ceil (30)	

	elseif inst.components.explevel:Level13()then
		inst.components.health.maxhealth = math.ceil (120)
		inst.components.sanity.max = math.ceil (130)
		inst.components.orchidacite.max_shield = math.ceil (30)	

	elseif inst.components.explevel:Level14()then
		inst.components.health.maxhealth = math.ceil (125)
		inst.components.sanity.max = math.ceil (130)
		inst.components.orchidacite.max_shield = math.ceil (30)

	elseif inst.components.explevel:Level15() then
		inst.components.health.maxhealth = math.ceil (125)
		inst.components.sanity.max = math.ceil (135)
		inst.components.orchidacite.max_shield = math.ceil (30)	

	elseif inst.components.explevel:Level16()then
		inst.components.health.maxhealth = math.ceil (125)
		inst.components.sanity.max = math.ceil (135)
		inst.components.orchidacite.max_shield = math.ceil (30)	

	elseif inst.components.explevel:Level17()then
		inst.components.health.maxhealth = math.ceil (130)
		inst.components.sanity.max = math.ceil (140)
		inst.components.orchidacite.max_shield = math.ceil (30)	

	elseif inst.components.explevel:Level18() then
		inst.components.health.maxhealth = math.ceil (130)
		inst.components.sanity.max = math.ceil (140)
		inst.components.orchidacite.max_shield = math.ceil (30)	

	elseif inst.components.explevel:Level19()then
		inst.components.health.maxhealth = math.ceil (130)
		inst.components.sanity.max = math.ceil (145)
		inst.components.orchidacite.max_shield = math.ceil (30)	

	elseif inst.components.explevel:Level20()then
		inst.components.health.maxhealth = math.ceil (135)
		inst.components.sanity.max = math.ceil (145)
		inst.components.orchidacite.max_shield = math.ceil (30)	

	elseif inst.components.explevel:Level21()then
		inst.components.health.maxhealth = math.ceil (135)
		inst.components.sanity.max = math.ceil (150)
		inst.components.orchidacite.max_shield = math.ceil (30)	

	elseif inst.components.explevel:Level22() then
		inst.components.health.maxhealth = math.ceil (135)
		inst.components.sanity.max = math.ceil (150)
		inst.components.orchidacite.max_shield = math.ceil (30)	

	elseif inst.components.explevel:Level23() then
		inst.components.health.maxhealth = math.ceil (140)
		inst.components.sanity.max = math.ceil (155)
		inst.components.orchidacite.max_shield = math.ceil (30)	

	elseif inst.components.explevel:Level24() then
		inst.components.health.maxhealth = math.ceil (140)
		inst.components.sanity.max = math.ceil (155)
		inst.components.orchidacite.max_shield = math.ceil (30)	

	elseif inst.components.explevel:Level25() then
		inst.components.health.maxhealth = math.ceil (140)
		inst.components.sanity.max = math.ceil (160)
		inst.components.orchidacite.max_shield = math.ceil (30)	

	elseif inst.components.explevel:Level26() then
		inst.components.health.maxhealth = math.ceil (145)
		inst.components.sanity.max = math.ceil (160)
		inst.components.orchidacite.max_shield = math.ceil (30)	

	elseif inst.components.explevel:Level27() then
		inst.components.health.maxhealth = math.ceil (145)
		inst.components.sanity.max = math.ceil (165)
		inst.components.orchidacite.max_shield = math.ceil (30)	

	elseif inst.components.explevel:Level28() then
		inst.components.health.maxhealth = math.ceil (145)
		inst.components.sanity.max = math.ceil (165)
		inst.components.orchidacite.max_shield = math.ceil (30)	

	elseif inst.components.explevel:Level29() then
		inst.components.health.maxhealth = math.ceil (150)
		inst.components.sanity.max = math.ceil (170)
		inst.components.orchidacite.max_shield = math.ceil (30)	

	elseif inst.components.explevel:Level30() then
		inst.components.health.maxhealth = math.ceil (150)
		inst.components.sanity.max = math.ceil (170)
		inst.components.orchidacite.max_shield = math.ceil (30)	

	elseif inst.components.explevel:Level31() then
		inst.components.health.maxhealth = math.ceil (150)
		inst.components.sanity.max = math.ceil (175)
		inst.components.orchidacite.max_shield = math.ceil (50)	

	elseif inst.components.explevel:Level32() then
		inst.components.health.maxhealth = math.ceil (155)
		inst.components.sanity.max = math.ceil (175)
		inst.components.orchidacite.max_shield = math.ceil (50)	

	elseif inst.components.explevel:Level33() then
		inst.components.health.maxhealth = math.ceil (155)
		inst.components.sanity.max = math.ceil (180)
		inst.components.orchidacite.max_shield = math.ceil (50)	

	elseif inst.components.explevel:Level34() then
		inst.components.health.maxhealth = math.ceil (155)
		inst.components.sanity.max = math.ceil (180)
		inst.components.orchidacite.max_shield = math.ceil (50)	

	elseif inst.components.explevel:Level35() then
		inst.components.health.maxhealth = math.ceil (160)
		inst.components.sanity.max = math.ceil (185)
		inst.components.orchidacite.max_shield = math.ceil (50)	

	elseif inst.components.explevel:Level36() then
		inst.components.health.maxhealth = math.ceil (160)
		inst.components.sanity.max = math.ceil (185)
		inst.components.orchidacite.max_shield = math.ceil (50)	

	elseif inst.components.explevel:Level37() then
		inst.components.health.maxhealth = math.ceil (160)
		inst.components.sanity.max = math.ceil (190)
		inst.components.orchidacite.max_shield = math.ceil (50)	

	elseif inst.components.explevel:Level38() then
		inst.components.health.maxhealth = math.ceil (165)
		inst.components.sanity.max = math.ceil (190)
		inst.components.orchidacite.max_shield = math.ceil (50)	

	elseif inst.components.explevel:Level39() then
		inst.components.health.maxhealth = math.ceil (165)
		inst.components.sanity.max = math.ceil (195)
		inst.components.orchidacite.max_shield = math.ceil (50)	

	elseif inst.components.explevel:Level40() then
		inst.components.health.maxhealth = math.ceil (165)
		inst.components.sanity.max = math.ceil (195)
		inst.components.orchidacite.max_shield = math.ceil (50)	

	elseif inst.components.explevel:Level41() then
		inst.components.health.maxhealth = math.ceil (170)
		inst.components.sanity.max = math.ceil (200)
		inst.components.orchidacite.max_shield = math.ceil (50)	

	elseif inst.components.explevel:Level42() then
		inst.components.health.maxhealth = math.ceil (170)
		inst.components.sanity.max = math.ceil (200)
		inst.components.orchidacite.max_shield = math.ceil (50)	

	elseif inst.components.explevel:Level43() then
		inst.components.health.maxhealth = math.ceil (170)
		inst.components.sanity.max = math.ceil (205)
		inst.components.orchidacite.max_shield = math.ceil (50)	

	elseif inst.components.explevel:Level44() then
		inst.components.health.maxhealth = math.ceil (175)
		inst.components.sanity.max = math.ceil (205)
		inst.components.orchidacite.max_shield = math.ceil (50)	

	elseif inst.components.explevel:Level45() then
		inst.components.health.maxhealth = math.ceil (175)
		inst.components.sanity.max = math.ceil (210)
		inst.components.orchidacite.max_shield = math.ceil (50)	

	elseif inst.components.explevel:Level46() then
		inst.components.health.maxhealth = math.ceil (175)
		inst.components.sanity.max = math.ceil (210)
		inst.components.orchidacite.max_shield = math.ceil (50)	

	elseif inst.components.explevel:Level47() then
		inst.components.health.maxhealth = math.ceil (180)
		inst.components.sanity.max = math.ceil (215)
		inst.components.orchidacite.max_shield = math.ceil (50)	

	elseif inst.components.explevel:Level48() then
		inst.components.health.maxhealth = math.ceil (180)
		inst.components.sanity.max = math.ceil (215)
		inst.components.orchidacite.max_shield = math.ceil (50)	

	elseif inst.components.explevel:Level49() then
		inst.components.health.maxhealth = math.ceil (180)
		inst.components.sanity.max = math.ceil (220)
		inst.components.orchidacite.max_shield = math.ceil (50)	

	elseif inst.components.explevel:Level50() then
		inst.components.health.maxhealth = math.ceil (185)
		inst.components.sanity.max = math.ceil (220)
		inst.components.orchidacite.max_shield = math.ceil (50)	

	elseif inst.components.explevel:Level51() then
		inst.components.health.maxhealth = math.ceil (185)
		inst.components.sanity.max = math.ceil (225)
		inst.components.orchidacite.max_shield = math.ceil (80)	

	elseif inst.components.explevel:Level52() then
		inst.components.health.maxhealth = math.ceil (185)
		inst.components.sanity.max = math.ceil (225)
		inst.components.orchidacite.max_shield = math.ceil (80)

	elseif inst.components.explevel:Level53() then
		inst.components.health.maxhealth = math.ceil (190)
		inst.components.sanity.max = math.ceil (230)
		inst.components.orchidacite.max_shield = math.ceil (80)

	elseif inst.components.explevel:Level54() then
		inst.components.health.maxhealth = math.ceil (190)
		inst.components.sanity.max = math.ceil (230)
		inst.components.orchidacite.max_shield = math.ceil (80)

	elseif inst.components.explevel:Level55() then
		inst.components.health.maxhealth = math.ceil (190)
		inst.components.sanity.max = math.ceil (235)
		inst.components.orchidacite.max_shield = math.ceil (80)

	elseif inst.components.explevel:Level56() then
		inst.components.health.maxhealth = math.ceil (195)
		inst.components.sanity.max = math.ceil (235)
		inst.components.orchidacite.max_shield = math.ceil (80)

	elseif inst.components.explevel:Level57() then
		inst.components.health.maxhealth = math.ceil (195)
		inst.components.sanity.max = math.ceil (240)
		inst.components.orchidacite.max_shield = math.ceil (80)

	elseif inst.components.explevel:Level58() then
		inst.components.health.maxhealth = math.ceil (195)
		inst.components.sanity.max = math.ceil (240)
		inst.components.orchidacite.max_shield = math.ceil (80)

	elseif inst.components.explevel:Level59() then
		inst.components.health.maxhealth = math.ceil (200)
		inst.components.sanity.max = math.ceil (245)
		inst.components.orchidacite.max_shield = math.ceil (80)

	elseif inst.components.explevel:Level60() then
		inst.components.health.maxhealth = math.ceil (200)
		inst.components.sanity.max = math.ceil (245)
		inst.components.orchidacite.max_shield = math.ceil (80)

	elseif inst.components.explevel:Level61() then
		inst.components.health.maxhealth = math.ceil (200)
		inst.components.sanity.max = math.ceil (250)
		inst.components.orchidacite.max_shield = math.ceil (80)

	elseif inst.components.explevel:Level62() then
		inst.components.health.maxhealth = math.ceil (205)
		inst.components.sanity.max = math.ceil (250)
		inst.components.orchidacite.max_shield = math.ceil (80)

	elseif inst.components.explevel:Level63() then
		inst.components.health.maxhealth = math.ceil (205)
		inst.components.sanity.max = math.ceil (255)
		inst.components.orchidacite.max_shield = math.ceil (80)

	elseif inst.components.explevel:Level64() then
		inst.components.health.maxhealth = math.ceil (205)
		inst.components.sanity.max = math.ceil (255)
		inst.components.orchidacite.max_shield = math.ceil (80)

	elseif inst.components.explevel:Level65() then
		inst.components.health.maxhealth = math.ceil (210)
		inst.components.sanity.max = math.ceil (260)
		inst.components.orchidacite.max_shield = math.ceil (80)

	elseif inst.components.explevel:Level66() then
		inst.components.health.maxhealth = math.ceil (210)
		inst.components.sanity.max = math.ceil (260)
		inst.components.orchidacite.max_shield = math.ceil (80)

	elseif inst.components.explevel:Level67() then
		inst.components.health.maxhealth = math.ceil (210)
		inst.components.sanity.max = math.ceil (265)
		inst.components.orchidacite.max_shield = math.ceil (80)

	elseif inst.components.explevel:Level68() then
		inst.components.health.maxhealth = math.ceil (215)
		inst.components.sanity.max = math.ceil (265)
		inst.components.orchidacite.max_shield = math.ceil (80)

	elseif inst.components.explevel:Level69() then
		inst.components.health.maxhealth = math.ceil (215)
		inst.components.sanity.max = math.ceil (270)
		inst.components.orchidacite.max_shield = math.ceil (80)

	elseif inst.components.explevel:Level70() then
		inst.components.health.maxhealth = math.ceil (215)
		inst.components.sanity.max = math.ceil (270)
		inst.components.orchidacite.max_shield = math.ceil (80)

	elseif inst.components.explevel:Level71() then
		inst.components.health.maxhealth = math.ceil (220)
		inst.components.sanity.max = math.ceil (275)
		inst.components.orchidacite.max_shield = math.ceil (100)	

	elseif inst.components.explevel:Level72() then
		inst.components.health.maxhealth = math.ceil (220)
		inst.components.sanity.max = math.ceil (280)
		inst.components.orchidacite.max_shield = math.ceil (100)	

	elseif inst.components.explevel:Level73() then
		inst.components.health.maxhealth = math.ceil (220)
		inst.components.sanity.max = math.ceil (280)
		inst.components.orchidacite.max_shield = math.ceil (100)	

	elseif inst.components.explevel:Level74() then
		inst.components.health.maxhealth = math.ceil (225)
		inst.components.sanity.max = math.ceil (285)
		inst.components.orchidacite.max_shield = math.ceil (100)	

	elseif inst.components.explevel:Level75() then
		inst.components.health.maxhealth = math.ceil (225)
		inst.components.sanity.max = math.ceil (285)
		inst.components.orchidacite.max_shield = math.ceil (100)	

	elseif inst.components.explevel:Level76() then
		inst.components.health.maxhealth = math.ceil (225)
		inst.components.sanity.max = math.ceil (290)
		inst.components.orchidacite.max_shield = math.ceil (100)	

	elseif inst.components.explevel:Level77() then
		inst.components.health.maxhealth = math.ceil (230)
		inst.components.sanity.max = math.ceil (290)
		inst.components.orchidacite.max_shield = math.ceil (100)	

	elseif inst.components.explevel:Level78() then
		inst.components.health.maxhealth = math.ceil (230)
		inst.components.sanity.max = math.ceil (295)
		inst.components.orchidacite.max_shield = math.ceil (100)	

	elseif inst.components.explevel:Level79() then
		inst.components.health.maxhealth = math.ceil (240)
		inst.components.sanity.max = math.ceil (295)
		inst.components.orchidacite.max_shield = math.ceil (100)	

	elseif inst.components.explevel:Level80() then
		inst.components.health.maxhealth = math.ceil (245)
		inst.components.sanity.max = math.ceil (300)
		inst.components.orchidacite.max_shield = math.ceil (100)	

	elseif inst.components.explevel:LevelMax() then
		inst.components.health.maxhealth = math.ceil (250)
		inst.components.sanity.max = math.ceil (300)
		inst.components.orchidacite.max_shield = math.ceil (100)	
	end
	inst.components.health:SetPercent(health_percent)
	inst.components.sanity:SetPercent(sanity_percent)
	inst.components.orchidacite:SetPercent("shield", shield_percent)
end

-- Exp on killed others
local smallScale = 0.5;
local medScale = 0.7; 
local largeScale = 1.1;

local function wathgrithr_spiritfx(inst, x, y, z, scale)
    local fx = SpawnPrefab("wathgrithr_spirit")
	fx.Transform:SetPosition(x, y, z)
	fx.Transform:SetScale(scale, scale, scale)
end

local function OnKillOther(inst, data)
	local victim = data.victim
	if victim ~= nil 
		and not (victim:HasTag("veggie") 
			or victim:HasTag("structure") 
			or victim:HasTag("wall") 
			or victim:HasTag("balloon") 
			or victim:HasTag("soulless") 
			or victim:HasTag("chess") 
			or victim:HasTag("shadow") 
			or victim:HasTag("shadowcreature") 
			or victim:HasTag("shadowminion") 
			or victim:HasTag("shadowchesspiece") 
			or victim:HasTag("groundspike") 
			or victim:HasTag("smashable")) 
		and victim.components.combat ~= nil 
		and victim.components.health ~= nil  then

		-- Hostile --
		if victim.prefab == "minotaur" then 
			inst.components.explevel:AddExp(500)
			ApplyExpLevel(inst)
		elseif victim.prefab == "batbat" then 
			inst.components.explevel:AddExp(15)
			ApplyExpLevel(inst)
		elseif victim.prefab == "killerbee" then 
			inst.components.explevel:AddExp(2)
			ApplyExpLevel(inst)
		elseif victim.prefab == "bishop" then
			inst.components.explevel:AddExp(45)
			ApplyExpLevel(inst)
		elseif victim.prefab == "bishop_nightmare" then
			inst.components.explevel:AddExp(40)
			ApplyExpLevel(inst)
		elseif victim.prefab == "knight" then
			inst.components.explevel:AddExp(35)
			ApplyExpLevel(inst)
		elseif victim.prefab == "knight_nightmare" then
			inst.components.explevel:AddExp(30)
			ApplyExpLevel(inst)
		elseif victim.prefab == "rook" then
			inst.components.explevel:AddExp(55)
			ApplyExpLevel(inst)
		elseif victim.prefab == "rook_nightmare" then
			inst.components.explevel:AddExp(50)
			ApplyExpLevel(inst)
		elseif victim.prefab == "deerclops" then
			inst.components.explevel:AddExp(600)
			ApplyExpLevel(inst)
		elseif victim.prefab == "worm" then
			inst.components.explevel:AddExp(200)
			ApplyExpLevel(inst)
		elseif victim.prefab == "spat" then 
			inst.components.explevel:AddExp(150)
			ApplyExpLevel(inst)
		elseif victim.prefab == "frog" then
			inst.components.explevel:AddExp(5)
			ApplyExpLevel(inst)
		elseif victim.prefab == "ghost" then
			inst.components.explevel:AddExp(10)
			ApplyExpLevel(inst)
		elseif victim.prefab == "hound" then
			inst.components.explevel:AddExp(25)
			ApplyExpLevel(inst)
		elseif victim.prefab == "firehound" then
			inst.components.explevel:AddExp(35)
			ApplyExpLevel(inst)
		elseif victim.prefab == "icehound" then
			inst.components.explevel:AddExp(40)
			ApplyExpLevel(inst)
		elseif victim.prefab == "moonhound" then
			inst.components.explevel:AddExp(50)
			ApplyExpLevel(inst)
		elseif victim.prefab == "clayhound" then
			inst.components.explevel:AddExp(55)
			ApplyExpLevel(inst)
		elseif victim.prefab == "walrus" then
			inst.components.explevel:AddExp(50)
			ApplyExpLevel(inst)
		elseif victim.prefab == "little_walrus" then
			inst.components.explevel:AddExp(15)
			ApplyExpLevel(inst)
		elseif victim.prefab == "merm" then
			inst.components.explevel:AddExp(30)
			ApplyExpLevel(inst)
		elseif victim.prefab == "mosquito" then
			inst.components.explevel:AddExp(3)
			ApplyExpLevel(inst)
		elseif victim.prefab == "pigguard" then
			inst.components.explevel:AddExp(30)
			ApplyExpLevel(inst)
		elseif victim.prefab == "moonpig" then
			inst.components.explevel:AddExp(40)
			ApplyExpLevel(inst)
		elseif (victim.prefab == "crawlinghorror" or victim.prefab == "crawlingnightmare") then
			inst.components.explevel:AddExp(120)
			ApplyExpLevel(inst)
		elseif (victim.prefab == "terrorbeak" or victim.prefab == "nightmarebeak") then
			inst.components.explevel:AddExp(125)
			ApplyExpLevel(inst)
		elseif victim.prefab == "slurper" then
			inst.components.explevel:AddExp(25)
			ApplyExpLevel(inst)
		elseif victim.prefab == "spider" then
			inst.components.explevel:AddExp(15)
			ApplyExpLevel(inst)
		elseif victim.prefab == "spider_warrior" then
			inst.components.explevel:AddExp(30)
			ApplyExpLevel(inst)
		elseif victim.prefab == "spider_hider" then
			inst.components.explevel:AddExp(35)
			ApplyExpLevel(inst)
		elseif victim.prefab == "spider_spitter" then
			inst.components.explevel:AddExp(40)
			ApplyExpLevel(inst)
		elseif victim.prefab == "spider_dropper" then
			inst.components.explevel:AddExp(30)
			ApplyExpLevel(inst)
		elseif victim.prefab == "tallbird" then
			inst.components.explevel:AddExp(25)
			ApplyExpLevel(inst)
		elseif victim.prefab == "tentacle" then
			inst.components.explevel:AddExp(35)
			ApplyExpLevel(inst)
		elseif victim.prefab == "tentacle_pillar_arm" then
			inst.components.explevel:AddExp(20)
			ApplyExpLevel(inst)
		elseif victim.prefab == "bearger" then
			inst.components.explevel:AddExp(800)
			ApplyExpLevel(inst)
		elseif victim.prefab == "dragonfly" then
			inst.components.explevel:AddExp(1000)
			ApplyExpLevel(inst)
		elseif victim.prefab == "moose" then
			inst.components.explevel:AddExp(250)
			ApplyExpLevel(inst)
		elseif victim.prefab == "warg" then
			inst.components.explevel:AddExp(200)
			ApplyExpLevel(inst)
		elseif victim.prefab == "monkey" and victim:HasTag("nightmare") then
			inst.components.explevel:AddExp(25)
			ApplyExpLevel(inst)
		elseif victim.prefab == "claywarg" then
			inst.components.explevel:AddExp(230)
			ApplyExpLevel(inst)
		elseif victim.prefab == "lightninggoat" and victim:HasTag("charged") then
			inst.components.explevel:AddExp(45)
			ApplyExpLevel(inst)
		elseif victim.prefab == "beequeen" then
			inst.components.explevel:AddExp(900)
			ApplyExpLevel(inst)
		elseif victim.prefab == "deer_red" then
			inst.components.explevel:AddExp(30)
			ApplyExpLevel(inst)
		elseif victim.prefab == "deer_blue" then
			inst.components.explevel:AddExp(30)
			ApplyExpLevel(inst)
		elseif victim.prefab == "beeguard" then
			inst.components.explevel:AddExp(5)
			ApplyExpLevel(inst)
		elseif victim.prefab == "klaus" then
			inst.components.explevel:AddExp(850)
			ApplyExpLevel(inst)
		elseif victim.prefab == "lavae" then
			inst.components.explevel:AddExp(60)
			ApplyExpLevel(inst)
		elseif victim.prefab == "toadstool" then
			inst.components.explevel:AddExp(1500)
			ApplyExpLevel(inst)
		elseif victim.prefab == "toadstool_dark" then
			inst.components.explevel:AddExp(2000)
			ApplyExpLevel(inst)
		-- Neutral -- 
		elseif victim.prefab == "buzzard" then
			inst.components.explevel:AddExp(25)
			ApplyExpLevel(inst)
		elseif (victim.prefab == "leif" or victim.prefab == "leif_sparse") then
			inst.components.explevel:AddExp(30)
			ApplyExpLevel(inst)
		elseif victim.prefab == "pigman" then
			inst.components.explevel:AddExp(20)
			ApplyExpLevel(inst)
		elseif victim.prefab == "penguin" then
			inst.components.explevel:AddExp(15)
			ApplyExpLevel(inst)
		elseif victim.prefab == "rocky" then
			inst.components.explevel:AddExp(40)
			ApplyExpLevel(inst)
		elseif victim.prefab == "slurtle" then
			inst.components.explevel:AddExp(30)
			ApplyExpLevel(inst)
		elseif victim.prefab == "snurtle" then
			inst.components.explevel:AddExp(35)
			ApplyExpLevel(inst)
		elseif victim.prefab == "monkey" then
			inst.components.explevel:AddExp(15)
			ApplyExpLevel(inst)
		elseif victim.prefab == "bunnyman" then
			inst.components.explevel:AddExp(20)
			ApplyExpLevel(inst)
		elseif victim.prefab == "bee" then
			inst.components.explevel:AddExp(1)
			ApplyExpLevel(inst)
		elseif victim.prefab == "beefalo" then
			inst.components.explevel:AddExp(25)
			ApplyExpLevel(inst)
		elseif victim.prefab == "koalefant_summer" then
			inst.components.explevel:AddExp(20)
			ApplyExpLevel(inst)
		elseif victim.prefab == "koalefant_winter" then
			inst.components.explevel:AddExp(22)
			ApplyExpLevel(inst)
		elseif victim.prefab == "krampus" then
			inst.components.explevel:AddExp(15)
			ApplyExpLevel(inst)
		elseif victim.prefab == "mossling" then
			inst.components.explevel:AddExp(15)
			ApplyExpLevel(inst)
		elseif victim.prefab == "catcoon" then
			inst.components.explevel:AddExp(5)
			ApplyExpLevel(inst)
		elseif victim.prefab == "lightninggoat" then
			inst.components.explevel:AddExp(30)
			ApplyExpLevel(inst)
		elseif victim.prefab == "antlion" then
			inst.components.explevel:AddExp(500)
			ApplyExpLevel(inst)
	end
	-- Soul
		local time = victim.components.health.destroytime or 2
		local x, y, z = victim.Transform:GetWorldPosition()
		local scale = (victim:HasTag("smallcreature") and smallScale)
				or (victim:HasTag("largecreature") and largeScale) or medScale
				inst:DoTaskInTime(time, wathgrithr_spiritfx, x, y, z, scale)
		SpawnPrefab("soul_orb_spawn").Transform:SetPosition(victim:GetPosition():Get())
	end
end

-- Sanity regen
local function SanityRegenfn(inst)
    local delta = 0
    local max_rad = 6
	local sanity_aura = 0.1
    local x, y, z = inst.Transform:GetWorldPosition()
    local ents = TheSim:FindEntities(x, y, z, max_rad, { "fire" })
    for i, v in ipairs(ents) do
        if v.components.burnable ~= nil and v.components.burnable:IsBurning() then
            local rad = v.components.burnable:GetLargestLightRadius() or 1
            local sz = sanity_aura * math.min(max_rad, rad) / max_rad
            local distsq = inst:GetDistanceSqToInst(v) - 9
            delta = delta + sz / math.max(1, distsq)
        end
    end
    return delta
end

-- Pets
local function DoEffects(pet)
	local x, y, z = pet.Transform:GetWorldPosition()
	SpawnPrefab("statue_transition_2").Transform:SetPosition(x, y, z)
end
local function OnSpawnPetFn(inst, pet)
	if pet:HasTag("dendrobiumshadows") then
		-- pet:DoTaskInTime(0, DoEffects)
		pet.sg:GoToState("spawnjumpout")
	end
end
local function OnDespawnPetFn(inst, pet)
	if pet:HasTag("dendrobiumshadows") then
		DoEffects(pet)
		pet:Remove()
	end
end

-- Set/Remove speed when becoming/not a ghost (optional)
local function OnBecameHumanFn(inst)
	inst.components.locomotor.walkspeed = TUNING.WILSON_WALK_SPEED*1.25    
	inst.components.locomotor.runspeed = TUNING.WILSON_RUN_SPEED*1.25 
end
local function OnBecameGhostFn(inst)
	inst.components.locomotor.walkspeed = TUNING.WILSON_WALK_SPEED*1.15    
	inst.components.locomotor.runspeed = TUNING.WILSON_RUN_SPEED*1.15 
end

-- Loading or Spawning the Character
local function OnLoadFn(inst)
    inst:ListenForEvent("ms_respawnedfromghost", OnBecameHumanFn)
    inst:ListenForEvent("ms_becameghost", OnBecameGhostFn)
    if inst:HasTag("playerghost") then
        OnBecameGhostFn(inst)
    else
        OnBecameHumanFn(inst)
    end
end

-- This initializes for both the server and client. Tags can be added here.
local common_postinit = function(inst) 
	-- Minimap icon
	inst.MiniMapEntity:SetIcon("dendrobium.tex")

	-- Status badge: quantum
	inst.widget_quantum_max = net_float(inst.GUID, "widget_quantum_max", "clientsetquantum_max")
	inst.widget_quantum_min = net_float(inst.GUID, "widget_quantum_min", "clientsetquantum_min")
	if not TheWorld.ismastersim then
		inst:ListenForEvent("clientsetquantum_min", function(inst)
			if not TheWorld.ismastersim and inst.quantumbadge ~= nil then
				if inst._clientquantum_min ~= inst.widget_quantum_min:value() then
					local oldperc = inst._clientquantum_min
				if oldperc == nil then 
					oldperc = 0 
				end	
				inst._clientquantum_min = inst.widget_quantum_min:value()	
				inst.quantumbadge:SetPercent(inst._clientquantum_min, inst._clientquantum_max)
				local up = (inst:HasTag("Dendrobium"))
				local anim = up and "arrow_loop_increase" or "neutral"
				if inst.arrowdir ~= anim then
					inst.arrowdir = anim
					inst.quantumarrow:GetAnimState():PlayAnimation(anim, true)
					end	
				end	
			end	
		end)
		inst:ListenForEvent("clientsetquantum_max", function(inst)
			if not TheWorld.ismastersim and inst.quantumbadge ~= nil then
				if inst._clientquantum_max ~= inst.widget_quantum_max:value() then
					inst._clientquantum_max = inst.widget_quantum_max:value()
				end	
			end	
		end)
	end

	-- Status badge: energy
	inst.widget_energy_max = net_float(inst.GUID, "widget_energy_max", "clientsetenergy_max")
	inst.widget_energy_min = net_float(inst.GUID, "widget_energy_min", "clientsetenergy_min")
	if not TheWorld.ismastersim then
		inst:ListenForEvent("clientsetenergy_min", function(inst)
			if not TheWorld.ismastersim and inst.energybadge ~= nil then
				if inst._clientenergy_min ~= inst.widget_energy_min:value() then
					local oldperc = inst._clientenergy_min
				if oldperc == nil then 
					oldperc = 0 
				end	
				inst._clientenergy_min = inst.widget_energy_min:value()	
				inst.energybadge:SetPercent(inst._clientenergy_min, inst._clientenergy_max)
				local up = (inst:HasTag("Dendrobium"))
				local anim = up and "arrow_loop_increase" or "neutral"
				if inst.arrowdir ~= anim then
					inst.arrowdir = anim
					inst.energyarrow:GetAnimState():PlayAnimation(anim, true)
					end	
				end	
			end	
		end)
		inst:ListenForEvent("clientsetenergy_max", function(inst)
			if not TheWorld.ismastersim and inst.energybadge ~= nil then
				if inst._clientenergy_max ~= inst.widget_energy_max:value() then
					inst._clientenergy_max = inst.widget_energy_max:value()
				end	
			end	
		end)
	end

	-- Status badge: magic
	inst.widget_magic_max = net_float(inst.GUID, "widget_magic_max", "clientsetmagic_max")
	inst.widget_magic_min = net_float(inst.GUID, "widget_magic_min", "clientsetmagic_min")
	if not TheWorld.ismastersim then
		inst:ListenForEvent("clientsetmagic_min", function(inst)
			if not TheWorld.ismastersim and inst.magicbadge ~= nil then
				if inst._clientmagic_min ~= inst.widget_magic_min:value() then
					local oldperc = inst._clientmagic_min
				if oldperc == nil then 
					oldperc = 0 
				end	
				inst._clientmagic_min = inst.widget_magic_min:value()	
				inst.magicbadge:SetPercent(inst._clientmagic_min, inst._clientmagic_max)
				local up = (inst:HasTag("Dendrobium"))
				local anim = up and "arrow_loop_increase" or "neutral"
				if inst.arrowdir ~= anim then
					inst.arrowdir = anim
					inst.magicarrow:GetAnimState():PlayAnimation(anim, true)
					end	
				end	
			end	
		end)
		inst:ListenForEvent("clientsetmagic_max", function(inst)
			if not TheWorld.ismastersim and inst.magicbadge ~= nil then
				if inst._clientmagic_max ~= inst.widget_magic_max:value() then
					inst._clientmagic_max = inst.widget_magic_max:value()
				end	
			end	
		end)
	end
	
	--- Status badge: shield
	inst.widget_shield_max = net_float(inst.GUID, "widget_shield_max", "clientsetshield_max")
	inst.widget_shield_min = net_float(inst.GUID, "widget_shield_min", "clientsetshield_min")
	if not TheWorld.ismastersim then
		inst:ListenForEvent("clientsetshield_min", function(inst)
			if not TheWorld.ismastersim and inst.shieldbadge ~= nil then
				if inst._clientshield_min ~= inst.widget_shield_min:value() then
					local oldperc = inst._clientshield_min
				if oldperc == nil then 
					oldperc = 0 
				end	
				inst._clientshield_min = inst.widget_shield_min:value()	
				inst.shieldbadge:SetPercent(inst._clientshield_min, inst._clientshield_max)
				local up = (inst:HasTag("Dendrobium"))
				local anim = up and "arrow_loop_increase" or "neutral"
				if inst.arrowdir ~= anim then
					inst.arrowdir = anim
					inst.shieldarrow:GetAnimState():PlayAnimation(anim, true)
					end	
				end	
			end	
		end)
		inst:ListenForEvent("clientsetshield_max", function(inst)
			if not TheWorld.ismastersim and inst.shieldbadge ~= nil then
				if inst._clientshield_max ~= inst.widget_shield_max:value() then
					inst._clientshield_max = inst.widget_shield_max:value()
				end	
			end	
		end)
	end

	-- Book Builder (Game)
	inst:AddTag("bookbuilder")

	-- Custom tags
	inst:AddTag("Dendrobium")
	inst:AddTag("soulleaper")
	inst:AddTag("firepowersource")
	inst:AddTag("mindpowersource")
	inst:AddTag("soulorbcollector")

	-- Buttons
	inst.bloomd_eventcd = net_float(inst.GUID, "inst.bloomd_eventcd")
	inst.healingd_eventcd = net_float(inst.GUID, "inst.healingd_eventcd")
	inst.shadowg_eventcd = net_float(inst.GUID, "inst.shadowg_eventcd")
	inst.shadoww_eventcd = net_float(inst.GUID, "inst.shadoww_eventcd")
	inst.sneaka_eventcd = net_float(inst.GUID, "inst.sneaka_eventcd")
	inst.treasuret_eventcd = net_float(inst.GUID, "inst.treasuret_eventcd")

	-- Character keyhandler
	inst:AddComponent("keyhandler")
	inst.components.keyhandler:Press(_G[TUNING.DENDROBIUM.KEY_1], "LevelInfo")
	inst.components.keyhandler:Press(_G[TUNING.DENDROBIUM.KEY_2], "SpellSwitcher")
	inst.components.keyhandler:Press(_G[TUNING.DENDROBIUM.KEY_3], "HitType")
	
end

-- This initializes for the server only. Components are added here.
local master_postinit = function(inst) 
	-- Set starting inventory
	inst.starting_inventory = start_inv[TheNet:GetServerGameMode()] or start_inv.default

	-- choose which sounds this character will play
	inst.soundsname = "willow" 
	inst.components.talker.fontsize = 28
	inst.components.talker.colour = Vector3(200/255, 175/255, 210/255, 1)
	
	-- Character size
	inst.Transform:SetScale(1, 1, 1)
	
	-- Temperature modification
	inst.components.temperature.inherentinsulation = 5
	inst.components.temperature.inherentsummerinsulation = 5
	
	-- Health modification
	local percent = inst.components.health:GetPercent()
	inst.components.health:SetMaxHealth(TUNING.DENDROBIUM_HEALTH)
    inst.components.health:SetPercent(percent)

	-- Hunger modification
    local hunger_percent = inst.components.hunger:GetPercent()
	inst.components.hunger:SetMax(TUNING.DENDROBIUM_HUNGER)
    inst.components.hunger:SetPercent(hunger_percent)
	inst.components.hunger:SetKillRate(1.25)
    inst.components.hunger:SetRate(TUNING.WILSON_HUNGER_RATE * TUNING.WARLY_HUNGER_RATE_MODIFIER)

	-- Sanity modification
	local sanity_percent = inst.components.sanity:GetPercent()
	inst.components.sanity:SetMax(TUNING.DENDROBIUM_SANITY)
    inst.components.sanity:SetPercent(sanity_percent)
	inst.components.sanity.custom_rate_fn = SanityRegenfn
	inst.components.sanity.rate_modifier = 1
	inst.components.sanity.night_drain_mult = 0

	-- Eater modification
	inst.components.eater.strongstomach = false 
	inst.components.eater.stale_hunger = TUNING.WICKERBOTTOM_STALE_FOOD_HUNGER
	inst.components.eater.stale_health = TUNING.WICKERBOTTOM_STALE_FOOD_HEALTH
	inst.components.eater.spoiled_hunger = TUNING.WICKERBOTTOM_SPOILED_FOOD_HUNGER
	inst.components.eater.spoiled_health = TUNING.WICKERBOTTOM_SPOILED_FOOD_HEALTH
	inst.components.eater:SetOnEatFn(function(inst, food)
		if food and food.components.edible and food.components.edible.foodtype == "MEAT" then
			if not food.prefab == "monstermeat" then
				--- Code
			end
		end 
	end)

	-- Can read book
	inst:AddComponent("reader")

	-- Pets
	if inst.components.petleash then
		inst.components.petleash:SetOnSpawnFn(OnSpawnPetFn)
		inst.components.petleash:SetOnDespawnFn(OnDespawnPetFn)
		inst.components.petleash:SetMaxPets(inst.components.petleash:GetMaxPets()+2)
	end

	-- Sanity aura
	inst:AddComponent("sanityaura")
	inst.components.sanityaura.aura = .2

	-- Combat damage modification
	inst.components.combat:SetDefaultDamage(20)
	inst.components.combat.damagemultiplier = 1.2

	-- Special
	inst:ListenForEvent("itemget", function (inst, data)
		if inst.components.inventory:Has("cursed_monkey_token", 1) then
			inst.components.cursable:RemoveCurse("MONKEY", 1)
		end
	end)

	-- Classified
	local untouchables = { babybeefalo = true }
	inst:DoTaskInTime(0, function()
		local old = inst.replica.combat.IsValidTarget
		inst.replica.combat.IsValidTarget = function(self, target)
			if target and untouchables[target.prefab] then
				return false
			end
			return old(self, target)
		end
	end)
	
	-- Classified
	local unequiable = { knive = true }
	inst:ListenForEvent("equip", function(inst, data)
		if unequiable[data.item.prefab] then 
			inst:DoTaskInTime(1, function(inst)
				inst.components.inventory:GiveItem(data.item)
			end)
			inst.components.talker:Say("I can't use that!", 2.5)
		end
	end)

	----------------------------------------------------------------------
	inst:ListenForEvent("Transform[UP]", function(inst)
		inst.components.locomotor.walkspeed = TUNING.WILSON_WALK_SPEED*1.5
		inst.components.locomotor.runspeed = TUNING.WILSON_RUN_SPEED*1.5
	end)
	
	inst:ListenForEvent("Transform[DOWN]", function(inst)
		inst.components.locomotor.walkspeed = TUNING.WILSON_WALK_SPEED*1.25
		inst.components.locomotor.runspeed = TUNING.WILSON_RUN_SPEED*1.25
	end)

	-- Custom
	inst:AddComponent("orchidacite")
	inst.components.orchidacite:LoadStatus(true)
	inst.components.orchidacite:SetMax("energy", 100)
	inst.components.orchidacite:SetPercent("energy", .2)
	inst.components.orchidacite:SetMax("shield", 10)
	inst.components.orchidacite:SetPercent("shield", 1)
	inst.components.orchidacite:SetMax("magic", 300)
	inst.components.orchidacite:SetPercent("magic", .5)
	inst.components.orchidacite:SetMax("treasure", 100)
	inst.components.orchidacite:SetPercent("treasure", 0)
	inst.components.orchidacite:SetMax("bloom", 100)
	inst.components.orchidacite:SetPercent("bloom", 0)
	inst.components.orchidacite:SetMax("quantum", 500)
	inst.components.orchidacite:SetPercent("quantum",  .7)

	-- Leveling
	inst:AddComponent("explevel")
	inst.components.explevel:SetStarter(0)
	
	-- Buttons
	inst:AddComponent("chronometer")
	inst:DoPeriodicTask(0, function(inst)
		inst.bloomd_eventcd:set(
			inst.components.chronometer ~= nil and 
			inst.components.chronometer:GetTimeLeft("bloomd_eventcd") or 0
		);
		inst.healingd_eventcd:set(
			inst.components.chronometer ~= nil and 
			inst.components.chronometer:GetTimeLeft("healingd_eventcd") or 0
		);
		inst.shadowg_eventcd:set(
			inst.components.chronometer ~= nil and 
			inst.components.chronometer:GetTimeLeft("shadowg_eventcd") or 0
		);
		inst.shadoww_eventcd:set(
			inst.components.chronometer ~= nil and 
			inst.components.chronometer:GetTimeLeft("shadoww_eventcd") or 0
		);
		inst.sneaka_eventcd:set(
			inst.components.chronometer ~= nil and 
			inst.components.chronometer:GetTimeLeft("sneaka_eventcd") or 0
		);
		inst.treasuret_eventcd:set(
			inst.components.chronometer ~= nil and 
			inst.components.chronometer:GetTimeLeft("treasuret_eventcd") or 0
		);
	end)
	
	-- Levelup
	inst:DoTaskInTime(1, ApplyExpLevel)
	inst:ListenForEvent("killed", OnKillOther)

	-- Incoming update
	inst:ListenForEvent("death", function(inst, data) end)
	inst:ListenForEvent("respawnfromghost", function(inst, data) end)
	inst:WatchWorldState("startday", function(inst) end)
	inst:WatchWorldState("startdusk", function(inst) end)
	inst:WatchWorldState("startnight", function(inst) end)

	-- Save/Load Data
	inst.OnLoad = OnLoadFn
    inst.OnNewSpawn = OnLoadFn
end

return MakePlayerCharacter("dendrobium", prefabs, assets, common_postinit, master_postinit, start_inv)