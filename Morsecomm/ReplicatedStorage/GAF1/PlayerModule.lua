--[[
    ================================================================
    
    Author:      @Baubobbi
    Created:     11.03.2025
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

local PlayerModule = 
	{
		["StandartAnimationNames"] = {
			cheer     = "cheer",
			climb     = "climb",
			fall      = "fall",
			idle      = "idle",
			jump      = "jump",
			laugh     = "laugh",
			mood      = "mood",
			point     = "point",
			run       = "run",
			sit       = "sit",
			swim      = "swim",
			swimidle  = "swimidle",
			toollunge = "toollunge",
			toolnone  = "toolnone",
			toolslash = "toolslash",
			walk      = "walk",
			wave      = "wave"
		}
	}
PlayerModule.__index = PlayerModule


function PlayerModule.new(Player: Player)
	local newPlayerObject = {}
	newPlayerObject.Player    = Player
	newPlayerObject.Character = Player.Character
	newPlayerObject.Humanoid  = Player.Character:WaitForChild("Humanoid")
	
	setmetatable(newPlayerObject, PlayerModule)
	return newPlayerObject
end

function PlayerModule:ChangeStandardAnimationId(AnimationId_: string, StandartAnimationName)
	local Animate = self.Character:WaitForChild("Animate")
	
	Animate:FindFirstChild(StandartAnimationName):FindFirstChildWhichIsA("Animation").AnimationId = AnimationId_
end

return PlayerModule