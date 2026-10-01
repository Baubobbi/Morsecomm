--[[
    ================================================================
    
    Author:      @Baubobbi
    Created:     11.03.2025
    Description: Sets up game on start.
    
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
local StarterGui = game:GetService("StarterGui")
local Players = game:GetService("Players")

local RemoteEvents = ReplicatedStorage:WaitForChild("RemoteEvents")
local Modules = ReplicatedStorage:WaitForChild("Modules")
local Audio = ReplicatedStorage:WaitForChild("Audio")
local Values = ReplicatedStorage:WaitForChild("Values")
local GAF1 = ReplicatedStorage:WaitForChild("GAF1")
local CurrentCamera = game.Workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

local TutorialModule = require(Modules.TutorialModule)
local AnimationIDs = require(Modules.AnimationIDs)
local LevelModule = require(Modules.LevelModule)
local PlayerModule = require(GAF1.PlayerModule)
local AmbientMusicModule = require(GAF1.AmbientMusicModule)

local YPlayerStackPosIncreese = 20


function main()	
	local NewLevel = LevelModule.new(LevelModule.FirstTimePlayingLevel)
	local LocalPlayerObj = PlayerModule.new(LocalPlayer)
	
	-- Changes the sitting animation to the morse sitting anim
	LocalPlayerObj:ChangeStandardAnimationId(AnimationIDs.NewSitAnim, LocalPlayerObj.StandartAnimationNames.sit)
	
	NewLevel.Level.Parent = workspace:WaitForChild("CurrentLevel")
	NewLevel.Level:MoveTo(Vector3.new(0, YPlayerStackPosIncreese * LocalPlayer:WaitForChild("PlayerStackIndex").Value, 0))
	
	LocalPlayerObj.Character.PrimaryPart.Anchored = true
	LocalPlayerObj.Character:PivotTo(NewLevel.Level:FindFirstChild("PlayerPos").CFrame)
	LocalPlayerObj.Humanoid.Sit = true
	
	SetupCamera(NewLevel.Level:FindFirstChild("CameraPart").CFrame)
	NewLevel.Level:FindFirstChild("NoramlCameraPos").Value = NewLevel.Level:FindFirstChild("CameraPart").CFrame
	
	NewLevel:Activate()
	
	local AmibentMusic = AmbientMusicModule.NewAmbientce(Audio.AmbientMusic)
	AmibentMusic:Play()
end

function SetupCamera(CamCFrame)
	CurrentCamera.CameraType = Enum.CameraType.Scriptable
	CurrentCamera.FieldOfView = Values.StandartFov.Value
	CurrentCamera.CFrame = CamCFrame
end

task.wait(5)
main()