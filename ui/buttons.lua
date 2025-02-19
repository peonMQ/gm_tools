local imgui = require 'ImGui'

local buttonSize = ImVec2(30, 30)

local function create(h, s, v)
  local r, g, b = imgui.ColorConvertHSVtoRGB(h / 7.0, s, v)
  return ImVec4(r, g, b, 1)
end

local blueButton = {
  default = create(4, 0.6, 0.6),
  hovered = create(4, 0.7, 0.7),
  active = create(4, 0.8, 0.8),
}

local darkBlueButton = {
  default = create(4.8, 0.6, 0.6),
  hovered = create(4.8, 0.7, 0.7),
  active = create(4.8, 0.8, 0.8),
}

local greenButton = {
  default = create(2, 0.6, 0.6),
  hovered = create(2, 0.7, 0.7),
  active = create(2, 0.8, 0.8),
}

local redButton = {
  default = create(0, 0.6, 0.6),
  hovered = create(0, 0.7, 0.7),
  active = create(0, 0.8, 0.8),
}

local orangeButton = {
  default = create(0.55, 0.6, 0.6),
  hovered = create(0.55, 0.7, 0.7),
  active = create(0.55, 0.8, 0.8),
}

local yellowButton = {
  default = create(1, 0.6, 0.6),
  hovered = create(1, 0.7, 0.7),
  active = create(1, 0.8, 0.8),
}

local fuchsiaButton = {
  default = create(6.4, 0.6, 0.6),
  hovered = create(6.4, 0.7, 0.7),
  active = create(6.4, 0.8, 0.8),
}

local function drawTooltip(text)
  if imgui.IsItemHovered() and text and string.len(text) > 0 then
      imgui.BeginTooltip()
      imgui.PushTextWrapPos(imgui.GetFontSize() * 35.0)
      imgui.Text(text)
      imgui.PopTextWrapPos()
      imgui.EndTooltip()
  end
end

local function createStateButton(state, uiState)
  if not state.active then
    imgui.PushStyleColor(ImGuiCol.Button, blueButton.default)
    imgui.PushStyleColor(ImGuiCol.ButtonHovered, greenButton.hovered)
    imgui.PushStyleColor(ImGuiCol.ButtonActive, greenButton.active)
    local isDisabled = state.isDisabled(uiState)
    imgui.BeginDisabled(isDisabled)
    imgui.Button(state.icon, buttonSize)
    imgui.EndDisabled()
  else
    imgui.PushStyleColor(ImGuiCol.Button, greenButton.default)
    imgui.PushStyleColor(ImGuiCol.ButtonHovered, redButton.hovered)
    imgui.PushStyleColor(ImGuiCol.ButtonActive, redButton.hovered)
    local isDisabled = state.isDisabled(uiState)
    imgui.BeginDisabled(isDisabled)
    if not state.activeIcon then
      imgui.Button(state.icon, buttonSize)
    else
      imgui.Button(state.activeIcon, buttonSize)
    end
    imgui.EndDisabled()
  end

  drawTooltip(state.tooltip)

  if imgui.IsItemClicked(0) then
    if not state.active then
      state.activate(uiState)
    else
      state.deactivate(uiState)
    end
  end

  imgui.PopStyleColor(3)
end

local function createButton(state, buttonColor, uiState)
  imgui.PushStyleColor(ImGuiCol.Button, buttonColor.default)
  imgui.PushStyleColor(ImGuiCol.ButtonHovered, buttonColor.hovered)
  imgui.PushStyleColor(ImGuiCol.ButtonActive, buttonColor.active)

  local isDisabled = state.isDisabled(uiState)
  imgui.BeginDisabled(isDisabled)
  imgui.PushID(state.tooltip)
  imgui.Button(state.icon, buttonSize)
  imgui.PopID()
  imgui.EndDisabled()
  drawTooltip(state.tooltip)
  if not isDisabled and imgui.IsItemClicked(0) then
    state.activate(uiState)
  end

  imgui.PopStyleColor(3)
end

return {
  CreateButton = createButton,
  CreateStateButton = createStateButton,
  Colors =  {
    blueButton = blueButton,
    darkBlueButton = darkBlueButton,
    fuchsiaButton = fuchsiaButton,
    greenButton = greenButton,
    orangeButton = orangeButton,
    redButton = redButton,
    yellowButton = yellowButton
  }
}