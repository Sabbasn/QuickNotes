Notepad = {}
Notepad.__index = Notepad

function Notepad.new(name, data)
	local self = setmetatable({}, Notepad)
	self.name = name
	self.data = data
	self.isLocked = false
	self.isMinimized = false
	self.notes = {}
	self.settings = nil

	self:Initialize()
	if data then
		self:LoadData(data)
	end
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