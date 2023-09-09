-- Creating the main frame
local MainFrame = CreateFrame("Frame", "HN_MainFrame", UIParent, "BasicFrameTemplateWithInset")
MainFrame:SetSize(200, 300)
MainFrame:SetPoint("CENTER")
MainFrame:RegisterEvent("ADDON_LOADED")

-- Enable dragging of main frame
MainFrame:SetMovable(true)
MainFrame:EnableMouse(true)
MainFrame:RegisterForDrag("LeftButton")
MainFrame:SetScript("OnDragStart", MainFrame.StartMoving)
MainFrame:SetScript("OnDragStop", MainFrame.StopMovingOrSizing)

-- Title
MainFrame.title = MainFrame:CreateFontString(nil, "OVERLAY")
MainFrame.title:SetFontObject("GameFontHighlight")
MainFrame.title:SetPoint("LEFT", MainFrame.TitleBg, "LEFT", 5, 0)
MainFrame.title:SetText("Handy Notes")

-- Player input
MainFrame.inputField = CreateFrame("EditBox", nil, MainFrame, "InputBoxTemplate")
MainFrame.inputField:SetPoint("TOPLEFT", MainFrame, 15, -30)
MainFrame.inputField:SetSize(140, 30)
MainFrame.inputField:SetAutoFocus(false)
MainFrame.inputField:SetMaxLetters(20)

local notes = {}
local y_offset_surplus = 0
local deleteButtons = {}

local function AddNote(string, save)
    if save then
        table.insert(NotesText, string)
    end
    MainFrame.noteField = MainFrame:CreateFontString(nil, "OVERLAY")
    MainFrame.noteField:SetJustifyH("LEFT")
    MainFrame.noteField:SetFontObject("GameFontHighlight")
    MainFrame.noteField:SetPoint("CENTER", MainFrame, "TOP", 0, -80 - y_offset_surplus)
    y_offset_surplus = y_offset_surplus + 20
    MainFrame.noteField:SetText(string)
    MainFrame.inputField:ClearFocus()
    MainFrame.inputField:SetText("")
    MainFrame.noteField:SetSize(170, 30)

    local noteField = MainFrame.noteField

    local _, _, _, _, noteY = MainFrame.noteField:GetPoint(1)
    table.insert(notes, MainFrame.noteField)

    MainFrame.noteDeleteBtn = CreateFrame("Button", nil, MainFrame, "GameMenuButtonTemplate")
    MainFrame.noteDeleteBtn:SetPoint("CENTER", MainFrame, "TOP", 75, noteY)
    MainFrame.noteDeleteBtn:SetSize(30, 20)
    MainFrame.noteDeleteBtn:SetText("-")
    MainFrame.noteDeleteBtn:SetNormalFontObject("GameFontNormalLarge")

    table.insert(deleteButtons, MainFrame.noteDeleteBtn)

    MainFrame.noteDeleteBtn:SetScript("OnClick", function (self)
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
                value:SetPoint("CENTER", MainFrame, "TOP", 0, oldY + 20)
                local _, _, _, _, oldY = deleteButtons[key]:GetPoint(1)
                deleteButtons[key]:SetPoint("CENTER", MainFrame, "TOP", 75, oldY + 20)
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


SLASH_PHRASE1 = "/hn"
SlashCmdList['PHRASE'] = function()
    MainFrame:Show()
end

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