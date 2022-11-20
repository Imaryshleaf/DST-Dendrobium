local Image = require "widgets/image"
local Widget = require "widgets/widget"
local Button = require "widgets/button"
local Text = require "widgets/text"

local RADEWB = 175
local WSCALE = .32
local WBNAME = "Dendrobium Widgets"

local Dendrobium_WB_BD = Class(Button, function(self, owner)
	Button._ctor(self, "BloomDomainButton")
	
	local stringwb = "Bloom Domain"
	local atlasimg = "character/skills/buttons/bloom_domain.xml"
	local imagetex = "bloom_domain.tex"
	local focustex = "bloom_domain.tex"
	local wdbevent = "bloomd_event"
	local wskillcd = 20
	
	self.image = self:AddChild(Image())
    self.image:SetTexture(atlasimg, imagetex, focustex) 

	self.nums = self.image:AddChild(Text(BODYTEXTFONT, 50))
	self.nums:SetHAlign(ANCHOR_MIDDLE)
	self.nums:MoveToFront()

	self.click = true
	local function DisplayCooldownfn(inst)
		inst.wdbevent_bloomd_event = inst:DoPeriodicTask(0, function() --Diff
		
			if not inst.bloomd_eventcd then 
				return false --Diff
			end
			
			local timeleft = inst.bloomd_eventcd:value() or 0
			self.nums:SetString(string.format("%.1f", timeleft))
			
			if timeleft > 0 then
				self.nums:Show()
				self.click = false
			else
				self.nums:Hide()
				self.click = true
			end
		end)
	end
	self:SetOnClick(function()
		if not self.click then return false end
		if owner.components.chronometer ~= nil then
			owner.components.chronometer:StartTimer("bloomd_eventcd", wskillcd)
			owner:PushEvent(wdbevent)
			DisplayCooldownfn(owner)
			owner:DoTaskInTime(wskillcd+.2, function()
				if owner.wdbevent_bloomd_event ~= nil then
					owner.wdbevent_bloomd_event:Cancel()
					owner.wdbevent_bloomd_event = nil
				end
			end)
		end
	end)
end)

local Dendrobium_WB_HD = Class(Button, function(self, owner)
	Button._ctor(self, "HealingDomainButton")
	
	local stringwb = "Healing Domain"
	local atlasimg = "character/skills/buttons/healing_domain.xml"
	local imagetex = "healing_domain.tex"
	local focustex = "healing_domain.tex"
	local wdbevent = "healingd_event"
	local wskillcd = 3
	
	self.image = self:AddChild(Image())
    self.image:SetTexture(atlasimg, imagetex, focustex) 

	self.nums = self.image:AddChild(Text(BODYTEXTFONT, 50))
	self.nums:SetHAlign(ANCHOR_MIDDLE)
	self.nums:MoveToFront()

	self.click = true
	local function DisplayCooldownfn(inst)
		inst.wdbevent_healingd_event = inst:DoPeriodicTask(0, function() --Diff
		
			if not inst.healingd_eventcd then 
				return false --Diff
			end
			
			local timeleft = inst.healingd_eventcd:value() or 0
			self.nums:SetString(string.format("%.1f", timeleft))
			
			if timeleft > 0 then
				self.nums:Show()
				self.click = false
			else
				self.nums:Hide()
				self.click = true
			end
		end)
	end
	self:SetOnClick(function()
		if not self.click then return false end
		if owner.components.chronometer ~= nil then
			owner.components.chronometer:StartTimer("healingd_eventcd", wskillcd)
			owner:PushEvent(wdbevent)
			DisplayCooldownfn(owner)
			owner:DoTaskInTime(wskillcd+.2, function()
				if owner.wdbevent_healingd_event ~= nil then
					owner.wdbevent_healingd_event:Cancel()
					owner.wdbevent_healingd_event = nil
				end
			end)
		end
	end)
end)


local Dendrobium_WB_SG = Class(Button, function(self, owner)
	Button._ctor(self, "ShadowGuardianButton")
	
	local stringwb = "Shadow Guardian"
	local atlasimg = "character/skills/buttons/shadow_guardian.xml"
	local imagetex = "shadow_guardian.tex"
	local focustex = "shadow_guardian.tex"
	local wdbevent = "shadowg_event"
	local wskillcd = 2
	
	self.image = self:AddChild(Image())
    self.image:SetTexture(atlasimg, imagetex, focustex) 

	self.nums = self.image:AddChild(Text(BODYTEXTFONT, 50))
	self.nums:SetHAlign(ANCHOR_MIDDLE)
	self.nums:MoveToFront()

	self.click = true
	local function DisplayCooldownfn(inst)
		inst.wdbevent_shadowg_event = inst:DoPeriodicTask(0, function() --Diff
		
			if not inst.shadowg_eventcd then 
				return false --Diff
			end
			
			local timeleft = inst.shadowg_eventcd:value() or 0
			self.nums:SetString(string.format("%.1f", timeleft))
			
			if timeleft > 0 then
				self.nums:Show()
				self.click = false
			else
				self.nums:Hide()
				self.click = true
			end
		end)
	end
	self:SetOnClick(function()
		if not self.click then return false end
		if owner.components.chronometer ~= nil then
			owner.components.chronometer:StartTimer("shadowg_eventcd", wskillcd)
			owner:PushEvent(wdbevent)
			DisplayCooldownfn(owner)
			owner:DoTaskInTime(wskillcd+.2, function()
				if owner.wdbevent_shadowg_event ~= nil then
					owner.wdbevent_shadowg_event:Cancel()
					owner.wdbevent_shadowg_event = nil
				end
			end)
		end
	end)
end)

local Dendrobium_WB_SW = Class(Button, function(self, owner)
	Button._ctor(self, "ShadowWorkerButton")
	
	local stringwb = "Shadow Worker"
	local atlasimg = "character/skills/buttons/shadow_worker.xml"
	local imagetex = "shadow_worker.tex"
	local focustex = "shadow_worker.tex"
	local wdbevent = "shadoww_event"
	local wskillcd = 2
	
	self.image = self:AddChild(Image())
    self.image:SetTexture(atlasimg, imagetex, focustex) 

	self.nums = self.image:AddChild(Text(BODYTEXTFONT, 50))
	self.nums:SetHAlign(ANCHOR_MIDDLE)
	self.nums:MoveToFront()

	self.click = true
	local function DisplayCooldownfn(inst)
		inst.wdbevent_shadoww_event = inst:DoPeriodicTask(0, function() --Diff
		
			if not inst.shadoww_eventcd then 
				return false --Diff
			end
			
			local timeleft = inst.shadoww_eventcd:value() or 0
			self.nums:SetString(string.format("%.1f", timeleft))
			
			if timeleft > 0 then
				self.nums:Show()
				self.click = false
			else
				self.nums:Hide()
				self.click = true
			end
		end)
	end
	self:SetOnClick(function()
		if not self.click then return false end
		if owner.components.chronometer ~= nil then
			owner.components.chronometer:StartTimer("shadoww_eventcd", wskillcd)
			owner:PushEvent(wdbevent)
			DisplayCooldownfn(owner)
			owner:DoTaskInTime(wskillcd+.2, function()
				if owner.wdbevent_shadoww_event ~= nil then
					owner.wdbevent_shadoww_event:Cancel()
					owner.wdbevent_shadoww_event = nil
				end
			end)
		end
	end)
end)

local Dendrobium_WB_SA = Class(Button, function(self, owner)
	Button._ctor(self, "SneakAttackButton")
	
	local stringwb = "Sneak Attack"
	local atlasimg = "character/skills/buttons/sneak_attack.xml"
	local imagetex = "sneak_attack.tex"
	local focustex = "sneak_attack.tex"
	local wdbevent = "sneaka_event"
	local wskillcd = 5
	
	self.image = self:AddChild(Image())
    self.image:SetTexture(atlasimg, imagetex, focustex) 

	self.nums = self.image:AddChild(Text(BODYTEXTFONT, 50))
	self.nums:SetHAlign(ANCHOR_MIDDLE)
	self.nums:MoveToFront()

	self.click = true
	local function DisplayCooldownfn(inst)
		inst.wdbevent_sneaka_event = inst:DoPeriodicTask(0, function() --Diff
		
			if not inst.sneaka_eventcd then 
				return false --Diff
			end
			
			local timeleft = inst.sneaka_eventcd:value() or 0
			self.nums:SetString(string.format("%.1f", timeleft))
			
			if timeleft > 0 then
				self.nums:Show()
				self.click = false
			else
				self.nums:Hide()
				self.click = true
			end
		end)
	end
	self:SetOnClick(function()
		if not self.click then return false end
		if owner.components.chronometer ~= nil then
			owner.components.chronometer:StartTimer("sneaka_eventcd", wskillcd)
			owner:PushEvent(wdbevent)
			DisplayCooldownfn(owner)
			owner:DoTaskInTime(wskillcd+.2, function()
				if owner.wdbevent_sneaka_event ~= nil then
					owner.wdbevent_sneaka_event:Cancel()
					owner.wdbevent_sneaka_event = nil
				end
			end)
		end
	end)
end)

local Dendrobium_WB_TT = Class(Button, function(self, owner)
	Button._ctor(self, "TreasureTrackerButton")
	
	local stringwb = "Treasure Tracker"
	local atlasimg = "character/skills/buttons/treasure_tracker.xml"
	local imagetex = "treasure_tracker.tex"
	local focustex = "treasure_tracker.tex"
	local wdbevent = "treasuret_event"
	local wskillcd = 10
	
	self.image = self:AddChild(Image())
    self.image:SetTexture(atlasimg, imagetex, focustex) 

	self.nums = self.image:AddChild(Text(BODYTEXTFONT, 50))
	self.nums:SetHAlign(ANCHOR_MIDDLE)
	self.nums:MoveToFront()

	self.click = true
	local function DisplayCooldownfn(inst)
		inst.wdbevent_treasuret_event = inst:DoPeriodicTask(0, function() --Diff
		
			if not inst.treasuret_eventcd then 
				return false --Diff
			end
			
			local timeleft = inst.treasuret_eventcd:value() or 0
			self.nums:SetString(string.format("%.1f", timeleft))
			
			if timeleft > 0 then
				self.nums:Show()
				self.click = false
			else
				self.nums:Hide()
				self.click = true
			end
		end)
	end
	self:SetOnClick(function()
		if not self.click then return false end
		if owner.components.chronometer ~= nil then
			owner.components.chronometer:StartTimer("treasuret_eventcd", wskillcd)
			owner:PushEvent(wdbevent)
			DisplayCooldownfn(owner)
			owner:DoTaskInTime(wskillcd+.2, function()
				if owner.wdbevent_treasuret_event ~= nil then
					owner.wdbevent_treasuret_event:Cancel()
					owner.wdbevent_treasuret_event = nil
				end
			end)
		end
	end)
end)

BUTTON_TABLE = {
	BUTTONLISTS = {
		{
			WBType = Dendrobium_WB_BD
		},
		{
			WBType = Dendrobium_WB_HD
		},
		{
			WBType = Dendrobium_WB_SG
		},
		{
			WBType = Dendrobium_WB_SW
		},
		{
			WBType = Dendrobium_WB_SA
		},
		{
			WBType = Dendrobium_WB_TT
		},
	}
}

local skill_sets = {}
table.insert(skill_sets, BUTTON_TABLE)

local Dendrobium_WW = Class(Widget, function(self, owner, skillsets, str)
	Widget._ctor(self, "Dendrobium-Widget-Wheel")
	self:SetScale(WSCALE, WSCALE, WSCALE)
	self:SetHAnchor(2)
	self:SetVAnchor(2)
	
	self.texts = self:AddChild(Text(NUMBERFONT, 40))
	self.texts:SetVAlign(ANCHOR_MIDDLE)
	self.texts:SetString(str)

	self.owner = owner
	self.root = self:AddChild(Widget("root"))
	self.gestures = {}
	self.wheels = {}
	self.activewheel = nil
	
	local function BuildWheel(name, buttonlist, radius, scale)
		local wheel = self.root:AddChild(Widget("DWW-"..name))
		wheel:SetScale(1)
		table.insert(self.wheels, wheel)
		local count = #buttonlist
		radius = radius * scale
		wheel.radius = radius
		local delta = 2*math.pi/count
		local theta = 0
		wheel.gestures = {}
		for i, v in ipairs(buttonlist) do
			local gesture = wheel:AddChild(v.WBType(owner))
			gesture:SetPosition(radius*math.cos(theta),radius*math.sin(theta), 0)
			gesture:SetScale(scale)
			theta = theta + delta
		end
	end
	
	-- Sort the skill sets in order of decreasing radius
	table.sort(skillsets, function(a,b) return a.radius > b.radius end)
	local scale = 1
	for _, skllist in ipairs(skillsets) do
		BuildWheel(WBNAME, skllist.BUTTONLISTS, RADEWB, scale)
		scale = scale * 0.85
	end
end)

local handlers_applied = false
KEYBOARDTOGGLEKEY = GetModConfigData("KEYBOARDTOGGLEKEY") or "R"
if type(KEYBOARDTOGGLEKEY) == "string" then
	KEYBOARDTOGGLEKEY = KEYBOARDTOGGLEKEY:lower():byte()
end
AddClassPostConstruct("widgets/controls", function(self)
	if self.owner and self.owner.prefab == "dendrobium" then
		self.gesturewheel = self:AddChild(Dendrobium_WW(self.owner, skill_sets))
		
		local function ResetTransform()
			local screenwidth, screenheight = GLOBAL.TheSim:GetScreenSize()
			local centerx = math.floor(screenwidth/2)
			local centery = math.floor(screenheight/2)
			self.gesturewheel:SetPosition(-centerx, centery, 0)
		end
		
		ResetTransform()
		self.gesturewheel:Hide()
		
		if not handlers_applied then
			handlers_applied = true
			GLOBAL.TheInput:AddKeyDownHandler(KEYBOARDTOGGLEKEY, function()
				ResetTransform()
				self.gesturewheel:Show()
			end)
			GLOBAL.TheInput:AddKeyUpHandler(KEYBOARDTOGGLEKEY, function()
				self.gesturewheel:Hide()
			end)
		end
		
	end
end)

--[[ -- v3 (No idea how to make them clicable for each button)
SKILL_TABLE = {
	name = "MySkillList",
	buttonlists = {
		{
			name = "myskill1",
			atlas = "character/skills/buttons/myskill1.xml",
			image = "myskill1.tex",
			event = "myskill1e",
		},
		{
			name = "myskill2",
			atlas = "character/skills/buttons/myskill2.xml",
			image = "myskill2.tex",
			event = "myskill2e",
		},
	},
	radius = 175
}

local Dendrobium_WB = Class(Button, function(self, owner, atlas, normal_tex, focus_tex)
	Button._ctor(self, "Dendrobium-Buttons")

	self.image = self:AddChild(Image())
    self.image:SetTexture(atlas, normal_tex, focus_tex) 

	self.nums = self.image:AddChild(Text(BODYTEXTFONT, 60))
	self.nums:SetHAlign(ANCHOR_MIDDLE)
	self.nums:MoveToFront()
	
	self.owner = owner
end)

local Dendrobium_WW = Class(Widget, function(self, owner, skillsets, str)
	Widget._ctor(self, "Dendrobium-Widgets")
	self:SetScale(.32, .32, .32)
	self:SetHAnchor(2)
	self:SetVAnchor(2)
	-- self:Hide()
	
	self.texts = self:AddChild(Text(NUMBERFONT, 40))
	self.texts:SetVAlign(ANCHOR_MIDDLE)
	self.texts:SetString(str)

	self.owner = owner
	self.root = self:AddChild(Widget("root"))
	self.gestures = {}
	self.wheels = {}
	self.activewheel = nil
	
	local function BuildWheel(name, buttonlist, radius, scale)
		local wheel = self.root:AddChild(Widget("Dendrobium_WW-"..name))
		wheel:SetScale(1)
		table.insert(self.wheels, wheel)
		if name == "default" then
			self.activewheel = #self.wheels
		end
		local count = #buttonlist
		radius = radius * scale
		wheel.radius = radius
		local delta = 2*math.pi/count
		local theta = 0
		wheel.gestures = {}
		for i, v in ipairs(buttonlist) do
			local gesture = wheel:AddChild(Dendrobium_WB(self, v.atlas, v.image, v.image))
			gesture:SetPosition(radius*math.cos(theta),radius*math.sin(theta), 0)
			gesture:SetScale(scale)
			self.gestures[v.name] = gesture
			wheel.gestures[v.name] = gesture
			theta = theta + delta
		end
	end
	-- Sort the skill sets in order of decreasing radius
	table.sort(skillsets, function(a,b) return a.radius > b.radius end)
	local scale = 1
	for _, skllist in ipairs(skillsets) do
		BuildWheel(skllist.name, skllist.buttonlists, skllist.radius, scale)
		scale = scale * 0.85
	end
end)

local skill_sets = {}
table.insert(skill_sets, SKILL_TABLE)
AddClassPostConstruct("widgets/controls", function(self)
	if self.owner and self.owner.prefab == "dendrobium" then
		self.gesturewheel = self:AddChild(Dendrobium_WW(self.owner, skill_sets, "Skills"))
		local screenwidth, screenheight = GLOBAL.TheSim:GetScreenSize()
		local centerx = math.floor(screenwidth/2)
		local centery = math.floor(screenheight/2)
		self.gesturewheel:SetPosition(-centerx, centery, 0)
		-- self.gesturewheel:Hide()
	end
end)
]]

--[[ -- v2 (no idea how to positioning the widget neatly)
local w1atlas = "character/skills/buttons/healing_domain.xml"
local w1image = "healing_domain.tex"
local w2atlas = "character/skills/buttons/shadow_guardian.xml"
local w2image = "shadow_guardian.tex"

local Dendrobium_WW = Class(Widget, function(self, owner, atl, img, ix, iy, iz, str)
	Widget._ctor(self, "Dendrobium_WW")
	self:SetScale(.3, .3, .3)

	self:SetHAnchor(2)
	self:SetVAnchor(2)

	self.images = self:AddChild(Image(atl, img))
	self.images:SetPosition(ix, iy, iz)
	
	self.nums = self.images:AddChild(Text(BODYTEXTFONT, 60))
	self.nums:SetHAlign(ANCHOR_MIDDLE)
	self.nums:MoveToFront()
	
	self.texts = self.images:AddChild(Text(NUMBERFONT, 40))
	self.texts:SetVAlign(ANCHOR_MIDDLE)
	self.texts:SetString(str)

	self.owner = owner
end)
AddClassPostConstruct("widgets/controls", function(self)
	local inst = self.owner
	if self.owner and self.owner.prefab == "dendrobium" then
		self.w1b = self:AddChild(Dendrobium_WW(inst, w1atlas, w1image, -400, 500,0, "HD"))
		self.w2b = self:AddChild(Dendrobium_WW(inst, w2atlas, w2image, -600, 500,0, "SG"))
	end
end)
]]


--[[ -- v1 (learning how to make my own)
local Dendrobium_WW = Class(Button, function(self, owner, atlas, normal_tex, focus_tex, x,y,z, str)
	Button._ctor(self, "Dendrobium_WW")
	self:SetScale(.3, .3, .3)
	self:SetPosition(x, y, z)
	
	self.image = self:AddChild(Image())
    self.image:SetTexture(atlas, normal_tex, focus_tex)
	
	self.texts = self:AddChild(Text(NUMBERFONT, 40))
	self.texts:SetVAlign(ANCHOR_MIDDLE)
	self.texts:SetString(str)
end)
AddClassPostConstruct("widgets/controls", function(self)
	local inst = self.owner
	if self.owner and self.owner.prefab == "dendrobium" then
		self.w1 = self:AddChild(Dendrobium_WW(inst, w1atlas, w1image, w1image, 35,37,0, "HD"))
		self.w2 = self:AddChild(Dendrobium_WW(inst, w2atlas, w2image, w2image, 95,37,0, "SG"))
	end
end)
]]

return Dendrobium_WW