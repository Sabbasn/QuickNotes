-- Creating the main frame
local MainFrame = CreateFrame("Frame", "HN_MainFrame", UIParent)
MainFrame:SetSize(225, 300)
MainFrame:SetPoint("CENTER")
MainFrame:RegisterEvent("ADDON_LOADED")

-- Main Frame Background
MainFrame.bg = MainFrame:CreateTexture("HN_BackGround", "BACKGROUND")
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
MainFrame.title:SetText("Handy Notes")

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

local function AddNote(string, save)
    if #string < 1 then
        return
    end
    if save then
        table.insert(NotesText, string)
    end
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
        foreach(NotesText, function (key, value)
            if value == noteField:GetText() then
                table.remove(NotesText, tonumber(key))
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

-- Load previous notes
MainFrame:SetScript("OnEvent", function (self, event, arg1)
    if event == "ADDON_LOADED" and arg1 == "HandyNotes" then
        print("HandyNotes loaded!")
        if NotesText == nil then
            NotesText = {}
        else
            foreach(NotesText, function (key, value)
                AddNote(value, false)
            end)
        end
    end
end)

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

local function commandHandler(arg)
    if arg == "clear" then
        table.wipe(NotesText)
        print("Cleared all notes!")
    else
        MainFrame:Show()
    end
end

SLASH_PHRASE1 = "/hn"
SLASH_PHRASE2 = "/hn clear"
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
local minibtn = CreateFrame("Button", nil, Minimap)
minibtn:SetFrameLevel(8)
minibtn:SetSize(32,32)
minibtn:SetMovable(true)

minibtn:SetNormalTexture("Interface/COMMON/Indicator-Yellow.png")
minibtn:SetPushedTexture("Interface/COMMON/Indicator-Yellow.png")
minibtn:SetHighlightTexture("Interface/COMMON/Indicator-Yellow.png")

local myIconPos = 0

-- Control movement
local function UpdateMapBtn()
    local Xpoa, Ypoa = GetCursorPosition()
    local Xmin, Ymin = Minimap:GetLeft(), Minimap:GetBottom()
    Xpoa = Xmin - Xpoa / Minimap:GetEffectiveScale() + 70
    Ypoa = Ypoa / Minimap:GetEffectiveScale() - Ymin - 70
    myIconPos = math.deg(math.atan2(Ypoa, Xpoa))
    minibtn:ClearAllPoints()
    minibtn:SetPoint("TOPLEFT", Minimap, "TOPLEFT", 52 - (80 * cos(myIconPos)), (80 * sin(myIconPos)) - 52)
end
 
minibtn:RegisterForDrag("LeftButton")
minibtn:SetScript("OnDragStart", function()
    minibtn:StartMoving()
    minibtn:SetScript("OnUpdate", UpdateMapBtn)
end)
 
minibtn:SetScript("OnDragStop", function()
    minibtn:StopMovingOrSizing();
    minibtn:SetScript("OnUpdate", nil)
    UpdateMapBtn();
end)
 
-- Set position
minibtn:ClearAllPoints();
minibtn:SetPoint("TOPLEFT", Minimap, "TOPLEFT", 52 - (80 * cos(myIconPos)),(80 * sin(myIconPos)) - 52)
 
-- Control clicks
minibtn:SetScript("OnClick", function()
    if MainFrame:IsShown() then
        MainFrame:Hide()
    else
        MainFrame:Show()
    end
end)