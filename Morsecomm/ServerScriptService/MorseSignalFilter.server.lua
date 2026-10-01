--[[
    ================================================================
    
    Author:      @Baubobbi
    Created:     11.03.2025
    Description: Filters text or signals and detects if its bad 
                 or good text.
    
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

local ServerScriptService = game:GetService("ServerScriptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TextService = game:GetService("TextService")
local Players = game:GetService("Players")
local Chat = game:GetService("Chat")

local RemoteEvents = ReplicatedStorage:FindFirstChild("RemoteEvents")
local ServerModules = ServerScriptService:FindFirstChild("Modules")
local Modules = ReplicatedStorage:FindFirstChild("Modules")
local rSendFilterSignal = RemoteEvents.SendFilterSignal

local MorseStringTranslator = require(Modules.MorseStringTranslator)
local DataManager = require(ServerModules.DataManager)

local BadWords = {
	"fuck", "fck", "f1ck", "f0ck", "fuk", "fuyou", "fyou", "fuuu",
	"faggot", "fag", "faqq", "fgt",
	"fick", "f1ck", "f1k", "fyk", "ficc",
	"shit", "sht", "sh1t", "scheisse", "scheiss", "shiet", "shyt",
	"bitch", "btch", "b1tch", "b1ch",
	"ass", "azz", "4ss", "arse", "arsch",
	"penis", "pen1s", "pnss", "pns", "p3nis",
	"pussy", "pussie", "pusy", "pussi", "p0ssy",
	"vagina", "vag1na", "vag",
	"sex", "s3x", "seggs",
	"rape", "rap3", "r4pe", "rapist",
	"boobs", "boobz", "bo0bs", "b00bs", "bobs",
	"tits", "t1ts", "tit", "boobs",
	"dick", "d1ck", "dik", "dyke",
	"cum", "c0m", "cumm", "cumming",
	"cock", "c0ck", "kok", "kock",
	"balls", "ballz", "nude", "n4k3d", "naked",
	"drug", "drugs", "droge", "drogen", "weed", "thc", "coke", "cocaine", "heroin", "meth",
	"smoke", "smoking", "smok", "sm0ke",
	"opfer", "hurensohn", "huso", "wichser", "w1chser", "wichs", "bastard",
	"motherfucker", "m0therf", "mfkr", "mthr",
	"niga", "n1ga", "nigga", "n1gga", "nigger", "n1gger", "ngger", "ngga",
	"kys", "killme", "suicide", "suiside", "selfharm",
	"casso", "c4sso", "merde", "puta", "puto", "putain",
	"mierda", "cabron", "culero", "polla",
	"zorra", "maricon", "cono", "perra", "pene", "condo",
	"stronzo", "cazzo", "merda", "puttana",
	"piscia", "cretino", "scemo", "mignotta",
	"siktir", "amk", "orospu", "anan", "sikik", "pich",
	"ibne", "yarrak",
	"allahsız", "gavur", "serefsiz", "kaltak",
	"blyat", "suka", "sukablyat", "pidor", "jebat", "ebat",
	"durak", "mudak", "pidaras",
	"khara", "sharmuta", "sharmout", "kalb", "kosomak",
	"manyak", "lunatic", "perv", "molest", "m0lest", "mlest", "mulest",
	"whatsyouradress", "bitch", "b1tch", "b1ch"
}

local Buffers = {}


local AutoTranslate = coroutine.create(function()
	while wait() do
		for i, v in pairs(Buffers) do
			local Silence = (tick() - v.LastSent)

			if Silence >= 0.7 then
				if v.MorseOutput ~= "" then
					v.TranslatedOutput ..= MorseStringTranslator.TranslateMorseChar(v.MorseOutput, "")
					
					DataManager.AddTranslatedCharMorsecodeToDataStore(v.Player, MorseStringTranslator.TranslateMorseChar(v.MorseOutput, ""))
					
					v.MorseOutput = ""
					
					-- Check if appropriate --
					if CheckIfContainsBadWord(v.TranslatedOutput) then
						v.Player:Kick("You sent inappropriate content.")
						
						table.remove(Buffers, table.find(Buffers, v.Player))
					end
					
					--print(v.TranslatedOutput)
				end
			end
		end
	end
end)

coroutine.resume(AutoTranslate)

function GetPlayersBufferSlot(Player)
	for i, v in pairs(Buffers) do
		if v.Player.Name == Player.Name then
			return Buffers[i]
		end
	end
end

function CheckIfContainsBadWord(Text)
	Text = string.lower(Text)

	for _, v in BadWords do
		if Text:find(v) then
			return true
		end
	end

	return false
end

rSendFilterSignal.OnServerEvent:Connect(function(SendingPlayer, MorseChar)
	local PlayersBufferSlot = GetPlayersBufferSlot(SendingPlayer)

	PlayersBufferSlot.MorseOutput ..= MorseChar
	PlayersBufferSlot.LastSent = tick()
end)

Players.PlayerAdded:Connect(function(player)
	table.insert(Buffers, {Player = player, LastSent = 0, MorseOutput = "", TranslatedOutput = ""})
end)
