--[[
    ================================================================
    
    Author:      @Baubobbi
    Created:     26.06.2025
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
local Players = game:GetService("Players")

local GAF1 = ReplicatedStorage:WaitForChild("GAF1")
local Hud = script.Parent.Parent.Parent
local TaskFrame = Hud.TaskFrame
local FirstPersonButton = TaskFrame.FPV

local CurrentLevel
local CamPart: Part
local NormalCamPos: CFrameValue
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character

local InFPV = false

local FadeModule = require(GAF1.FadeModule)


ReplicatedStorage:FindFirstChild("BindableEvents").ResetAllGadgeds.Event:Connect(function()
	CurrentLevel = workspace:FindFirstChild("CurrentLevel"):GetChildren()[1]
	CamPart = CurrentLevel:FindFirstChild("CameraPart")
	NormalCamPos = CurrentLevel:FindFirstChild("NoramlCameraPos")
	
	InFPV = false

	FirstPersonButton.Text = "First Person"

	workspace.CurrentCamera.FieldOfView = 55
	CamPart.CFrame = NormalCamPos.Value
	workspace.CurrentCamera.CFrame = CamPart.CFrame
end)

FirstPersonButton.MouseButton1Click:Connect(function()
	CurrentLevel = workspace:FindFirstChild("CurrentLevel"):GetChildren()[1]
	CamPart = CurrentLevel:FindFirstChild("CameraPart")
	NormalCamPos = CurrentLevel:FindFirstChild("NoramlCameraPos")
	
	FadeModule.FadeGuiObject(Hud.FullCoverBlackBackground, 0.5, 0)
	task.wait(0.6)
	
	if InFPV == false then
		InFPV = true
		
		FirstPersonButton.Text = "Normal View"
		
		workspace.CurrentCamera.FieldOfView = 70
		CamPart.CFrame = Character:FindFirstChild("UpperTorso").CFrame * CFrame.new(0, 1.6, -0.5) * CFrame.Angles(math.rad(-28), 0, 0)
		workspace.CurrentCamera.CFrame = CamPart.CFrame
	else
		InFPV = false
		
		FirstPersonButton.Text = "First Person"
		
		workspace.CurrentCamera.FieldOfView = 55
		CamPart.CFrame = NormalCamPos.Value
		workspace.CurrentCamera.CFrame = CamPart.CFrame
	end
	
	CamPart.FOV.Value = workspace.CurrentCamera.FieldOfView
	
	task.wait(0.15)
	
	FadeModule.FadeGuiObject(Hud.FullCoverBlackBackground, 0.5, 1)
end)