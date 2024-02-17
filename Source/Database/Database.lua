function QuickNotes.Database.Initialize()
  if CharNotesDB == nil then
    CharNotesDB = {}
  else
    foreach(CharNotesDB, function(key, value)
      AddNote(value, false)
    end)
  end
  if QuickNotesDB == nil then
    QuickNotesDB = {}
  end
  if CharSettings == nil then
    CharSettings = {
      ["visible"] = true
    }
  end
  if not CharSettings["visible"] then
    QuickNotes.Interface.MainFrame:Hide()
  end
end
