local assets = {
	Asset("ANIM", "character/skins/dendrobium_black.zip"),
}

local function NoDebrisDmg(inst, amount, overtime, cause, ignore_invincible, afflicter, ignore_absorb)
    return afflicter ~= nil and afflicter:HasTag("quakedebris")
end

local function makeshadowremnant()
	local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddDynamicShadow()
    inst.entity:AddNetwork()
	inst.entity:AddMiniMapEntity()

	inst.Transform:SetScale(.8, .8, .8)
	inst.Transform:SetFourFaced(inst)

	inst.MiniMapEntity:SetIcon("dendrobium.tex")
	inst.MiniMapEntity:SetCanUseCache(false)

	inst.AnimState:SetBank("wilson")
	inst.AnimState:SetBuild("dendrobium_black")
	inst.AnimState:PlayAnimation("idle_loop", true)
    
	inst.AnimState:Hide("ARM_carry")
    inst.AnimState:Hide("hat")
    inst.AnimState:Hide("hat_hair")

	-- Game Tags
	inst:AddTag("NOBLOCK")
	
	inst.entity:SetPristine()
   	if not TheWorld.ismastersim then
		return inst
	end

	inst:AddComponent("inspectable")
	
	inst:AddComponent("colourtweener")
	inst.components.colourtweener:StartTween({1,1,1,.7}, 0)

	inst:AddComponent("talker")
	inst.components.talker.fontsize = 20
	inst.components.talker.colour = Vector3(0.7, 0.75, 0.95, 1)
	
	-- Custom
	inst:AddTag("shadow_remnants")
	inst:AddComponent("shadowremnant")

	return inst
end
return Prefab("dendrobium_shadow_remnants", makeshadowremnant, assets, prefabs)