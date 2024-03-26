local mq = require("mq")
local logger = require 'knightlinc.Write'
local commandQueue  = require'application.command_queue'

---@alias GodModeOption 'on'|'off'

---@param toggle GodModeOption
local function execute(toggle)
  logger.Info("Godmode %s", toggle)
  mq.cmdf("/say #godmode %s", toggle)
end

---@param toggle GodModeOption
local function createCommand(toggle)
    commandQueue.Enqueue(function() execute(toggle) end)
end

---@type Command
return {
  Execute = execute,
  Queue = createCommand
}