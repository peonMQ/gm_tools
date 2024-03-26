local imgui = require 'ImGui'
local mq = require 'mq'
local logger = require 'knightlinc.Write'
local buttons = require 'ui.buttons'
local zoneselector = require('zoneselector')
local corpseselector = require('corpseselector')
local zoneinstanceselector = require('zoneinstanceselector')
local illusionselector = require('illusionselector')
local npc_editor_window = require('ui.npc_editor')
local state = require 'state'
local command_queue = require'application.command_queue'
local cast_spell_command = require'application.commands.cast_spell_command'
local summon_command = require'application.commands.summon_command'
local zone_command = require'application.commands.zone_command'
local zone_instance_command = require'application.commands.zone_instance_command'
local zoneshutdown_command = require'application.commands.zoneshutdown_command'

logger.prefix = string.format("\at%s\ax", "[GM]")
logger.postfix = function () return string.format(" %s", os.date("%X")) end

-- GUI Control variables
local openGUI = true
local terminate = false
local windowFlags = bit32.bor(ImGuiWindowFlags.NoDecoration, ImGuiWindowFlags.NoDocking, ImGuiWindowFlags.AlwaysAutoResize, ImGuiWindowFlags.NoFocusOnAppearing, ImGuiWindowFlags.NoNav)

local function zoneTo(zoneShortName)
  state.ui_State.zone.deactivate(state.ui_State)
  if not zoneShortName then
    return
  elseif not mq.TLO.Zone(zoneShortName).ID() then
    logger.Error("Zone shortname does not exist <%s>", zoneShortName)
  else
    zone_command.Queue(zoneShortName)
  end
end

local function massIllusion(spellId)
  state.ui_State.illusion.deactivate(state.ui_State)
  cast_spell_command.Queue(spellId)
end

local function zoneShutdown(zoneShortName)
  state.ui_State.zoneshutdown.deactivate(state.ui_State)
  zoneshutdown_command.Queue(zoneShortName)
end

local function zoneInstance(selectedInstanceId)
  state.ui_State.zoneinstance.deactivate(state.ui_State)
  zone_instance_command.Queue(selectedInstanceId)
end

local function onCloseCorpsePopup()
  state.ui_State.corpse.deactivate(state.ui_State)
end

local function actionbarUI()
  openGUI = imgui.Begin('GMActions', openGUI, windowFlags)

  buttons.CreateStateButton(state.ui_State.godmode, state.ui_State)
  imgui.SameLine()
  buttons.CreateButton(state.ui_State.kill, buttons.Colors.redButton, state.ui_State)
  imgui.SameLine()
  buttons.CreateButton(state.ui_State.cazictouch, buttons.Colors.redButton, state.ui_State)
  imgui.SameLine()
  buttons.CreateButton(state.ui_State.kick, buttons.Colors.orangeButton, state.ui_State)
  imgui.SameLine()
  buttons.CreateStateButton(state.ui_State.zone, state.ui_State)

  -- newline
  buttons.CreateButton(state.ui_State.buffs, buttons.Colors.blueButton, state.ui_State)
  imgui.SameLine()
  buttons.CreateButton(state.ui_State.petWeapons, buttons.Colors.blueButton, state.ui_State)
  imgui.SameLine()
  buttons.CreateButton(state.ui_State.corpse, buttons.Colors.blueButton, state.ui_State)
  imgui.SameLine()
  buttons.CreateButton(state.ui_State.heal, buttons.Colors.greenButton, state.ui_State)
  imgui.SameLine()
  buttons.CreateButton(state.ui_State.ressurect, buttons.Colors.fuchsiaButton, state.ui_State)
  imgui.SameLine()
  buttons.CreateButton(state.ui_State.illusion, buttons.Colors.fuchsiaButton, state.ui_State)

  -- newline
  buttons.CreateButton(state.ui_State.rq, buttons.Colors.yellowButton, state.ui_State)
  imgui.SameLine()
  buttons.CreateButton(state.ui_State.reloadrules, buttons.Colors.fuchsiaButton, state.ui_State)
  imgui.SameLine()
  buttons.CreateButton(state.ui_State.repop, buttons.Colors.orangeButton, state.ui_State)
  imgui.SameLine()
  buttons.CreateStateButton(state.ui_State.zoneshutdown, state.ui_State)

  --newline
  -- buttons.CreateStateButton(state.ui_State.npceditor, state.ui_State)

  imgui.End()
  if state.ui_State.zone.active then
    zoneselector("Zone", zoneTo)
  end

  if state.ui_State.zoneshutdown.active then
    zoneselector("Zone Shutdown", zoneShutdown)
  end

  if state.ui_State.zoneinstance.active then
    zoneinstanceselector("Zone to Instance", zoneInstance)
  end

  if state.ui_State.corpse.active then
    corpseselector(state.GetplayerCorpses(), onCloseCorpsePopup)
  end

  if state.ui_State.illusion.active then
    illusionselector("Mass Illusion", massIllusion)
  end

  if not openGUI then
      terminate = true
  end
end

npc_editor_window.Init()
mq.imgui.init('ActionBar', actionbarUI)

while not terminate do
  mq.delay(100)
  if not state.ui_State.corpse.active then
    state.setPlayerCorpses(mq.getFilteredSpawns(function(spawn) return spawn.Type() == "Corpse" and spawn.Deity.ID() > 0 end))
  end

  state.ui_State.npceditor.active = npc_editor_window.IsOpen()

  command_queue.Process()
end