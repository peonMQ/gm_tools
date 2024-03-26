local imgui = require 'ImGui'
local mq = require 'mq'
local create_spawn_command = require'application.commands.create_spawn_command'
local find_npc_command = require'application.commands.find_npc_command'
local spawn_npc_command = require'application.commands.spawn_npc_command'

local _open, _showUI = false, true

local npc_id = ""
local npc_query = ""

local function drawTooltip(text)
  if imgui.IsItemHovered() and text and string.len(text) > 0 then
      imgui.BeginTooltip()
      imgui.PushTextWrapPos(imgui.GetFontSize() * 35.0)
      imgui.Text(text)
      imgui.PopTextWrapPos()
      imgui.EndTooltip()
  end
end

local function renderSettingsWindow()
  if imgui.BeginTabBar("NPCEDITORTAB##", ImGuiTabBarFlags.None) then
    if imgui.BeginTabItem("NPC") then
      imgui.Text('Find NPC')
      imgui.PushItemWidth(200)
      npc_query = imgui.InputText("##NPCQUERY", npc_query)
      imgui.PopItemWidth()
      imgui.SameLine()

      if imgui.Button("Find") then
        find_npc_command.Queue(npc_query)
      end

      imgui.Text('NPC Id')
      imgui.PushItemWidth(200)
      local newNpcId, changed = imgui.InputText("##NPCID", npc_id)
      if changed and newNpcId ~= "" and tonumber(newNpcId) then -- Check for empty string and if the entered string passes a numerical conversion
        npc_id = ""..tonumber(newNpcId)
      end
      imgui.PopItemWidth()

      imgui.SameLine()
      if imgui.Button("Spawn") then
        spawn_npc_command.Queue(npc_id)
      end
      drawTooltip("Spawn NPC at current location")

      local targetName = mq.TLO.Target.Name() or ""
      imgui.SameLine()
      imgui.BeginDisabled(targetName == "")
      if imgui.Button("Create") then
        create_spawn_command.Queue()
      end
      imgui.EndDisabled()
      drawTooltip(string.format("Create spawnpoint for '%s' at current location", targetName))

      imgui.EndTabItem()
    end
    if imgui.BeginTabItem("Grid") then
      imgui.EndTabItem()
    end
    imgui.EndTabBar()
  end
end

local function init()
  local function npc_editor_window()
      if _open then
          _open, _showUI = imgui.Begin('NPC Editor', _open)
          imgui.SetWindowSize(500, 200, ImGuiCond.FirstUseEver)
          if _showUI then
              renderSettingsWindow()
          end
          imgui.End()
      end
  end

  mq.imgui.init('npceditorwindow', npc_editor_window)
end
 
return {
  Init = init,
  IsOpen = function() return _open end,
  Open = function() _open = true end,
  Close = function() _open = false end
}