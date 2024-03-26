local mq = require("mq")
local logger = require 'knightlinc.Write'
local commandQueue  = require'application.command_queue'

local function execute()
  local target = mq.TLO.Target
  if target() and target.Type() ~= "Corpse" then
    logger.Info("Healing %s", target())
    mq.cmdf("/say #heal")
    mq.cmdf("/say #mana")
  end
end

local function createCommand()
    commandQueue.Enqueue(function() execute() end)
end

---@type Command
return {
  Execute = execute,
  Queue = createCommand
}