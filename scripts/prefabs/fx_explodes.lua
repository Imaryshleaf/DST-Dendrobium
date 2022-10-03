local assets = {
    Asset("ANIM", "anim/fx_explodes.zip"),
}

local function PlaySmallAnim(proxy)
    local inst = CreateEntity()

    inst:AddTag("FX")
    --[[Non-networked entity]]
    inst.entity:SetCanSleep(false)
    inst.persists = false

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()

    inst.Transform:SetFromProxy(proxy.GUID)

    inst.AnimState:SetBank("explode")
    inst.AnimState:SetBuild("fx_explodes")
    inst.AnimState:PlayAnimation("small")
    inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
	inst.SoundEmitter:PlaySound("dontstarve/common/blackpowder_explo")

    inst:ListenForEvent("animover", inst.Remove)
end

local function PlayFirecrackers(proxy)
    local inst = CreateEntity()

    inst:AddTag("FX")
    --[[Non-networked entity]]
    inst.entity:SetCanSleep(false)
    inst.persists = false

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()

    inst.Transform:SetFromProxy(proxy.GUID)
	inst.AnimState:SetScale(.5, .5, .5)

    inst.AnimState:SetBank("explode")
    inst.AnimState:SetBuild("fx_explodes")
    inst.AnimState:PlayAnimation("small_firecrackers")
    inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
	inst.SoundEmitter:PlaySound("dontstarve/common/together/fire_cracker")

    inst:ListenForEvent("animover", inst.Remove)
end

local function SmallFn()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddNetwork()

    inst:AddTag("FX")

	--Dedicated server does not need to spawn the local fx
	--Delay one frame so that we are positioned properly before starting the effect
	--or in case we are about to be removed
	if not TheNet:IsDedicated() then
		inst:DoTaskInTime(0, PlaySmallAnim)
	end

	inst.Transform:SetFourFaced()
	
    inst.entity:SetPristine()
    if not TheWorld.ismastersim then
        return inst
    end

    inst.persists = false
    inst:DoTaskInTime(1, inst.Remove)
    return inst
end

local function FirecrackersFn()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddNetwork()

    inst:AddTag("FX")

	--Dedicated server does not need to spawn the local fx
	--Delay one frame so that we are positioned properly before starting the effect
	--or in case we are about to be removed
	if not TheNet:IsDedicated() then
		inst:DoTaskInTime(0, PlayFirecrackers)
	end

	inst.Transform:SetFourFaced()
	
    inst.entity:SetPristine()
    if not TheWorld.ismastersim then
        return inst
    end

    inst.persists = false
    inst:DoTaskInTime(1, inst.Remove)
    return inst
end

return Prefab("fx_exploded_small", SmallFn, assets),
	Prefab("fx_exploded_firecrackers", FirecrackersFn, assets)