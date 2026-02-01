function NotepadSettings:_InitializeColorPicker()

	-- Color Picker Button
	self.Frame.ColorPickerButton = CreateFrame("Button", "QN_Settings_ColorPicker", self.Frame)
	self.Frame.ColorPickerButton:SetPoint("TOPLEFT", self.Frame, 15, -30)
	self.Frame.ColorPickerButton:SetSize(25, 25)
	self.Frame.ColorPickerButton:SetText("Choose Color")
	self.Frame.ColorPickerButton:SetScript("OnClick", function()
		self:_OpenColorPickerDialog()
	end)

	-- Color Preview Box
	self.Frame.ColorPickerButton.Preview = self.Frame:CreateTexture("QN_Settings_ColorPreview", "ARTWORK")
	self.Frame.ColorPickerButton.Preview:SetSize(20, 20)
	self.Frame.ColorPickerButton.Preview:SetPoint("CENTER", self.Frame.ColorPickerButton, "CENTER", 0, 0)
	self.Frame.ColorPickerButton.Preview:SetColorTexture(self.currentColor.r, self.currentColor.g, self.currentColor.b, 1)

	-- Label
	self.Frame.ColorPickerButton.Text = self.Frame.ColorPickerButton:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	self.Frame.ColorPickerButton.Text:SetPoint("LEFT", self.Frame.ColorPickerButton, "LEFT", 27, 0)
	self.Frame.ColorPickerButton.Text:SetText("Background Color")
	self.Frame.ColorPickerButton.Text:SetJustifyH("LEFT")

	self.Frame.ColorPickerButton:SetScript("OnEnter", function()
		GameTooltip:SetOwner(self.Frame.ColorPickerButton, "ANCHOR_RIGHT")
		GameTooltip:SetText("Choose the background color for the notepad.", nil, nil, nil, nil, true)
		GameTooltip:Show()
	end)

	self.Frame.ColorPickerButton:SetScript("OnLeave", function()
		GameTooltip:Hide()
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
		self.Frame.ColorPickerButton.Preview:SetColorTexture(r, g, b, 1)
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
		self.Frame.ColorPickerButton.Preview:SetColorTexture(r, g, b, self.currentColor.a)
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
		self.Frame.ColorPickerButton.Preview:SetColorTexture(
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
