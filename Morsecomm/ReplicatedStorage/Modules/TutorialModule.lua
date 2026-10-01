--[[
    ================================================================
    
    Author:      @Baubobbi
    Created:     19.04.2025
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

local GAF1 = ReplicatedStorage:WaitForChild("GAF1")

local FadeModule = require(GAF1.FadeModule)

local TutorialModule = {}
TutorialModule.__index = TutorialModule


function TutorialModule.new(ScreenGui: ScreenGui, TextSound: Sound)
	local newTutorial = {}
	newTutorial.ScreenGui = ScreenGui
	newTutorial.TextSound = TextSound
	
	setmetatable(newTutorial, TutorialModule)
	return newTutorial
end

function TutorialModule:NewSequence(Tex: string, PointerPos: UDim2, callback)
	local Pointer: ImageLabel = self.ScreenGui:FindFirstChild("Pointer")
	local TalkerText: TextLabel = self.ScreenGui:FindFirstChild("TalkerText")
	
	Pointer.Position = PointerPos
	
	TalkerText.Text = ""
	
	for _, v in pairs(string.split(Tex, "")) do
		wait(0.045)
		TalkerText.Text ..= v
		self.TextSound:Play()
	end
	
	if callback then
		callback()
	end
end

function TutorialModule:EndTutorial(callback)
	local BlackBackground: TextLabel = self.ScreenGui:FindFirstChild("BlackBackground")
	local Pointer: ImageLabel = self.ScreenGui:FindFirstChild("Pointer")
	local TalkerText: TextLabel = self.ScreenGui:FindFirstChild("TalkerText")
	
	FadeModule.FadeGuiObject(BlackBackground, 1, 0)
	wait(1)
	Pointer.Visible = false
	TalkerText.Visible = false
	wait(2)
	if callback then
		callback()
	end
	FadeModule.FadeGuiObject(BlackBackground, 1, 1)
	wait(1)
	self.ScreenGui:Destroy()
	
end

return TutorialModule