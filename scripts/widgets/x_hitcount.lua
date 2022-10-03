local Badge = require "widgets/badge"
local UIAnim = require "widgets/uianim"
local Image = require "widgets/image"

local HitCount = Class(Badge, function(self, owner)
    Badge._ctor(self, "hitcount", owner)
	self.anim:GetAnimState():SetBuild("hitcount")
	---
	self.hitcount_badge = self.underNumber:AddChild(UIAnim())
    self.hitcount_badge:GetAnimState():SetBank("hitcount")
    self.hitcount_badge:GetAnimState():SetBuild("hitcount")
    self.hitcount_badge:GetAnimState():PlayAnimation("empty")
    self.hitcount_badge:SetClickable(true)
	self.hitcount_badge:Show()
	--
	self.owner = owner
	owner.hitcount_badge = self.hitcount_badge
	self.OnMouseStartClick = true
    self:StartUpdating()
end)

function HitCount:OnUpdate(dt)
	if self.owner:HasTag("playerghost") then
		self.hitcount_badge:Hide() 
	else 
		self.hitcount_badge:Show()
	end
end

function HitCount:OnMouseButton(button, down, x, y)
if down == true and button == 1000 then
	if self.OnMouseStartClick then
			return -- Do something
		end
	end
end

local function DragableFn(self, widget_display)
	local dragging = false
	self.dragable_widget = widget_display
	self.dragable_widget.OnMouseButton = function(inst, button, down, x, y)
		if button == 1001 and down then
				dragging = true
				if dragging then
					local mousepos = TheInput:GetScreenPosition()
					self.dragPosDiff = self.dragable_widget:GetPosition() - mousepos
					print("- Drag mouse pos -")
					print(self.dragPosDiff)
					print("- Current widget pos -")
					print(widget_display:GetPosition())
				end
			else
			dragging = false
		end	
	end
	self.followhandler = TheInput:AddMoveHandler(function(x,y)
		if dragging then
			local pos
			if type(x) == "number" then
				pos = Vector3(x, y, 1)
			else
				pos = x
			end
			self.dragable_widget:SetPosition(pos + self.dragPosDiff)
		end
	end)
end
local dragableConf = 0

local function HitCountFn(self)
	if self.owner.prefab == "dendrobium" then
		self.hitcount_widget = self:AddChild(HitCount(self.owner))
		-- Set some initial positions
		self.hitcount_widget:SetPosition(-646, -535, 23)
		self.hitcount_widget:SetScale(0.4)
		if dragableConf == 1 then
			DragableFn(self, self.hitcount_widget)
		end
	end
	return self
end
AddClassPostConstruct("widgets/statusdisplays", HitCountFn)

return HitCount