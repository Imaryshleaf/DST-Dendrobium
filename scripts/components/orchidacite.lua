local function on_max_energy(self, max_energy) if self.inst.widget_energy_max then self.inst.widget_energy_max:set(max_energy) end end
local function on_min_energy(self, min_energy) if self.inst.widget_energy_min then self.inst.widget_energy_min:set(min_energy/self.max_energy) end end
local function on_max_shield(self, max_shield) if self.inst.widget_shield_max then self.inst.widget_shield_max:set(max_shield) end end
local function on_min_shield(self, min_shield) if self.inst.widget_shield_min then self.inst.widget_shield_min:set(min_shield/self.max_shield) end end
local function on_max_magic(self, max_magic) if self.inst.widget_magic_max then self.inst.widget_magic_max:set(max_magic) end end
local function on_min_magic(self, min_magic) if self.inst.widget_magic_min then self.inst.widget_magic_min:set(min_magic/self.max_magic) end end
local function on_max_quantum(self, max_quantum) if self.inst.widget_quantum_max then self.inst.widget_quantum_max:set(max_quantum) end end
local function on_min_quantum(self, min_quantum) if self.inst.widget_quantum_min then self.inst.widget_quantum_min:set(min_quantum/self.max_quantum) end end

local Orchidacite = Class(function(self, inst)
	self.inst = inst
	self.orchidaceae = true
	self.SecondForm = "FALSE"
	self.InitStrings = "Flowers and Diamonds"
	self.inst.spellpower_count = 0
	
	self.max_levelxp = 30375
	self.min_levelxp = 0
	self.max_treasure = 100
	self.min_treasure = 0
	self.max_bloom = 100
	self.min_bloom = 0
	
	self.max_energy = 100
	self.min_energy = 0
	self.max_shield = 100
	self.min_shield = 0
	self.max_magic = 100
	self.min_magic = 0
	self.max_quantum = 100
	self.min_quantum = 0
end,nil,{
	max_energy = on_max_energy,
	min_energy = on_min_energy,
	max_shield = on_max_shield,
	min_shield = on_min_shield,
	max_magic = on_max_magic,
	min_magic = on_min_magic,
	max_quantum = on_max_quantum,
	min_quantum = on_min_quantum
})

function Orchidacite:OnSave()
	return {
		SecondForm = self.SecondForm or nil,

		max_levelxp = self.max_levelxp,
		min_levelxp = self.min_levelxp or nil,
		max_treasure = self.max_treasure,
		min_treasure = self.min_treasure or nil,
		max_bloom = self.max_bloom,
		min_bloom = self.min_bloom or nil,

		max_energy = self.max_energy,
		min_energy = self.min_energy or nil,
		max_shield = self.max_shield,
		min_shield = self.min_shield or nil,
		max_magic = self.max_magic,
		min_magic = self.min_magic or nil,
		max_quantum = self.max_quantum,
		min_quantum = self.min_quantum or nil
	}
end

function Orchidacite:OnLoad(data)
	local owner = self.inst
	if data ~= nil then
		self.SecondForm = data.SecondForm
		if data.SecondForm == "TRUE" then self:MorphUp() elseif data.SecondForm == "FALSE" then self:MorphDown() end
		owner.components.health:DoDelta(0) 
		owner.components.sanity:DoDelta(0)

		self.max_levelxp = data.max_levelxp
		self.min_levelxp = data.min_levelxp
		self:DoDelta("levelxp", 0)
		self.max_treasure = data.max_treasure
		self.min_treasure = data.min_treasure
		self:DoDelta("treasure", 0)
		self.max_bloom = data.max_bloom
		self.min_bloom = data.min_bloom
		self:DoDelta("bloom", 0)

		self.max_energy = data.max_energy
		self.min_energy = data.min_energy
		self:DoDelta("energy", 0)
		self.max_shield = data.max_shield
		self.min_shield = data.min_shield
		self:DoDelta("shield", 0)
		self.max_magic = data.max_magic
		self.min_magic = data.min_magic
		self:DoDelta("magic", 0)
		self.max_quantum = data.max_quantum
		self.min_quantum = data.min_quantum
		self:DoDelta("quantum", 0)
	end
end

function Orchidacite:HasCharge(stype)
	if stype == "levelxp" then return self.min_levelxp > 0 end
	if stype == "treasure" then return self.min_treasure > 0 end
	if stype == "bloom" then return self.min_bloom > 0 end
	
	if stype == "energy" then return self.min_energy > 0 end
	if stype == "shield" then return self.min_shield > 0 end
	if stype == "magic" then return self.min_magic > 0 end
	if stype == "quantum" then return self.min_quantum > 0 end
end
function Orchidacite:IsDepleted(stype)
	if stype == "levelxp" then return self.min_levelxp < 1 end
	if stype == "treasure" then return self.min_treasure < 1 end
	if stype == "bloom" then return self.min_bloom < 1 end
	
	if stype == "energy" then return self.min_energy < 1 end
	if stype == "shield" then return self.min_shield < 1 end
	if stype == "magic" then return self.min_magic < 1 end
	if stype == "quantum" then return self.min_quantum < 1 end
end

function Orchidacite:GetPercent(stype)
	if stype == "levelxp" then return self.min_levelxp / self.max_levelxp end
	if stype == "treasure" then return self.min_treasure / self.max_treasure end
	if stype == "bloom" then return self.min_bloom / self.max_bloom end
	
	if stype == "energy" then return self.min_energy / self.max_energy end
	if stype == "shield" then return self.min_shield / self.max_shield end
	if stype == "magic" then return self.min_magic / self.max_magic end
	if stype == "quantum" then return self.min_quantum / self.max_quantum end
end
function Orchidacite:SetMax(stype, amount)
	if stype == "levelxp" then self.max_levelxp = amount; self.min_levelxp = amount; end
	if stype == "treasure" then self.max_treasure = amount; self.min_treasure = amount; end
	if stype == "bloom" then self.max_bloom = amount; self.min_bloom = amount; end
	
	if stype == "energy" then self.max_energy = amount; self.min_energy = amount; if self.inst.widget_energy_max then self.inst.widget_energy_max:set(amount) end end
	if stype == "shield" then self.max_shield = amount; self.min_shield = amount; if self.inst.widget_shield_max then self.inst.widget_shield_max:set(amount) end end
	if stype == "magic" then self.max_magic = amount; self.min_magic = amount; if self.inst.widget_magic_max then self.inst.widget_magic_max:set(amount) end end
	if stype == "quantum" then self.max_quantum = amount; self.min_quantum = amount; if self.inst.widget_quantum_max then self.inst.widget_quantum_max:set(amount) end end
end
function Orchidacite:SetPercent(stype, p, overtime)
	if stype == "levelxp" then local old = self.min_levelxp; self.min_levelxp  = p * self.max_levelxp; self.inst:PushEvent("levelxp_delta", { oldpercent = old / self.max_levelxp, newpercent = p, overtime = overtime }) end
	if stype == "treasure" then local old = self.min_treasure; self.min_treasure  = p * self.max_treasure; self.inst:PushEvent("treasure_delta", { oldpercent = old / self.max_treasure, newpercent = p, overtime = overtime }) end
	if stype == "bloom" then local old = self.min_bloom; self.min_bloom  = p * self.max_bloom; self.inst:PushEvent("bloom_delta", { oldpercent = old / self.max_bloom, newpercent = p, overtime = overtime }) end
	
	if stype == "energy" then local old = self.min_energy; self.min_energy  = p * self.max_energy; self.inst:PushEvent("energy_delta", { oldpercent = old / self.max_energy, newpercent = p, overtime = overtime }) end
	if stype == "shield" then local old = self.min_shield; self.min_shield  = p * self.max_shield; self.inst:PushEvent("shield_delta", { oldpercent = old / self.max_shield, newpercent = p, overtime = overtime }) end
	if stype == "magic" then local old = self.min_magic; self.min_magic  = p * self.max_magic; self.inst:PushEvent("magic_delta", { oldpercent = old / self.max_magic, newpercent = p, overtime = overtime }) end
	if stype == "quantum" then local old = self.min_quantum; self.min_quantum  = p * self.max_quantum; self.inst:PushEvent("quantum_delta", { oldpercent = old / self.max_quantum, newpercent = p, overtime = overtime }) end
end

function Orchidacite:DoDelta(stype, delta, overtime, ignore_invincible)
    if not ignore_invincible and (self.inst.components.health.invincible == true and not self.inst.sg:HasStateTag("tent")) or self.inst.is_teleporting == true then
        return
    end
	if stype == "levelxp" then local old = self.min_levelxp; local new = math.clamp(self.min_levelxp + delta, 0, self.max_levelxp); self.min_levelxp = new; self.inst:PushEvent("levelxp_delta", { oldpercent = old / self.max_levelxp, newpercent = self.min_levelxp / self.max_levelxp, overtime = overtime }) end
	if stype == "treasure" then local old = self.min_treasure; local new = math.clamp(self.min_treasure + delta, 0, self.max_treasure); self.min_treasure = new; self.inst:PushEvent("treasure_delta", { oldpercent = old / self.max_treasure, newpercent = self.min_treasure / self.max_treasure, overtime = overtime }) end
	if stype == "bloom" then local old = self.min_bloom; local new = math.clamp(self.min_bloom + delta, 0, self.max_bloom); self.min_bloom = new; self.inst:PushEvent("bloom_delta", { oldpercent = old / self.max_bloom, newpercent = self.min_bloom / self.max_bloom, overtime = overtime }) end
	
	if stype == "energy" then local old = self.min_energy; local new = math.clamp(self.min_energy + delta, 0, self.max_energy); self.min_energy = new; self.inst:PushEvent("energy_delta", { oldpercent = old / self.max_energy, newpercent = self.min_energy / self.max_energy, overtime = overtime }) end
	if stype == "shield" then local old = self.min_shield; local new = math.clamp(self.min_shield + delta, 0, self.max_shield); self.min_shield = new; self.inst:PushEvent("shield_delta", { oldpercent = old / self.max_shield, newpercent = self.min_shield / self.max_shield, overtime = overtime }) end
	if stype == "magic" then local old = self.min_magic; local new = math.clamp(self.min_magic + delta, 0, self.max_magic); self.min_magic = new; self.inst:PushEvent("magic_delta", { oldpercent = old / self.max_magic, newpercent = self.min_magic / self.max_magic, overtime = overtime }) end
	if stype == "quantum" then local old = self.min_quantum; local new = math.clamp(self.min_quantum + delta, 0, self.max_quantum); self.min_quantum = new; self.inst:PushEvent("quantum_delta", { oldpercent = old / self.max_quantum, newpercent = self.min_quantum / self.max_quantum, overtime = overtime }) end
end

--------------------------------------------------------------------------------------------------------------------------------
function Orchidacite:LoadStatus(bool)
	local owner = self.inst
	if bool == true then
		self:OnAttacked(owner)
		self:OnBecameHuman(owner)
		self:OnBecameGhost(owner)
		self:OnRespawnFromGhost(owner)
	end
end

function Orchidacite:MorphUp()
	self.SecondForm = "TRUE"
	self.inst:AddTag("SecondForm")
	self.inst:AddTag("fastbuilder")
	self.inst:PushEvent("Transform[UP]")
	self.inst:DoTaskInTime(1, self.inst.sg:GoToState("TransformSG"))
	SpawnPrefab("statue_transition_2").Transform:SetPosition(self.inst:GetPosition():Get())
end

function Orchidacite:MorphDown()
	self.SecondForm = "FALSE"
	self.inst:RemoveTag("SecondForm")
	self.inst:RemoveTag("fastbuilder")
	self.inst:PushEvent("Transform[Down]")
	SpawnPrefab("fx_elec_charged").Transform:SetPosition(self.inst:GetPosition():Get())
end

-- Attacked
function Orchidacite:OnAttacked(owner)
	local SHIELD_COOLDOWN = 0.2
	owner:ListenForEvent("attacked", function(inst, data)
	inst.components.orchidacite:DoDelta("shield", -1)
		-- 2nd form
		if inst:HasTag("SecondForm") then
			if not inst.IsBattleMode and not TheWorld.state.isfullmoon then
			inst.IsBattleMode = true;
				inst.QuantumRegenT = inst:DoPeriodicTask(1, function()
					inst.components.orchidacite:DoDelta("quantum", 0.5)
				end) inst.QuantumRegen = true
				inst:DoTaskInTime(5, function()
					inst.IsBattleMode = false
					inst.QuantumRegen = false
					if inst.QuantumRegenT ~= nil then
						inst.QuantumRegenT:Cancel()
						inst.QuantumRegenT = nil
					end
				end)
			end
		-- 1st form
		elseif not inst:HasTag("SecondForm") then
			if not inst.IsBattleMode and not TheWorld.state.isfullmoon then
			inst.IsBattleMode = true;
				inst.QuantumRegenT = inst:DoPeriodicTask(1, function()
					inst.components.orchidacite:DoDelta("quantum", 1)
				end) inst.QuantumRegen = true
				inst:DoTaskInTime(5, function()
					inst.IsBattleMode = false
					inst.QuantumRegen = false
					if inst.QuantumRegenT ~= nil then
						inst.QuantumRegenT:Cancel()
						inst.QuantumRegenT = nil
					end
				end)
			end
		end
		-- Block All Damage
		if inst.OpenShield and not inst.UseShield then
			inst.UseShield = true; 
			local fx = SpawnPrefab("fx_dark_forcefield")
				fx.entity:SetParent(inst.entity)
				fx.Transform:SetPosition(0, 0.2, 0)
			if inst.components.rider ~= nil and inst.components.rider:IsRiding() then
				fx.Transform:SetScale(2, 2, 2) else fx.Transform:SetScale(0.8, 0.8, 0.8)
			end
			-- Temporary Invicible
			inst:AddTag("blockingdamage")
			inst.components.health:SetInvincible(true)
			local fx_hitanim = function()
				fx.AnimState:PlayAnimation("hit")
				fx.AnimState:PushAnimation("idle_loop")	end
				fx:ListenForEvent("blocked", fx_hitanim, inst)
			local duration = 10
			inst:DoTaskInTime(duration, function()
				fx:RemoveEventCallback("blocked", fx_hitanim, inst)
				if inst:IsValid() then 
					fx.kill_fx(fx)
					inst.components.health:SetInvincible(false)
					inst:RemoveTag("blockingdamage")
					inst.ShieldMaxCharge = false
				end 
				inst.components.health:DoDelta(30)
			end)
		end
		-- Dark Armor (Cold shield - 2nd)
		if inst:HasTag("SecondForm") and not inst.components.orchidacite:IsDepleted("shield") then
			local fx_1 = SpawnPrefab("fx_dark_shield")
				  fx_1.Transform:SetScale(0.30, 0.30, 0.30)
				  fx_1.Transform:SetPosition(inst:GetPosition():Get())
			local fx_2 = SpawnPrefab("fx_fire_ring") 
				  fx_2.Transform:SetScale(0.5, 0.5, 0.5)
				  fx_2.Transform:SetPosition(inst:GetPosition():Get())
			-- 
			local other = data.attacker
			if other and other.components.health and not other.components.health:IsDead() then
				if other.components.freezable then
					other.components.freezable:AddColdness(0.5)
					other.components.freezable:SpawnShatterFX()
				elseif not other.components.freezable then
					other.components.health:DoDelta(-5)
					SpawnPrefab("sparks").Transform:SetPosition(other:GetPosition():Get())
				end
			end
		-- Spark Armor (Sparks - 1st)
		elseif not inst:HasTag("SecondForm") and not inst.components.orchidacite:IsDepleted("shield") then
			local fx1 = SpawnPrefab("fx_spin_electric")
			local fx2 = SpawnPrefab("fx_elec_charged")
				if (fx1 or fx2) then
					if (fx1:IsValid() or fx2:IsValid()) then
						fx1.entity:SetParent(inst.entity)
						fx2.entity:SetParent(inst.entity)
						inst:DoTaskInTime(0.25, function(inst) local fx2 = SpawnPrefab("fx_elec_charged") fx2.entity:SetParent(inst.entity) fx2.Transform:SetScale(0.75, 0.75, 0.75) end)
						inst:DoTaskInTime(1, function(inst) local fx2 = SpawnPrefab("fx_elec_charged") fx2.entity:SetParent(inst.entity) fx2.Transform:SetScale(0.75, 0.75, 0.75) end)
					end	
				end
			fx1.Transform:SetScale(0.75, 0.75, 0.75)
			fx2.Transform:SetScale(0.75, 0.75, 0.75)
			-- Sparks shield
			local other = data.attacker
			if other and other.components.burnable ~= nil and other.components.health ~= nil and not other:HasTag("thorny") and not other:HasTag("shadowcreature") and other.components.combat ~= nil then
				other.components.health:DoDelta(-10)
				SpawnPrefab("sparks").Transform:SetPosition(other:GetPosition():Get())
			end
		end
	end)
end

-- Resume tasks
function Orchidacite:OnBecameHuman(owner)
	if owner:HasTag("playerghost") then
		return
	end
	owner.IsUpdatingSkin = true
	-- Regen stats
	owner.OnRegenPerSec = owner:DoPeriodicTask(1, function(inst)
		if self.min_energy < self.max_energy + 1 then
			if inst.sg:HasStateTag("resting") then
				self:DoDelta("energy", 1, true)
			end
		end
		if self.min_shield < self.max_shield + 1 then
			if inst.sg:HasStateTag("resting") then 
				self:DoDelta("shield", 1, true);
			end
		end
		if self.min_treasure < self.max_treasure + 1 then
			if inst.sg:HasStateTag("walking") or inst.sg:HasStateTag("moving") then 
				self:DoDelta("treasure", 0.25, true);
			end
		end
		if self.min_bloom < self.max_bloom + 1 then
			if not inst.sg:HasStateTag("attack") or inst.sg:HasStateTag("attacked") then 
				self:DoDelta("bloom", 0.1, true);
			end
		end
		if inst:HasTag("SecondForm") then
			if not self:IsDepleted("quantum") then
				self:DoDelta("quantum", -0.1, true);
			elseif self:IsDepleted("quantum") then
				self:MorphDown();
			end
		end
	end)
	-- Play anim up in badge, etc
	owner.OnTaskPerTick = owner:DoPeriodicTask(0.5, function(inst)
		if inst.sg:HasStateTag("walking") or inst.sg:HasStateTag("moving") then 
			inst.TreasureRegen = true else inst.TreasureRegen = false 
		end
		if not inst.sg:HasStateTag("attack") or inst.sg:HasStateTag("attacked") then 
			inst.BloomRegen = true else inst.BloomRegen = false
		end
		if owner.sg:HasStateTag("resting") then 
			owner.EnergyRegen = true inst.ShieldRegen = true
		else 
			owner.EnergyRegen = false inst.ShieldRegen = false
		end
		----- Visual Change
		if inst.IsUpdatingSkin then
			if not inst:HasTag("SecondForm") then
				if TheWorld.state.isautumn then
					if not inst.IsBattleMode and not --[[False]] inst.IsBlossomMode and not --[[False]]  inst.IsFullmoonMode and not --[[False]]  inst.IsHighMoisture then --[[False]] 
						inst.AnimState:SetBuild("dendrobium")
					elseif not inst.IsBattleMode and not --[[False]]  inst.IsBlossomMode and not --[[False]]  inst.IsFullmoonMode and --[[False]]  inst.IsHighMoisture then --[[True]] 
						inst.AnimState:SetBuild("dendrobium_blue")
					elseif inst.IsBattleMode and not --[[True]]  inst.IsBlossomMode and not --[[False]]  inst.IsFullmoonMode and not --[[False]]  inst.IsHighMoisture then --[[False]] 
						inst.AnimState:SetBuild("dendrobium_red")
					elseif not inst.IsBattleMode and  --[[False]]  inst.IsBlossomMode and not --[[True]]  inst.IsFullmoonMode and not --[[False]]  inst.IsHighMoisture then --[[False]] 
						inst.AnimState:SetBuild("dendrobium_green")
					elseif not inst.IsBattleMode and not --[[False]]  inst.IsBlossomMode and --[[False]]  inst.IsFullmoonMode and not --[[True]]  inst.IsHighMoisture then --[[False]] 
						inst.AnimState:SetBuild("dendrobium_black")
					end
				end
				if TheWorld.state.iswinter then
					if not inst.IsBattleMode and not --[[False]]  inst.IsBlossomMode and not --[[False]]  inst.IsFullmoonMode and not --[[False]]  inst.IsHighMoisture then --[[False]] 
						inst.AnimState:SetBuild("dendrobium_aquatic")
					elseif not inst.IsBattleMode and not --[[False]]  inst.IsBlossomMode and not --[[False]]  inst.IsFullmoonMode and --[[False]] inst.IsHighMoisture then --[[True]] 
						inst.AnimState:SetBuild("dendrobium_blue")
					elseif inst.IsBattleMode and not --[[True]]  inst.IsBlossomMode and not --[[False]]  inst.IsFullmoonMode and not --[[False]]  inst.IsHighMoisture then --[[False]] 
						inst.AnimState:SetBuild("dendrobium_red")
					elseif not inst.IsBattleMode and  --[[False]]  inst.IsBlossomMode and not --[[True]]  inst.IsFullmoonMode and not --[[False]] inst.IsHighMoisture then --[[False]] 
						inst.AnimState:SetBuild("dendrobium_green")
					elseif not inst.IsBattleMode and not --[[False]]  inst.IsBlossomMode and --[[False]]  inst.IsFullmoonMode and not --[[True]]  inst.IsHighMoisture then --[[False]] 
						inst.AnimState:SetBuild("dendrobium_black")
					end
				end
				if TheWorld.state.isspring then
					if not inst.IsBattleMode and not --[[False]]  inst.IsBlossomMode and not --[[False]]  inst.IsFullmoonMode and not --[[False]]  inst.IsHighMoisture then --[[False]] 
						inst.AnimState:SetBuild("dendrobium_purple")
					elseif not inst.IsBattleMode and not --[[False]] inst.IsBlossomMode and not --[[False]] inst.IsFullmoonMode and --[[False]]  inst.IsHighMoisture then --[[True]] 
						inst.AnimState:SetBuild("dendrobium_blue")
					elseif inst.IsBattleMode and not --[[True]] inst.IsBlossomMode and not --[[False]] inst.IsFullmoonMode and not --[[False]] inst.IsHighMoisture then --[[False]] 
						inst.AnimState:SetBuild("dendrobium_red")
					elseif not inst.IsBattleMode and  --[[False]] inst.IsBlossomMode and not --[[True]] inst.IsFullmoonMode and not --[[False]] inst.IsHighMoisture then --[[False]] 
						inst.AnimState:SetBuild("dendrobium_green")
					elseif not inst.IsBattleMode and not --[[False]] inst.IsBlossomMode and --[[False]] inst.IsFullmoonMode and not --[[True]] inst.IsHighMoisture then --[[False]] 
						inst.AnimState:SetBuild("dendrobium_black")
					end
				end
				if TheWorld.state.issummer then
					if not inst.IsBattleMode and not --[[False]] inst.IsBlossomMode and not --[[False]] inst.IsFullmoonMode and not --[[False]] inst.IsHighMoisture then --[[False]] 
						inst.AnimState:SetBuild("dendrobium_sun")
					elseif not inst.IsBattleMode and not --[[False]] inst.IsBlossomMode and not --[[False]] inst.IsFullmoonMode and --[[False]] inst.IsHighMoisture then --[[True]] 
						inst.AnimState:SetBuild("dendrobium_blue")
					elseif inst.IsBattleMode and not --[[True]] inst.IsBlossomMode and not --[[False]] inst.IsFullmoonMode and not --[[False]] inst.IsHighMoisture then --[[False]] 
						inst.AnimState:SetBuild("dendrobium_red")
					elseif not inst.IsBattleMode and  --[[False]] inst.IsBlossomMode and not --[[True]] inst.IsFullmoonMode and not --[[False]] inst.IsHighMoisture then --[[False]] 
						inst.AnimState:SetBuild("dendrobium_green")
					elseif not inst.IsBattleMode and not --[[False]] inst.IsBlossomMode and --[[False]] inst.IsFullmoonMode and not --[[True]] inst.IsHighMoisture then --[[False]] 
						inst.AnimState:SetBuild("dendrobium_black")
						end
					end
				end
			if inst:HasTag("SecondForm") then
				if TheWorld.state.isautumn then
					if not inst.IsBattleMode and not --[[False]] inst.IsBlossomMode and not --[[False]] inst.IsFullmoonMode and not --[[False]] inst.IsHighMoisture then --[[False]] 
						inst.AnimState:SetBuild("dendrobium_2nd")
					elseif not inst.IsBattleMode and not --[[False]] inst.IsBlossomMode and not --[[False]] inst.IsFullmoonMode and --[[False]] inst.IsHighMoisture then --[[True]] 
						inst.AnimState:SetBuild("dendrobium_blue_2nd")
					elseif inst.IsBattleMode and not --[[True]] inst.IsBlossomMode and not --[[False]] inst.IsFullmoonMode and not --[[False]] inst.IsHighMoisture then --[[False]] 
						inst.AnimState:SetBuild("dendrobium_red_2nd")
					elseif not inst.IsBattleMode and  --[[False]] inst.IsBlossomMode and not --[[True]] inst.IsFullmoonMode and not --[[False]] inst.IsHighMoisture then --[[False]] 
						inst.AnimState:SetBuild("dendrobium_green_2nd")
					elseif not inst.IsBattleMode and not --[[False]] inst.IsBlossomMode and --[[False]] inst.IsFullmoonMode and not --[[True]] inst.IsHighMoisture then --[[False]] 
						inst.AnimState:SetBuild("dendrobium_black_2nd")
					end
				end
				if TheWorld.state.iswinter then
					if not inst.IsBattleMode and not --[[False]] inst.IsBlossomMode and not --[[False]] inst.IsFullmoonMode and not --[[False]] inst.IsHighMoisture then --[[False]] 
						inst.AnimState:SetBuild("dendrobium_aquatic_2nd")
					elseif not inst.IsBattleMode and not --[[False]] inst.IsBlossomMode and not --[[False]] inst.IsFullmoonMode and --[[False]] inst.IsHighMoisture then --[[True]] 
						inst.AnimState:SetBuild("dendrobium_blue_2nd")
					elseif inst.IsBattleMode and not --[[True]] inst.IsBlossomMode and not --[[False]] inst.IsFullmoonMode and not --[[False]] inst.IsHighMoisture then --[[False]] 
						inst.AnimState:SetBuild("dendrobium_red_2nd")
					elseif not inst.IsBattleMode and  --[[False]] inst.IsBlossomMode and not --[[True]] inst.IsFullmoonMode and not --[[False]] inst.IsHighMoisture then --[[False]] 
						inst.AnimState:SetBuild("dendrobium_green_2nd")
					elseif not inst.IsBattleMode and not --[[False]] inst.IsBlossomMode and --[[False]] inst.IsFullmoonMode and not --[[True]] inst.IsHighMoisture then --[[False]] 
						inst.AnimState:SetBuild("dendrobium_black_2nd")
					end
				end
				if TheWorld.state.isspring then
					if not inst.IsBattleMode and not --[[False]] inst.IsBlossomMode and not --[[False]] inst.IsFullmoonMode and not --[[False]] inst.IsHighMoisture then --[[False]] 
						inst.AnimState:SetBuild("dendrobium_purple_2nd")
					elseif not inst.IsBattleMode and not --[[False]] inst.IsBlossomMode and not --[[False]] inst.IsFullmoonMode and --[[False]] inst.IsHighMoisture then --[[True]] 
						inst.AnimState:SetBuild("dendrobium_blue_2nd")
					elseif inst.IsBattleMode and not --[[True]] inst.IsBlossomMode and not --[[False]] inst.IsFullmoonMode and not --[[False]] inst.IsHighMoisture then --[[False]] 
						inst.AnimState:SetBuild("dendrobium_red_2nd")
					elseif not inst.IsBattleMode and  --[[False]] inst.IsBlossomMode and not --[[True]] inst.IsFullmoonMode and not --[[False]] inst.IsHighMoisture then --[[False]] 
						inst.AnimState:SetBuild("dendrobium_green_2nd")
					elseif not inst.IsBattleMode and not --[[False]] inst.IsBlossomMode and --[[False]] inst.IsFullmoonMode and not --[[True]] inst.IsHighMoisture then --[[False]] 
						inst.AnimState:SetBuild("dendrobium_black_2nd")
					end
				end
				if TheWorld.state.issummer then
					if not inst.IsBattleMode and not --[[False]] inst.IsBlossomMode and not --[[False]] inst.IsFullmoonMode and not --[[False]] inst.IsHighMoisture then --[[False]] 
						inst.AnimState:SetBuild("dendrobium_sun_2nd")
					elseif not inst.IsBattleMode and not --[[False]] inst.IsBlossomMode and not --[[False]] inst.IsFullmoonMode and --[[False]] inst.IsHighMoisture then --[[True]] 
						inst.AnimState:SetBuild("dendrobium_blue_2nd")
					elseif inst.IsBattleMode and not --[[True]] inst.IsBlossomMode and not --[[False]] inst.IsFullmoonMode and not --[[False]] inst.IsHighMoisture then --[[False]] 
						inst.AnimState:SetBuild("dendrobium_red_2nd")
					elseif not inst.IsBattleMode and  --[[False]] inst.IsBlossomMode and not --[[True]] inst.IsFullmoonMode and not --[[False]] inst.IsHighMoisture then --[[False]] 
						inst.AnimState:SetBuild("dendrobium_green_2nd")
					elseif not inst.IsBattleMode and not --[[False]] inst.IsBlossomMode and --[[False]] inst.IsFullmoonMode and not --[[True]] inst.IsHighMoisture then --[[False]] 
						inst.AnimState:SetBuild("dendrobium_black_2nd")
						end
					end
				end
			end
		if TheWorld.state.isfullmoon then inst.IsFullmoonMode = true inst.IsHighMoisture = false inst.IsBlossomMode = false inst.IsBattleMode = false elseif not TheWorld.state.isfullmoon then inst.IsFullmoonMode = false end
		if inst.components.moisture:IsWet() then inst.IsHighMoisture = true elseif not inst.components.moisture:IsWet() then inst.IsHighMoisture = false end
		----- Armor
		if inst.components.orchidacite ~= nil then
			if inst.components.orchidacite.max_shield == 10 then
				-- Enabled shield when charge hit max
				if inst.components.orchidacite:HasCharge("shield") and not inst.ShieldMaxCharge then
					--print("Shield Charged | Armor: 55%") -- Printed Once
					inst.ShieldMaxCharge = true -- Disabled after using shield
					inst.UseShield = false
					inst.OpenShield = false
					inst.components.health:SetAbsorptionAmount(0.55) -- Add armor effect
				elseif inst.components.orchidacite:IsDepleted("shield") and not inst.OpenShield then
					--print("Shield Activated | Armor: 0%") -- Printed Once
					-- Grant shield after relogin, charge must empty
					inst.OpenShield = true
					inst.components.health:SetAbsorptionAmount(0) -- Remove armor effect
				end
			elseif inst.components.orchidacite.max_shield == 30 then
				-- Enabled shield when charge hit max
				if inst.components.orchidacite:HasCharge("shield") and not inst.ShieldMaxCharge then
					--print("Shield Charged | Armor: 65%") -- Printed Once
					inst.ShieldMaxCharge = true -- Disabled after using shield
					inst.UseShield = false
					inst.OpenShield = false
					inst.components.health:SetAbsorptionAmount(0.65) -- Add armor effect
				elseif inst.components.orchidacite:IsDepleted("shield") and not inst.OpenShield then
					--print("Shield Activated | Armor: 0%") -- Printed Once
					-- Grant shield after relogin, charge must empty
					inst.OpenShield = true
					inst.components.health:SetAbsorptionAmount(0) -- Remove armor effect
				end
			elseif inst.components.orchidacite.max_shield == 50 then
				-- Enabled shield when charge hit max
				if inst.components.orchidacite:HasCharge("shield") and not inst.ShieldMaxCharge then
					--print("Shield Charged | Armor: 75%") -- Printed Once
					inst.ShieldMaxCharge = true -- Disabled after using shield
					inst.UseShield = false
					inst.OpenShield = false
					inst.components.health:SetAbsorptionAmount(0.75) -- Add armor effect
				elseif inst.components.orchidacite:IsDepleted("shield") and not inst.OpenShield then
					--print("Shield Activated | Armor: 0%") -- Printed Once
					-- Grant shield after relogin, charge must empty
					inst.OpenShield = true
					inst.components.health:SetAbsorptionAmount(0) -- Remove armor effect
				end
			elseif inst.components.orchidacite.max_shield == 80 then
				-- Enabled shield when charge hit max
				if inst.components.orchidacite:HasCharge("shield") and not inst.ShieldMaxCharge then
					--print("Shield Charged | Armor: 85%") -- Printed Once
					inst.ShieldMaxCharge = true -- Disabled after using shield
					inst.UseShield = false
					inst.OpenShield = false
					inst.components.health:SetAbsorptionAmount(0.85) -- Add armor effect
				elseif inst.components.orchidacite:IsDepleted("shield") and not inst.OpenShield then
					--print("Shield Activated | Armor: 0%") -- Printed Once
					-- Grant shield after relogin, charge must empty
					inst.OpenShield = true
					inst.components.health:SetAbsorptionAmount(0) -- Remove armor effect
				end
			elseif inst.components.orchidacite.max_shield == 100 then
				-- Enabled shield when charge hit max
				if inst.components.orchidacite:HasCharge("shield") and not inst.ShieldMaxCharge then
					--print("Shield Charged | Armor: 95%") -- Printed Once
					inst.ShieldMaxCharge = true -- Disabled after using shield
					inst.UseShield = false
					inst.OpenShield = false
					inst.components.health:SetAbsorptionAmount(0.95) -- Add armor effect
				elseif inst.components.orchidacite:IsDepleted("shield") and not inst.OpenShield then
					--print("Shield Activated | Armor: 0%") -- Printed Once
					-- Grant shield after relogin, charge must empty
					inst.OpenShield = true
					inst.components.health:SetAbsorptionAmount(0) -- Remove armor effect
				end
			end
		end
		-----
	end)
end
function Orchidacite:OnBecameGhost(owner)
	owner:ListenForEvent("death", function(inst) 
		inst.components.orchidacite:MorphDown()
		inst.IsUpdatingSkin = false
	end)
end
function Orchidacite:OnRespawnFromGhost(owner)
	owner:ListenForEvent("respawnfromghost", function(inst) 
		inst.IsUpdatingSkin = true
	end)
end

--------------------------------------------------------------------------------------------------------------------------------
-- Spell Power (Flute | Extinguish): 1
function Orchidacite:Extinguish()
	local owner = self.inst; local rads = 17;  local x,y,z = owner.Transform:GetWorldPosition(); local ents = TheSim:FindEntities(x, y, z, rads);
	for k,v in pairs(ents) do 
		if v.components.burnable and (v.components.burnable:IsBurning() or v.components.burnable:IsSmoldering()) and not (v:HasTag("lighter") or v:HasTag("campfire") or v:HasTag("shadow_fire")) then
		   v.components.burnable:Extinguish() v.components.burnable:StopSmoldering()
		end
	end
	-- Cost
	if owner.components.hunger then
		owner.components.hunger:DoDelta(-5)
	end
end

-- Spell Power (Book): 1
function Orchidacite:DawnLight()
	local owner = self.inst
	local pt = owner:GetPosition()
	local ents = TheSim:FindEntities(pt.x, pt.y, pt.z, 10, { "DAWNLIGHT" })
	if #ents > 2 then -- Max: 3
		owner.components.talker:Say("There are already lights nearby!")
	else
		local x,y,z = owner.Transform:GetWorldPosition()
		local light = SpawnPrefab("fx_dawn_light")
		light.Transform:SetPosition(x,y,z)
		light:SetDuration(729) -- 1 and a half day
		-- Cost
		if owner.components.sanity then
			owner.components.sanity:DoDelta(-20)
		end	
	end
end

-- Spell Power (Book | Frigid Aura): 2
function Orchidacite:FrigidAura()
	local owner = self.inst; local rads = 20;  local x,y,z = owner.Transform:GetWorldPosition(); local ents = TheSim:FindEntities(x, y, z, rads);
	for k,v in pairs(ents) do 
		if v ~=nil and v.components.health and not v.components.health:IsDead() and v.entity:IsVisible() and v.components.combat and (v.components.combat.target == self.inst or v:HasTag("monster") or v:HasTag("werepig") or v:HasTag("frog")) and not v:HasTag("player") and not v:HasTag("companion") and not  v:HasTag("stalkerminion") and not  v:HasTag("smashable") and not  v:HasTag("alignwall") and not v:HasTag("shadowminion") then 
			if v.components.combat and not v:HasTag("companion") then 
				SpawnPrefab("fx_ice_splash").Transform:SetPosition(v:GetPosition():Get())
				v.components.combat:SuggestTarget(self.inst)
			end
			if not v.freezebuffed then v.freezebuffed = true
				v.damagedFreeze = v:DoPeriodicTask(2, function()
					if not v.components.health:IsDead() then
						SpawnPrefab("fx_ice_splash").Transform:SetPosition(v:GetPosition():Get());
						if v.sg ~= nil and v:HasTag("spider") then v.sg:GoToState("hit_stunlock") else v.sg:GoToState("hit") end
						-- v.components.combat:GetAttacked(owner, 25)
						v.components.health:DoDelta(-25)
						if v.components.freezable then
							v.components.freezable:AddColdness(0.5); v.components.freezable:SpawnShatterFX();
						end
					end
				end)
				v:DoTaskInTime(20, function() 
					if v.damagedFreeze ~= nil then 
						v.damagedFreeze:Cancel(); v.damagedFreeze = nil; v.freezebuffed = false; 
						SpawnPrefab("fx_exploded_small").Transform:SetPosition(v:GetPosition():Get()); 
					end;
				end)
				-- else owner.components.talker:Say("Buff applied only once, current buff still active!")
			end
		end
	end
	-- Cost
	if owner.components.orchidacite then
		owner.components.orchidacite:DoDelta("magic", -25)
	end
end

-- Spell Power (Book | Lightning Smite): 3
function Orchidacite:LightningSmite()
	local owner = self.inst; local rads = 20;  local x,y,z = owner.Transform:GetWorldPosition(); local ents = TheSim:FindEntities(x, y, z, rads);
	for k,v in pairs(ents) do 
		if v ~=nil and v.components.health and not v.components.health:IsDead() and v.entity:IsVisible() and v.components.combat and (v.components.combat.target == self.inst or v:HasTag("monster") or v:HasTag("werepig") or v:HasTag("frog")) and not v:HasTag("player") and not v:HasTag("companion") and not  v:HasTag("stalkerminion") and not  v:HasTag("smashable") and not  v:HasTag("alignwall") and not v:HasTag("shadowminion") then 
			if v.components.combat and not v:HasTag("companion") then 
				SpawnPrefab("fx_exploded_small").Transform:SetPosition(v:GetPosition():Get())
				v.components.combat:SuggestTarget(self.inst)
			end
			if not v.slowbuffed then v.slowbuffed = true
				v.damagedSlow = v:DoPeriodicTask(2, function()
					if not v.components.health:IsDead() then
						SpawnPrefab("sparks").Transform:SetPosition(v:GetPosition():Get());
						if v.sg ~= nil and v:HasTag("spider") then v.sg:GoToState("hit_stunlock") else v.sg:GoToState("hit") end
						--v.components.combat:GetAttacked(owner, 30)
						v.components.health:DoDelta(-30)
						if v.components ~= nil then
							v.components.locomotor.groundspeedmultiplier = 0.2
						end
					end
				end)
				v:DoTaskInTime(20, function() 
					if v.damagedSlow ~= nil then 
						v.damagedSlow:Cancel(); v.damagedSlow = nil; v.slowbuffed = false; 
						SpawnPrefab("fx_exploded_small").Transform:SetPosition(v:GetPosition():Get()); 
						SpawnPrefab("fx_lightning").Transform:SetPosition(v:GetPosition():Get()); 
					end;
				end) 
				-- else owner.components.talker:Say("Buff applied only once, current buff still active!")
			end
		end
	end
	-- Cost
	if owner.components.orchidacite then
		owner.components.orchidacite:DoDelta("magic", -30)
	end
end

return Orchidacite