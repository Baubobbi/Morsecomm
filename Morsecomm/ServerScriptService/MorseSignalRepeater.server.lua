--[[
    ================================================================
    
    Author:      @Baubobbi
    Created:     11.03.2025
    Description: Sends the signal to the reciver
    
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

local RemoteEvents = ReplicatedStorage:FindFirstChild("RemoteEvents")


RemoteEvents.MorseSignal.OnServerEvent:Connect(function(Sendingplayer, ReciveingPlayer, Sound, Method)
	if ReciveingPlayer then
		RemoteEvents.MorseSignal:FireClient(ReciveingPlayer, Sound, Method, Sendingplayer)
	end
end)

-- Morse Translator --
RemoteEvents.MorseTranslatorSignal.OnServerEvent:Connect(function(Sendingplayer, ReciverPlayer, Method)
	if ReciverPlayer ~= nil then
		--print(Sendingplayer.Name .. " Send: " .. Method .. " to " .. ReciverPlayer.Name)
		RemoteEvents.MorseTranslatorSignal:FireClient(ReciverPlayer, Sendingplayer, Method)
	end
end)