local assets = {
    Asset("ANIM", "anim/fx_spin_electric.zip")
}

local function onupdate(inst, dt)
    inst.Light:SetIntensity(inst.i)
    inst.i = inst.i - dt * 2
    if inst.i <= 0 then
        inst:Remove()
    end
end

local function StartFX(proxy)
    local inst = CreateEntity()
	
    inst:AddTag("FX")
    --[[Non-networked entity]]
    inst.entity:SetCanSleep(false)
    inst.persists = false

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    if not TheNet:IsDedicated() then
        inst.entity:AddSoundEmitter()
    end
	inst.entity:AddLight()

	-- This follow entity
    local parent = proxy.entity:GetParent()
    if parent ~= nil then
        inst.entity:SetParent(parent.entity)
    end
    inst.Transform:SetFromProxy(proxy.GUID)
	
    inst.AnimState:SetBank("mossling_spin_fx")
    inst.AnimState:SetBuild("fx_spin_electric")
    inst.AnimState:PlayAnimation("spin_loop")
	inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")

    inst.Light:Enable(true)
    inst.Light:SetRadius(2)
    inst.Light:SetFalloff(1)
    inst.Light:SetIntensity(.8)
    inst.Light:SetColour(150/255,200/255,255/255)

	local dt = 1/150
    inst.i = .9
    inst:DoPeriodicTask(dt, onupdate, nil, dt)	
    inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/mossling/spin_electric")
    inst:DoTaskInTime(24*FRAMES, function(inst)
        inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/mossling/spin_electric")
        inst:DoTaskInTime(24*FRAMES, function(inst)
            inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/mossling/spin_electric")
        end)
    end)
    
    inst:ListenForEvent("animover", inst.Remove)
end

local function fn()
    local inst = CreateEntity()
	inst.entity:AddTransform()
    inst.entity:AddNetwork()
    inst:AddTag("FX")
	
    --Delay one frame in case we are about to be removed
    inst:DoTaskInTime(0, StartFX)
    inst.entity:SetPristine()
    if not TheWorld.ismastersim then
        return inst
    end
    
    inst.persists = false
    inst:DoTaskInTime(1, inst.Remove)
    return inst
end

return Prefab("fx_spin_electric", fn, assets)