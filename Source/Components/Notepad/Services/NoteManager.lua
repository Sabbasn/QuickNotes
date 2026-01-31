-- Removes specified note from the frame
function Notepad:RemoveNote(note)
    note:SetShown(false)
    foreach(CharNotesDB, function(key, value)
        if value == note:GetText() then
            table.remove(CharNotesDB, tonumber(key))
        end
    end)
    local shouldMove = false
    self.yOffsetSurplus = self.yOffsetSurplus - 20
    for _, value in pairs(self.notes) do
        if shouldMove then
            local _, _, _, _, oldY = value:GetPoint(1)
            value:SetPoint("TOPLEFT", self.Frame.ScrollFrame:GetScrollChild(), "TOPLEFT", 0, oldY + 20)
        end
        if value == note then
            shouldMove = true
        end
    end
end

-- Add a note to the frame
function Notepad:AddNote(string, save)
	local notepadFrame = self.Frame
    if #string < 1 then
        self.Frame.InputField:ClearFocus()
        return
     end

    if save then table.insert(CharNotesDB, string) end
    notepadFrame.ScrollFrame:SetClipsChildren(true)
    notepadFrame.NoteField = CreateFrame("Button", nil, notepadFrame.ScrollFrame:GetScrollChild())
    notepadFrame.NoteField:SetPoint("TOPLEFT", notepadFrame.ScrollFrame:GetScrollChild(), 0, 0 - self.yOffsetSurplus)
    self.yOffsetSurplus = self.yOffsetSurplus + 20
    notepadFrame.NoteField:SetText(string)
    notepadFrame.NoteField:SetHyperlinksEnabled(true)
    notepadFrame.NoteField:SetNormalFontObject("GameFontWhite")
    notepadFrame.NoteField:SetSize(225, 30)
    notepadFrame.InputField:ClearFocus()
    notepadFrame.InputField:SetText("")

    local noteField = notepadFrame.NoteField
    table.insert(self.notes, noteField)

     noteField:SetScript("OnHyperlinkClick", function (_)
        self:RemoveNote(noteField)
     end)

    noteField:SetScript("OnHyperlinkEnter", function(note, link)
        note:SetAlpha(0.5)
        GameTooltip:SetOwner(note, "ANCHOR_CURSOR_RIGHT")
        GameTooltip:SetHyperlink(link)
        GameTooltip:Show()
    end)

    noteField:SetScript("OnHyperlinkLeave", function()
        noteField:SetAlpha(1)
        GameTooltip:Hide()
    end)

    noteField:SetScript("OnEnter", function ()
        noteField:SetAlpha(0.5)
    end)

    noteField:SetScript("OnLeave", function ()
        noteField:SetAlpha(1)
    end)

    noteField:SetScript("OnClick", function ()
        self:RemoveNote(noteField)
    end)
end