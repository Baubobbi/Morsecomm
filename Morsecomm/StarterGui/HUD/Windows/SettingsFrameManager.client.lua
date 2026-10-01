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
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")


local Values = ReplicatedStorage:WaitForChild("Values")
local LocalPlayer = Players.LocalPlayer
local Hud = script.Parent.Parent.Parent
local TaskFrame = Hud.TaskFrame
local SettingsFrame = TaskFrame.SettingsFrame
local SettingsGrid = SettingsFrame.SettingsGrid
local Mouse = LocalPlayer:GetMouse()
-- Settings elements --
local ClassicMorseKey = SettingsGrid.ClassicMorseKey
local DirectMorseDot = SettingsGrid.DirectMorseDot
local DirectMorseDash = SettingsGrid.DirectMorseDash
local MorseSounds = SettingsGrid.MorseSounds
local MusicSounds = SettingsGrid.MusicSounds

local focus = false
local Dotfocus = false
local Dashfocus = false
local MourseSoundPressed = false
local MusicSoundPressed = false


function OneTimeSettingsSetup()
	ClassicMorseKey.KeyInputBox.Text = LocalPlayer:FindFirstChild("ClassicMorseKey").Value
	DirectMorseDot.KeyInputBox.Text = LocalPlayer:FindFirstChild("DotKey").Value
	DirectMorseDash.KeyInputBox.Text = LocalPlayer:FindFirstChild("DashKey").Value
end

------------ Direct Morse Dot ------------
DirectMorseDot.KeyInputBox.Focused:Connect(function()
	Dotfocus = true
	local tween = TweenService:Create(DirectMorseDot.KeyInputBox.UIStroke, TweenInfo.new(0.3), {Thickness = 1.3})
	tween:Play()
end)

DirectMorseDot.KeyInputBox.FocusLost:Connect(function()
	Dotfocus = false
	local tween = TweenService:Create(DirectMorseDot.KeyInputBox.UIStroke, TweenInfo.new(0.1), {Thickness = 0})
	tween:Play()
end)

UserInputService.InputBegan:Connect(function(key)
	if Dotfocus == true then
		DirectMorseDot.KeyInputBox.Text = key.KeyCode.Name

		if key.KeyCode.Name == "Unknown" then
			LocalPlayer:FindFirstChild("DotKey").Value = ""
		else
			LocalPlayer:FindFirstChild("DotKey").Value = key.KeyCode.Name

			Dotfocus = false
			local tween = TweenService:Create(DirectMorseDot.KeyInputBox.UIStroke, TweenInfo.new(0.1), {Thickness = 0})
			tween:Play()
		end
	end
end)

------------ Direct Morse Dash ------------
DirectMorseDash.KeyInputBox.Focused:Connect(function()
	Dashfocus = true
	local tween = TweenService:Create(DirectMorseDash.KeyInputBox.UIStroke, TweenInfo.new(0.3), {Thickness = 1.3})
	tween:Play()
end)

DirectMorseDash.KeyInputBox.FocusLost:Connect(function()
	Dashfocus = false
	local tween = TweenService:Create(DirectMorseDash.KeyInputBox.UIStroke, TweenInfo.new(0.1), {Thickness = 0})
	tween:Play()
end)

UserInputService.InputBegan:Connect(function(key)
	if Dashfocus == true then
		DirectMorseDash.KeyInputBox.Text = key.KeyCode.Name

		if key.KeyCode.Name == "Unknown" then
			LocalPlayer:FindFirstChild("DashKey").Value = ""
		else
			LocalPlayer:FindFirstChild("DashKey").Value = key.KeyCode.Name

			Dashfocus = false
			local tween = TweenService:Create(DirectMorseDash.KeyInputBox.UIStroke, TweenInfo.new(0.1), {Thickness = 0})
			tween:Play()
		end
	end
end)

------------ ClassicMorseKey ------------
ClassicMorseKey.KeyInputBox.Focused:Connect(function()
	focus = true
	local tween = TweenService:Create(ClassicMorseKey.KeyInputBox.UIStroke, TweenInfo.new(0.3), {Thickness = 1.3})
	tween:Play()
end)

ClassicMorseKey.KeyInputBox.FocusLost:Connect(function()
	focus = false
	local tween = TweenService:Create(ClassicMorseKey.KeyInputBox.UIStroke, TweenInfo.new(0.1), {Thickness = 0})
	tween:Play()
end)

UserInputService.InputBegan:Connect(function(key)
	if focus == true then
		ClassicMorseKey.KeyInputBox.Text = key.KeyCode.Name

		if key.KeyCode.Name == "Unknown" then
			LocalPlayer:FindFirstChild("ClassicMorseKey").Value = ""
		else
			LocalPlayer:FindFirstChild("ClassicMorseKey").Value = key.KeyCode.Name

			focus = false
			local tween = TweenService:Create(ClassicMorseKey.KeyInputBox.UIStroke, TweenInfo.new(0.1), {Thickness = 0})
			tween:Play()
		end
	end
end)

------------ Morse Sounds ------------
MorseSounds.Slider.Position = UDim2.new(0.527, -3, 0.33, 0)

MorseSounds.Slider:GetPropertyChangedSignal("Position"):Connect(function()
	local perc = MorseSounds.Slider.Position.X.Offset/244

	for i, v in pairs(game:GetService("ReplicatedStorage").Audio:GetChildren()) do
		if string.find(v.Name, "Morse") and v.Name ~= "MorseClick" then
			if v:IsA("Sound") then
				v.Volume = perc
			end
		end
	end

	for i, v in pairs(game:GetService("ReplicatedStorage").Audio.MorseBeepRecives:GetChildren()) do
		if v:IsA("Sound") then
			v.Volume = perc
		end
	end
end)

------------ Music Sounds ------------
MusicSounds.Slider.Position = UDim2.new(0.523, -3, 0.33, 0)

MusicSounds.Slider:GetPropertyChangedSignal("Position"):Connect(function()
	local perc = MusicSounds.Slider.Position.X.Offset/244

	for i, v in pairs(game:GetService("ReplicatedStorage").Audio.AmbientMusic:GetChildren()) do
		if v:IsA("Sound") then
			v.Volume = perc
			Values.MusicMasterVolume.Value = perc
		end
	end
end)



--[[
------------ Morse Sounds ------------
local MorseSoundsPercentage
MorseSounds.Slider.Position = UDim2.new(0.521, 52, 0.33, 0)

MorseSounds.Slider.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		MourseSoundPressed = true

		while MourseSoundPressed == true do
			local percentage = (UserInputService:GetMouseLocation() - MorseSounds.SliderBack.AbsolutePosition)
			MorseSounds.Slider.Position = UDim2.new(0.521, math.clamp(percentage.X, 0, MorseSounds.SliderBack.AbsoluteSize.X), 0.33, 0)

			MorseSoundsPercentage = math.floor(math.clamp(percentage.X, 0, MorseSounds.SliderBack.AbsoluteSize.X) / MorseSounds.SliderBack.AbsoluteSize.X * 100)
			MorseSounds.Percentage.Visible = true
			MorseSounds.Percentage.Position = UDim2.new(0.521, math.clamp(percentage.X, 0, MorseSounds.SliderBack.AbsoluteSize.X) -15, -0.438, 0)
			MorseSounds.Percentage.Text = tostring(MorseSoundsPercentage) .. "%"
			--print(MorseSounds.Slider.Position.X.Offset)

			for i, v in pairs(game:GetService("ReplicatedStorage").Audio:GetChildren()) do
				if string.find(v.Name, "Morse") and v.Name ~= "MorseClick" then
					if v:IsA("Sound") then
						v.Volume = (MorseSoundsPercentage/100)
					end
				end
			end

			wait()
		end
	end
end)

MorseSounds.Slider.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		MourseSoundPressed = false
		MorseSounds.Percentage.Visible = false
	end
end)

------------ Music Sounds ------------
local MusicSoundsPercentage
MusicSounds.Slider.Position = UDim2.new(0.521, 52, 0.33, 0)

MusicSounds.Slider.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		MusicSoundPressed = true

		while MusicSoundPressed == true do
			local percentage = (UserInputService:GetMouseLocation() - MusicSounds.SliderBack.AbsolutePosition)
			MusicSounds.Slider.Position = UDim2.new(0.521, math.clamp(percentage.X, 0, MusicSounds.SliderBack.AbsoluteSize.X), 0.33, 0)

			MusicSoundsPercentage = math.floor(math.clamp(percentage.X, 0, MusicSounds.SliderBack.AbsoluteSize.X) / MusicSounds.SliderBack.AbsoluteSize.X * 100)
			MusicSounds.Percentage.Visible = true
			MusicSounds.Percentage.Position = UDim2.new(0.521, math.clamp(percentage.X, 0, MusicSounds.SliderBack.AbsoluteSize.X) -15, -0.438, 0)
			MusicSounds.Percentage.Text = tostring(MusicSoundsPercentage) .. "%"
			--print(MorseSounds.Slider.Position.X.Offset)

			for i, v in pairs(game:GetService("ReplicatedStorage").Audio.AmbientMusic:GetChildren()) do
				if v:IsA("Sound") then
					v.Volume = (MusicSoundsPercentage/150)
				end
			end

			wait()
		end
	end
end)

MusicSounds.Slider.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		MusicSoundPressed = false
		MusicSounds.Percentage.Visible = false
	end
end)]]

OneTimeSettingsSetup()