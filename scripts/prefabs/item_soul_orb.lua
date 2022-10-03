local assets = { 		
	Asset("ANIM", "anim/fx_soul_orb.zip"),
    Asset("ANIM", "anim/soul_orb.zip"),
    -- Inventory item
	Asset("ATLAS", "images/inventoryimages/soul_orb.xml"),
	Asset("IMAGE", "images/inventoryimages/soul_orb.tex"),
}

local prefabs = {
    "soul_orb_in",
    "soul_orb",
    "soul_orb_fx",
}

-- Soul orb fx
local TINT = { r = 154 / 255, g = 23 / 255, b = 19 / 255 }

local function OnUpdateTargetTint(inst)--, dt)
    if inst._tinttarget:IsValid() then
        local curframe = inst.AnimState:GetCurrentAnimationTime() / FRAMES
        if curframe < 10 then
            local k = curframe / 10 * .5
            if inst._tinttarget.components.colouradder ~= nil then
                inst._tinttarget.components.colouradder:PushColour(inst, TINT.r * k, TINT.g * k, TINT.b * k, 0)
            end
        elseif curframe < 40 then
            local k = (curframe - 10) / 30
            k = (1 - k * k) * .5
            if inst._tinttarget.components.colouradder ~= nil then
                inst._tinttarget.components.colouradder:PushColour(inst, TINT.r * k, TINT.g * k, TINT.b * k, 0)
            end
        else
            inst.components.updatelooper:RemoveOnUpdateFn(OnUpdateTargetTint)
            if inst._tinttarget.components.colouradder ~= nil then
                inst._tinttarget.components.colouradder:PopColour(inst)
            end
        end
    else
        inst.components.updatelooper:RemoveOnUpdateFn(OnUpdateTargetTint)
    end
end

local function Setup(inst, target)
    if inst.components.updatelooper == nil then
        inst:AddComponent("updatelooper")
        inst.components.updatelooper:AddOnUpdateFn(OnUpdateTargetTint)
        inst._tinttarget = target
    end
    if target.SoundEmitter ~= nil then
        target.SoundEmitter:PlaySound("dontstarve/characters/wortox/soul/heal")
    end
end

local function fn()
	local inst = CreateEntity()
	
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
	inst.AnimState:SetBank("wortox_soul_heal_fx")
	inst.AnimState:SetBuild("soul_orb_fx")
	inst.AnimState:PlayAnimation("heal")
    inst.AnimState:SetScale(.8, .8)
    inst.AnimState:SetFinalOffset(-1)
    inst.AnimState:SetScale(1.5, 1.5)
    inst.AnimState:SetDeltaTimeMultiplier(2)

	inst.entity:SetPristine()
	
	if not TheWorld.ismastersim then
        return inst
    end

    inst:AddTag("FX")
	inst:AddTag("soulorbfx")

    if math.random() < .5 then
        inst.AnimState:SetScale(-1.5, 1.5)
    end

    inst:ListenForEvent("animover", inst.Remove)
    inst.persists = false
    inst.Setup = Setup

    return inst
end


-- Soul orb in Fx
local INSCALE = .8
local TINT = { r = 154 / 255, g = 23 / 255, b = 19 / 255 }

local function PushColour(inst, addval, multval)
    if inst.components.highlight == nil then
        inst.AnimState:SetHighlightColour(TINT.r * addval, TINT.g * addval, TINT.b * addval, 0)
        inst.AnimState:OverrideMultColour(multval, multval, multval, 1)
    else
        inst.AnimState:OverrideMultColour()
    end
end

local function PopColour(inst)
    if inst.components.highlight == nil then
        inst.AnimState:SetHighlightColour()
    end
    inst.AnimState:OverrideMultColour()
end

local function OnUpdateTargetTint(inst)--, dt)
    if inst._tinttarget:IsValid() then
        local curframe = inst.AnimState:GetCurrentAnimationTime() / FRAMES
        if curframe < 10 then
            local k = curframe / 10
            k = k * k
            PushColour(inst._tinttarget, (1 - k) * .7, k * .7 + .3)
        else
            inst.components.updatelooper:RemoveOnUpdateFn(OnUpdateTargetTint)
            inst.OnRemoveEntity = nil
            PopColour(inst._tinttarget)
        end
    else
        inst.components.updatelooper:RemoveOnUpdateFn(OnUpdateTargetTint)
        inst.OnRemoveEntity = nil
    end
end

local function OnRemoveEntity(inst)
    if inst._tinttarget:IsValid() then
        PopColour(inst._tinttarget)
    end
end

local function OnTargetDirty(inst)
    if inst._target:value() ~= nil and inst._tinttarget == nil then
        if inst.components.updatelooper == nil then
            inst:AddComponent("updatelooper")
        end
        inst.components.updatelooper:AddOnUpdateFn(OnUpdateTargetTint)
        inst._tinttarget = inst._target:value()
        inst.OnRemoveEntity = OnRemoveEntity
    end
end

local function Setup(inst, target)
    inst._target:set(target)
    OnTargetDirty(inst)
    if target.SoundEmitter ~= nil then
        target.SoundEmitter:PlaySound("dontstarve/characters/wortox/soul/spawn", nil, .5)
    end
end

local function Infn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    inst.AnimState:SetBank("wortox_soul_ball")
    inst.AnimState:SetBuild("soul_orb")
    inst.AnimState:PlayAnimation("idle_pst")
    inst.AnimState:SetTime(6 * FRAMES)
    inst.AnimState:SetScale(INSCALE, INSCALE)
    inst.AnimState:SetFinalOffset(-1)

    inst:AddTag("FX")

    inst._target = net_entity(inst.GUID, "soul_orb_in._target", "targetdirty")

    inst.entity:SetPristine()
	inst:ListenForEvent("targetdirty", OnTargetDirty)
    
	if not TheWorld.ismastersim then
        return inst
    end

    inst:ListenForEvent("animover", inst.Remove)
    inst.persists = false
    inst.Setup = Setup

    return inst
end


-- Soul orb portal Fx
local function OnAnimOver(inst)
    inst:DoTaskInTime(2 * FRAMES, inst.Remove)
end

local function MakeFX(name, anim)
    local function fn()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddNetwork()

        inst.AnimState:SetBank("wilson")
        inst.AnimState:SetBuild("leaper_portal")
        inst.AnimState:PlayAnimation(anim)
        inst.AnimState:SetFinalOffset(-1)

        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end

        inst:ListenForEvent("animover", OnAnimOver)
        inst.persists = false

        return inst
    end

    return Prefab(name, fn, assets)
end


-- Soul orb spawn Fx
local SPAWNSCALE = .8
local SPEED = 10

local function CreateTail()
    local inst = CreateEntity()

    inst:AddTag("FX")
    inst:AddTag("NOCLICK")
    --[[Non-networked entity]]
    inst.entity:SetCanSleep(false)
    inst.persists = false

    inst.entity:AddTransform()
    inst.entity:AddAnimState()

    MakeInventoryPhysics(inst)
    inst.Physics:ClearCollisionMask()

    inst.AnimState:SetBank("wortox_soul_ball")
    inst.AnimState:SetBuild("soul_orb")
    inst.AnimState:PlayAnimation("disappear")
    inst.AnimState:SetScale(SPAWNSCALE, SPAWNSCALE)
    inst.AnimState:SetFinalOffset(-1)

    inst:ListenForEvent("animover", inst.Remove)

    return inst
end

local function OnUpdateProjectileTail(inst)--, dt)
    local x, y, z = inst.Transform:GetWorldPosition()
    for tail, _ in pairs(inst._tails) do
        tail:ForceFacePoint(x, y, z)
    end
    if inst.entity:IsVisible() then
        local tail = CreateTail()
        local rot = inst.Transform:GetRotation()
        tail.Transform:SetRotation(rot)
        rot = rot * DEGREES
        local offsangle = math.random() * 2 * PI
        local offsradius = (math.random() * .2 + .2) * SPAWNSCALE
        local hoffset = math.cos(offsangle) * offsradius
        local voffset = math.sin(offsangle) * offsradius
        tail.Transform:SetPosition(x + math.sin(rot) * hoffset, y + voffset, z + math.cos(rot) * hoffset)
        tail.Physics:SetMotorVel(SPEED * (.2 + math.random() * .3), 0, 0)
        inst._tails[tail] = true
        inst:ListenForEvent("onremove", function(tail) inst._tails[tail] = nil end, tail)
        tail:ListenForEvent("onremove", function(inst)
            tail.Transform:SetRotation(tail.Transform:GetRotation() + math.random() * 30 - 15)
        end, inst)
    end
end

local function OnHit(inst, attacker, target)
    if target ~= nil then
        local x, y, z = inst.Transform:GetWorldPosition()
        local fx = SpawnPrefab("soul_orb_in")
        fx.Transform:SetPosition(x, y, z)
        fx:Setup(target)
        --ignore .isvisible, as long as it's .isopen
        if target.components.inventory ~= nil and target.components.inventory.isopen then
            target.components.inventory:GiveItem(SpawnPrefab("soul_orb"), nil, target:GetPosition())
        else
            --reuse fx variable
            fx = SpawnPrefab("soul_orb")
            fx.Transform:SetPosition(x, y, z)
            fx.components.inventoryitem:OnDropped(true)
        end
    end
    inst:Remove()
end

local function OnHasTailDirty(inst)
    if inst._hastail:value() and inst._tails == nil then
        inst._tails = {}
        if inst.components.updatelooper == nil then
            inst:AddComponent("updatelooper")
        end
        inst.components.updatelooper:AddOnUpdateFn(OnUpdateProjectileTail)
    end
end

local function OnThrownTimeout(inst)
    inst._timeouttask = nil
    inst.components.projectile:Miss(inst.components.projectile.target)
end

local function OnThrown(inst)
    if inst._timeouttask ~= nil then
        inst._timeouttask:Cancel()
    end
    inst._timeouttask = inst:DoTaskInTime(6, OnThrownTimeout)
    if inst._seektask ~= nil then
        inst._seektask:Cancel()
        inst._seektask = nil
    end
    inst.AnimState:Hide("blob")
    inst._hastail:set(true)
    OnHasTailDirty(inst)
end

local function SeekSoulStealer(inst)
    local x, y, z = inst.Transform:GetWorldPosition()
    local closestPlayer = nil
    local rangesq = TUNING.WORTOX_SOULSTEALER_RANGE * TUNING.WORTOX_SOULSTEALER_RANGE
    for i, v in ipairs(AllPlayers) do
        if v:HasTag("soulorbcollector") and -- Change tag here!
            not (v.components.health:IsDead() or v:HasTag("playerghost")) and
            not (v.sg ~= nil and (v.sg:HasStateTag("nomorph") or v.sg:HasStateTag("silentmorph"))) and
            v.entity:IsVisible() then
            local distsq = v:GetDistanceSqToPoint(x, y, z)
            if distsq < rangesq then
                rangesq = distsq
                closestPlayer = v
            end
        end
    end
    if closestPlayer ~= nil then
        inst.components.projectile:Throw(inst, closestPlayer, inst)
    end
end

local function EndBlockSoulHealFX(v)
    v.blocksoulhealfxtask = nil
end

local function DoHeal(inst)
    local targets = {}
    local x, y, z = inst.Transform:GetWorldPosition()
    for i, v in ipairs(AllPlayers) do
        if not (v.components.health:IsDead() or v:HasTag("playerghost")) and
            v.entity:IsVisible() and
            v:GetDistanceSqToPoint(x, y, z) < TUNING.WORTOX_SOULHEAL_RANGE * TUNING.WORTOX_SOULHEAL_RANGE then
            table.insert(targets, v)
        end
    end
    if #targets > 0 then
        local amt = TUNING.HEALING_MED - math.min(8, #targets) + 1
        for i, v in ipairs(targets) do
            --always heal, but don't stack visual fx
            v.components.health:DoDelta(amt, nil, inst.prefab)
            if v.blocksoulhealfxtask == nil then
                v.blocksoulhealfxtask = v:DoTaskInTime(.5, EndBlockSoulHealFX)
                local fx = SpawnPrefab("soul_orb_fx")
                fx.entity:AddFollower():FollowSymbol(v.GUID, v.components.combat.hiteffectsymbol, 0, -50, 0)
                fx:Setup(v)
            end
        end
    end
end

local function OnTimeout(inst)
    inst._timeouttask = nil
    if inst._seektask ~= nil then
        inst._seektask:Cancel()
        inst._seektask = nil
    end
    inst:ListenForEvent("animover", inst.Remove)
    inst.AnimState:PlayAnimation("idle_pst")
    inst.SoundEmitter:PlaySound("dontstarve/characters/wortox/soul/spawn", nil, .5)

    DoHeal(inst)
end

local TINT = { r = 154 / 255, g = 23 / 255, b = 19 / 255 }

local function PushColour(inst, addval, multval)
    if inst.components.highlight == nil then
        inst.AnimState:SetHighlightColour(TINT.r * addval, TINT.g * addval, TINT.b * addval, 0)
        inst.AnimState:OverrideMultColour(multval, multval, multval, 1)
    else
        inst.AnimState:OverrideMultColour()
    end
end

local function PopColour(inst)
    if inst.components.highlight == nil then
        inst.AnimState:SetHighlightColour()
    end
    inst.AnimState:OverrideMultColour()
end

local function OnUpdateTargetTint(inst)--, dt)
    if inst._tinttarget:IsValid() then
        local curframe = inst.AnimState:GetCurrentAnimationTime() / FRAMES
        if curframe < 15 then
            local k = curframe / 15
            k = k * k
            PushColour(inst._tinttarget, 1 - k, k)
        else
            inst.components.updatelooper:RemoveOnUpdateFn(OnUpdateTargetTint)
            inst.OnRemoveEntity = nil
            PopColour(inst._tinttarget)
        end
    else
        inst.components.updatelooper:RemoveOnUpdateFn(OnUpdateTargetTint)
        inst.OnRemoveEntity = nil
    end
end

local function OnRemoveEntity(inst)
    if inst._tinttarget:IsValid() then
        PopColour(inst._tinttarget)
    end
end

local function OnTargetDirty(inst)
    if inst._target:value() ~= nil and inst._tinttarget == nil then
        if inst.components.updatelooper == nil then
            inst:AddComponent("updatelooper")
        end
        inst.components.updatelooper:AddOnUpdateFn(OnUpdateTargetTint)
        inst._tinttarget = inst._target:value()
        inst.OnRemoveEntity = OnRemoveEntity
    end
end

local function Setup(inst, target)
    inst.SoundEmitter:PlaySound("dontstarve/characters/wortox/soul/spawn", nil, .5)
    inst._target:set(target)
    OnTargetDirty(inst)
end

local function Spawnfn()
	local inst = CreateEntity()
	
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
    MakeInventoryPhysics(inst)
    RemovePhysicsColliders(inst)
	
	inst.AnimState:SetBank("wortox_soul_ball")
	inst.AnimState:SetBuild("soul_orb")
    inst.AnimState:PlayAnimation("idle_pre")
    inst.AnimState:SetScale(SPAWNSCALE, SPAWNSCALE)
    inst.AnimState:SetFinalOffset(-1)
	inst.entity:SetPristine()

    inst:ListenForEvent("targetdirty", OnTargetDirty)
    inst:ListenForEvent("hastaildirty", OnHasTailDirty)
	
	if not TheWorld.ismastersim then
        return inst
    end

    inst:AddTag("FX")
	inst:AddTag("weapon")
    inst:AddTag("projectile")
	inst:AddTag("soulorbfx")
	
    inst._target = net_entity(inst.GUID, "soul_orb._target", "targetdirty")
    inst._hastail = net_bool(inst.GUID, "soul_orb._hastail", "hastaildirty")

	inst.AnimState:PushAnimation("idle_loop", true)

    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(0)

    inst:AddComponent("projectile")
    inst.components.projectile:SetSpeed(SPEED)
    inst.components.projectile:SetHitDist(.5)
    inst.components.projectile:SetOnThrownFn(OnThrown)
    inst.components.projectile:SetOnHitFn(OnHit)
    inst.components.projectile:SetOnMissFn(inst.Remove)

    inst._seektask = inst:DoPeriodicTask(.5, SeekSoulStealer, 1)
    inst._timeouttask = inst:DoTaskInTime(10, OnTimeout)

    inst.persists = false
    inst.Setup = Setup

    return inst
end


-- Soul orb Inventory Item
local ORBSCALE = .8
local function EndBlockSoulHealFX(v)
    v.blocksoulhealfxtask = nil
end

local function DoHeal(inst)
    local targets = {}
    local x, y, z = inst.Transform:GetWorldPosition()
    for i, v in ipairs(AllPlayers) do
        if not (v.components.health:IsDead() or v:HasTag("playerghost")) and
            v.entity:IsVisible() and
            v:GetDistanceSqToPoint(x, y, z) < TUNING.WORTOX_SOULHEAL_RANGE * TUNING.WORTOX_SOULHEAL_RANGE then
            table.insert(targets, v)
        end
    end
    if #targets > 0 then
        local amt = TUNING.HEALING_MED - math.min(8, #targets) + 1
        for i, v in ipairs(targets) do
            --always heal, but don't stack visual fx
            v.components.health:DoDelta(amt, nil, inst.prefab)
            if v.blocksoulhealfxtask == nil then
                v.blocksoulhealfxtask = v:DoTaskInTime(.5, EndBlockSoulHealFX)
                local fx = SpawnPrefab("soul_orb_fx")
                fx.entity:AddFollower():FollowSymbol(v.GUID, v.components.combat.hiteffectsymbol, 0, -50, 0)
                fx:Setup(v)
            end
        end
    end
end

local function KillSoul(inst)
    inst:ListenForEvent("animover", inst.Remove)
    inst.AnimState:PlayAnimation("idle_pst")
    inst.SoundEmitter:PlaySound("dontstarve/characters/wortox/soul/spawn", nil, .5)
	DoHeal(inst)
end

local function toground(inst)
    inst.persists = false
    if inst._task == nil then
        inst._task = inst:DoTaskInTime(.4 + math.random() * .7, KillSoul)
    end
    if inst.AnimState:IsCurrentAnimation("idle_loop") then
        inst.AnimState:SetTime(math.random() * inst.AnimState:GetCurrentAnimationLength())
    end
end

local function topocket(inst)
    inst.persists = true
    if inst._task ~= nil then
        inst._task:Cancel()
        inst._task = nil
    end
end

local function OnDropped(inst)
    if inst.components.stackable ~= nil and inst.components.stackable:IsStack() then
        local x, y, z = inst.Transform:GetWorldPosition()
        local num = 10 - #TheSim:FindEntities(x, y, z, 4, { "darksoul" })
        if num > 0 then
            for i = 1, math.min(num, inst.components.stackable:StackSize()) do
                local darksoul = inst.components.stackable:Get()
                darksoul.Physics:Teleport(x, y, z)
                darksoul.components.inventoryitem:OnDropped(true)
            end
        end
    end
end

local function OnChosen(inst, owner)
	return owner.prefab == "dendrobium"
end 

local function Inventoryfn()
	local inst = CreateEntity()
	
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
    MakeInventoryPhysics(inst)
    RemovePhysicsColliders(inst)
	
	inst.AnimState:SetBank("wortox_soul_ball")
	inst.AnimState:SetBuild("soul_orb")
	inst.AnimState:PlayAnimation("idle_loop", true)
    inst.AnimState:SetScale(ORBSCALE, ORBSCALE)
	
	inst.entity:AddMiniMapEntity()
	inst.MiniMapEntity:SetIcon("soul_orb")

	inst:AddTag("soulorb")
	inst:AddTag("taintedsoul")

    inst.entity:SetPristine()
	if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM
    inst.components.stackable.forcedropsingle = true
	
	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.canbepickedup = false
    inst.components.inventoryitem.canonlygoinpocket = true
	inst.components.inventoryitem.imagename = "soul_orb"
	inst.components.inventoryitem.atlasname = "images/inventoryimages/soul_orb.xml" 
    inst.components.inventoryitem:SetOnDroppedFn(OnDropped)

	inst:ListenForEvent("onputininventory", topocket)
    inst:ListenForEvent("ondropped", toground)
    inst._task = nil
    toground(inst)
	
	inst:AddComponent("inspectable")
    
	inst:AddComponent("chosen")
	inst.components.chosen:SetChosenFn(OnChosen)

	return inst
end

return Prefab( "common/inventory/soul_orb_fx", fn, assets, prefabs),
    Prefab( "common/inventory/soul_orb_in", Infn, assets),
    Prefab( "common/inventory/soul_orb_spawn", Spawnfn, assets, prefabs),
    Prefab( "common/inventory/soul_orb", Inventoryfn, assets, prefabs),
    MakeFX("leaper_portal_jumpin_fx", "wortox_portal_jumpin"),
    MakeFX("leaper_portal_jumpout_fx", "wortox_portal_jumpout"),
    MakeFX("leaper_portal", "wortox_portal_jumpout")