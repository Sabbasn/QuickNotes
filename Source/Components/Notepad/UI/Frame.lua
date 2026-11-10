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
    self.Frame.Background:SetColorTexture(0.055, 0.05, 0.045, 0.78)

    self.Frame.Header = self.Frame:CreateTexture(nil, "BORDER")
    self.Frame.Header:SetPoint("TOPLEFT", self.Frame, "TOPLEFT", 0, 0)
    self.Frame.Header:SetPoint("TOPRIGHT", self.Frame, "TOPRIGHT", 0, 0)
    self.Frame.Header:SetHeight(25)
    self.Frame.Header:SetColorTexture(0.07, 0.065, 0.06, 0.96)

    self.Frame.HeaderDivider = self.Frame:CreateTexture(nil, "BORDER")
    self.Frame.HeaderDivider:SetPoint("TOPLEFT", self.Frame.Header, "BOTTOMLEFT")
    self.Frame.HeaderDivider:SetPoint("TOPRIGHT", self.Frame.Header, "BOTTOMRIGHT")
    self.Frame.HeaderDivider:SetHeight(1)
    self.Frame.HeaderDivider:SetColorTexture(0.52, 0.38, 0.19, 0.65)

    self.Frame.Title = self.Frame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    self.Frame.Title:SetTextColor(0.88, 0.87, 0.82, 1)
    self.Frame.Title:SetPoint("TOPLEFT", self.Frame, 10, -6)
    self.Frame.Title:SetPoint("TOPRIGHT", self.Frame, "TOPRIGHT", -48, -6)
    self.Frame.Title:SetWordWrap(false)
    self.Frame.Title:SetText("")

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
            if self.data then
                self:SaveFrameSettings()
            end
        end
    end)
end
