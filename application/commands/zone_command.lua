local mq = require("mq")
local logger = require 'knightlinc.Write'
local commandQueue  = require'application.command_queue'

local function execute(zone_short_name)
  if not zone_short_name then
    return
  elseif not mq.TLO.Zone(zone_short_name).ID() then
    logger.Error("Zone shortname does not exist <%s>", zone_short_name)
  elseif zone_short_name == mq.TLO.Zone.ShortName() then
    logger.Error("Teleport to a different zone before trying to shutdown <%s>", zone_short_name)
  else
    logger.Info("Zone %s", zone_short_name)
    mq.cmdf("/say #zone %s", zone_short_name)
  end
end

local function createCommand(zone_short_name)
    commandQueue.Enqueue(function() execute(zone_short_name) end)
end

---@type Command
return {
  Execute = execute,
  Queue = createCommand
}