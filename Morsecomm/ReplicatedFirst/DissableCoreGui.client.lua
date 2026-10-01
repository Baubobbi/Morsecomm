--[[
    ================================================================
    
    Author:      @Baubobbi
    Created:     11.03.2025
    Description: Dissables robloxs core gui.
    
    ================================================================
    LICENSE:
    
    All rights reserved. This code is intended for personal use only.
    - The code may not be modified, redistributed, or altered.
    - The code may not be used or distributed for commercial purposes.
    
    Any use of this code without explicit permission from the author is prohibited.
    
    ================================================================
    NOTES: Had to do this because it should happen immedietly and
    not 5s delayed, wich is the case in the CoreSetup code.
    ================================================================
]]

local ContentProvider = game:GetService("ContentProvider")
local StarterGui = game:GetService("StarterGui")


function HideCoreGUI()
	StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, false)
	StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Captures, true)
	
	task.wait(4)
	StarterGui:SetCore("ResetButtonCallback", false)
end

HideCoreGUI()