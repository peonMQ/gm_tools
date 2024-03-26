local mq = require("mq")
local logger = require 'knightlinc.Write'
local commandQueue  = require'application.command_queue'


local function execute()
  if not mq.TLO.Target() or mq.TLO.Target.ID() == mq.TLO.Me.ID() or mq.TLO.Target.GM() then
    return
  end

  if mq.TLO.Target()  then
    logger.Info("Killing target %s", mq.TLO.Target.Name())
    mq.cmdf("/say #kill")
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