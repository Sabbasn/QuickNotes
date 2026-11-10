function Notepad:_InitializeScrollFrame()
	self.Frame.ScrollFrame = CreateFrame("ScrollFrame", nil, self.Frame, "UIPanelScrollFrameTemplate")
	self.Frame.ScrollFrame:SetPoint("TOPLEFT", self.Frame, "TOPLEFT", 10, -60)
	self.Frame.ScrollFrame:SetPoint("BOTTOMRIGHT", self.Frame, "BOTTOMRIGHT", -10, 15)
	self.Frame.ScrollFrame:SetClipsChildren(true)

	local child = CreateFrame("Frame", nil, self.Frame.ScrollFrame)
	child:SetSize(205, 270)

	self.Frame.ScrollFrame:SetScrollChild(child)
	self.Frame.ScrollFrame:SetScript("OnSizeChanged", function(scrollFrame, width)
		local scrollChild = scrollFrame:GetScrollChild()
		scrollChild:SetWidth(width)
		self:_UpdateNotesForWidth()
	end)
end