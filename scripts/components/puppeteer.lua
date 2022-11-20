local Puppeteer = Class(function(self, inst)
    self.inst = inst
    self.enabled = true
    self.executor = nil
    self.isControlling = nil
end)

function Puppeteer:SetEnabled(enabled)
    self.enabled = enabled
end

--
function Puppeteer:IsControlling()
    return self.executor ~= nil and 
	self.executor:IsValid() and 
	self.executor.sg ~= nil and 
	self.executor.sg:HasStateTag("controlling")
end
function Puppeteer:IsSwitching()
    return self.executor ~= nil and 
	self.executor:IsValid() and 
	self.executor.sg ~= nil and 
	self.executor.sg:HasStateTag("igniting")
end
function Puppeteer:IsDisturbed()
    return self.executor ~= nil and 
	self.executor:IsValid() and 
	self.executor.sg ~= nil and 
	(self.executor.sg:HasStateTag("moving") or 
	self.executor.sg:HasStateTag("idle") or 
	self.executor.components.health:IsDead())
end

--
function Puppeteer:SetSwitchingFn(startfn, stopfn)
    self.onswitchingfn = startfn
    self.onstopswitching = stopfn
end
function Puppeteer:SetControllingFn(startfn, stopfn)
    self.oncontrollingfn = startfn
    self.onstopcontrolling = stopfn
end

--
function Puppeteer:StartSwitching(executor, target)
    if self.enabled and
        not self:IsSwitching() and
        executor ~= nil and
        executor:IsValid() and
        executor.sg ~= nil and
        executor.sg:HasStateTag("preignite") then
        self.executor = executor
        executor.sg:GoToState("igniting", self.inst)
        if self.onswitchingfn ~= nil then
            self.onswitchingfn(self.inst, executor)
        end
        self.inst:StartUpdatingComponent(self)
		self:ReIgnite()
        return true
    end
end
function Puppeteer:StopSwitching(aborted)
    if self:IsSwitching() then
        self.executor.sg.statemem.stopswitching = true
        self.executor.sg:GoToState("ignite_stop")
    end
    self.executor = nil
    self.inst:StopUpdatingComponent(self)
    if self.onstopswitching ~= nil then
        self.onstopswitching(self.inst, aborted)
    end	
end

--
function Puppeteer:StartControlling(executor, target)
    if self.enabled and
        not self:IsControlling() and
        executor ~= nil and
        executor:IsValid() and
        executor.sg ~= nil and
        executor.sg:HasStateTag("precontrolling") then
        self.executor = executor
        executor.sg:GoToState("controlling", self.inst)
        if self.oncontrollingfn ~= nil then
            self.oncontrollingfn(self.inst, executor)
        end
        self.inst:StartUpdatingComponent(self)
		self:CoaxTarget()
        return true
    end
end
function Puppeteer:StopControlling(aborted)
    if self:IsControlling() then
        self.executor.sg.statemem.stopcontrolling = true
        self.executor.sg:GoToState("stopcontrolling")
    end
    self.executor = nil
    self.inst:StopUpdatingComponent(self)
    if self.onstopcontrolling ~= nil then
        self.onstopcontrolling(self.inst, aborted)
    end	
    if self.isControlling ~= nil then
	   self.isControlling:Cancel()
	   self.isControlling = nil
	end
end

-- Actions
function Puppeteer:ReIgnite(executor, target)
	local buffaction = self.executor:GetBufferedAction()
	local target = buffaction ~= nil and buffaction.target or nil
	
    if not self:IsDisturbed() and self:IsSwitching() then
		if target ~= nil and target:IsValid() and target.components.fueled ~= nil and target.components.burnable  ~= nil then
			if not target.components.burnable:IsBurning() then
				local fx1 = SpawnPrefab("tauntfire_fx")
				fx1.Transform:SetScale(0.3, 0.3, 0.3) 
				fx1.Transform:SetPosition(target:GetPosition():Get())
				
				self.executor:DoTaskInTime(1, function() 
					local fx2 = SpawnPrefab("statue_transition_2")
						fx2.Transform:SetScale(1.3, 1.3, 1.3) 
						fx2.Transform:SetPosition(target:GetPosition():Get())
					target.components.fueled:DoDelta(120)
					self:StopSwitching()
				end)
				
			elseif target.components.burnable:IsBurning() then
			
				self.executor:DoTaskInTime(1, function() 
					if self.executor ~= nil then
					if self.executor.components.talker then
						self.executor.components.talker:Say("Nonsense!")
						self:StopSwitching()
						end
					else
						self:StopSwitching()
					end
				end)
				
			end 
		end 
	end 
end

function Puppeteer:CoaxTarget(executor, target)
	local buffaction = self.executor:GetBufferedAction()
	local target = buffaction ~= nil and buffaction.target or nil
	
    if not self:IsDisturbed() and self:IsControlling() then
		if target ~= nil and target:IsValid() and target.components.combat ~= nil and target.components.health ~= nil and not target.components.health:IsDead() then
			target.components.combat:SuggestTarget(self.executor)
			target:AddTag("undercontrolled")
			
			if target.components.burnable and target.components.burnable:IsBurning() then
			   target.components.burnable:Extinguish()
			end
			if target.components.freezable and target.components.freezable:IsFrozen() then
			   target.components.freezable:Unfreeze()
			end
			
			local fx1 = SpawnPrefab("tauntfire_fx") 
				fx1.Transform:SetScale(0.5, 0.5, 0.5) 
				fx1.Transform:SetPosition(target:GetPosition():Get())

				self.isControlling = TheWorld:DoPeriodicTask(1, function()
				if target.components.combat:TargetIs(self.executor) and target:HasTag("undercontrolled") then
					if target:HasTag("spider") and not target:HasTag("spiderqueen") then 
						target.sg:GoToState("hit_stunlock")
						SpawnPrefab("statue_transition_2").Transform:SetPosition(target:GetPosition():Get())
					else
						SpawnPrefab("statue_transition_2").Transform:SetPosition(target:GetPosition():Get())
						if target.components.locomotor then
							target.components.locomotor.groundspeedmultiplier = 0.2
						end
					end
					
					if target.components.health then
					   target.components.health:DoDelta(-20)
					end
					if self.executor.components.hunger then
					   self.executor.components.hunger:DoDelta(-2)
					end
					
					if (target.components.health:IsDead() or target.components.combat:TargetIs(nil)) then
						target:RemoveTag("undercontrolled")
						self.executor.sg:GoToState("stopcontrolling")
						if self.isControlling ~= nil then
							self.isControlling:Cancel()
							self.isControlling = nil
						end
					end
				end
			end)
		end
	end 
end

return Puppeteer