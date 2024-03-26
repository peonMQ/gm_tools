local mq = require("mq")
local logger = require 'knightlinc.Write'
local commandQueue  = require'application.command_queue'

local function execute(x, y ,z)
  logger.Info("Goto %d %d %d", x, y, z)
  mq.cmdf("/say #goto %d %d %d", x, y, z)
end

local function createCommand(x, y ,z)
    commandQueue.Enqueue(function() execute(x, y ,z) end)
end

---@type Command
return {
  Execute = execute,
  Queue = createCommand
}