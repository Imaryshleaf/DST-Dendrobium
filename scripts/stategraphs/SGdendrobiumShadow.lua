require("stategraphs/commonstates")

local SHADOWWAXWELL_PROTECTOR_ACTIVE_LEADER_RANGE = 10
local SHADOWWAXWELL_PROTECTOR_ATTACK_PERIOD_INACTIVE_LEADER = 1
local SHADOWWAXWELL_PROTECTOR_ATTACK_PERIOD = .5
local SHADOWWAXWELL_SHADOWSTRIKE_COOLDOWN_INACTIVE_LEADER = 16
local SHADOWWAXWELL_SHADOWSTRIKE_COOLDOWN = 4
local SHADOWWAXWELL_PROTECTOR_SHADOW_LEADER_RADIUS = 16
local SHADOWWAXWELL_PROTECTOR_DAMAGE = 40
local SHADOWWAXWELL_PROTECTOR_DAMAGE_BONUS_PER_LEVEL = 4
local SHADOWWAXWELL_SHADOWSTRIKE_DAMAGE_MULT = 1.5

local function ToggleOffCharacterCollisions(inst)
    --inst.Physics:ClearCollisionMask()
    --inst.Physics:CollidesWith(COLLISION.GROUND)
end

local function ToggleOnCharacterCollisions(inst)
    --inst.Physics:ClearCollisionMask()
    --inst.Physics:CollidesWith(COLLISION.WORLD)
    --inst.Physics:CollidesWith(COLLISION.OBSTACLES)
    --inst.Physics:CollidesWith(COLLISION.SMALLOBSTACLES)
    --inst.Physics:CollidesWith(COLLISION.CHARACTERS)
    --inst.Physics:CollidesWith(COLLISION.GIANTS)
end

local function DetachFX(fx)
	fx.Transform:SetPosition(fx.Transform:GetWorldPosition())
	fx.entity:SetParent(nil)
end

local function DoDespawnFX(inst)
	local x, y, z = inst.Transform:GetWorldPosition()
	local fx1 = SpawnPrefab("statue_transition")
	local fx2 = SpawnPrefab("shadow_glob_fx")
	fx2.AnimState:SetScale(math.random() < .5 and -1.3 or 1.3, 1.3, 1.3)
	local platform = inst:GetCurrentPlatform()
	if platform ~= nil then
		fx1.entity:SetParent(platform.entity)
		fx2.entity:SetParent(platform.entity)
		fx1:ListenForEvent("onremove", function() DetachFX(fx1) end, platform)
		x, y, z = platform.entity:WorldToLocalSpace(x, y, z)
	end
	fx1.Transform:SetPosition(x, y, z)
	fx2.Transform:SetPosition(x, y, z)
end

local function TrySplashFX(inst, size)
	local x, y, z = inst.Transform:GetWorldPosition()
	if TheWorld.Map:IsOceanAtPoint(x, 0, z) then
		SpawnPrefab("ocean_splash_"..(size or "med")..tostring(math.random(2))).Transform:SetPosition(x, 0, z)
		return true
	end
	if not TheWorld.Map:IsOceanAtPoint(x, 0, z) then
		SpawnPrefab("shadow_glob_fx").Transform:SetPosition(x, 0, z)
		return true
	end
end

local function TryStepSplash(inst)
	local t = GetTime()
	if (inst.sg.mem.laststepsplash == nil or inst.sg.mem.laststepsplash + .1 < t) and TrySplashFX(inst) then
		inst.sg.mem.laststepsplash = t
	end
end

local function NotBlocked(pt)
	return not TheWorld.Map:IsGroundTargetBlocked(pt)
end

local function IsNearTarget(inst, target, range)
	return inst:IsNear(target, range + target:GetPhysicsRadius(0))
end

local function IsLeaderNear(inst, leader, target, range)
	--leader is in range of us or our target
	return inst:IsNear(leader, range) or (target ~= nil and IsNearTarget(leader, target, range))
end

local COMBAT_TIMEOUT = 6
local function CheckCombatLeader(inst, target)
	local score = 0
	local leader = inst.components.follower:GetLeader()
	if leader ~= nil then
		local isnear = IsLeaderNear(inst, leader, target, SHADOWWAXWELL_PROTECTOR_ACTIVE_LEADER_RANGE)
		local leader_combat = leader.components.combat
		if leader_combat ~= nil then
			local t = GetTime()
			if math.max(leader_combat.laststartattacktime or 0, leader_combat.lastdoattacktime or 0) + COMBAT_TIMEOUT > t then
				if target ~= nil and leader_combat:IsRecentTarget(target) then
					--leader attacking same target as me, ignore range
					score = 4
				elseif isnear then
					--leader is near me, but fighting something else
					score = 3.5
				else
					local leader_target = Ents[leader_combat.lasttargetGUID]
					if leader_target ~= nil and leader_target:IsValid() and inst:IsNear(leader_target, SHADOWWAXWELL_PROTECTOR_ACTIVE_LEADER_RANGE) then
						--i'm near my leader's target, so that counts too
						score = 3.5
					end
				end
			end
			if score == 0 and leader_combat:GetLastAttackedTime() + COMBAT_TIMEOUT > t then
				if target ~= nil and leader_combat.lastattacker == target then
					--leader got hit by my target, ignore range
					score = 3
				elseif isnear then
					--leader is near me, but got hit by something else
					score = 2.5
				else
					local attacker = leader_combat.lastattacker
					if attacker ~= nil and attacker:IsValid() and IsNearTarget(inst, attacker, SHADOWWAXWELL_PROTECTOR_ACTIVE_LEADER_RANGE) then
						--i'm near my leader's attacker, so that counts too
						score = 2.5
					end
				end
			end
		end
		if score == 0 and isnear then
			score = 1.5
		end
	end

	--0 is most inactive, 4 is most active, convert score to %
	score = score / 4

	--Scale attack speed
	inst.components.combat:SetAttackPeriod(Lerp(SHADOWWAXWELL_PROTECTOR_ATTACK_PERIOD_INACTIVE_LEADER, SHADOWWAXWELL_PROTECTOR_ATTACK_PERIOD, score))

	--Scale shadowstrike cooldown
	local elapsed = inst.components.chronometer ~= nil and inst.components.chronometer:GetTimeElapsed("shadowstrike_cd") or nil
	if elapsed ~= nil then
		inst.components.chronometer:StopTimer("shadowstrike_cd")
		local cd = Lerp(SHADOWWAXWELL_SHADOWSTRIKE_COOLDOWN_INACTIVE_LEADER, SHADOWWAXWELL_SHADOWSTRIKE_COOLDOWN, score)
		if elapsed < cd then
			inst.components.chronometer:StartTimer("shadowstrike_cd", cd - elapsed, nil, cd)
		end
	end
end

local function CheckLeaderShadowLevel(inst, target)
	local level = 0
	local leader = inst.components.follower:GetLeader()
	if leader ~= nil and
		leader.components.inventory ~= nil and
		IsLeaderNear(inst, leader, target, SHADOWWAXWELL_PROTECTOR_SHADOW_LEADER_RADIUS)
		then
		for k, v in pairs(EQUIPSLOTS) do
			local equip = leader.components.inventory:GetEquippedItem(v)
			if equip ~= nil and equip.components.shadowlevel ~= nil then
				level = level + equip.components.shadowlevel:GetCurrentLevel()
			end
		end
	end

	--Scale damage
	inst.components.combat:SetDefaultDamage(SHADOWWAXWELL_PROTECTOR_DAMAGE + level * SHADOWWAXWELL_PROTECTOR_DAMAGE_BONUS_PER_LEVEL)
end

local actionhandlers =
{    
    ActionHandler(ACTIONS.CHOP, 
        function(inst)
            if not inst.sg:HasStateTag("prechop") then 
                if inst.sg:HasStateTag("chopping") then
                    return "chop"
                else
                    return "chop_start"
                end
            end 
        end),
    ActionHandler(ACTIONS.MINE, 
        function(inst) 
            if not inst.sg:HasStateTag("premine") then 
                if inst.sg:HasStateTag("mining") then
                    return "mine"
                else
                    return "mine_start"
                end
            end 
        end),
    ActionHandler(ACTIONS.DIG,
        function(inst)
            if not inst.sg:HasStateTag("predig") then
                return inst.sg:HasStateTag("digging")
                    and "dig"
                    or "dig_start"
            end
        end),
		ActionHandler(ACTIONS.PICKUP, "pickupitem"),
		ActionHandler(ACTIONS.GIVE, "giveitem"),
}

local events = 
{
    CommonHandlers.OnLocomote(true, false),
    CommonHandlers.OnAttacked(),
    CommonHandlers.OnDeath(),
    --CommonHandlers.OnAttack(),
	-- This give me an error "Could not find anim [disappear] in bank [lavaarena_shadow_lunge]"
	-- EventHandler("attacked", function(inst, data)
		-- if not (inst.components.health:IsDead() or inst.components.health:IsInvincible()) then
			-- inst.sg:GoToState("disappear", data ~= nil and data.attacker or nil)
		-- end
	-- end),
	EventHandler("doattack", function(inst, data)
		if inst.components.health ~= nil and not inst.components.health:IsDead() and not inst.sg:HasStateTag("busy") then
			if inst.components.combat.attackrange == 5 then
				inst.sg:GoToState("lunge_pre", data ~= nil and data.target or nil)
			else
				inst.sg:GoToState("attack", data ~= nil and data.target or nil)
			end
		end
	end),
}

local states =
{
    State{
        name = "idle",
        tags = {"idle", "canrotate"},
        onenter = function(inst, pushanim)    
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("idle_loop", true)
			if inst.prefab == "dendrobium_shadow_duelist" then
				inst.equipfn(inst, inst.items["SWORD"])
				if inst.components.chronometer ~= nil and not inst.components.chronometer:TimerExists("shadowstrike_cd") then
					inst.components.combat:SetRange(5)
				end
			end
        end,
    },

    State{
        name = "run_start",
        tags = {"moving", "running", "canrotate"},
        
        onenter = function(inst)
			inst.components.locomotor:RunForward()
            inst.AnimState:PlayAnimation("run_pre")
            inst.sg.mem.foosteps = 0
        end,

        events=
        {   
            EventHandler("animover", function(inst)
                if inst.AnimState:AnimDone() then
                    inst.sg:GoToState("run")
                end
			end),        
        },
        
        timeline=
        {        
			TimeEvent(1 * FRAMES, TryStepSplash),
			TimeEvent(3 * FRAMES, function(inst)
                inst.SoundEmitter:PlaySound("dontstarve/maxwell/shadowmax_step")
            end),
        },        
        
    },

    State{
        name = "run",
        tags = {"moving", "running", "canrotate"},
        
        onenter = function(inst) 
            inst.components.locomotor:RunForward()
            if not inst.AnimState:IsCurrentAnimation("run_loop") then
                inst.AnimState:PlayAnimation("run_loop", true)
            end
            inst.sg:SetTimeout(inst.AnimState:GetCurrentAnimationLength())
        end,

        timeline=
        {
			TimeEvent(5 * FRAMES, TryStepSplash),
            TimeEvent(7 * FRAMES, function(inst)
				inst.sg.mem.laststepsplash = GetTime()
				inst.sg.mem.foosteps = inst.sg.mem.foosteps + 1
                inst.SoundEmitter:PlaySound("dontstarve/maxwell/shadowmax_step")
            end),
			TimeEvent(13 * FRAMES, TryStepSplash),
            TimeEvent(15 * FRAMES, function(inst)
				inst.sg.mem.laststepsplash = GetTime()
				inst.sg.mem.foosteps = inst.sg.mem.foosteps + 1
                inst.SoundEmitter:PlaySound("dontstarve/maxwell/shadowmax_step")
            end),
        },
		
        ontimeout = function(inst)
			inst.sg.statemem.running = true
            inst.sg:GoToState("run")
        end,
		
		onexit = function(inst)
			if not inst.sg.statemem.running then
				TryStepSplash(inst)
			end
		end,
    },
    
    State{
    
        name = "run_stop",
        tags = {"canrotate", "idle"},
        
        onenter = function(inst) 
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("run_pst")
        end,
        
        events=
        {   
            EventHandler("animover", function(inst)
                if inst.AnimState:AnimDone() then
                    inst.sg:GoToState("idle")
                end
            end),        
        },
        
    },

    State{
        name = "attack",
        tags = {"attack", "notalking", "abouttoattack", "busy"},
        
        onenter = function(inst)
            inst.equipfn(inst, inst.items["SWORD"])        
            inst.sg.statemem.target = inst.components.combat.target
            inst.components.combat:StartAttack()
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("atk")
            inst.SoundEmitter:PlaySound("dontstarve/wilson/attack_nightsword")
            
            if inst.components.combat.target then
                if inst.components.combat.target and inst.components.combat.target:IsValid() then
                    inst:FacePoint(Point(inst.components.combat.target.Transform:GetWorldPosition()))
                end
            end
            
        end,
        
        timeline=
        {
            TimeEvent(8*FRAMES, function(inst) inst.components.combat:DoAttack(inst.sg.statemem.target) inst.sg:RemoveStateTag("abouttoattack") end),
            TimeEvent(12*FRAMES, function(inst) 
                inst.sg:RemoveStateTag("busy")
            end),               
            TimeEvent(13*FRAMES, function(inst)
                if not inst.sg.statemem.slow then
                    inst.sg:RemoveStateTag("attack")
                end
            end),
            TimeEvent(24*FRAMES, function(inst)
                if inst.sg.statemem.slow then
                    inst.sg:RemoveStateTag("attack")
                end
            end),           
        },
        
        events=
        {
            EventHandler("animover", function(inst)
                inst.sg:GoToState("idle")
            end ),
        },
    },  

    State{
        name = "death",
        tags = {"busy"},
        
        onenter = function(inst)
            inst.Physics:Stop()
            inst.AnimState:Hide("swap_arm_carry")
            inst.AnimState:PlayAnimation("death")
        end,

        events =
        {
            EventHandler("animover", function(inst)
                if inst.AnimState:AnimDone() then
					inst.SoundEmitter:PlaySound("dontstarve/maxwell/shadowmax_despawn")
					DoDespawnFX(inst)
					TrySplashFX(inst)
                    inst:Remove()
                end
            end ),
        },
    },
   
    State{
        name = "hit",
        tags = { "busy", "hit" },
        
        onenter = function(inst)
            inst.Physics:Stop()
            inst:ClearBufferedAction()
            inst.AnimState:PlayAnimation("hit")
        end,
        
        events=
        {
            EventHandler("animover", function(inst)
                local max_tries = 0 -- Taken from SGshadowcreature
                for k = 0, max_tries do
                    local x, y, z = inst.Transform:GetWorldPosition()
                    local offset = 7
					x = x + math.random(2 * offset) - offset
					z = z + math.random(2 * offset) - offset
					if TheWorld.Map:IsPassableAtPoint(x, y, z) then
						inst.Physics:Teleport(x, y, z)
						break
					end
                end
				SpawnPrefab("statue_transition_2").Transform:SetPosition(inst:GetPosition():Get())
                if inst.AnimState:AnimDone() then
                    inst.sg:GoToState("idle")
                end
            end),
        }, 
        timeline =
        {
            TimeEvent(3*FRAMES, function(inst)
                inst.sg:RemoveStateTag("busy")
            end),
        },               
    },

    State{
        name = "stunned",
        tags = {"busy", "canrotate"},

        onenter = function(inst)
            inst:ClearBufferedAction()
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("idle_sanity_pre")
            inst.AnimState:PushAnimation("idle_sanity_loop", true)
            inst.sg:SetTimeout(5)
        end,

        ontimeout = function(inst)
            inst.sg:GoToState("idle")
        end,
    },

	State{ 
		name = "chop_start",
        tags = {"prechop", "chopping", "working"},
        onenter = function(inst)
            inst.equipfn(inst, inst.items["AXE"])
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("chop_pre")

        end,
        
        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("chop") end),
        },
    },
    
    State{
        name = "chop",
        tags = {"prechop", "chopping", "working"},
        onenter = function(inst)
            inst.AnimState:PlayAnimation("chop_loop")        
        end,

        timeline=
        {
            TimeEvent(5*FRAMES, function(inst) 
                    inst:PerformBufferedAction() 
            end),

            TimeEvent(9*FRAMES, function(inst)
                    inst.sg:RemoveStateTag("prechop")
            end),

            TimeEvent(16*FRAMES, function(inst) 
                inst.sg:RemoveStateTag("chopping")
            end),
        },
        
        events=
        {
            EventHandler("animover", function(inst) 
                inst.sg:GoToState("idle")
            end ),            
        },        
    },

    State{ 
        name = "mine_start",
        tags = {"premine", "working"},
        onenter = function(inst)
            inst.equipfn(inst, inst.items["PICKAXE"])
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("pickaxe_pre")
        end,
        
        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("mine") end),
        },
    },
    
    State{
        name = "mine",
        tags = {"premine", "mining", "working"},
        onenter = function(inst)
            inst.AnimState:PlayAnimation("pickaxe_loop")
        end,

        timeline=
        {
            TimeEvent(10*FRAMES, function(inst) 
                inst:PerformBufferedAction() 
                inst.sg:RemoveStateTag("premine") 
                inst.SoundEmitter:PlaySound("dontstarve/wilson/use_pick_rock")
            end),
        },
        
        events=
        {
            EventHandler("animover", function(inst) 
                inst.AnimState:PlayAnimation("pickaxe_pst") 
                inst.sg:GoToState("idle", true)
            end ),            
        },        
    },
	
    State{
        name = "dig_start",
        tags = {"predig", "working"},

        onenter = function(inst)
			inst.equipfn(inst, inst.items["SHOVEL"])
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("shovel_pre")
        end,

        events =
        {
            EventHandler("animover", function(inst)
                if inst.AnimState:AnimDone() then
                    inst.sg:GoToState("dig")
                end
            end),
        },
    },

    State{
        name = "dig",
        tags = {"predig", "digging", "working"},

        onenter = function(inst)
            inst.AnimState:PlayAnimation("shovel_loop")
        end,

        timeline =
        {
            TimeEvent(15 * FRAMES, function(inst)
                inst:PerformBufferedAction()
                inst.SoundEmitter:PlaySound("dontstarve/wilson/dig")
            end),

            TimeEvent(35 * FRAMES, function(inst)
                inst.sg:RemoveStateTag("predig")
            end),
        },

        events =
        {
            EventHandler("animover", function(inst)
                if inst.AnimState:AnimDone() then
                    inst.AnimState:PlayAnimation("shovel_pst")
                    inst.sg:GoToState("idle", true)
                end
            end),
        },
    },

    State
    {
        name = "pickupitem",
        tags = { "doing", "busy" },

        onenter = function(inst, target)
            inst.components.locomotor:Stop()
            inst.AnimState:PlayAnimation("pickup")
            inst.AnimState:PushAnimation("pickup_pst", false)
            inst.sg.statemem.action = inst.bufferedaction
            inst.sg:SetTimeout(10 * FRAMES)
        end,

        timeline =
        {
            TimeEvent(4 * FRAMES, function(inst)
                inst.sg:RemoveStateTag("busy")
            end),
            TimeEvent(6 * FRAMES, function(inst)
			inst:PerformBufferedAction()
                if inst.sg.statemem.action ~= nil then
                    local target = inst.sg.statemem.action.target
                    if target.components.inventoryitem then
						if target then
							--if inst.components.inventory and inst.components.inventory:Has(target, 1)then
							if inst.components.container then
							--	inst.components.container:GiveItem(target)
								 --SpawnPrefab("sand_puff").Transform:SetPosition(target.Transform:GetWorldPosition())
							end
						end
                    end
                end
            end),
        },

        ontimeout = function(inst)
            inst.sg:GoToState("idle", true)
        end,
        onexit = function(inst)
            if inst.bufferedaction == inst.sg.statemem.action then
                inst:ClearBufferedAction()
            end
        end,
    },
    State{
        name = "giveitem",
        tags = { "giving" },

        onenter = function(inst)
            inst.components.locomotor:Stop()
            inst.AnimState:PlayAnimation("give")
            inst.AnimState:PushAnimation("give_pst", false)
        end,

        timeline =
        {
            TimeEvent(13 * FRAMES, function(inst)
                inst:PerformBufferedAction()
            end),
        },

        events =
        {
            EventHandler("animqueueover", function(inst)
                if inst.AnimState:AnimDone() then
                    inst.sg:GoToState("idle")
                end
            end),
        },
    },
	--------------------------- New ------------------------------------
	State{
		-- From waxwell rework (+Modified)
		name = "disappear",
		tags = { "busy", "noattack", "temp_invincible", "phasing" },
		
		onenter = function(inst, attacker)
			inst.components.locomotor:Stop()
			ToggleOffCharacterCollisions(inst)
			inst.AnimState:PlayAnimation("disappear")
			if attacker ~= nil and attacker:IsValid() then
				inst.sg.statemem.attackerpos = attacker:GetPosition()
			end
			TrySplashFX(inst, "small")
			SpawnPrefab("statue_transition_2").Transform:SetPosition(inst:GetPosition():Get())
		end,

		events =
		{
			EventHandler("animover", function(inst)
				if inst.AnimState:AnimDone() then
					local theta =
						inst.sg.statemem.attackerpos ~= nil and
						inst:GetAngleToPoint(inst.sg.statemem.attackerpos) or
						inst.Transform:GetRotation()

					theta = (theta + 165 + math.random() * 30) * DEGREES

					local pos = inst:GetPosition()
					pos.y = 0

					local offs =
						FindWalkableOffset(pos, theta, 4 + math.random(), 8, false, true, NotBlocked, true, true) or
						FindWalkableOffset(pos, theta, 2 + math.random(), 6, false, true, NotBlocked, true, true)

					if offs ~= nil then
						pos.x = pos.x + offs.x
						pos.z = pos.z + offs.z
					end
					inst.Physics:Teleport(pos:Get())
					if inst.sg.statemem.attackerpos ~= nil then
						inst:ForceFacePoint(inst.sg.statemem.attackerpos)
					end

					inst.sg.statemem.appearing = true
					inst.sg:GoToState("appear")
				end
			end),
		},

		onexit = function(inst)
			if not inst.sg.statemem.appearing then
				ToggleOnCharacterCollisions(inst)
			end
		end,
	},
	
	State{
		name = "appear",
		tags = { "busy", "noattack", "temp_invincible", "phasing"},

		onenter = function(inst)
			inst.components.locomotor:Stop()
			ToggleOffCharacterCollisions(inst)
			inst.AnimState:PlayAnimation("appear")
			SpawnPrefab("statue_transition_2").Transform:SetPosition(inst:GetPosition():Get())
		end,

		timeline =
		{
			TimeEvent(9 * FRAMES, function(inst)
				TrySplashFX(inst, "small")
			end),
			TimeEvent(11 * FRAMES, function(inst)
				inst.sg:RemoveStateTag("temp_invincible")
				inst.sg:RemoveStateTag("phasing")
			end),
			TimeEvent(13 * FRAMES, function(inst)
				inst.sg:RemoveStateTag("busy")
			end),
		},

		events =
		{
			EventHandler("animover", function(inst)
				if inst.AnimState:AnimDone() then
					inst.sg:GoToState("idle")
				end
			end),
		},

		onexit = function(inst)
			ToggleOnCharacterCollisions(inst)
		end,
	},

	State{
		-- From waxwell rework
		name = "lunge_pre",
		tags = { "attack", "busy" },

		onenter = function(inst, target)
			inst:StopBrain()
			inst.components.locomotor:Stop()
			inst.AnimState:SetBankAndPlayAnimation("lavaarena_shadow_lunge", "lunge_pre")
			inst.components.combat:StartAttack()
			
			if target == nil then
				target = inst.components.combat.target
			end
			
			if target ~= nil and target:IsValid() then
				inst.sg.statemem.target = target
				inst.sg.statemem.targetpos = target:GetPosition()
				inst:ForceFacePoint(inst.sg.statemem.targetpos:Get())
			else
				target = nil
			end
			CheckCombatLeader(inst, target)
		end,

		onupdate = function(inst)
			if inst.sg.statemem.target ~= nil then
				if inst.sg.statemem.target:IsValid() then
					inst.sg.statemem.targetpos = inst.sg.statemem.target:GetPosition()
				else
					inst.sg.statemem.target = nil
				end
			end
		end,

		events =
		{
			EventHandler("animover", function(inst)
				if inst.AnimState:AnimDone() then
					inst.sg.statemem.lunge = true
					inst.sg:GoToState("lunge_loop", { target = inst.sg.statemem.target, targetpos = inst.sg.statemem.targetpos })
				end
			end),
		},

		onexit = function(inst)
			if not inst.sg.statemem.lunge then
				inst.components.combat:CancelAttack()
				inst:RestartBrain()
			end
		end,
	},

	State{
		name = "lunge_loop",
		tags = { "attack", "busy", "noattack", "temp_invincible" },

		onenter = function(inst, data)
			inst.AnimState:PlayAnimation("lunge_loop")
			inst.SoundEmitter:PlaySound("dontstarve/wilson/attack_nightsword")
			inst.Physics:ClearCollidesWith(COLLISION.GIANTS)
			ToggleOffCharacterCollisions(inst)
			TrySplashFX(inst)

			if inst.components.chronometer ~= nil then
				inst.components.chronometer:StopTimer("shadowstrike_cd")
				inst.components.chronometer:StartTimer("shadowstrike_cd", SHADOWWAXWELL_SHADOWSTRIKE_COOLDOWN)
			end

			if data ~= nil then
				if data.target ~= nil and data.target:IsValid() then
					inst.sg.statemem.target = data.target
					inst:ForceFacePoint(data.target.Transform:GetWorldPosition())
				elseif data.targetpos ~= nil then
					inst:ForceFacePoint(data.targetpos)
				end
			end
			inst.Physics:SetMotorVelOverride(35, 0, 0)

			inst.sg:SetTimeout(8 * FRAMES)
		end,

		onupdate = function(inst)
			if inst.sg.statemem.attackdone then
				return
			end
			local target = inst.sg.statemem.target
			if target == nil or not target:IsValid() then
				if inst.sg.statemem.animdone then
					inst.sg.statemem.lunge = true
					inst.sg:GoToState("lunge_pst")
					return
				end
				inst.sg.statemem.target = nil
			elseif inst:IsNear(target, 1) then
				local fx = SpawnPrefab(math.random() < .5 and "shadowstrike_slash_fx" or "shadowstrike_slash2_fx")
				local x, y, z = target.Transform:GetWorldPosition()
				fx.Transform:SetPosition(x, y + 1.5, z)
				fx.Transform:SetRotation(inst.Transform:GetRotation())

				CheckLeaderShadowLevel(inst, target)
				inst.components.combat.externaldamagemultipliers:SetModifier(inst, SHADOWWAXWELL_SHADOWSTRIKE_DAMAGE_MULT, "shadowstrike")
				inst.components.combat:DoAttack(target)

				if inst.sg.statemem.animdone then
					inst.sg.statemem.lunge = true
					inst.sg:GoToState("lunge_pst", target)
					return
				end
				inst.sg.statemem.attackdone = true
			end
		end,

		events =
		{
			EventHandler("animover", function(inst)
				if inst.AnimState:AnimDone() then
					if inst.sg.statemem.attackdone or inst.sg.statemem.target == nil then
						inst.sg.statemem.lunge = true
						inst.sg:GoToState("lunge_pst", inst.sg.statemem.target)
						return
					end
					inst.sg.statemem.animdone = true
				end
			end),
		},

		ontimeout = function(inst)
			inst.sg.statemem.lunge = true
			inst.sg:GoToState("lunge_pst")
		end,

		onexit = function(inst)
			inst.components.combat.externaldamagemultipliers:RemoveModifier(inst, "shadowstrike")
			inst.components.combat:SetRange(2)
			if not inst.sg.statemem.lunge then
				inst:RestartBrain()
				inst.AnimState:SetBank("wilson")
				inst.Physics:CollidesWith(COLLISION.GIANTS)
				ToggleOnCharacterCollisions(inst)
			end
		end,
	},

	State{
		name = "lunge_pst",
		tags = { "busy", "noattack", "temp_invincible", "phasing" },

		onenter = function(inst, target)
			inst.AnimState:PlayAnimation("lunge_pst")
			inst.Physics:SetMotorVelOverride(12, 0, 0)
			inst.sg.statemem.target = target
		end,

		onupdate = function(inst)
			inst.Physics:SetMotorVelOverride(inst.Physics:GetMotorVel() * .8, 0, 0)
		end,

		events =
		{
			EventHandler("animover", function(inst)
				if inst.AnimState:AnimDone() then
					local target = inst.sg.statemem.target
					local pos = inst:GetPosition()
					pos.y = 0
					local moved = false
					if target ~= nil then
						if target:IsValid() then
							local targetpos = target:GetPosition()
							local dx, dz = targetpos.x - pos.x, targetpos.z - pos.z
							local radius = math.sqrt(dx * dx + dz * dz)
							local theta = math.atan2(dz, -dx)
							local offs = FindWalkableOffset(targetpos, theta, radius + 3 + math.random(), 8, false, true, NotBlocked, true, true)
							if offs ~= nil then
								pos.x = targetpos.x + offs.x
								pos.z = targetpos.z + offs.z
								inst.Physics:Teleport(pos:Get())
								moved = true
							end
						else
							target = nil
						end
					end
					if not moved and not TheWorld.Map:IsPassableAtPoint(pos.x, 0, pos.z, true) then
						pos = FindNearbyLand(pos, 1) or FindNearbyLand(pos, 2)
						if pos ~= nil then
							inst.Physics:Teleport(pos.x, 0, pos.z)
						end
					end

					if target ~= nil then
						inst:ForceFacePoint(target.Transform:GetWorldPosition())
					end

					inst.sg.statemem.appearing = true
					inst.sg:GoToState("appear")
				end
			end),
		},

		onexit = function(inst)
			inst:RestartBrain()
			inst.AnimState:SetBank("wilson")
			inst.Physics:CollidesWith(COLLISION.GIANTS)
			if not inst.sg.statemem.appearing then
				ToggleOnCharacterCollisions(inst)
			end
		end,
	},

	State{
        name = "despawnjumpin",
        tags = { "doing", "busy", "canrotate" },

        onenter = function(inst, data)
            inst.components.locomotor:Stop()
            ToggleOffCharacterCollisions(inst)
			inst.AnimState:PlayAnimation("jump")
			inst.sg:SetTimeout(11 * FRAMES)
		end,
        timeline =
        {
			TimeEvent(FRAMES, function(inst)
				inst.SoundEmitter:PlaySound("dontstarve/creatures/together/toad_stool/infection_post", nil, .7)
				inst.SoundEmitter:PlaySound("dontstarve/characters/wortox/soul/spawn", nil, .5)
			end),
        },
        events =
        {
            EventHandler("animover", function(inst)
                if inst.AnimState:AnimDone() then
					local x, y, z = inst.Transform:GetWorldPosition()
					SpawnPrefab("leaper_portal_jumpin_fx").Transform:SetPosition(x, y, z)
					inst:Remove()
                end
            end),
        },
    },
	
	State{
        name = "spawnjumpout",
        tags = { "doing", "no_stun", "busy", "noattack", "nointerrupt"},
        onenter = function(inst, data)
            inst.components.locomotor:Stop()
            ToggleOffCharacterCollisions(inst)
			inst.AnimState:PlayAnimation("wortox_portal_jumpout")
			SpawnPrefab("leaper_portal_jumpout_fx").Transform:SetPosition(inst:GetPosition():Get())
			inst.sg:SetTimeout(14 * FRAMES)
		end,
        timeline =
        {
			TimeEvent(FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/characters/wortox/soul/hop_out") end),
			TimeEvent(7 * FRAMES, function(inst)
				inst.sg:RemoveStateTag("noattack")
				inst.SoundEmitter:PlaySound("dontstarve/movement/bodyfall_dirt")
			end),
			TimeEvent(8 * FRAMES, function(inst)
				ToggleOnCharacterCollisions(inst)
			end),
        },
        events =
        {
            EventHandler("animover", function(inst)
                if inst.AnimState:AnimDone() then
					inst.sg:GoToState("idle")
                end
            end),
        },
    },
}

return StateGraph("dendrobiumShadow", states, events, "idle", actionhandlers)