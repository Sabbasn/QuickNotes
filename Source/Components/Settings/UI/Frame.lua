function NotepadSettings:_InitializeFrame()
	self.Frame = CreateFrame("Frame", "QN_Settings", UIParent)
	self.Frame:SetSize(300, 250)
	self.Frame:SetPoint("CENTER")
	self.Frame:SetMovable(true)
	self.Frame:EnableMouse(true)
	self.Frame:SetClampedToScreen(true)

	-- Main Frame Background
	self.Frame.Background = self.Frame:CreateTexture("QN_Settings_Background", "BACKGROUND")
	self.Frame.Background:SetAllPoints()
	self.Frame.Background:SetColorTexture(0.1, 0.1, 0.1, 0.95)

	-- Title
	self.Frame.Title = self.Frame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
	self.Frame.Title:SetTextColor(1, 1, 0, 1)
	self.Frame.Title:SetPoint("TOPLEFT", self.Frame, 8, -8)
	self.Frame.Title:SetText("Quick Notes Settings")

	-- Close Button
	self.Frame.CloseButton = CreateFrame("Button", "QN_Settings_Close", self.Frame, "UIPanelCloseButton")
	self.Frame.CloseButton:SetPoint("TOPRIGHT", self.Frame, -4, 0)
	self.Frame.CloseButton:SetScript("OnClick", function()
		self:Close()
	end)

	-- Dragging
	self.Frame:RegisterForDrag("LeftButton")
	self.Frame:SetScript("OnDragStart", function()
		self.Frame:StartMoving()
	end)
	self.Frame:SetScript("OnDragStop", function()
		self.Frame:StopMovingOrSizing()
	end)

	-- Hide by default
	self.Frame:Hide()
end
