
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CollectionService = game:GetService("CollectionService")

local BindableEvents = ReplicatedStorage:FindFirstChild("BindableEvents")
local Values = ReplicatedStorage:FindFirstChild("Values")
local Audio = ReplicatedStorage:FindFirstChild("Audio")

local LED_ON_COLOR = Color3.new(0.694118, 0.305882, 0.345098)
local LED_OFF_COLOR = Color3.new(0.227451, 0.0980392, 0.113725)


for i, vt in pairs(CollectionService:GetTagged("ReciveButton")) do
	local LED = vt.LED

	LED.Color = LED_OFF_COLOR

	vt.ClickDetector.MouseClick:Connect(function()
		Audio.Switch:Play()

		if LED.CanCollide == true then
			LED.CanCollide = false
			LED.Color = LED_ON_COLOR
			Values.Reciving.Value = true
			Audio["Radiostatic "]:Play()
			Audio.MorseBeep:Stop()

			for i, v in pairs(Audio.MorseBeepRecives:GetChildren()) do
				if v:IsA("Sound") and string.find(v.Name, "MorseBeepRecive") then
					v.Volume = 0.5
				end
			end
		else
			LED.CanCollide = true
			LED.Color = LED_OFF_COLOR
			Values.Reciving.Value = false
			Audio["Radiostatic "]:Stop()

			for i, v in pairs(Audio.MorseBeepRecives:GetChildren()) do
				if v:IsA("Sound") and string.find(v.Name, "MorseBeepRecive") then
					v.Volume = 0
					v:Stop()
				end
			end
		end
	end)
	
	BindableEvents.ResetAllGadgeds.Event:Connect(function()
		LED.CanCollide = true
		Values.Reciving.Value = false
		LED.Color = LED_OFF_COLOR
		Audio["Radiostatic "]:Stop()
		
		for i, v in pairs(Audio.MorseBeepRecives:GetChildren()) do
			if v:IsA("Sound") and string.find(v.Name, "MorseBeepRecive") then
				v.Volume = 0
				v:Stop()
			end
		end
	end)
end