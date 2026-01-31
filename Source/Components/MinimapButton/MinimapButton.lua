function QuickNotes.Interface.MinimapButton.Initialize()
  local QuickNotesLDB = LibStub("LibDataBroker-1.1", true)
  local LDBIcon = LibStub("LibDBIcon-1.0", true)

  local minimapButton = QuickNotesLDB:NewDataObject("QuickNotes", {
    type = "launcher",
    icon = "Interface\\AddOns\\QuickNotes\\Images\\QuickNotesIcon.tga",
    OnClick = function(self, button)
      if (QuickNotes.Interface.MainFrame.Frame:IsShown()) then
        QuickNotes.Interface.MainFrame.Frame:Hide()
        CharSettings["visible"] = false
      else
        QuickNotes.Interface.MainFrame.Frame:Show()
        CharSettings["visible"] = true
      end
    end,
    OnTooltipShow = function(tooltip)
      if not tooltip or not tooltip.AddLine then return end
      tooltip:AddLine("Quick Notes")
    end,
  })

  LDBIcon:Register("QuickNotes", minimapButton, QuickNotesDB)
end
