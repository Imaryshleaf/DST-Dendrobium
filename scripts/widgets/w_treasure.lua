local G = GLOBAL
local require = G.require
local Badge = require "widgets/badge"
local UIAnim = require "widgets/uianim"
local TreasureBadge = Class(Badge, function(self, owner)
    Badge._ctor(self, "TreasureBadge", owner)
	self.anim = self.underNumber:AddChild(UIAnim())
	self.anim:GetAnimState():SetBank("boat")
	self.anim:GetAnimState():SetBuild("treasure_badge")
	self.anim:SetClickable(true)
	self.topperanim = self.underNumber:AddChild(UIAnim())
	self.topperanim:GetAnimState():SetBank("boat")
	self.topperanim:GetAnimState():SetBuild("treasure_badge")
	self.topperanim:SetClickable(false) 
	self.treasurearrow = self.underNumber:AddChild(UIAnim())
    self.treasurearrow:GetAnimState():SetBank("sanity_arrow")
    self.treasurearrow:GetAnimState():SetBuild("sanity_arrow")
    self.treasurearrow:GetAnimState():PlayAnimation("neutral")
    self.treasurearrow:SetClickable(false)
	self.owner = owner
	owner.treasurearrow = self.treasurearrow
    self:StartUpdating()
	self:OpenBadge()
	self.OnMouseStartClick = true
end)
local _oldSetPercent = TreasureBadge.SetPercent
function TreasureBadge:SetPercent(val, max_treasure)
    Badge.SetPercent(self, val, max_treasure)
end
function TreasureBadge:OnUpdate(dt)
	local up = self.owner ~= nil and
		(self.owner:HasTag("Dendrobium") and not self.owner:HasTag("playerghost") and
		self.owner.TreasureRegen or self.owner.sg ~= nil and self.owner.sg:HasStateTag(" ")) 
	local anim = up and "arrow_loop_increase" or "neutral"
	if self.arrowdir ~= anim then
		self.arrowdir = anim
		self.treasurearrow:GetAnimState():PlayAnimation(anim, true)
	end
	if self.owner:HasTag("playerghost") then
		self.anim:Hide() self.treasurearrow:Hide() self.topperanim:Hide() else self.anim:Show() self.treasurearrow:Show() self.topperanim:Show()
	end
end
function TreasureBadge:OpenBadge()
	self.inst:DoTaskInTime( 0.25, function() self.topperanim:GetAnimState():PlayAnimation("open_pre") end)
	self.inst:DoTaskInTime( 0.30, function() self.anim:Show() self.treasurearrow:Show() end)
	self.inst:DoTaskInTime( 0.5, function()	 self.topperanim:GetAnimState():PlayAnimation("open_pst") end)
	self.inst:DoTaskInTime( 5, function()	
		self.OnMouseStartClick = true
	end)
end
function TreasureBadge:CloseBadge()
	self.inst:DoTaskInTime( 0.25, function() self.topperanim:GetAnimState():PlayAnimation("close_pre") end)
	self.inst:DoTaskInTime( 0.30, function() self.anim:Hide() self.treasurearrow:Hide() end)
	self.inst:DoTaskInTime( 0.5, function()	self.topperanim:GetAnimState():PlayAnimation("close_pst") end)
	self.inst:DoTaskInTime( 5, function()	
		self:OpenBadge()	
	end)
end
function TreasureBadge:OnMouseButton(button, down, x, y)
if down == true and button == 1000 then
if self.OnMouseStartClick then
	--self.OnMouseStartClick = false
		self:DoSomething()
		end
	end
end
function TreasureBadge:DoSomething()
	--self:CloseBadge()
	if self.owner ~= nil and self.owner:HasTag("Dendrobium") and not self.owner.sg:HasStateTag("sleeping") and not self.owner.sg:HasStateTag("resting") then
		self.owner.sg:GoToState("revealXMarkSG")
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

local function TreasureFn(self)
	if self.owner.prefab == "dendrobium" then
		self.treasure_widget = self:AddChild(TreasureBadge(self.owner))
		self.owner.treasurebadge = self.treasure_widget
		-- Set some initial positions
		self.treasure_widget:SetPosition(-921, -510, 1)
		self.treasure_widget:SetScale(0.75)
		if dragableConf == 1 then
			DragableFn(self, self.treasure_widget)
		end
		local function OnSetPlayerMode(self)
			if self.on_treasure_delta == nil then
				self.on_treasure_delta = function(owner, data) self:TreasureDelta(data) end
				self.inst:ListenForEvent("treasure_delta", self.on_treasure_delta, self.owner)
				if self.owner.components.orchidacite ~= nil then
					self:SetTreasurePercent(self.owner.components.orchidacite:GetPercent("treasure"))
				end
			end
		end
		function self:SetTreasurePercent(pct)
			if self.owner.components.orchidacite ~= nil then
				self.treasure_widget:SetPercent(pct, self.owner.components.orchidacite.max_treasure)
			end		
		end
		function self:TreasureDelta(data)
			self:SetTreasurePercent(data.newpercent)
		end
		OnSetPlayerMode(self)
	end	
	return self
end
AddClassPostConstruct("widgets/statusdisplays", TreasureFn)