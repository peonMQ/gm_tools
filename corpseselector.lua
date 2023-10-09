local mq = require 'mq'
local imgui = require 'ImGui'
local uihelpers = require('uihelpers')

local EscapeKeyId = 27 -- https://github.com/gallexme/LuaPlugin-GTAV/blob/master/scripts/keys.lua
local selectedCorpse = nil

local function resetState()
  selectedCorpse = nil
end

local function doGMCommand(command)
  mq.cmdf("/say %s", command)
end

---@param corpses spawn[]
---@param okText string
---@param summonTarget fun(doSummon?: boolean)
local function renderZoneSelector(corpses, okText, summonTarget)
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
    local isDisabled = not selectedCorpse or not target() or target.ID() ~= selectedCorpse.ID()
    imgui.BeginDisabled(isDisabled)
    if imgui.Button("Ressurect") then
      doGMCommand("#castspell 994")
    end
    imgui.EndDisabled()
    imgui.SameLine()

    imgui.BeginDisabled(isDisabled)
    if imgui.Button(okText) then
      resetState()
      imgui.CloseCurrentPopup()
      summonTarget(true)
    end
    imgui.EndDisabled()
    imgui.SameLine()

    if imgui.Button("Cancel") or ImGui.IsKeyPressed(EscapeKeyId) then
      resetState()
      imgui.CloseCurrentPopup()
      summonTarget();
    end

    imgui.EndPopup()
  end
end

return renderZoneSelector