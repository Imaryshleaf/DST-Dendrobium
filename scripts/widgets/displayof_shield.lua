local G = GLOBAL
local require = G.require
local Badge = require "widgets/badge"
local UIAnim = require "widgets/uianim"
local ShieldBadge = Class(Badge, function(self, owner)
    Badge._ctor(self, "ShieldBadge", owner)
	self.anim = self.underNumber:AddChild(UIAnim())
	self.anim:GetAnimState():SetBank("boat")
	self.anim:GetAnimState():SetBuild("shield_badge")
	self.anim:SetClickable(true)
	self.topperanim = self.underNumber:AddChild(UIAnim())
	self.topperanim:GetAnimState():SetBank("boat")
	self.topperanim:GetAnimState():SetBuild("shield_badge")
	self.topperanim:SetClickable(false) 
	self.shieldarrow = self.underNumber:AddChild(UIAnim())
    self.shieldarrow:GetAnimState():SetBank("sanity_arrow")
    self.shieldarrow:GetAnimState():SetBuild("sanity_arrow")
    self.shieldarrow:GetAnimState():PlayAnimation("neutral")
    self.shieldarrow:SetClickable(false)
	self.owner = owner
	owner.shieldarrow = self.shieldarrow
    self:StartUpdating()
	self:OpenBadge()
	self.OnMouseStartClick = true
end)

function ShieldBadge:SetPercent(val, max_shield)
    Badge.SetPercent(self, val, max_shield)
end

function ShieldBadge:OnUpdate(dt)
	local up = self.owner ~= nil and
		(self.owner:HasTag("Dendrobium") and not self.owner:HasTag("playerghost") and
		self.owner.ShieldRegen or self.owner.sg ~= nil and self.owner.sg:HasStateTag(" ")) 
	local anim = up and "arrow_loop_increase" or "neutral"
	if self.arrowdir ~= anim then
		self.arrowdir = anim
		self.shieldarrow:GetAnimState():PlayAnimation(anim, true)
	end
	if self.owner:HasTag("playerghost") then
		self.anim:Hide() 
		self.shieldarrow:Hide() 
		self.topperanim:Hide() 
	else 
		self.anim:Show() 
		self.shieldarrow:Show() 
		self.topperanim:Show()
	end
end

function ShieldBadge:OpenBadge()
	self.inst:DoTaskInTime( 0.25, function() self.topperanim:GetAnimState():PlayAnimation("open_pre") end)
	self.inst:DoTaskInTime( 0.30, function() self.anim:Show() self.shieldarrow:Show() end)
	self.inst:DoTaskInTime( 0.5, function()	 self.topperanim:GetAnimState():PlayAnimation("open_pst") end)
	self.inst:DoTaskInTime( 5, function()	
		self.OnMouseStartClick = true
	end)
end

function ShieldBadge:CloseBadge()
	self.inst:DoTaskInTime( 0.25, function() self.topperanim:GetAnimState():PlayAnimation("close_pre") end)
	self.inst:DoTaskInTime( 0.30, function() self.anim:Hide() self.shieldarrow:Hide() end)
	self.inst:DoTaskInTime( 0.5, function() self.topperanim:GetAnimState():PlayAnimation("close_pst") end)
	self.inst:DoTaskInTime( 5, function()	
		self:OpenBadge()	
	end)
end

function ShieldBadge:OnMouseButton(button, down, x, y)
	if down == true and button == 1000 and not self.owner:HasTag("playerghost") then
		if self.OnMouseStartClick then
			self.OnMouseStartClick = false
			--self:CloseBadge()
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

local function ShieldFn(self)
	if self.owner.prefab == "dendrobium" then
		self.shield_widget = self:AddChild(ShieldBadge(self.owner))
		self.owner.shieldbadge = self.shield_widget
		-- Set some initial positions
		self.shield_widget:SetPosition(-625, -445, 95)
		self.shield_widget:SetScale(.75)
		if dragableConf == 1 then
			DragableFn(self, self.shield_widget)
		end
		local function OnSetPlayerMode(self)
			if self.on_shield_delta == nil then
				self.on_shield_delta = function(owner, data) self:ShieldDelta(data) end
				self.inst:ListenForEvent("shield_delta", self.on_shield_delta, self.owner)
				if self.owner.components.orchidacite ~= nil then
					self:SetShieldPercent(self.owner.components.orchidacite:GetPercent("shield"))
				end
			end
		end
		function self:SetShieldPercent(pct)
			if self.owner.components.orchidacite ~= nil then
				self.shield_widget:SetPercent(pct, self.owner.components.orchidacite.max_shield)
			end		
		end
		function self:ShieldDelta(data)
			self:SetShieldPercent(data.newpercent)
		end
		OnSetPlayerMode(self)
	end	
	return self
end
AddClassPostConstruct("widgets/statusdisplays", ShieldFn)