--[[
    ================================================================
    
    Author:      @Baubobbi
    Created:     20.03.2025
    Description: Translates the morse signal.
    
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

local RemoteEvents = ReplicatedStorage:FindFirstChild("RemoteEvents")
local Modules = ReplicatedStorage:FindFirstChild("Modules")
local Audio = ReplicatedStorage:FindFirstChild("Audio")
local CurrentCamera = workspace.CurrentCamera

local MorseStringTranslator = require(Modules.MorseStringTranslator)


function HandleMorseTranslator(MorseTranslator)
	local MainPaper = MorseTranslator.MorseStripeTranslator.MainPaper
	
	local morseBuffer = ""
	local TanslationBuffer = ""
	--local MorseBufferTable = {}
	
	local writing = false  -- Track whether the signal is active
	local ruhe = 0
	local lastsent = tick()
	local SendingPlayer
	
	local function move(charObj: TextLabel)
		charObj:TweenPosition(UDim2.new(-0.5, 0, 0, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Sine, 40)
	end

	-- TranslatorView --

	RemoteEvents.MorseTranslatorSignal.OnClientEvent:Connect(function(TheSendingPlayer, Char)
		if ReplicatedStorage.Values:FindFirstChild("Reciving").Value == false then return end -- TODO: Change to adapt with mute mahine.

		lastsent = tick()

		SendingPlayer = TheSendingPlayer
		morseBuffer ..= Char
	end)
	
	-- Have to start a coroutine, else the loop would stop the for loop
	local cor = coroutine.create(function()
		while wait() do
			ruhe = (tick() - lastsent)

			if ruhe >= 0.7 then
				if morseBuffer ~= "" then
					
					local newCharObj = script.PrintChar:Clone()
					newCharObj.Text = MorseStringTranslator.TranslateMorseChar(morseBuffer, "?")
					newCharObj.Parent = MainPaper.SurfaceGui

					move(newCharObj)
					task.wait(0.1)
				end

				morseBuffer = ""
			end
		end
	end)
	
	coroutine.resume(cor)
end

_G.TranslatorCamIn = false

function Main()
	for i, v in pairs(CollectionService:GetTagged("MorseTranslator")) do
		
		v.TranslatorClickDetector:FindFirstChild("ClickDetector").MouseClick:Connect(function()
			
			if ReplicatedStorage.Values.WorkspaceClickable.Value == false then return end
			
			if _G.TranslatorCamIn == false then
				local CamTween = TweenService:Create(CurrentCamera, TweenInfo.new(1), {CFrame = v.TranslatorCameraPart.CFrame, FieldOfView = v.Parent.CameraPart.FOV.Value - 10})
				local SunRayTween = TweenService:Create(game:GetService("Lighting").SunRays, TweenInfo.new(1), {Intensity = 0.06})
				CamTween:Play()
				SunRayTween:Play()
				_G.TranslatorCamIn = true
			else
				local CamTween = TweenService:Create(CurrentCamera, TweenInfo.new(1), {CFrame = v.Parent.CameraPart.CFrame, FieldOfView = v.Parent.CameraPart.FOV.Value})
				local SunRayTween = TweenService:Create(game:GetService("Lighting").SunRays, TweenInfo.new(1), {Intensity = 1})
				CamTween:Play()
				SunRayTween:Play()
				_G.TranslatorCamIn = false
				
			end
		end)
		--[[
		RemoteEvents.MorseTranslatorTrailEnded.OnClientEvent:Connect(function()
			local CamTween = TweenService:Create(CurrentCamera, TweenInfo.new(1), {CFrame = v.Parent.CameraPart.CFrame, FieldOfView = ReplicatedStorage.Values.StandartFov.Value})
			local SunRayTween = TweenService:Create(game:GetService("Lighting").SunRays, TweenInfo.new(1), {Intensity = 1})
			CamTween:Play()
			SunRayTween:Play()
			camIn = false
		end)]]
		
		HandleMorseTranslator(v)
	end
end

Main()