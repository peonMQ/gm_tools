--- @type Mq
local mq = require 'mq'

--- @type ImGui
local imgui = require 'ImGui'

local uihelpers = require('uihelpers')

local selectedInstanceId = nil

local function resetState()
  selectedInstanceId = nil
end

---@param okText string
---@param selectedInstanceIdAction fun(selectedInstanceId: number)
local function renderZoneSelector(okText, selectedInstanceIdAction)
  if not imgui.IsPopupOpen("Zone Instance") then
    imgui.OpenPopup("Summon Corpse")
  end

  if imgui.BeginPopupModal("Zone Instance", nil, ImGuiWindowFlags.AlwaysAutoResize) then


    ImGui.Text("Instance Id")
    selectedInstanceId, _ = ImGui.InputTextWithHint("##instanceid", "id", selectedInstanceId)

    local instanceId = tonumber(selectedInstanceId)
    ImGui.BeginDisabled(not selectedInstanceId or not instanceId)
    if imgui.Button(okText) and instanceId then
      selectedInstanceIdAction(instanceId)
    end
    ImGui.EndDisabled()

    imgui.SameLine()

    if imgui.Button("Cancel") then
      resetState()
      imgui.CloseCurrentPopup()
    end

    imgui.EndPopup()
  end
end

return renderZoneSelector