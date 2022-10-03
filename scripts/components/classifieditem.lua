-- Only for inventory items
local ClassifiedItem = Class(function(self, inst)
    self.inst = inst
    self.character = nil
    self.storable = false
    self.comment = "It's a thing!"
end)

function ClassifiedItem:CanPickUp(doer)
	if doer and doer.prefab ~= self.character then
		return false
	end
	return true
end

function ClassifiedItem:SetOwner(name)
    self.character = name
end

function ClassifiedItem:IsStorable()
	return self.storable
end

function ClassifiedItem:SetStorable(value)
	self.storable = value
end

function ClassifiedItem:GetComment()
	return self.comment
end

function ClassifiedItem:SetComment(comment)
	self.comment = comment
end

return ClassifiedItem