local playerName = game.Players.LocalPlayer.Name
local placeId = game.PlaceId
local gameInfo = game:GetService("MarketplaceService"):GetProductInfo(placeId)

local GamesList = {
	"8003084678",
}

local isSupported = table.find(GamesList, tostring(placeId)) ~= nil

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("Quantum", "BloodTheme")

local HomeTab = Window:NewTab("Home")
local ScriptsTab = Window:NewTab("Scripts")
local HomeSection = HomeTab:NewSection("Welcome, "..playerName)
local ScriptsSection = ScriptsTab:NewSection("Scripts")

HomeSection:NewLabel("Currently in: "..gameInfo.Name)
HomeSection:NewLabel("Game Supported?: "..(isSupported and "YES" or "NO"))

ScriptsSection:NewButton("Load Script", "ButtonInfo", function()
	local currentPlaceId = game.PlaceId
	local isCurrentlySupported = table.find(GamesList, tostring(currentPlaceId)) ~= nil

	if isCurrentlySupported then
		print("Game is supported! Loading script...")
		--Here
		print("Script loaded and executed.")
	else
		print("Game is not supported.")
	end
end)
