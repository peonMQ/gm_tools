local mq = require("mq")
local logger = require 'knightlinc.Write'
local commandQueue  = require'application.command_queue'
local utils = require 'utils'

local function execute(id)
  if id then
    logger.Info("Targeting id %s", id)
    if not utils.EnsureTarget(id) then
      logger.Error("Failed targeting id %s", id)
    end
  end

  if mq.TLO.Target() then
    logger.Info("Summoning target %s", mq.TLO.Target.Name())
    mq.cmdf("/say #summon")
  end
end

local function createCommand(id)
    commandQueue.Enqueue(function() execute(id) end)
end

---@type Command
return {
  Execute = execute,
  Queue = createCommand
}