--[[
    ================================================================
    
    Author:      @Baubobbi
    Created:     12.05.2025
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

local Morseboard = script.Parent.Parent
local Background = Morseboard.Background
local ActivationButton = Morseboard.ActivationButton


ActivationButton.MouseButton1Click:Connect(function()
	if Background.Visible == false then
		Background.Visible = true
		Background:TweenPosition(UDim2.new(0.162, 0, 0.534, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Sine, 0.25, true)
	else
		Background:TweenPosition(UDim2.new(0.162, 0, 1.1, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Sine, 0.25, true, function()
			Background.Visible = false
		end)
	end

end)