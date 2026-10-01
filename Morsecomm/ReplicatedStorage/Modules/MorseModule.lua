--[[
    ================================================================
    
    Author:      @Baubobbi
    Created:     18.03.2025
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

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Audio = ReplicatedStorage:FindFirstChild("Audio")
local MorseBeepRecives = Audio.MorseBeepRecives

local MorseModule = {}


function MorseModule.GetPlayerBeepReciveSound(Player: Player)
	for i, v in pairs(MorseBeepRecives:GetChildren()) do
		if v.Name == "MorseBeepRecive_" .. Player.Name then return v end
	end
end

function MorseModule.EnsureAllGotMorseBeep()
	for i, v in pairs(game.Players:GetPlayers()) do
		if MorseModule.GetPlayerBeepReciveSound(v) == nil then
			local MorseBeepRecive = Audio.MorseBeepRecive:Clone()
			MorseBeepRecive.Name = "MorseBeepRecive_" .. v.Name
			MorseBeepRecive.Parent = MorseBeepRecives
		end
	end
end

return MorseModule