local assets = {
   Asset("ANIM", "anim/fx_dark_forcefield.zip")
}

local function kill_fx(inst)
    inst.AnimState:PlayAnimation("close")
    inst.components.lighttweener:StartTween(nil, 0, .9, 0.9, nil, .2)
    inst:DoTaskInTime(0.6, inst.Remove)
end

local function fn(Sim)
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddLight()
	inst.entity:AddNetwork()
	
    inst.AnimState:SetBank("forcefield")
    inst.AnimState:SetBuild("fx_dark_forcefield")
    inst.AnimState:PlayAnimation("open")
    inst.AnimState:PushAnimation("idle_loop", true)

    inst.entity:SetPristine()
    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("lighttweener")
    inst.components.lighttweener:StartTween(inst.Light, 0, .9, 0.9, {1,1,1}, 0)
    inst.components.lighttweener:StartTween(nil, 3, .9, 0.9, nil, .2)
	
    inst.kill_fx = kill_fx
    inst.SoundEmitter:PlaySound("dontstarve/wilson/forcefield_LP", "loop")
		
    return inst
end

return Prefab( "common/fx_dark_forcefield", fn, assets) 
