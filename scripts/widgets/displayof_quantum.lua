local G = GLOBAL
local require = G.require
local Badge = require "widgets/badge"
local UIAnim = require "widgets/uianim"
local QuantumBadge = Class(Badge, function(self, owner)
    Badge._ctor(self, "QuantumBadge", owner)
	self.anim = self.underNumber:AddChild(UIAnim())
	self.anim:GetAnimState():SetBank("boat")
	self.anim:GetAnimState():SetBuild("quantum_badge")
	self.anim:SetClickable(true)
	self.topperanim = self.underNumber:AddChild(UIAnim())
	self.topperanim:GetAnimState():SetBank("boat")
	self.topperanim:GetAnimState():SetBuild("quantum_badge")
	self.topperanim:SetClickable(false) 
	self.quantumarrow = self.underNumber:AddChild(UIAnim())
    self.quantumarrow:GetAnimState():SetBank("sanity_arrow")
    self.quantumarrow:GetAnimState():SetBuild("sanity_arrow")
    self.quantumarrow:GetAnimState():PlayAnimation("neutral")
    self.quantumarrow:SetClickable(false)
	self.owner = owner
	owner.quantumarrow = self.quantumarrow
    self:StartUpdating()
	self:OpenBadge()
	self.OnMouseStartClick = true
end)

function QuantumBadge:SetPercent(val, max_quantum)
    Badge.SetPercent(self, val, max_quantum)
end

function QuantumBadge:OnUpdate(dt)
	local up = self.owner ~= nil and
		(self.owner:HasTag("Dendrobium") and not self.owner:HasTag("playerghost") and
		self.owner.QuantumRegen or self.owner.sg ~= nil and self.owner.sg:HasStateTag(" ")) 
	local anim = up and "arrow_loop_increase" or "neutral"
	if self.arrowdir ~= anim then
		self.arrowdir = anim
		self.quantumarrow:GetAnimState():PlayAnimation(anim, true)
	end
	if self.owner:HasTag("playerghost") then
		self.anim:Hide() 
		self.quantumarrow:Hide() 
		self.topperanim:Hide() 
	else 
		self.anim:Show() 
		self.quantumarrow:Show() 
		self.topperanim:Show()
	end
end

function QuantumBadge:OpenBadge()
	self.inst:DoTaskInTime( 0.25, function() self.topperanim:GetAnimState():PlayAnimation("open_pre") end)
	self.inst:DoTaskInTime( 0.30, function() self.anim:Show() self.quantumarrow:Show() end)
	self.inst:DoTaskInTime( 0.5, function()	 self.topperanim:GetAnimState():PlayAnimation("open_pst") end)
	self.inst:DoTaskInTime( 5, function()	
		self.OnMouseStartClick = true
	end)
end

function QuantumBadge:CloseBadge()
	self.inst:DoTaskInTime( 0.25, function() self.topperanim:GetAnimState():PlayAnimation("close_pre") end)
	self.inst:DoTaskInTime( 0.30, function() self.anim:Hide() self.quantumarrow:Hide() end)
	self.inst:DoTaskInTime( 0.5, function()	self.topperanim:GetAnimState():PlayAnimation("close_pst") end)
	self.inst:DoTaskInTime( 5, function()	
		self:OpenBadge()	
	end)
end

function QuantumBadge:OnMouseButton(button, down, x, y)
	if down == true and button == 1000 and not self.owner:HasTag("playerghost") then
		if self.OnMouseStartClick then
			--self.OnMouseStartClick = false
			--self:CloseBadge()
			self:DoSomething()
		end
	end
end

function QuantumBadge:DoSomething()
	--self:CloseBadge()
	if self.owner ~= nil and self.owner:HasTag("Dendrobium") and not self.owner.sg:HasStateTag("sleeping") and not self.owner.sg:HasStateTag("resting") then
		if not self.owner:HasTag("SecondForm") and self.owner.components.orchidacite:HasCharge("quantum") then
			if self.owner.components.orchidacite then
				self.owner.components.orchidacite:MorphUp()
			end
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

local function QuantumFn(self)
	if self.owner.prefab == "dendrobium" then
		self.quantum_widget = self:AddChild(QuantumBadge(self.owner))
		self.owner.quantumbadge = self.quantum_widget
		-- Set some initial positions
		self.quantum_widget:SetPosition(-670, -475, 80)
		self.quantum_widget:SetScale(0.75)
		if dragableConf == 1 then
			DragableFn(self, self.quantum_widget)
		end
		local function OnSetPlayerMode(self)
			if self.on_quantum_delta == nil then
				self.on_quantum_delta = function(owner, data) self:QuantumDelta(data) end
				self.inst:ListenForEvent("quantum_delta", self.on_quantum_delta, self.owner)
				if self.owner.components.orchidacite ~= nil then
					self:SetQuantumPercent(self.owner.components.orchidacite:GetPercent("quantum"))
				end
			end
		end
		function self:SetQuantumPercent(pct)
			if self.owner.components.orchidacite ~= nil then
				self.quantum_widget:SetPercent(pct, self.owner.components.orchidacite.max_quantum)
			end		
		end
		function self:QuantumDelta(data)
			self:SetQuantumPercent(data.newpercent)
		end
		OnSetPlayerMode(self)
	end	
	return self
end
AddClassPostConstruct("widgets/statusdisplays", QuantumFn)