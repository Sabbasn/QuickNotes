function NotepadSettings:_InitializeFrame()
	self.Frame = CreateFrame("Frame", "QN_Settings", UIParent)
	self.Frame:SetSize(340, 290)
	self.Frame:SetPoint("CENTER")
	self.Frame:SetMovable(true)
	self.Frame:EnableMouse(true)
	self.Frame:SetClampedToScreen(true)

	self.Frame.Background = self.Frame:CreateTexture("QN_Settings_Background", "BACKGROUND")
	self.Frame.Background:SetAllPoints()
	self.Frame.Background:SetColorTexture(0.075, 0.055, 0.075, 0.98)

	local function AddEdge(name, point, relativePoint, x, y, width, height, r, g, b, a)
		local edge = self.Frame:CreateTexture(name, "BORDER")
		edge:SetPoint(point, self.Frame, relativePoint, x, y)
		edge:SetSize(width, height)
		edge:SetColorTexture(r, g, b, a)
		return edge
	end

	self.Frame.Header = self.Frame:CreateTexture(nil, "BORDER")
	self.Frame.Header:SetPoint("TOPLEFT", self.Frame, "TOPLEFT", 3, -3)
	self.Frame.Header:SetPoint("TOPRIGHT", self.Frame, "TOPRIGHT", -3, -3)
	self.Frame.Header:SetHeight(38)
	self.Frame.Header:SetColorTexture(0.12, 0.075, 0.035, 0.95)

	local outer = {r = 0.19, g = 0.12, b = 0.055, a = 1}
	local inner = {r = 0.62, g = 0.43, b = 0.17, a = 0.9}
	AddEdge("QN_Settings_OuterTop", "TOPLEFT", "TOPLEFT", 0, 0, 340, 2, outer.r, outer.g, outer.b, outer.a)
	AddEdge("QN_Settings_OuterBottom", "BOTTOMLEFT", "BOTTOMLEFT", 0, 0, 340, 2, outer.r, outer.g, outer.b, outer.a)
	AddEdge("QN_Settings_OuterLeft", "TOPLEFT", "TOPLEFT", 0, 0, 2, 290, outer.r, outer.g, outer.b, outer.a)
	AddEdge("QN_Settings_OuterRight", "TOPRIGHT", "TOPRIGHT", 0, 0, 2, 290, outer.r, outer.g, outer.b, outer.a)
	AddEdge("QN_Settings_InnerTop", "TOPLEFT", "TOPLEFT", 3, -3, 334, 1, inner.r, inner.g, inner.b, inner.a)
	AddEdge("QN_Settings_InnerBottom", "BOTTOMLEFT", "BOTTOMLEFT", 3, 3, 334, 1, inner.r, inner.g, inner.b, inner.a)
	AddEdge("QN_Settings_InnerLeft", "TOPLEFT", "TOPLEFT", 3, -3, 1, 284, inner.r, inner.g, inner.b, inner.a)
	AddEdge("QN_Settings_InnerRight", "TOPRIGHT", "TOPRIGHT", -3, -3, 1, 284, inner.r, inner.g, inner.b, inner.a)

	AddEdge("QN_Settings_HeaderAccent", "TOPLEFT", "TOPLEFT", 3, -40, 334, 1, 0.78, 0.58, 0.22, 0.85)

	self.Frame.Title = self.Frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	self.Frame.Title:SetTextColor(1, 0.82, 0, 1)
	self.Frame.Title:SetPoint("TOP", self.Frame, "TOP", 0, -13)
	self.Frame.Title:SetText("Quick Notes Options")

	local function AddDivider(name, yOffset)
		local divider = self.Frame:CreateTexture(name, "BORDER")
		divider:SetPoint("TOPLEFT", self.Frame, "TOPLEFT", 18, yOffset)
		divider:SetPoint("TOPRIGHT", self.Frame, "TOPRIGHT", -18, yOffset)
		divider:SetHeight(1)
		divider:SetColorTexture(0.48, 0.34, 0.16, 0.7)
		return divider
	end

	AddDivider("QN_Settings_HeaderDivider", -60)

	self.Frame.AppearanceHeading = self.Frame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
	self.Frame.AppearanceHeading:SetTextColor(1, 0.82, 0, 1)
	self.Frame.AppearanceHeading:SetPoint("TOPLEFT", self.Frame, 18, -77)
	self.Frame.AppearanceHeading:SetText("Appearance")

	AddDivider("QN_Settings_DataDivider", -185)

	self.Frame.DataHeading = self.Frame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
	self.Frame.DataHeading:SetTextColor(1, 0.82, 0, 1)
	self.Frame.DataHeading:SetPoint("TOPLEFT", self.Frame, 18, -202)
	self.Frame.DataHeading:SetText("Character data")

	AddDivider("QN_Settings_FooterDivider", -252)

	self.Frame.CloseButton = CreateFrame("Button", "QN_Settings_Close", self.Frame, "UIPanelCloseButton")
	self.Frame.CloseButton:SetPoint("TOPRIGHT", self.Frame, -3, -3)
	self.Frame.CloseButton:SetScript("OnClick", function()
		self:Close()
	end)

	self.Frame:RegisterForDrag("LeftButton")
	self.Frame:SetScript("OnDragStart", function()
		self.Frame:StartMoving()
	end)
	self.Frame:SetScript("OnDragStop", function()
		self.Frame:StopMovingOrSizing()
	end)

	self.Frame:Hide()
end
