function NotepadSettings:_InitializeHighlightToggle()
	-- Highlight Toggle
	self.Frame.HighlightToggle = CreateFrame("CheckButton", "QN_Settings_HighlightToggle", self.Frame, "UICheckButtonTemplate")
	self.Frame.HighlightToggle:SetPoint("TOPLEFT", self.Frame, 12, -140)
	self.Frame.HighlightToggle.Text:SetText("Enable Highlighting")
	
	-- Set initial state
	self.Frame.HighlightToggle:SetChecked(self.enableHighlight or false)
	
	-- Toggle changed
	self.Frame.HighlightToggle:SetScript("OnClick", function(button)
		self.enableHighlight = button:GetChecked()
		self:SaveSettings()
	end)

	self.Frame.HighlightToggle:SetScript("OnEnter", function()
		GameTooltip:SetOwner(self.Frame.HighlightToggle, "ANCHOR_RIGHT")
		GameTooltip:SetText("Highlights the notepad any time you enter a rested zone.", nil, nil, nil, nil, true)
		GameTooltip:Show()
	end)

	self.Frame.HighlightToggle:SetScript("OnLeave", function()
		GameTooltip:Hide()
	end)
end