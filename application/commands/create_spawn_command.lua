local mq = require("mq")
local logger = require 'knightlinc.Write'
local commandQueue  = require'application.command_queue'

local function execute()
  if mq.TLO.Target() and mq.TLO.Target.Type() == "NPC" then
    logger.Info("Creating spawn for %s at %s:%s:%s heading %s", mq.TLO.Target.Name(), mq.TLO.Me.X(), mq.TLO.Me.Y(), mq.TLO.Me.Z(), mq.TLO.Me.Heading.Degrees())
    mq.cmdf("/say #npcspawn create")
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