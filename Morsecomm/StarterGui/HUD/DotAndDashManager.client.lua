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

local RemoteEvents = ReplicatedStorage:FindFirstChild("RemoteEvents")
local Modules = ReplicatedStorage:FindFirstChild("Modules")
local Audio = ReplicatedStorage:FindFirstChild("Audio")
local LocalPlayer = Players.LocalPlayer
local Hud = script.Parent.Parent.Parent
local MorseBeep = Audio.MorseBeep
local MorseClick = Audio.MorseClick
local MorseKey = Enum.KeyCode.Space
local TaskFrame = Hud.TaskFrame
local Dash = TaskFrame.Dash
local Dot = TaskFrame.Dot
local ConnectionPartner

local DotGate = false
local DashGate = false

local ClickAnim = "rbxassetid://85122768249149"

local MorseModule = require(Modules.MorseModule)

local Character: Model = Players.LocalPlayer.Character
local Humanoid: Humanoid = Character:FindFirstChild("Humanoid")
local animation = Instance.new("Animation")
animation.AnimationId = ClickAnim
local ClickAnimationLoaded: Animator = Humanoid:FindFirstChild("Animator"):LoadAnimation(animation)


function GetMyBeepReciveSound()
	for i, v in pairs(Audio:GetChildren()) do
		if v.Name == Players.LocalPlayer.Name .. "_MorseBeepRecive" then return v end
	end
end

function GetValueFromPlayerValues(valname)
	
	if Players.LocalPlayer:WaitForChild(valname) then
		return Players.LocalPlayer:WaitForChild(valname).Value
	end
end

local MorseBeepRecive = GetMyBeepReciveSound()

function OnDot()
	if DotGate == false then
		DotGate = true
		
		if Players.LocalPlayer:FindFirstChild("ConnectionPartner").Value ~= Players.LocalPlayer then
			MorseBeep:Play()
		end

		ConnectionPartner = LocalPlayer:FindFirstChild("ConnectionPartner").Value

		ClickAnimationLoaded:Play()
		RemoteEvents.MorseSignal:FireServer(ConnectionPartner, MorseModule.GetPlayerBeepReciveSound(LocalPlayer), "Play")
		task.wait(0.15)
		RemoteEvents.MorseSignal:FireServer(ConnectionPartner, MorseModule.GetPlayerBeepReciveSound(LocalPlayer), "Stop")
		ClickAnimationLoaded:Stop()
		MorseBeep:Stop()

		RemoteEvents.MorseTranslatorSignal:FireServer(Players.LocalPlayer:FindFirstChild("ConnectionPartner").Value, ".")
		
		DotGate = false
	end
end

function OnDash()
	if DashGate == false then
		DashGate = true
		
		if Players.LocalPlayer:FindFirstChild("ConnectionPartner").Value ~= Players.LocalPlayer then
			MorseBeep:Play()
		end

		ConnectionPartner = LocalPlayer:FindFirstChild("ConnectionPartner").Value

		ClickAnimationLoaded:Play()
		RemoteEvents.MorseSignal:FireServer(ConnectionPartner, MorseModule.GetPlayerBeepReciveSound(LocalPlayer), "Play")
		task.wait(0.3)
		RemoteEvents.MorseSignal:FireServer(ConnectionPartner, MorseModule.GetPlayerBeepReciveSound(LocalPlayer), "Stop")
		ClickAnimationLoaded:Stop()
		MorseBeep:Stop()

		RemoteEvents.MorseTranslatorSignal:FireServer(Players.LocalPlayer:FindFirstChild("ConnectionPartner").Value, "-")
		
		DashGate = false
	end
end

Dot.MouseButton1Down:Connect(function()
	OnDot()
end)

Dash.MouseButton1Down:Connect(function()
	OnDash()
end)

---------------------------------------------------

UserInputService.InputBegan:Connect(function(key)
	if key.KeyCode.Name == Players.LocalPlayer:FindFirstChild("DashKey").Value then
		OnDash()
	elseif key.KeyCode.Name == Players.LocalPlayer:FindFirstChild("DotKey").Value then
		OnDot()
	end
end)
