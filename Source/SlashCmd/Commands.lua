local SLASH_COMMANDS_DESCRIPTION = {
  { commands = "help",   description = "Shows a list over all available commands." },
  { commands = "toggle", description = "Toggles the visibility of all notepads." },
  { commands = "reset", description = "Resets the position and size of all notepads."}
}

function QuickNotes.SlashCmd.Help()
  for index = 1, #SLASH_COMMANDS_DESCRIPTION do
    local slash = SLASH_COMMANDS_DESCRIPTION[index]
    local helpString = "|cffffff00" .. slash.commands .. " - " .. slash.description .. "|r"
    print(helpString)
  end
end

function QuickNotes.SlashCmd.ToggleVisibility()
  QuickNotes.Interface.ToggleAllNotepads()
end

function QuickNotes.SlashCmd.ResetPositionAndSize()
  for index, notepad in ipairs(QuickNotes.Interface.Notepads) do
    notepad:ResetPositionAndSize()
    if index > 1 then
      local offset = math.min(index - 1, 8) * 24
      notepad.Frame:ClearAllPoints()
      notepad.Frame:SetPoint("CENTER", UIParent, "CENTER", offset, -offset)
      notepad:SaveFrameSettings()
    end
  end
  print("|cffffcc00QuickNotes:|r All notepads have been reset to their default position and size.")
end