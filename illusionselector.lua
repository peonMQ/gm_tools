local mq = require 'mq'
local imgui = require 'ImGui'

local uihelpers = require('uihelpers')

local EscapeKeyId = 27 -- https://github.com/gallexme/LuaPlugin-GTAV/blob/master/scripts/keys.lua
local illussionSpellIds = {
6563,
6564,
6565,
6566,
6567,
6568,
6569,
6570,
6571,
6572,
6573,
6574,
6575,
6576,
6577,
6578,
6579,
6580,
6581,
6582,
6583,
6584,
6585,
6586,
6587,
6588,
6589,
6590,
6591,
}


---@class IllusionSpell
---@field id number
---@field name string

---@type IllusionSpell[]
local illusionSpells = {}
for _,spellId in ipairs(illussionSpellIds) do
  local mqSpell = mq.TLO.Spell(spellId)
  table.insert(illusionSpells, {name = mqSpell.Name(), id = mqSpell.ID()})
end
table.sort(illusionSpells, function(a,b) return a.name < b.name end)

---@type IllusionSpell | nil
local selectedIllusionSpell = nil


local function resetState()
  selectedIllusionSpell = nil --[[@as IllusionSpell]]
end

local function convertIllusionSpell(illusionSpell)
  if illusionSpell then
    return illusionSpell.name
  end

  return ""
end

---@param okText string
---@param selectedIllusionSpellAction fun(spellId?: number)
local function renderZoneSelector(okText, selectedIllusionSpellAction)
  if not imgui.IsPopupOpen("Select Illusion") then
    imgui.OpenPopup("Select Illusion")
  end

  if imgui.BeginPopupModal("Select Illusion", nil, ImGuiWindowFlags.AlwaysAutoResize) then
    imgui.Text("Select a continent and zone to go to:")

    selectedIllusionSpell = uihelpers.DrawComboBox3("IllusionSpell", selectedIllusionSpell, illusionSpells, convertIllusionSpell)

    imgui.BeginDisabled(not selectedIllusionSpell)
    if imgui.Button(okText) and selectedIllusionSpell then
      local spellId = selectedIllusionSpell.id
      resetState()
      imgui.CloseCurrentPopup()
      selectedIllusionSpellAction(spellId);
    end
    imgui.EndDisabled()

    imgui.SameLine()

    if imgui.Button("Cancel") or ImGui.IsKeyPressed(EscapeKeyId) then
      resetState()
      imgui.CloseCurrentPopup()
      selectedIllusionSpellAction();
    end

    imgui.EndPopup()
  end
end

return renderZoneSelector