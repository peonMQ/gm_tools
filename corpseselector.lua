--- @type Mq
local mq = require 'mq'

--- @type ImGui
local imgui = require 'ImGui'

local uihelpers = require('uihelpers')

local selectedCorpse = {key = 0, value = ""}

local function resetState()
  selectedCorpse = {key = 0, value = ""}
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

    local combospawns = {}
    for index, corpse in ipairs(corpses) do
      combospawns[index] = corpse.Name()
    end

    selectedCorpse = uihelpers.DrawComboBox2("Corpse", selectedCorpse, combospawns, false)


    local corpse = corpses[selectedCorpse.key]
    ImGui.BeginDisabled(not corpse or not corpse())
    if imgui.Button("Target Corpse") then
      mq.cmdf("/mqtarget id %d", corpse.ID())
    end
    ImGui.EndDisabled()

    imgui.SameLine()

    local target = mq.TLO.Target
    ImGui.BeginDisabled(not target() or target.Type() ~= "Corpse")
    if imgui.Button(okText) then
      local corpse = corpses[selectedCorpse.key]
      resetState()
      imgui.CloseCurrentPopup()
      selectedCorpseAction(corpse);
    end
    ImGui.EndDisabled()

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