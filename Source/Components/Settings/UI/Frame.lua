function NotepadSettings:_InitializeFrame()
	self.Frame = CreateFrame(
		"Frame",
		"QN_Settings_" .. self.notepad.name,
		UIParent,
		"PortraitFrameTemplate"
	)
	self.Frame:SetSize(340, 290)
	self.Frame:SetPoint("CENTER")
	self.Frame:SetMovable(true)
	self.Frame:EnableMouse(true)
	self.Frame:SetClampedToScreen(true)
	self.Frame:SetFrameStrata("HIGH")
	self.Frame:SetTitle("Quick Notes Options")

	if self.Frame.Bg then
		self.Frame.Bg:SetColorTexture(30 / 255, 23 / 255, 18 / 255, 0.85)
	end
	if self.Frame.PortraitContainer and self.Frame.PortraitContainer.portrait then
		local portrait = self.Frame.PortraitContainer.portrait
		local portraitBackground = self.Frame.PortraitContainer:CreateTexture(nil, "BACKGROUND")
		portraitBackground:SetAllPoints(portrait)
		portraitBackground:SetColorTexture(30 / 255, 23 / 255, 18 / 255, 1)
		local portraitMask = self.Frame.PortraitContainer:CreateMaskTexture()
		portraitMask:SetTexture("Interface\\CharacterFrame\\TempPortraitAlphaMask")
		portraitMask:SetAllPoints(portrait)
		portraitBackground:AddMaskTexture(portraitMask)
		portrait:SetTexture("Interface\\AddOns\\QuickNotes\\Images\\QuickNotesIcon.tga")
	end

	local function AddDivider(yOffset)
		local divider = self.Frame:CreateTexture(nil, "BORDER")
		divider:SetPoint("TOPLEFT", self.Frame, "TOPLEFT", 18, yOffset)
		divider:SetPoint("TOPRIGHT", self.Frame, "TOPRIGHT", -18, yOffset)
		divider:SetHeight(1)
		divider:SetColorTexture(0.48, 0.34, 0.16, 0.7)
		return divider
	end

	AddDivider(-60)

	self.Frame.AppearanceHeading = self.Frame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
	self.Frame.AppearanceHeading:SetTextColor(1, 0.82, 0, 1)
	self.Frame.AppearanceHeading:SetPoint("TOPLEFT", self.Frame, 18, -77)
	self.Frame.AppearanceHeading:SetText("Appearance")

	AddDivider(-185)

	self.Frame.DataHeading = self.Frame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
	self.Frame.DataHeading:SetTextColor(1, 0.82, 0, 1)
	self.Frame.DataHeading:SetPoint("TOPLEFT", self.Frame, 18, -202)
	self.Frame.DataHeading:SetText("Character data")

	AddDivider(-252)

	self.Frame.CloseButton:SetScript("OnClick", function()
		self:Close()
	end)

	self.Frame:RegisterForDrag("LeftButton")
	self.Frame:SetScript("OnDragStart", function()
		self.Frame:StartMoving()
	end)
	self.Frame:SetScript("OnDragStop", function()
		self.Frame:StopMovingOrSizing()
	end)

	self.Frame:Hide()
end
