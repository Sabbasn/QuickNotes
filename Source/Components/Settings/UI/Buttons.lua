function NotepadSettings:_InitializeButtons()
	-- Reset Button
	self.Frame.ResetButton = CreateFrame("Button", "QN_Settings_Reset", self.Frame, "UIPanelButtonTemplate")
	self.Frame.ResetButton:SetSize(100, 22)
	self.Frame.ResetButton:SetPoint("BOTTOMLEFT", self.Frame, 18, 12)
	self.Frame.ResetButton:SetText("Reset Color")
	self.Frame.ResetButton:SetScript("OnClick", function()
		self:_ResetToDefaults()
	end)

	self.Frame.ResetCharacterButton = CreateFrame("Button", "QN_Settings_ResetCharacter", self.Frame)
	self.Frame.ResetCharacterButton:SetSize(304, 18)
	self.Frame.ResetCharacterButton:SetPoint("TOPLEFT", self.Frame, 18, -220)
	self.Frame.ResetCharacterButton.Text = self.Frame.ResetCharacterButton:CreateFontString(nil, "ARTWORK", "GameFontDisableSmall")
	self.Frame.ResetCharacterButton.Text:SetPoint("LEFT", self.Frame.ResetCharacterButton, "LEFT", 0, 0)
	self.Frame.ResetCharacterButton.Text:SetTextColor(0.65, 0.68, 0.73)
	self.Frame.ResetCharacterButton.Text:SetText("Reset this character's notes and settings...")
	self.Frame.ResetCharacterButton:SetAlpha(0.8)
	self.Frame.ResetCharacterButton:SetScript("OnClick", function()
		StaticPopupDialogs["QUICKNOTES_RESET_CHARACTER"] = {
			text = "Reset Quick Notes for this character?\n\nThis permanently deletes this character's saved notes and resets its notepad position, size, and settings. Other characters and the minimap icon position will not be changed.",
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
	self.Frame.ApplyButton = CreateFrame("Button", "QN_Settings_Apply", self.Frame, "UIPanelButtonTemplate")
	self.Frame.ApplyButton:SetSize(100, 22)
	self.Frame.ApplyButton:SetPoint("BOTTOMRIGHT", self.Frame, -18, 12)
	self.Frame.ApplyButton:SetText("Close")
	self.Frame.ApplyButton:SetScript("OnClick", function()
		self:Close()
	end)
end

function NotepadSettings:_ResetToDefaults()
	self.currentColor.r = 0
	self.currentColor.g = 0
	self.currentColor.b = 0
	self.currentColor.a = 0.3
	self.Frame.ColorPickerButton.Preview:SetColorTexture(
		self.currentColor.r,
		self.currentColor.g,
		self.currentColor.b,
		self.currentColor.a)
	
	if self.notepad and self.notepad.Frame and self.notepad.Frame.Background then
		self.notepad.Frame.Background:SetColorTexture(0, 0, 0, 0.3)
		self.notepad.backgroundOpacity = 0.3
	end
	self:SaveSettings()
end

function NotepadSettings:_ResetCharacterData()
	wipe(CharNotesDB)
	for _, note in ipairs(self.notepad.notes) do
		note:Hide()
		note:SetParent(nil)
	end
	wipe(self.notepad.notes)

	wipe(CharSettings)
	self.notepad.Frame:SetUserPlaced(false)
	self.notepad.Frame:ClearAllPoints()
	self.notepad.Frame:SetPoint("CENTER")
	self.notepad:Maximize()
	self.notepad:ToggleUILock(false)
	self.notepad.isMinimized = false
	self.notepad:_UpdateNotesLayout()

	self.currentColor = {r = 0, g = 0, b = 0, a = 0.3}
	self.enableHighlight = false
	self.Frame.ColorPickerButton.Preview:SetColorTexture(0, 0, 0, 0.3)
	self.Frame.HighlightToggle:SetChecked(false)
	self.notepad.Frame.Background:SetColorTexture(0, 0, 0, 0.3)
	self.notepad.Frame.HighlightBorderAnimGroup:Stop()
	self:SaveSettings()

	print("|cffffcc00QuickNotes:|r This character's notes and settings have been reset.")
end
