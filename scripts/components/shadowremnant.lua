local ShadowRemnant = Class(function(self, inst)
	self.inst = inst
	self.inst:AddTag("shadowremnant")
end)

function ShadowRemnant:Teleport(caster, remnant)
	local pos = remnant:GetPosition()
	if pos ~= nil and TheWorld.Map:IsPassableAtPoint(pos:Get()) and not TheWorld.Map:IsGroundTargetBlocked(pos) then
		SpawnPrefab("statue_transition_2").Transform:SetPosition(remnant:GetPosition():Get())
	    caster.Physics:Teleport(pos:Get())
		self:Despawn()
	end
end

function ShadowRemnant:Despawn()
	return self.inst:Remove()
end

return ShadowRemnant