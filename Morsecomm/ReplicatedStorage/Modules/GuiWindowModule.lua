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

local GuiWindowModule = {}

function GuiWindowModule.OpenCloseAnimateWindow(Window: Frame, Open: boolean)
	if Open == true then
		Window.Visible = true
		Window:TweenPosition(UDim2.new(0.303, 0, 0.131, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Sine, 0.17, true)
	else
		Window:TweenPosition(UDim2.new(0.303, 0, 4, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Sine, 0.17, true)
		task.wait(0.17)
		Window.Visible = false
	end
end

function GuiWindowModule.CloseAllWindowsExceptMine(Mine: Frame, LocationOfOthers: {}, BlackList: {})
	for i, v in pairs(LocationOfOthers) do
		if not table.find(BlackList, v) and v.Name ~= Mine.Name and v:IsA("Frame") and v.Visible == true then
			GuiWindowModule.OpenCloseAnimateFrame(v, false)
		end
	end
end

return GuiWindowModule
