--[[ Used as
# Transform to 2nd form
# Bloom animation

]] 
local TransformFN = GLOBAL.State {
	name = "TransformSG",
	tags = { "busy", "pausepredict", "nomorph", "nodangle" },
	onenter = function(inst)
		inst.components.locomotor:Stop()
		if not inst.components.health:IsDead() then
			inst.AnimState:OverrideSymbol("shadow_hands", "shadow_skinchangefx", "shadow_hands")
			inst.AnimState:OverrideSymbol("shadow_ball", "shadow_skinchangefx", "shadow_ball")
			inst.AnimState:OverrideSymbol("splode", "shadow_skinchangefx", "splode")
			inst.AnimState:PlayAnimation("pickup", false)
			inst.AnimState:PushAnimation("skin_change", false)
			inst.components.inventory:ReturnActiveActionItem(inst.bufferedaction ~= nil and inst.bufferedaction.invobject or nil)
		end
	end,
	timeline = {
		TimeEvent(16 * FRAMES, function(inst)
			inst.SoundEmitter:PlaySound("dontstarve/common/together/skin_change")
		end),
		TimeEvent(60 * FRAMES, function(inst)
			inst:PerformBufferedAction()
		end),
	},
	events = {
		EventHandler("animover", function(inst)
			if inst.AnimState:AnimDone() then
				inst.sg:GoToState("idle")
			end
		end),
	},
	onexit = function(inst)
		if inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS) then
			inst.AnimState:Show("ARM_carry")
			inst.AnimState:Hide("ARM_normal")
		end
	end,
}
AddStategraphState("wilson", TransformFN)
AddStategraphState("wilson_client", TransformFN)

--[[ Used as
# Animation to spawn shadow (worker - guardian/duelist)

]] 
local BookFN = GLOBAL.State {
	name = "BookSG",
	tags = { "doing", "busy" },
	onenter = function(inst)
		inst.components.locomotor:Stop()
		inst.AnimState:PlayAnimation("action_uniqueitem_pre")
		inst.AnimState:PushAnimation("book", false)
		inst.components.inventory:ReturnActiveActionItem(inst.bufferedaction ~= nil and (inst.bufferedaction.target or inst.bufferedaction.invobject) or nil)
	end,
	timeline = {
		TimeEvent(0, function(inst)
		local fxtoplay = inst.components.rider ~= nil and inst.components.rider:IsRiding() and "book_fx_mount" or "book_fx"
		local fx = SpawnPrefab(fxtoplay)
				fx.entity:SetParent(inst.entity)
				fx.Transform:SetPosition(0, 0.2, 0)
				inst.sg.statemem.book_fx = fx	
		end),
		TimeEvent(28 * FRAMES, function(inst)
			local fx1 = SpawnPrefab("fx_dark_shield")
				fx1.Transform:SetScale(0.30, 0.30, 0.30)
				fx1.Transform:SetPosition(inst:GetPosition():Get())
				inst.SoundEmitter:PlaySound("dontstarve/common/use_book_light")
		end),
		TimeEvent(54 * FRAMES, function(inst)
				inst.SoundEmitter:PlaySound("dontstarve/common/use_book_close")
		end),
		TimeEvent(58 * FRAMES, function(inst)
				inst.SoundEmitter:PlaySound("dontstarve/common/book_spell")
				inst:PerformBufferedAction()
				inst.sg.statemem.book_fx = nil
			if inst.castype == "dendrobium_shadow_duelist" then
				inst.castype = nil
				local theta = math.random(10, 360)*DEGREES
				local x,y,z = inst.Transform:GetWorldPosition()
				local offset = FindWalkableOffset(inst:GetPosition(), theta, 4, 30, false, false)
				inst.components.petleash:SpawnPetAt(x + offset.x, y + offset.y, z + offset.z, "dendrobium_shadow_duelist")
			elseif inst.castype == "dendrobium_shadow_worker" then
				inst.castype = nil
				local theta = math.random(10, 360)*DEGREES
				local x,y,z = inst.Transform:GetWorldPosition()
				local offset = FindWalkableOffset(inst:GetPosition(), theta, 4, 30, false, false)		
				if not inst.components.leader:IsBeingFollowedBy("dendrobium_shadow_lumber") then
					inst.components.petleash:SpawnPetAt(x + offset.x, y + offset.y, z + offset.z, "dendrobium_shadow_lumber")
				elseif not inst.components.leader:IsBeingFollowedBy("dendrobium_shadow_digger") then
					inst.components.petleash:SpawnPetAt(x + offset.x, y + offset.y, z + offset.z, "dendrobium_shadow_digger")
				elseif not inst.components.leader:IsBeingFollowedBy("dendrobium_shadow_miner") then
					inst.components.petleash:SpawnPetAt(x + offset.x, y + offset.y, z + offset.z, "dendrobium_shadow_miner")
				end
			end
		end),
		TimeEvent(65 * FRAMES, function(inst)
			inst.sg:RemoveStateTag("busy")
		end),
	},
	events = {
		EventHandler("animover", function(inst)
			if inst.AnimState:AnimDone() then
				if inst.AnimState:AnimDone() then
                    if inst.AnimState:IsCurrentAnimation("book") then
                        inst.sg:GoToState("idle")
                    end
				end
			end
		end),
	},
	ontimeout = function(inst)
		inst.sg:RemoveStateTag("doing")
		inst:ClearBufferedAction()
	end,
	onexit = function(inst)
		if inst.sg.statemem.book_fx then
			inst.sg.statemem.book_fx:Remove()
			inst.sg.statemem.book_fx = nil
		end
		if inst.bufferedaction == inst.sg.statemem.action then
			inst:ClearBufferedAction()
		end
		inst.sg.statemem.action = nil
	end,
}
AddStategraphState("wilson", BookFN)
AddStategraphState("wilson_client", BookFN)

--[[ Used as
# Convert soul to magic

]] 
local alterSoulFn = GLOBAL.State {
	name = "alterSoulSG",
	tags = { "doing", "busy" },
	onenter = function(inst)
		if not inst.components.health:IsDead() then
			if not inst.sg:HasStateTag("sleeping") then
				if inst.components.inventory:Has("soul_orb", 1)then
					if inst.components.orchidacite and inst.components.orchidacite.min_magic >= 300 then
						inst.sg:GoToState("mindcontrolled")
						inst.components.talker:Say("Too many magic power...", 2.5)
					end
				end
				if inst.components.inventory:Has("soul_orb", 1)then
					if inst.components.orchidacite and inst.components.orchidacite.min_magic < 300 then
						inst.components.orchidacite:DoDelta("magic", 10)
						inst.components.inventory:ConsumeByName("soul_orb", 1)
						SpawnPrefab("statue_transition_2").Transform:SetPosition(inst:GetPosition():Get())
						SpawnPrefab("fx_elec_charged").Transform:SetPosition(inst:GetPosition():Get())
						inst.components.locomotor:Stop()
						inst.AnimState:PlayAnimation("pickup")
						inst.AnimState:PushAnimation("pickup_pst", false)
					end
				end
				if not inst.components.inventory:Has("soul_orb", 1)then
					if inst.components.orchidacite and inst.components.orchidacite.min_magic <= 300 then
						inst.components.locomotor:Stop()
						inst.AnimState:PlayAnimation("pickup")
						inst.AnimState:PushAnimation("pickup_pst", false)
					end
				end
				if not inst.components.inventory:Has("soul_orb", 1)then
					if inst.components.orchidacite and inst.components.orchidacite.min_magic >= 300 then
						inst.components.locomotor:Stop()
						inst.AnimState:PlayAnimation("pickup")
						inst.AnimState:PushAnimation("pickup_pst", false)
					end
				end
			end
			inst.sg.statemem.action = inst.bufferedaction
			inst.sg:SetTimeout(10 * FRAMES)
		end
	end,
	timeline = {
		TimeEvent(4 * FRAMES, function(inst)
			inst.sg:RemoveStateTag("busy")
		end),
		TimeEvent(6 * FRAMES, function(inst)
			inst:PerformBufferedAction()
		end),
	},
	ontimeout = function(inst)
		inst.sg:GoToState("idle", true)
	end,
	onexit = function(inst)
		if inst.bufferedaction == inst.sg.statemem.action and
		(inst.components.playercontroller == nil or inst.components.playercontroller.lastheldaction ~= inst.bufferedaction) then
			inst:ClearBufferedAction()
		end
	end,
}
AddStategraphState("wilson", alterSoulFn)
AddStategraphState("wilson_client", alterSoulFn)

-----------------------------------------------------------------------------------------------------------------------------------------------------
local function SetSleeperSleepState(inst)
    if inst.components.grue ~= nil then inst.components.grue:AddImmunity("sleeping") end
    if inst.components.talker ~= nil then inst.components.talker:IgnoreAll("sleeping") end
    if inst.components.firebug ~= nil then inst.components.firebug:Disable() end
    if inst.components.playercontroller ~= nil then inst.components.playercontroller:EnableMapControls(false) inst.components.playercontroller:Enable(false) end
    inst:OnSleepIn();  inst.components.inventory:Hide(); inst:PushEvent("ms_closepopups"); inst:ShowActions(false);
end
local function SetSleeperAwakeState(inst)
    if inst.components.grue ~= nil then inst.components.grue:RemoveImmunity("sleeping") end
    if inst.components.talker ~= nil then inst.components.talker:StopIgnoringAll("sleeping") end
    if inst.components.firebug ~= nil then inst.components.firebug:Enable() end
    if inst.components.playercontroller ~= nil then inst.components.playercontroller:EnableMapControls(true) inst.components.playercontroller:Enable(true) end
    inst:OnWakeUp();  inst.components.inventory:Show(); inst:ShowActions(true);
end
local function RestTick(inst)
	local is_resting = true
    local isstarving = false
    local HUNGER_REST_PER_TICK = 0
    local SANITY_REST_PER_TICK = 1
    local HEALTH_REST_PER_TICK = 1
	local SLEEP_TEMP_PER_TICK = 1
	local SLEEP_TARGET_TEMP = 40
    if inst.components.hunger ~= nil then
        inst.components.hunger:DoDelta(HUNGER_REST_PER_TICK, true, true)
        isstarving = inst.components.hunger:IsStarving()
    end
    if inst.components.sanity ~= nil and inst.components.sanity:GetPercentWithPenalty() < 1 then
        inst.components.sanity:DoDelta(SANITY_REST_PER_TICK, true)
    end
    if not isstarving and inst.components.health ~= nil then
        inst.components.health:DoDelta(HEALTH_REST_PER_TICK, true, is_resting, true)
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

--[[ Used as
# Animation to sleep/rest
# Animation to wake

-- Rest / SleepSG modification (Let put this at very bottom)
]] 
local RestingFn = GLOBAL.State{
	name = "resting",
	tags = { "resting", "sleep", "busy", "nomorph" },
	onenter = function(inst)
		SetSleeperSleepState(inst)
		inst.components.locomotor:Stop()
		inst.AnimState:PlayAnimation("action_uniqueitem_pre")
		inst.AnimState:PushAnimation("bedroll", false)
		if inst.components.temperature:GetCurrent() < 12 then
    		inst.AnimState:OverrideSymbol("swap_bedroll", "swap_bedroll_furry", "bedroll_furry") else 
  			inst.AnimState:OverrideSymbol("swap_bedroll", "swap_bedroll_straw", "bedroll_straw")
        end
		if inst._sleepinghandsitem ~= nil then inst.AnimState:Show("ARM_carry") inst.AnimState:Hide("ARM_normal") end
	end,
	timeline = {
		TimeEvent(20 * FRAMES, function(inst)
			inst.SoundEmitter:PlaySound("dontstarve/wilson/use_bedroll")
		end),
	},
	events = {
		EventHandler("firedamage", function(inst)
			if inst.sg:HasStateTag("resting") then
				inst.sg:GoToState("restingwake")
			end
		end),
		EventHandler("animqueueover", function(inst)
			if inst.AnimState:AnimDone() then
				if inst.components.playercontroller ~= nil then inst.components.playercontroller:Enable(true) end
				inst.AnimState:PushAnimation("bedroll_sleep_loop", true)
				inst.AnimState:PlayAnimation("bedroll_sleep_loop", true)
				inst.sg:AddStateTag("resting")
				-- Auto wakeup
				inst.warncheck = inst:DoPeriodicTask(0, function(inst)
					local x,y,z = inst.Transform:GetWorldPosition()
					local ents = TheSim:FindEntities(x ,y ,z , 20)
					for k,v in pairs(ents) do 
						if v ~=nil and v.components.health and not v.components.health:IsDead() and v.components.combat and (v.components.combat.target == inst or v:HasTag("monster") or v:HasTag("werepig") or v:HasTag("frog")) and not v:HasTag("companion") and not v:HasTag("stalkerminion") and not v:HasTag("smashable") and not v:HasTag("alignwall") and not v:HasTag("shadowminion") then 
							inst.sg:GoToState("restingwake")
						end
					end
				end)
				-- Disable effect when attacked & Cancel task if still running
				inst:ListenForEvent("attacked", attackdrest)
				if inst.resttask ~= nil then inst.resttask:Cancel() end
				inst.resttask = inst:DoPeriodicTask(1, function(inst) RestTick(inst) end)
			end
		end),
	},
	onexit = function(inst)
		if not inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS) then
			inst.AnimState:Hide("ARM_carry") inst.AnimState:Show("ARM_normal")
		end
	end,
}
AddStategraphState("wilson", RestingFn)
AddStategraphState("wilson_client", RestingFn)
local RestingWakeFn = GLOBAL.State{
	name = "restingwake",
	tags = { "restingwake", "busy", "waking", "nomorph", "nodangle" },
	onenter = function(inst)
		inst.components.locomotor:Stop()
		if inst.components.playercontroller ~= nil then  inst.components.playercontroller:Enable(false) end
		if inst.AnimState:IsCurrentAnimation("bedroll") or inst.AnimState:IsCurrentAnimation("bedroll_sleep_loop") then
			inst.AnimState:PlayAnimation("bedroll_wakeup")
		elseif not (inst.AnimState:IsCurrentAnimation("bedroll_wakeup") or inst.AnimState:IsCurrentAnimation("wakeup")) then
			inst.AnimState:PlayAnimation("wakeup")
		end
	end,
	events = {
		EventHandler("animover", function(inst)
			if inst.AnimState:AnimDone() then
				inst.sg:GoToState("idle")
			end
		end),
	},
	onexit = function(inst)
		inst.sg:RemoveStateTag("resting"); SetSleeperAwakeState(inst)
		if inst.warncheck ~= nil then inst.warncheck:Cancel() inst.warncheck = nil end
		inst:RemoveEventCallback("attacked", attackdrest)
		if inst.resttask ~= nil then inst.resttask:Cancel() inst.resttask = nil end
	end,
}
AddStategraphState("wilson", RestingWakeFn)
AddStategraphState("wilson_client", RestingWakeFn)