local T, C, L = unpack((select(2, ...)))

local Miscellaneous = T["Miscellaneous"]

function Miscellaneous:Enable()
	Miscellaneous["Experience"]:Enable()
	Miscellaneous["Errors"]:Enable()
	Miscellaneous["MirrorTimers"]:Enable()
	Miscellaneous["DropDown"]:Enable()
	Miscellaneous["GarbageCollection"]:Enable()
	Miscellaneous["GameMenu"]:Enable()
	Miscellaneous["StaticPopups"]:Enable()
	Miscellaneous["Durability"]:Enable()
	Miscellaneous["UIWidgets"]:Enable()
	Miscellaneous["AFK"]:Enable()
	
	if Miscellaneous.MicroMenu then
		Miscellaneous["MicroMenu"]:Enable()
	end
	
	Miscellaneous["Keybinds"]:Enable()
	Miscellaneous["ThreatBar"]:Enable()
	Miscellaneous["ItemLevel"]:Enable()
	Miscellaneous["Alerts"]:Enable()
	
	if T.Retail or T.MoP then
		Miscellaneous["VehicleIndicator"]:Enable()
	end

	if T.Retail then
		Miscellaneous["TalkingHead"]:Enable()
		Miscellaneous["LossControl"]:Enable()
		Miscellaneous["DeathRecap"]:Enable()
		Miscellaneous["Ghost"]:Enable()
		Miscellaneous["TimerTracker"]:Enable()
		Miscellaneous["AltPowerBar"]:Enable()
		Miscellaneous["OrderHall"]:Enable()
		Miscellaneous["Tutorials"]:Enable()
		Miscellaneous["RaidUtilities"]:Enable()
	end
	
	-- TWW (UNLOAD)
	if not T.TWW then
		Miscellaneous["TimeManager"]:Enable()
	end
end
