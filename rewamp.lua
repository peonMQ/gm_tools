local mq = require 'mq'
local logger = require 'knightlinc/Write'


local function ensureTarget(targetId)
  if not targetId then
    logger.Debug("Invalid <targetId>")
    return false
  end

  if mq.TLO.Target.ID() ~= targetId then
    if mq.TLO.SpawnCount("id "..targetId)() > 0 then
      mq.cmdf("/mqtarget id %s", targetId)
      mq.delay("3s", function() return mq.TLO.Target.ID() == targetId end)
    else
      logger.Warn("EnsureTarget has no spawncount for target id <%d>", targetId)
    end
  end

  return mq.TLO.Target.ID() == targetId
end

local npcs = mq.getFilteredSpawns(function(spawn) return spawn.Distance() < 1000
                                                            and  spawn.Type() =="NPC"
                                                            and spawn.Level() < 60
                                                            and not string.find(spawn.Name(), "elven")
                                                            and not string.find(spawn.Name(), "dwarven")
                                                            and not string.find(spawn.Name(), "Kelynn")
                                                          end)
-- npcs = mq.getAllSpawns()
for _, npc in ipairs(npcs) do
  if ensureTarget(npc.ID()) then
    mq.cmdf("/say #level 60")
    mq.delay(1000, function() return mq.TLO.Target.Level() == 60 end)
  end
end