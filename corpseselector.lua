local mq = require 'mq'
local imgui = require 'ImGui'
local uihelpers = require('uihelpers')

local selectedCorpse = nil

local function resetState()
  selectedCorpse = nil
end

---@param corpses spawn[]
---@param okText string
---@param selectedCorpseAction fun(zoneShortName?: spawn)
local function renderZoneSelector(corpses, okText, selectedCorpseAction)
  if not imgui.IsPopupOpen("Summon Corpse") then
    imgui.OpenPopup("Summon Corpse")
  end

  if imgui.BeginPopupModal("Summon Corpse", nil, ImGuiWindowFlags.AlwaysAutoResize) then
    imgui.Text("Select a corpse to summon:")
    selectedCorpse = uihelpers.DrawComboBox3("Corpse", selectedCorpse, corpses, function(spawn) if spawn then return spawn.Name() else return "" end end)
    imgui.BeginDisabled(not selectedCorpse or not selectedCorpse())
    if imgui.Button("Target Corpse") then
      mq.cmdf("/mqtarget id %d", selectedCorpse.ID())
    end
    imgui.EndDisabled()

    imgui.SameLine()

    local target = mq.TLO.Target
    imgui.BeginDisabled(not target() or target.Type() ~= "Corpse")
    if imgui.Button(okText) then
      local corpse = corpses[selectedCorpse.key]
      resetState()
      imgui.CloseCurrentPopup()
      selectedCorpseAction(corpse);
    end
    imgui.EndDisabled()

    imgui.SameLine()

    if imgui.Button("Cancel") then
      resetState()
      imgui.CloseCurrentPopup()
      selectedCorpseAction();
    end

    imgui.EndPopup()
  end
end

return renderZoneSelector