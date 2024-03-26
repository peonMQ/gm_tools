local mq = require("mq")
local logger = require 'knightlinc.Write'
local commandQueue  = require'application.command_queue'


local function execute(npc_id)
  if not npc_id or not tonumber(npc_id) then
    logger.Warn("Not a valid NPC id <%s>", npc_id)
    return
  end

  logger.Info("Spawn NPC %s", npc_id)
  mq.cmdf("/say #npctypespawn %s", npc_id)
end

local function createCommand(npc_id)
    commandQueue.Enqueue(function() execute(npc_id) end)
end

---@type Command
return {
  Execute = execute,
  Queue = createCommand
}