function NotepadSettings:_InitializeColorPicker()
	-- Color Label
	self.Frame.ColorLabel = self.Frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	self.Frame.ColorLabel:SetPoint("TOPLEFT", self.Frame, 12, -40)
	self.Frame.ColorLabel:SetText("Background Color:")

	-- Color Preview Box
	self.Frame.ColorPreview = self.Frame:CreateTexture("QN_Settings_ColorPreview", "ARTWORK")
	self.Frame.ColorPreview:SetSize(30, 20)
	self.Frame.ColorPreview:SetPoint("LEFT", self.Frame.ColorLabel, "RIGHT", 10, 0)
	self.Frame.ColorPreview:SetColorTexture(self.currentColor.r, self.currentColor.g, self.currentColor.b, 1)

	-- Color Picker Button
	self.Frame.ColorPickerButton = CreateFrame("Button", "QN_Settings_ColorPicker", self.Frame, "UIPanelButtonTemplate")
	self.Frame.ColorPickerButton:SetSize(100, 22)
	self.Frame.ColorPickerButton:SetPoint("LEFT", self.Frame.ColorPreview, "RIGHT", 10, 0)
	self.Frame.ColorPickerButton:SetText("Choose Color")
	self.Frame.ColorPickerButton:SetScript("OnClick", function()
		self:_OpenColorPickerDialog()
	end)
end

function NotepadSettings:_OpenColorPickerDialog()
	-- Store reference to self for closure
	local settingsInstance = self
	local prevR, prevG, prevB = self.currentColor.r, self.currentColor.g, self.currentColor.b
	local background = self.notepad.Frame.Background
	
	-- WoW Color Picker function - real-time updates
	ColorPickerFrame:SetColorRGB(self.currentColor.r, self.currentColor.g, self.currentColor.b)
	ColorPickerFrame.func = function()
		local r, g, b = ColorPickerFrame:GetColorRGB()
		settingsInstance.currentColor.r = r
		settingsInstance.currentColor.g = g
		settingsInstance.currentColor.b = b
		settingsInstance.Frame.ColorPreview:SetColorTexture(r, g, b, 1)
		-- Apply color to notepad background
		if background then
			background:SetColorTexture(r, g, b, settingsInstance.notepad.backgroundOpacity or 0.3)
		end
	end
	
	-- OK button callback
	ColorPickerFrame.swatchFunc = function()
		local r, g, b = ColorPickerFrame:GetColorRGB()
		settingsInstance.currentColor.r = r
		settingsInstance.currentColor.g = g
		settingsInstance.currentColor.b = b
		settingsInstance.Frame.ColorPreview:SetColorTexture(r, g, b, 1)
		-- Apply color to notepad background
		if background then
			background:SetColorTexture(r, g, b, settingsInstance.notepad.backgroundOpacity or 0.3)
		end
		-- Save settings
		settingsInstance:SaveSettings()
	end

	ColorPickerFrame.cancelFunc = function ()
		-- Restore previous color if canceled
		settingsInstance.currentColor.r = prevR
		settingsInstance.currentColor.g = prevG
		settingsInstance.currentColor.b = prevB
		settingsInstance.Frame.ColorPreview:SetColorTexture(
			settingsInstance.currentColor.r,
			settingsInstance.currentColor.g,
			settingsInstance.currentColor.b,
			1
		)
		if background then
			background:SetColorTexture(prevR, prevG, prevB, settingsInstance.notepad.backgroundOpacity or 0.3)
		end
	end
	
	ColorPickerFrame:Show()
end
