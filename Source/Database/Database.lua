function QuickNotes.Database.Initialize()
  if CharNotesDB == nil then
    CharNotesDB = {}
  end
  if QuickNotesDB == nil then
    QuickNotesDB = {}
  end
  if CharSettings == nil then
    CharSettings = {
      ["visible"] = true,
      ["minimized"] = true,
      ["frameSize"] = {225, 300}
    }
  end
end
