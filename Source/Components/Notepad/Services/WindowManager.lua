function Notepad:Minimize()
    local width, height = self.Frame:GetSize()
    self.data.settings.frameSize = {width, height}
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
    self.data.settings.minimized = true
    self.isMinimized = true
end

function Notepad:Maximize()
    self.Frame:SetResizable(true)
    self.Frame.InputField:Show()
    self.Frame.AddButton:Show()
	self.Frame.ResizeButton:Show()
	if self.isLocked then
		self.Frame.ResizeButton:Hide()
	end
	self.Frame.LockButton:Show()
    if self.Frame.NoteField then
        self.Frame.NoteField:Show()
    end
    self.Frame.ScrollFrame:Show()
    self.Frame.ToggleMinimizeButton:SetText("-")
    if self.data.settings.frameSize == nil then
        self.Frame:SetSize(225, 300)
    else
        self.Frame:SetSize(unpack(self.data.settings.frameSize))
    end
    self.data.settings.minimized = false
    self.isMinimized = false
end

function Notepad:ToggleMinimize()
    if self.data.settings.minimized then
        self:Maximize()
    else
        self:Minimize()
    end
end

function Notepad:ToggleUILock(locked)
	if locked then
		self.isLocked = true
		self.Frame.LockButton:SetText("unlock")
		self.Frame.ResizeButton:Hide()
	else
		self.isLocked = false
		self.Frame.LockButton:SetText("lock")
		self.Frame.ResizeButton:Show()
	end
    self.data.settings.frameLocked = self.isLocked
end

function Notepad:LoadWindowSettings()
    local settings = self.data.settings
    local position = settings.framePosition

    self.Frame:ClearAllPoints()
    if position then
        self.Frame:SetPoint(
            position.point or "CENTER",
            UIParent,
            position.relativePoint or position.point or "CENTER",
            position.x or 0,
            position.y or 0
        )
    else
        self.Frame:SetPoint("CENTER")
    end

    self.Frame:SetSize(unpack(settings.frameSize or {225, 300}))
    self.Frame.Title:SetText(self.data.title)
    local isMinimized = settings.minimized
    self:Maximize()
    self:ToggleUILock(settings.frameLocked or false)
    if isMinimized then
        self:Minimize()
    end
end

function Notepad:SaveFrameSettings()
    local settings = self.data.settings
    if not self.isMinimized then
        local width, height = self.Frame:GetSize()
        settings.frameSize = {width, height}
    end

    local point, _, relativePoint, x, y = self.Frame:GetPoint(1)
    if point then
        settings.framePosition = {
            point = point,
            relativePoint = relativePoint,
            x = x,
            y = y,
        }
    end
end

function Notepad:SetVisible(visible)
    self.visible = visible
    self.data.visible = visible
    if visible then
        self.Frame:Show()
    else
        self.Frame:Hide()
    end
end

function Notepad:ResetPositionAndSize()
    self:Maximize()
    self.Frame:SetSize(225, 300)
    self.Frame:ClearAllPoints()
    self.Frame:SetPoint("CENTER", UIParent, 0, 0)
    self:SaveFrameSettings()
end