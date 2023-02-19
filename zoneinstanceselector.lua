local mq = require 'mq'
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
    imgui.OpenPopup("Zone Instance")
  end

  if imgui.BeginPopupModal("Zone Instance", nil, ImGuiWindowFlags.AlwaysAutoResize) then


    imgui.Text("Instance Id")
    selectedInstanceId, _ = imgui.InputTextWithHint("##instanceid", "id", selectedInstanceId)

    local instanceId = tonumber(selectedInstanceId)
    imgui.BeginDisabled(not selectedInstanceId or not instanceId)
    if imgui.Button(okText) and instanceId then
      selectedInstanceIdAction(instanceId)
    end
    imgui.EndDisabled()

    imgui.SameLine()

    if imgui.Button("Cancel") then
      resetState()
      imgui.CloseCurrentPopup()
    end

    imgui.EndPopup()
  end
end

return renderZoneSelector