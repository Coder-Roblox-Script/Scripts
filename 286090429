local placeId = game.PlaceId
local gameInfo = game:GetService("MarketplaceService"):GetProductInfo(placeId)

-- Load Kavo UI Library
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()

-- Create the UI Window
local Window = Library.CreateLib(gameInfo.Name", "BloodTheme")

-- Create a tab for the aimbot
local AimbotTab = Window:NewTab("Aimbot")
local ESPTab = Window:NewTab("ESP")

-- Create a section for aimbot settings
local AimbotSection = AimbotTab:NewSection("Aimbot Settings")
local ESPSection = ESPTab:NewSection("ESP Settings")

-- Aimbot toggle
local AimEnabled = false
AimbotSection:NewToggle("Enable Aimbot", "Toggles the aimbot on or off", function(state)
    AimEnabled = state
end)

-- Team check toggle
local TeamCheck = false
AimbotSection:NewToggle("Team Check", "Toggles team check on or off", function(state)
    TeamCheck = state
end)

-- Wall check toggle
local WallCheck = false
AimbotSection:NewToggle("Wall Check", "Toggles wall check on or off", function(state)
    WallCheck = state
end)

-- Aimbot keybind (using UserInputService)
local AimKey = Enum.UserInputType.MouseButton2 -- Right mouse button
AimbotSection:NewLabel("Aimbot will be activated when right mouse is pressed")

-- ESP toggle
local ESPEnabled = false
ESPSection:NewToggle("Enable ESP", "Toggles the ESP on or off", function(state)
    ESPEnabled = state
end)

-- ESP Team Check
local ESPTeamCheck = false
ESPSection:NewToggle("ESP Team Check", "Toggle to only show enemies", function(state)
    ESPTeamCheck = state
end)

-- ESP color
local ESPColor = Color3.fromRGB(255, 0, 0) -- Red by default
ESPSection:NewColorPicker("ESP Color", "Sets the color of the ESP", ESPColor, function(color)
    ESPColor = color
end)

-- Table to store ESP boxes
local ESPBoxes = {}

-- Function to create an ESP box around a player
local function CreateESPBox(Player)
    local box = Drawing.new("Square")
    box.Visible = false
    box.Color = ESPColor
    box.Thickness = 2
    box.Filled = false
    box.Transparency = 1

    local function UpdateBox()
        if ESPEnabled and Player.Character and Player.Character.PrimaryPart then
            local vec, onScreen = workspace.CurrentCamera:WorldToViewportPoint(Player.Character.PrimaryPart.Position)
            if onScreen then
                local size = 50 -- Adjust the size of the box as needed
                box.Position = Vector2.new(vec.X - size / 2, vec.Y - size / 2)
                box.Size = Vector2.new(size, size)
                box.Visible = true
            else
                box.Visible = false
            end
        elseif not ESPEnabled and box.Visible then
            box.Visible = false
        end
    end

    game:GetService("RunService").RenderStepped:Connect(UpdateBox)

    return box
end

-- ESP function (with Team Check logic)
local function ESP()
    for i, v in pairs(game.Players:GetPlayers()) do
        if v ~= game.Players.LocalPlayer then
            if v.Character then
                -- ESP Team check logic
                if ESPTeamCheck and game.Players.LocalPlayer.Team == v.Team then
                    -- Remove existing box
                    if ESPBoxes[v] then
                        ESPBoxes[v]:Remove()
                        ESPBoxes[v] = nil
                    end
                else
                    -- Create or update box
                    if not ESPBoxes[v] then
                        ESPBoxes[v] = CreateESPBox(v)
                    else
                        ESPBoxes[v].Color = ESPColor
                    end
                end
            end
        end
    end
end

-- Function to check if there's a wall between the local player and the target, returns true if there's a wall, false otherwise
local function IsWalled(Target)
    local LocalPlayer = game.Players.LocalPlayer
    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        return false
    end

    local Origin = LocalPlayer.Character.HumanoidRootPart.Position
    local TargetPosition = Target.Character.HumanoidRootPart.Position
    local Direction = (TargetPosition - Origin).Unit * 1000

    local Params = RaycastParams.new()
    Params.FilterDescendantsInstances = {LocalPlayer.Character, workspace.Terrain}
    Params.FilterType = Enum.RaycastFilterType.Exclude
    Params.IgnoreWater = true

    local Result = workspace:Raycast(Origin, Direction, Params)
    
    -- Return true if there's a wall (the result isn't the target), false otherwise
    return Result and Result.Instance:FindFirstAncestor(Target.Name) == nil
end

-- Aimbot function (with Team Check and Wall Check logic, corrected for no goto)
local function Aimbot()
    local LocalPlayer = game.Players.LocalPlayer
    local Mouse = LocalPlayer:GetMouse()
    local Camera = workspace.CurrentCamera

    local Target = nil
    local ClosestDistance = math.huge

    for i, v in pairs(game.Players:GetPlayers()) do
        if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
            local HumanoidRootPart = v.Character.HumanoidRootPart
            local ScreenPosition, OnScreen = Camera:WorldToScreenPoint(HumanoidRootPart.Position)

            if OnScreen then
                local Distance = (Vector2.new(Mouse.X, Mouse.Y) - Vector2.new(ScreenPosition.X, ScreenPosition.Y)).Magnitude

                -- Check if the target is closer than the current closest target
                if Distance < ClosestDistance then
                    local ValidTarget = true

                    -- If wall check is enabled, only target if not walled
                    if WallCheck then
                        if IsWalled(v) then
                            ValidTarget = false
                        end
                    end

                    -- Team check logic
                    if TeamCheck and LocalPlayer.Team == v.Team then
                        ValidTarget = false
                    end

                    -- If all checks pass, this player is a valid target
                    if ValidTarget then
                        Target = v
                        ClosestDistance = Distance
                    end
                end
            end
        end
    end

    -- Aim at the target if found
    if Target and Target.Character and Target.Character:FindFirstChild("HumanoidRootPart") then
        local Camera = workspace.CurrentCamera
        Camera.CFrame = CFrame.new(Camera.CFrame.Position, Target.Character.HumanoidRootPart.Position)
    end
end
-- Run the aimbot and ESP when enabled
game:GetService("RunService").RenderStepped:Connect(function()
    if AimEnabled and game:GetService("UserInputService"):IsMouseButtonPressed(AimKey) then
        Aimbot()
    end

    if ESPEnabled then
        ESP()
    else
        -- Clean up boxes when ESP is disabled
        for Player, Box in pairs(ESPBoxes) do
            Box:Remove()
            ESPBoxes[Player] = nil
        end
    end
end)

-- Apply ESP to any new players that join
game.Players.PlayerAdded:Connect(function(player)
    if ESPEnabled then
        ESPBoxes[player] = CreateESPBox(player)
    end
end)

-- Remove ESP for any players that leave
game.Players.PlayerRemoving:Connect(function(player)
    if ESPBoxes[player] then
        ESPBoxes[player]:Remove()
        ESPBoxes[player] = nil
    end
end)
