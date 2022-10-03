local ACTIONS = GLOBAL.ACTIONS
local TheInput = GLOBAL.TheInput
local dodgeSkill = GetModConfigData("dodgeSlide")

-- Leap -------------------------------------------------------------------------------------
local function CanBlinkToPoint(pt)
    local ground = TheWorld()
    if ground then
        local tile = ground.Map:GetTileAtPoint(pt.x, pt.y, pt.z)
        return tile ~= GROUND.IMPASSABLE and tile < GROUND.UNDERGROUND
    end
end
local function CollectPointActions(doer, pos, actions, right)
    return CanBlinkToPoint(pos) and doer.components.inventory:Has("soul_orb",1) and not doer.sg:HasStateTag('leaper_leap')
end
local function ActionPickerPostInit(c)
    local old_get = c.DoGetMouseActions
    function c:DoGetMouseActions(...)
        local left,right = old_get(self,...)
        if self.inst:HasTag("Leaper") then
            return left,right
        end
        local ui = TheInput:GetHUDEntityUnderMouse()
        local pos = TheInput:GetWorldPosition()
        local OnRiding = self.inst.components.rider and self.inst.components.rider:IsRiding()
        if not (OnRiding) or not CollectPointActions(self.inst, pos) then 
            return left,right
        end
        if ui then
            return left,right
        end
        if not right then
            right = BufferedAction(self.inst, nil, ACTIONS.LEAPACT, nil, pos)
        else
            if right and right.action and (right.action.priority < -1 and right.action.id ~= 'LIGHT')then
                right = BufferedAction(self.inst, nil, ACTIONS.LEAPACT, nil, pos)
            end
        end
        return left,right
    end
end
AddComponentPostInit('playeractionpicker', ActionPickerPostInit)
local function DoPortalTint(inst, val)
    if val > 0 then
        inst.components.colouradder:PushColour("portaltint", 40/255 * val, 40/255 * val, 50/255 * val, 0)
        val = 1 - val
        inst.AnimState:SetMultColour(val, val, val, 1)
    else
        inst.components.colouradder:PopColour("portaltint")
        inst.AnimState:SetMultColour(1, 1, 1, 1)
    end
end
local function ToggleOffPhysics(inst)
    inst.sg.statemem.isphysicstoggle = true
    inst.Physics:ClearCollisionMask()
    inst.Physics:CollidesWith(COLLISION.GROUND)
end
local function ToggleOnPhysics(inst)
    inst.sg.statemem.isphysicstoggle = nil
    inst.Physics:ClearCollisionMask()
    inst.Physics:CollidesWith(COLLISION.WORLD)
    inst.Physics:CollidesWith(COLLISION.OBSTACLES)
    inst.Physics:CollidesWith(COLLISION.SMALLOBSTACLES)
    inst.Physics:CollidesWith(COLLISION.CHARACTERS)
    inst.Physics:CollidesWith(COLLISION.GIANTS)
end

-- Action Scene ----------------------------------------------------------------------------------
local LEAPACT = GLOBAL.Action({ priority=10, rmb=true, distance=36, mount_valid=true })
LEAPACT.str = "Leap"
LEAPACT.id = "LEAPACT"
AddAction(LEAPACT)
LEAPACT.fn = function(act)
	local act_pos = act:GetActionPoint()
	if act.doer ~= nil
        and act.doer.sg ~= nil
        and act.doer.sg.currentstate.name == "leaper_jump_in_pre"
        and act_pos ~= nil
        and act.doer.components.inventory ~= nil
        and act.doer.components.inventory:Has("soul_orb", 1) then
        act.doer.components.inventory:ConsumeByName("soul_orb", 1)
        act.doer.sg:GoToState("leaper_jump_in", act_pos)
        return true
	end
end
AddStategraphActionHandler("wilson", GLOBAL.ActionHandler(GLOBAL.ACTIONS.LEAPACT, "leaper_jump_in_pre"))
AddStategraphActionHandler("wilson_client", GLOBAL.ActionHandler(GLOBAL.ACTIONS.LEAPACT, "leaper_jump_in_pre"))
--- End Leap

local DODGEACT = GLOBAL.Action({}, -5, nil, nil, 3, nil, true)
DODGEACT.str = "Dodge"
DODGEACT.id = "DODGEACT"
AddAction(DODGEACT)
AddStategraphEvent("wilson",
	GLOBAL.EventHandler("redirect_locomote", function(inst)
        local bufferedaction = inst:GetBufferedAction()
        if bufferedaction and bufferedaction.action.id == "DODGEACT" then
            inst.sg:GoToState("dodge")
        end
    end)
)
--- End Dodge


-- Above "common_postinit" ----------------------------------------------------------------------------------
local function NoHoles(pt)
    return (TheWorld.Map:IsAboveGroundAtPoint(pt.x, pt.y, pt.z) or TheWorld.Map:GetPlatformAtPoint(pt.x, pt.z) ~= nil) and not TheWorld.Map:IsGroundTargetBlocked(pt)
end
local BLINKFOCUS_MUST_TAGS = { "blinkfocus" }
local CONTROLLER_BLINKFOCUS_DISTANCE = 8
local CONTROLLER_BLINKFOCUS_DISTANCESQ_MIN = 4
local CONTROLLER_BLINKFOCUS_ANGLE = 30
local function ReticuleTargetFn(inst)
    local rotation = inst.Transform:GetRotation()
    local pos = inst:GetPosition()
    local ents = TheSim:FindEntities(pos.x, pos.y, pos.z, CONTROLLER_BLINKFOCUS_DISTANCE, BLINKFOCUS_MUST_TAGS)
    for _, v in ipairs(ents) do
        local epos = v:GetPosition()
        if distsq(pos, epos) > CONTROLLER_BLINKFOCUS_DISTANCESQ_MIN then
            local angletoepos = inst:GetAngleToPoint(epos)
            local angleto = math.abs(anglediff(rotation, angletoepos))
            if angleto < CONTROLLER_BLINKFOCUS_ANGLE then
                return epos
            end
        end
    end
    rotation = rotation * DEGREES
    pos.y = 0
    for r = 13, 4, -.5 do
        local offset = FindWalkableOffset(pos, rotation, r, 1, false, true, NoHoles)
        if offset ~= nil then
            pos.x = pos.x + offset.x
            pos.z = pos.z + offset.z
            return pos
        end
    end
    for r = 13.5, 16, .5 do
        local offset = FindWalkableOffset(pos, rotation, r, 1, false, true, NoHoles)
        if offset ~= nil then
            pos.x = pos.x + offset.x
            pos.z = pos.z + offset.z
            return pos
        end
    end
    pos.x = pos.x + math.cos(rotation) * 13
    pos.z = pos.z - math.sin(rotation) * 13
    return pos
end
local function IsSoulOrbinInv(inst, data)
	if inst.components.inventory:Has("soul_orb", 1) then
	   inst:AddTag("soulleaper")
	end
end
local function NoSoulOrbinInv(inst, data)
	if not inst.components.inventory:Has("soul_orb", 1) then
		inst:RemoveTag("soulleaper")
	end
end
local function IsSoul(item)
    return item.prefab == "soul_orb"
end
local function GetStackSize(item)
    return item.components.stackable ~= nil and item.components.stackable:StackSize() or 1
end
local function SortByStackSize(l, r)
    return GetStackSize(l) < GetStackSize(r)
end
local function CheckSoulsAdded(inst)
    inst._checksoulstask = nil
    local souls = inst.components.inventory:FindItems(IsSoul)
    local count = 0
    for i, v in ipairs(souls) do
        count = count + GetStackSize(v)
    end
    if count > 40 then
        --convert count to drop count
        count = count - math.floor(40 / 2) + math.random(0, 2) - 1
        table.sort(souls, SortByStackSize)
        local pos = inst:GetPosition()
        for i, v in ipairs(souls) do
            local vcount = GetStackSize(v)
            if vcount < count then
                inst.components.inventory:DropItem(v, true, true, pos)
                count = count - vcount
            else
                if vcount == count then
                    inst.components.inventory:DropItem(v, true, true, pos)
                else
                    v = v.components.stackable:Get(count)
                    v.Transform:SetPosition(pos:Get())
                    v.components.inventoryitem:OnDropped(true)
                end
                break
            end
        end
        inst.components.sanity:DoDelta(-20)
		inst.sg:GoToState("mindcontrolled")
		inst.components.talker:Say("Too many soul")
    elseif count > 30 then
        inst.components.talker:Say("I have so much soul!")
    end
end
local function OnGotNewItem(inst, data)
    if data.item ~= nil and data.item.prefab == "soul_orb" then
        if inst._checksoulstask ~= nil then
            inst._checksoulstask:Cancel()
        end
        inst._checksoulstask = inst:DoTaskInTime(0, CheckSoulsAdded)
    end
end
--- End Leap Check

local function EnergyLevel(inst, data)
    if inst.components.orchidacite then
        if inst.components.orchidacite.min_energy >= 5 then
            inst:RemoveTag("noenergy")
        elseif inst.components.orchidacite.min_energy < 5 then
            inst:AddTag("noenergy")
        end
    end
end
--- End Dodge Check

--- Player Action ---------------------------------------------------------------------------------------
local function GetPointSpecialActions(inst, pos, useitem, right)
	local rider = inst.components.rider
	
	-- Config: Mod Info
	if dodgeSkill == "enable" then
		if right and not inst:HasTag("soulleaper") and (rider == nil or not rider:IsRiding()) and not inst:HasTag("noenergy") and not inst:HasTag("blockingdamage") then
			if GetTime() - inst.last_dodge_time > 2 then
				return { ACTIONS.DODGEACT }
			end
		end
	end
	
	if right and useitem == nil and NoHoles(pos) and inst:HasTag("soulleaper") and (rider == nil or not rider:IsRiding()) and not inst:HasTag("blockingdamage") then
		return { ACTIONS.LEAPACT }
	end
	
	return {}
end
local function OnSetOwner(inst)
    if inst.components.playeractionpicker ~= nil then
		inst.components.playeractionpicker.pointspecialactionsfn = GetPointSpecialActions
	end
end


-- Inside "master_postinit"
local prefabName = "dendrobium"
AddPrefabPostInit(prefabName, function(inst)
	inst:ListenForEvent("setowner", OnSetOwner)
	-- Dodge
	inst.last_dodge_time = GetTime()
    inst:DoPeriodicTask(1, EnergyLevel)
	
	-- Leap
	inst:AddComponent("reticule")
    inst.components.reticule.targetfn = ReticuleTargetFn
    inst.components.reticule.ease = true
    inst._checksoulstask = nil
    inst:ListenForEvent("gotnewitem", OnGotNewItem)
	inst:ListenForEvent("itemget", IsSoulOrbinInv)
	inst:ListenForEvent("itemlose", NoSoulOrbinInv)	
end)


-- Leap SG -------------------------------------------------------------------------------------------------
local JumpInPreFn = GLOBAL.State {
	name = "leaper_jump_in_pre",
	tags = { "busy", "leaper_leap" },
	onenter = function(inst)
		inst.components.locomotor:Stop()
		inst.AnimState:PlayAnimation("wortox_portal_jumpin_pre")
		local buffaction = inst:GetBufferedAction()
		if buffaction ~= nil and buffaction.pos ~= nil then
			inst:ForceFacePoint(buffaction:GetActionPoint():Get())
			--inst:ForceFacePoint(buffaction.pos:Get()) -- Use at non Beta Update
		end
	end,
	events = {
		EventHandler("animover", function(inst)
			if inst.AnimState:AnimDone() and not inst:PerformBufferedAction() then
				inst.sg:GoToState("idle")
			end
		end),
	},
} 
AddStategraphState("wilson", JumpInPreFn)
-- AddStategraphState("wilson_client", JumpInPreFn)
local JumpInFn = GLOBAL.State {
	name = "leaper_jump_in",
	tags = { "busy", "pausepredict", "nodangle", "nomorph", "leaper_leap" },
	onenter = function(inst, dest)
		inst.components.locomotor:Stop()
		inst.AnimState:PlayAnimation("leaper_portal_jumpin_fx")
		local x, y, z = inst.Transform:GetWorldPosition()
		SpawnPrefab("leaper_portal_jumpin_fx").Transform:SetPosition(x, y, z)
		inst.sg:SetTimeout(11 * FRAMES)
		if dest ~= nil then
			inst.sg.statemem.dest = dest
			inst:ForceFacePoint(dest:Get())
		else
			inst.sg.statemem.dest = Vector3(x, y, z)
		end
		if inst.components.playercontroller ~= nil then
			inst.components.playercontroller:RemotePausePrediction()
		end
	end,
	onupdate = function(inst)
		if inst.sg.statemem.tints ~= nil then
			DoPortalTint(inst, table.remove(inst.sg.statemem.tints))
			if #inst.sg.statemem.tints <= 0 then
				inst.sg.statemem.tints = nil
			end
		end
	end,
	timeline = {
		TimeEvent(FRAMES, function(inst)
			inst.SoundEmitter:PlaySound("dontstarve/creatures/together/toad_stool/infection_post", nil, .7)
			inst.SoundEmitter:PlaySound("dontstarve/characters/wortox/soul/spawn", nil, .5)
		end),
		TimeEvent(2 * FRAMES, function(inst)
			inst.sg.statemem.tints = { 1, .6, .3, .1 }
			PlayFootstep(inst)
		end),
		TimeEvent(4 * FRAMES, function(inst)
			inst.sg:AddStateTag("noattack")
			inst.components.health:SetInvincible(true)
			inst.DynamicShadow:Enable(false)
		end),
	},
	ontimeout = function(inst)
		inst.sg.statemem.portaljumping = true
		inst.sg:GoToState("leaper_jump_out", inst.sg.statemem.dest)
	end,
	onexit = function(inst)
		if not inst.sg.statemem.portaljumping then
			inst.components.health:SetInvincible(false)
			inst.DynamicShadow:Enable(true)
			DoPortalTint(inst, 0)
		end
	end,        
} 
AddStategraphState("wilson", JumpInFn)
-- AddStategraphState("wilson_client", JumpInFn)
local JumpOutFn = GLOBAL.State {
	name = "leaper_jump_out",
	tags = {"evade", "no_stun", "busy", "nopredict", "nomorph", "noattack", "nointerrupt", "leaper_leap"},
	onenter = function(inst, dest)
		ToggleOffPhysics(inst)
		inst.components.locomotor:Stop()
		inst.AnimState:PlayAnimation("wortox_portal_jumpout")
		if dest ~= nil then
			inst.Physics:Teleport(dest:Get())
		else
			dest = inst:GetPosition()
		end
		SpawnPrefab("leaper_portal_jumpout_fx").Transform:SetPosition(dest:Get())
		inst.DynamicShadow:Enable(false)
		inst.sg:SetTimeout(14 * FRAMES)
		DoPortalTint(inst, 1)
		inst.components.health:SetInvincible(true)
		--inst:PushEvent("soulhop")
	end,
	onupdate = function(inst)
		if inst.sg.statemem.tints ~= nil then
			DoPortalTint(inst, table.remove(inst.sg.statemem.tints))
			if #inst.sg.statemem.tints <= 0 then
				inst.sg.statemem.tints = nil
			end
		end
	end,
	timeline ={
		TimeEvent(FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/characters/wortox/soul/hop_out") end),
		TimeEvent(5 * FRAMES, function(inst)
			inst.sg.statemem.tints = { 0, .4, .7, .9 }
		end),
		TimeEvent(7 * FRAMES, function(inst)
			inst.components.health:SetInvincible(false)
			inst.sg:RemoveStateTag("noattack")
			inst.SoundEmitter:PlaySound("dontstarve/movement/bodyfall_dirt")
		end),
		TimeEvent(8 * FRAMES, function(inst)
			inst.DynamicShadow:Enable(true)
			ToggleOnPhysics(inst)
		end),
	},
	ontimeout = function(inst)
		inst.sg:GoToState("idle", true)
	end,
	onexit = function(inst)
		inst.components.health:SetInvincible(false)
		inst.DynamicShadow:Enable(true)
		DoPortalTint(inst, 0)
	end,
}
AddStategraphState("wilson", JumpOutFn)
-- AddStategraphState("wilson_client", JumpOutFn)

-- Dodge SG -------------------------------------------------------------------------------------------------
AddStategraphEvent("wilson", 
	GLOBAL.EventHandler("locomote", function(inst, data)
        if inst.sg:HasStateTag("busy") or inst.sg:HasStateTag("armorbroke") or inst.sg:HasStateTag("toolbroke") or inst.sg:HasStateTag("tool_slip") then
            return
        end
        local is_moving = inst.sg:HasStateTag("moving")
        local should_move = inst.components.locomotor:WantsToMoveForward()
		local bufferedaction = inst:GetBufferedAction()
        if inst.sg:HasStateTag("bedroll") or inst.sg:HasStateTag("tent") or inst.sg:HasStateTag("waking") then -- wakeup on locomote
            if inst.sleepingbag ~= nil and inst.sg:HasStateTag("sleeping") then
                inst.sleepingbag.components.sleepingbag:DoWakeUp()
                inst.sleepingbag = nil
            end
		elseif bufferedaction and bufferedaction.action.id == "DODGEACT" then
            inst.sg:GoToState("dodge")
        elseif is_moving and not should_move then
            inst.sg:GoToState("run_stop")
        elseif not is_moving and should_move then
            inst.sg:GoToState("run_start")
        elseif data.force_idle_state and not (is_moving or should_move or inst.sg:HasStateTag("idle")) then
            inst.sg:GoToState("idle")
        end
    end)
)
local DodgeStartFn = GLOBAL.State {
	name = "dodge",
	tags = { "busy", "evade", "no_stun" },
	onenter = function(inst)
		inst.sg:SetTimeout(0.25) -- 0.15
		inst.components.locomotor:Stop()
		if inst.components.orchidacite then 
			inst.components.orchidacite:DoDelta("energy", -5)
		end
		inst.AnimState:PlayAnimation("slide_pre")
		inst.AnimState:PushAnimation("slide_loop")
		--inst.SoundEmitter:PlaySound("dontstarve_DLC003/characters/wheeler/slide")
		inst.Physics:SetMotorVelOverride(25,0,0)
		inst.components.locomotor:EnableGroundSpeedMultiplier(false)
		inst.components.health:SetInvincible(true)
		inst:PerformBufferedAction()
		inst.last_dodge_time = GLOBAL.GetTime()
	end,
	ontimeout = function(inst)
		inst.sg:GoToState("dodge_pst")
	end,
	onexit = function(inst)
		inst.components.locomotor:EnableGroundSpeedMultiplier(true)
		inst.Physics:ClearMotorVelOverride()
		inst.components.locomotor:Stop()
	end,
}
AddStategraphState("wilson", DodgeStartFn)
-- AddStategraphState("wilson_client", DodgeStartFn)
local DodgeExitFn = GLOBAL.State{
	name = "dodge_pst",
	tags = {"evade","no_stun"},
	onenter = function(inst)
		inst.AnimState:PlayAnimation("slide_pst")
		inst.components.locomotor:SetBufferedAction(nil)
		inst.components.health:SetInvincible(false)
	end,
	ontimeout = function(inst)
	
	end,
	onexit = function(inst)
	
	end,  
	timeline = {
		TimeEvent(0, function(inst)
		
		end),
	},
	events ={
		GLOBAL.EventHandler("animover", function(inst)
			inst.sg:GoToState("idle")
		end ),
	}
}
AddStategraphState("wilson", DodgeExitFn)
-- AddStategraphState("wilson_client", DodgeExitFn)