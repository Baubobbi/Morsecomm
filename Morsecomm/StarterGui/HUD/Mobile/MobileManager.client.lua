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

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

local Hud = script.Parent.Parent.Parent
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer.PlayerGui
local CurrentCamera = workspace.CurrentCamera
local TaskFrame = Hud.TaskFrame

_G.OnMobile = false


function HideMobileButtons()
	PlayerGui:WaitForChild("TouchGui"):Destroy()
end

function detectIfMobile()
	if UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled then
		-- Mobile
		_G.OnMobile = true
		
		Hud.Mobile.Visible = true
		Hud.TaskFrame.Dot.Visible = false
		Hud.TaskFrame.Dash.Visible = false
		Hud.TaskFrame.DashKey.Visible = false
		Hud.TaskFrame.DotKey.Visible = false
		HideMobileButtons()
		
		Hud.TaskFrame.SettingsFrame.SettingsGrid.ClassicMorseKey.Visible = false
		Hud.TaskFrame.SettingsFrame.SettingsGrid.DirectMorseDash.Visible = false
		Hud.TaskFrame.SettingsFrame.SettingsGrid.DirectMorseDot.Visible = false
		Hud.TaskFrame.SettingsFrame.SettingsGrid.Controlls.Visible = false
		
		task.wait(3)
		CurrentCamera.FieldOfView = 68
		ReplicatedStorage:WaitForChild("Values").StandartFov.Value = 68
		print("fov")
	end
end

detectIfMobile()