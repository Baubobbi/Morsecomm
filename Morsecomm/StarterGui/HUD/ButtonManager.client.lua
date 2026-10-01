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
local TweenService = game:GetService("TweenService")

local Hud = script.Parent.Parent.Parent
local TaskFrame = Hud.TaskFrame
local Stack = TaskFrame.Stack
local AlphabetButton = Stack.AlphabetButton
local AlphabetFrame = Stack.Parent.AlphabetFrame
local SettingsButton = Stack.SettingsButton
local ShopButton = Stack.ShopButton
local SettingsFrame = Stack.Parent.SettingsFrame
local ShopFrame = Stack.Parent.ShopFrame
local Audio = ReplicatedStorage:FindFirstChild("Audio")
local Values = ReplicatedStorage:FindFirstChild("Values")

local FadeDuration = 0.2

local FadeTypes = {
	In = "In",
	Out = "Out"
}


function FadeGuiObject(Obj: GuiObject, fadetype, Duration)
	local FinalTransparency = fadetype == FadeTypes.In and 0.5 or 1
	local Tween = TweenService:Create(Obj, TweenInfo.new(Duration), {BackgroundTransparency = FinalTransparency})
	Tween:Play()
end

function FadeBlur(fadetype, Duration)
	local FinalSize = fadetype == FadeTypes.In and 8 or 0
	local Tween = TweenService:Create(game.Lighting:FindFirstChild("Blur"), TweenInfo.new(Duration), {Size = FinalSize})
	Tween:Play()
end

function OpenCloseAnimateFrame(Window: Frame, Open: boolean)
	if Open == true then
		Window.Visible = true
		Window:TweenPosition(UDim2.new(0.303, 0, 0.131, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Sine, 0.17, true)
	else
		Window:TweenPosition(UDim2.new(0.303, 0, 1.01, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Sine, 0.17, true)
		task.wait(0.17)
		Window.Visible = false
	end
end

function CloseAllFramesExceptMine(Mine: Frame)
	for i, v in pairs(Stack.Parent:GetChildren()) do
		if v.Name ~= "Stack" and v.Name ~= Mine.Name and v:IsA("Frame") and v.Visible == true then
			OpenCloseAnimateFrame(v, false)
		end
	end
end

AlphabetButton.MouseButton1Down:Connect(function()
	if AlphabetFrame.Visible == true then
		Values.WorkspaceClickable.Value = true
		Audio.Ui_click_close:Play()
		FadeGuiObject(Hud.BlackBackground, FadeTypes.Out, FadeDuration)
		FadeBlur(FadeTypes.Out, 0.3)
		OpenCloseAnimateFrame(AlphabetFrame, false)
	else
		Values.WorkspaceClickable.Value = false
		Audio.Ui_click_open:Play()
		CloseAllFramesExceptMine(AlphabetFrame)
		FadeGuiObject(Hud.BlackBackground, FadeTypes.In, FadeDuration)
		FadeBlur(FadeTypes.In, 0.3)
		OpenCloseAnimateFrame(AlphabetFrame, true)
	end
end)

SettingsButton.MouseButton1Down:Connect(function()
	if SettingsFrame.Visible == true then
		Values.WorkspaceClickable.Value = true
		Audio.Ui_click_close:Play()
		FadeGuiObject(Hud.BlackBackground, FadeTypes.Out, FadeDuration)
		FadeBlur(FadeTypes.Out, 0.3)
		OpenCloseAnimateFrame(SettingsFrame, false)
	else
		Values.WorkspaceClickable.Value = false
		Audio.Ui_click_open:Play()
		CloseAllFramesExceptMine(SettingsFrame)
		FadeGuiObject(Hud.BlackBackground, FadeTypes.In, FadeDuration)
		FadeBlur(FadeTypes.In, 0.3)
		OpenCloseAnimateFrame(SettingsFrame, true)
	end
end)

ShopButton.MouseButton1Down:Connect(function()
	if ShopFrame.Visible == true then
		Values.WorkspaceClickable.Value = true
		Audio.Ui_click_close:Play()
		FadeGuiObject(Hud.BlackBackground, FadeTypes.Out, FadeDuration)
		FadeBlur(FadeTypes.Out, 0.3)
		OpenCloseAnimateFrame(ShopFrame, false)
	else
		Values.WorkspaceClickable.Value = false
		Audio.Ui_click_open:Play()
		CloseAllFramesExceptMine(ShopFrame)
		FadeGuiObject(Hud.BlackBackground, FadeTypes.In, FadeDuration)
		FadeBlur(FadeTypes.In, 0.3)
		OpenCloseAnimateFrame(ShopFrame, true)
	end
end)


