local ACTIONS = GLOBAL.ACTIONS
-- List of structures that can be re-lit
local targetstructures = { 
	"firepit",
	"coldfirepit",
	"nightlight"
}

-- List of entities that can be controlled
local targetsmobs = {  
    "character", 		"pigman", 			"bunnyman", 		"frog", 
    "monkey", 			"bat", 				"minotaur", 		"bishop", 
    "krampus", 			"mossling", 		"tallbird", 		"deerclopse", 
    "bearger", 			"dragonfly", 		"moose", 			"leif", 
    "spat", 			"birchnutdrake", 	"deerclops", 		"toadstool", 
    "beequeen", 		"klaus", 			"stalker", 			"antlion", 
    "beefalo", 			"perd", 			"spider", 			"spider_warrior", 
    "spiderqueen", 		"spider_spitter", 	"spider_dropper", 	"hound", 
    "firehound", 		"icehound", 		"warg", 			"tentacle", 
    "walrus", 			"merm", 			"knight", 			"rook", 
    "pigguard", 		"leif_sparse", 
}
----------------------------------------------------------------------------------------------
local function OnStartControlling(inst, doer)
    inst.doer = doer.components.sanity ~= nil and doer or nil
    if inst.doer ~= nil then
        inst.doer.components.sanity.externalmodifiers:SetModifier(inst, -1)
    end
end
local function OnStopControlling(inst, doer)
    if inst.doer ~= nil and inst.doer:IsValid() and inst.doer.components.sanity ~= nil then
        inst.doer.components.sanity.externalmodifiers:RemoveModifier(inst)
    end
end
for k,v in pairs(targetsmobs) do
	AddPrefabPostInit(v,function(inst)
		if GLOBAL.TheWorld.ismastersim then
            inst:AddTag("MindControlled")
			inst:AddComponent("puppeteer")
			inst.components.puppeteer:SetControllingFn(OnStartControlling, OnStopControlling)
		end
	end)
end
----------------------------------------------------------------------------------------------
local function OnStartSwitching(inst, doer)
    inst.doer = doer.components.sanity ~= nil and doer or nil
    if inst.doer ~= nil then
        inst.doer.components.sanity:DoDelta(-4)
		inst.doer.components.sanity.externalmodifiers:SetModifier(inst, -1)
    end
end
local function OnStopSwitching(inst, doer)
    if inst.doer ~= nil and inst.doer:IsValid() and inst.doer.components.sanity ~= nil then
		inst.doer.components.sanity.externalmodifiers:RemoveModifier(inst)
    end
end
for k,v in pairs(targetstructures) do
	AddPrefabPostInit(v,function(inst)
		if GLOBAL.TheWorld.ismastersim then
			inst:AddTag("FireStructures")
			inst:AddComponent("puppeteer")
			inst.components.puppeteer:SetSwitchingFn(OnStartSwitching, OnStopSwitching)
		end
	end)
end
----------------------------------------------------------------------------------------------
-- Action (Just start)
local IgniteAction = GLOBAL.Action({ distance = 36 }) -- Distance
IgniteAction.str = "Switch"
IgniteAction.id = "IgniteAction"
AddAction(IgniteAction)
IgniteAction.fn = function(act)
	if act.doer ~= nil and 
		act.target ~= nil and 
            act.doer:HasTag("Firemastery") and act.target:HasTag("FireStructures") then
		return act.target.components.puppeteer:StartSwitching(act.doer)
	end
end

-- Action (Start)
local StartMindControl = GLOBAL.Action({ distance = 36 })
StartMindControl.str = "Start Manipulate"
StartMindControl.id = "StartMindControl"
AddAction(StartMindControl)
StartMindControl.fn = function(act)
	if act.doer ~= nil and 
		act.target ~= nil and 
			act.doer:HasTag("Mastermind") and 
				act.target.components.puppeteer and 
					act.target:HasTag("MindControlled") then
		return act.target.components.puppeteer:StartControlling(act.doer)
	end
end

-- Action (Stop)
local StopMindControl = GLOBAL.Action({ instant = true, distance = 36 })
StopMindControl.str = "Stop Manipulate"
StopMindControl.id = "StopMindControl"
AddAction(StopMindControl)
StopMindControl.fn = function(act)
	if act.doer ~= nil and 
		act.target ~= nil and 
			act.doer:HasTag("Mastermind") and 
				act.target.components.puppeteer and 
					act.target:HasTag("MindControlled") then
		return act.target.components.puppeteer:StopControlling(act.doer)
	end
end

AddComponentAction("SCENE", "puppeteer", function(inst, doer, actions, right)
    if right then
        if inst:HasTag("MindControlled") and not doer.sg:HasStateTag("controlling") and doer:HasTag("Mastermind") then
            table.insert(actions, GLOBAL.ACTIONS.StartMindControl)
        end
    end
    if right then
        if inst:HasTag("MindControlled") and doer.sg:HasStateTag("controlling") and doer:HasTag("Mastermind") then
            table.insert(actions, GLOBAL.ACTIONS.StopMindControl)
        end
    end
    if right then
        if inst:HasTag("FireStructures") and not doer.sg:HasStateTag("ignite_start") and doer:HasTag("Firemastery") then
            table.insert(actions, GLOBAL.ACTIONS.IgniteAction)
        end
    end
end)

-- Character state animation
local start_controlling = GLOBAL.State{ 
		name = "startcontrolling",
		tags = { "doing", "busy", "precontrolling", "nodangle" },
        onenter = function(inst)
            inst.components.locomotor:Stop()
            inst.AnimState:PlayAnimation("channel_pre")
            inst.AnimState:PushAnimation("channel_loop", true)
            inst.sg:SetTimeout(.7)
        end,
        timeline =
        {
            TimeEvent(7 * FRAMES, function(inst)
                inst.sg:RemoveStateTag("busy")
            end),
            TimeEvent(9 * FRAMES, function(inst)
                inst:PerformBufferedAction()
            end),
        },
        ontimeout = function(inst)
            inst.AnimState:PlayAnimation("channel_pst")
        end,
        events =
        {
            EventHandler("animqueueover", function(inst)
                if inst.AnimState:AnimDone() then
                    inst.sg:GoToState("idle")
                end
            end),
		},
}
AddStategraphState("wilson",start_controlling)
AddStategraphState("wilson_client",start_controlling)

-- Play loop animation while controlling
local controlling_state = GLOBAL.State{
        name = "controlling",
        tags = { "doing", "controlling", "nodangle" },
        onenter = function(inst, target)
            inst:AddTag("controlling")
            inst.components.locomotor:Stop()
            if not inst.AnimState:IsCurrentAnimation("channel_loop") then
                inst.AnimState:PlayAnimation("channel_loop", true)
            end
            inst.sg.statemem.target = target
        end,
        onupdate = function(inst)
            if not CanEntitySeeTarget(inst, inst.sg.statemem.target) then
                inst.sg:GoToState("stopcontrolling")
            end
        end,
        events =
        {
            EventHandler("ontalk", function(inst)
                if not (inst.AnimState:IsCurrentAnimation("channel_dial_loop") or inst:HasTag("mime")) then
                    inst.AnimState:PlayAnimation("channel_dial_loop", true)
                end
            end),
            EventHandler("donetalking", function(inst)
                if not inst.AnimState:IsCurrentAnimation("channel_loop") then
                    inst.AnimState:PlayAnimation("channel_loop", true)
                end
            end),
        },
        onexit = function(inst)
            inst:RemoveTag("controlling")
            if not inst.sg.statemem.stopcontrolling and
                inst.sg.statemem.target ~= nil and
                inst.sg.statemem.target:IsValid() and
                inst.sg.statemem.target.components.puppeteer ~= nil then
                inst.sg.statemem.target.components.puppeteer:StopControlling(true)
            end
        end,
}
AddStategraphState("wilson", controlling_state)
AddStategraphState("wilson_client", controlling_state)

-- Play animation stop controlling
local stop_controlling = GLOBAL.State {
        name = "stopcontrolling",
        tags = { "idle", "nodangle" },
        onenter = function(inst)
            inst.AnimState:PlayAnimation("channel_pst")
        end,
        events =
        {
		EventHandler("animover", function(inst)
			if inst.AnimState:AnimDone() then
				inst.sg:GoToState("idle")
			end
		end),
		},
}
AddStategraphState("wilson", stop_controlling)
AddStategraphState("wilson_client", stop_controlling)

AddStategraphActionHandler("wilson", GLOBAL.ActionHandler(GLOBAL.ACTIONS.StartMindControl, "startcontrolling"))
AddStategraphActionHandler("wilson_client", GLOBAL.ActionHandler(GLOBAL.ACTIONS.StartMindControl, "startcontrolling"))

AddStategraphActionHandler("wilson", GLOBAL.ActionHandler(GLOBAL.ACTIONS.StopMindControl, "stopcontrolling"))
AddStategraphActionHandler("wilson_client", GLOBAL.ActionHandler(GLOBAL.ACTIONS.StopMindControl, "stopcontrolling"))

----------------------------------------------------------------------------------------------
-- Character state animation
local start_ignite = GLOBAL.State{ 
    name = "ignite_start",
    tags = { "doing", "busy", "nodangle", "preignite" },
    onenter = function(inst)
        inst.components.locomotor:Stop()
        inst.AnimState:PlayAnimation("channel_pre")
        inst.AnimState:PushAnimation("channel_loop", true)
        inst.sg:SetTimeout(.7)
    end,
    timeline =
    {
        TimeEvent(7 * FRAMES, function(inst)
            inst.sg:RemoveStateTag("busy")
        end),
        TimeEvent(9 * FRAMES, function(inst)
            inst:PerformBufferedAction()
        end),
    },
    ontimeout = function(inst)
        inst.AnimState:PlayAnimation("channel_pst")
    end,
    events =
    {
        EventHandler("animqueueover", function(inst)
            if inst.AnimState:AnimDone() then
                inst.sg:GoToState("idle")
            end
        end),
    },
}
AddStategraphState("wilson",start_ignite)
AddStategraphState("wilson_client",start_ignite)

-- Play loop animation while igniting
local igniting_state = GLOBAL.State{
    name = "igniting",
    tags = { "doing", "igniting", "nodangle" },
    onenter = function(inst, target)
        inst:AddTag("igniting")
        inst.components.locomotor:Stop()
        if not inst.AnimState:IsCurrentAnimation("channel_loop") then
            inst.AnimState:PlayAnimation("channel_loop", true)
        end
        inst.sg.statemem.target = target
    end,
    onupdate = function(inst)
        if not CanEntitySeeTarget(inst, inst.sg.statemem.target) then
            inst.sg:GoToState("ignite_stop")
        end
    end,
    events =
    {
        EventHandler("ontalk", function(inst)
            if not (inst.AnimState:IsCurrentAnimation("channel_dial_loop") or inst:HasTag("mime")) then
                inst.AnimState:PlayAnimation("channel_dial_loop", true)
            end
        end),
        EventHandler("donetalking", function(inst)
            if not inst.AnimState:IsCurrentAnimation("channel_loop") then
                inst.AnimState:PlayAnimation("channel_loop", true)
            end
        end),
    },
    onexit = function(inst)
        inst:RemoveTag("igniting")
        if not inst.sg.statemem.stopswitching and
            inst.sg.statemem.target ~= nil and
            inst.sg.statemem.target:IsValid() and
            inst.sg.statemem.target.components.switcher ~= nil then
            inst.sg.statemem.target.components.switcher:StopSwitching(true)
        end
    end,
}
AddStategraphState("wilson", igniting_state)
AddStategraphState("wilson_client", igniting_state)

-- Play animation stop igniting
local stop_ignite = GLOBAL.State {
    name = "ignite_stop",
    tags = { "idle", "nodangle" },
    onenter = function(inst)
        inst.AnimState:PlayAnimation("channel_pst")
    end,
    events =
    {
    EventHandler("animover", function(inst)
        if inst.AnimState:AnimDone() then
            inst.sg:GoToState("idle")
        end
    end),
    },
}
AddStategraphState("wilson", stop_ignite)
AddStategraphState("wilson_client", stop_ignite)

AddStategraphActionHandler("wilson", GLOBAL.ActionHandler(GLOBAL.ACTIONS.IgniteAction, "ignite_start"))
AddStategraphActionHandler("wilson_client", GLOBAL.ActionHandler(GLOBAL.ACTIONS.IgniteAction, "ignite_start"))