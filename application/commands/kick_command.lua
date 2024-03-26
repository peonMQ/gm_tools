local mq = require("mq")
local logger = require 'knightlinc.Write'
local commandQueue  = require'application.command_queue'

local function execute(name)
  if name and name ~= mq.TLO.Me.Name() then
    logger.Info("Kicking %s", name)
    mq.cmdf("/say #kick %s", name)
  elseif mq.TLO.Target() and mq.TLO.Target.Type() == "PC" then
    if not mq.TLO.Target() or mq.TLO.Target.ID() == mq.TLO.Me.ID() or mq.TLO.Target.GM() then
      return
    end

    logger.Info("Kicking target %s", mq.TLO.Target.Name())
    mq.cmdf("/say #kick")
  end
end

local function createCommand(name)
    commandQueue.Enqueue(function() execute(name) end)
end

---@type Command
return {
  Execute = execute,
  Queue = createCommand
}