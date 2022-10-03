local G = GLOBAL
local require = G.require
local Badge = require "widgets/badge"
local UIAnim = require "widgets/uianim"
local EnergyBadge = Class(Badge, function(self, owner)
    Badge._ctor(self, "EnergyBadge", owner)
	self.anim = self.underNumber:AddChild(UIAnim())
	self.anim:GetAnimState():SetBank("boat")
	self.anim:GetAnimState():SetBuild("energy_badge")
	self.anim:SetClickable(true)
	self.topperanim = self.underNumber:AddChild(UIAnim())
	self.topperanim:GetAnimState():SetBank("boat")
	self.topperanim:GetAnimState():SetBuild("energy_badge")
	self.topperanim:SetClickable(false) 
	self.energyarrow = self.underNumber:AddChild(UIAnim())
    self.energyarrow:GetAnimState():SetBank("sanity_arrow")
    self.energyarrow:GetAnimState():SetBuild("sanity_arrow")
    self.energyarrow:GetAnimState():PlayAnimation("neutral")
    self.energyarrow:SetClickable(false)
	self.owner = owner
	owner.energyarrow = self.energyarrow
    self:StartUpdating()
	self:OpenBadge()
	self.OnMouseStartClick = true
end)
local _oldSetPercent = EnergyBadge.SetPercent
function EnergyBadge:SetPercent(val, max_energy)
    Badge.SetPercent(self, val, max_energy)
end
function EnergyBadge:OnUpdate(dt)
	local up = self.owner ~= nil and
		(self.owner:HasTag("Dendrobium") and not self.owner:HasTag("playerghost") and
		self.owner.EnergyRegen or self.owner.sg ~= nil and self.owner.sg:HasStateTag(" ")) 
	local anim = up and "arrow_loop_increase" or "neutral"
	if self.arrowdir ~= anim then
		self.arrowdir = anim
		self.energyarrow:GetAnimState():PlayAnimation(anim, true)
	end
	if self.owner:HasTag("playerghost") then
		self.anim:Hide() self.energyarrow:Hide() self.topperanim:Hide() else self.anim:Show() self.energyarrow:Show() self.topperanim:Show()
	end
end
function EnergyBadge:OpenBadge()
	self.inst:DoTaskInTime( 0.25, function() self.topperanim:GetAnimState():PlayAnimation("open_pre") end)
	self.inst:DoTaskInTime( 0.30, function() self.anim:Show() self.energyarrow:Show() end)
	self.inst:DoTaskInTime( 0.5, function()	 self.topperanim:GetAnimState():PlayAnimation("open_pst") end)
	self.inst:DoTaskInTime( 5, function()	
		self.OnMouseStartClick = true
	end)
end
function EnergyBadge:CloseBadge()
	self.inst:DoTaskInTime( 0.25, function() self.topperanim:GetAnimState():PlayAnimation("close_pre") end)
	self.inst:DoTaskInTime( 0.30, function() self.anim:Hide() self.energyarrow:Hide() end)
	self.inst:DoTaskInTime( 0.5, function()	self.topperanim:GetAnimState():PlayAnimation("close_pst") end)
	self.inst:DoTaskInTime( 5, function()	
		self:OpenBadge()	
	end)
end
function EnergyBadge:OnMouseButton(button, down, x, y)
if down == true and button == 1000 then
if self.OnMouseStartClick then
	--self.OnMouseStartClick = false
		-- self:CloseBadge()
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

local function EnergyFn(self)
	if self.owner.prefab == "dendrobium" then
		self.energy_widget = self:AddChild(EnergyBadge(self.owner))
		self.owner.energybadge = self.energy_widget
		-- Set some initial positions
		self.energy_widget:SetPosition(-1083, -510, 1)
		self.energy_widget:SetScale(0.75)
		if dragableConf == 1 then
			DragableFn(self, self.energy_widget)
		end
		local function OnSetPlayerMode(self)
			if self.on_energy_delta == nil then
				self.on_energy_delta = function(owner, data) self:EnergyDelta(data) end
				self.inst:ListenForEvent("energy_delta", self.on_energy_delta, self.owner)
				if self.owner.components.orchidacite ~= nil then
					self:SetEnergyPercent(self.owner.components.orchidacite:GetPercent("energy"))
				end
			end
		end
		function self:SetEnergyPercent(pct)
			if self.owner.components.orchidacite ~= nil then
				self.energy_widget:SetPercent(pct, self.owner.components.orchidacite.max_energy)
			end		
		end
		function self:EnergyDelta(data)
			self:SetEnergyPercent(data.newpercent)
		end
		OnSetPlayerMode(self)
	end	
	return self
end
AddClassPostConstruct("widgets/statusdisplays", EnergyFn)