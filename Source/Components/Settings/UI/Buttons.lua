function NotepadSettings:_InitializeButtons()
	self.Frame.ResetCharacterButton = CreateFrame("Button", nil, self.Frame)
	self.Frame.ResetCharacterButton:SetSize(304, 18)
	self.Frame.ResetCharacterButton:SetPoint("TOPLEFT", self.Frame, 18, -294)
	self.Frame.ResetCharacterButton.Text = self.Frame.ResetCharacterButton:CreateFontString(nil, "ARTWORK", "GameFontDisableSmall")
	self.Frame.ResetCharacterButton.Text:SetPoint("LEFT", self.Frame.ResetCharacterButton, "LEFT", 0, 0)
	self.Frame.ResetCharacterButton.Text:SetTextColor(0.65, 0.68, 0.73)
	self.Frame.ResetCharacterButton.Text:SetText("Reset this character's notes and settings...")
	self.Frame.ResetCharacterButton:SetAlpha(0.8)
	self.Frame.ResetCharacterButton:SetScript("OnClick", function()
		StaticPopupDialogs["QUICKNOTES_RESET_CHARACTER"] = {
			text = "Reset Quick Notes for this character?\n\nThis permanently deletes all of this character's notepads and notes, then resets the notepad settings. Other characters and the minimap icon position will not be changed.",
			button1 = "Delete Notes & Reset",
			button2 = CANCEL,
			OnAccept = function(_, settings)
				settings:_ResetCharacterData()
			end,
			timeout = 0,
			whileDead = true,
			hideOnEscape = true,
			preferredIndex = 3,
		}
		StaticPopup_Show("QUICKNOTES_RESET_CHARACTER", nil, nil, self)
	end)
	self.Frame.ResetCharacterButton:SetScript("OnEnter", function(button)
		button:SetAlpha(1)
		button.Text:SetTextColor(1, 0.82, 0.25)
	end)
	self.Frame.ResetCharacterButton:SetScript("OnLeave", function(button)
		button:SetAlpha(0.8)
		button.Text:SetTextColor(0.65, 0.68, 0.73)
	end)

	-- Apply Button
	self.Frame.ApplyButton = CreateFrame("Button", nil, self.Frame, "UIPanelButtonTemplate")
	self.Frame.ApplyButton:SetSize(100, 22)
	self.Frame.ApplyButton:SetPoint("BOTTOMRIGHT", self.Frame, -18, 12)
	self.Frame.ApplyButton:SetText("Close")
	self.Frame.ApplyButton:SetScript("OnClick", function()
		self:Close()
	end)
end

function NotepadSettings:_ResetToDefaults(colorKey)
	local defaults = {
		backgroundColor = {r = 0, g = 0, b = 0, a = 0.3},
		headerColor = {r = 0.07, g = 0.065, b = 0.06, a = 0.96},
		rowColor = {r = 0.07, g = 0.065, b = 0.06, a = 0.72},
	}
	local color = self:_GetColorState(colorKey)
	local default = defaults[colorKey]
	color.r, color.g, color.b, color.a = default.r, default.g, default.b, default.a
	self.Frame.ColorPickers[colorKey].Preview:SetColorTexture(color.r, color.g, color.b, 1)
	self:_ApplyColor(colorKey)
	self:SaveSettings()
end

function NotepadSettings:_ResetCharacterData()
	QuickNotes.Interface.ResetNotepads()

	print("|cffffcc00QuickNotes:|r This character's notes and settings have been reset.")
end
