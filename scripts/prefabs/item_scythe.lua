local assets = {
    Asset("ANIM", "anim/equippable/idle/scythe.zip"),
    Asset("ANIM", "anim/equippable/swap/swap_scythe.zip"),
	Asset("ATLAS", "images/inventoryimages/scythe.xml"),
	Asset("IMAGE", "images/inventoryimages/scythe.tex"),
}

local function onequip(inst, owner)
	owner.AnimState:OverrideSymbol("swap_object", "swap_scythe", "swap_scythe")
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")
	--
	inst.SoundEmitter:PlaySound("dontstarve/wilson/equip_item_gold")
end

local function onunequip(inst, owner)
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")
    local skin_build = inst:GetSkinBuild()
    if skin_build ~= nil then
        owner:PushEvent("unequipskinneditem", inst:GetSkinName())
    end
	--
	inst.SoundEmitter:PlaySound("dontstarve/common/gem_shatter")
end

local function fn()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()
	inst.entity:AddSoundEmitter()
	inst.entity:AddMiniMapEntity()
    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("scythe")
    inst.AnimState:SetBuild("scythe")
    inst.AnimState:PlayAnimation("idle")
	inst.MiniMapEntity:SetIcon("scythe.tex")

    inst:AddTag("sharp")
    inst:AddTag("weapon")

    MakeInventoryFloatable(inst, "med", 0.05, {1.1, 0.5, 1.1}, true, -9)

    inst.entity:SetPristine()
    if not TheWorld.ismastersim then
        return inst
    end

	inst:AddComponent("talker")
    inst.components.talker.fontsize = 22
    inst.components.talker.font = TALKINGFONT
    inst.components.talker.colour = Vector3(0.7, 0.85, 1, 1)
    inst.components.talker.offset = Vector3(200,-250,0)
    inst.components.talker.symbol = "swap_object"

    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(50)
	inst.components.weapon:SetRange(0.3, 1)
	inst.components.weapon:SetElectric()

    inst:AddComponent("inspectable")
	inst.components.inspectable:RecordViews()
	
    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.imagename = "scythe"
	inst.components.inventoryitem.atlasname = "images/inventoryimages/scythe.xml" 

    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)

	-- 
	inst:AddComponent("classifieditem")
	inst.components.classifieditem:SetOwner("dendrobium")

    MakeHauntableLaunch(inst)
    return inst
end

return Prefab("dendrobium_scythe", fn, assets)