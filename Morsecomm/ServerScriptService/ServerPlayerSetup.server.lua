--[[
    ================================================================
    
    Author:      @Baubobbi
    Created:     11.03.2025
    Description: Generates Values that are placed inside the player
    and increeses the PlayerStackIndex.
    
    ================================================================
    LICENSE:
    
    All rights reserved. This code is intended for personal use only.
    - The code may not be modified, redistributed, or altered.
    - The code may not be used or distributed for commercial purposes.
    
    Any use of this code without explicit permission from the author is prohibited.
    
    ================================================================
    NOTES:
    
    We got a PlayerStackIndex so that the players aren't overlapping
    in game. The Levels are all local and not visible for others
    but the players are visible for everyon, so this is a fix.

    ================================================================
]]

local Players = game:GetService("Players")

local PlayerStackIndexBuffer = 0


function GenerateValues(LocalPlayer)
	local PlayerStackIndex = Instance.new("NumberValue")
	PlayerStackIndex.Parent = LocalPlayer
	PlayerStackIndex.Name = "PlayerStackIndex"
	PlayerStackIndex.Value = PlayerStackIndexBuffer

	local ConnectionPartner = Instance.new("ObjectValue")
	ConnectionPartner.Parent = LocalPlayer
	ConnectionPartner.Name = "ConnectionPartner"

	local ClassicMorseKey = Instance.new("StringValue")
	ClassicMorseKey.Parent = LocalPlayer
	ClassicMorseKey.Name = "ClassicMorseKey"
	ClassicMorseKey.Value = "Space"
	
	local DotKey = Instance.new("StringValue")
	DotKey.Parent = LocalPlayer
	DotKey.Name = "DotKey"
	DotKey.Value = "Q"

	local DashKey = Instance.new("StringValue")
	DashKey.Parent = LocalPlayer
	DashKey.Name = "DashKey"
	DashKey.Value = "E"
end

Players.PlayerAdded:Connect(function(player)
	PlayerStackIndexBuffer += 1
	
	GenerateValues(player)
end)