-- SettingsManager handles persistence and retrieval of settings
function NotepadSettings:SaveSettings()
	local settings = self.notepad.data.settings
	settings.notepadSettings = settings.notepadSettings or {}
	
	-- Store current color
	settings.notepadSettings.backgroundColor = {
		r = self.currentColor.r,
		g = self.currentColor.g,
		b = self.currentColor.b,
		a = self.currentColor.a
	}
	
	settings.notepadSettings.enableHighlight = self.enableHighlight

	if self.Frame and self.Frame.OpacitySlider then
		settings.notepadSettings.backgroundOpacity = self.opacity
	end
end

function NotepadSettings:_LoadSettings()
	local settings = self.notepad.data.settings
	settings.notepadSettings = settings.notepadSettings or {}

	if settings.notepadSettings.enableHighlight ~= nil then
		self.enableHighlight = settings.notepadSettings.enableHighlight
	else
		self.enableHighlight = false
	end
	
	-- Load background color
	if settings.notepadSettings.backgroundColor then
		self.currentColor = settings.notepadSettings.backgroundColor
	else
		-- Use defaults
		self.currentColor = {r = 0, g = 0, b = 0, a = 0.3}
	end
end

function NotepadSettings:_ApplyLoadedSettings()
	if not self.notepad.data or not self.notepad.data.settings.notepadSettings then
		return
	end
  
	-- Apply color and opacity to notepad background
	if self.notepad and self.notepad.Frame and self.notepad.Frame.Background then
		local r = self.currentColor.r or 0
		local g = self.currentColor.g or 0
		local b = self.currentColor.b or 0
		local a = self.currentColor.a or 0.3
		self.notepad.Frame.Background:SetColorTexture(r, g, b, a)
		self.Frame.HighlightToggle:SetChecked(self.enableHighlight)
	end
end
