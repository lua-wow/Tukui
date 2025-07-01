local T, C, L = unpack((select(2, ...)))

local ActionBars = T["ActionBars"]

function ActionBars:MoveStanceButtons(button, i)
	local FakeButton = _G["TukuiStanceActionBarButton"..i]
	local Button = button
	
	Button:ClearAllPoints()
	Button:SetAllPoints(FakeButton)
end

function ActionBars:CreateStanceBar()
	local PetSize = C.ActionBars.PetButtonSize
	local Spacing = C.ActionBars.ButtonSpacing
	local Movers = T["Movers"]

	if (not C.ActionBars.ShapeShift) then
		return
	end
	
	local StanceBarFrame = T.Retail and StanceBar or StanceBarFrame

	local Bar = CreateFrame("Frame", "TukuiStanceBar", T.PetHider, "SecureHandlerStateTemplate")
	Bar:SetSize((PetSize * 10) + (Spacing * 11), PetSize + (Spacing * 2))
	-- Hunter in Cata has both stance and pet.  Offset stance so not on top of each other
	if T.MoP and (T.MyClass == "HUNTER" or T.MyClass == "DEATHKNIGHT") then
		Bar:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", 28, 277)
	else
		Bar:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", 28, 233)
	end
	Bar:SetFrameStrata("LOW")
	Bar:SetFrameLevel(10)
	Bar:RegisterEvent("UPDATE_SHAPESHIFT_COOLDOWN")
	Bar:RegisterEvent("UPDATE_SHAPESHIFT_FORM")
	Bar:RegisterEvent("UPDATE_SHAPESHIFT_FORMS")
	Bar:RegisterEvent("UPDATE_SHAPESHIFT_USABLE")
	Bar:SetScript("OnEvent", ActionBars.UpdateStanceBar)

	if C.ActionBars.ShowBackdrop then
		Bar:CreateBackdrop()
		Bar:CreateShadow()
	end
	
	self.Bars.Stance = Bar

	StanceBarFrame.ignoreFramePositionManager = true
	StanceBarFrame:StripTextures()
	StanceBarFrame:EnableMouse(false)

	for i = 1, 10 do
		local Button = _G["StanceButton"..i]
		local FakeButton = CreateFrame("Frame", "TukuiStanceActionBarButton"..i, TukuiStanceBar)
		
		if not T.Retail then
			Button:SetParent(Bar)
		end
		
		FakeButton:SetSize(PetSize, PetSize)

		if (i ~= 1) then
			local Previous = _G["TukuiStanceActionBarButton"..i-1]

			FakeButton:ClearAllPoints()
			FakeButton:SetPoint("LEFT", Previous, "RIGHT", Spacing, 0)
		else
			FakeButton:ClearAllPoints()
			FakeButton:SetPoint("BOTTOMLEFT", Bar, "BOTTOMLEFT", Spacing, Spacing)
		end
		
		ActionBars:MoveStanceButtons(Button, i)
		
		if T.Retail then
			hooksecurefunc(Button, "SetPoint", function(self)
				local ID = Button:GetID()

				if ID then
					ActionBars:MoveStanceButtons(Button, ID)
				end
			end)
		end
	end
	
	ActionBars:UpdateStanceBar()
	ActionBars:SkinStanceButtons()

	Movers:RegisterFrame(Bar, "Stance Action Bar")
end