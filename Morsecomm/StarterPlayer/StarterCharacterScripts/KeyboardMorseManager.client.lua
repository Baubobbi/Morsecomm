--[[
    ================================================================
    
    Author:      @Baubobbi
    Created:     18.03.2025
    Description: Recognizing dots and dashes from the keyboard inputs
    and passing the signal to the "SignalRepeater".
    
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
local LocalPlayer = Players.LocalPlayer
local Audio = ReplicatedStorage.Audio
local A_MorseClick = Audio.MorseClick
local A_MorseBeep = Audio.MorseBeep
local Character = script.Parent
local Humanoid = Character:WaitForChild("Humanoid")
local Animator = Humanoid:FindFirstChild("Animator")

local AnimationIDs = require(Modules.AnimationIDs)
local MorseModule = require(Modules.MorseModule)

local MorseClickAnim = Instance.new("Animation")
local InputStartTime = 0
local ConnectionPartner
local SignalRecognitionTimes = {
	Dot = {Start = 0.01, End = 0.15},
	Dash = {Start = 0.15, End = 0.5}
}

MorseClickAnim.AnimationId = AnimationIDs.MorseClickAnim
local LoadedClickAnim = Animator:LoadAnimation(MorseClickAnim)


UserInputService.InputBegan:Connect(function(key)
	if key.KeyCode.Name == LocalPlayer:FindFirstChild("ClassicMorseKey").Value then -- Getting this value, bc the morse key can be changed in the settings
		
		ConnectionPartner = LocalPlayer:FindFirstChild("ConnectionPartner").Value
		InputStartTime = tick()
		
		RemoteEvents.MorseSignal:FireServer(ConnectionPartner, MorseModule.GetPlayerBeepReciveSound(LocalPlayer), "Play")
		
		if ConnectionPartner ~= LocalPlayer then A_MorseBeep:Play() end
		
		A_MorseClick:Play()
		LoadedClickAnim:Play()
	end
end)

UserInputService.InputEnded:Connect(function(key)
	if key.KeyCode.Name == LocalPlayer:FindFirstChild("ClassicMorseKey").Value then
		
		RemoteEvents.MorseSignal:FireServer(ConnectionPartner, MorseModule.GetPlayerBeepReciveSound(LocalPlayer), "Stop")
		
		local PassedTime = tick() - InputStartTime
		
		if PassedTime >= SignalRecognitionTimes.Dot.Start and PassedTime < SignalRecognitionTimes.Dot.End then
			RemoteEvents.SendFilterSignal:FireServer(".")
			
			RemoteEvents.MorseTranslatorSignal:FireServer(ConnectionPartner, ".")
		elseif PassedTime >= SignalRecognitionTimes.Dash.Start and PassedTime < SignalRecognitionTimes.Dash.End then
			RemoteEvents.SendFilterSignal:FireServer("-")
			
			RemoteEvents.MorseTranslatorSignal:FireServer(ConnectionPartner, "-")
		end
		
		if ConnectionPartner ~= Players.LocalPlayer then A_MorseBeep:Stop() end
		
		LoadedClickAnim:Stop()
	end
end)