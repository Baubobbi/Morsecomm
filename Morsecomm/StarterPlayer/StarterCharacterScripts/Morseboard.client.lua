--[[
    ================================================================
    
    Author:      @Baubobbi
    Created:     12.05.2025
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
local LocalPlayer = Players.LocalPlayer
local Audio = ReplicatedStorage.Audio
local A_MorseClick = Audio.MorseClick
local A_MorseBeep = Audio.MorseBeep
local Character = script.Parent
local Humanoid = Character:WaitForChild("Humanoid")
local Animator = Humanoid:FindFirstChild("Animator")
local Morseboard = LocalPlayer.PlayerGui:FindFirstChild("Morseboard")
local Background = Morseboard.Background
local ActivationButton = Morseboard.ActivationButton

local MorseStringTranslator = require(Modules.MorseStringTranslator)
local AnimationIDs = require(Modules.AnimationIDs)
local MorseModule = require(Modules.MorseModule)

local MorseClickAnim = Instance.new("Animation")
local InputStartTime = 0
local ConnectionPartner

MorseClickAnim.AnimationId = AnimationIDs.MorseClickAnim
local LoadedClickAnim = Animator:LoadAnimation(MorseClickAnim)

local CanPress = true


function Main()
	
	for _, key in pairs(Background.Keyboard.KeyTable:GetChildren()) do
		
		if key:IsA("TextButton") then
			
			key.MouseButton1Click:Connect(function()	
				if CanPress == true then
					CanPress = false
					
					local CHAR = key.Text
					local TranslatedLetter = MorseStringTranslator.TranslateCharIntoMorse(CHAR, "")

					if TranslatedLetter == nil then return end

					for _, char in pairs(string.split(TranslatedLetter, "")) do
						if char == "." then
							ConnectionPartner = LocalPlayer:FindFirstChild("ConnectionPartner").Value

							if ConnectionPartner ~= LocalPlayer then A_MorseBeep:Play() end

							A_MorseClick:Play()
							LoadedClickAnim:Play()


							RemoteEvents.MorseSignal:FireServer(ConnectionPartner, MorseModule.GetPlayerBeepReciveSound(LocalPlayer), "Play")
							task.wait(0.15)
							RemoteEvents.MorseSignal:FireServer(ConnectionPartner, MorseModule.GetPlayerBeepReciveSound(LocalPlayer), "Stop")

							if ConnectionPartner ~= LocalPlayer then A_MorseBeep:Stop() end

							A_MorseClick:Stop()
							LoadedClickAnim:Stop()

							RemoteEvents.SendFilterSignal:FireServer(".")
							RemoteEvents.MorseTranslatorSignal:FireServer(ConnectionPartner, ".")


						elseif char == "-" then

							ConnectionPartner = LocalPlayer:FindFirstChild("ConnectionPartner").Value

							if ConnectionPartner ~= LocalPlayer then A_MorseBeep:Play() end

							A_MorseClick:Play()
							LoadedClickAnim:Play()


							RemoteEvents.MorseSignal:FireServer(ConnectionPartner, MorseModule.GetPlayerBeepReciveSound(LocalPlayer), "Play")
							task.wait(0.5)
							RemoteEvents.MorseSignal:FireServer(ConnectionPartner, MorseModule.GetPlayerBeepReciveSound(LocalPlayer), "Stop")

							if ConnectionPartner ~= LocalPlayer then A_MorseBeep:Stop() end

							A_MorseClick:Stop()
							LoadedClickAnim:Stop()

							RemoteEvents.SendFilterSignal:FireServer("-")
							RemoteEvents.MorseTranslatorSignal:FireServer(ConnectionPartner, "-")

						end
					end
					
					task.wait(0.6)
					
					CanPress = true
				end
			end)
		end
	end
end

Main()