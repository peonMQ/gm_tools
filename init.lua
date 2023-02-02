--- @type ImGui
require 'ImGui'

--- @type Mq
local mq = require 'mq'

---@type Icons
local icons = require 'mq/icons'
local logger = require 'utils/logging'
local debugUtils = require 'utils/debug'
local plugins = require('utils/plugins')
local broadCastInterfaceFactory = require('broadcast/broadcastinterface')

local bci = broadCastInterfaceFactory()
if not bci then
  logger.Fatal("No networking interface found, please start eqbc or dannet")
  return
end

local zones = require('zones')
local zoneselector = require('zoneselector')
local corpseselector = require('corpseselector')
local zoneinstanceselector = require('zoneinstanceselector')


-- local classes
---@class ActionButton
---@field public active boolean
---@field public icon string
---@field public activeIcon? string
---@field public tooltip string
---@field public isDisabled fun(state:ActionButtons):boolean
---@field public activate fun(state:ActionButtons)
---@field public deactivate? fun(state:ActionButtons)


---@class ActionButtons
---@field public buffs ActionButton
---@field public cazictouch ActionButton
---@field public corpse ActionButton
---@field public godmode ActionButton
---@field public heal ActionButton
---@field public kick ActionButton
---@field public kill ActionButton
---@field public ressurect ActionButton
---@field public rq ActionButton
---@field public summon ActionButton
---@field public zone ActionButton
---@field public zoneinstance ActionButton
---@field public zoneshutdown ActionButton

-- GUI Control variables
local openGUI = true
local terminate = false
local buttonSize = ImVec2(30, 30)
local windowFlags = bit32.bor(ImGuiWindowFlags.NoDecoration, ImGuiWindowFlags.NoDocking, ImGuiWindowFlags.AlwaysAutoResize, ImGuiWindowFlags.NoFocusOnAppearing, ImGuiWindowFlags.NoNav)

local playerCorpses = {}

local function create(h, s, v)
  local r, g, b = ImGui.ColorConvertHSVtoRGB(h / 7.0, s, v)
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


local function doGMCommand(command)
  mq.cmdf("/say %s", command)
end

---@type ActionButton
local buffs = {
  active = false,
  icon = icons.FA_MAGIC, -- MD_ANDRIOD
  tooltip = "Buff target",
  isDisabled = function (state) return not mq.TLO.Target() end,
  activate = function(state)
    doGMCommand("#castspell 2680")
    doGMCommand("#castspell 2681")
    doGMCommand("#castspell 2682")
    doGMCommand("#castspell 2691")
    doGMCommand("#castspell 2692")
    doGMCommand("#castspell 2693")
    doGMCommand("#castspell 2695")
    doGMCommand("#castspell 2696")
    doGMCommand("#castspell 3023")
    doGMCommand("#castspell 3028")
  end
}

---@type ActionButton
local cazictouch = {
  active = false,
  icon = icons.FA_MAGIC, -- MD_ANDRIOD
  tooltip = "Cazic Touch target",
  isDisabled = function (state) return not mq.TLO.Me.GM() or not mq.TLO.Target() end,
  activate = function(state)
    doGMCommand("#castspell 7477")
  end
}

---@type ActionButton
local corpse = {
  active = false,
  icon = icons.MD_AIRLINE_SEAT_FLAT, -- MD_ANDRIOD
  tooltip = "Corpse",
  isDisabled = function (state) return not mq.TLO.Me.GM() end,
  activate = function(state)
    playerCorpses = mq.getFilteredSpawns(function(spawn) return spawn.Type() == "Corpse" and spawn.Deity.ID() > 0 end)
    state.corpse.active = true
  end,
  deactivate = function(state)
    playerCorpses = {}
    state.corpse.active = false
  end,
}

---@type ActionButton
local godmode = {
  active = false,
  icon = icons.MD_ANDROID,
  tooltip = "God mode",
  isDisabled = function (state)
    return not mq.TLO.Me.GM()
  end,
  activate = function(state)
    state.godmode.active = true
    doGMCommand("#godmode on")
  end,
  deactivate = function(state)
    state.godmode.active = false
    doGMCommand("#godmode off")
  end,
}
---@type ActionButton
local heal = {
  active = false,
  icon = icons.MD_HEALING, -- MD_ANDRIOD
  tooltip = "Heal target",
  isDisabled = function (state)
    local target = mq.TLO.Target
    return not mq.TLO.Me.GM() or not target() or target.Type() == "Corpse"
  end,
  activate = function(state)
    doGMCommand("#heal")
  end
}

---@type ActionButton
local kick = {
  active = false,
  icon = icons.FA_MINUS_SQUARE, -- MD_ANDRIOD
  tooltip = "Kick target",
  isDisabled = function (state) return not mq.TLO.Me.GM() or not mq.TLO.Target() end,
  activate = function(state)
    doGMCommand("#kick")
  end
}

---@type ActionButton
local kill = {
  active = false,
  icon = icons.FA_MINUS_CIRCLE, -- MD_ANDRIOD
  tooltip = "Kill target",
  isDisabled = function (state) return not mq.TLO.Me.GM() or not mq.TLO.Target() end,
  activate = function(state)
    doGMCommand("#kill")
  end
}
---@type ActionButton
local ressurect = {
  active = false,
  icon = icons.MD_HEALING, -- MD_ANDRIOD
  tooltip = "Ressurect target",
  isDisabled = function (state)
    local target = mq.TLO.Target
    return not mq.TLO.Me.GM() or not target() or target.Type() ~= "Corpse"
  end,
  activate = function(state)
    doGMCommand("#castspell 994")
  end
}

---@type ActionButton
local rq = {
  active = false,
  icon = icons.MD_REFRESH, -- MD_ANDRIOD
  tooltip = "Reload quests",
  isDisabled = function (state) return not mq.TLO.Me.GM() end,
  activate = function(state)
    doGMCommand("#rq")
  end
}

---@type ActionButton
local summon = {
  active = false,
  icon = icons.MD_PLAY_ARROW, -- MD_ANDRIOD
  tooltip = "Summon target",
  isDisabled = function (state) return not mq.TLO.Me.GM() or not mq.TLO.Target() end,
  activate = function(state)
    doGMCommand("#summon")
  end
}

---@type ActionButton
local togglezone = {
  active = false,
  icon = icons.FA_PAPER_PLANE,
  tooltip = "Zone",
  isDisabled = function (state) return not mq.TLO.Me.GM() end,
  activate = function(state)
    state.zone.active = true
  end,
  deactivate = function(state)
    state.zone.active = false
  end,
}

---@type ActionButton
local zoneinstance = {
  active = false,
  icon = icons.FA_PAPER_PLANE,
  tooltip = "Zone Instance",
  isDisabled = function (state) return not mq.TLO.Me.GM() end,
  activate = function(state)
    state.zoneinstance.active = true
  end,
  deactivate = function(state)
    state.zoneinstance.active = false
  end,
}

---@type ActionButton
local zoneshutdown = {
  active = false,
  icon = icons.FA_POWER_OFF,
  tooltip = "Shutdown zone",
  isDisabled = function (state) return not mq.TLO.Me.GM() end,
  activate = function(state)
    state.zoneshutdown.active = true
  end,
  deactivate = function(state)
    state.zoneshutdown.active = false
  end,
}

---@type ActionButtons
local uiState = {
  buffs = buffs,
  cazictouch = cazictouch,
  corpse = corpse,
  godmode = godmode,
  heal = heal,
  kick = kick,
  kill = kill,
  ressurect = ressurect,
  rq = rq,
  summon = summon,
  zone = togglezone,
  zoneinstance = zoneinstance,
  zoneshutdown = zoneshutdown,
}

local function zoneTo(zoneShortName)
  uiState.zone.deactivate(uiState)
  if not zoneShortName then
    return
  elseif not mq.TLO.Zone(zoneShortName).ID() then
    logger.Error("Zone shortname does not exist <%s>", zoneShortName)
  else
    doGMCommand(string.format("#zone %s", zoneShortName))
  end
end

local function zoneShutdown(zoneShortName)
  uiState.zoneshutdown.deactivate(uiState)
  if not zoneShortName then
    return
  elseif not mq.TLO.Zone(zoneShortName).ID() then
    logger.Error("Zone shortname does not exist <%s>", zoneShortName)
  elseif zoneShortName == mq.TLO.Zone.ShortName() then
    logger.Error("Teleport to a different zone before trying to shutdown <%s>", zoneShortName)
  else
    doGMCommand(string.format("#zone %s", zoneShortName))
  end
end

---@param corpseSpawn spawn
local function summonCorpse(corpseSpawn)
  uiState.corpse.deactivate(uiState)
  if not corpseSpawn or not corpseSpawn() then
    return
  end

  doGMCommand("#summon")
end

local function DrawTooltip(text)
  if ImGui.IsItemHovered() and text and string.len(text) > 0 then
      ImGui.BeginTooltip()
      ImGui.PushTextWrapPos(ImGui.GetFontSize() * 35.0)
      ImGui.Text(text)
      ImGui.PopTextWrapPos()
      ImGui.EndTooltip()
  end
end

local function createStateButton(state)
  if not state.active then
    ImGui.PushStyleColor(ImGuiCol.Button, blueButton.default)
    ImGui.PushStyleColor(ImGuiCol.ButtonHovered, greenButton.hovered)
    ImGui.PushStyleColor(ImGuiCol.ButtonActive, greenButton.active)
    local isDisabled = state.isDisabled(uiState)
    ImGui.BeginDisabled(isDisabled)
    ImGui.Button(state.icon, buttonSize)
    ImGui.EndDisabled()
  else
    ImGui.PushStyleColor(ImGuiCol.Button, greenButton.default)
    ImGui.PushStyleColor(ImGuiCol.ButtonHovered, redButton.hovered)
    ImGui.PushStyleColor(ImGuiCol.ButtonActive, redButton.hovered)
    local isDisabled = state.isDisabled(uiState)
    ImGui.BeginDisabled(isDisabled)
    if not state.activeIcon then
      ImGui.Button(state.icon, buttonSize)
    else
      ImGui.Button(state.activeIcon, buttonSize)
    end
    ImGui.EndDisabled()
  end

  DrawTooltip(state.tooltip)

  if ImGui.IsItemClicked(0) then
    if not state.active then
      state.activate(uiState)
    else
      state.deactivate(uiState)
    end
  end

  ImGui.PopStyleColor(3)
end

local function createButton(state, buttonColor)
  ImGui.PushStyleColor(ImGuiCol.Button, buttonColor.default)
  ImGui.PushStyleColor(ImGuiCol.ButtonHovered, buttonColor.hovered)
  ImGui.PushStyleColor(ImGuiCol.ButtonActive, buttonColor.active)

  local isDisabled = state.isDisabled(uiState)
  ImGui.BeginDisabled(isDisabled)
  ImGui.Button(state.icon, buttonSize)
  ImGui.EndDisabled()
  DrawTooltip(state.tooltip)
  if not isDisabled and ImGui.IsItemClicked(0) then
    state.activate(uiState)
  end

  ImGui.PopStyleColor(3)
end

local function actionbarUI()
  openGUI = ImGui.Begin('Actions', openGUI, windowFlags)

  createStateButton(uiState.godmode)
  ImGui.SameLine()
  createButton(uiState.rq, yellowButton)
  ImGui.SameLine()
  createButton(uiState.buffs, blueButton)
  ImGui.SameLine()
  createButton(uiState.corpse, blueButton)
  ImGui.SameLine()
  createButton(uiState.heal, greenButton)
  ImGui.SameLine()
  createButton(uiState.ressurect, fuchsiaButton)
  ImGui.SameLine()
  createButton(uiState.kill, redButton)
  ImGui.SameLine()
  createButton(uiState.cazictouch, redButton)
  ImGui.SameLine()
  createButton(uiState.kick, orangeButton)
  ImGui.SameLine()
  createStateButton(uiState.zone)
  ImGui.SameLine()
  createStateButton(uiState.zoneshutdown)

  ImGui.End()
  if uiState.zone.active then
    zoneselector(zones, "Zone", zoneTo)
  end

  if uiState.zoneshutdown.active then
    zoneselector(zones, "Zone Shutdown", zoneShutdown)
  end

  if uiState.zoneinstance.active then
    zoneinstanceselector("Zone to Instance", function(selectedInstanceId) uiState.zoneinstance.deactivate(uiState); doGMCommand("#zoneinstance "..selectedInstanceId) end)
  end

  if next(playerCorpses) then
    corpseselector(playerCorpses, "Summon Corpse", summonCorpse)
  end

  if not openGUI then
      terminate = true
  end
end

mq.imgui.init('ActionBar', actionbarUI)

while not terminate do
  mq.delay(500)
end