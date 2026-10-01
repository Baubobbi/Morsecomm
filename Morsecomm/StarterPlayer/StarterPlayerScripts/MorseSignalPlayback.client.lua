--[[
    ================================================================
    
    Author:      @Baubobbi
    Created:     11.03.2025
    Description: Plays the morse signal when recivied
    
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

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local RemoteEvents = ReplicatedStorage:FindFirstChild("RemoteEvents")
local Modules = ReplicatedStorage:FindFirstChild("Modules")
local Values = ReplicatedStorage:FindFirstChild("Values")

local MutedPlayers = require(Modules.MutedPlayers)


RemoteEvents.MorseSignal.OnClientEvent:Connect(function(Sound, Method, SendingPlayer)
	if Values.Reciving.Value == false or table.find(MutedPlayers, SendingPlayer.Name) then return end
	
	if Method == "Play" then
		Sound:Play()
	elseif Method == "Stop" then
		Sound:Stop()
	end
end)