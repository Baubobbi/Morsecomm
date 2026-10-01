local MorseStringTranslator = {}

MorseStringTranslator.MorseCodeAlphabet = {
	{morse = ".-", char = "A"},
	{morse = "-...", char = "B"},
	{morse = "-.-.", char = "C"},
	{morse = "-..", char = "D"},
	{morse = ".", char = "E"},
	{morse = "..-.", char = "F"},
	{morse = "--.", char = "G"},
	{morse = "....", char = "H"},
	{morse = "..", char = "I"},
	{morse = ".---", char = "J"},
	{morse = "-.-", char = "K"},
	{morse = ".-..", char = "L"},
	{morse = "--", char = "M"},
	{morse = "-.", char = "N"},
	{morse = "---", char = "O"},
	{morse = ".--.", char = "P"},
	{morse = "--.-", char = "Q"},
	{morse = ".-.", char = "R"},
	{morse = "...", char = "S"},
	{morse = "-", char = "T"},
	{morse = "..-", char = "U"},
	{morse = "...-", char = "V"},
	{morse = ".--", char = "W"},
	{morse = "-..-", char = "X"},
	{morse = "-.--", char = "Y"},
	{morse = "--..", char = "Z"},
	{morse = "-----", char = "0"},
	{morse = ".----", char = "1"},
	{morse = "..---", char = "2"},
	{morse = "...--", char = "3"},
	{morse = "....-", char = "4"},
	{morse = ".....", char = "5"},
	{morse = "-....", char = "6"},
	{morse = "--...", char = "7"},
	{morse = "---..", char = "8"},
	{morse = "----.", char = "9"}
}

function MorseStringTranslator.TranslateMorseChar(line, nilAlternative)
	local foundchar

	for i, v in pairs(MorseStringTranslator.MorseCodeAlphabet) do
		if v.morse == line then
			foundchar = MorseStringTranslator.MorseCodeAlphabet[i].char
		end
	end

	if foundchar then
		return foundchar
	else
		return "?"
	end 
end

function MorseStringTranslator.TranslateCharIntoMorse(Char, nilAlternative)
	local foundmorse

	for i, v in pairs(MorseStringTranslator.MorseCodeAlphabet) do
		if v.char == Char then
			foundmorse = MorseStringTranslator.MorseCodeAlphabet[i].morse
		end
	end

	if foundmorse then
		return foundmorse
	else
		return nilAlternative
	end 
end

return MorseStringTranslator