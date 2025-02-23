local mq = require 'mq'
local imgui = require 'ImGui'
local uihelpers = require 'uihelpers'
local mass_summon_ressurect_command = require'application.commands.mass_summon_ressurect_command'
local summon_command = require'application.commands.summon_command'
local cast_spell_command = require'application.commands.cast_spell_command'

local GM_REZZ_SPELL_ID = 994

---@type PlayerCorpe|nil
local selectedCorpse = nil

local function resetState()
  selectedCorpse = nil
end

---@param corpses PlayerCorpe[]
---@param onClose fun()
local function render(corpses, onClose)
  if not imgui.IsPopupOpen("Summon Corpse") then
    imgui.OpenPopup("Summon Corpse")
  end

  if imgui.BeginPopupModal("Summon Corpse", nil, ImGuiWindowFlags.AlwaysAutoResize) then
    imgui.Text("Select a corpse to summon:")
    selectedCorpse = uihelpers.RenderWithLabel("Corpse", selectedCorpse, corpses, function(spawn) if spawn then return spawn.Name else return "" end end)

    local target = mq.TLO.Target
    if selectedCorpse and (not target() or target.ID() ~= selectedCorpse.Id) then
      mq.cmdf("/mqtarget id %d", selectedCorpse.Id)
    end

    imgui.BeginDisabled(not selectedCorpse)
    if imgui.Button("Summon Corpse") then
      summon_command.Queue(selectedCorpse.Id)
    end
    imgui.EndDisabled()
    imgui.SameLine()

    local isDisabled = not selectedCorpse or not target() or target.ID() ~= selectedCorpse.Id
    imgui.BeginDisabled(isDisabled)
    if imgui.Button("Ressurect") then
      cast_spell_command.Queue(GM_REZZ_SPELL_ID)
    end
    imgui.EndDisabled()
    imgui.SameLine()

    if imgui.Button("Summon & Rezz All Corpses") then
      mass_summon_ressurect_command.Queue(corpses)
    end
    imgui.SameLine()

    if imgui.Button("Cancel") or ImGui.IsKeyPressed(ImGuiKey.Escape) then
      imgui.CloseCurrentPopup()
      resetState()
      onClose()
    end

    imgui.EndPopup()
  end
end

return render