function Notepad:_InitializeButtons()
	self:_InitializeToggleMinimizeButton()
	self:_InitializeSettingsButton()
	self:_InitializeAddNoteButton()
	self:_InitializeHistoryButtons()
	self:_InitializeResizeButton()
end

function Notepad:_InitializeToggleMinimizeButton()
	self.Frame.ToggleMinimizeButton = CreateFrame("Button", nil, self.Frame, "BackdropTemplate")
	self.Frame.ToggleMinimizeButton:SetPoint("TOPRIGHT", self.Frame, -2, -1)
	self.Frame.ToggleMinimizeButton:SetText("-")
	self.Frame.ToggleMinimizeButton:SetSize(24, 24)
	self.Frame.ToggleMinimizeButton:SetNormalFontObject("GameFontNormalLarge")
	self.Frame.ToggleMinimizeButton:SetScript("OnClick", function ()
		self:ToggleMinimize()
	end)
end

function Notepad:_InitializeSettingsButton()
	self.Frame.SettingsButton = CreateFrame("Button", nil, self.Frame)
	self.Frame.SettingsButton:SetPoint("TOPRIGHT", self.Frame.ToggleMinimizeButton, "TOPLEFT", -1, 0)
	self.Frame.SettingsButton:SetSize(24, 24)
	self.Frame.SettingsButton.Icon = self.Frame.SettingsButton:CreateTexture(nil, "ARTWORK")
	self.Frame.SettingsButton.Icon:SetPoint("CENTER")
	self.Frame.SettingsButton.Icon:SetSize(16, 16)
	self.Frame.SettingsButton.Icon:SetTexture("Interface\\AddOns\\QuickNotes\\Images\\Cog.png")
	self.Frame.SettingsButton.Icon:SetVertexColor(0.88, 0.82, 0.72)
	
	self.Frame.SettingsButton:SetScript("OnEnter", function()
		self.Frame.SettingsButton.Icon:SetVertexColor(1, 0.82, 0.25)
		GameTooltip:SetOwner(self.Frame.SettingsButton, "ANCHOR_RIGHT")
		GameTooltip:SetText("Settings")
		GameTooltip:Show()
	end)

	self.Frame.SettingsButton:SetScript("OnLeave", function()
		self.Frame.SettingsButton.Icon:SetVertexColor(0.88, 0.82, 0.72)
		GameTooltip:Hide()
	end)

	self.Frame.SettingsButton:SetScript("OnClick", function ()
		if self.settings then
			self:ShowSettings()
		end
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

function Notepad:_InitializeHistoryButtons()
	self.Frame.UndoButton = CreateFrame("Button", "QN_" .. self.name .. "_UndoButton", self.Frame)
	self.Frame.UndoButton:SetSize(24, 24)
	self.Frame.UndoButton.Icon = self.Frame.UndoButton:CreateTexture(nil, "ARTWORK")
	self.Frame.UndoButton.Icon:SetPoint("CENTER")
	self.Frame.UndoButton.Icon:SetSize(16, 16)
	self.Frame.UndoButton.Icon:SetTexture("Interface\\Buttons\\UI-RotationLeft-Button-Up")
	self.Frame.UndoButton:SetScript("OnClick", function()
		self:UndoNoteAction()
	end)

	self.Frame.RedoButton = CreateFrame("Button", "QN_" .. self.name .. "_RedoButton", self.Frame)
	self.Frame.RedoButton:SetSize(24, 24)
	self.Frame.RedoButton.Icon = self.Frame.RedoButton:CreateTexture(nil, "ARTWORK")
	self.Frame.RedoButton.Icon:SetPoint("CENTER")
	self.Frame.RedoButton.Icon:SetSize(16, 16)
	self.Frame.RedoButton.Icon:SetTexture("Interface\\Buttons\\UI-RotationRight-Button-Up")
	self.Frame.RedoButton:SetPoint("TOPRIGHT", self.Frame.SettingsButton, "TOPLEFT", -1, 0)
	self.Frame.UndoButton:SetPoint("TOPRIGHT", self.Frame.RedoButton, "TOPLEFT", -1, 0)
	self.Frame.RedoButton:SetScript("OnClick", function()
		self:RedoNoteAction()
	end)

	self.Frame.UndoButton:SetScript("OnEnter", function(button)
		button.Icon:SetVertexColor(1, 0.82, 0.25)
		GameTooltip:SetOwner(button, "ANCHOR_RIGHT")
		GameTooltip:SetText("Undo (Ctrl+Z while over this notepad)")
		GameTooltip:Show()
	end)
	self.Frame.RedoButton:SetScript("OnEnter", function(button)
		button.Icon:SetVertexColor(1, 0.82, 0.25)
		GameTooltip:SetOwner(button, "ANCHOR_RIGHT")
		GameTooltip:SetText("Redo (Ctrl+Y while over this notepad)")
		GameTooltip:Show()
	end)
	self.Frame.UndoButton:SetScript("OnLeave", function()
		if self.undoStack and #self.undoStack > 0 then
			self.Frame.UndoButton.Icon:SetVertexColor(0.88, 0.82, 0.72)
		else
			self.Frame.UndoButton.Icon:SetVertexColor(0.45, 0.45, 0.45)
		end
		GameTooltip:Hide()
	end)
	self.Frame.RedoButton:SetScript("OnLeave", function()
		if self.redoStack and #self.redoStack > 0 then
			self.Frame.RedoButton.Icon:SetVertexColor(0.88, 0.82, 0.72)
		else
			self.Frame.RedoButton.Icon:SetVertexColor(0.45, 0.45, 0.45)
		end
		GameTooltip:Hide()
	end)
	self:_UpdateHistoryButtons()
end

function Notepad:_UpdateHistoryButtons()
	if not self.Frame or not self.Frame.UndoButton then
		return
	end
	local canUndo = self.undoStack ~= nil and #self.undoStack > 0
	local canRedo = self.redoStack ~= nil and #self.redoStack > 0
	self.Frame.UndoButton:SetEnabled(canUndo)
	self.Frame.RedoButton:SetEnabled(canRedo)
	self.Frame.UndoButton.Icon:SetVertexColor(canUndo and 0.88 or 0.45, canUndo and 0.82 or 0.45, canUndo and 0.72 or 0.45)
	self.Frame.RedoButton.Icon:SetVertexColor(canRedo and 0.88 or 0.45, canRedo and 0.82 or 0.45, canRedo and 0.72 or 0.45)
	self:UpdateHistoryBindingsForMouse()
end

function Notepad:UpdateHistoryBindingsForMouse()
	if not self.Frame then
		return
	end
	self:SetHistoryBindings(self.Frame:IsMouseOver())
end

function Notepad:SetHistoryBindings(enabled)
	if not self.Frame or not self.Frame.UndoButton then
		return
	end
	if not enabled
		or self.isMinimized
		or not self.Frame:IsShown()
		or (self.Frame.InputField and self.Frame.InputField:HasFocus())
		or (ChatEdit_GetActiveWindow and ChatEdit_GetActiveWindow())
		or (GetCurrentKeyBoardFocus and GetCurrentKeyBoardFocus()) then
		if ClearOverrideBindings then
			ClearOverrideBindings(self.Frame)
		end
		return
	end

	if not SetOverrideBindingClick then
		return
	end
	if ClearOverrideBindings then
		ClearOverrideBindings(self.Frame)
	end
	if self.undoStack and #self.undoStack > 0 then
		SetOverrideBindingClick(self.Frame, true, "CTRL-Z", self.Frame.UndoButton:GetName(), "LeftButton")
	end
	if self.redoStack and #self.redoStack > 0 then
		SetOverrideBindingClick(self.Frame, true, "CTRL-Y", self.Frame.RedoButton:GetName(), "LeftButton")
	end
end

function Notepad:_InitializeResizeButton()
	self.Frame.ResizeButton = CreateFrame("Button", nil, self.Frame)
	self.Frame.ResizeButton:SetSize(12, 12)
	self.Frame.ResizeButton:SetPoint("BOTTOMRIGHT")
	self.Frame.ResizeButton:SetNormalTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Up")
	self.Frame.ResizeButton:SetHighlightTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Highlight")
	self.Frame.ResizeButton:SetPushedTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Down")

	self.Frame.ResizeButton:SetScript("OnMouseDown", function(_, button)
		if (not self.isLocked) then
			self.Frame:StartSizing("BOTTOMRIGHT")
			self.Frame:SetUserPlaced(true)
		end
	end)

	self.Frame.ResizeButton:SetScript("OnMouseUp", function(_, button)
		self.Frame:StopMovingOrSizing()
		if self.data and not self.isLocked then
			self:SaveFrameSettings()
		end
	end)

	self.Frame.LockButton = CreateFrame("Button", nil, self.Frame)
	self.Frame.LockButton:SetSize(22, 12)
	self.Frame.LockButton:SetText("lock")
	self.Frame.LockButton:SetPoint("BOTTOMRIGHT", self.Frame, "BOTTOMRIGHT", -16, 4)
	self.Frame.LockButton:SetNormalFontObject("GameFontWhite")
	self.Frame.LockButton:SetAlpha(0.3)
	self.Frame.LockButton:SetScript("OnClick", function ()
		self:ToggleUILock(not self.isLocked)
	end)

	self.Frame.LockButton:SetScript("OnEnter", function()
		self.Frame.LockButton:SetAlpha(0.7)
		GameTooltip:SetOwner(self.Frame.LockButton, "ANCHOR_RIGHT")
		GameTooltip:SetText("Lock or unlock the window")
		GameTooltip:Show()
	end)

	self.Frame.LockButton:SetScript("OnLeave", function()
		self.Frame.LockButton:SetAlpha(0.3)
		GameTooltip:Hide()
	end)

	self:SetHoverControlsVisible(false)
end

function Notepad:SetHoverControlsVisible(visible)
	if not self.Frame or not self.Frame.ResizeButton or not self.Frame.LockButton then
		return
	end
	self.hoverControlsActive = visible
	if visible and not self.isMinimized then
		self.Frame.LockButton:Show()
		if self.isLocked then
			self.Frame.ResizeButton:Hide()
		else
			self.Frame.ResizeButton:Show()
		end
	else
		self.Frame.LockButton:Hide()
		self.Frame.ResizeButton:Hide()
	end
end