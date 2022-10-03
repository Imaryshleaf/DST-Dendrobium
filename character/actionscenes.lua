local STRINGS = GLOBAL.STRINGS
local ACTIONS = GLOBAL.ACTIONS

-- A string "Extinguish Wildfire" under cursor
AddAction("ACTEXTINGUISH", "Extinguish Wildfire", function(act)
if act.doer ~= nil and act.target ~= nil and 
	act.doer:HasTag("Dendrobium") and 
		act.doer.spellpower_count == (1) and 
			act.target.components.orchidacite and 
                not act.target.components.health:IsDead() and 
					act.doer.components.orchidacite and -- requirements
						act.doer.components.orchidacite.min_energy >= (10) then
					act.target.components.orchidacite:Extinguish(act.doer)
                return true	
            else 
		return false
	end
end)

-- A string "Dawn Lights" under cursor
AddAction("ACTDAWNLIGHT", "Dawn Lights", function(act)
if act.doer ~= nil and act.target ~= nil and 
	act.doer:HasTag("Dendrobium") and 
		act.doer.spellpower_count == (2) and 
			act.target.components.orchidacite and 
                not act.target.components.health:IsDead() and
					act.doer.components.sanity and -- requirements
						act.doer.components.sanity.current >= (40) then
					act.target.components.orchidacite:DawnLight(act.doer)
                return true	
            else 
		return false
	end
end)

-- A string "Frigid Aura" under cursor
AddAction("ACTFRIGIDAURA", "Frigid Aura", function(act)
if act.doer ~= nil and act.target ~= nil and 
	act.doer:HasTag("Dendrobium") and 
		act.doer.spellpower_count == (3) and 
			act.target.components.orchidacite and 
                not act.target.components.health:IsDead() and
						act.doer.components.orchidacite.min_magic >= (25) then
					act.target.components.orchidacite:FrigidAura(act.doer)
                return true	
            else 
		return false
	end
end)

-- A string "Dawn Lights" under cursor
AddAction("ACTLIGHTNINGSMITE", "Lightning Smite", function(act)
if act.doer ~= nil and act.target ~= nil and 
	act.doer:HasTag("Dendrobium") and 
		act.doer.spellpower_count == (4) and 
			act.target.components.orchidacite and 
                not act.target.components.health:IsDead() and
						act.doer.components.orchidacite.min_magic >= (30) then
					act.target.components.orchidacite:LightningSmite(act.doer)
                return true	
            else 
		return false
	end
end)

AddComponentAction("SCENE", "orchidacite", function(inst, doer, actions, right)
	if right then
		if inst:HasTag("Dendrobium") and inst.spellpower_count == (1) and
				inst == doer and (rider == nil or not rider:IsRiding()) then
			table.insert(actions, GLOBAL.ACTIONS.ACTEXTINGUISH)	
		end
	end
	if right then
		if inst:HasTag("Dendrobium") and inst.spellpower_count == (2) and
				inst == doer and (rider == nil or not rider:IsRiding()) then
			table.insert(actions, GLOBAL.ACTIONS.ACTDAWNLIGHT)	
		end
	end
	if right then
		if inst:HasTag("Dendrobium") and inst.spellpower_count == (3) and
				inst == doer and (rider == nil or not rider:IsRiding()) then
			table.insert(actions, GLOBAL.ACTIONS.ACTFRIGIDAURA)	
		end
	end
	if right then
		if inst:HasTag("Dendrobium") and inst.spellpower_count == (4) and
				inst == doer and (rider == nil or not rider:IsRiding()) then
			table.insert(actions, GLOBAL.ACTIONS.ACTLIGHTNINGSMITE)	
		end
	end
end)

-- Check: "character/stategraphs.lua"
AddStategraphActionHandler("wilson", GLOBAL.ActionHandler(GLOBAL.ACTIONS.ACTEXTINGUISH, "FluteExtinguishSG"))
AddStategraphActionHandler("wilson_client", GLOBAL.ActionHandler(GLOBAL.ACTIONS.ACTEXTINGUISH, "FluteExtinguishSG"))

AddStategraphActionHandler("wilson", GLOBAL.ActionHandler(GLOBAL.ACTIONS.ACTDAWNLIGHT, "DawnLightSG"))
AddStategraphActionHandler("wilson_client", GLOBAL.ActionHandler(GLOBAL.ACTIONS.ACTDAWNLIGHT, "DawnLightSG"))

AddStategraphActionHandler("wilson", GLOBAL.ActionHandler(GLOBAL.ACTIONS.ACTFRIGIDAURA, "FrigidAuraSG"))
AddStategraphActionHandler("wilson_client", GLOBAL.ActionHandler(GLOBAL.ACTIONS.ACTFRIGIDAURA, "FrigidAuraSG"))

AddStategraphActionHandler("wilson", GLOBAL.ActionHandler(GLOBAL.ACTIONS.ACTLIGHTNINGSMITE, "LightningSmiteSG"))
AddStategraphActionHandler("wilson_client", GLOBAL.ActionHandler(GLOBAL.ACTIONS.ACTLIGHTNINGSMITE, "LightningSmiteSG"))
