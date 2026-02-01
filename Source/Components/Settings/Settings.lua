NotepadSettings = {}
NotepadSettings.__index = NotepadSettings

function NotepadSettings.new(notepad)
	local self = setmetatable({}, NotepadSettings)
	self.notepad = notepad
	self.Frame = nil
	self.isOpen = false
	self.currentColor = {r = 0, g = 0, b = 0} -- Store current color
	self.enableHighlight = false

	self:Initialize()
	return self
end

function NotepadSettings:Initialize()
	self:_LoadSettings()
	self:_InitializeFrame()
	self:_InitializeColorPicker()
	self:_InitializeOpacitySlider()
	self:_InitializeButtons()
	self:_InitializeHighlightToggle()
	self:_ApplyLoadedSettings()
end

function NotepadSettings:Open()
	if not self.Frame then
		self:Initialize()
	end
	self.Frame:Show()
	self.isOpen = true
end

function NotepadSettings:Close()
	if self.Frame then
		self:SaveSettings()
		self.Frame:Hide()
	end
	self.isOpen = false
end

function NotepadSettings:Toggle()
	if self.isOpen then
		self:Close()
	else
		self:Open()
	end
end

return NotepadSettings
