local Widget = require "widgets/widget"
local Text = require "widgets/text"
local Image = require "widgets/image"

local SneakAttack = Class(Widget, function(self, owner)
	Widget._ctor(self, "SneakAttack")
	self.owner = owner

	self:SetHAnchor(2)
	self:SetVAnchor(2)
	self:SetPosition(-170, 80, 0)
	self:SetScale(0.3, 0.3, 0.3)

	self.image_0 = self:AddChild(Image("character/skills/buttons/sneakattack.xml", "sneakattack.tex"))
	self.image_1 = self:AddChild(Image("character/skills/buttons/sneakattack_cd.xml", "sneakattack_cd.tex"))

	--增加贴图
	--self.image = self:AddChild(Image())
    --self.image:SetTexture(atlas, normal_tex, focus_tex) 

	self.cd = self:AddChild(Text(BODYTEXTFONT, 53))
	self.cd:SetHAlign(ANCHOR_MIDDLE)
	self.cd:MoveToFront()

	self:StartUpdating()

	self.click = true
end)

function SneakAttack:OnControl(control, down)
	if not self:IsEnabled() or not self.focus then return false end
	if not self.click then return false end

	if control == CONTROL_ACCEPT then
		if down then
			TheFrontEnd:GetSound():PlaySound("dontstarve/HUD/click_move")
			self.o_pos = self:GetLocalPosition()
			self:SetPosition(self.o_pos + Vector3(0, -3, 0))
			self.down = true
		elseif self.down then
			self.down = false
			if self.o_pos then
				self:SetPosition(self.o_pos)
				self.o_pos = nil
			end
			local inst = self.owner
			if inst.components.chronometer ~= nil then
				inst:PushEvent("sneakattack_skill")
				inst.components.chronometer:StartTimer("sneakattack_skill", 7)
			end
		end
		return true
	end
end

function SneakAttack:OnUpdate(dt)
	local timeleft = self.owner.sneakattack_cd:value() or 0
	self.cd:SetString(string.format("%.1f", timeleft))

	if self.owner:HasTag("playerghost") or self.owner.sg:HasStateTag("sleeping") or self.owner.sg:HasStateTag("resting") then
		self.cd:Hide()
		self.image_0:Hide()
		self.image_1:Hide()
	else
		if timeleft > 0 then
			self.cd:Show()
			self.image_0:Show()
			self.image_1:Hide()
			self.click = false
		else
			self.cd:Hide()
			self.image_0:Hide()
			self.image_1:Show()
			self.click = true
		end
	end
end

AddClassPostConstruct("widgets/controls", function(self)
	if self.owner and self.owner.prefab == "dendrobium" then
		self.quaButton = self:AddChild(SneakAttack(self.owner))
	end
end)

return SneakAttack