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
local Values = ReplicatedStorage:WaitForChild("Values")
local FadeModule = require(GAF1.FadeModule)

local AmbientMusicModule = {}
AmbientMusicModule.__index = AmbientMusicModule


function AmbientMusicModule.NewAmbientce(Playlist: Folder)
	local newAmbience = {}
	newAmbience.Playlist = Playlist
	newAmbience.CurrentlyPlaying = nil
	
	setmetatable(newAmbience, AmbientMusicModule)
	return newAmbience
end

function AmbientMusicModule:Play()
	while wait() do
		for _, v: Sound in pairs(self.Playlist:GetChildren()) do
			if v:IsA("Sound") then
				v.Volume = 0
				v:Play()
				self.CurrentlyPlaying = v
				FadeModule.FadeSound(v, 2, Values.MusicMasterVolume.Value)
				task.wait(v.TimeLength - 2)
				FadeModule.FadeSound(v, 2, 0)
				task.wait(3)
			end
		end
	end
end

function AmbientMusicModule:StopRestart()
	if self.CurrentlyPlaying then
		self.CurrentlyPlaying:Stop()
	end
end

return AmbientMusicModule