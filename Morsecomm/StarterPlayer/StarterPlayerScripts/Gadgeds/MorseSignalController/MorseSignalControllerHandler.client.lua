--[[
    ================================================================
    
    Author:      @Baubobbi
    Created:     20.03.2025
    Description: Controlls who can send you.
    
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
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local BindableEvents = ReplicatedStorage:FindFirstChild("BindableEvents")
local RemoteEvents = ReplicatedStorage:FindFirstChild("RemoteEvents")
local Modules = ReplicatedStorage:FindFirstChild("Modules")
local Values = ReplicatedStorage:FindFirstChild("Values")
local Audio = ReplicatedStorage:FindFirstChild("Audio")
local CurrentCamera = workspace.CurrentCamera

local LED_ON_COLOR = Color3.new(0.694118, 0.305882, 0.345098)
local LED_OFF_COLOR = Color3.new(0.227451, 0.0980392, 0.113725)

local zoom = 15


function HandleMorseController(MorseController)
	local MorseStation = MorseController.Parent
	local Elements = MorseController.Elements
	
	local MutedPlayers = require(Modules.MutedPlayers)
	
	local ZoomedIn = false
	local CanLightup = true
	
	
	MorseController.Selection.ClickDetector.MouseClick:Connect(function()
		if Values.WorkspaceClickable.Value == false then return end
		
		if _G.OnMobile == true then
			zoom = 17
		end
		
		if ZoomedIn == false then
			local CamTween = TweenService:Create(CurrentCamera, TweenInfo.new(0.8), {CFrame = MorseController.ControllerCameraPart.CFrame, FieldOfView = MorseStation.CameraPart.FOV.Value + zoom})
			local SunRayTween = TweenService:Create(game:GetService("Lighting").SunRays, TweenInfo.new(1), {Intensity = 0.06})
			CamTween:Play()
			SunRayTween:Play()
			ZoomedIn = true
		else
			local CamTween = TweenService:Create(CurrentCamera, TweenInfo.new(0.8), {CFrame = MorseStation.CameraPart.CFrame, FieldOfView = MorseStation.CameraPart.FOV.Value})
			local SunRayTween = TweenService:Create(game:GetService("Lighting").SunRays, TweenInfo.new(0.8), {Intensity = 1})
			CamTween:Play()
			SunRayTween:Play()
			ZoomedIn = false
		end
	end)

	local function LEDSwitch(playername: string, Switch: boolean)
		for i, v in pairs(Elements:GetChildren()) do
			if v:IsA("Model") then
				if v:FindFirstChild("Plakette").SurfaceGui.TextLabel.Text == playername then

					if Switch == true then
						v.LED.Color = LED_ON_COLOR
					else
						v.LED.Color = LED_OFF_COLOR
					end
				end
			end
		end
	end

	local function NameElemenst()
		for i, v in pairs(Elements:GetChildren()) do
			if v:IsA("Model") then
				local player = Players:GetPlayers()[i]

				if player then
					v:FindFirstChild("Plakette").SurfaceGui.TextLabel.Text = player.Name
				else
					v:FindFirstChild("Plakette").SurfaceGui.TextLabel.Text = ""
				end
			end
		end
	end
	
	local function ResetAllElement()
		for i, v in pairs(Elements:GetChildren()) do
			if v:IsA("Model") then 
				v:FindFirstChild("Plakette").SurfaceGui.CanvasSize = Vector2.new(500, 100)
				v:FindFirstChild("LED").Color = LED_OFF_COLOR
			end
		end
	end

	local function MutePlayersBeep(playerName: string)
		for i, v in pairs(Audio.MorseBeepRecives:GetChildren()) do
			if v:IsA("Sound") and string.find(v.Name, playerName) then
				v:Stop()
				v.Volume = 0
			end
		end
	end

	local function UnMutePlayersBeep(playerName: string)
		for i, v in pairs(Audio.MorseBeepRecives:GetChildren()) do
			if v:IsA("Sound") and string.find(v.Name, playerName) then
				v.Volume = 0.5
			end
		end
	end

	RunService.RenderStepped:Connect(function()
		NameElemenst()

		if Values.Reciving.Value == false then
			ResetAllElement()
		end
	end)
	
	RemoteEvents.MorseSignal.OnClientEvent:Connect(function(Sound: Sound, Method, player: Player)

		if Method == "Play" and CanLightup == true then
			LEDSwitch(player.Name, true)

		elseif Method == "Stop" then
			LEDSwitch(player.Name, false)
		end
	end)
	
	ResetAllElement()
	
	-- Just using Active as a gate to check the state of the button... YES THIS WHOLE CODE BASE IS UNORGANIZED, but my current goal is to just get the game finished. --
	for i, v in pairs(Elements:GetChildren()) do
		if v:IsA("Model") then
			local Button = v:FindFirstChild("Button")
			local ClickDetector: ClickDetector = Button.ClickDetector
			local SurfaceGui = Button.SurfaceGui
			local TextLabel: TextLabel = SurfaceGui.TextLabel

			if ClickDetector then
				ClickDetector.MouseClick:Connect(function()
					if Values.WorkspaceClickable.Value == false then return end
					if not Players:FindFirstChild(v.Plakette.SurfaceGui.TextLabel.Text) then return end

					if TextLabel.Active == false then
						TextLabel.TextColor3 = Color3.new(1, 0.286275, 0.513725)
						table.insert(MutedPlayers, v.Plakette.SurfaceGui.TextLabel.Text)
						MutePlayersBeep(v.Plakette.SurfaceGui.TextLabel.Text)
						v.LED.Color = LED_OFF_COLOR
						CanLightup = false
						TextLabel.Active = true
					else
						TextLabel.TextColor3 = Color3.new(0.839216, 0.839216, 0.839216)
						table.remove(MutedPlayers, table.find(MutedPlayers, v.Plakette.SurfaceGui.TextLabel.Text))
						UnMutePlayersBeep(v.Plakette.SurfaceGui.TextLabel.Text)
						CanLightup = true
						TextLabel.Active = false
					end
				end)
			end
		end
	end
	
	BindableEvents.ResetAllGadgeds.Event:Connect(function()
		ResetAllElement()
		
		Values.Reciving.Value = false
		table.clear(MutedPlayers)
		
		for _, v in pairs(Players:GetPlayers()) do
			UnMutePlayersBeep(v.Name)
		end
		
		for i, v in pairs(Elements:GetChildren()) do
			if v:IsA("Model") then
				local Button = v:FindFirstChild("Button")
				local ClickDetector: ClickDetector = Button.ClickDetector
				local SurfaceGui = Button.SurfaceGui
				local TextLabel: TextLabel = SurfaceGui.TextLabel

				CanLightup = true
				TextLabel.Active = false
				
				TextLabel.TextColor3 = Color3.new(0.839216, 0.839216, 0.839216)
			end
		end
	end)
end

for i, v in pairs(CollectionService:GetTagged("MorseController")) do
	HandleMorseController(v)
end