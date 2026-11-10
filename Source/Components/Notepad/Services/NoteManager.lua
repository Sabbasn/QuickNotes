function Notepad:RemoveNote(note)
    -- Remove note from saved variables
    for i = #self.data.notes, 1, -1 do
        if self.data.notes[i] == note.Text:GetText() then
            table.remove(self.data.notes, i)
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
        table.insert(self.data.notes, text)
    end

    local parent = frame.ScrollFrame:GetScrollChild()

    local row = CreateFrame("Frame", nil, parent)
    row:SetHeight(20)

    -- layout
    local last = self.notes[#self.notes]

    if last then
        row:SetPoint("TOPLEFT",  last, "BOTTOMLEFT",  0, -2)
        row:SetPoint("TOPRIGHT", last, "BOTTOMRIGHT", 0, -2)
    else
        row:SetPoint("TOPLEFT",  parent, "TOPLEFT",  0, 0)
        row:SetPoint("TOPRIGHT", parent, "TOPRIGHT", 0, 0)
    end

    -- text
    local fs = row:CreateFontString(nil, "ARTWORK", "GameFontWhite")
    fs:SetPoint("TOPLEFT",  row, "TOPLEFT",  8, -3)
    fs:SetPoint("TOPRIGHT", row, "TOPRIGHT", -6, -3)
    fs:SetJustifyH("LEFT")
    fs:SetJustifyV("TOP")
    fs:SetWordWrap(true)
    fs:SetFontObject("GameFontHighlightSmall")
    fs:SetText(text)

    row.Text = fs

    row:SetHeight(math.max(22, fs:GetStringHeight() + 6))

    row.Background = row:CreateTexture(nil, "BACKGROUND")
    row.Background:SetAllPoints()
    row.Background:SetColorTexture(0.07, 0.065, 0.06, 0.72)

    row.Accent = row:CreateTexture(nil, "ARTWORK")
    row.Accent:SetPoint("TOPLEFT", row, "TOPLEFT", 0, -3)
    row.Accent:SetPoint("BOTTOMLEFT", row, "BOTTOMLEFT", 0, 3)
    row.Accent:SetWidth(2)
    row.Accent:SetColorTexture(0.56, 0.39, 0.17, 0.65)

    frame.InputField:ClearFocus()
    frame.InputField:SetText("")

    table.insert(self.notes, row)

    row:EnableMouse(true)

    row:SetHyperlinksEnabled(true)

    row:SetScript("OnHyperlinkEnter", function(_, link)
        row:SetAlpha(0.7)
        GameTooltip:SetOwner(row, "ANCHOR_CURSOR_RIGHT")
        GameTooltip:SetHyperlink(link)
        GameTooltip:Show()
    end)

    row:SetScript("OnHyperlinkLeave", function()
        row:SetAlpha(1)
        GameTooltip:Hide()
    end)

    row:SetScript("OnHyperlinkClick", function()
        self:RemoveNote(row)
    end)

    row:SetScript("OnEnter", function()
        row.Background:SetColorTexture(0.12, 0.105, 0.085, 0.9)
        row.Accent:SetColorTexture(0.86, 0.62, 0.25, 1)
    end)

    row:SetScript("OnLeave", function()
        row.Background:SetColorTexture(0.07, 0.065, 0.06, 0.72)
        row.Accent:SetColorTexture(0.56, 0.39, 0.17, 0.65)
        GameTooltip:Hide()
    end)

    row:SetScript("OnMouseDown", function(_, button)
        if button == "LeftButton" then
            self:RemoveNote(row)
        end
    end)

    row:SetScript("OnMouseUp", function(_, button)
        if button == "RightButton" then
            self:ShowContextMenu()
        end
    end)

    self:_UpdateNotesLayout()
end

function Notepad:_ReanchorNotes()
    local parent = self.Frame.ScrollFrame:GetScrollChild()

    local prev

    for _, note in ipairs(self.notes) do
        note:ClearAllPoints()

        if prev then
            note:SetPoint("TOPLEFT",  prev, "BOTTOMLEFT",  0, -2)
            note:SetPoint("TOPRIGHT", prev, "BOTTOMRIGHT", 0, -2)
        else
            note:SetPoint("TOPLEFT",  parent, "TOPLEFT",  0, 0)
            note:SetPoint("TOPRIGHT", parent, "TOPRIGHT", 0, 0)
        end

        prev = note
    end

    self:_UpdateNotesLayout()
end

function Notepad:_UpdateNotesForWidth()
    for _, note in ipairs(self.notes) do
        note:SetHeight(math.max(22, note.Text:GetStringHeight() + 6))
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