local mq = require("mq")
local logger = require 'knightlinc.Write'
local commandQueue  = require'application.command_queue'

local function execute()
  logger.Info("Buffing")
  -- mq.cmdf("/say #castspell 2680") -- overwritten by Beta Brell's Stalwart : 3028
  mq.cmdf("/say #castspell 2681")
  mq.cmdf("/say #castspell 2682")
  -- mq.cmdf("/say #castspell 2691") -- overwritten by Beta Boar : 3023
  mq.cmdf("/say #castspell 2692")
  mq.cmdf("/say #castspell 2693")
  mq.cmdf("/say #castspell 2695")
  mq.cmdf("/say #castspell 2696")
  mq.cmdf("/say #castspell 2699")
  mq.cmdf("/say #castspell 3023")
  mq.cmdf("/say #castspell 3028")
end

local function createCommand()
    commandQueue.Enqueue(function() execute() end)
end

---@type Command
return {
  Execute = execute,
  Queue = createCommand
}