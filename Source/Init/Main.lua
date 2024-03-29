-- Intialize MainFrame
local MainFrame = CreateFrame("Frame", "QN_MainFrame", UIParent)
QuickNotes.Interface.MainFrame = MainFrame
MainFrame:RegisterEvent("ADDON_LOADED")

-- Initialize Services
MainFrame:SetScript("OnEvent", function(self, event, arg1)
    if event == "ADDON_LOADED" and arg1 == "QuickNotes" then
        QuickNotes.Database.Initialize()
        QuickNotes.SlashCmd.Initialize()
        QuickNotes.Interface.MinimapButton.Initialize()
        print("|cffffcc00QuickNotes|r loaded!")
    end
end)

-- Various settings for the MainFrame
MainFrame:SetSize(225, 300)
MainFrame:SetPoint("CENTER")
MainFrame:SetMovable(true)
MainFrame:EnableMouse(true)
MainFrame:SetResizable(true)
MainFrame:SetClampedToScreen(true)
MainFrame:SetResizeBounds(225, 200, 225, 600)
MainFrame:RegisterForDrag("LeftButton")
MainFrame:SetScript("OnDragStart", MainFrame.StartMoving)
MainFrame:SetScript("OnDragStop", MainFrame.StopMovingOrSizing)

-- Main Frame Background
MainFrame.Background = MainFrame:CreateTexture("QN_Background", "BACKGROUND")
MainFrame.Background:SetAllPoints(true)
MainFrame.Background:SetColorTexture(0, 0, 0, 0.3)

-- Scroll frame
MainFrame.ScrollFrame = CreateFrame("ScrollFrame", nil, MainFrame, "UIPanelScrollFrameTemplate")
MainFrame.ScrollFrame:SetPoint("TOPLEFT", MainFrame, "TOPLEFT", 0, -60)
MainFrame.ScrollFrame:SetPoint("BOTTOMRIGHT", MainFrame, "BOTTOMRIGHT", 0, 15)
MainFrame.ScrollFrame:SetClipsChildren(true)

local child = CreateFrame("Frame", nil, MainFrame.ScrollFrame)
child:SetSize(225, 270)

MainFrame.ScrollFrame:SetScrollChild(child)

-- Title
MainFrame.Title = MainFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
MainFrame.Title:SetTextColor(1, 1, 0, 1)
MainFrame.Title:SetScale(1.25)
MainFrame.Title:SetPoint("TOP", MainFrame, 0, -6)
MainFrame.Title:SetText("Quick Notes")

-- Player input
MainFrame.InputField = CreateFrame("EditBox", nil, MainFrame, "InputBoxTemplate")
MainFrame.InputField:SetPoint("TOPLEFT", MainFrame, 15, -30)
MainFrame.InputField:SetResizable(true)
local mainFrameWidth = MainFrame:GetWidth()
MainFrame.InputField:SetSize(mainFrameWidth * 0.75, 30)
MainFrame.InputField:SetAutoFocus(false)
MainFrame.InputField:SetMaxLetters(40)

-- Add note by pressing Enter
MainFrame.InputField:SetScript("OnEnterPressed", function()
    AddNote(MainFrame.InputField:GetText(), true)
end)

local notes = {}
local y_offset_surplus = 0

-- Add a note to the frame
function AddNote(string, save)
    if #string < 1 then return end

    if save then table.insert(CharNotesDB, string) end

    MainFrame.ScrollFrame:SetClipsChildren(true)
    MainFrame.NoteField = CreateFrame("Button", nil, child)
    MainFrame.NoteField:SetPoint("TOPLEFT", child, 0, 0 - y_offset_surplus)
    y_offset_surplus = y_offset_surplus + 20
    MainFrame.NoteField:SetText(string)
    MainFrame.NoteField:SetNormalFontObject("GameFontWhite")
    MainFrame.NoteField:SetSize(225, 30)
    MainFrame.InputField:ClearFocus()
    MainFrame.InputField:SetText("")

    local noteField = MainFrame.NoteField
    table.insert(notes, MainFrame.NoteField)

    MainFrame.NoteField:SetScript("OnClick", function(self)
        noteField:SetShown(false)
        self:SetShown(false)
        foreach(CharNotesDB, function(key, value)
            if value == noteField:GetText() then
                table.remove(CharNotesDB, tonumber(key))
            end
        end)
        local shouldMove = false
        y_offset_surplus = y_offset_surplus - 20
        table.foreach(notes, function(key, value)
            if shouldMove then
                local _, _, _, _, oldY = value:GetPoint(1)
                value:SetPoint("TOPLEFT", child, "TOPLEFT", 0, oldY + 20)
            end
            if value == noteField then
                shouldMove = true
            end
        end)
    end)
end

-- Add button for player input
MainFrame.AddButton = CreateFrame("Button", nil, MainFrame, "GameMenuButtonTemplate")
MainFrame.AddButton:SetPoint("TOPRIGHT", MainFrame, -10, -30)
MainFrame.AddButton:SetSize(30, 30)
MainFrame.AddButton:SetText("+")
MainFrame.AddButton:SetNormalFontObject("GameFontNormalLarge")
MainFrame.AddButton:SetScript("OnClick", function()
    AddNote(MainFrame.InputField:GetText(), true)
end)

-- Resize Button
local resizeButton = CreateFrame("Button", nil, MainFrame)
resizeButton:SetSize(16, 16)
resizeButton:SetPoint("BOTTOMRIGHT")
resizeButton:SetNormalTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Up")
resizeButton:SetHighlightTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Highlight")
resizeButton:SetPushedTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Down")

resizeButton:SetScript("OnMouseDown", function(self, button)
    MainFrame:StartSizing("BOTTOMRIGHT")
    MainFrame.InputField:StartSizing("BOTTOMRIGHT")
    MainFrame:SetUserPlaced(true)
end)

resizeButton:SetScript("OnMouseUp", function(self, button)
    MainFrame.InputField:StopMovingOrSizing()
    MainFrame:StopMovingOrSizing()
end)
