require "behaviours/wander"
require "behaviours/faceentity"
require "behaviours/chaseandattack"
require "behaviours/runaway"
require "behaviours/panic"
require "behaviours/follow"
require "behaviours/attackwall"
require "behaviours/doaction"

local EntsBrain = Class(Brain, function(self, inst)
    Brain._ctor(self, inst)
end)

local MIN_FOLLOW_DIST = 2
local TARGET_FOLLOW_DIST = 3
local MAX_FOLLOW_DIST = 6

local START_FACE_DIST = 6
local KEEP_FACE_DIST = 8

local KEEP_WORKING_DIST = 18
local SEE_WORK_DIST = 14

local RUN_AWAY_DIST = 5
local STOP_RUN_AWAY_DIST = 10

local KITING_DIST = 3
local STOP_KITING_DIST = 4

local AVOID_EXPLOSIVE_DIST = 5

local DIG_TAGS = { "stump", "grave", "farm_debris" }
local TOWORK_CANT_TAGS = { "fire", "smolder", "event_trigger", "INLIMBO", "NOCLICK", "carnivalgame_part" }

-- Following
local function GetLeader(inst)
    return inst.components.follower.leader 
end

local function IsNearLeader(inst, dist)
    local leader = GetLeader(inst)
    return leader ~= nil and inst:IsNear(leader, dist)
end

local function GetFaceTargetFn(inst)
    local target = GetClosestInstWithTag("player", inst, START_FACE_DIST)
    if target and not target:HasTag("notarget") then
        return target
    end
end

local function KeepFaceTargetFn(inst, target)
    return inst:IsNear(target, KEEP_FACE_DIST) and not target:HasTag("notarget")
end

-- Working
local function StartWorking(inst, data)
local x,y,z = inst.Transform:GetWorldPosition()
local ents = TheSim:FindEntities(x,y,z, SEE_WORK_DIST)
	for k,v in pairs(ents) do
		if (v:HasTag("tree") or v:HasTag("boulder") or v:HasTag("stump")) and not v:HasTag("statue") then
			return true
		end
	end
end

local function FindObjectToWorkAction(inst, action, addtltags)
local leader = GetLeader(inst)
    if leader ~= nil then
        local target = inst.sg.statemem.target
        if target ~= nil
			and target:IsValid() 
			and target.components.workable ~= nil 
			and target.components.workable:CanBeWorked() 
			and target.components.workable:GetWorkAction() == action 
			and not (target.components.burnable ~= nil and (target.components.burnable:IsBurning() or target.components.burnable:IsSmoldering())) 
			and not (target:IsInLimbo() or target:HasTag("NOCLICK") or target:HasTag("event_trigger"))
			and target.entity:IsVisible() 
			and target:IsNear(leader, KEEP_WORKING_DIST) then
            if addtltags ~= nil then
                for i, v in ipairs(addtltags) do
                    if target:HasTag(v) then
                        return BufferedAction(inst, target, action)
                    end
                end
            else
                return BufferedAction(inst, target, action)
            end
        end
		--Find new target to work
        target = FindEntity(leader, SEE_WORK_DIST, nil, { action.id.."_workable" }, TOWORK_CANT_TAGS, addtltags)
        return target ~= nil and BufferedAction(inst, target, action) or nil
    end
end

-- Combat
local function ShouldKite(target, inst)
    return inst.components.combat:TargetIs(target)
        and target.components.health ~= nil
        and not target.components.health:IsDead()
end

-- Avoid explosives
local function ShouldAvoidExplosive(target)
    return target.components.explosive == nil
        or target.components.burnable == nil
        or target.components.burnable:IsBurning()
end

-- Watch leader playing in minigame
local function ShouldWatchMinigame(inst)
	if inst.components.follower.leader ~= nil and inst.components.follower.leader.components.minigame_participator ~= nil then
		if inst.components.combat.target == nil or inst.components.combat.target.components.minigame_participator ~= nil then
			return true
		end
	end
	return false
end
local function WatchingMinigame(inst)
	return (inst.components.follower.leader ~= nil and inst.components.follower.leader.components.minigame_participator ~= nil) and inst.components.follower.leader.components.minigame_participator:GetMinigame() or nil
end
local function WatchingMinigame_MinDist(inst)
	local minigame = WatchingMinigame(inst)
	return minigame ~= nil and minigame.components.minigame.watchdist_min or 0
end
local function WatchingMinigame_TargetDist(inst)
	local minigame = WatchingMinigame(inst)
	return minigame ~= nil and minigame.components.minigame.watchdist_target or 0
end
local function WatchingMinigame_MaxDist(inst)
	local minigame = WatchingMinigame(inst)
	return minigame ~= nil and minigame.components.minigame.watchdist_max or 0
end

-- Initialize brain
function EntsBrain:OnStart()

	local watch_game = WhileNode(function() return ShouldWatchMinigame(self.inst) end, "Watching Game",
        PriorityNode({
            Follow(self.inst, WatchingMinigame, WatchingMinigame_MinDist, WatchingMinigame_TargetDist, WatchingMinigame_MaxDist),
            RunAway(self.inst, "minigame_participator", 5, 7),
            FaceEntity(self.inst, WatchingMinigame, WatchingMinigame),
		}, .25))

    local root = PriorityNode(
	{
	
		watch_game,
		
		WhileNode(function() 
			return IsNearLeader(self.inst, KEEP_WORKING_DIST)
				end, "Leader In Range",
				
		PriorityNode({
			-- Avoid explosives
			RunAway(self.inst, { fn = ShouldAvoidExplosive, tags = { "explosive" }, notags = { "INLIMBO" } }, AVOID_EXPLOSIVE_DIST, AVOID_EXPLOSIVE_DIST),
			
			-- Duelists
			IfNode(function() return self.inst.prefab == "dendrobium_shadow_duelist" end, "Is Duelist",
				PriorityNode({
					WhileNode(function() 
						return self.inst.components.combat.target ~= nil 
							and self.inst.components.combat:InCooldown() 
							and ShouldKite(self.inst.components.combat.target, self.inst) end, "Dodge",
					RunAway(self.inst, { fn = ShouldKite, tags = { "_combat", "_health" }, notags = { "INLIMBO" } }, KITING_DIST, STOP_KITING_DIST)),
					ChaseAndAttack(self.inst),
			}, .25)),
			
			-- Worker
			IfNode(function() 
				return self.inst.prefab == "dendrobium_shadow_lumber" end, "Keep Chopping",
				DoAction(self.inst, function() 
					return FindObjectToWorkAction(self.inst, ACTIONS.CHOP) 
			end)),
			IfNode(function() 
				return self.inst.prefab == "dendrobium_shadow_miner" end, "Keep Mining",
				DoAction(self.inst, function() 
					return FindObjectToWorkAction(self.inst, ACTIONS.MINE) 
			end)),
			IfNode(function() 
				return self.inst.prefab == "dendrobium_shadow_digger" end, "Keep Digging",
				DoAction(self.inst, function() 
					return FindObjectToWorkAction(self.inst, ACTIONS.DIG, DIG_TAGS) 
			end)),
			
		}, .25)),

		-- Follow
        Follow(self.inst, GetLeader, MIN_FOLLOW_DIST, TARGET_FOLLOW_DIST, MAX_FOLLOW_DIST),
        IfNode(function() return GetLeader(self.inst) end, "has leader",            
            FaceEntity(self.inst, GetFaceTargetFn, KeepFaceTargetFn)),
    }, .25)
    self.bt = BT(self.inst, root)    
end

return EntsBrain