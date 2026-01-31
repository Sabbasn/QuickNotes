function Notepad:Minimize()
    local width, height = self.Frame:GetSize()
    CharSettings["frameSize"] = {width, height}
    self.Frame:SetSize(width, 25)
    self.Frame:SetResizable(false)
    self.Frame.InputField:Hide()
    self.Frame.AddButton:Hide()
	self.Frame.ResizeButton:SetAlpha(0)
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
	self.Frame.ResizeButton:SetAlpha(1)
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