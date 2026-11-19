function Notepad:_RecordNoteAction(action)
    self.undoStack = self.undoStack or {}
    self.redoStack = {}
    table.insert(self.undoStack, action)
    self:_UpdateHistoryButtons()
end

function Notepad:_CreateNoteRow(text, index)
    local frame = self.Frame

    local parent = frame.ScrollFrame:GetScrollChild()

    local row = CreateFrame("Frame", nil, parent)
    row:SetHeight(20)

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

    row.Background = row:CreateTexture(nil, "BACKGROUND")
    row.Background:SetAllPoints()

    row.Accent = row:CreateTexture(nil, "ARTWORK")
    row.Accent:SetPoint("TOPLEFT", row, "TOPLEFT", 0, -3)
    row.Accent:SetPoint("BOTTOMLEFT", row, "BOTTOMLEFT", 0, 3)
    row.Accent:SetWidth(2)

    table.insert(self.notes, index, row)
    self:_ReanchorNotes()
    row:SetHeight(math.max(22, fs:GetStringHeight() + 6))
    self:_ReanchorNotes()
    self:ApplyNoteRowColor(row, false)

    row:EnableMouse(true)

    row:SetHyperlinksEnabled(true)
    row:SetScript("OnMouseUp", function(_, button)
        if row.IsEditing then
            return
        end
        if button == "LeftButton" then
            self:RemoveNote(row)
        elseif button == "RightButton" then
            self:ShowNoteContextMenu(row)
        end
    end)

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

    row:SetScript("OnEnter", function()
        row.isHovered = true
        self:ApplyNoteRowColor(row, true)
    end)

    row:SetScript("OnLeave", function()
        row.isHovered = false
        self:ApplyNoteRowColor(row, false)
        GameTooltip:Hide()
    end)

    self:_UpdateHistoryButtons()
    return row
end

function Notepad:ApplyNoteRowColor(row, hovered)
    local color = self.settings and self.settings.currentRowColor
    local r, g, b, a = 0.07, 0.065, 0.06, 0.72
    if color then
        r, g, b, a = color.r or r, color.g or g, color.b or b, color.a or a
    end
    if hovered then
        row.Background:SetColorTexture(math.min(r * 1.7, 1), math.min(g * 1.7, 1), math.min(b * 1.7, 1), math.min(a + 0.18, 1))
        row.Accent:SetColorTexture(0.86, 0.62, 0.25, 1)
    else
        row.Background:SetColorTexture(r, g, b, a)
        row.Accent:SetColorTexture(0.56, 0.39, 0.17, 0.65)
    end
end

function Notepad:ApplyRowColorToNotes()
    for _, row in ipairs(self.notes) do
        self:ApplyNoteRowColor(row, row.isHovered)
    end
end

function Notepad:_RemoveNoteAt(index)
    local row = self.notes[index]
    if not row then
        return nil
    end

    local text = row.Text:GetText()
    table.remove(self.notes, index)
    table.remove(self.data.notes, index)
    row:Hide()
    row:SetParent(nil)
    self:_ReanchorNotes()
    return text
end

function Notepad:RemoveNote(row)
    for index, currentRow in ipairs(self.notes) do
        if currentRow == row then
            local text = row.Text:GetText()
            self:_RemoveNoteAt(index)
            self:_RecordNoteAction({type = "delete", index = index, text = text})
            return
        end
    end
end

function Notepad:AddNote(text, save, index)
    local frame = self.Frame
    if #text < 1 then
        frame.InputField:ClearFocus()
        return
    end

    index = index or (#self.notes + 1)
    if save then
        table.insert(self.data.notes, index, text)
    end
    self:_CreateNoteRow(text, index)

    if save then
        self:_RecordNoteAction({type = "add", index = index, text = text})
    end

    frame.InputField:ClearFocus()
    frame.InputField:SetText("")
end

function Notepad:_SetNoteText(index, text)
    local row = self.notes[index]
    if not row then
        return
    end
    row.Text:SetText(text)
    row:SetHeight(math.max(22, row.Text:GetStringHeight() + 6))
    self.data.notes[index] = text
    self:_ReanchorNotes()
end

function Notepad:EditNote(row, text)
    if #text < 1 then
        print("|cffffcc00QuickNotes:|r Notes cannot be empty.")
        return
    end

    for index, currentRow in ipairs(self.notes) do
        if currentRow == row then
            local oldText = row.Text:GetText()
            if oldText ~= text then
                self:_SetNoteText(index, text)
                self:_RecordNoteAction({
                    type = "edit",
                    index = index,
                    oldText = oldText,
                    newText = text,
                })
            end
            return
        end
    end
end

function Notepad:StartInlineEdit(row)
    if row.IsEditing then
        row.EditBox:SetFocus()
        return
    end

    row.IsEditing = true
    row.Text:Hide()
    row.EditBox = row.EditBox or CreateFrame("EditBox", nil, row, "InputBoxTemplate")
    row.EditBox:ClearAllPoints()
    row.EditBox:SetPoint("TOPLEFT", row, "TOPLEFT", 6, -1)
    row.EditBox:SetPoint("BOTTOMRIGHT", row, "BOTTOMRIGHT", -6, 1)
    row.EditBox:SetAutoFocus(false)
    row.EditBox:SetMultiLine(true)
    row.EditBox:SetMaxLetters(120)
    row.EditBox:SetHyperlinksEnabled(true)
    row.EditBox:SetFontObject("GameFontHighlightSmall")
    row.EditBox:SetText(row.Text:GetText())
    row.EditBox:HighlightText()
    row.EditBox:Show()

    row.EditBox:SetScript("OnEnterPressed", function(editBox)
        editBox:ClearFocus()
    end)

    row.EditBox:SetScript("OnEscapePressed", function(editBox)
        row.IsEditing = false
        editBox:Hide()
        row.Text:Show()
        if self.inlineEditRow == row then
            self.inlineEditRow = nil
        end
        editBox:ClearFocus()
    end)

    row.EditBox:SetScript("OnEditFocusLost", function(editBox)
        if not row.IsEditing then
            return
        end
        local text = editBox:GetText()
        row.IsEditing = false
        editBox:Hide()
        row.Text:Show()
        if self.inlineEditRow == row then
            self.inlineEditRow = nil
        end
        if text ~= "" then
            self:EditNote(row, text)
        end
    end)

    self.inlineEditRow = row
    row.EditBox:SetFocus()
end

function Notepad:UndoNoteAction()
    local action = self.undoStack and table.remove(self.undoStack)
    if not action then
        return
    end

    if action.type == "add" then
        self:_RemoveNoteAt(action.index)
    elseif action.type == "delete" then
        table.insert(self.data.notes, action.index, action.text)
        self:_CreateNoteRow(action.text, action.index)
    elseif action.type == "edit" then
        self:_SetNoteText(action.index, action.oldText)
    end

    table.insert(self.redoStack, action)
    self:_UpdateHistoryButtons()
end

function Notepad:RedoNoteAction()
    local action = self.redoStack and table.remove(self.redoStack)
    if not action then
        return
    end

    if action.type == "add" then
        table.insert(self.data.notes, action.index, action.text)
        self:_CreateNoteRow(action.text, action.index)
    elseif action.type == "delete" then
        self:_RemoveNoteAt(action.index)
    elseif action.type == "edit" then
        self:_SetNoteText(action.index, action.newText)
    end

    table.insert(self.undoStack, action)
    self:_UpdateHistoryButtons()
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