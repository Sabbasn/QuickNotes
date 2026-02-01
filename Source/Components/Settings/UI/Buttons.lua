function NotepadSettings:_InitializeButtons()
	-- Reset Button
	self.Frame.ResetButton = CreateFrame("Button", "QN_Settings_Reset", self.Frame, "UIPanelButtonTemplate")
	self.Frame.ResetButton:SetSize(100, 22)
	self.Frame.ResetButton:SetPoint("BOTTOMLEFT", self.Frame, 12, 12)
	self.Frame.ResetButton:SetText("Reset")
	self.Frame.ResetButton:SetScript("OnClick", function()
		self:_ResetToDefaults()
	end)

	-- Apply Button
	self.Frame.ApplyButton = CreateFrame("Button", "QN_Settings_Apply", self.Frame, "UIPanelButtonTemplate")
	self.Frame.ApplyButton:SetSize(100, 22)
	self.Frame.ApplyButton:SetPoint("BOTTOMRIGHT", self.Frame, -12, 12)
	self.Frame.ApplyButton:SetText("Close")
	self.Frame.ApplyButton:SetScript("OnClick", function()
		self:Close()
	end)
end

function NotepadSettings:_ResetToDefaults()
	-- Reset color to black
	self.currentColor.r = 0
	self.currentColor.g = 0
	self.currentColor.b = 0
	self.currentColor.a = 0.3
	self.Frame.ColorPickerButton.Preview:SetColorTexture(
		self.currentColor.r,
		self.currentColor.g,
		self.currentColor.b,
		self.currentColor.a)
	
	-- Apply to notepad
	if self.notepad and self.notepad.Frame and self.notepad.Frame.Background then
		self.notepad.Frame.Background:SetColorTexture(0, 0, 0, 0.3)
		self.notepad.backgroundOpacity = 0.3
	end
	-- Save settings
	self:SaveSettings()
end
