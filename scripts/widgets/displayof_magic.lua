local G = GLOBAL
local require = G.require
local Badge = require "widgets/badge"
local UIAnim = require "widgets/uianim"
local MagicBadge = Class(Badge, function(self, owner)
    Badge._ctor(self, "MagicBadge", owner)
	self.anim = self.underNumber:AddChild(UIAnim())
	self.anim:GetAnimState():SetBank("boat")
	self.anim:GetAnimState():SetBuild("magic_badge")
	self.anim:SetClickable(true)
	self.topperanim = self.underNumber:AddChild(UIAnim())
	self.topperanim:GetAnimState():SetBank("boat")
	self.topperanim:GetAnimState():SetBuild("magic_badge")
	self.topperanim:SetClickable(false) 
	self.magicarrow = self.underNumber:AddChild(UIAnim())
    self.magicarrow:GetAnimState():SetBank("sanity_arrow")
    self.magicarrow:GetAnimState():SetBuild("sanity_arrow")
    self.magicarrow:GetAnimState():PlayAnimation("neutral")
    self.magicarrow:SetClickable(false)
	self.owner = owner
	owner.magicarrow = self.magicarrow
    self:StartUpdating()
	self:OpenBadge()
	self.OnMouseStartClick = true
end)

function MagicBadge:SetPercent(val, max_magic)
    Badge.SetPercent(self, val, max_magic)
end

function MagicBadge:OnUpdate(dt)
	local up = self.owner ~= nil and
		(self.owner:HasTag("Dendrobium") and not self.owner:HasTag("playerghost") and
		self.owner.MagicRegen or self.owner.sg ~= nil and self.owner.sg:HasStateTag(" ")) 
	local anim = up and "arrow_loop_increase" or "neutral"
	if self.arrowdir ~= anim then
		self.arrowdir = anim
		self.magicarrow:GetAnimState():PlayAnimation(anim, true)
	end
	if self.owner:HasTag("playerghost") then
		self.anim:Hide() 
		self.magicarrow:Hide() 
		self.topperanim:Hide() 
	else 
		self.anim:Show() 
		self.magicarrow:Show() 
		self.topperanim:Show()
	end
end

function MagicBadge:OpenBadge()
	self.inst:DoTaskInTime( 0.25, function() self.topperanim:GetAnimState():PlayAnimation("open_pre") end)
	self.inst:DoTaskInTime( 0.30, function() self.anim:Show() self.magicarrow:Show() end)
	self.inst:DoTaskInTime( 0.5, function()	 self.topperanim:GetAnimState():PlayAnimation("open_pst") end)
	self.inst:DoTaskInTime( 5, function()	
		self.OnMouseStartClick = true
	end)
end

function MagicBadge:CloseBadge()
	self.inst:DoTaskInTime( 0.25, function() self.topperanim:GetAnimState():PlayAnimation("close_pre") end)
	self.inst:DoTaskInTime( 0.30, function() self.anim:Hide() self.magicarrow:Hide() end)
	self.inst:DoTaskInTime( 0.5, function()	self.topperanim:GetAnimState():PlayAnimation("close_pst") end)
	self.inst:DoTaskInTime( 5, function()	
		self:OpenBadge()	
	end)
end

function MagicBadge:OnMouseButton(button, down, x, y)
	if down == true and button == 1000 and not self.owner:HasTag("playerghost") then
		if self.OnMouseStartClick then
			--self.OnMouseStartClick = false
			--self:CloseBadge()
			self:DoSomething()
		end
	end
end

function MagicBadge:DoSomething()
	--self:CloseBadge()
	if self.owner ~= nil and self.owner:HasTag("Dendrobium") and not self.owner.sg:HasStateTag("sleeping") and not self.owner.sg:HasStateTag("resting") then
		self.owner.sg:GoToState("alterSoulSG")
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

local function MagicFn(self)
	if self.owner.prefab == "dendrobium" then
		self.magic_widget = self:AddChild(MagicBadge(self.owner))
		self.owner.magicbadge = self.magic_widget
		-- Set some initial positions
		self.magic_widget:SetPosition(-670, -415, 80)
		self.magic_widget:SetScale(0.75)
		if dragableConf == 1 then
			DragableFn(self, self.magic_widget)
		end
		local function OnSetPlayerMode(self)
			if self.on_magic_delta == nil then
				self.on_magic_delta = function(owner, data) self:MagicDelta(data) end
				self.inst:ListenForEvent("magic_delta", self.on_magic_delta, self.owner)
				if self.owner.components.orchidacite ~= nil then
					self:SetMagicPercent(self.owner.components.orchidacite:GetPercent("magic"))
				end
			end
		end
		function self:SetMagicPercent(pct)
			if self.owner.components.orchidacite ~= nil then
				self.magic_widget:SetPercent(pct, self.owner.components.orchidacite.max_magic)
			end		
		end
		function self:MagicDelta(data)
			self:SetMagicPercent(data.newpercent)
		end
		OnSetPlayerMode(self)
	end	
	return self
end
AddClassPostConstruct("widgets/statusdisplays", MagicFn)