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
    info.text = "Notepads"
    info.isTitle = true
    info.notCheckable = true
    UIDropDownMenu_AddButton(info, level)

    for index, notepadData in ipairs(CharacterNotepads.notepads) do
      local selectedNotepad = QuickNotes.Interface.Notepads[index]
      info = UIDropDownMenu_CreateInfo()
      info.text = notepadData.title ~= "" and notepadData.title or ("Notepad " .. index)
      info.checked = notepadData.visible ~= false
      info.isNotRadio = true
      info.keepShownOnClick = true
      info.func = function()
        if selectedNotepad then
          selectedNotepad:SetVisible(not selectedNotepad.visible)
        else
          notepadData.visible = not notepadData.visible
        end
      end
      UIDropDownMenu_AddButton(info, level)
    end

    info = UIDropDownMenu_CreateInfo()
    info.text = "Create Notepad"
    info.notCheckable = true
    info.func = function()
      QuickNotes.Interface.CreateNotepad()
    end
    UIDropDownMenu_AddButton(info, level)

    info = UIDropDownMenu_CreateInfo()
    info.text = "Reset All Notepads' Position and Size"
    info.notCheckable = true
    info.func = function()
      QuickNotes.SlashCmd.ResetPositionAndSize()
    end
    UIDropDownMenu_AddButton(info, level)
  end, "MENU")

  local minimapButton = QuickNotesLDB:NewDataObject("QuickNotes", {
    type = "launcher",
    icon = "Interface\\AddOns\\QuickNotes\\Images\\QuickNotesIcon.tga",
    OnClick = function(self, button)
      if button == "RightButton" then
        ShowMinimapMenu()
      else
        QuickNotes.Interface.ToggleAllNotepads()
      end
    end,
    OnTooltipShow = function(tooltip)
      if not tooltip or not tooltip.AddLine then return end
      tooltip:AddLine("Quick Notes")
    end,
  })

  LDBIcon:Register("QuickNotes", minimapButton, QuickNotesDB)
end
