function Notepad:RemoveNote(note)
    -- Remove note from saved variables
    for i = #CharNotesDB, 1, -1 do
        if CharNotesDB[i] == note.Text:GetText() then
            table.remove(CharNotesDB, i)
            break
        end
    end

    -- Remove note from table
    for i = #self.notes, 1, -1 do
        if self.notes[i] == note then
            table.remove(self.notes, i)
            break
        end
    end

    note:Hide()
    note:SetParent(nil)

    self:_ReanchorNotes()
end


function Notepad:AddNote(text, save)
    local frame = self.Frame

    if #text < 1 then
        frame.InputField:ClearFocus()
        return
    end

    if save then
        table.insert(CharNotesDB, text)
    end

    local parent = frame.ScrollFrame:GetScrollChild()

    local row = CreateFrame("Frame", nil, parent)
    row:SetHeight(20)

    -- layout
    local last = self.notes[#self.notes]

    if last then
        row:SetPoint("TOPLEFT",  last, "BOTTOMLEFT",  0, -4)
        row:SetPoint("TOPRIGHT", last, "BOTTOMRIGHT", 0, -4)
    else
        row:SetPoint("TOPLEFT",  parent, "TOPLEFT",  0, 0)
        row:SetPoint("TOPRIGHT", parent, "TOPRIGHT", 0, 0)
    end

    -- text
    local fs = row:CreateFontString(nil, "ARTWORK", "GameFontWhite")
    fs:SetPoint("TOPLEFT",  row, "TOPLEFT",  4, -2)
    fs:SetPoint("TOPRIGHT", row, "TOPRIGHT", -4, -2)
    fs:SetJustifyH("LEFT")
    fs:SetJustifyV("TOP")
    fs:SetWordWrap(true)
    fs:SetText(text)

    row.Text = fs

    -- let the row grow with the text
    row:SetHeight(fs:GetStringHeight() + 4)

    frame.InputField:ClearFocus()
    frame.InputField:SetText("")

    table.insert(self.notes, row)

    row:EnableMouse(true)

    row:SetScript("OnEnter", function()
        row:SetAlpha(0.7)
    end)

    row:SetScript("OnLeave", function()
        row:SetAlpha(1)
    end)

    row:SetScript("OnMouseDown", function()
        self:RemoveNote(row)
    end)

    self:_UpdateNotesLayout()
end

function Notepad:_ReanchorNotes()
    local parent = self.Frame.ScrollFrame:GetScrollChild()

    local prev

    for _, note in ipairs(self.notes) do
        note:ClearAllPoints()

        if prev then
            note:SetPoint("TOPLEFT",  prev, "BOTTOMLEFT",  0, -4)
            note:SetPoint("TOPRIGHT", prev, "BOTTOMRIGHT", 0, -4)
        else
            note:SetPoint("TOPLEFT",  parent, "TOPLEFT",  0, 0)
            note:SetPoint("TOPRIGHT", parent, "TOPRIGHT", 0, 0)
        end

        prev = note
    end

    self:_UpdateNotesLayout()
end


function Notepad:_UpdateNotesLayout()
    local child = self.Frame.ScrollFrame:GetScrollChild()

    local last = self.notes[#self.notes]

    if not last then
        child:SetHeight(self.Frame.ScrollFrame:GetHeight())
        return
    end

    local bottom = last:GetBottom()
    local top = child:GetTop()

    if not bottom or not top then return end

    local contentHeight = top - bottom + 4

    child:SetHeight(math.max(contentHeight, self.Frame.ScrollFrame:GetHeight()))
end