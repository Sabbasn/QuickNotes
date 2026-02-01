Notepad = {}
Notepad.__index = Notepad

function Notepad.new(name)
	local self = setmetatable({}, Notepad)
	self.name = name
	self.isLocked = false
	self.isMinimized = false
	self.notes = {}
	self.settings = nil

	self:Initialize()
	return self
end

function Notepad:Initialize()
	self:_InitializeFrame()
	self:_InitializeScrollFrame()
	self:_InitializeButtons()
	self:_InitializeInputField()
	self:_InitializeBorderGlow()
	
	self:_InitializeEventHandler()
end

function Notepad:_InitializeSettings()
	self.settings = NotepadSettings.new(self)
end

function Notepad:ShowSettings()
	self.settings:Open()
end

return Notepad