function Notepad:_InitializeEventHandler()
    self.Frame:RegisterEvent("ADDON_LOADED")
    self.Frame:RegisterEvent("PLAYER_UPDATE_RESTING")
    self.Frame:RegisterEvent("PLAYER_STARTED_LOOKING")
    
    self.Frame:SetScript("OnEvent", function(frame, event, arg1)
        if event == "ADDON_LOADED" and arg1 == "QuickNotes" then
            self:OnAddonLoaded()
        elseif event == "PLAYER_UPDATE_RESTING" then
            self:OnPlayerRestingStateChanged()
        elseif event == "PLAYER_STARTED_LOOKING" then
            self:OnPlayerLooking()
        end
    end)

    -- Mouse Enter
    self.Frame:SetScript("OnEnter", function()
        self.Frame.HighlightBorderAnimGroup:Stop()
        self:SetHoverControlsVisible(true)
        self:SetHistoryBindings(true)
    end)

    -- Mouse Leave
    self.Frame:SetScript("OnLeave", function()
        self:UpdateHistoryBindingsForMouse()
    end)

    self.hoverCheckElapsed = 0
    self.hoverControlsActive = false
    self.Frame:SetScript("OnUpdate", function(frame, elapsed)
        self.hoverCheckElapsed = (self.hoverCheckElapsed or 0) + elapsed
        if self.hoverCheckElapsed < 0.1 then
            return
        end
        self.hoverCheckElapsed = 0

        local isHovered = frame:IsMouseOver()
        if isHovered ~= self.hoverControlsActive then
            self.hoverControlsActive = isHovered
            self:SetHoverControlsVisible(isHovered)
            if isHovered then
                self:SetHistoryBindings(true)
            else
                self:SetHistoryBindings(false)
            end
        end
    end)
end

function Notepad:LoadData(data)
    self.data = data
    self.visible = data.visible ~= false
    self.notes = {}
    self.undoStack = {}
    self.redoStack = {}
    self:_InitializeContextMenu()
    self.Frame.InputField:SetText("")
    for _, noteData in ipairs(self.data.notes) do
        self:AddNote(noteData)
    end
    self:LoadWindowSettings()
    if self.settings then
        self.settings:Reload()
    else
        self:_InitializeSettings()
    end
    if self.visible then
        self.Frame:Show()
    else
        self.Frame:Hide()
    end
end

function Notepad:OnAddonLoaded()
    if QuickNotes.Interface.Initialized then
        return
    end

    QuickNotes.Database.Initialize()
    QuickNotes.SlashCmd.Initialize()
    QuickNotes.Interface.MinimapButton.Initialize()
    QuickNotes.Interface.InitializeNotepads(self)
    QuickNotes.Interface.Initialized = true
    print("|cffffcc00QuickNotes|r loaded!")
end

function Notepad:OnPlayerRestingStateChanged()
    if IsResting() and #self.notes > 0 and self.settings and self.settings.enableHighlight then
        self.Frame.HighlightBorderAnimGroup:Play()
    else
        self.Frame.HighlightBorderAnimGroup:Stop()
    end
end

function Notepad:OnPlayerLooking()
    if self.Frame.InputField then
        self.Frame.InputField:ClearFocus()
    end
end

function Notepad:OnEnter()

end

function Notepad:OnLeave()

end