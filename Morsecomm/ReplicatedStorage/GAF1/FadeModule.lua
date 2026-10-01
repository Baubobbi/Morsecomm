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

local TweenService = game:GetService("TweenService")

local FadeModule = 
	{
		FadeTypes = {
			In = "In",
			Out = "Out"
		}
	}


function FadeModule.FadeSound(Sound: Sound, Duration: number, ToVolume)
	local Tween = TweenService:Create(Sound, TweenInfo.new(Duration), {Volume = ToVolume})
	Tween:Play()
end

function FadeModule.FadeGuiObject(Obj: GuiObject, Duration: number, ToTransparency)
	local Tween = TweenService:Create(Obj, TweenInfo.new(Duration), {BackgroundTransparency = ToTransparency})
	Tween:Play()
end

function FadeModule.FadeBlur(Duration, ToSize)
	local Tween = TweenService:Create(game.Lighting:FindFirstChild("Blur"), TweenInfo.new(Duration), {Size = ToSize})
	Tween:Play()
end

return FadeModule