local assets = {
    Asset("ANIM", "anim/noctilucous_jade.zip"),
    -- Inventory item
	Asset("ATLAS", "images/inventoryimages/noctilucous_jade.xml"),
	Asset("IMAGE", "images/inventoryimages/noctilucous_jade.tex"),
}

local function fn()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
    MakeInventoryPhysics(inst)

    --inst.AnimState:SetRayTestOnBB(true)
    inst.AnimState:SetBank("noctilucous_jade")
    inst.AnimState:SetBuild("noctilucous_jade")
    inst.AnimState:PlayAnimation("idle", true)
	inst.Transform:SetScale(0.5, 0.5, 0.5)

	inst:AddTag("materials")
	inst:AddTag("noctilucous_jade")

    inst.entity:SetPristine()
    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem:SetSinks(true)
	inst.components.inventoryitem.imagename = "noctilucous_jade"
	inst.components.inventoryitem.atlasname = "images/inventoryimages/noctilucous_jade.xml" 
	
    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

    inst:AddComponent("inspectable")
    MakeHauntableLaunchAndSmash(inst)

    return inst
end

return Prefab("noctilucous_jade", fn, assets)