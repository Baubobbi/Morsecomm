--[[
    ================================================================
    
    Author:      @Baubobbi
    Created:     12.04.2025
    Description: Handling remoteevents for the trail system.
    Acts like a bridge.
    
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

local RemoteEvents = ReplicatedStorage:FindFirstChild("RemoteEvents")
local ServerModules = ServerScriptService:FindFirstChild("Modules")

local DataManager = require(ServerModules.DataManager)


RemoteEvents.DissableMorseboardTrailAbility.OnServerEvent:Connect(function(player)
	DataManager.SetMorseboardAbillityTo_Boolean(player, false)
	RemoteEvents.DissableMorseboardTrailAbility:FireClient(player)
end)

RemoteEvents.DissableMorseTranslatorTrailAbility.OnServerEvent:Connect(function(player)
	DataManager.SetMorseTranslatorAbillityTo_Boolean(player, false)
	RemoteEvents.DissableMorseTranslatorTrailAbility:FireClient(player)
end)