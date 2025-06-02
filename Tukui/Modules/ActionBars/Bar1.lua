local T, C, L = unpack((select(2, ...)))

local ActionBars = T["ActionBars"]
local Num = NUM_ACTIONBAR_BUTTONS
local MainMenuBar_OnEvent = MainMenuBar_OnEvent

function ActionBars:CreateBar1()
	local Movers = T["Movers"]
	local Size = C.ActionBars.NormalButtonSize
	local Spacing = C.ActionBars.ButtonSpacing
	local Druid, Rogue, Warrior, Priest, Warlock = "", "", "", "", ""
	local ButtonsPerRow = C.ActionBars.Bar1ButtonsPerRow
	local NumButtons = C.ActionBars.Bar1NumButtons
	local NumPerRows = C.ActionBars.Bar1ButtonsPerRow
	local NextRowButtonAnchor = _G["ActionButton1"]

	if NumButtons <= ButtonsPerRow then
		ButtonsPerRow = NumButtons
	end

	local NumRow = ceil(NumButtons / ButtonsPerRow)

	local ActionBar1 = CreateFrame("Frame", "TukuiActionBar1", T.PetHider, "SecureHandlerStateTemplate")
	ActionBar1:SetPoint("BOTTOM", UIParent, "BOTTOM", 0, 12)
	ActionBar1:SetFrameStrata("LOW")
	ActionBar1:SetFrameLevel(10)
	ActionBar1:SetWidth((Size * ButtonsPerRow) + (Spacing * (ButtonsPerRow + 1)))
	ActionBar1:SetHeight((Size * NumRow) + (Spacing * (NumRow + 1)))

	if C.ActionBars.ShowBackdrop then
		ActionBar1:CreateBackdrop()
		ActionBar1:CreateShadow()
	end

	if (C.ActionBars.SwitchBarOnStance) then
		if T.Cata then
			Rogue = "[bonusbar:1] 7; [bonusbar:2] 8;"
		else
			Rogue = "[bonusbar:1] 7;"
		end

		if T.Retail then
			Druid = "[bonusbar:1,stealth] 2; [bonusbar:1,nostealth] 7; [bonusbar:2] 8; [bonusbar:3] 9; [bonusbar:4] 10;"
		else
			Druid = "[bonusbar:1,stealth] 2; [bonusbar:1,nostealth] 7; [bonusbar:2] 8; [bonusbar:3] 9; [bonusbar:4] 10; [bonusbar:5] 10;"
		end

		Warrior = "[bonusbar:1] 7; [bonusbar:2] 8; [bonusbar:3] 9;"
		Priest = "[bonusbar:1] 7;"
		if T.Cata then
			Warlock = "[form:1] 7;"
		end
	end

	local DefaultPaging
	if T.Retail or T.Cata then
		local VehicleBar = format("[vehicleui][possessbar] %d;", GetVehicleBarIndex()) or ""
		local OverrideBar = format("[overridebar] %d;", GetOverrideBarIndex()) or ""
		local ShapeshiftBar = format("[shapeshift] %d;", GetTempShapeshiftBarIndex()) or ""

		DefaultPaging = ShapeshiftBar..VehicleBar..OverrideBar.."[bar:2] 2; [bar:3] 3; [bar:4] 4; [bar:5] 5; [bar:6] 6; [bonusbar:5] 11;"
	else
		DefaultPaging = "[bar:6] 6;[bar:5] 5;[bar:4] 4;[bar:3] 3;[bar:2] 2;[overridebar] 14;[shapeshift] 13;[vehicleui] 12;[possessbar] 12;"
	end

	ActionBar1.Page = {
		["DRUID"] = Druid,
		["ROGUE"] = Rogue,
		["WARRIOR"] = Warrior,
		["PRIEST"] = Priest,
		["WARLOCK"] = Warlock,
		["DEFAULT"] = DefaultPaging,
	}

	function ActionBar1:GetBar()
		local Condition = ActionBar1.Page["DEFAULT"]
		local Class = select(2, UnitClass("player"))
		local Page = ActionBar1.Page[Class]

		if Page then
			Condition = Condition .. " " .. Page
		end

		Condition = Condition .. " [form] 1; 1"

		return Condition
	end

	for i = 1, Num do
		local Button = _G["ActionButton"..i]

		ActionBar1:SetFrameRef("ActionButton"..i, Button)
	end

	ActionBar1:Execute([[
		Buttons = table.new()
		for i = 1, 12 do
			table.insert(Buttons, self:GetFrameRef("ActionButton"..i))
		end
	]])

	ActionBar1:SetAttribute("_onstate-page", [[
		if newstate == "possess" or newstate == "11" then
			if HasVehicleActionBar and HasVehicleActionBar() then
				newstate = GetVehicleBarIndex()
			elseif HasOverrideActionBar and HasOverrideActionBar() then
				newstate = GetOverrideBarIndex()
			elseif HasTempShapeshiftActionBar and HasTempShapeshiftActionBar() then
				newstate = GetTempShapeshiftBarIndex()
			elseif HasBonusActionBar and HasBonusActionBar() then
				newstate = GetBonusBarIndex()
			else
				newstate = nil
			end

			if not newstate then
				print("|cffff8000Tukui|r: Cannot determine possess/vehicle action bar page, please report this!")

				newstate = 12
			end
		end

		for i, Button in ipairs(Buttons) do
			Button:SetAttribute("actionpage", tonumber(newstate))
		end
	]])

	local pageState = ActionBar1.GetBar()
	print("PAGE STATE", pageState)
	RegisterStateDriver(ActionBar1, "page", pageState)

	if T.Retail or T.Cata then
		ActionBar1:RegisterEvent("UPDATE_VEHICLE_ACTIONBAR")
		ActionBar1:RegisterEvent("UPDATE_OVERRIDE_ACTIONBAR")
	end

	ActionBar1:SetScript("OnEvent", function(self, event, unit, ...)
		for i = 1, 12 do
			local Button = _G["ActionButton"..i]
			local Action = Button.action
			local Icon = Button.icon

			if Action >= 120 then
				local Texture = GetActionTexture(Action)

				if (Texture) then
					Icon:SetTexture(Texture)
					Icon:Show()
				else
					if Icon:IsShown() then
						Icon:Hide()
					end
				end
			end
		end
	end)

	for i = 1, Num do
		local Button = _G["ActionButton"..i]

		ActionBar1["Button"..i] = Button
	end

	-- Move main buttons inside our action bar #1
	for i = 1, Num do
		local Button = _G["ActionButton"..i]
		local PreviousButton = _G["ActionButton"..i-1]

		Button:SetParent(ActionBar1)
		Button:SetSize(Size, Size)
		Button:ClearAllPoints()
		Button:SetAttribute("showgrid", 1)

		if not T.Retail then
			ActionButton_ShowGrid(Button)
		end

		ActionBars:SkinButton(Button)

		if i <= NumButtons then
			if (i == 1) then
				Button:SetPoint("TOPLEFT", ActionBar1, "TOPLEFT", Spacing, -Spacing)
			elseif (i == NumPerRows + 1) then
				Button:SetPoint("TOPLEFT", NextRowButtonAnchor, "BOTTOMLEFT", 0, -Spacing)

				NumPerRows = NumPerRows + ButtonsPerRow
				NextRowButtonAnchor = _G["ActionButton"..i]
			else
				Button:SetPoint("LEFT", PreviousButton, "RIGHT", Spacing, 0)
			end
		else
			Button:SetPoint("TOP", UIParent, "TOP", 0, 200)
		end
	end

	Movers:RegisterFrame(ActionBar1, "Action Bar #1")

	self.Bars = {}
	self.Bars.Bar1 = ActionBar1
end
