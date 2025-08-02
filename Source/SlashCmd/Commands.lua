local SLASH_COMMANDS_DESCRIPTION = {
  { commands = "help",   description = "Shows a list over all available commands." },
  { commands = "toggle", description = "Toggles the visibility of the notepad." },
  { commands = "reset", description = "Resets the size of the notepad to its default size."}
}

function QuickNotes.SlashCmd.Help()
  for index = 1, #SLASH_COMMANDS_DESCRIPTION do
    local slash = SLASH_COMMANDS_DESCRIPTION[index]
    local helpString = "|cffffff00" .. slash.commands .. " - " .. slash.description .. "|r"
    print(helpString)
  end
end

function QuickNotes.SlashCmd.ToggleVisibility()
  if (QuickNotes.Interface.MainFrame:IsShown()) then
    QuickNotes.Interface.MainFrame:Hide()
  else
    QuickNotes.Interface.MainFrame:Show()
  end
end

function QuickNotes.SlashCmd.ResetSize()
  QuickNotes.Interface.MainFrame:SetSize(225, 300)
  CharSettings["frameSize"] = {225, 300}
  print("|cffffcc00QuickNotes:|r The notepad has been reset to its default size.")
end