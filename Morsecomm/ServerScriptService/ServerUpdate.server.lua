--[[
    ================================================================
    
    Author:      @Baubobbi
    Created:     18.03.2025
    Description: Updates the game in a loop.
    
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

local Modules = ReplicatedStorage:FindFirstChild("Modules")

local MorseModule = require(Modules.MorseModule)


function Update()
	while wait() do
		MorseModule.EnsureAllGotMorseBeep()
	end
end

Update()