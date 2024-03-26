local mq = require("mq")
local logger = require 'knightlinc.Write'
local commandQueue  = require'application.command_queue'

local function execute(npc_query)
  if not npc_query or npc_query == "" then
    logger.Warn("Not a valid NPC query.")
    return
  end

  logger.Info("Querying NPC %s", npc_query)
  mq.cmdf("/say #findnpctype %s", npc_query)
end

local function createCommand(npc_query)
    commandQueue.Enqueue(function() execute(npc_query) end)
end

---@type Command
return {
  Execute = execute,
  Queue = createCommand
}