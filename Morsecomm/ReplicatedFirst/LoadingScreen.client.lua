--[[
    ================================================================
    
    Author:      @Baubobbi
    Created:     25.03.2025
    Description: Loading screen.
    
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
local TweenService = game:GetService("TweenService")
local StarterGui = game:GetService("StarterGui")
local Players = game:GetService("Players")

local RemoteEvents = ReplicatedStorage:WaitForChild("RemoteEvents")
local Modules = ReplicatedStorage:WaitForChild("Modules")
local Values = ReplicatedStorage:WaitForChild("Values")
local TutorialModule = require(Modules.TutorialModule)
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer.PlayerGui
local LoadingScreen = script.LoadingScreen
local Background = LoadingScreen.Background
local HUD = PlayerGui:WaitForChild("HUD")
local Black = LoadingScreen.Black
local Logo = LoadingScreen.Logo

local LoadingFinished = false

function SetupLoadingScreen()
	LoadingScreen.Parent = PlayerGui
	HUD.Enabled = false
	Values.WorkspaceClickable.Value = false

	LoadingScreen.Background.Transparency = 0
	LoadingScreen.Black.Transparency = 0
	LoadingScreen.Logo.ImageTransparency = 0
	LoadingScreen.TextLabel.TextTransparency = 0
end

function ShowLoadingScreen()
	local Tween = TweenService:Create(LoadingScreen.Black, TweenInfo.new(0.2), {BackgroundTransparency = 1})
	Tween:Play()
end

function ReenableGui()
	HUD.Enabled = true
	Values.WorkspaceClickable.Value = true

	StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, true)
end

function DisableGui()
	HUD.Enabled = false
	Values.WorkspaceClickable.Value = false

	StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, false)
end

function EndLoadingScreen()
	local Tween1 = TweenService:Create(LoadingScreen.Background, TweenInfo.new(0.7), {BackgroundTransparency = 1})
	local Tween2 = TweenService:Create(LoadingScreen.Logo, TweenInfo.new(0.7), {ImageTransparency = 1})
	local Tween3 = TweenService:Create(LoadingScreen.TextLabel, TweenInfo.new(0.7), {TextTransparency = 1})
	Tween1:Play()
	Tween2:Play()
	Tween3:Play()
	
	LoadingFinished = true

	Tween1.Completed:Connect(function()
		ReenableGui()
	end)

end

function Main()
	SetupLoadingScreen()
	task.wait(2)
	ShowLoadingScreen()
	task.wait(5)
	EndLoadingScreen()
end

Main()

RemoteEvents:WaitForChild("ActivateTutorial").OnClientEvent:Connect(function()
	while LoadingFinished == false do
		wait()
	end
	
	while HUD.Enabled == false do
		wait()
	end
	DisableGui()

	local TutorialGui = script.Tutorial:Clone()
	TutorialGui.Parent = LocalPlayer.PlayerGui

	local Tutorial = TutorialModule.new(TutorialGui, TutorialGui.sfxDot)

    -- intro --
	Tutorial:NewSequence("Hi ".. LocalPlayer.Name.. " welcome to MORSECOM!", UDim2.new(-0.117, 0, -3.006, 0), nil)
	task.wait(3.5)
	Tutorial:NewSequence("This is the QUICK beginner tutorial, where you'll get to know all the tools you'll need.", UDim2.new(-0.117, 0, -3.006, 0), nil)
	task.wait(3)
	
	
	-- Telegraph --
	Tutorial:NewSequence("This is your Telegraph.", UDim2.new(-0.982, 0, -2.947, 0), nil)
	task.wait(2)
	Tutorial:NewSequence("Tap to send dots (.) and dashes (-)", UDim2.new(-0.982, 0, -2.947, 0), nil)
	task.wait(2.5)
	Tutorial:NewSequence("On mobile you will have an extra telegraph on the left that you can tap to send signals.", UDim2.new(-0.982, 0, -2.947, 0), nil)
	task.wait(2.5)
	Tutorial:NewSequence("Short press = dot. Long press = dash.", UDim2.new(-0.982, 0, -2.947, 0), nil)
	task.wait(3.5)
	Tutorial:NewSequence("(Btw, try to morse at a normal speed... not too fast)", UDim2.new(-0.982, 0, -2.947, 0), nil)
	task.wait(2.25)
	
	
	-- Morse Sender --
	Tutorial:NewSequence("Now, meet the Morse Sender.", UDim2.new(-1.177, 0, -2.896, 0), nil)
	task.wait(2)
	Tutorial:NewSequence("Here you'll be able to choose a player to send your signal to.", UDim2.new(-1.177, 0, -2.896, 0), nil)
	task.wait(3.5)
	Tutorial:NewSequence("You will just have to tap on the white box and it will scroll through the players.", UDim2.new(-1.177, 0, -2.896, 0), nil)
	task.wait(3.5)
	Tutorial:NewSequence("Once finished, click the button right bellow and you are connected.", UDim2.new(-1.177, 0, -2.896, 0), nil)
	task.wait(3.5)
	Tutorial:NewSequence("(BTW, YOU CAN ALSO SELECT YOURSELF AND SEND YOURSELF SIGNALS)", UDim2.new(-1.177, 0, -2.896, 0), nil)
	task.wait(3)
	
	
	-- Morse Translator --
	Tutorial:NewSequence("So, here we have your Morse translator!", UDim2.new(-1.083, 0,-3, 0), nil)
	task.wait(2)
	Tutorial:NewSequence("This device translates incoming signals directly and automatically.", UDim2.new(-1.083, 0,-3, 0), nil)
	task.wait(2.7)
	Tutorial:NewSequence("It makes starting with Morse code much easier.", UDim2.new(-1.083, 0,-3, 0), nil)
	task.wait(3)
	
	
	-- Signal Controller --
	Tutorial:NewSequence("Let’s look at the Signal Controller.", UDim2.new(-1.006, 0, -3.067, 0), nil)
	task.wait(2.25)
	Tutorial:NewSequence("To receive anything at all, you have to press the big button on the device to let in signals.", UDim2.new(-1.006, 0, -3.067, 0), nil)
	task.wait(3.5)
	Tutorial:NewSequence("All players in the game are also listed here.", UDim2.new(-1.006, 0, -3.067, 0), nil)
	task.wait(2.5)
	Tutorial:NewSequence("Tap the button under a name to mute their signal.", UDim2.new(-1.006, 0, -3.067, 0), nil)
	task.wait(2.5)
	Tutorial:NewSequence("Handy if someone’s making noise.", UDim2.new(-1.006, 0, -3.067, 0), nil)
	task.wait(2.5)
	
	-- Gadget info --
	Tutorial:NewSequence("You can also zoom in on all the gadgets by clicking on them after this tutorial.", UDim2.new(-1.006, 0, -3.067, 0), nil)
	task.wait(2.75)
	
	-- outro --
	Tutorial:NewSequence("And thats it. Have Fun!", UDim2.new(-1.006, 0, -3.067, 0), nil)
	task.wait(2.5)
	
	
	Tutorial:EndTutorial(function()
		ReenableGui()
	end)
end)