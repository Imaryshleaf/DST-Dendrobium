local G = GLOBAL
local require = G.require
local Badge = require "widgets/badge"
local UIAnim = require "widgets/uianim"
local BloomBadge = Class(Badge, function(self, owner)
    Badge._ctor(self, "BloomBadge", owner)
	self.anim = self.underNumber:AddChild(UIAnim())
	self.anim:GetAnimState():SetBank("boat")
	self.anim:GetAnimState():SetBuild("bloom_badge")
	self.anim:SetClickable(true)
	self.topperanim = self.underNumber:AddChild(UIAnim())
	self.topperanim:GetAnimState():SetBank("boat")
	self.topperanim:GetAnimState():SetBuild("bloom_badge")
	self.topperanim:SetClickable(false) 
	self.bloomarrow = self.underNumber:AddChild(UIAnim())
    self.bloomarrow:GetAnimState():SetBank("sanity_arrow")
    self.bloomarrow:GetAnimState():SetBuild("sanity_arrow")
    self.bloomarrow:GetAnimState():PlayAnimation("neutral")
    self.bloomarrow:SetClickable(false)
	self.owner = owner
	owner.bloomarrow = self.bloomarrow
    self:StartUpdating()
	self:OpenBadge()
	self.OnMouseStartClick = true
end)
local _oldSetPercent = BloomBadge.SetPercent
function BloomBadge:SetPercent(val, max_bloom)
    Badge.SetPercent(self, val, max_bloom)
end
function BloomBadge:OnUpdate(dt)
	local up = self.owner ~= nil and
		(self.owner:HasTag("Dendrobium") and not self.owner:HasTag("playerghost") and
		self.owner.BloomRegen or self.owner.sg ~= nil and self.owner.sg:HasStateTag(" "))
	local anim = up and "arrow_loop_increase" or "neutral"
	if self.arrowdir ~= anim then
		self.arrowdir = anim
		self.bloomarrow:GetAnimState():PlayAnimation(anim, true)
	end
	if self.owner:HasTag("playerghost") then
		self.anim:Hide() self.bloomarrow:Hide() self.topperanim:Hide() else self.anim:Show() self.bloomarrow:Show() self.topperanim:Show()
	end
end

function BloomBadge:OpenBadge()
	self.inst:DoTaskInTime( 0.25, function() self.topperanim:GetAnimState():PlayAnimation("open_pre") end)
	self.inst:DoTaskInTime( 0.30, function() self.anim:Show() self.bloomarrow:Show() end)
	self.inst:DoTaskInTime( 0.5, function()	 self.topperanim:GetAnimState():PlayAnimation("open_pst") end)
	self.inst:DoTaskInTime( 5, function()	
		self.OnMouseStartClick = true
	end)
end
function BloomBadge:CloseBadge()
	self.inst:DoTaskInTime( 0.25, function() self.topperanim:GetAnimState():PlayAnimation("close_pre") end)
	self.inst:DoTaskInTime( 0.30, function() self.anim:Hide() self.bloomarrow:Hide() end)
	self.inst:DoTaskInTime( 0.5, function()	self.topperanim:GetAnimState():PlayAnimation("close_pst") end)
	self.inst:DoTaskInTime( 5, function()	
		self:OpenBadge()	
	end)
end
function BloomBadge:OnMouseButton(button, down, x, y)
--if down == true and button == 1000 then
--if self.OnMouseStartClick then
	--self.OnMouseStartClick = false
		self:DoSomething()
--		end
--	end
end
function BloomBadge:DoSomething()
	-- self:CloseBadge()
	if self.owner ~= nil and self.owner:HasTag("Dendrobium") and not self.owner.sg:HasStateTag("sleeping") and not self.owner.sg:HasStateTag("resting") then
		self.owner.sg:GoToState("bloomStartSG")
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

local function BloomFn(self)
	if self.owner.prefab == "dendrobium" then
		self.bloom_widget = self:AddChild(BloomBadge(self.owner))
		self.owner.bloombadge = self.bloom_widget
		-- Set some initial positions
		self.bloom_widget:SetPosition(-867, -510, 4)
		self.bloom_widget:SetScale(0.75)
		if dragableConf == 1 then
			DragableFn(self, self.bloom_widget)
		end
		local function OnSetPlayerMode(self)
			if self.on_bloom_delta == nil then
				self.on_bloom_delta = function(owner, data) self:BloomDelta(data) end
				self.inst:ListenForEvent("bloom_delta", self.on_bloom_delta, self.owner)
				if self.owner.components.orchidacite ~= nil then
					self:SetBloomPercent(self.owner.components.orchidacite:GetPercent("bloom"))
				end
			end
		end
		function self:SetBloomPercent(pct)
			if self.owner.components.orchidacite ~= nil then
				self.bloom_widget:SetPercent(pct, self.owner.components.orchidacite.max_bloom)
			end		
		end
		function self:BloomDelta(data)
			self:SetBloomPercent(data.newpercent)
		end
		OnSetPlayerMode(self)
	end	
	return self
end
AddClassPostConstruct("widgets/statusdisplays", BloomFn)