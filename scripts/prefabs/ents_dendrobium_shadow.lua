local Brain = require "brains/BrainOShadowDendrobium"
local Stategraph = "SGdendrobiumShadow"

local assets = {
	-- Basic
	Asset("ANIM", "character/skins/dendrobium_black.zip"),
	Asset("ANIM", "anim/shadow/shadowminion_appear.zip"),
	Asset("ANIM", "anim/shadow/shadowminion_lunge.zip"),
	-- Others
    Asset("ANIM", "anim/player_basic.zip" ),  
	Asset("ANIM", "anim/swap_shovel.zip"),
	Asset("ANIM", "anim/swap_axe.zip"),
	Asset("ANIM", "anim/swap_pickaxe.zip"),
	Asset("ANIM", "anim/swap_nightmaresword.zip"),
	Asset("SOUND", "sound/maxwell.fsb"),
	Asset("SOUND", "sound/willow.fsb"), 
	-- Actions
	Asset("ANIM", "anim/actions/action_leap.zip"),
	Asset("ANIM", "anim/actions/action_jump.zip"),
}

local prefabs = { }
local ATTACK_RANGE = 2
local HIT_RANGE = 2
local SHADOW_DENDROBIUM_RUNSPEED = 12
local SHADOW_DENDROBIUM_WALKSPEED = 10
local NEAR_LEADER_DISTANCE = 13
local SHADOWGUARDIAN_DENDROBIUM_DURATION = 120 -- (seg * 4)
local SHADOWWORKER_DENDROBIUM_DURATION = 180 -- (seg * 6)
local SHADOWIDLE_DESPAWN_TIME = 10

local RETARGET_MUST_TAGS = { "_combat" }
local RETARGET_CANT_TAGS = { "INLIMBO", "companion", "playerghost" }
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

local function IsTargetable(inst, target)
    local leader = inst.components.follower:GetLeader()
	return leader ~= nil and FindEntity(leader, NEAR_LEADER_DISTANCE)
		and target.components.combat ~= nil
		and inst.components.combat:CanTarget(target)
		and (target.components.combat:CanTarget(leader) or target.components.combat:CanTarget(inst))
		and (target.components.combat:TargetIs(leader) or target.components.combat:TargetIs(inst))
		and (target:HasTag("shadowcreature") or (target.components.combat:HasTarget() and target.components.combat.target:HasTag("player")))
		and not (target.components.health ~= nil and target.components.health:IsDead())
end

local function RetargetFn(inst)
    if inst.components.combat:HasTarget() then
        return
    end
    local x, y, z = inst.Transform:GetWorldPosition()
    for i, v in ipairs(TheSim:FindEntities(x, y, z, NEAR_LEADER_DISTANCE, RETARGET_MUST_TAGS, RETARGET_CANT_TAGS, RETARGET_ONEOF_TAGS)) do
        if IsTargetable(inst, v) and ValidTarget(v) then
            return v
        end
    end
end

local function KeepTargetFn(inst, target)
	return target.components.minigame_participator == nil
        and inst.components.follower:IsNearLeader(NEAR_LEADER_DISTANCE)
        and inst.components.combat:CanTarget(target)
end

local function OnAttacked(inst, data)
	local target = data.attacker
	if target ~= nil then
		if target.components.petleash ~= nil and target.components.petleash:IsPet(inst) and target:HasTag("Dendrobium") then
			target.components.petleash:DespawnPet(inst)
        elseif target.components.combat ~= nil and not target:HasTag("player") then
			-- Duelist
			if inst:HasTag("dendrobiumshadowduelist") then
				inst.components.combat:SetTarget(target)
				inst.components.combat:ShareTarget(data.attacker, NEAR_LEADER_DISTANCE, function(dude)
					local should_share = dude:HasTag("dendrobiumshadowduelist")
						and not dude.components.health:IsDead()
						and dude.components.follower ~= nil
						and dude.components.follower.leader == inst.components.follower.leader
					return should_share
				end, 2)
			end
        end
    end
end

local function OnHit(inst, data)
	local other =  data.target
	local fxcd = SpawnPrefab("fx_spin_electric")
	if ValidTarget(other) then
		if other.components.combat:InCooldown() then
			inst.components.talker:Say("[ -- Attack -- ]", 3)
			inst.components.combat:SetAttackPeriod(0)
		elseif not (other.components.combat:InCooldown()
				or other.components.combat.laststartattacktime == 0
				or other.sg ~= nil and other.sg:HasStateTag("attack")) then
			inst.components.combat:SetAttackPeriod(math.random(1, 2))
			inst.components.talker:Say("[ -- Evade -- ]")
			fxcd.Transform:SetPosition(other:GetPosition():Get())
		end
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
		inst.components.locomotor.runspeed = SHADOW_DENDROBIUM_RUNSPEED
		inst.components.locomotor.walkspeed = SHADOW_DENDROBIUM_WALKSPEED
		if inst.components.combat ~= nil and inst.components.combat:HasTarget() then
			inst.components.combat:GiveUp()
		end
	end 
end

local function NoDebrisDmg(inst, amount, overtime, cause, ignore_invincible, afflicter, ignore_absorb)
    return afflicter ~= nil and afflicter:HasTag("quakedebris")
end

local function EntityDeathFn(inst, data)
    if data.inst:HasTag("Dendrobium") then
		if not inst.components.health:IsDead() then
			inst.components.health:Kill()
		end
    end
end

local function OnKilled(inst, data)
	local victim = data.victim
end
----------------------------------------------------------------------------------
-- Shadows lifetime
local function OnSeekOblivion(inst)
	inst.components.chronometer:StopTimer("obliviate")
	if not inst.components.health:IsDead() then
		inst.sg:GoToState("despawnjumpin")
	end
end

local function OnTimerDone(inst, data)
    if data and data.name == "obliviate" then
        OnSeekOblivion(inst)
    end
end

local function MakeOblivionSeeker(inst, duration)
    inst:ListenForEvent("chronometerdone", OnTimerDone)
    inst.components.chronometer:StartTimer("obliviate", duration)
end

local function MakeShadowWorker()
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
	inst.components.combat:SetRange(2)
	inst.components.combat.hiteffectsymbol = "torso"
	inst.components.combat:SetKeepTargetFunction(function(inst)
		return false
	end)

	-- Health
    inst:AddComponent("health")
	inst.components.health.nofadeout = true
    inst.components.health:SetMaxHealth(100)
	inst.components.health:SetAbsorptionAmount(.1)
	inst.components.health.redirect = NoDebrisDmg

	-- Speed
    inst:AddComponent("playerprox")
    inst.components.playerprox:SetDist(NEAR_LEADER_DISTANCE, NEAR_LEADER_DISTANCE)
    inst.components.playerprox:SetOnPlayerNear(LeaderProxOnClose)
    inst.components.playerprox:SetOnPlayerFar(LeaderProxOnFar)
	
	-- SG Items
    inst.items = items
    inst.equipfn = EquipItem
	EquipItem(inst)

	-- Custom
	inst:AddComponent("chronometer")
	MakeOblivionSeeker(inst, SHADOWWORKER_DENDROBIUM_DURATION + math.random())

	-- Events
	inst:ListenForEvent("attacked", OnAttacked)
    inst:ListenForEvent("entity_death", function(world, data) EntityDeathFn(inst, data) end, TheWorld)

	inst:SetBrain(Brain)
	inst:SetStateGraph(Stategraph)
	return inst
end

local function MakeShadowDuelist()
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
	
    inst.AnimState:AddOverrideBuild("waxwell_minion_appear")
	inst.AnimState:AddOverrideBuild("lavaarena_shadow_lunge")

	inst.AnimState:Hide("ARM_carry")
    inst.AnimState:Hide("hat")
    inst.AnimState:Hide("hat_hair")

	-- Game Tags
    inst:AddTag("shadowminion")
	inst:AddTag("companion")
    inst:AddTag("noauradamage")
	inst:AddTag("NOBLOCK")
	
	-- Allow attack shadow creature
	inst:AddTag("crazy")
	
	-- Custom
	inst:AddTag("friendlyshadows")
	inst:AddTag("dendrobiumshadows")
	inst:AddTag("dendrobiumshadowduelist")

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
    inst.components.combat:SetDefaultDamage(40)
    inst.components.combat.playerdamagepercent = 0
    inst.components.combat.hiteffectsymbol = "torso"
    inst.components.combat:SetRange(ATTACK_RANGE, HIT_RANGE)
    inst.components.combat:SetRetargetFunction(1, RetargetFn) -- Look for leader's target.
    inst.components.combat:SetKeepTargetFunction(KeepTargetFn) -- Keep attacking while leader is near.
	
	-- Health
    inst:AddComponent("health")
	inst.components.health.nofadeout = true
	inst.components.health:StartRegen(20, 5)
    inst.components.health:SetMaxHealth(200)
	inst.components.health:SetAbsorptionAmount(.7)
	inst.components.health.redirect = NoDebrisDmg

	-- Speed
    inst:AddComponent("playerprox")
    inst.components.playerprox:SetDist(NEAR_LEADER_DISTANCE, NEAR_LEADER_DISTANCE)
    inst.components.playerprox:SetOnPlayerNear(LeaderProxOnClose)
    inst.components.playerprox:SetOnPlayerFar(LeaderProxOnFar)
	
	-- SG Items
    inst.items = items
    inst.equipfn = EquipItem
	EquipItem(inst)
	
	-- Custom
	inst:AddComponent("chronometer")
	MakeOblivionSeeker(inst, SHADOWGUARDIAN_DENDROBIUM_DURATION + math.random())

	-- Events
	inst:ListenForEvent("killed", OnKilled)	
	inst:ListenForEvent("onhitother", OnHit)
	inst:ListenForEvent("attacked", OnAttacked)
    inst:ListenForEvent("entity_death", function(world, data) EntityDeathFn(inst, data) end, TheWorld)

	inst:SetBrain(Brain)
	inst:SetStateGraph(Stategraph)
	return inst
end

return Prefab("dendrobium_shadow_duelist", MakeShadowDuelist, assets, prefabs),
	Prefab("dendrobium_shadow_lumber", MakeShadowWorker, assets, prefabs),
	Prefab("dendrobium_shadow_miner", MakeShadowWorker, assets, prefabs),
	Prefab("dendrobium_shadow_digger", MakeShadowWorker, assets, prefabs)