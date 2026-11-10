function QuickNotes.Interface.InitializeNotepads(firstNotepad)
    local data = CharacterNotepads.notepads[1]
    QuickNotes.Interface.Notepads = {firstNotepad}
    firstNotepad:LoadData(data)

    for index = 2, #CharacterNotepads.notepads do
        local notepadData = CharacterNotepads.notepads[index]
        local notepad = Notepad.new("Notepad" .. notepadData.id, notepadData)
        table.insert(QuickNotes.Interface.Notepads, notepad)
    end
    QuickNotes.Interface.MainFrame = firstNotepad
end

function QuickNotes.Interface.CreateNotepad()
    local data = QuickNotes.Database.CreateNotepad()
    local notepad = Notepad.new("Notepad" .. data.id, data)
    table.insert(QuickNotes.Interface.Notepads, notepad)
    return notepad
end

function QuickNotes.Interface.ToggleAllNotepads()
    local shouldShowAll = false
    for _, notepad in ipairs(QuickNotes.Interface.Notepads) do
        if notepad.visible then
            shouldShowAll = true
            break
        end
    end

    for _, notepad in ipairs(QuickNotes.Interface.Notepads) do
        notepad:SetVisible(not shouldShowAll)
    end
end

function QuickNotes.Interface.ResetNotepads()
    local notepads = QuickNotes.Interface.Notepads
    local keeper = notepads[1]

    for _, notepad in ipairs(notepads) do
        if notepad.settings and notepad.settings.isOpen then
            notepad.settings:Close()
        end
        if notepad ~= keeper then
            notepad.Frame:Hide()
            notepad.Frame:UnregisterAllEvents()
        end
        for _, note in ipairs(notepad.notes) do
            note:Hide()
            note:SetParent(nil)
        end
        wipe(notepad.notes)
    end

    local data = {
        id = 1,
        title = "",
        notes = {},
        settings = {},
        visible = true,
    }
    CharacterNotepads.notepads = {data}
    QuickNotes.Interface.Notepads = {keeper}
    QuickNotes.Interface.MainFrame = keeper
    keeper:LoadData(data)
end

function Notepad:_InitializeContextMenu()
    self.ContextMenu = CreateFrame("Frame", nil, UIParent, "UIDropDownMenuTemplate")
    UIDropDownMenu_Initialize(self.ContextMenu, function(_, level)
        local info = UIDropDownMenu_CreateInfo()
        info.text = "Rename..."
        info.notCheckable = true
        info.func = function()
            self:PromptRename()
        end
        UIDropDownMenu_AddButton(info, level)

        info = UIDropDownMenu_CreateInfo()
        info.text = "Hide"
        info.notCheckable = true
        info.func = function()
            self:SetVisible(false)
        end
        UIDropDownMenu_AddButton(info, level)

        info = UIDropDownMenu_CreateInfo()
        info.text = "Delete..."
        info.notCheckable = true
        info.disabled = #CharacterNotepads.notepads <= 1
        info.func = function()
            self:PromptDelete()
        end
        UIDropDownMenu_AddButton(info, level)
    end, "MENU")

    self.Frame:SetScript("OnMouseUp", function(_, button)
        if button == "RightButton" then
            self:ShowContextMenu()
        end
    end)

    for _, child in ipairs({
        self.Frame.InputField,
        self.Frame.ScrollFrame,
        self.Frame.ToggleMinimizeButton,
        self.Frame.SettingsButton,
        self.Frame.AddButton,
        self.Frame.ResizeButton,
        self.Frame.LockButton,
    }) do
        child:HookScript("OnMouseUp", function(_, button)
            if button == "RightButton" then
                self:ShowContextMenu()
            end
        end)
    end
end

function Notepad:ShowContextMenu()
    ToggleDropDownMenu(1, nil, self.ContextMenu, "cursor", 0, 0)
end

function Notepad:Rename(title)
    self.data.title = title:match("^%s*(.-)%s*$")
    self.Frame.Title:SetText(self.data.title)
end

function Notepad:PromptRename()
    StaticPopupDialogs["QUICKNOTES_RENAME_NOTEPAD"] = {
        text = "Enter a title for this notepad (leave blank for no title):",
        button1 = ACCEPT,
        button2 = CANCEL,
        hasEditBox = 1,
        maxLetters = 40,
        OnShow = function(dialog)
            dialog.EditBox:SetText(dialog.data.title or "")
            dialog.EditBox:HighlightText()
            dialog.EditBox:SetFocus()
        end,
        OnAccept = function(dialog)
            self:Rename(dialog.EditBox:GetText())
        end,
        EditBoxOnEnterPressed = function(editBox)
            self:Rename(editBox:GetText())
            editBox:GetParent():Hide()
        end,
        EditBoxOnEscapePressed = function(editBox)
            editBox:GetParent():Hide()
        end,
        timeout = 0,
        whileDead = true,
        hideOnEscape = true,
        preferredIndex = 3,
    }

    StaticPopup_Show("QUICKNOTES_RENAME_NOTEPAD", nil, nil, {
        title = self.data.title,
    })
end

function Notepad:PromptDelete()
    if #CharacterNotepads.notepads <= 1 then
        return
    end

    StaticPopupDialogs["QUICKNOTES_DELETE_NOTEPAD"] = {
        text = "Delete this notepad and all of its notes?",
        button1 = DELETE,
        button2 = CANCEL,
        OnAccept = function()
            self:Delete()
        end,
        timeout = 0,
        whileDead = true,
        hideOnEscape = true,
        preferredIndex = 3,
    }
    StaticPopup_Show("QUICKNOTES_DELETE_NOTEPAD")
end

function Notepad:Delete()
    if #CharacterNotepads.notepads <= 1 then
        return
    end

    if self.settings and self.settings.isOpen then
        self.settings:Close()
    end
    self.Frame:Hide()
    self.Frame:UnregisterAllEvents()

    for index, notepad in ipairs(CharacterNotepads.notepads) do
        if notepad == self.data then
            table.remove(CharacterNotepads.notepads, index)
            break
        end
    end
    for index, notepad in ipairs(QuickNotes.Interface.Notepads) do
        if notepad == self then
            table.remove(QuickNotes.Interface.Notepads, index)
            break
        end
    end

    QuickNotes.Interface.MainFrame = QuickNotes.Interface.Notepads[1]
end
