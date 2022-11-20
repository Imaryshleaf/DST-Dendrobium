local STRINGS = GLOBAL.STRINGS
local ACTIONS = GLOBAL.ACTIONS

-- A string "Extinguish Wildfire" under cursor
AddAction("ACTEXTINGUISH", "Extinguish", function(act)
	if act.doer ~= nil 
		and act.target ~= nil 
		and act.doer:HasTag("Dendrobium") 
		and act.doer.spellpower_count == (1) 
		and not act.target.components.health:IsDead() 
		and act.doer.components.orchidacite 
		and act.doer.components.orchidacite.min_energy >= (10) then
			act.target.components.orchidacite:Extinguish(act.doer)
		return true	else return false
	end
end)
AddStategraphActionHandler("wilson", GLOBAL.ActionHandler(GLOBAL.ACTIONS.ACTEXTINGUISH, "FluteExtinguishSG"))
AddStategraphActionHandler("wilson_client", GLOBAL.ActionHandler(GLOBAL.ACTIONS.ACTEXTINGUISH, "FluteExtinguishSG"))

-- A string "Dawn Lights" under cursor
AddAction("ACTDAWNLIGHT", "Lights", function(act)
	if act.doer ~= nil 
		and act.target ~= nil 
		and act.doer:HasTag("Dendrobium") 
		and act.doer.spellpower_count == (2) 
		and not act.target.components.health:IsDead() 
		and act.doer.components.sanity 
		and act.doer.components.sanity.current >= (20) then
			act.target.components.orchidacite:DawnLight(act.doer)
		return true	else return false
	end
end)
AddStategraphActionHandler("wilson", GLOBAL.ActionHandler(GLOBAL.ACTIONS.ACTDAWNLIGHT, "DawnLightSG"))
AddStategraphActionHandler("wilson_client", GLOBAL.ActionHandler(GLOBAL.ACTIONS.ACTDAWNLIGHT, "DawnLightSG"))

-- A string "Frigid Aura" under cursor
AddAction("ACTFRIGIDAURA", "Frost Smite", function(act)
	if act.doer ~= nil 
		and act.target ~= nil 
		and act.doer:HasTag("Dendrobium") 
		and act.doer.spellpower_count == (3) 
		and not act.target.components.health:IsDead() 
		and act.doer.components.orchidacite.min_magic >= (25) then
			act.target.components.orchidacite:FrigidAura(act.doer)
		return true	else return false
	end
end)
AddStategraphActionHandler("wilson", GLOBAL.ActionHandler(GLOBAL.ACTIONS.ACTFRIGIDAURA, "FrigidAuraSG"))
AddStategraphActionHandler("wilson_client", GLOBAL.ActionHandler(GLOBAL.ACTIONS.ACTFRIGIDAURA, "FrigidAuraSG"))

-- A string "Dawn Lights" under cursor
AddAction("ACTLIGHTNINGSMITE", "Lightning Smite", function(act)
	if act.doer ~= nil 
		and act.target ~= nil 
		and act.doer:HasTag("Dendrobium") 
		and act.doer.spellpower_count == (4) 
		and not act.target.components.health:IsDead() 
		and act.doer.components.orchidacite.min_magic >= (30) then
			act.target.components.orchidacite:LightningSmite(act.doer)
		return true	else return false
	end
end)
AddStategraphActionHandler("wilson", GLOBAL.ActionHandler(GLOBAL.ACTIONS.ACTLIGHTNINGSMITE, "LightningSmiteSG"))
AddStategraphActionHandler("wilson_client", GLOBAL.ActionHandler(GLOBAL.ACTIONS.ACTLIGHTNINGSMITE, "LightningSmiteSG"))

AddComponentAction("SCENE", "orchidacite", function(inst, doer, actions, right)
	if right then
		if inst:HasTag("Dendrobium") and inst.spellpower_count == (1) and
				inst == doer and (rider == nil or not rider:IsRiding()) then
			table.insert(actions, GLOBAL.ACTIONS.ACTEXTINGUISH)	
		end
	end
	if right then
		if inst:HasTag("Dendrobium") and inst.spellpower_count == (2) and
				inst == doer and (rider == nil or not rider:IsRiding()) then
			table.insert(actions, GLOBAL.ACTIONS.ACTDAWNLIGHT)	
		end
	end
	if right then
		if inst:HasTag("Dendrobium") and inst.spellpower_count == (3) and
				inst == doer and (rider == nil or not rider:IsRiding()) then
			table.insert(actions, GLOBAL.ACTIONS.ACTFRIGIDAURA)	
		end
	end
	if right then
		if inst:HasTag("Dendrobium") and inst.spellpower_count == (4) and
				inst == doer and (rider == nil or not rider:IsRiding()) then
			table.insert(actions, GLOBAL.ACTIONS.ACTLIGHTNINGSMITE)	
		end
	end
	if right then
		if inst:HasTag("Dendrobium") and inst.spellpower_count == (5) and
				inst == doer and (rider == nil or not rider:IsRiding()) then
			table.insert(actions, GLOBAL.ACTIONS.ACTSHADOWFRIENDS)	
		end
	end
end)

----------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Flute Extinguish: (components check: hunger)
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
----------------------------------------------------------------------------------------------------------------------------------------------------
-- Light: (components check: sanity)  
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
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Freeze: (components check: magic) 
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
----------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Slow: (components check: magic)  
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