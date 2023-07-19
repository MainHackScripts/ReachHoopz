local plr = game.Players.LocalPlayer

local function updateNearestPlayerWithBall()
    local dist = 9e9
    for _, v in ipairs(game.Players:GetPlayers()) do
        if v.Name ~= plr.Name and v.Character and v.Character:FindFirstChild("Basketball")
            and not plr.Character:FindFirstChild("Basketball") 
            and (plr.Character.Torso.Position - v.Character.Torso.Position).Magnitude < 50 then
            local mag = (plr.Character.Torso.Position - v.Character.Torso.Position).Magnitude
            if dist > mag then
                dist = mag
                player = v
            end
        end
    end
end

local function getNearestPart(torso)
    local dist, part = 9e9
    for _, v in ipairs(plr.Character:GetChildren()) do
        if v:IsA("Part") and torso then
            local mag = (v.Position - torso.Position).Magnitude
            if dist > mag then
                dist = mag
                part = v
            end
        end
    end
    return part
end

local function table(a, b)
    local args = {
        X1 = a.X,
        Y1 = a.Y,
        Z1 = a.Z,
        X2 = b.X,
        Y2 = b.Y,
        Z2 = b.Z
    }

    return {
        args[_G.method[1]],
        args[_G.method[2]],
        args[_G.method[3]],
        args[_G.method[4]],
        args[_G.method[5]],
        args[_G.method[6]]
    }
end

local function arc()
    -- The arc function implementation
    -- ... (the implementation is not provided in the original code)
end

local function shoot()
    local dist, goal = setup()
    local pwr = power()
    local arc = arc()
   
    if arc ~= nil and plr.Character and plr.Character:FindFirstChild("Humanoid") then
        local args = table(plr.Character.Torso.Position, (goal.Position + Vector3.new(0, arc, 0) - plr.Character.HumanoidRootPart.Position + plr.Character.Humanoid.MoveDirection).Unit)
   
        shootingEvent:FireServer(
            plr.Character.Basketball,
            pwr.Value,
            args,
            _G.key
        )
    end
end

local function stepped()
    for _, v in ipairs(game.Players:GetPlayers()) do
        if (v.Name ~= plr.Name and v.Character and plr.Character) and _G.Reach then
            local nearestPart = getNearestPart(v.Character.Torso)
            for _, x in ipairs(v.Character:GetChildren()) do
                if ((nearestPart.Position - v.Character.Torso.Position).Magnitude < 8) then
                    if (x:IsA("Tool") or x:IsA("Folder")) then
                        firetouchinterest(nearestPart, x:FindFirstChildOfClass("Part"), 0)
                        task.wait()
                        firetouchinterest(nearestPart, x:FindFirstChildOfClass("Part"), 1)
                    elseif (x:IsA("BasePart") and string.find(x.Name:lower(), "ball")) then
                        firetouchinterest(nearestPart, x, 0)
                        task.wait()
                        firetouchinterest(nearestPart, x, 1)
                    end
                end
            end
        end
    end
end

_G.stepped = rs.Stepped:Connect(stepped)
_G.charAdded = plr.CharacterAdded:Connect(function(ch)
    for _, v in ipairs(getconnections(ch:WaitForChild("HumanoidRootPart"):GetPropertyChangedSignal("Size"))) do
        v:Disable()
    end
    for _, v in ipairs(getconnections(ch:WaitForChild("HumanoidRootPart"):GetPropertyChangedSignal("BrickColor"))) do
        v:Disable()
    end
    for _, v in ipairs(getconnections(ch:WaitForChild("HumanoidRootPart"):GetPropertyChangedSignal("Color"))) do
        v:Disable()
    end
end)
