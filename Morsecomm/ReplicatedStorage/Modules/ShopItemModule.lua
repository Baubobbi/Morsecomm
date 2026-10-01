--[[
    ================================================================
    
    Author:      @Baubobbi
    Created:     31.03.2025
    Description: 
    
    ================================================================
    LICENSE:
    
    All rights reserved. This code is intended for personal use only.
    - The code may not be modified, redistributed, or altered.
    - The code may not be used or distributed for commercial purposes.
    
    Any use of this code without explicit permission from the author is prohibited.
    
    ================================================================
    NOTES: 

    ================================================================
]]

local MarketplaceService = game:GetService("MarketplaceService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local RemoteEvents = ReplicatedStorage:FindFirstChild("RemoteEvents")
local Modules = ReplicatedStorage:WaitForChild("Modules")
local Values = ReplicatedStorage:FindFirstChild("Values")
local GAF1 = ReplicatedStorage:FindFirstChild("GAF1")
local LocalPlayer = Players.LocalPlayer

local PositionFolderModule = require(GAF1.PositionFolderModule)
local GuiWindowModule = require(Modules.GuiWindowModule)
local FadeModule = require(GAF1.FadeModule)

local GadgedPresentOnTableStates = 
	{

	}

local ShopItemModule = 
	{
		GiveOrRemove = {
			Give = "Give",
			Remove = "Remove"
		}
	}


function ShopItemModule.CreateForTableGadged(ShopItemFrame: Frame, GamePassID, TrailTimeInSeconds: number?, Gadgeds, TrailEvent: RemoteEvent?) -- Gadgeds is a table
	-- The gamepass Id is also used as an uniqe id for the on table boolean
	table.insert(GadgedPresentOnTableStates, {id = GamePassID, state = true})

	local TrailWindow = ShopItemFrame:FindFirstChild("TrailWindow")

	local TrailButton = ShopItemFrame:FindFirstChild("TrailButton")
	local BuyButton = ShopItemFrame:FindFirstChild("BuyButton")
	local StartTrailButton = TrailWindow.StartTrailButton
	local ExitTrailButton = TrailWindow.Exit

	-- On player joins --
	if MarketplaceService:UserOwnsGamePassAsync(LocalPlayer.UserId, GamePassID) then
		ShopItemModule.GiveOrRemovePlayerGadged(Gadgeds, ShopItemModule.GiveOrRemove.Give, GamePassID) -- give
	else
		--if Values:FindFirstChild("InMorseTranslatorTrail").Value == false then
		ShopItemModule.GiveOrRemovePlayerGadged(Gadgeds, ShopItemModule.GiveOrRemove.Remove, GamePassID) -- remove
		--end
	end

	-- BUY button clicked
	BuyButton.MouseButton1Click:Connect(function()
		if not MarketplaceService:UserOwnsGamePassAsync(LocalPlayer.UserId, GamePassID) then
			MarketplaceService:PromptGamePassPurchase(LocalPlayer, GamePassID)
		else
			print("Allready bought")
		end
	end)

	MarketplaceService.PromptGamePassPurchaseFinished:Connect(function(player: Instance, gamePassId: number, wasPurchased: boolean)
		--CloseShop()

		if player == LocalPlayer and gamePassId == GamePassID and wasPurchased == true then

			ShopItemModule.DissableTrailButton(TrailButton) -- Doing this too, bc. it's faster.
			ShopItemModule.DissableTrailButton(TrailWindow.StartTrailButton) -- for the trail window button

			RemoteEvents:FindFirstChild(TrailEvent.Name):FireServer(LocalPlayer) -- Dissables trail button for ever
			ShopItemModule.GiveOrRemovePlayerGadged(Gadgeds, ShopItemModule.GiveOrRemove.Give, GamePassID)
		end

	end)


	-- TRAIL button clicked
	TrailButton.MouseButton1Click:Connect(function()
		FadeModule.FadeGuiObject(ShopItemFrame.DarkBack, 0.2, 0.5)
		GuiWindowModule.OpenCloseAnimateWindow(TrailWindow, true)
	end)

	-- TRAIL EXIT button clicked
	ExitTrailButton.MouseButton1Click:Connect(function()
		FadeModule.FadeGuiObject(ShopItemFrame.DarkBack, 0.2, 1)
		GuiWindowModule.OpenCloseAnimateWindow(TrailWindow, false)
	end)

	-- START TRAIL button clicked
	StartTrailButton.MouseButton1Click:Connect(function()
		ShopItemModule.DissableTrailButton(TrailButton) -- The same thing here
		ShopItemModule.DissableTrailButton(TrailWindow.StartTrailButton) -- for the trail window button

		FadeModule.FadeGuiObject(ShopItemFrame.DarkBack, 0.2, 1)
		GuiWindowModule.OpenCloseAnimateWindow(TrailWindow, false)

		RemoteEvents:FindFirstChild(TrailEvent.Name):FireServer(LocalPlayer) -- Dissables trail button for ever

		ShopItemModule.GiveOrRemovePlayerGadged(Gadgeds, ShopItemModule.GiveOrRemove.Give, GamePassID) -- adding gadged
		task.wait(TrailTimeInSeconds) -- Waiting Trail time
		ShopItemModule.GiveOrRemovePlayerGadged(Gadgeds, ShopItemModule.GiveOrRemove.Remove, GamePassID) -- removing gadged
	end)
end

function ShopItemModule.GiveOrRemovePlayerGadged(Gadgeds, State, ID)

	local function GetMyOnTableBoolean()
		for i, v in pairs(GadgedPresentOnTableStates) do
			if v.id == ID then
				return v.state
			end
		end
	end

	local function SetMyOnTableBoolean(setTo: boolean)
		for i, v in pairs(GadgedPresentOnTableStates) do
			if v.id == ID then
				v.state = setTo
			end
		end
	end
	
	
	if State == ShopItemModule.GiveOrRemove.Give then
		-- giving
		if GetMyOnTableBoolean() == false then
			SetMyOnTableBoolean(true)
			
			for _, gadged in Gadgeds do
				PositionFolderModule.PositionFolder(gadged, 10, "+")
			end

		end
	elseif State == ShopItemModule.GiveOrRemove.Remove then
		-- removing
		if GetMyOnTableBoolean() == true then
			SetMyOnTableBoolean(false)
			
			for _, gadged in Gadgeds do
				PositionFolderModule.PositionFolder(gadged, 10, "-")
			end

		end
	end


end

function ShopItemModule.DissableTrailButton(TrailButton)
	TrailButton.AutoButtonColor = false
	TrailButton.Interactable = false
	TrailButton.Active = false

	TrailButton.TextTransparency = 0.5
	TrailButton.BackgroundTransparency = 0.7
end


function ShopItemModule.CreateForUIGadged(ShopItemFrame: Frame, GamePassID, TrailTimeInSeconds: number?, Gadged: Folder, TrailEvent: RemoteEvent?)
	local TrailWindow = ShopItemFrame:FindFirstChild("TrailWindow")

	local TrailButton = ShopItemFrame:FindFirstChild("TrailButton")
	local BuyButton = ShopItemFrame:FindFirstChild("BuyButton")
	local StartTrailButton = TrailWindow.StartTrailButton
	local ExitTrailButton = TrailWindow.Exit

	-- On player joins --
	if MarketplaceService:UserOwnsGamePassAsync(LocalPlayer.UserId, GamePassID) then
		Gadged:FindFirstChild("ActivationButton").Visible = true
	else
		--if Values:FindFirstChild("InMorseTranslatorTrail").Value == false then
		Gadged:FindFirstChild("ActivationButton").Visible = false
		Gadged:FindFirstChild("Background").Visible = false
		--end
	end

	-- BUY button clicked
	BuyButton.MouseButton1Click:Connect(function()
		if not MarketplaceService:UserOwnsGamePassAsync(LocalPlayer.UserId, GamePassID) then
			MarketplaceService:PromptGamePassPurchase(LocalPlayer, GamePassID)
		else
			print("Allready bought")
		end
	end)

	MarketplaceService.PromptGamePassPurchaseFinished:Connect(function(player: Instance, gamePassId: number, wasPurchased: boolean)
		--CloseShop()

		if player == LocalPlayer and gamePassId == GamePassID and wasPurchased == true then

			ShopItemModule.DissableTrailButton(TrailButton) -- Doing this too, bc. it's faster.
			ShopItemModule.DissableTrailButton(TrailWindow.StartTrailButton) -- for the trail window button

			RemoteEvents:FindFirstChild(TrailEvent.Name):FireServer(LocalPlayer) -- Dissables trail button for ever
			Gadged:FindFirstChild("ActivationButton").Visible = true
		end

	end)


	-- TRAIL button clicked
	TrailButton.MouseButton1Click:Connect(function()
		FadeModule.FadeGuiObject(ShopItemFrame.DarkBack, 0.2, 0.5)
		GuiWindowModule.OpenCloseAnimateWindow(TrailWindow, true)
	end)

	-- TRAIL EXIT button clicked
	ExitTrailButton.MouseButton1Click:Connect(function()
		FadeModule.FadeGuiObject(ShopItemFrame.DarkBack, 0.2, 1)
		GuiWindowModule.OpenCloseAnimateWindow(TrailWindow, false)
	end)

	-- START TRAIL button clicked
	StartTrailButton.MouseButton1Click:Connect(function()
		ShopItemModule.DissableTrailButton(TrailButton) -- The same thing here
		ShopItemModule.DissableTrailButton(TrailWindow.StartTrailButton) -- for the trail window button

		FadeModule.FadeGuiObject(ShopItemFrame.DarkBack, 0.2, 1)
		GuiWindowModule.OpenCloseAnimateWindow(TrailWindow, false)

		RemoteEvents:FindFirstChild(TrailEvent.Name):FireServer(LocalPlayer) -- Dissables trail button for ever

		Gadged:FindFirstChild("ActivationButton").Visible = true -- adding gadged
		task.wait(TrailTimeInSeconds) -- Waiting Trail time
		Gadged:FindFirstChild("ActivationButton").Visible = false -- removing gadged
		Gadged:FindFirstChild("Background").Visible = false
	end)
end

return ShopItemModule