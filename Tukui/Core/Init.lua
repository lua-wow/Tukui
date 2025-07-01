----------------------------------------------------------------
-- Initiation of Tukui engine
----------------------------------------------------------------

-- [[ Build the engine ]] --
local AddOn, Engine = ...
local Resolution = select(1, GetPhysicalScreenSize()).."x"..select(2, GetPhysicalScreenSize())
local Windowed = Display_DisplayModeDropDown and Display_DisplayModeDropDown:windowedmode()
local Fullscreen = Display_DisplayModeDropDown and Display_DisplayModeDropDown:fullscreenmode()
local Toc = select(4, GetBuildInfo())
local GetAddOnMetadata = C_AddOns and C_AddOns.GetAddOnMetadata or GetAddOnMetadata

Engine[1] = CreateFrame("Frame")
Engine[2] = {}
Engine[3] = {}
Engine[4] = {}

local function ParseVersionString()
	local version = strsub(GetAddOnMetadata(AddOn, 'Version'), 2)
	if not strfind(version, '%-') then
		return tonumber(version), version
	elseif strfind(version, 'project%-version') then
		return 99999, 'Development'
	else
		return 99999, version
	end
end

function Engine:unpack()
	return self[1], self[2], self[3], self[4]
end

Engine[1].Retail = WOW_PROJECT_ID == WOW_PROJECT_MAINLINE
Engine[1].BCC = (WOW_PROJECT_ID == WOW_PROJECT_BURNING_CRUSADE_CLASSIC) or (Toc >= 20000 and Toc < 30000)
Engine[1].Classic = WOW_PROJECT_ID == WOW_PROJECT_CLASSIC
Engine[1].WotLK = (WOW_PROJECT_ID == WOW_PROJECT_WRATH_CLASSIC) or (Toc >= 30000 and Toc < 40000)
Engine[1].Cata = (WOW_PROJECT_ID == WOW_PROJECT_CATACLYSM_CLASSIC) or (Toc >= 40000 and Toc < 50000)
Engine[1].MoP = Toc >= 50000 and Toc < 60000
Engine[1].DF = Toc >= 100000 and Toc < 110000
Engine[1].TWW = Toc >= 110000 and Toc < 120000
Engine[1].WindowedMode = Windowed
Engine[1].FullscreenMode = Fullscreen
Engine[1].Resolution = Resolution or (Windowed and GetCVar("gxWindowedResolution")) or GetCVar("gxFullscreenResolution")
Engine[1].ScreenHeight = select(2, GetPhysicalScreenSize())
Engine[1].ScreenWidth = select(1, GetPhysicalScreenSize())
Engine[1].PerfectScale = min(1, max(0.3, 768 / string.match(Resolution, "%d+x(%d+)")))
Engine[1].MyName = UnitName("player")
Engine[1].MyClass = select(2, UnitClass("player"))
Engine[1].MyLevel = UnitLevel("player")
Engine[1].MyFaction = select(2, UnitFactionGroup("player"))
Engine[1].MyRace = select(2, UnitRace("player"))
Engine[1].MyRealm = GetRealmName()
Engine[1].VersionNumber, Engine[1].Version = ParseVersionString()
Engine[1].WoWPatch, Engine[1].WoWBuild, Engine[1].WoWPatchReleaseDate, Engine[1].TocVersion = GetBuildInfo()
Engine[1].WoWBuild = tonumber(Engine[1].WoWBuild)
Engine[1].Hider = CreateFrame("Frame", "TukuiHider", UIParent)
Engine[1].PetHider = CreateFrame("Frame", "TukuiPetHider", UIParent, "SecureHandlerStateTemplate")
Engine[1].OffScreen = CreateFrame("Frame", "TukuiOffScreen", UIParent)

SLASH_RELOADUI1 = "/rl"
SlashCmdList.RELOADUI = ReloadUI

Tukui = Engine
