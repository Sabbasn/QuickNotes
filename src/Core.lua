-- Load Databases
MainFrame = CreateFrame("Frame", "QN_MainFrame", UIParent)
MainFrame:RegisterEvent("ADDON_LOADED")

-- Load Databases
MainFrame:SetScript("OnEvent", function(self, event, arg1)
    if event == "ADDON_LOADED" and arg1 == "QuickNotes" then
        print("QuickNotes loaded!")
        if CharNotesDB == nil then
            CharNotesDB = {}
        else
            foreach(CharNotesDB, function (key, value)
                AddNote(value, false)
            end)
        end
        if QuickNotesDB == nil then
            QuickNotesDB = {}
        end
        CreateMinimapButton()
    end
end)

-- Main Frame Background
MainFrame:SetSize(225, 300)
MainFrame:SetPoint("CENTER")
MainFrame.bg = MainFrame:CreateTexture("QN_BackGround", "BACKGROUND")
MainFrame.bg:SetAllPoints(true)
MainFrame.bg:SetColorTexture(0, 0, 0, 0.3)

-- Enable dragging and resizing of main frame
MainFrame:SetMovable(true)
MainFrame:EnableMouse(true)
MainFrame:SetResizable(true)
MainFrame:SetResizeBounds(225, 200, 225, 600)
MainFrame:RegisterForDrag("LeftButton")
MainFrame:SetScript("OnDragStart", MainFrame.StartMoving)
MainFrame:SetScript("OnDragStop", MainFrame.StopMovingOrSizing)

-- Scroll frame
MainFrame.ScrollFrame = CreateFrame("ScrollFrame", nil, MainFrame, "UIPanelScrollFrameTemplate")
MainFrame.ScrollFrame:SetPoint("TOPLEFT", MainFrame, "TOPLEFT", 0, -60)
MainFrame.ScrollFrame:SetPoint("BOTTOMRIGHT", MainFrame, "BOTTOMRIGHT", 0, 15)
MainFrame.ScrollFrame:SetClipsChildren(true)

local child = CreateFrame("Frame", nil, MainFrame.ScrollFrame)
child:SetSize(225, 270)

MainFrame.ScrollFrame:SetScrollChild(child)

-- Title
MainFrame.title = MainFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
MainFrame.title:SetTextColor(1, 1, 0, 1)
MainFrame.title:SetScale(1.25)
MainFrame.title:SetPoint("TOP", MainFrame, 0, -6)
MainFrame.title:SetText("Quick Notes")

-- Player input
MainFrame.inputField = CreateFrame("EditBox", nil, MainFrame, "InputBoxTemplate")
MainFrame.inputField:SetPoint("TOPLEFT", MainFrame, 15, -30)
MainFrame.inputField:SetResizable(true)
local mainFrameWidth = MainFrame:GetWidth()
MainFrame.inputField:SetSize(mainFrameWidth*0.75, 30)
MainFrame.inputField:SetAutoFocus(false)
MainFrame.inputField:SetMaxLetters(40)

local notes = {}
local y_offset_surplus = 0

-- Add a note to the frame
function AddNote(string, save)
    if #string < 1 then return end

    if save then table.insert(CharNotesDB, string) end

    MainFrame.ScrollFrame:SetClipsChildren(true)
    MainFrame.noteField = CreateFrame("Button", nil, child)
    MainFrame.noteField:SetPoint("TOPLEFT", child, 0, 0 - y_offset_surplus)
    y_offset_surplus = y_offset_surplus + 20
    MainFrame.noteField:SetText(string)
    MainFrame.noteField:SetNormalFontObject("GameFontWhite")
    MainFrame.noteField:SetSize(225, 30)
    MainFrame.inputField:ClearFocus()
    MainFrame.inputField:SetText("")

    local noteField = MainFrame.noteField
    table.insert(notes, MainFrame.noteField)

    MainFrame.noteField:SetScript("OnClick", function (self)
        noteField:SetShown(false)
        self:SetShown(false)
        foreach(CharNotesDB, function (key, value)
            if value == noteField:GetText() then
                table.remove(CharNotesDB, tonumber(key))
            end
        end)
        local shouldMove = false
        y_offset_surplus = y_offset_surplus - 20
        table.foreach(notes, function (key, value)
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

-- Add note by pressing Enter
MainFrame.inputField:SetScript("OnEnterPressed", function ()
    AddNote(MainFrame.inputField:GetText(), true)
end)

-- Add button for player input
MainFrame.addBtn = CreateFrame("Button", nil, MainFrame, "GameMenuButtonTemplate")
MainFrame.addBtn:SetPoint("TOPRIGHT", MainFrame, -10, -30)
MainFrame.addBtn:SetSize(30, 30)
MainFrame.addBtn:SetText("+")
MainFrame.addBtn:SetNormalFontObject("GameFontNormalLarge")
MainFrame.addBtn:SetScript("OnClick", function()
    AddNote(MainFrame.inputField:GetText(), true)
end)

-- Handles slash commands
local function commandHandler(arg)
    if arg == "clear" then
        table.wipe(CharNotesDB)
        for _, note in pairs(notes) do
            note:SetShown(false)
        end
        print("|cffffcc00QuickNotes:|r Cleared all notes!")
    else
        MainFrame:Show()
    end
end

SLASH_PHRASE1 = "/qn"
SLASH_PHRASE2 = "/qn clear"
SlashCmdList['PHRASE'] = commandHandler

-----------------------------------------------------------
-- Resize Button
local resizeButton = CreateFrame("Button", nil, MainFrame)
resizeButton:SetSize(16, 16)
resizeButton:SetPoint("BOTTOMRIGHT")
resizeButton:SetNormalTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Up")
resizeButton:SetHighlightTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Highlight")
resizeButton:SetPushedTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Down")
 
resizeButton:SetScript("OnMouseDown", function(self, button)
    MainFrame:StartSizing("BOTTOMRIGHT")
    MainFrame.inputField:StartSizing("BOTTOMRIGHT")
    MainFrame:SetUserPlaced(true)
end)
 
resizeButton:SetScript("OnMouseUp", function(self, button)
    MainFrame.inputField:StopMovingOrSizing()
    MainFrame:StopMovingOrSizing()
end)

-----------------------------------------------------------
-- Create minimap button
function CreateMinimapButton()
    local QuickNotesLDB = LibStub("LibDataBroker-1.1", true)
    local LDBIcon = LibStub("LibDBIcon-1.0", true)

    local minimapButton = QuickNotesLDB:NewDataObject("QuickNotes", {
        type = "launcher",
        icon = "Interface\\AddOns\\QuickNotes\\Images\\QuickNotesIcon.tga",
        OnClick = function(self, button)
            if (MainFrame:IsShown()) then
                MainFrame:Hide()
            else
                MainFrame:Show()
            end
        end,
        OnTooltipShow = function(tooltip)
            if not tooltip or not tooltip.AddLine then return end
            tooltip:AddLine("Quick Notes")
        end,
    })

    LDBIcon:Register("QuickNotes", minimapButton, QuickNotesDB)
end