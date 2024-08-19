local imgui = require 'ImGui'
local mq = require 'mq'
local icons = require 'mq.Icons'
local logger = require 'knightlinc.Write'
local buff_command = require'application.commands.buff_command'
local cast_spell_command = require'application.commands.cast_spell_command'
local godmode_command = require'application.commands.godmode_command'
local heal_command = require'application.commands.heal_command'
local kick_command = require'application.commands.kick_command'
local kill_command = require'application.commands.kill_command'
local pet_weapons_command = require'application.commands.pet_weapons_command'
local reload_quests_command = require'application.commands.reload_quests_command'
local reload_rules_command = require'application.commands.reload_rules_command'
local repop_command = require'application.commands.repop_command'
local summon_command = require'application.commands.summon_command'
local npc_editor_window = require('ui.npc_editor')

---@class PlayerCorpe
---@field Id number
---@field Name string

---@type PlayerCorpe[]
local playerCorpses =  {}

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
---@field public petWeapons ActionButton
---@field public cazictouch ActionButton
---@field public corpse ActionButton
---@field public godmode ActionButton
---@field public heal ActionButton
---@field public kick ActionButton
---@field public kill ActionButton
---@field public ressurect ActionButton
---@field public rq ActionButton
---@field public summon ActionButton
---@field public illusion ActionButton
---@field public zone ActionButton
---@field public zoneinstance ActionButton
---@field public zoneshutdown ActionButton

---@type ActionButton
local buffs = {
  active = false,
  icon = icons.FA_MAGIC, -- MD_ANDRIOD
  tooltip = "Buff target",
  isDisabled = function (state) return not mq.TLO.Me.GM() or not mq.TLO.Target() or mq.TLO.Target.Type() ~= "PC" or mq.TLO.Target.ID() == mq.TLO.Me.ID() or mq.TLO.Target.GM() end,
  activate = function(state)
    buff_command.Queue()
  end
}

---@type ActionButton
local petWeapons = {
  active = false,
  icon = icons.FA_SHIELD,
  tooltip = "Pet Weapons",
  isDisabled = function (state) return not mq.TLO.Me.GM() or not mq.TLO.Target() or mq.TLO.Target.Type() ~= "PC" or mq.TLO.Target.ID() == mq.TLO.Me.ID() or mq.TLO.Target.GM() end,
  activate = function(state)
    pet_weapons_command.Queue()
  end
}

---@type ActionButton
local cazictouch = {
  active = false,
  icon = icons.FA_MAGIC, -- MD_ANDRIOD
  tooltip = "Cazic Touch target",
  isDisabled = function (state) return not mq.TLO.Me.GM() or not mq.TLO.Target() or mq.TLO.Target.ID() == mq.TLO.Me.ID() or mq.TLO.Target.GM() end,
  activate = function(state)
    cast_spell_command.Queue(7477)
  end
}

---@type ActionButton
local corpse = {
  active = false,
  icon = icons.MD_AIRLINE_SEAT_FLAT, -- MD_ANDRIOD
  tooltip = "Corpse",
  isDisabled = function (state) return not mq.TLO.Me.GM() or not next(playerCorpses) end,
  activate = function(state)
    state.corpse.active = true
  end,
  deactivate = function(state)
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
    godmode_command.Queue("on")
  end,
  deactivate = function(state)
    state.godmode.active = false
    godmode_command.Queue("off")
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
    heal_command.Queue()
  end
}

---@type ActionButton
local kick = {
  active = false,
  icon = icons.FA_MINUS_SQUARE, -- MD_ANDRIOD
  tooltip = "Kick target",
  isDisabled = function (state) return not mq.TLO.Me.GM() or not mq.TLO.Target() or mq.TLO.Target.Type() ~= "PC" or mq.TLO.Target.ID() == mq.TLO.Me.ID() or mq.TLO.Target.GM() end,
  activate = function(state)
    kick_command.Queue()
  end
}

---@type ActionButton
local kill = {
  active = false,
  icon = icons.FA_MINUS_CIRCLE, -- MD_ANDRIOD
  tooltip = "Kill target",
  isDisabled = function (state) return not mq.TLO.Me.GM() or not mq.TLO.Target() or mq.TLO.Target.ID() == mq.TLO.Me.ID() or mq.TLO.Target.GM() end,
  activate = function(state)
    kill_command.Queue()
  end
}

---@type ActionButton
local reloadrules = {
  active = false,
  icon = icons.MD_REFRESH,
  tooltip = "Reload Rules",
  isDisabled = function (state)
    return not mq.TLO.Me.GM()
  end,
  activate = function(state)
    reload_rules_command.Queue()
  end
}

---@type ActionButton
local repop = {
  active = false,
  icon = icons.MD_REFRESH,
  tooltip = "Repop Zone",
  isDisabled = function (state)
    return not mq.TLO.Me.GM()
  end,
  activate = function(state)
    repop_command.Queue()
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
    cast_spell_command.Queue(994)
  end
}

---@type ActionButton
local rq = {
  active = false,
  icon = icons.MD_REFRESH, -- MD_ANDRIOD
  tooltip = "Reload quests",
  isDisabled = function (state) return not mq.TLO.Me.GM() end,
  activate = function(state)
    reload_quests_command.Queue()
  end
}

---@type ActionButton
local summon = {
  active = false,
  icon = icons.MD_PLAY_ARROW, -- MD_ANDRIOD
  tooltip = "Summon target",
  isDisabled = function (state) return not mq.TLO.Me.GM() or not mq.TLO.Target() end,
  activate = function(state)
    summon_command.Queue()
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
local illusion = {
  active = false,
  icon = icons.FA_MAGIC,
  tooltip = "Illusion",
  isDisabled = function (state) return not mq.TLO.Me.GM() or not mq.TLO.Target() or mq.TLO.Target.Type() ~= "PC" end,
  activate = function(state)
    state.illusion.active = true
  end,
  deactivate = function(state)
    state.illusion.active = false
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

---@type ActionButton
local npcEditor = {
  active = false,
  icon = icons.MD_ANDROID,
  tooltip = "NPC Editor",
  isDisabled = function (state) return not mq.TLO.Me.GM() end,
  activate = function(state)
    npc_editor_window.Open()
  end,
  deactivate = function(state)
    npc_editor_window.Close()
  end,
}

---@type ActionButtons
local uiState = {
  buffs = buffs,
  petWeapons = petWeapons,
  cazictouch = cazictouch,
  corpse = corpse,
  godmode = godmode,
  heal = heal,
  kick = kick,
  kill = kill,
  reloadrules = reloadrules,
  repop = repop,
  ressurect = ressurect,
  rq = rq,
  summon = summon,
  illusion = illusion,
  zone = togglezone,
  zoneinstance = zoneinstance,
  zoneshutdown = zoneshutdown,
  npceditor = npcEditor,
}

---@param pcCorpseSpawns spawn[]
local function setPlayerCorpses(pcCorpseSpawns)
  local newPlayerCorpses = {}
  for _, pccorpse in ipairs(pcCorpseSpawns) do
    table.insert(newPlayerCorpses, {Id = pccorpse.ID(), Name = pccorpse.Name()})
  end

  playerCorpses = newPlayerCorpses
end

---@return PlayerCorpe[]
local function getPlayerCorpses()
  return playerCorpses
end

return {
  setPlayerCorpses = setPlayerCorpses,
  GetplayerCorpses = getPlayerCorpses,
  ui_State = uiState
}