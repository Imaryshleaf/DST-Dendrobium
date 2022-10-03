-- Forest Stalker
local MAX_TRAIL_VARIATIONS = 5
local MAX_RECENT_TRAILS = 3
local TRAIL_MIN_SCALE = 1
local TRAIL_MAX_SCALE = 1.5
local function PickTrail(inst)
    local rand = table.remove(inst.availabletrails, math.random(#inst.availabletrails))
    table.insert(inst.usedtrails, rand)
    if #inst.usedtrails > MAX_RECENT_TRAILS then
        table.insert(inst.availabletrails, table.remove(inst.usedtrails, 1))
    end
    return rand
end
local function RefreshTrail(inst, fx)
    if fx:IsValid() then
        fx:Refresh()
    else
        inst._trailtask:Cancel()
        inst._trailtask = nil
    end
end
local function DoTrail(inst)
    local x, y, z = inst.Transform:GetWorldPosition()
	if inst.sg:HasStateTag("moving") then
        local theta = -inst.Transform:GetRotation() * DEGREES
        x = x + math.cos(theta)
        z = z + math.sin(theta)
    end
    local fx = SpawnPrefab("damp_trail")
    fx.Transform:SetPosition(x, 0, z)
    fx:SetVariation(PickTrail(inst), GetRandomMinMax(TRAIL_MIN_SCALE, TRAIL_MAX_SCALE), TUNING.STALKER_BLOOM_DECAY)
    if inst._trailtask ~= nil then
        inst._trailtask:Cancel()
    end
	inst._trailtask = inst:DoPeriodicTask(TUNING.STALKER_BLOOM_DECAY * .5, RefreshTrail, nil, fx)
end
local BLOOM_CHOICES = {
    ["stalker_bulb"] = .3,
    ["stalker_bulb_double"] = .25,
    ["stalker_berry"] = 1,
	["stalker_fern"] = 3,
	-- ["sch_spore"] = .2,
	-- ["sch_spore_blue"] = .2,
	-- ["sch_spore_red"] = .1,
}
local function DoPlantBloom(inst)
    local x, y, z = inst.Transform:GetWorldPosition()
    local map = TheWorld.Map
    local offset = FindValidPositionByFan(
        math.random() * 1 * PI,
        math.random() * 2,
        4,
        function(offset)
            local x1 = x + offset.x
            local z1 = z + offset.z
            return map:IsPassableAtPoint(x1, 0, z1)
                and map:IsDeployPointClear(Vector3(x1, 0, z1), nil, 1)
                and #TheSim:FindEntities(x1, 0, z1, 2.5, { "stalkerbloom" }) < 4
        end
    )
    if offset ~= nil then
        SpawnPrefab(weighted_random_choice(BLOOM_CHOICES)).Transform:SetPosition(x + offset.x, 0, z + offset.z)
    end
end
local function OnStartBlooming(inst)
    DoTrail(inst)
   -- inst._bloomtask = inst:DoPeriodicTask(3 * FRAMES, DoPlantBloom, 2 * FRAMES)
	inst._bloomtask = inst:DoPeriodicTask(9 * FRAMES, DoPlantBloom, 6 * FRAMES)
end
local function _StartBlooming(inst)
    if inst._bloomtask == nil then
        inst._bloomtask = inst:DoTaskInTime(0, OnStartBlooming)
    end
end
local function ForestOnEntityWake(inst)
    if inst._blooming then
		if not (inst.sg:HasStateTag("rowing") or inst.sg:HasStateTag("sailing") or inst.sg:HasStateTag("sail") or inst.sg:HasStateTag("row") or inst.sg:HasStateTag("boating") or inst:HasTag("aquatic")) then
        _StartBlooming(inst)
		end
    end
end
local function ForestOnEntitySleep(inst)
    if inst._bloomtask ~= nil then
        inst._bloomtask:Cancel()
        inst._bloomtask = nil
    end
    if inst._trailtask ~= nil then
        inst._trailtask:Cancel()
        inst._trailtask = nil
    end
end

local function StartBlooming(inst)
    if not inst._blooming then
        inst._blooming = true
        if not inst:IsAsleep() then
            _StartBlooming(inst)
        end
    end
end
local function StopBlooming(inst)
    if inst._blooming then
        inst._blooming = false
        ForestOnEntitySleep(inst)
    end
end

-- Check
local function BloomsModeFn(inst, data)
	if inst.IsBlossomMode then
		inst.components.orchidacite:DoDelta("bloom", -1)
	elseif not inst.IsBlossomMode then
		inst.components.orchidacite:DoDelta("bloom", 0)
	end
end
local function BloomDeltaFn(inst, data)
	if inst.CanStartBloom then
		inst.IsBlossomMode = true
		StartBlooming(inst)
	elseif not inst.CanStartBloom then
		inst.IsBlossomMode = false
		StopBlooming(inst)
	end
end
local function BloomCheckFn(inst, data)
	if inst.components.orchidacite:IsDepleted("bloom") then
		inst.CanStartBloom = false
	end
    -- Regen
	if not inst.sg:HasStateTag("attack") and not inst:HasTag("playerghost") then 
		inst.BloomRegen = true
	else
		inst.BloomRegen = false
	end
end
----------------------------------- End Bloom Regen -----------------------------------
---------------------------------------------------------------------------------------
-- Revied
local function ResumeTask(inst, data)
	if not inst.components.health:IsDead() or inst.sg:HasStateTag("nomorph") or inst:HasTag("playerghost") then
		-- Bloom
        inst.BloomCheckTask = inst:DoPeriodicTask(0, BloomCheckFn)
        inst.BloomModeTask = inst:DoPeriodicTask(1, BloomsModeFn)
	end
end

-- Death
local function CancelAllTask(inst, data)
	-- Bloom
	if inst.BloomCheckTask ~= nil then 
		inst.BloomCheckTask:Cancel() 
		inst.BloomCheckTask = nil 
	end
	if inst.BloomModeTask ~= nil then 
		inst.BloomModeTask:Cancel() 
		inst.BloomModeTask = nil 
	end
end

-- "common_postinit" or "master_postinit"
AddPrefabPostInit("dendrobium", function(inst)
    if inst:HasTag("Dendrobium") then
        if not inst.components.health:IsDead() then
			-- Bloom
            inst.usedtrails = {}
            inst.availabletrails = {}
            for i = 1, MAX_TRAIL_VARIATIONS do
                table.insert(inst.availabletrails, i)
            end
            inst._blooming = false
            inst.DoTrail = DoTrail
            inst.StartBlooming = StartBlooming
            inst.StopBlooming = StopBlooming
            inst.OnEntityWake = ForestOnEntityWake
            inst.OnEntitySleep = ForestOnEntitySleep
            inst:ListenForEvent("bloom_delta", BloomDeltaFn)
            inst.BloomCheckTask = inst:DoPeriodicTask(0, BloomCheckFn)
            inst.BloomModeTask = inst:DoPeriodicTask(1, BloomsModeFn)
		end
    end
	inst:ListenForEvent("respawnfromghost", ResumeTask)
	inst:ListenForEvent("death", CancelAllTask)
end)