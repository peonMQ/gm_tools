local mq = require("mq")
local logger = require 'knightlinc.Write'
local commandQueue  = require'application.command_queue'


local function execute()
  logger.Info("Repopping zone %s", mq.TLO.Zone.Name())
  mq.cmdf("/say #repop")
end

local function createCommand()
  commandQueue.Enqueue(function() execute() end)
end

---@type Command
return {
  Execute = execute,
  Queue = createCommand
}