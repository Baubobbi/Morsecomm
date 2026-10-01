local TimeModule = {}

function TimeModule.GetCurrentRealTimeAM_PM(PlusSec: number)
	local AMorPM = ""
	local Date = os.date("*t", os.time() + PlusSec)
	local TIME = ("%02d:%02d"):format( ((Date.hour % 24) - 1) % 12 + 1, Date.min )
	
	local CurrentHour = os.date("*t").hour
	
	if CurrentHour < 12 or CurrentHour == 24 then
		AMorPM = "AM"
	else
		AMorPM = "PM"
	end
	
	return tostring(TIME.." "..AMorPM)
end

return TimeModule