local DataManager = {}

DataManager.Profiles = {}


function DataManager.SetMorseboardAbillityTo_Boolean(Player: Player, Boolean: boolean)
	local Profile = DataManager.Profiles[Player]
	
	if not Profile then return end
	
	Profile.Data.MorseboardTrailAbillity = Boolean
end

function DataManager.SetMorseTranslatorAbillityTo_Boolean(Player: Player, Boolean: boolean)
	local Profile = DataManager.Profiles[Player]

	if not Profile then return end

	Profile.Data.MorseTranslatorTrailAbillity = Boolean
end

function DataManager.AddTranslatedCharMorsecodeToDataStore(Player: Player, Char: string)
	local Profile = DataManager.Profiles[Player]

	if not Profile then return end

	Profile.Data.TranslatedMorseContent ..= Char
end

return DataManager