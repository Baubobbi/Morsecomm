--[[
    ================================================================
    
    Author:      @Baubobbi
    Created:     31.03.2025
    Description: Handling shop operation like buying trail & open close.
    
    ================================================================
    LICENSE:
    
    All rights reserved. This code is intended for personal use only.
    - The code may not be modified, redistributed, or altered.
    - The code may not be used or distributed for commercial purposes.
    
    Any use of this code without explicit permission from the author is prohibited.
    
    ================================================================
    NOTES: 
    
    The Trail system works like this:
        Player clicks the start trail button and the ShopItemModule
        reacts to that with sending a remoteevent to the TrailSystemDataBridge,
        giving the player the gadged and removing it when the trail time ends.
        
        The TrailSystemDataBridge recives the remoteevent, sets the according
        boolean value in the datastore to false, so that the the server remembers
        that the player allready used his trail and that it cant be used again.
        
        The TrailSystemDataBridge sends the removeevent back to the client
        and this script will recive the event and will now dissable the trail
        button.
        
        So now, when a player joins and allready used his trail abillity
        once, the DataSetup script (which runns everytime to of course
        setup the datastore) will detect that and will fire the 
        DissableMorseTranslatorTrailAbility so that the player cant press
        it again.
        
    ================================================================
]]

task.wait(5)

local MarketplaceService = game:GetService("MarketplaceService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")

local RemoteEvents = ReplicatedStorage:FindFirstChild("RemoteEvents")
local Modules = ReplicatedStorage:FindFirstChild("Modules")
local Values = ReplicatedStorage:FindFirstChild("Values")
local Audio = ReplicatedStorage:FindFirstChild("Audio")
local GAF1 = ReplicatedStorage:FindFirstChild("GAF1")
local LocalPlayer = Players.LocalPlayer
local Hud = script.Parent.Parent.Parent
local TaskFrame = Hud.TaskFrame
local ShopFrame = TaskFrame.ShopFrame
local ShopGrid = ShopFrame.ShopGrid
local Stack = TaskFrame.Stack

local PositionFolderModule = require(GAF1.PositionFolderModule)
local GuiWindowModule = require(Modules.GuiWindowModule)
local ShopItemModule = require(Modules.ShopItemModule)
local LevelModule = require(Modules.LevelModule)
local FadeModule = require(GAF1.FadeModule)


function InitShopItems()
	--=================== Morseboard ===================--
	local Morseboard = LocalPlayer.PlayerGui:FindFirstChild("Morseboard")
	if not Morseboard then warn("Can't find Morseboard inside of Level!") end

	-- Creating Shop item --
	ShopItemModule.CreateForUIGadged(ShopGrid.Morseboard, 1210236777, 300, Morseboard, RemoteEvents.DissableMorseboardTrailAbility)

	-- Dissables Trail button
	RemoteEvents.DissableMorseboardTrailAbility.OnClientEvent:Connect(function()
		ShopItemModule.DissableTrailButton(ShopGrid.Morseboard.TrailButton)
	end)

	-- If player bought the gamepass allready
	if MarketplaceService:UserOwnsGamePassAsync(LocalPlayer.UserId, 1210236777) then
		Morseboard:FindFirstChild("ActivationButton").Visible = true
	end
	--========================================================--
	
	--=================== MorseTranslator ===================--
	local MorseTranslatorsTable = GetAllGadgedsWithName("MorseTranslator")
	local MorseTranslatorGamepassID = 1086985965
	
	if not MorseTranslatorsTable then warn("Can't find MorseTranslator inside of Level!") end

	-- Creating Shop item --
	ShopItemModule.CreateForTableGadged(ShopGrid.MorseTranslator, MorseTranslatorGamepassID, 300, MorseTranslatorsTable, RemoteEvents.DissableMorseTranslatorTrailAbility)

	-- Dissables Trail button
	RemoteEvents.DissableMorseTranslatorTrailAbility.OnClientEvent:Connect(function()
		ShopItemModule.DissableTrailButton(ShopGrid.MorseTranslator.TrailButton)
	end)

	-- If player bought the gamepass allready
	if MarketplaceService:UserOwnsGamePassAsync(LocalPlayer.UserId, MorseTranslatorGamepassID) then
		Morseboard:FindFirstChild("ActivationButton").Visible = true
	end
	--========================================================
end

function CloseShop()
	Values.WorkspaceClickable.Value = true -- All morse gadgeds in workspace are now clickable

	Audio.Ui_click_close:Play()

	FadeModule.FadeGuiObject(Hud.BlackBackground, 0.2, 1)
	FadeModule.FadeBlur(0.3, 0)
	GuiWindowModule.OpenCloseAnimateWindow(ShopFrame, false)
end

function GetAllGadgedsWithName(GadgedName: string)
	local buffertable = {}
	
	for i, v in pairs(game:GetDescendants()) do
		if v.Name == GadgedName and v:IsA("Folder") then
			table.insert(buffertable, v)
		end
	end
	
	return buffertable
end

InitShopItems()