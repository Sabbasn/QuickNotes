function QuickNotes.Database.Initialize()
  CharNotesDB = CharNotesDB or {}
  CharacterNotepads = CharacterNotepads or {}
  QuickNotesDB = QuickNotesDB or {}
  if CharSettings == nil then
    CharSettings = {
      ["visible"] = true,
      ["minimized"] = true,
      ["frameLocked"] = false,
    }
  end
end
