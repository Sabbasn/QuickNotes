local SLASH_COMMANDS_DESCRIPTION = {
  { commands = "help",   description = "Shows a list over all available commands." },
  { commands = "clear",  description = "Clears all of the character's notes." },
  { commands = "toggle", description = "Toggles the visibility of the notepad." }
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
