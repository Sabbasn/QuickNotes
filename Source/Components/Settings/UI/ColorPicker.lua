local colorOptions = {
	{
		key = "backgroundColor",
		label = "Background color",
		tooltip = "Choose the background color for the notepad.",
		y = -101,
	},
	{
		key = "headerColor",
		label = "Header color",
		tooltip = "Choose the header color for the notepad.",
		y = -139,
	},
	{
		key = "rowColor",
		label = "Note row color",
		tooltip = "Choose the background color for note rows.",
		y = -177,
	},
}

function NotepadSettings:_GetColorState(colorKey)
	if colorKey == "backgroundColor" then
		return self.currentColor
	elseif colorKey == "headerColor" then
		return self.currentHeaderColor
	end
	return self.currentRowColor
end

function NotepadSettings:_InitializeColorPicker()
	self.Frame.ColorPickers = {}

	for _, option in ipairs(colorOptions) do
		local colorKey = option.key
		local colorLabel = option.label
		local colorTooltip = option.tooltip
		local y = option.y
		local label = self.Frame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
		label:SetPoint("TOPLEFT", self.Frame, 22, y)
		label:SetText(colorLabel)

		local button = CreateFrame("Button", nil, self.Frame, "UIPanelButtonTemplate")
		button:SetPoint("TOPRIGHT", self.Frame, "TOPRIGHT", -18, y + 5)
		button:SetSize(88, 24)
		button:SetText("Change...")
		button:SetScript("OnClick", function()
			self:_OpenColorPickerDialog(colorKey)
		end)

		local preview = self.Frame:CreateTexture(nil, "OVERLAY")
		preview:SetSize(20, 20)
		preview:SetPoint("RIGHT", button, "LEFT", -8, 0)

		local resetButton = CreateFrame("Button", nil, self.Frame)
		resetButton:SetSize(38, 18)
		resetButton:SetPoint("RIGHT", preview, "LEFT", -8, 0)
		resetButton.Text = resetButton:CreateFontString(nil, "ARTWORK", "GameFontDisableSmall")
		resetButton.Text:SetPoint("CENTER")
		resetButton.Text:SetText("Reset")
		resetButton:SetScript("OnClick", function()
			self:_ResetToDefaults(colorKey)
		end)
		resetButton:SetScript("OnEnter", function(control)
			control.Text:SetTextColor(1, 0.82, 0.25)
		end)
		resetButton:SetScript("OnLeave", function(control)
			control.Text:SetTextColor(0.65, 0.68, 0.73)
		end)

		button:SetScript("OnEnter", function(control)
			GameTooltip:SetOwner(control, "ANCHOR_RIGHT")
			GameTooltip:SetText(colorTooltip, nil, nil, nil, nil, true)
			GameTooltip:Show()
		end)
		button:SetScript("OnLeave", function()
			GameTooltip:Hide()
		end)

		self.Frame.ColorPickers[option.key] = {
			Label = label,
			Button = button,
			Preview = preview,
			ResetButton = resetButton,
		}
	end

	for _, option in ipairs(colorOptions) do
		local color = self:_GetColorState(option.key)
		self.Frame.ColorPickers[option.key].Preview:SetColorTexture(color.r, color.g, color.b, 1)
	end
end

function NotepadSettings:_ApplyColor(colorKey)
	local color = self:_GetColorState(colorKey)
	local notepadFrame = self.notepad.Frame

	if colorKey == "backgroundColor" then
		notepadFrame.Background:SetColorTexture(color.r, color.g, color.b, color.a or 0.3)
	elseif colorKey == "headerColor" then
		notepadFrame.Header:SetColorTexture(color.r, color.g, color.b, color.a or 0.96)
	else
		self.notepad:ApplyRowColorToNotes()
	end
end

function NotepadSettings:_OpenColorPickerDialog(colorKey)
	local color = self:_GetColorState(colorKey)
	local prevR, prevG, prevB, prevA = color.r, color.g, color.b, color.a
	local picker = self.Frame.ColorPickers[colorKey]

	local function updateColor()
		local r, g, b = ColorPickerFrame:GetColorRGB()
		color.r, color.g, color.b = r, g, b
		picker.Preview:SetColorTexture(r, g, b, 1)
		self:_ApplyColor(colorKey)
		self:SaveSettings()
	end

	local function updateOpacity()
		color.a = ColorPickerFrame:GetColorAlpha()
		self:_ApplyColor(colorKey)
		self:SaveSettings()
	end

	local function cancelColor()
		color.r, color.g, color.b, color.a = prevR, prevG, prevB, prevA
		picker.Preview:SetColorTexture(prevR, prevG, prevB, 1)
		self:_ApplyColor(colorKey)
		self:SaveSettings()
	end

	ColorPickerFrame:SetupColorPickerAndShow({
		r = color.r,
		g = color.g,
		b = color.b,
		hasOpacity = true,
		opacity = color.a or 1,
		swatchFunc = updateColor,
		opacityFunc = updateOpacity,
		cancelFunc = cancelColor,
	})
end
