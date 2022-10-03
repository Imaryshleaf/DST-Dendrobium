---- Clickable Treasure Badge : (components check: treasure) --------------------------------------------------------------------------------------------------
local revealXMarkFuncs = GLOBAL.State {
	name = "revealXMarkSG",
	tags = { "doing", "busy" },
	onenter = function(inst, silent)
		inst.components.locomotor:Stop()
		if inst.components.orchidacite.min_treasure >= 100 then
			inst.AnimState:PlayAnimation("action_uniqueitem_pre")
			inst.AnimState:PushAnimation("book", false)
			inst.components.orchidacite:DoDelta("treasure", -100)
			inst.components.talker:Say("Treasure will appear in this area.\nPrepare for the battle!", 2.5)
		else
			inst.sg:GoToState("mindcontrolled")
		end
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
				inst.SoundEmitter:PlaySound("dontstarve/common/use_book_light")	
		end),
		TimeEvent(54 * FRAMES, function(inst)
				inst.SoundEmitter:PlaySound("dontstarve/common/use_book_close")
		end),
		TimeEvent(58 * FRAMES, function(inst)
				inst.SoundEmitter:PlaySound("dontstarve/common/book_spell")
				inst:PerformBufferedAction()
				inst.sg.statemem.book_fx = nil
		end),
		TimeEvent(65 * FRAMES, function(inst)
			inst.sg:RemoveStateTag("busy")
			local pos1 = inst:GetPosition()
			local offset1 = FindWalkableOffset(pos1, math.random() * 2 * math.pi, math.random(10, 15), 10)
			local spawn_pos1 = pos1 + offset1 
			if offset1 then
				local chest_spawn = SpawnPrefab("treasure_trunk")
				chest_spawn.Transform:SetPosition(spawn_pos1:Get()) chest_spawn:SetTreasureHunt()
			end	
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
AddStategraphState("wilson", revealXMarkFuncs)
AddStategraphState("wilson_client", revealXMarkFuncs)
---- Clickable Bloom Badge: (components check: bloom) -----------------------------------------------------------------
local BloomingFunc = GLOBAL.State {
	name = "bloomStartSG",
	tags = { "busy", "pausepredict", "nomorph", "nodangle" },
	onenter = function(inst)
		inst.components.locomotor:Stop()
		if not inst.components.health:IsDead() then
			if inst.components.orchidacite ~= nil and inst.components.orchidacite.min_bloom >= (100) then
				inst.AnimState:OverrideSymbol("shadow_hands", "shadow_skinchangefx", "shadow_hands")
				inst.AnimState:OverrideSymbol("shadow_ball", "shadow_skinchangefx", "shadow_ball")
				inst.AnimState:OverrideSymbol("splode", "shadow_skinchangefx", "splode")
				inst.AnimState:PlayAnimation("pickup", false)
				inst.AnimState:PushAnimation("skin_change", false)
				inst.components.inventory:ReturnActiveActionItem(inst.bufferedaction ~= nil and inst.bufferedaction.invobject or nil)
				inst:DoTaskInTime(1.5 , function()
					if inst.components.orchidacite ~= nil then
						inst.CanStartBloom = true
					end
				end)
			else
				inst.sg:GoToState("mindcontrolled")
			end
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
		--inst.components.playercontroller:Enable(true)
		if inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS) then
			inst.AnimState:Show("ARM_carry")
			inst.AnimState:Hide("ARM_normal")
		end
	end,
}
AddStategraphState("wilson", BloomingFunc)
AddStategraphState("wilson_client", BloomingFunc)
-- Transform animation. Well, since I can't create my custom anim ---------------------------------------------------------------
local MorphingFn = GLOBAL.State {
	name = "MorphingSG",
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
AddStategraphState("wilson", MorphingFn)
AddStategraphState("wilson_client", MorphingFn)
-- Too much soul? Alter the souls ---------------------------------------------------------------
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
-- Taking a break  --------------------------------------------------------------------------------------
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
					local ents = TheSim:FindEntities(x ,y ,z , 10)
					for k,v in pairs(ents) do 
						if v ~=nil and v.components.health and not v.components.health:IsDead() and v.components.combat and (v.components.combat.target == inst or v:HasTag("monster") or v:HasTag("werepig") or v:HasTag("frog")) and not v:HasTag("companion") and not v:HasTag("stalkerminion") and not v:HasTag("smashable") and not v:HasTag("alignwall") and not v:HasTag("shadowminion") then 
							inst.sg:GoToState("restingwake")
						end
					end
				end)
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
	end,
}
AddStategraphState("wilson", RestingWakeFn)
AddStategraphState("wilson_client", RestingWakeFn)
-- Light: (components check: sanity)  --------------------------------------------------------------------------
local DawnLightFn = GLOBAL.State {
	name = "DawnLightSG",
	tags = { "doing", "busy" },
	onenter = function(inst)
		inst.components.locomotor:Stop()
		if inst.components.sanity and inst.components.sanity.current >= (40) then
			inst.AnimState:PlayAnimation("action_uniqueitem_pre")
			inst.AnimState:PushAnimation("book", false)
		else
			inst.sg:GoToState("mindcontrolled")
		end
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
AddStategraphState("wilson", DawnLightFn)
AddStategraphState("wilson_client", DawnLightFn)
-- Freeze: (components check: magic) ---------------------------------------------------------------------------------------------------------------
local FrigidAuraFn = GLOBAL.State {
	name = "FrigidAuraSG",
	tags = { "doing", "busy" },
	onenter = function(inst)
		inst.components.locomotor:Stop()
		if inst.components.orchidacite and inst.components.orchidacite.min_magic >= (25) then
			inst.AnimState:PlayAnimation("action_uniqueitem_pre")
			inst.AnimState:PushAnimation("book", false)
		else
			inst.sg:GoToState("mindcontrolled")
		end
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
AddStategraphState("wilson", FrigidAuraFn)
AddStategraphState("wilson_client", FrigidAuraFn)
-- Slow: (components check: magic)  -----------------------------------------------------------------------------------
local LightningSmiteFn = GLOBAL.State {
	name = "LightningSmiteSG",
	tags = { "doing", "busy" },
	onenter = function(inst)
		inst.components.locomotor:Stop()
		if inst.components.orchidacite and inst.components.orchidacite.min_magic >= (30) then
			inst.AnimState:PlayAnimation("action_uniqueitem_pre")
			inst.AnimState:PushAnimation("book", false)
		else
			inst.sg:GoToState("mindcontrolled")
		end
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
AddStategraphState("wilson", LightningSmiteFn)
AddStategraphState("wilson_client", LightningSmiteFn)
-- Flute Extinguish: (components check: hunger)  -------------------------------------------------------------------------------
local FluteExtinguishFn = GLOBAL.State{
	name = "FluteExtinguishSG",
	tags = { "doing", "playing" },
	onenter = function(inst)
		inst.components.locomotor:Stop()
		if inst.components.hunger and inst.components.hunger.current >= (5) then
			inst.AnimState:PlayAnimation("action_uniqueitem_pre")
			inst.AnimState:PushAnimation("flute", false)
			inst.AnimState:OverrideSymbol("pan_flute01", "pan_flute", "pan_flute01")
			inst.AnimState:Hide("ARM_carry")
			inst.AnimState:Show("ARM_normal")
			inst.components.inventory:ReturnActiveActionItem(inst.bufferedaction ~= nil and inst.bufferedaction.invobject or nil)
		else
			inst.sg:GoToState("mindcontrolled")
		end
	end,
	timeline = {
		TimeEvent(30 * FRAMES, function(inst)
			if inst:PerformBufferedAction() then
				inst.SoundEmitter:PlaySound("dontstarve/wilson/flute_LP", "flute")
			else
				inst.AnimState:SetTime(94 * FRAMES)
			end
		end),
		TimeEvent(85 * FRAMES, function(inst)
			inst.SoundEmitter:KillSound("flute")
		end),
	},
	events = {
		EventHandler("animqueueover", function(inst)
			if inst.AnimState:AnimDone() then
				inst.sg:GoToState("idle")
			end
		end),
	},
	onexit = function(inst)
		inst.SoundEmitter:KillSound("flute")
		if inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS) then
			inst.AnimState:Show("ARM_carry")
			inst.AnimState:Hide("ARM_normal")
		end
	end,
}
AddStategraphState("wilson", FluteExtinguishFn)
AddStategraphState("wilson_client", FluteExtinguishFn)