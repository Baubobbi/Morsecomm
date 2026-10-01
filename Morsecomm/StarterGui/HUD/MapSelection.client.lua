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

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local BindableEvents = ReplicatedStorage:FindFirstChild("BindableEvents")
local Modules = ReplicatedStorage:FindFirstChild("Modules")
local Levels = ReplicatedStorage:FindFirstChild("Levels")
local Values = ReplicatedStorage:WaitForChild("Values")
local Audio = ReplicatedStorage:WaitForChild("Audio")
local GAF1 = ReplicatedStorage:WaitForChild("GAF1")
local CurrentCamera = game.Workspace.CurrentCamera
local Hud = script.Parent.Parent.Parent
local TaskFrame = Hud.TaskFrame
local MapSelectionButton = TaskFrame.MapSelectionButton
local Grid = MapSelectionButton.Grid
local DropDownButton = MapSelectionButton.DropDown
local LocalPlayer = Players.LocalPlayer

local LevelModule = require(Modules.LevelModule)
local PlayerModule = require(GAF1.PlayerModule)
local FadeModule = require(GAF1.FadeModule)


DropDownButton.MouseButton1Click:Connect(function()
	if DropDownButton.Text == "▲" then
		DropDownButton.Text = "▼"
		Grid.Visible = true
		MapSelectionButton.Menu.Visible = true
		Audio.DropDownClick:Play()
	else
		DropDownButton.Text = "▲"
		Grid.Visible = false
		MapSelectionButton.Menu.Visible = false
		Audio.DropDownClick:Play()
	end
end)

for _, v in pairs(Grid:GetChildren()) do
	if v:IsA("TextButton") then
		
		v.MapImage.MouseButton1Click:Connect(function()
			MapSelectionButton.MapPreviewImage.Image = v.MapImage.Image
			
			FadeModule.FadeGuiObject(MapSelectionButton.FadingBackground, 0.3, 0.25)
			wait(0.3)
			MapSelectionButton.MapPreviewImage.Visible = true
		end)
		
		MapSelectionButton.MapPreviewImage.ExitButton.MouseButton1Click:Connect(function()
			MapSelectionButton.MapPreviewImage.Visible = false
			FadeModule.FadeGuiObject(MapSelectionButton.FadingBackground, 0.3, 1)
		end)
		
		v.MouseButton1Click:Connect(function()
			Audio.MapSelectClick:Play()
			
			DropDownButton.Text = "▲"
			Grid.Visible = false
			MapSelectionButton.Menu.Visible = false
			MapSelectionButton.Text = v.MapName.Text
			
			_G.TranslatorCamIn = false
			BindableEvents.ResetAllGadgeds:Fire()
			
			FadeModule.FadeGuiObject(Hud.FullCoverBlackBackground, 0.5, 0)
			task.wait(0.5)
			local currentLevel = LevelModule.new(LevelModule.GetCurrentLevel())
			currentLevel.Level.Parent = Levels
			currentLevel:Deactivate()
			
			
			local NewLevel = LevelModule.new(v.MapLink.Value)
			local LocalPlayerObj = PlayerModule.new(LocalPlayer)

			-- Changes the sitting animation to the morse sitting anim
			--LocalPlayerObj:ChangeStandardAnimationId(AnimationIDs.NewSitAnim, LocalPlayerObj.StandartAnimationNames.sit)

			NewLevel.Level.Parent = workspace:FindFirstChild("CurrentLevel")
			NewLevel.Level:MoveTo(Vector3.new(0, 20 * LocalPlayer:WaitForChild("PlayerStackIndex").Value, 0))

			LocalPlayerObj.Character.PrimaryPart.Anchored = true
			LocalPlayerObj.Character:PivotTo(NewLevel.Level:FindFirstChild("PlayerPos").CFrame)
			LocalPlayerObj.Humanoid.Sit = true

			SetupCamera(NewLevel.Level:FindFirstChild("CameraPart").CFrame)
			NewLevel.Level:FindFirstChild("NoramlCameraPos").Value = NewLevel.Level:FindFirstChild("CameraPart").CFrame
			task.wait(0.5)
			FadeModule.FadeGuiObject(Hud.FullCoverBlackBackground, 0.5, 1)

			NewLevel:Activate()
			
		end)
	end
end

function SetupCamera(CamCFrame)
	CurrentCamera.CameraType = Enum.CameraType.Scriptable
	CurrentCamera.FieldOfView = Values.StandartFov.Value
	CurrentCamera.CFrame = CamCFrame
end