local minimapMenu

local function ShowMinimapMenu()
  ToggleDropDownMenu(1, nil, minimapMenu, "cursor", 0, 0)
end

function QuickNotes.Interface.MinimapButton.Initialize()
  local QuickNotesLDB = LibStub("LibDataBroker-1.1", true)
  local LDBIcon = LibStub("LibDBIcon-1.0", true)

  minimapMenu = CreateFrame("Frame", "QuickNotesMinimapButtonMenu", UIParent, "UIDropDownMenuTemplate")
  UIDropDownMenu_Initialize(minimapMenu, function(_, level)
    local info = UIDropDownMenu_CreateInfo()

    info.text = "Quick Notes"
    info.isTitle = true
    info.notCheckable = true
    UIDropDownMenu_AddButton(info, level)

    info = UIDropDownMenu_CreateInfo()
    info.text = "Help"
    info.notCheckable = true
    info.func = QuickNotes.SlashCmd.Help
    UIDropDownMenu_AddButton(info, level)

    info = UIDropDownMenu_CreateInfo()
    info.text = "Toggle Notepad"
    info.notCheckable = true
    info.func = QuickNotes.SlashCmd.ToggleVisibility
    UIDropDownMenu_AddButton(info, level)

    info = UIDropDownMenu_CreateInfo()
    info.text = "Reset Position and Size"
    info.notCheckable = true
    info.func = QuickNotes.SlashCmd.ResetPositionAndSize
    UIDropDownMenu_AddButton(info, level)
  end, "MENU")

  local minimapButton = QuickNotesLDB:NewDataObject("QuickNotes", {
    type = "launcher",
    icon = "Interface\\AddOns\\QuickNotes\\Images\\QuickNotesIcon.tga",
    OnClick = function(self, button)
      if button == "RightButton" then
        ShowMinimapMenu()
      else
        if (QuickNotes.Interface.MainFrame.Frame:IsShown()) then
          QuickNotes.Interface.MainFrame.Frame:Hide()
          CharSettings["visible"] = false
        else
          QuickNotes.Interface.MainFrame.Frame:Show()
          CharSettings["visible"] = true
        end
      end
    end,
    OnTooltipShow = function(tooltip)
      if not tooltip or not tooltip.AddLine then return end
      tooltip:AddLine("Quick Notes")
    end,
  })

  LDBIcon:Register("QuickNotes", minimapButton, QuickNotesDB)
end
