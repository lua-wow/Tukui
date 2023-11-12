local T, C, L = unpack((select(2, ...)))

local Framework = select(2, ...)
local oUF = oUF or Framework.oUF
local Class = select(2, UnitClass("player"))

oUF.colors.disconnected = oUF:CreateColor(0.1, 0.1, 0.1)

oUF.colors.runes = {
	[1] = oUF:CreateColor(0.69, 0.31, 0.31),
	[2] = oUF:CreateColor(0.41, 0.80, 1.00),
	[3] = oUF:CreateColor(0.65, 0.63, 0.35),
	[4] = oUF:CreateColor(0.53, 0.53, 0.93),
	[5] = oUF:CreateColor(0.55, 0.57, 0.61)	 -- unspec, new char
}

oUF.colors.reaction = {
	[1] = oUF:CreateColor(0.78, 0.25, 0.25), -- Hated
	[2] = oUF:CreateColor(0.78, 0.25, 0.25), -- Hostile
	[3] = oUF:CreateColor(0.78, 0.25, 0.25), -- Unfriendly
	[4] = oUF:CreateColor(0.85, 0.77, 0.36), -- Neutral
	[5] = oUF:CreateColor(0.29, 0.68, 0.30), -- Friendly
	[6] = oUF:CreateColor(0.29, 0.68, 0.30), -- Honored
	[7] = oUF:CreateColor(0.29, 0.68, 0.30), -- Revered
	[8] = oUF:CreateColor(0.29, 0.68, 0.30)  -- Exalted
}

oUF.colors.power = {
	["MANA"]              = oUF:CreateColor(0.31, 0.45, 0.63),
	["INSANITY"]          = oUF:CreateColor(0.40, 0.00, 0.80),
	["MAELSTROM"]         = oUF:CreateColor(0.00, 0.50, 1.00),
	["LUNAR_POWER"]       = oUF:CreateColor(0.93, 0.51, 0.93),
	["HOLY_POWER"]        = oUF:CreateColor(0.95, 0.90, 0.60),
	["RAGE"]              = oUF:CreateColor(0.69, 0.31, 0.31),
	["FOCUS"]             = oUF:CreateColor(0.71, 0.43, 0.27),
	["ENERGY"]            = oUF:CreateColor(0.65, 0.63, 0.35),
	["CHI"]               = oUF:CreateColor(0.71, 1.00, 0.92),
	["RUNES"]             = oUF:CreateColor(0.55, 0.57, 0.61),
	["SOUL_SHARDS"]       = oUF:CreateColor(0.50, 0.32, 0.55),
	["FURY"]              = oUF:CreateColor(0.78, 0.26, 0.99),
	["PAIN"]              = oUF:CreateColor(1.00, 0.61, 0.00),
	["RUNIC_POWER"]       = oUF:CreateColor(0.00, 0.82, 1.00),
	["AMMOSLOT"]          = oUF:CreateColor(0.80, 0.60, 0.00),
	["FUEL"]              = oUF:CreateColor(0.00, 0.55, 0.50),
	["POWER_TYPE_STEAM"]  = oUF:CreateColor(0.55, 0.57, 0.61),
	["POWER_TYPE_PYRITE"] = oUF:CreateColor(0.60, 0.09, 0.17),
	["ALTPOWER"]          = oUF:CreateColor(0.00, 1.00, 1.00),
	["ANIMA"]             = oUF:CreateColor(0.83, 0.83, 0.83),
	["ESSENCE"]           = oUF:CreateColor(0.00, 0.82, 1.00)
}

oUF.colors.class = {
	["DRUID"]       = oUF:CreateColor(1.00, 0.49, 0.04),
	["HUNTER"]      = oUF:CreateColor(0.67, 0.83, 0.45),
	["MAGE"]        = oUF:CreateColor(0.25, 0.78, 0.92),
	["PALADIN"]     = oUF:CreateColor(0.96, 0.55, 0.73),
	["PRIEST"]      = oUF:CreateColor(0.99, 0.99, 0.99),
	["ROGUE"]       = oUF:CreateColor(1.00, 0.96, 0.41),
	["SHAMAN"]      = oUF:CreateColor(0.00, 0.44, 0.87),
	["WARLOCK"]     = oUF:CreateColor(0.53, 0.53, 0.93),
	["WARRIOR"]     = oUF:CreateColor(0.78, 0.61, 0.43),
	["DEATHKNIGHT"] = oUF:CreateColor(0.77, 0.12, 0.24),
	["MONK"]        = oUF:CreateColor(0.00, 1.00, 0.59),
	["DEMONHUNTER"] = oUF:CreateColor(0.64, 0.19, 0.79),
	["EVOKER"]      = oUF:CreateColor(0.20, 0.58, 0.50)
}

oUF.colors.totems = {
	[1] = oUF:CreateColor(0.78, 0.25, 0.25),
	[2] = oUF:CreateColor(0.78, 0.61, 0.43),
	[3] = oUF:CreateColor(0.25, 0.78, 0.92),
	[4] = oUF:CreateColor(0.99, 0.99, 0.99)
}

oUF.colors.happiness = {
	[1] = oUF:CreateColor(0.69, 0.31, 0.31),
	[2] = oUF:CreateColor(0.65, 0.63, 0.35),
	[3] = oUF:CreateColor(0.33, 0.59, 0.33)
}

oUF.colors.mirror = {
	EXHAUSTION = oUF:CreateColor(1.0, 0.90, 0.0),
	BREATH = oUF:CreateColor(0.0, 0.50, 1.0),
	DEATH = oUF:CreateColor(1.0, 0.70, 0.0),
	FEIGNDEATH = oUF:CreateColor(1.0, 0.70, 0.0)
}

if (next(UF.colors.debuff) == nil) then
	for debuffType, color in next, DebuffTypeColor do
		oUF.colors.debuff[debuffType] = oUF:CreateColor(color.r, color.g, color.b)
	end
end

T["Colors"] = oUF.colors
