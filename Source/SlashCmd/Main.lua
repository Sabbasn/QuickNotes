-- Handles slash commands
function QuickNotes.SlashCmd.Initialize()
  SlashCmdList["QuickNotes"] = QuickNotes.SlashCmd.CommandHandler
  SLASH_QuickNotes1 = "/quicknotes"
  SLASH_QuickNotes2 = "/qn"
end

local SLASH_COMMANDS = {
  ["help"] = QuickNotes.SlashCmd.Help,
  ["toggle"] = QuickNotes.SlashCmd.ToggleVisibility,
  ["reset"] = QuickNotes.SlashCmd.ResetPositionAndSize,
}

function QuickNotes.SlashCmd.CommandHandler(input)
  if #input == 0 then
    QuickNotes.SlashCmd:Help()
  else
    local handler = SLASH_COMMANDS[input]
    if handler == nil then
      print("|cffffcc00QuickNotes:|r '" .. input .. "' is not recognised as a command!")
      return
    end
    handler()
  end
end
