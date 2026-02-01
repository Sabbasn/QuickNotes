function Notepad:_InitializeInputField()
    self.Frame.InputField = CreateFrame("EditBox", nil, self.Frame, "InputBoxTemplate")
    self.Frame.InputField:SetPoint("TOPLEFT", self.Frame, "TOPLEFT", 15, -30)
    self.Frame.InputField:SetPoint("TOPRIGHT", self.Frame, "TOPRIGHT", -50, -30)
    self.Frame.InputField:SetHeight(20)
    self.Frame.InputField:SetHyperlinksEnabled(true)
    self.Frame.InputField:SetAutoFocus(false)
    self.Frame.InputField:SetMaxLetters(120)

    hooksecurefunc("HandleModifiedItemClick", function(link)
        self.Frame.InputField:Insert(link)
    end)

    -- Credit: Fizzlemizz from https://www.wowinterface.com/forums/showthread.php?t=59562
    self.Frame.InputField:SetScript("OnHyperlinkEnter", function(self, link)
        GameTooltip:SetOwner(self, "ANCHOR_CURSOR_RIGHT")
        GameTooltip:SetHyperlink(link)
        GameTooltip:Show()
    end)

    self.Frame.InputField:SetScript("OnHyperlinkLeave", function(self)
        GameTooltip:Hide()
    end)

    -- Hide StackSplitFrame when text changes to prevent it showing when entering hyperlinks
    self.Frame.InputField:SetScript("OnTextChanged", function ()
        StackSplitFrame:Hide()
    end)

    -- Add note by pressing Enter
    self.Frame.InputField:SetScript("OnEnterPressed", function()
        self:AddNote(self.Frame.InputField:GetText(), true)
    end)
end