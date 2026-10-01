--[[
    ================================================================
    
    Author:      @Baubobbi
    Created:     19.03.2025
    Description: Sends the signal to the chosen reciver.
    
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
local CollectionService = game:GetService("CollectionService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")

local BindableEvents = ReplicatedStorage:FindFirstChild("BindableEvents")
local RemoteEvents = ReplicatedStorage:FindFirstChild("RemoteEvents")
local Values = ReplicatedStorage:FindFirstChild("Values")
local Audio = ReplicatedStorage:FindFirstChild("Audio")
local CurrentCamera = workspace.CurrentCamera

local Index = 0


function HandleMorseSender(MorseModule)
	local CurrentlyDisplayedPlayer = MorseModule.NameDisplay
	
	local ZoomedIn = false
	
	-- PlayerSelector --
	MorseModule.PlayerSelector:FindFirstChild("ClickDetector").MouseClick:Connect(function(player)
		if Values.WorkspaceClickable.Value == false then return end

		if ZoomedIn == false then
			local CamTween = TweenService:Create(CurrentCamera, TweenInfo.new(0.8), {CFrame = MorseModule.PlayerSelectCameraPart.CFrame, FieldOfView = MorseModule.Parent.CameraPart.FOV.Value - 30})
			local SunRayTween = TweenService:Create(game:GetService("Lighting").SunRays, TweenInfo.new(0.8), {Intensity = 0.06})
			CamTween:Play()
			SunRayTween:Play()
			ZoomedIn = true
		else
			local CamTween = TweenService:Create(CurrentCamera, TweenInfo.new(0.8), {CFrame = MorseModule.Parent.CameraPart.CFrame, FieldOfView = MorseModule.Parent.CameraPart.FOV.Value})
			local SunRayTween = TweenService:Create(game:GetService("Lighting").SunRays, TweenInfo.new(0.8), {Intensity = 1})
			CamTween:Play()
			SunRayTween:Play()
			ZoomedIn = false
		end
	end)

	-- OK Button --
	MorseModule.OkButton:FindFirstChild("ClickDetector").MouseClick:Connect(function(player)
		if Values.WorkspaceClickable.Value == false then return end
		Audio.MorseClick:Play()

		--print("O!2")
		MorseModule.OkButton.Position -= Vector3.new(0, 0, 0.01)
		task.wait(0.2)
		MorseModule.OkButton.Position += Vector3.new(0, 0, 0.01)

		local CamTween = TweenService:Create(CurrentCamera, TweenInfo.new(0.8), {CFrame = MorseModule.Parent.CameraPart.CFrame, FieldOfView = Values.StandartFov.Value})
		local SunRayTween = TweenService:Create(game:GetService("Lighting").SunRays, TweenInfo.new(0.8), {Intensity = 1})
		CamTween:Play()
		SunRayTween:Play()

		player:FindFirstChild("ConnectionPartner").Value = CurrentlyDisplayedPlayer

		if CurrentlyDisplayedPlayer ~= nil then
			Audio.RadioSwitchConnect:Play()
			task.wait(1)
			Audio.RadioSwitchConnect:Stop()
		end

		Audio.MorseBeep:Stop()
	end)

	MorseModule.NameDisplay.ClickDetector.MouseClick:Connect(function(player)
		if Values.WorkspaceClickable.Value == false then return end
		local TweenRotation = TweenService:Create(MorseModule.NameDisplay, TweenInfo.new(0.8), {Rotation = Vector3.new(35, MorseModule.NameDisplay.Rotation.Y, MorseModule.NameDisplay.Rotation.Z)})
		TweenRotation:Play()

		CurrentlyDisplayedPlayer = GetNextPlayer()
		MorseModule.NameDisplay.Rotation = Vector3.new(-35, 0, 0)

		if CurrentlyDisplayedPlayer == nil then
			MorseModule.NameDisplay.SurfaceGui.TextLabel.Text = "- No Reciver -"
		else
			MorseModule.NameDisplay.SurfaceGui.TextLabel.Text = CurrentlyDisplayedPlayer.Name
		end

		local TweenRotation2 = TweenService:Create(MorseModule.NameDisplay, TweenInfo.new(0.8), {Rotation = Vector3.new(0, MorseModule.NameDisplay.Rotation.Y, MorseModule.NameDisplay.Rotation.Z)})
		TweenRotation2:Play()
	end)
	
	BindableEvents.ResetAllGadgeds.Event:Connect(function()
		Index = 0
		
		CurrentlyDisplayedPlayer = nil
		MorseModule.NameDisplay.SurfaceGui.TextLabel.Text = "- No Reciver -"
		Players.LocalPlayer:FindFirstChild("ConnectionPartner").Value = nil
	end)
end

function GetNextPlayer()
	if Index ~= #Players:GetPlayers() then
		Index += 1
	else
		Index = 0
	end

	return Players:GetPlayers()[Index]
end

for i, v in pairs(CollectionService:GetTagged("MorseSender")) do
	HandleMorseSender(v)
end