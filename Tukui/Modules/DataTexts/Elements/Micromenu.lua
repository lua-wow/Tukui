local T, C, L = unpack((select(2, ...)))

local DataText = T["DataTexts"]
local Popups = T["Popups"]
local Miscellaneous = T.Miscellaneous

local OnMouseDown = function()
	local MicroMenu = Miscellaneous.MicroMenu

	if MicroMenu then
		MicroMenu:Toggle()
	end
end

local Enable = function(self)
	self:SetScript("OnMouseDown", OnMouseDown)

	self.Text:SetFormattedText("%s", DataText.NameColor .. "Micro Menu|r")
end

local Disable = function(self)
	self:SetScript("OnMouseDown", nil)
end

DataText:Register("MicroMenu", Enable, Disable, Update)
