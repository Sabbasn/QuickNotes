-- SettingsManager handles persistence and retrieval of settings
function NotepadSettings:SaveSettings()
	if not CharSettings then
		CharSettings = {}
	end
	
	if not CharSettings.notepadSettings then
		CharSettings.notepadSettings = {}
	end
	
	-- Store current color
	CharSettings.notepadSettings.backgroundColor = {
		r = self.currentColor.r,
		g = self.currentColor.g,
		b = self.currentColor.b
	}
	
  CharSettings.notepadSettings.enableHighlight = self.enableHighlight

	if self.Frame and self.Frame.OpacitySlider then
		CharSettings.notepadSettings.backgroundOpacity = self.Frame.OpacitySlider:GetValue()
	end
end

function NotepadSettings:_LoadSettings()
	if not CharSettings then
		CharSettings = {}
	end
	
	if not CharSettings.notepadSettings then
		CharSettings.notepadSettings = {}
	end

  if CharSettings.notepadSettings.enableHighlight ~= nil then
    self.enableHighlight = CharSettings.notepadSettings.enableHighlight
  end
	
	-- Load background color
	if CharSettings.notepadSettings.backgroundColor then
		self.currentColor = CharSettings.notepadSettings.backgroundColor
	else
		-- Use defaults
		self.currentColor = {r = 0, g = 0, b = 0}
	end
	
	-- Load background opacity
	if CharSettings.notepadSettings.backgroundOpacity then
		if self.Frame and self.Frame.OpacitySlider then
			self.Frame.OpacitySlider:SetValue(CharSettings.notepadSettings.backgroundOpacity)
			self.Frame.OpacityValue:SetText(string.format("%.2f", CharSettings.notepadSettings.backgroundOpacity))
		end
	else
		-- Use default
		if self.Frame and self.Frame.OpacitySlider then
			self.Frame.OpacitySlider:SetValue(0.3)
			self.Frame.OpacityValue:SetText("0.3")
		end
	end
end

function NotepadSettings:_ApplyLoadedSettings()
	if not CharSettings or not CharSettings.notepadSettings then
		return
	end
  
	-- Apply color and opacity to notepad background
	if self.notepad and self.notepad.Frame and self.notepad.Frame.Background then
		local r = self.currentColor.r or 0
		local g = self.currentColor.g or 0
		local b = self.currentColor.b or 0
		local opacity = CharSettings.notepadSettings.backgroundOpacity or 0.3
		self.notepad.Frame.Background:SetColorTexture(r, g, b, opacity)
		self.notepad.backgroundOpacity = opacity
		self.Frame.HighlightToggle:SetChecked(self.enableHighlight)
	end
end
