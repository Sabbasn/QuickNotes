function QuickNotes.Database.Initialize()
  CharNotesDB = CharNotesDB or {}
  QuickNotesDB = QuickNotesDB or {}
  CharSettings = CharSettings or {}

  if type(CharacterNotepads) ~= "table" then
    CharacterNotepads = {}
  end

  if type(CharacterNotepads.notepads) ~= "table" then
    CharacterNotepads.notepads = {}
  end

  if #CharacterNotepads.notepads == 0 then
    CharacterNotepads.notepads[1] = {
      id = 1,
      title = "",
      notes = CharNotesDB,
      settings = CharSettings,
      visible = CharSettings.visible ~= false,
    }
  end

  for index, notepad in ipairs(CharacterNotepads.notepads) do
    notepad.id = notepad.id or index
    notepad.title = notepad.title or ""
    notepad.notes = type(notepad.notes) == "table" and notepad.notes or {}
    notepad.settings = type(notepad.settings) == "table" and notepad.settings or {}
    if notepad.visible == nil then
      notepad.visible = true
    end
    if notepad.settings.framePosition == nil and index > 1 then
      local offset = math.min(index - 1, 8) * 24
      notepad.settings.framePosition = {
        point = "CENTER",
        relativePoint = "CENTER",
        x = offset,
        y = -offset,
      }
    end
  end
end

function QuickNotes.Database.CreateNotepad()
  local highestId = 0
  for _, notepad in ipairs(CharacterNotepads.notepads) do
    if type(notepad.id) == "number" and notepad.id > highestId then
      highestId = notepad.id
    end
  end

  local notepad = {
    id = highestId + 1,
    title = "",
    notes = {},
    settings = {
      framePosition = {
        point = "CENTER",
        relativePoint = "CENTER",
        x = math.min(#CharacterNotepads.notepads, 8) * 24,
        y = -math.min(#CharacterNotepads.notepads, 8) * 24,
      },
    },
    visible = true,
  }
  table.insert(CharacterNotepads.notepads, notepad)
  return notepad
end
