function Notepad:_InitializeEventHandler()
    self.Frame:RegisterEvent("ADDON_LOADED")
    self.Frame:RegisterEvent("PLAYER_UPDATE_RESTING")
    self.Frame:RegisterEvent("PLAYER_STARTED_LOOKING")
	self.Frame:RegisterEvent("VARIABLES_LOADED")
    
    self.Frame:SetScript("OnEvent", function(frame, event, arg1)
        if event == "ADDON_LOADED" and arg1 == "QuickNotes" then
            self:OnAddonLoaded()
        elseif event == "PLAYER_UPDATE_RESTING" then
            self:OnPlayerRestingStateChanged()
        elseif event == "PLAYER_STARTED_LOOKING" then
            self:OnPlayerLooking()
		elseif event == "VARIABLES_LOADED" then
			self:OnVariablesLoaded()
        end
    end)
end

function Notepad:OnVariablesLoaded()
	QuickNotes.Database.Initialize()
	for _, note in pairs(CharNotesDB) do
		self:AddNote(note, false)
	end
end

function Notepad:OnAddonLoaded()
    -- QuickNotes.Database.Initialize()
    QuickNotes.SlashCmd.Initialize()
    QuickNotes.Interface.MinimapButton.Initialize()
    print("|cffffcc00QuickNotes|r loaded!")
    if CharSettings["minimized"] then
        self:Minimize()
    end
end

function Notepad:OnPlayerRestingStateChanged()
    if IsResting() and #self.notesDB > 0 then
        self.HighlightBorderAnimGroup:Play()
    else
        self.HighlightBorderAnimGroup:Stop()
    end
end

function Notepad:OnPlayerLooking()
    if self.InputField then
        self.InputField:ClearFocus()
    end
end