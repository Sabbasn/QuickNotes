-- Intialize MainFrame
local MainFrame = CreateFrame("Frame", "QN_MainFrame", UIParent)
QuickNotes.Interface.MainFrame = MainFrame
MainFrame:RegisterEvent("ADDON_LOADED")
MainFrame:RegisterEvent("PLAYER_UPDATE_RESTING")
MainFrame:RegisterEvent("PLAYER_STARTED_LOOKING")

-- Initialize Services
MainFrame:SetScript("OnEvent", function(self, event, arg1)
    if event == "ADDON_LOADED" and arg1 == "QuickNotes" then
        QuickNotes.Database.Initialize()
        QuickNotes.SlashCmd.Initialize()
        QuickNotes.Interface.MinimapButton.Initialize()
        print("|cffffcc00QuickNotes|r loaded!")
        if CharSettings["minimized"] then
            MainFrame:Minimize()
        end
    end
    if event == "PLAYER_UPDATE_RESTING" then
        if IsResting() and #CharNotesDB > 0  then
            MainFrame.HighlightBorderAnimGroup:Play()
        else
            MainFrame.HighlightBorderAnimGroup:Stop()
        end
    end
    if event == "PLAYER_STARTED_LOOKING" then
        MainFrame.InputField:ClearFocus()
    end
end)

-- Stop Glow Animation
MainFrame:SetScript("OnEnter", function ()
    MainFrame.HighlightBorderAnimGroup:Stop()
end)

-- Various settings for the MainFrame
MainFrame:SetSize(225, 300)
MainFrame:SetPoint("CENTER")
MainFrame:SetMovable(true)
MainFrame:EnableMouse(true)
MainFrame:SetResizable(true)
MainFrame:SetClampedToScreen(true)
MainFrame:SetResizeBounds(225, 100, 500, 600)
MainFrame:RegisterForDrag("LeftButton")
MainFrame:SetScript("OnDragStart", MainFrame.StartMoving)
MainFrame:SetScript("OnDragStop", MainFrame.StopMovingOrSizing)

-- Main Frame Background
MainFrame.Background = MainFrame:CreateTexture("QN_Background", "BACKGROUND")
MainFrame.Background:SetAllPoints()
MainFrame.Background:SetColorTexture(0, 0, 0, 0.3)
-- MainFrame.Background:SetAtlas("warboard-parchment")

-- Highlight
MainFrame.HighlightBorder = MainFrame:CreateTexture("QN_HighlightBorder", "BORDER", nil)
MainFrame.HighlightBorder:SetAllPoints()
MainFrame.HighlightBorder:SetAtlas("communities-create-avatar-border-selected")
MainFrame.HighlightBorder:SetAlpha(0)
MainFrame.HighlightBorderAnimGroup = MainFrame.HighlightBorder:CreateAnimationGroup()
local HighlightBorderFadeIn = MainFrame.HighlightBorderAnimGroup:CreateAnimation("Alpha")
local HighlightBorderFadeOut = MainFrame.HighlightBorderAnimGroup:CreateAnimation("Alpha")
HighlightBorderFadeIn:SetDuration(1)
HighlightBorderFadeIn:SetFromAlpha(0)
HighlightBorderFadeIn:SetToAlpha(1)
HighlightBorderFadeIn:SetOrder(1)
HighlightBorderFadeOut:SetDuration(1)
HighlightBorderFadeOut:SetFromAlpha(1)
HighlightBorderFadeOut:SetToAlpha(0)
HighlightBorderFadeOut:SetOrder(2)
MainFrame.HighlightBorderAnimGroup:SetLooping("REPEAT")

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
MainFrame.Title:SetPoint("TOPLEFT", MainFrame, 4, -4)
MainFrame.Title:SetText("Quick Notes")

function MainFrame:Minimize()
    local width, height = self:GetSize()
    CharSettings["frameSize"] = {width, height}
    self:SetSize(width, 30)
    self:SetResizable(false)
    self.InputField:Hide()
    self.AddButton:Hide()
    if self.NoteField then
        self.NoteField:Hide()
    end
    self.ScrollFrame:Hide()
    self.ToggleMinimizeButton:SetText("+")
    CharSettings["minimized"] = true
end

function MainFrame:Maximize()
    self:SetResizable(true)
    self.InputField:Show()
    self.AddButton:Show()
    if self.NoteField then
        self.NoteField:Show()
    end
    self.ScrollFrame:Show()
    self.ToggleMinimizeButton:SetText("-")
    if CharSettings["frameSize"] == nil then
        self:SetSize(225, 300)
    else
        self:SetSize(unpack(CharSettings["frameSize"]))
    end
    CharSettings["minimized"] = false
end

function MainFrame.ToggleMinimize()
    if CharSettings["minimized"] == false then
        MainFrame:Minimize()
    else
        MainFrame:Maximize()
    end
end

MainFrame.ToggleMinimizeButton = CreateFrame("Button", nil, MainFrame, "BackdropTemplate")
MainFrame.ToggleMinimizeButton:SetPoint("TOPRIGHT", MainFrame, 0, 0)
MainFrame.ToggleMinimizeButton:SetText("-")
MainFrame.ToggleMinimizeButton:SetSize(30, 30)
MainFrame.ToggleMinimizeButton:SetNormalFontObject("GameFontNormalLarge")
MainFrame.ToggleMinimizeButton:SetScript("OnClick", function ()
    MainFrame.ToggleMinimize()
end)

-- Player input
MainFrame.InputField = CreateFrame("EditBox", nil, MainFrame, "InputBoxTemplate")
MainFrame.InputField:SetPoint("TOPLEFT", MainFrame, "TOPLEFT", 15, -30)
MainFrame.InputField:SetPoint("TOPRIGHT", MainFrame, "TOPRIGHT", -50, -30)
MainFrame.InputField:SetHeight(20)
MainFrame.InputField:SetHyperlinksEnabled(true)
MainFrame.InputField:SetAutoFocus(false)
MainFrame.InputField:SetMaxLetters(40)

-- Credit: Phanx from https://www.wowinterface.com/forums/showthread.php?t=45297
hooksecurefunc("ChatEdit_InsertLink", function(link)
    if MainFrame.InputField:IsVisible() and MainFrame.InputField:HasFocus() then
        MainFrame.InputField:Insert(link)
    end
end)

-- Credit: Fizzlemizz from https://www.wowinterface.com/forums/showthread.php?t=59562
MainFrame.InputField:SetScript("OnHyperlinkEnter", function(self, link)
    GameTooltip:SetOwner(self, "ANCHOR_CURSOR_RIGHT")
    GameTooltip:SetHyperlink(link)
    GameTooltip:Show()
end)

-- Hide StackSplitFrame when text changes to prevent it showing when entering hyperlinks
MainFrame.InputField:SetScript("OnTextChanged", function ()
    StackSplitFrame:Hide()
end)

MainFrame.InputField:SetScript("OnHyperlinkLeave", function(self)
    GameTooltip:Hide()
end)

-- Add note by pressing Enter
MainFrame.InputField:SetScript("OnEnterPressed", function()
    AddNote(MainFrame.InputField:GetText(), true)
end)

local notes = {}
local y_offset_surplus = 0

-- Removes specified note from the frame
function RemoveNote(note)
    note:SetShown(false)
    foreach(CharNotesDB, function(key, value)
        if value == note:GetText() then
            table.remove(CharNotesDB, tonumber(key))
        end
    end)
    local shouldMove = false
    y_offset_surplus = y_offset_surplus - 20
    for _, value in pairs(notes) do
        if shouldMove then
            local _, _, _, _, oldY = value:GetPoint(1)
            value:SetPoint("TOPLEFT", child, "TOPLEFT", 0, oldY + 20)
        end
        if value == note then
            shouldMove = true
        end
    end
end

-- Add a note to the frame
function AddNote(string, save)
    if #string < 1 then
        MainFrame.InputField:ClearFocus()
        return
     end

    if save then table.insert(CharNotesDB, string) end
    MainFrame.ScrollFrame:SetClipsChildren(true)
    MainFrame.NoteField = CreateFrame("Button", nil, child)
    MainFrame.NoteField:SetPoint("TOPLEFT", child, 0, 0 - y_offset_surplus)
    y_offset_surplus = y_offset_surplus + 20
    MainFrame.NoteField:SetText(string)
    MainFrame.NoteField:SetHyperlinksEnabled(true)
    MainFrame.NoteField:SetNormalFontObject("GameFontWhite")
    MainFrame.NoteField:SetSize(225, 30)
    MainFrame.InputField:ClearFocus()
    MainFrame.InputField:SetText("")

    local noteField = MainFrame.NoteField
    table.insert(notes, MainFrame.NoteField)

     noteField:SetScript("OnHyperlinkClick", function (self)
        RemoveNote(self)
     end)

    noteField:SetScript("OnHyperlinkEnter", function(self, link)
        noteField:SetAlpha(0.5)
        GameTooltip:SetOwner(self, "ANCHOR_CURSOR_RIGHT")
        GameTooltip:SetHyperlink(link)
        GameTooltip:Show()
    end)

    noteField:SetScript("OnHyperlinkLeave", function(self)
        noteField:SetAlpha(1)
        GameTooltip:Hide()
    end)

    noteField:SetScript("OnEnter", function (self)
        noteField:SetAlpha(0.5)
    end)

    noteField:SetScript("OnLeave", function ()
        noteField:SetAlpha(1)
    end)

    noteField:SetScript("OnClick", function (self)
        RemoveNote(self)
    end)
end

-- Add button for player input
MainFrame.AddButton = CreateFrame("Button", nil, MainFrame, "GameMenuButtonTemplate")
MainFrame.AddButton:SetPoint("TOPRIGHT", MainFrame, -10, -30)
MainFrame.AddButton:SetSize(30, 21)
MainFrame.AddButton:SetText("+")
MainFrame.AddButton:SetNormalFontObject("GameFontNormalLarge")
MainFrame.AddButton:SetScript("OnClick", function()
    AddNote(MainFrame.InputField:GetText(), true)
end)

-- Resize Button
local resizeButton = CreateFrame("Button", nil, MainFrame)
resizeButton:SetSize(12, 12)
resizeButton:SetPoint("BOTTOMRIGHT")
resizeButton:SetNormalTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Up")
resizeButton:SetHighlightTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Highlight")
resizeButton:SetPushedTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Down")

resizeButton:SetScript("OnMouseDown", function(self, button)
    MainFrame:StartSizing("BOTTOMRIGHT")
    MainFrame:SetUserPlaced(true)
end)

resizeButton:SetScript("OnMouseUp", function(self, button)
    MainFrame:StopMovingOrSizing()
end)
