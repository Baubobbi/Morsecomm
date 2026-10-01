--[[
    ================================================================
    
    Author:      @Baubobbi
    Created:     31.03.2025
    Description: Mod to position folders.
    
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

local PositionModule = {}

-- Operator + or - --
function PositionModule.PositionFolder(Folder: Folder, YAmount: number, Operator: string)
	for i, v in pairs(Folder:GetDescendants()) do
		if v:IsA("BasePart") then
			if Operator == "+" then
				v.Position = v.Position + Vector3.new(0, YAmount, 0)
			else
				v.Position = v.Position - Vector3.new(0, YAmount, 0)
			end
		end
	end
end

return PositionModule