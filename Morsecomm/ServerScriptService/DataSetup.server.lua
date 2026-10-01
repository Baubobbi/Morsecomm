--[[
    ================================================================
    
    Author:      @Baubobbi
    Created:     23.03.2025
    Description: Manages data saving and loading with profil service.
    
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

local ServerScriptService = game:GetService("ServerScriptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local RemoteEvents = ReplicatedStorage:FindFirstChild("RemoteEvents")

local ReplicatedModules = ReplicatedStorage:FindFirstChild("Modules")
local ServerModules = ServerScriptService:FindFirstChild("Modules")

local ErrorMessages = require(ReplicatedModules.ErrorMessages)
local ProfileStore = require(ServerModules.ProfileStore)
local DataTemplate = require(ServerModules.DataTemplate)
local DataManager = require(ServerModules.DataManager)

local PlayerDataStore = ProfileStore.New("MorsecomPlayerData", DataTemplate)


function Init(Player: Player, Profile: typeof(PlayerDataStore:StartSessionAsync()))
	--print("--Init after data restore--")
	
	Profile.Data.Name = Player.Name
	Profile.Data.JoinedTime = tick()
	
	if Profile.Data.FirstTimeJoining == true then
		Profile.Data.FirstTimeJoining = false
		RemoteEvents.ActivateTutorial:FireClient(Player)
	end
	
	if Profile.Data.MorseboardTrailAbillity == false then
		RemoteEvents.DissableMorseboardTrailAbility:FireClient(Player)
	end
	
	if Profile.Data.MorseTranslatorTrailAbillity == false then
		RemoteEvents.DissableMorseTranslatorTrailAbility:FireClient(Player)
	end
end

function CreateProfile(Player: Player)
	local Profile = PlayerDataStore:StartSessionAsync("Plr_"..Player.UserId, {
		Cancel = function()
			return Player.Parent ~= Players
		end,
	})
	
	if Profile then
		Profile:AddUserId(Player.UserId) -- GDPR
		Profile:Reconcile()
		
		Profile.OnSessionEnd:Connect(function()
			DataManager.Profiles[Player] = nil
			
			Player:Kick(ErrorMessages.DataError_Basic_error)
		end)
		
		if Player.Parent == Players then
			DataManager.Profiles[Player] = Profile
			Init(Player, Profile)
		else
			Profile:EndSession() 
		end
	else
		Player:Kick(ErrorMessages.DataError_Faild_to_load_data)
	end
end

-- when player joined too early
for _, Player in pairs(Players:GetPlayers()) do
	task.spawn(CreateProfile, Player)
end

Players.PlayerAdded:Connect(CreateProfile)

Players.PlayerRemoving:Connect(function(Player)
	local Profile = DataManager.Profiles[Player]
	
	if not Profile then return end
	
	Profile.Data.PlayTime += (tick() - Profile.Data.JoinedTime)
	
	Profile:EndSession()
	DataManager.Profiles[Player] = nil
end)