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
local Players = game:GetService("Players")

task.wait(1)

local RemoteEvents = ReplicatedStorage:WaitForChild("RemoteEvents")
local Modules = ReplicatedStorage:FindFirstChild("Modules")
local Hud = script.Parent.Parent.Parent
local Audio = ReplicatedStorage.Audio
local MorseBeep = Audio.MorseBeep
local MorseClick = Audio.MorseClick
local Morsebutton = Hud.Mobile.MorseButton
local LocalPlayer = Players.LocalPlayer

local ClickAnim = "rbxassetid://85122768249149"

local Character: Model = LocalPlayer.Character
local Humanoid: Humanoid = Character:FindFirstChild("Humanoid")
local animation = Instance.new("Animation")
animation.AnimationId = ClickAnim
local ClickAnimationLoaded: Animator = Humanoid:FindFirstChild("Animator"):LoadAnimation(animation)
local StartTime = 0

local MorseModule = require(Modules.MorseModule)

local MorseBeepRecive = MorseModule.GetPlayerBeepReciveSound(LocalPlayer)



Morsebutton.MouseButton1Down:Connect(function()
	
	print("true")

	StartTime = tick()

	RemoteEvents.MorseSignal:FireServer(Players.LocalPlayer:FindFirstChild("ConnectionPartner").Value, MorseBeepRecive, "Play")

	if Players.LocalPlayer:FindFirstChild("ConnectionPartner").Value ~= Players.LocalPlayer then
		MorseBeep:Play()
	end

	MorseClick:Play()
	ClickAnimationLoaded:Play()
	
	Morsebutton.Parent.MobileMorseInterface.Telegraph.TPart.Orientation = Vector3.new(0, 90, 95)
end)

Morsebutton.MouseButton1Up:Connect(function()
	
	RemoteEvents.MorseSignal:FireServer(Players.LocalPlayer:FindFirstChild("ConnectionPartner").Value, MorseBeepRecive, "Stop")

	local pasedTime = tick() - StartTime

	if pasedTime >= 0.01 and pasedTime < 0.15 then
		RemoteEvents.SendFilterSignal:FireServer(".")
		
		RemoteEvents.MorseTranslatorSignal:FireServer(Players.LocalPlayer:FindFirstChild("ConnectionPartner").Value, ".")
	elseif pasedTime >= 0.15 and pasedTime < 0.5 then
		RemoteEvents.SendFilterSignal:FireServer("-")
		
		RemoteEvents.MorseTranslatorSignal:FireServer(Players.LocalPlayer:FindFirstChild("ConnectionPartner").Value, "-")
	end

	if Players.LocalPlayer:FindFirstChild("ConnectionPartner").Value ~= Players.LocalPlayer then
		MorseBeep:Stop()
	end
	ClickAnimationLoaded:Stop()
	
	Morsebutton.Parent.MobileMorseInterface.Telegraph.TPart.Orientation = Vector3.new(0, 90, 90)
end)