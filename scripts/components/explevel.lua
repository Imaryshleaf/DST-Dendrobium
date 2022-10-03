local ExpLevel = Class(function(self, inst)
	self.inst = inst
	self.max_levelxp = 30375
	self.min_levelxp = 0
end)

function ExpLevel:OnSave()
	return {
		max_levelxp = self.max_levelxp,
		min_levelxp = self.min_levelxp or nil
	}
end

function ExpLevel:OnLoad(data)
	local owner = self.inst
	if data ~= nil then
		self:AddExp(0)
		self.max_levelxp = data.max_levelxp
		self.min_levelxp = data.min_levelxp
	end
end

function ExpLevel:SetMax(amount)
    self.max_levelxp = amount
    self.min_levelxp = amount
    self:AddExp(0)
end

function ExpLevel:SetStarter(amount, overtime)
	local old = self.min_levelxp; 
	self.min_levelxp  = amount * self.max_levelxp; 
	self.inst:PushEvent("levelexp_delta", { 
		oldpercent = old / self.max_levelxp, 
		newpercent = amount, 
		overtime = overtime 
	})
end

function ExpLevel:AddExp(delta, overtime)
	local old = self.min_levelxp;
	local new = math.clamp(self.min_levelxp + delta, 0, self.max_levelxp);
	self.min_levelxp = new;
	self.inst:PushEvent("levelexp_delta", { 
		oldpercent = old / self.max_levelxp, 
		newpercent = self.min_levelxp / self.max_levelxp, 
		overtime = overtime 
	})
end

-- Backstab Level (Only for Character)
function ExpLevel:Level0Backstab( --[[ 0 - 5]] ) return self.min_levelxp < 1500 end
function ExpLevel:Level1Backstab( --[[ 5 - 10 ]] ) return self.min_levelxp >= 1500 and self.min_levelxp < 3750 end
function ExpLevel:Level2Backstab( --[[ 10 - 20 ]] ) return self.min_levelxp >= 3750 and self.min_levelxp < 7500 end
function ExpLevel:Level3Backstab( --[[ 20 - 30 ]] ) return self.min_levelxp >= 7500 and self.min_levelxp < 11250 end
function ExpLevel:Level4Backstab( --[[ 30 - 40 ]] ) return self.min_levelxp >= 11250 and self.min_levelxp < 15000 end
function ExpLevel:Level5Backstab( --[[ 40 - 50 ]] ) return self.min_levelxp >= 15000 and self.min_levelxp < 22500 end
function ExpLevel:Level6Backstab( --[[ 50 - 60 ]] ) return self.min_levelxp >= 22500 and self.min_levelxp < 26250 end
function ExpLevel:Level7Backstab( --[[ 60 - 70 ]] ) return self.min_levelxp >= 26250 and self.min_levelxp < 30375 end
function ExpLevel:LevelMaxBackstab( --[[ 70 - Max ]] ) return self.min_levelxp >= 30375 end
-- Basic Leveling (Only for Character)
function ExpLevel:Level1()return self.min_levelxp >= 0 and self.min_levelxp < 375 end
function ExpLevel:Level2()return self.min_levelxp >= 375 and self.min_levelxp < 750 end
function ExpLevel:Level3()return self.min_levelxp >= 750 and self.min_levelxp < 1125 end
function ExpLevel:Level4()return self.min_levelxp >= 1125 and self.min_levelxp < 1500 end
function ExpLevel:Level5()return self.min_levelxp >= 1500 and self.min_levelxp < 1875 end
function ExpLevel:Level6()return self.min_levelxp >= 1875 and self.min_levelxp < 2250 end
function ExpLevel:Level7()return self.min_levelxp >= 2250 and self.min_levelxp < 2625 end
function ExpLevel:Level8()return self.min_levelxp >= 2625 and self.min_levelxp < 3000 end
function ExpLevel:Level9()return self.min_levelxp >= 3000 and self.min_levelxp < 3375 end
function ExpLevel:Level10()return self.min_levelxp >= 3375 and self.min_levelxp < 3750 end
function ExpLevel:Level11()return self.min_levelxp >= 3750 and self.min_levelxp < 4125 end
function ExpLevel:Level12()return self.min_levelxp >= 4125 and self.min_levelxp < 4500 end
function ExpLevel:Level13()return self.min_levelxp >= 4500 and self.min_levelxp < 4875 end
function ExpLevel:Level14()return self.min_levelxp >= 4875 and self.min_levelxp < 5250 end
function ExpLevel:Level15()return self.min_levelxp >= 5250 and self.min_levelxp < 5625 end
function ExpLevel:Level16()return self.min_levelxp >= 5625 and self.min_levelxp < 6000 end
function ExpLevel:Level17()return self.min_levelxp >= 6000 and self.min_levelxp < 6375 end
function ExpLevel:Level18()return self.min_levelxp >= 6375 and self.min_levelxp < 6750 end
function ExpLevel:Level19()return self.min_levelxp >= 6750 and self.min_levelxp < 7125 end
function ExpLevel:Level20()return self.min_levelxp >= 7125 and self.min_levelxp < 7500 end
function ExpLevel:Level21()return self.min_levelxp >= 7500 and self.min_levelxp < 7875 end
function ExpLevel:Level22()return self.min_levelxp >= 7875 and self.min_levelxp < 8250 end
function ExpLevel:Level23()return self.min_levelxp >= 8250 and self.min_levelxp < 8625 end
function ExpLevel:Level24()return self.min_levelxp >= 8625 and self.min_levelxp < 9000 end
function ExpLevel:Level25()return self.min_levelxp >= 9000 and self.min_levelxp < 9375 end
function ExpLevel:Level26()return self.min_levelxp >= 9375 and self.min_levelxp < 9750 end
function ExpLevel:Level27()return self.min_levelxp >= 9750 and self.min_levelxp < 10125 end
function ExpLevel:Level28()return self.min_levelxp >= 10125 and self.min_levelxp < 10500 end
function ExpLevel:Level29()return self.min_levelxp >= 10500 and self.min_levelxp < 10875 end
function ExpLevel:Level30()return self.min_levelxp >= 10875 and self.min_levelxp < 11250 end
function ExpLevel:Level31()return self.min_levelxp >= 11250 and self.min_levelxp < 11625 end
function ExpLevel:Level32()return self.min_levelxp >= 11625 and self.min_levelxp < 12000 end
function ExpLevel:Level33()return self.min_levelxp >= 12000 and self.min_levelxp < 12375 end
function ExpLevel:Level34()return self.min_levelxp >= 12375 and self.min_levelxp < 12750 end
function ExpLevel:Level35()return self.min_levelxp >= 12750 and self.min_levelxp < 13125 end
function ExpLevel:Level36()return self.min_levelxp >= 13125 and self.min_levelxp < 13500 end
function ExpLevel:Level37()return self.min_levelxp >= 13500 and self.min_levelxp < 13875 end
function ExpLevel:Level38()return self.min_levelxp >= 13875 and self.min_levelxp < 14250 end
function ExpLevel:Level39()return self.min_levelxp >= 14250 and self.min_levelxp < 14625 end
function ExpLevel:Level40()return self.min_levelxp >= 14625 and self.min_levelxp < 15000 end
function ExpLevel:Level41()return self.min_levelxp >= 15000 and self.min_levelxp < 15375 end
function ExpLevel:Level42()return self.min_levelxp >= 15375 and self.min_levelxp < 15750 end
function ExpLevel:Level43()return self.min_levelxp >= 15750 and self.min_levelxp < 16125 end
function ExpLevel:Level44()return self.min_levelxp >= 16125 and self.min_levelxp < 16500 end
function ExpLevel:Level45()return self.min_levelxp >= 16500 and self.min_levelxp < 16875 end
function ExpLevel:Level46()return self.min_levelxp >= 16875 and self.min_levelxp < 17250 end
function ExpLevel:Level47()return self.min_levelxp >= 17250 and self.min_levelxp < 17625 end
function ExpLevel:Level48()return self.min_levelxp >= 17625 and self.min_levelxp < 18000 end
function ExpLevel:Level49()return self.min_levelxp >= 18000 and self.min_levelxp < 18375 end
function ExpLevel:Level50()return self.min_levelxp >= 18375 and self.min_levelxp < 18750 end
function ExpLevel:Level51()return self.min_levelxp >= 18750 and self.min_levelxp < 19125 end
function ExpLevel:Level52()return self.min_levelxp >= 19125 and self.min_levelxp < 19500 end
function ExpLevel:Level53()return self.min_levelxp >= 19500 and self.min_levelxp < 19875 end
function ExpLevel:Level54()return self.min_levelxp >= 19875 and self.min_levelxp < 20250 end
function ExpLevel:Level55()return self.min_levelxp >= 20250 and self.min_levelxp < 20625 end
function ExpLevel:Level56()return self.min_levelxp >= 20625 and self.min_levelxp < 21000 end
function ExpLevel:Level57()return self.min_levelxp >= 21000 and self.min_levelxp < 21375 end
function ExpLevel:Level58()return self.min_levelxp >= 21375 and self.min_levelxp < 21750 end
function ExpLevel:Level59()return self.min_levelxp >= 21750 and self.min_levelxp < 22125 end
function ExpLevel:Level60()return self.min_levelxp >= 22125 and self.min_levelxp < 22500 end
function ExpLevel:Level61()return self.min_levelxp >= 22500 and self.min_levelxp < 22875 end
function ExpLevel:Level62()return self.min_levelxp >= 22875 and self.min_levelxp < 23250 end
function ExpLevel:Level63()return self.min_levelxp >= 23250 and self.min_levelxp < 23625 end
function ExpLevel:Level64()return self.min_levelxp >= 23625 and self.min_levelxp < 24000 end
function ExpLevel:Level65()return self.min_levelxp >= 24000 and self.min_levelxp < 24375 end
function ExpLevel:Level66()return self.min_levelxp >= 24375 and self.min_levelxp < 24750 end
function ExpLevel:Level67()return self.min_levelxp >= 24750 and self.min_levelxp < 25125 end
function ExpLevel:Level68()return self.min_levelxp >= 25125 and self.min_levelxp < 25500 end
function ExpLevel:Level69()return self.min_levelxp >= 25500 and self.min_levelxp < 25875 end
function ExpLevel:Level70()return self.min_levelxp >= 25875 and self.min_levelxp < 26250 end
function ExpLevel:Level71()return self.min_levelxp >= 26250 and self.min_levelxp < 26625 end
function ExpLevel:Level72()return self.min_levelxp >= 26625 and self.min_levelxp < 27000 end
function ExpLevel:Level73()return self.min_levelxp >= 27000 and self.min_levelxp < 27375 end
function ExpLevel:Level74()return self.min_levelxp >= 27375 and self.min_levelxp < 27750 end
function ExpLevel:Level75()return self.min_levelxp >= 27750 and self.min_levelxp < 28125 end
function ExpLevel:Level76()return self.min_levelxp >= 28125 and self.min_levelxp < 28500 end
function ExpLevel:Level77()return self.min_levelxp >= 28500 and self.min_levelxp < 28875 end
function ExpLevel:Level78()return self.min_levelxp >= 28875 and self.min_levelxp < 29250 end
function ExpLevel:Level79()return self.min_levelxp >= 29250 and self.min_levelxp < 30000 end
function ExpLevel:Level80()return self.min_levelxp >= 30000 and self.min_levelxp < 30375 end
function ExpLevel:LevelMax()return self.min_levelxp >= 30375 end

return ExpLevel





















