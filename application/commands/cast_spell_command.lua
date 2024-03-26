local mq = require("mq")
local logger = require 'knightlinc.Write'
local commandQueue  = require'application.command_queue'

local function execute(spellId)
  local spell = mq.TLO.Spell(spellId)
  if not spell() then
    logger.Error("No spell defined for id <%s>", spellId)
  end

  logger.Info("Cast spell [%d] %s", spell.ID(), spell.Name())
  mq.cmdf("/say #castspell %d", spell.ID())
end

local function createCommand(spellId)
    commandQueue.Enqueue(function() execute(spellId) end)
end

---@type Command
return {
  Execute = execute,
  Queue = createCommand
}