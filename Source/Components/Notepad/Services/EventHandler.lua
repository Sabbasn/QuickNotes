function Notepad:_InitializeEventHandler()
    self.Frame:RegisterEvent("ADDON_LOADED")
    self.Frame:RegisterEvent("VARIABLES_LOADED")
    self.Frame:RegisterEvent("PLAYER_UPDATE_RESTING")
    self.Frame:RegisterEvent("PLAYER_STARTED_LOOKING")
    
    self.Frame:SetScript("OnEvent", function(frame, event, arg1)
        if event == "ADDON_LOADED" and arg1 == "QuickNotes" then
            self:OnAddonLoaded()
        elseif event == "VARIABLES_LOADED" then
            self:OnVariablesLoaded()
        elseif event == "PLAYER_UPDATE_RESTING" then
            self:OnPlayerRestingStateChanged()
        elseif event == "PLAYER_STARTED_LOOKING" then
            self:OnPlayerLooking()
        end
    end)
end

function Notepad:OnVariablesLoaded()
    QuickNotes.Database.Initialize()
    for _, noteData in ipairs(CharNotesDB) do
        self:AddNote(noteData)
    end
    self.isLocked = CharSettings["frameLocked"] or false
    self.isMinimized = CharSettings["minimized"] or false
    self:ToggleUILock(self.isLocked)

    self:_InitializeSettings()
end

function Notepad:OnAddonLoaded()
    QuickNotes.SlashCmd.Initialize()
    QuickNotes.Interface.MinimapButton.Initialize()
    print("|cffffcc00QuickNotes|r loaded!")
    if CharSettings["minimized"] then
        self:Minimize()
    end
end

function Notepad:OnPlayerRestingStateChanged()
    if IsResting() and #self.notes > 0 then
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