local imgui = require 'ImGui'
local debugUtils = require 'utils/debug'

local function renderHelpMarker(desc)
    imgui.TextDisabled('(?)')
    if imgui.IsItemHovered() then
        imgui.BeginTooltip()
        imgui.PushTextWrapPos(imgui.GetFontSize() * 35.0)
        imgui.Text(desc)
        imgui.PopTextWrapPos()
        imgui.EndTooltip()
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
    imgui.Text(label)
    imgui.SameLine()
    if imgui.BeginCombo("##"..label, resultvar) then
        for i,j in pairs(options) do
            if byKey then
                if imgui.Selectable(i, i == resultvar) then
                    resultvar = ""..i
                end
            else
                if imgui.Selectable(j, i == resultvar) then
                    resultvar = ""..i
                end
            end
        end
        imgui.EndCombo()
    end
    if helpText then
        imgui.SameLine()
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
    imgui.Text(label)
    imgui.SameLine()
    local selectedText = selectedValue.value
    if imgui.BeginCombo("##"..label, selectedText) then
        for i,j in pairs(options) do
            if imgui.Selectable(j, j == selectedText) then
                selectedValue = {key = i, value = j}
            end
        end
        imgui.EndCombo()
    end
    if helpText then
        imgui.SameLine()
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
    imgui.Text(label)
    imgui.SameLine()
    local selectedText = displayText(selectedValue)
    if imgui.BeginCombo("##"..label, selectedText, 0) then
        for _,j in ipairs(options) do
            local valueText = displayText(j)
            if imgui.Selectable(valueText, valueText == selectedText) then
                selectedText = displayText(j)
                selectedValue = j
            end
        end
        imgui.EndCombo()
    end
    if helpText then
        imgui.SameLine()
        renderHelpMarker(helpText)
    end
    return selectedValue
end

return {
    DrawComboBox = renderComboBox,
    DrawComboBox2 = renderComboBox2,
    DrawComboBox3 = renderComboBox3
}