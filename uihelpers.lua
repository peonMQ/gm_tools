--- @type ImGui
require 'ImGui'
local debugUtils = require 'utils/debug'

local function renderHelpMarker(desc)
    ImGui.TextDisabled('(?)')
    if ImGui.IsItemHovered() then
        ImGui.BeginTooltip()
        ImGui.PushTextWrapPos(ImGui.GetFontSize() * 35.0)
        ImGui.Text(desc)
        ImGui.PopTextWrapPos()
        ImGui.EndTooltip()
    end
end

---@generic T 
---@generic K
---@param label string
---@param resultvar T
---@param options table<T, K>
---@param byKey boolean
---@param helpText string?
---@return T
local function renderComboBox(label, resultvar, options, byKey, helpText)
    ImGui.Text(label)
    ImGui.SameLine()
    if ImGui.BeginCombo("##"..label, resultvar) then
        for i,j in pairs(options) do
            if byKey then
                if ImGui.Selectable(i, i == resultvar) then
                    resultvar = ""..i
                end
            else
                if ImGui.Selectable(j, i == resultvar) then
                    resultvar = ""..i
                end
            end
        end
        ImGui.EndCombo()
    end
    if helpText then
        ImGui.SameLine()
        renderHelpMarker(helpText)
    end
    return resultvar
end

---@generic T 
---@param label string
---@param selectedValue {key: T, value: string}
---@param options table<T, string>
---@param helpText string?
---@return T
local function renderComboBox2(label, selectedValue, options, helpText)
    ImGui.Text(label)
    ImGui.SameLine()
    local selectedText = selectedValue.value
    if ImGui.BeginCombo("##"..label, selectedText) then
        for i,j in pairs(options) do
            if ImGui.Selectable(j, j == selectedText) then
                selectedValue = {key = i, value = j}
            end
        end
        ImGui.EndCombo()
    end
    if helpText then
        ImGui.SameLine()
        renderHelpMarker(helpText)
    end
    return selectedValue
end

---@generic T 
---@param label string
---@param selectedValue T
---@param options T[]
---@param displayText fun(value: T): string
---@param helpText string?
---@return T
local function renderComboBox3(label, selectedValue, options, displayText, helpText)
    ImGui.Text(label)
    ImGui.SameLine()
    local selectedText = displayText(selectedValue)
    if ImGui.BeginCombo("##"..label, selectedText) then
        for _,j in ipairs(options) do
            local valueText = displayText(j)
            if ImGui.Selectable(valueText, valueText == selectedText) then
                selectedValue = j
            end
        end
        ImGui.EndCombo()
    end
    if helpText then
        ImGui.SameLine()
        renderHelpMarker(helpText)
    end
    return selectedValue
end

return {
    DrawComboBox = renderComboBox,
    DrawComboBox2 = renderComboBox2,
    DrawComboBox3 = renderComboBox3
}