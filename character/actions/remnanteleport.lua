local ACTIONS = GLOBAL.ACTIONS

-- Leave shadow remnant
AddPrefabPostInit("dendrobium", function(inst) 
	inst._onremnantlost = function(pet) inst.components.sanity:RemoveSanityPenalty(pet) end
end)
local LEAVEREMNANT = GLOBAL.Action({ priority = 10, rmb = true, distance = 36, mount_valid = true })
LEAVEREMNANT.str = "Leave Shadow Remnant"
LEAVEREMNANT.id = "LEAVEREMNANT"
LEAVEREMNANT.fn = function(act)
	local inst = act.doer
	local act_pos = act:GetActionPoint()
	local fx = SpawnPrefab("statue_transition_2")
	local remnants = SpawnPrefab("dendrobium_shadow_remnants")
	if inst ~= nil 
		and inst.sg ~= nil 
		and act_pos ~= nil 
		and inst:HasTag("remnantsource") then
			fx.Transform:SetPosition(act_pos:Get())
			remnants.Transform:SetPosition(act_pos:Get())
			inst.components.sanity:AddSanityPenalty(remnants, .2)
			inst:ListenForEvent("onremove", inst._onremnantlost, remnants)
        return true
	end
end
AddAction(LEAVEREMNANT)
AddStategraphActionHandler("wilson", GLOBAL.ActionHandler(LEAVEREMNANT, "doshortaction"))  -- Change to better stategraph to enable cd function
AddStategraphActionHandler("wilson_client", GLOBAL.ActionHandler(LEAVEREMNANT, "doshortaction"))

-- Action (Teleport with shadow remnants)
local USEREMNANT = GLOBAL.Action({ distance = 36 })
USEREMNANT.str = "Teleport to Remnant"
USEREMNANT.id = "USEREMNANT"
AddAction(USEREMNANT)
USEREMNANT.fn = function(act)
	if act.doer ~= nil 
		and act.target ~= nil 
		and act.doer:HasTag("remnantsource")
		and act.target.components.shadowremnant then
		return act.target.components.shadowremnant:Teleport(act.doer, act.target)
	end
end
AddComponentAction("SCENE", "shadowremnant", function(inst, doer, actions, right)
    if right then
        if doer:HasTag("remnantsource") and inst.components.shadowremnant then
            table.insert(actions, USEREMNANT)
        end
    end
end)
AddStategraphActionHandler("wilson", GLOBAL.ActionHandler(USEREMNANT, "doshortaction")) -- Change to better stategraph
AddStategraphActionHandler("wilson_client", GLOBAL.ActionHandler(USEREMNANT, "doshortaction"))