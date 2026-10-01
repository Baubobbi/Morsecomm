--[[
    ================================================================
    
    Author:      @Baubobbi
    Created:     11.03.2025
    Description: Contains functions for levels.
    
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

local Levels = ReplicatedStorage:WaitForChild("Levels")

local LevelModule = {
	FirstTimePlayingLevel = Levels:FindFirstChild("MorseStation_Hills")
}
LevelModule.__index = LevelModule


function LevelModule.new(Level: Model)
	local newLevel = {}
	newLevel.Level = Level

	setmetatable(newLevel, LevelModule)
	return newLevel
end

function LevelModule:Activate()
	local LevelActionsModule = require(self.Level:FindFirstChild("LevelActions"))

	if LevelActionsModule then
		LevelActionsModule.Start()
	else
		warn("|  The LevelActions Module cannot be found inside of the level.")
	end
end

function LevelModule.GetRandomLevel()
	return Levels:GetChildren()[math.random(1, #Levels:GetChildren())]
end

function LevelModule.GetCurrentLevel()
	return workspace:FindFirstChild("CurrentLevel"):FindFirstChildWhichIsA("Model")
end

function LevelModule:Deactivate() 
	local LevelActionsModule = require(self.Level:FindFirstChild("LevelActions"))
	
	if LevelActionsModule then 		
		LevelActionsModule.Stop() 	
	else 		
		warn("|  The LevelActions Module cannot be found inside of the level.") 	
	end 
end

return LevelModule