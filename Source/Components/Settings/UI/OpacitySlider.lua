function NotepadSettings:_InitializeOpacitySlider()
	-- Opacity Label
	self.Frame.OpacityLabel = self.Frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	self.Frame.OpacityLabel:SetPoint("TOPLEFT", self.Frame, 12, -80)
	self.Frame.OpacityLabel:SetText("Background Opacity:")

	-- Opacity Value Display
	self.Frame.OpacityValue = self.Frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	self.Frame.OpacityValue:SetPoint("LEFT", self.Frame.OpacityLabel, "RIGHT", 10, 0)
	self.Frame.OpacityValue:SetText((self.notepad.backgroundOpacity or 0.3) * 100 .. "%")

	-- Opacity Slider (no global name to avoid conflicts)
	self.Frame.OpacitySlider = CreateFrame("Slider", nil, self.Frame, "OptionsSliderTemplate")
	self.Frame.OpacitySlider:SetSize(200, 15)
	self.Frame.OpacitySlider:SetPoint("TOPLEFT", self.Frame, 12, -110)
	self.Frame.OpacitySlider:SetMinMaxValues(0, 1)
	self.Frame.OpacitySlider:SetValue(self.notepad.backgroundOpacity or 0.3)
	self.Frame.OpacitySlider:SetValueStep(0.05)

	-- Slider value changed
	self.Frame.OpacitySlider:SetScript("OnValueChanged", function(slider, value)
		value = math.floor(value * 100) / 100  -- Round to 2 decimal places
		self.Frame.OpacityValue:SetText(value * 100 .. "%")
		
		-- Apply opacity to notepad background
		if self.notepad and self.notepad.Frame and self.notepad.Frame.Background then
			local r = self.currentColor.r or 0
			local g = self.currentColor.g or 0
			local b = self.currentColor.b or 0
			self.notepad.Frame.Background:SetColorTexture(r, g, b, value)
			self.notepad.backgroundOpacity = value
		end
		-- Save settings
		self:SaveSettings()
	end)

	-- Set slider text labels if they exist
	if self.Frame.OpacitySlider.Low then
		self.Frame.OpacitySlider.Low:SetText("0%")
	end
	if self.Frame.OpacitySlider.High then
		self.Frame.OpacitySlider.High:SetText("100%")
	end
end
