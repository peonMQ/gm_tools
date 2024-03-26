local mq = require("mq")
local logger = require 'knightlinc.Write'
local commandQueue  = require'application.command_queue'

local function execute(instance_id)
  logger.Info("Zoneinstance %s", instance_id)
  mq.cmdf("/say #zoneinstance %s", instance_id)
end

local function createCommand(instance_id)
    commandQueue.Enqueue(function() execute(instance_id) end)
end

---@type Command
return {
  Execute = execute,
  Queue = createCommand
}