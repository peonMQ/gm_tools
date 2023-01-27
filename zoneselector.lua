--- @type ImGui
local imgui = require 'ImGui'

local uihelpers = require('uihelpers')

local selectedContinent = ""
local selectedZone = ""

local function resetState()
  selectedContinent = ""
  selectedZone = ""
end

---@param zones table<Contients, table<string, string>>
---@param okText string
---@param selectedZoneAction fun(zoneShortName?: string)
local function renderZoneSelector(zones, okText, selectedZoneAction)
  if not imgui.IsPopupOpen("Select Zone") then
    imgui.OpenPopup("Select Zone")
  end

  if imgui.BeginPopupModal("Select Zone", nil, ImGuiWindowFlags.AlwaysAutoResize) then
    imgui.Text("Select a continent and zone to go to:")

    selectedContinent = uihelpers.DrawComboBox("Continent", selectedContinent, zones, true)
    if selectedContinent and zones[selectedContinent] then
      selectedZone = uihelpers.DrawComboBox("Zone", selectedZone, zones[selectedContinent], false)
    end

    ImGui.BeginDisabled(not selectedZone)
    if imgui.Button(okText) then
      local zoneShortName = selectedZone
      resetState()
      imgui.CloseCurrentPopup()
      selectedZoneAction(zoneShortName);
    end
    ImGui.EndDisabled()

    imgui.SameLine()

    if imgui.Button("Cancel") then
      resetState()
      imgui.CloseCurrentPopup()
      selectedZoneAction();
    end

    imgui.EndPopup()
  end
end

return renderZoneSelector