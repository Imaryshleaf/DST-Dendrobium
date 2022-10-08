local Brain = require "brains/dendrobium_shadow_brain"
local Stategraph = "SG_Dendrobiumshadow"

local assets = {
	-- Base skin
	Asset("ANIM", "character/skins/dendrobium_black.zip"),
	-- Others
    Asset("ANIM", "anim/player_basic.zip" ),  
	Asset("ANIM", "anim/swap_shovel.zip"),
	Asset("ANIM", "anim/swap_axe.zip"),
	Asset("ANIM", "anim/swap_pickaxe.zip"),
	Asset("ANIM", "anim/swap_nightmaresword.zip"),
	Asset("SOUND", "sound/maxwell.fsb"),
	Asset("SOUND", "sound/willow.fsb"),  
}

local prefabs = { }
local ATTACK_RANGE = 1
local HIT_RANGE = 2
local CRITICAL_HIT_CHANCE = 0.2
local SHADOW_DENDROBIUM_RUNSPEED = 8
local SHADOW_DENDROBIUM_WALKSPEED = 6
local NEAR_LEADER_DISTANCE = 10
local SHARE_TARGET_DIST = NEAR_LEADER_DISTANCE
local RETARGET_MUST_TAGS = { "_combat" }
local RETARGET_CANT_TAGS = { "INLIMBO", "companion", "notaunt", "playerghost" }
local RETARGET_ONEOF_TAGS = { "locomotor", "epic" }

local items = {
	AXE = "swap_axe",
	PICKAXE = "swap_pickaxe",
	SHOVEL = "swap_shovel",
    SWORD = "swap_nightmaresword"
}

local function EquipItem(inst, item)
	if item then
	    inst.AnimState:OverrideSymbol("swap_object", item, item)
	    inst.AnimState:Show("ARM_carry") 
	    inst.AnimState:Hide("ARM_normal")
	end
end

local function ValidTarget(target)
	return target ~= nil 
		and not (target:HasTag("veggie") 
			or target:HasTag("structure") 
			or target:HasTag("wall") 
			or target:HasTag("balloon") 
			or target:HasTag("groundspike") 
			or target:HasTag("smashable")) 
		and target.components.combat ~= nil 
		and target.components.health ~= nil 
end

local function RetargetFn(inst)
    local leader = inst.components.follower:GetLeader()
    return leader ~= nil and FindEntity(leader, NEAR_LEADER_DISTANCE,
		function(guy)
			return guy ~= inst
				and ValidTarget(guy)
				and (guy.components.combat:TargetIs(leader) 
				  or guy.components.combat:TargetIs(inst)
				  or guy:HasTag("shadowcreature"))
				and inst.components.combat:CanTarget(guy)
            end,
		RETARGET_MUST_TAGS,
		RETARGET_CANT_TAGS
	)
end

local function KeepTargetFn(inst, target)
   return target ~= nil
        and target.components.combat ~= nil
        and target.components.health ~= nil
		and target.components.minigame_participator == nil
        and inst.components.follower:IsNearLeader(NEAR_LEADER_DISTANCE)
        and inst.components.combat:CanTarget(target)
		and ValidTarget(target)
end

local function OnAttacked(inst, data)
	local target = data.attacker
	if target ~= nil then
		if target.components.petleash ~= nil and target.components.petleash:IsPet(inst) and target:HasTag("Dendrobium") then
			target.components.petleash:DespawnPet(inst)
        elseif target.components.combat ~= nil then
			inst.components.combat:SetTarget(target)
			-- inst.components.combat:ShareTarget(target, SHARE_TARGET_DIST,
				-- function(dude)
					-- return not (dude.components.health ~= nil and dude.components.health:IsDead())
						-- and (dude:HasTag("dendrobiumshadows") or dude:HasTag("friendlyshadows"))
						-- and target ~= (dude.components.follower ~= nil and dude.components.follower.leader or nil)
				-- end, 5)
        end
    end
end

local function OnHit(inst, data)
	local other =  data.target
	local fx = SpawnPrefab("statue_transition_2")
	if ValidTarget(other) then
		fx.Transform:SetPosition(other:GetPosition():Get())
	end
end

local function LeaderProxOnClose(inst)
	if inst.components.follower:IsNearLeader(NEAR_LEADER_DISTANCE) then
    inst.components.locomotor.runspeed = SHADOW_DENDROBIUM_RUNSPEED
    inst.components.locomotor.walkspeed = SHADOW_DENDROBIUM_WALKSPEED
	end 
end

local function LeaderProxOnFar(inst)
	if inst.components.follower:IsNearLeader(NEAR_LEADER_DISTANCE) then
    inst.components.locomotor.runspeed = SHADOW_DENDROBIUM_RUNSPEED*2
    inst.components.locomotor.walkspeed = SHADOW_DENDROBIUM_WALKSPEED*2
		inst.components.combat:GiveUp()
	end 
end

local function NoDebrisDmg(inst, amount, overtime, cause, ignore_invincible, afflicter, ignore_absorb)
    return afflicter ~= nil and afflicter:HasTag("quakedebris")
end

local function EntityDeathFn(inst, data)
    if data.inst:HasTag("Dendrobium") then
        inst:DoTaskInTime(math.random(), function() 
			if not inst.components.health:IsDead() then
				inst.components.health:Kill()
			end
		end)
    end
end

local function OnDeath(inst)
	if inst.components.container then
		inst.components.container:DropEverything(true) 
	end
end 

local function OnKilled(inst, data)
	local victim = data.victim
end

local function makeshadowfn()
local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddDynamicShadow()
    inst.entity:AddNetwork()
	inst.entity:AddMiniMapEntity()

	MakeGhostPhysics(inst, 1, .5)

	inst.Transform:SetScale(.8, .8, .8)
	inst.Transform:SetFourFaced(inst)

	inst.MiniMapEntity:SetIcon("dendrobium.tex")
	inst.MiniMapEntity:SetCanUseCache(false)

	inst.AnimState:SetBank("wilson")
	inst.AnimState:SetBuild("dendrobium_black")
	inst.AnimState:PlayAnimation("idle")
    
	inst.AnimState:Hide("ARM_carry")
    inst.AnimState:Hide("hat")
    inst.AnimState:Hide("hat_hair")

	-- Game Tags
    inst:AddTag("shadowminion")
	inst:AddTag("companion")
    inst:AddTag("noauradamage")
	inst:AddTag("NOBLOCK")
	
	-- Custom
	inst:AddTag("friendlyshadows")
	inst:AddTag("dendrobiumshadows")

    inst:AddTag("flying")
	if inst.DLC2_fly then
		MakeAmphibiousCharacterPhysics(inst, 2, .5)
	end

	inst.entity:SetPristine()
   	if not TheWorld.ismastersim then
		return inst
	end
	
	inst:AddComponent("colourtweener")
	inst.components.colourtweener:StartTween({1,1,1,.7}, 0)

	inst:AddComponent("talker")
	inst.components.talker.fontsize = 20
	inst.components.talker.colour = Vector3(0.7, 0.75, 0.95, 1)

	inst:AddComponent("follower")
	inst.components.follower:KeepLeaderOnAttacked()
	
	-- Walk
	inst:AddComponent("locomotor")
	inst.components.locomotor:SetTriggersCreep(false)
	inst.components.locomotor.pathcaps = { ignorecreep = true }
    inst.components.locomotor.runspeed = SHADOW_DENDROBIUM_RUNSPEED
    inst.components.locomotor.walkspeed = SHADOW_DENDROBIUM_WALKSPEED

	-- Combat
    inst:AddComponent("combat")
    inst.components.combat:SetRange(ATTACK_RANGE, HIT_RANGE)
    inst.components.combat.playerdamagepercent = 0
    inst.components.combat.hiteffectsymbol = "torso"
    inst.components.combat:SetAttackPeriod(1)
    inst.components.combat:SetDefaultDamage(20)
    inst.components.combat:SetRetargetFunction(1, RetargetFn) -- Look for leader's target.
    inst.components.combat:SetKeepTargetFunction(KeepTargetFn) -- Keep attacking while leader is near.
	
	-- Health
    inst:AddComponent("health")
	inst.components.health.nofadeout = true
	inst.components.health:StartRegen(20, 5)
    inst.components.health:SetMaxHealth(400)
	inst.components.health:SetAbsorptionAmount(.1)
	inst.components.health.redirect = NoDebrisDmg

	-- Speed and combat
    inst:AddComponent("playerprox")
    inst.components.playerprox:SetDist(NEAR_LEADER_DISTANCE, NEAR_LEADER_DISTANCE)
    inst.components.playerprox:SetOnPlayerNear(LeaderProxOnClose)
    inst.components.playerprox:SetOnPlayerFar(LeaderProxOnFar)
	
	-- Check SG
    inst.items = items
    inst.equipfn = EquipItem
	EquipItem(inst)
	
	-- Events
	inst:ListenForEvent("death", OnDeath)
	inst:ListenForEvent("killed", OnKilled)	
	inst:ListenForEvent("onhitother", OnHit)
	inst:ListenForEvent("attacked", OnAttacked)
    inst:ListenForEvent("entity_death", function(world, data) EntityDeathFn(inst, data) end, TheWorld)

	inst:SetBrain(Brain)
	inst:SetStateGraph(Stategraph)
	return inst
end

return Prefab("dendrobium_shadow_duelist", makeshadowfn, assets, prefabs),
		Prefab("dendrobium_shadow_lumber", makeshadowfn, assets, prefabs),
		Prefab("dendrobium_shadow_miner", makeshadowfn, assets, prefabs),
		Prefab("dendrobium_shadow_digger", makeshadowfn, assets, prefabs)