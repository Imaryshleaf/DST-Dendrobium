local Chronometer = Class(function(self, inst)
    self.inst = inst
    self.chronometers = {}
end)

function Chronometer:OnRemoveFromEntity()
    for k, v in pairs(self.chronometers) do
        if v.chronometer ~= nil then
            v.chronometer:Cancel()
        end
    end
end

function Chronometer:GetDebugString()
    local str = ""
    for k, v in pairs(self.chronometers) do
        str = str..string.format(
            "\n    --%s: timeleft: %.2f paused: %s",
            k,
            self:GetTimeLeft(k) or 0,
            tostring(self:IsPaused(k) == true)
        )
    end
    return str
end

function Chronometer:TimerExists(name)
    return self.chronometers[name] ~= nil
end

local function OnTimerDone(inst, self, name)
    self:StopTimer(name)
    inst:PushEvent("chronometerdone", { name = name })
end

function Chronometer:StartTimer(name, time, paused, initialtime_override)
    if self:TimerExists(name) then
        print("A chronometer with the name ", name, " already exists on ", self.inst, "!")
        return
    end

    self.chronometers[name] =
    {
        chronometer = self.inst:DoTaskInTime(time, OnTimerDone, self, name),
        timeleft = time,
        end_time = GetTime() + time,
        initial_time = initialtime_override or time,
        paused = false,
    }

    if paused then
        self:PauseTimer(name)
    end
end

function Chronometer:StopTimer(name)
    if not self:TimerExists(name) then
        return
    end

    if self.chronometers[name].chronometer ~= nil then
        self.chronometers[name].chronometer:Cancel()
        self.chronometers[name].chronometer = nil
    end
    self.chronometers[name] = nil
end

function Chronometer:IsPaused(name)
    return self:TimerExists(name) and self.chronometers[name].paused
end

function Chronometer:PauseTimer(name)
    if not self:TimerExists(name) or self:IsPaused(name) then
        return
    end

    self:GetTimeLeft(name)

    self.chronometers[name].paused = true
    self.chronometers[name].chronometer:Cancel()
    self.chronometers[name].chronometer = nil
end

function Chronometer:ResumeTimer(name)
    if not self:IsPaused(name) then
        return
    end

    self.chronometers[name].paused = false
    self.chronometers[name].chronometer = self.inst:DoTaskInTime(self.chronometers[name].timeleft, OnTimerDone, self, name)
    self.chronometers[name].end_time = GetTime() + self.chronometers[name].timeleft
	return true
end

function Chronometer:GetTimeLeft(name)
    if not self:TimerExists(name) then
        return
    elseif not self:IsPaused(name) then
        self.chronometers[name].timeleft = self.chronometers[name].end_time - GetTime()
    end
    return self.chronometers[name].timeleft
end

function Chronometer:SetTimeLeft(name, time)
    if not self:TimerExists(name) then
        return
    elseif self:IsPaused(name) then
        self.chronometers[name].timeleft = math.max(0, time)
    else
        self:PauseTimer(name)
        self.chronometers[name].timeleft = math.max(0, time)
        self:ResumeTimer(name)
    end
end

function Chronometer:GetTimeElapsed(name)
    return self:TimerExists(name)
        and (self.chronometers[name].initial_time or 0) - self:GetTimeLeft(name)
        or nil
end

function Chronometer:OnSave()
    local data = {}
    for k, v in pairs(self.chronometers) do
        data[k] =
        {
            timeleft = self:GetTimeLeft(k),
            paused = v.paused,
            initial_time = v.initial_time,
        }
    end
    return next(data) ~= nil and { chronometers = data } or nil
end

function Chronometer:OnLoad(data)
    if data.chronometers ~= nil then
        for k, v in pairs(data.chronometers) do
            self:StopTimer(k)
            self:StartTimer(k, v.timeleft, v.paused, v.initial_time)
        end
    end
end

function Chronometer:LongUpdate(dt)
    for k, v in pairs(self.chronometers) do
        self:SetTimeLeft(k, self:GetTimeLeft(k) - dt)
    end
end

function Chronometer:TransferComponent(newinst)
    local newcomponent = newinst.components.chronometer

    for k, v in pairs(self.chronometers) do
        newcomponent:StartTimer(k, self:GetTimeLeft(k), v.paused, v.initial_time)
    end

end

return Chronometer
