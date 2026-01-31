function Notepad:_InitializeButtons()
	self:_InitializeToggleMinimizeButton()
	self:_InitializeAddNoteButton()
	self:_InitializeResizeButton()
end

function Notepad:_InitializeToggleMinimizeButton()
	self.Frame.ToggleMinimizeButton = CreateFrame("Button", nil, self.Frame, "BackdropTemplate")
	self.Frame.ToggleMinimizeButton:SetPoint("TOPRIGHT", self.Frame, -4, -2)
	self.Frame.ToggleMinimizeButton:SetText("-")
	self.Frame.ToggleMinimizeButton:SetSize(20, 20)
	self.Frame.ToggleMinimizeButton:SetNormalFontObject("GameFontNormalLarge")
	self.Frame.ToggleMinimizeButton:SetScript("OnClick", function ()
		self:ToggleMinimize()
	end)
end

function Notepad:_InitializeAddNoteButton()
	self.Frame.AddButton = CreateFrame("Button", nil, self.Frame, "GameMenuButtonTemplate")
	self.Frame.AddButton:SetPoint("TOPRIGHT", self.Frame, -10, -30)
	self.Frame.AddButton:SetSize(30, 21)
	self.Frame.AddButton:SetText("+")
	self.Frame.AddButton:SetNormalFontObject("GameFontNormalLarge")
	self.Frame.AddButton:SetScript("OnClick", function()
		self:AddNote(self.Frame.InputField:GetText(), true)
	end)
end

function Notepad:_InitializeResizeButton()
	self.Frame.ResizeButton = CreateFrame("Button", nil, self.Frame)
	self.Frame.ResizeButton:SetSize(12, 12)
	self.Frame.ResizeButton:SetPoint("BOTTOMRIGHT")
	self.Frame.ResizeButton:SetNormalTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Up")
	self.Frame.ResizeButton:SetHighlightTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Highlight")
	self.Frame.ResizeButton:SetPushedTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Down")

	self.Frame.ResizeButton:SetScript("OnMouseDown", function(_, button)
		self.Frame:StartSizing("BOTTOMRIGHT")
		self.Frame:SetUserPlaced(true)
	end)

	self.Frame.ResizeButton:SetScript("OnMouseUp", function(_, button)
		self.Frame:StopMovingOrSizing()
	end)
end