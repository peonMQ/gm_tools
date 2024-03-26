local mq = require("mq")
local logger = require 'knightlinc.Write'
local utils = require 'utils'
local commandQueue  = require'application.command_queue'
local summon_command = require'application.commands.summon_command'
local cast_spell_command = require'application.commands.cast_spell_command'

---@param corpses PlayerCorpe[]
local function execute(corpses)
  for _, corpse in ipairs(corpses) do
    summon_command.Execute(corpse.Id)
    mq.delay(100)
    cast_spell_command.Execute(994)
  end
end

---@param corpses PlayerCorpe[]
local function createCommand(corpses)
    commandQueue.Enqueue(function() execute(corpses) end)
end

---@type Command
return {
  Execute = execute,
  Queue = createCommand
}