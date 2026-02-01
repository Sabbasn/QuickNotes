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
	local prevR, prevG, prevB, prevA = self.currentColor.r, self.currentColor.g, self.currentColor.b, self.currentColor.a
	local background = self.notepad.Frame.Background
	
	-- WoW Color Picker function - real-time updates
	ColorPickerFrame:SetColorRGB(self.currentColor.r, self.currentColor.g, self.currentColor.b)
	ColorPickerFrame.func = function()
		local r, g, b = ColorPickerFrame:GetColorRGB()
		self.currentColor.r = r
		self.currentColor.g = g
		self.currentColor.b = b
		self.Frame.ColorPreview:SetColorTexture(r, g, b, 1)
		-- Apply color to notepad background
		if background then
			background:SetColorTexture(r, g, b, self.currentColor.a or 0.3)
		end
	end

	ColorPickerFrame.hasOpacity, ColorPickerFrame.opacity = (self.currentColor.a ~= nil), (self.currentColor.a or 0.3)
	ColorPickerFrame.opacityFunc = function ()
		local alpha = OpacitySliderFrame:GetValue()
		-- Update notepad background opacity
		if background then
			background:SetColorTexture(self.currentColor.r, self.currentColor.g, self.currentColor.b, alpha)
			self.currentColor.a = alpha
		end

		self:SaveSettings()
	end
	
	-- OK button callback
	ColorPickerFrame.swatchFunc = function()
		local r, g, b = ColorPickerFrame:GetColorRGB()
		self.currentColor.r = r
		self.currentColor.g = g
		self.currentColor.b = b
		self.Frame.ColorPreview:SetColorTexture(r, g, b, self.currentColor.a)
		-- Apply color to notepad background
		if background then
			background:SetColorTexture(r, g, b, self.currentColor.a or 0.3)
		end
		-- Save settings
		self:SaveSettings()
	end

	ColorPickerFrame.cancelFunc = function ()
		-- Restore previous color if canceled
		self.currentColor.r = prevR
		self.currentColor.g = prevG
		self.currentColor.b = prevB
		self.currentColor.a = prevA
		self.Frame.ColorPreview:SetColorTexture(
			self.currentColor.r,
			self.currentColor.g,
			self.currentColor.b,
			self.currentColor.a
		)
		if background then
			background:SetColorTexture(prevR, prevG, prevB, prevA)
		end
	end
	
	ColorPickerFrame:Show()
end
