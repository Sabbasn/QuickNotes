function Notepad:_InitializeScrollFrame()
	self.Frame.ScrollFrame = CreateFrame("ScrollFrame", nil, self.Frame, "UIPanelScrollFrameTemplate")
	self.Frame.ScrollFrame:SetPoint("TOPLEFT", self.Frame, "TOPLEFT", 0, -60)
	self.Frame.ScrollFrame:SetPoint("BOTTOMRIGHT", self.Frame, "BOTTOMRIGHT", 0, 15)
	self.Frame.ScrollFrame:SetClipsChildren(true)

	local child = CreateFrame("Frame", nil, self.Frame.ScrollFrame)
	child:SetSize(225, 270)

	self.Frame.ScrollFrame:SetScrollChild(child)
end