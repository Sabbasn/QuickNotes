function Notepad:Minimize()
    local width, height = self.Frame:GetSize()
    CharSettings["frameSize"] = {width, height}
    self.Frame:SetSize(width, 25)
    self.Frame:SetResizable(false)
    self.Frame.InputField:Hide()
    self.Frame.AddButton:Hide()
	self.Frame.ResizeButton:Hide()
	self.Frame.LockButton:Hide()
    if self.Frame.NoteField then
        self.Frame.NoteField:Hide()
    end
    self.Frame.ScrollFrame:Hide()
    self.Frame.ToggleMinimizeButton:SetText("+")
    CharSettings["minimized"] = true
end

function Notepad:Maximize()
    self.Frame:SetResizable(true)
    self.Frame.InputField:Show()
    self.Frame.AddButton:Show()
	self.Frame.ResizeButton:Show()
	self.Frame.LockButton:Show()
    if self.Frame.NoteField then
        self.Frame.NoteField:Show()
    end
    self.Frame.ScrollFrame:Show()
    self.Frame.ToggleMinimizeButton:SetText("-")
    if CharSettings["frameSize"] == nil then
        self.Frame:SetSize(225, 300)
    else
        self.Frame:SetSize(unpack(CharSettings["frameSize"]))
    end
    CharSettings["minimized"] = false
end

function Notepad:ToggleMinimize()
    if CharSettings["minimized"] == false then
        self:Minimize()
    else
        self:Maximize()
    end
end

function Notepad:ToggleUILock(locked)
	if locked then
		self.isLocked = true
		self.Frame:SetResizable(false)
		self.Frame.LockButton:SetText("unlock")
		self.Frame.ResizeButton:Hide()
	else
		self.isLocked = false
		self.Frame:SetResizable(true)
		self.Frame.LockButton:SetText("lock")
		self.Frame.ResizeButton:Show()
	end
    CharSettings["frameLocked"] = self.isLocked
end