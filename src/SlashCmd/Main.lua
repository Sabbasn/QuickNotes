-- Handles slash commands
function QuickNotes.SlashCmd.Initialize()
  SlashCmdList["QuickNotes"] = QuickNotes.SlashCmd.CommandHandler
  SLASH_QuickNotes1 = "/quicknotes"
  SLASH_QuickNotes2 = "/qn"
end

local SLASH_COMMANDS = {
  ["help"] = QuickNotes.SlashCmd.Help,
  ["toggle"] = QuickNotes.SlashCmd.ToggleVisibility
}

function QuickNotes.SlashCmd.CommandHandler(input)
  if #input == 0 then
    QuickNotes.SlashCmd:Help()
  else
    local handler = SLASH_COMMANDS[input]
    handler()
  end
end

-- if arg == "clear" then
--   table.wipe(CharNotesDB)
--   for _, note in pairs(notes) do
--     note:SetShown(false)
--   end
--   print("|cffffcc00QuickNotes:|r Cleared all notes!")
-- elseif arg == "help" then
--   print("|cffffff00/qn - Toggles the QuickNotes window|r")
--   print("|cffffff00/qn clear - Clears all of the character's notes|r")
-- else
--   if MainFrame:IsShown() then
--     MainFrame:Hide()
--     CharSettings["visible"] = false
--   else
--     MainFrame:Show()
--     CharSettings["visible"] = true
--   end
-- end
