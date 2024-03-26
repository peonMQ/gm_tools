local mq = require("mq")
local logger = require 'knightlinc.Write'
local commandQueue  = require'application.command_queue'

local function execute()
  local target = mq.TLO.Target
  if target() and target.Type() == "PC" then
    logger.Info("Giving pet weapons to %s", target())
    mq.cmdf("/say #giveitem 28595")
    mq.cmdf("/say #giveitem 28595")
    mq.cmdf("/say #giveitem 28595")
    mq.cmdf("/say #giveitem 28595")
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