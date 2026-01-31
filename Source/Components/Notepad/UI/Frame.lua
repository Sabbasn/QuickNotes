function Notepad:_InitializeFrame()
    self.Frame = CreateFrame("Frame", "QN_" .. self.name, UIParent)
    self.Frame:SetSize(225, 300)
    self.Frame:SetPoint("CENTER")
    self.Frame:SetMovable(true)
    self.Frame:EnableMouse(true)
    self.Frame:SetResizable(true)
    self.Frame:SetClampedToScreen(true)
    self.Frame:SetResizeBounds(225, 100, 500, 600)

    -- Main Frame Background
    self.Frame.Background = self.Frame:CreateTexture("QN_" .. self.name .. "_Background", "BACKGROUND")
    self.Frame.Background:SetAllPoints()
    self.Frame.Background:SetColorTexture(0, 0, 0, 0.3)

    -- Title
    self.Frame.Title = self.Frame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    self.Frame.Title:SetTextColor(1, 1, 0, 1)
    self.Frame.Title:SetPoint("TOPLEFT", self.Frame, 4, -4)
    self.Frame.Title:SetText("Quick Notes")

    -- Dragging
    self.Frame:RegisterForDrag("LeftButton")
    self.Frame:SetScript("OnDragStart", function ()
        if (not self.isLocked) then
            self.Frame:StartMoving()
        end
    end)
    self.Frame:SetScript("OnDragStop", function ()
        if (not self.isLocked) then
            self.Frame:StopMovingOrSizing()
        end
    end)
end


