local SLASH_COMMANDS_DESCRIPTION = {
  { commands = "help",   description = "Shows a list over all available commands." },
  { commands = "toggle", description = "Toggles the visibility of the notepad." },
  { commands = "reset", description = "Resets the position and size of the notepad to its default values."}
}

function QuickNotes.SlashCmd.Help()
  for index = 1, #SLASH_COMMANDS_DESCRIPTION do
    local slash = SLASH_COMMANDS_DESCRIPTION[index]
    local helpString = "|cffffff00" .. slash.commands .. " - " .. slash.description .. "|r"
    print(helpString)
  end
end

function QuickNotes.SlashCmd.ToggleVisibility()
  if (QuickNotes.Interface.MainFrame.Frame:IsShown()) then
    QuickNotes.Interface.MainFrame.Frame:Hide()
  else
    QuickNotes.Interface.MainFrame.Frame:Show()
  end
end

function QuickNotes.SlashCmd.ResetPositionAndSize()
  QuickNotes.Interface.MainFrame:Maximize()
  QuickNotes.Interface.MainFrame.Frame:SetSize(225, 300)
  QuickNotes.Interface.MainFrame.Frame:ClearAllPoints()
  QuickNotes.Interface.MainFrame.Frame:SetPoint("CENTER", UIParent, 0, 0)
  CharSettings["frameSize"] = {225, 300}
  CharSettings["minimized"] = false
  print("|cffffcc00QuickNotes:|r The notepad has been reset to its default position and size.")
end