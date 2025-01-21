local placeId = game.PlaceId
local gameInfo = game:GetService("MarketplaceService"):GetProductInfo(placeId)

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("gameInfo.Name", "BloodTheme") 
local TeleportTab = Window:NewTab("Teleport")

local function teleportToNextStage(stageNumber, currentStageValue, stageValue)
	local stageName = tostring(stageNumber)
	local spawnPart = workspace.Stages:FindFirstChild(stageName) and workspace.Stages[stageName]:FindFirstChild("Spawn")

	if spawnPart then
		local player = game.Players.LocalPlayer
		local character = player.Character or player.CharacterAdded:Wait()
		local rootPart = character:WaitForChild("HumanoidRootPart")

		local success = false
		rootPart.CFrame = spawnPart.CFrame * CFrame.new(0, 3, 0)

		if stageValue.Value ~= currentStageValue then
			return true
		end

		local startTime = tick()
		while tick() - startTime < 3 and not success do
			for i = 1, 2 do
				local offset = CFrame.new(0, 3 + i, 0)
				rootPart.CFrame = spawnPart.CFrame * offset
				wait(0.05)
				if stageValue.Value ~= currentStageValue then
					success = true
					break
				end
			end

			if not success then
				wait(0.1)
			end
		end
		return success
	end
	return false
end

local player = game:GetService("Players").LocalPlayer
local leaderstats = player:WaitForChild("leaderstats")
local stageValue = leaderstats:WaitForChild("Stage")

local TeleportSection = TeleportTab:NewSection("Teleport Controls")

TeleportSection:NewToggle("Auto Teleport", "Enables/Disables automatic teleportation", function(state)
	getgenv().TeleportEnabled = state

	if state then
		local currentStage = stageValue.Value
		local delayTime = 0.1

		coroutine.wrap(function()
			while getgenv().TeleportEnabled do
				currentStage = currentStage + 1
				if not teleportToNextStage(currentStage, stageValue.Value, stageValue) then
					TeleportToggle:UpdateToggle(false)
					getgenv().TeleportEnabled = false
					print("Failed to teleport to Stage "..currentStage.." after multiple attempts.")
					break
				end
				wait(delayTime)
			end
		end)()
	end
end)

TeleportSection:NewKeybind("Toggle UI", "Toggles the UI", Enum.KeyCode.RightControl, function()
	Library:ToggleUI()
end)
