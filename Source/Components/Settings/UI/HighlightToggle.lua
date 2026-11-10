function NotepadSettings:_InitializeHighlightToggle()
	self.Frame.HighlightToggle = CreateFrame(
		"CheckButton",
		"QN_Settings_" .. self.notepad.name .. "_HighlightToggle",
		self.Frame,
		"UICheckButtonTemplate"
	)
	self.Frame.HighlightToggle:SetPoint("TOPLEFT", self.Frame, 14, -120)
	self.Frame.HighlightToggle.Text:SetText("Enable Highlighting")
	self.Frame.HighlightToggle.Text:SetFontObject("GameFontNormal")

	self.Frame.HighlightToggle:SetChecked(self.enableHighlight or false)
	self.Frame.HighlightToggle:SetScript("OnClick", function(button)
		self.enableHighlight = button:GetChecked()
		self:SaveSettings()
	end)

	self.Frame.HighlightDescription = self.Frame:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
	self.Frame.HighlightDescription:SetPoint("TOPLEFT", self.Frame, 45, -153)
	self.Frame.HighlightDescription:SetText("Highlights the notepad when you enter a rested zone.")

	self.Frame.HighlightToggle:SetScript("OnEnter", function()
		GameTooltip:SetOwner(self.Frame.HighlightToggle, "ANCHOR_RIGHT")
		GameTooltip:SetText("Highlights the notepad any time you enter a rested zone.", nil, nil, nil, nil, true)
		GameTooltip:Show()
	end)

	self.Frame.HighlightToggle:SetScript("OnLeave", function()
		GameTooltip:Hide()
	end)
end