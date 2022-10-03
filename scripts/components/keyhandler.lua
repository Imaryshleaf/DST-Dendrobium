local KeyHandler = Class(function(self, inst)
	self.inst = inst
end)

function KeyHandler:Press(Key, Action, target)
	TheInput:AddKeyDownHandler(Key, function()
		if self.inst == ThePlayer and TheFrontEnd:GetActiveScreen() and TheFrontEnd:GetActiveScreen().name == "HUD" then
			SendModRPCToServer(MOD_RPC[self.inst.prefab][Action], target)
		end
	end)
end

function KeyHandler:Charge(Key, Start, Stop, target)
	TheInput:AddKeyDownHandler(Key, function()
		if self.inst == ThePlayer and TheFrontEnd:GetActiveScreen() and TheFrontEnd:GetActiveScreen().name == "HUD" then
			if not self.ishold then
				SendModRPCToServer(MOD_RPC[self.inst.prefab][Start], target)
				self.ishold = true
				self.inst:AddTag("charging")
			end
		end
	end)
	TheInput:AddKeyUpHandler(Key, function()
		if self.inst == ThePlayer and TheFrontEnd:GetActiveScreen() and TheFrontEnd:GetActiveScreen().name == "HUD" then
			if self.ishold then
				SendModRPCToServer(MOD_RPC[self.inst.prefab][Stop], target)
				self.ishold = false
				self.inst:RemoveTag("charging")
			end
		end
	end)
end

function KeyHandler:Event(Key, Press, Hold, target)
	TheInput:AddKeyDownHandler(Key, function()
		if self.inst == ThePlayer and TheFrontEnd:GetActiveScreen() and TheFrontEnd:GetActiveScreen().name == "HUD" then
			if not self.holding then
				self.pending = true
				self.holding = true
				self.inst:DoTaskInTime(0.6, function()
					if self.holding then
						SendModRPCToServer(MOD_RPC[self.inst.prefab][Hold], target)
					end
				end)
			end
		end
	end)
	TheInput:AddKeyUpHandler(Key, function()
		if self.inst == ThePlayer and TheFrontEnd:GetActiveScreen() and TheFrontEnd:GetActiveScreen().name == "HUD" then
			if self.pending then
				SendModRPCToServer(MOD_RPC[self.inst.prefab][Press], target)
				self.pending = false
				if self.holding then
					self.holding = false
				end
			end
		end
	end)
end

--[[
function KeyHandler:AddActionListener(Namespace, Key, Action)
	self.inst:ListenForEvent("keypressed", function(inst, data)
		if data.inst == ThePlayer then
			if data.key == Key then
				if TheWorld.ismastersim then
					ThePlayer:PushEvent("keyaction"..Namespace..Action, { Namespace = Namespace, Action = Action, Fn = MOD_RPC_HANDLERS[Namespace][MOD_RPC[Namespace][Action].id] })
				else
					SendModRPCToServer( MOD_RPC[Namespace][Action] )
				end
			end
		end
	end)

	if TheWorld.ismastersim then
      self.inst:ListenForEvent("keyaction"..Namespace..Action, function(inst, data)
          if not data.Action == Action and not data.Namespace == Namespace then
              return
          end
          
          data.Fn(inst)
      end, self.inst) 
    end
end
]]

return KeyHandler