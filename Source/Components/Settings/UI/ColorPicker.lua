function NotepadSettings:_InitializeColorPicker()
	self.Frame.ColorPickerLabel = self.Frame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
	self.Frame.ColorPickerLabel:SetPoint("TOPLEFT", self.Frame, 22, -101)
	self.Frame.ColorPickerLabel:SetText("Background color")

	self.Frame.ColorPickerButton = CreateFrame("Button", nil, self.Frame, "UIPanelButtonTemplate")
	self.Frame.ColorPickerButton:SetPoint("TOPRIGHT", self.Frame, "TOPRIGHT", -18, -96)
	self.Frame.ColorPickerButton:SetSize(88, 24)
	self.Frame.ColorPickerButton:SetText("Change...")
	self.Frame.ColorPickerButton:SetScript("OnClick", function()
		self:_OpenColorPickerDialog()
	end)

	self.Frame.ColorPickerButton.Preview = self.Frame:CreateTexture(nil, "OVERLAY")
	self.Frame.ColorPickerButton.Preview:SetSize(20, 20)
	self.Frame.ColorPickerButton.Preview:SetPoint("RIGHT", self.Frame.ColorPickerButton, "LEFT", -8, 0)
	self.Frame.ColorPickerButton.Preview:SetColorTexture(self.currentColor.r, self.currentColor.g, self.currentColor.b, 1)

	self.Frame.ResetColorButton = CreateFrame("Button", nil, self.Frame)
	self.Frame.ResetColorButton:SetSize(38, 18)
	self.Frame.ResetColorButton:SetPoint("RIGHT", self.Frame.ColorPickerButton.Preview, "LEFT", -8, 0)
	self.Frame.ResetColorButton.Text = self.Frame.ResetColorButton:CreateFontString(nil, "ARTWORK", "GameFontDisableSmall")
	self.Frame.ResetColorButton.Text:SetPoint("CENTER")
	self.Frame.ResetColorButton.Text:SetText("Reset")
	self.Frame.ResetColorButton:SetScript("OnClick", function()
		self:_ResetToDefaults()
	end)
	self.Frame.ResetColorButton:SetScript("OnEnter", function(button)
		button.Text:SetTextColor(1, 0.82, 0.25)
	end)
	self.Frame.ResetColorButton:SetScript("OnLeave", function(button)
		button.Text:SetTextColor(0.65, 0.68, 0.73)
	end)

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
	
	local function updateColor()
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

	local function updateOpacity()
		local alpha = ColorPickerFrame:GetColorAlpha()
		-- Update notepad background opacity
		if background then
			background:SetColorTexture(self.currentColor.r, self.currentColor.g, self.currentColor.b, alpha)
			self.currentColor.a = alpha
		end

		self:SaveSettings()
	end
	
	local function cancelColor()
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
	
	ColorPickerFrame:SetupColorPickerAndShow({
		r = self.currentColor.r,
		g = self.currentColor.g,
		b = self.currentColor.b,
		hasOpacity = (self.currentColor.a ~= nil),
		opacity = self.currentColor.a or 0.3,
		swatchFunc = updateColor,
		opacityFunc = updateOpacity,
		cancelFunc = cancelColor,
	})
end
