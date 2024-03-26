local mq = require 'mq'
local logger = require 'knightlinc.Write'
local utils = require 'utils'

local npcs = mq.getFilteredSpawns(function(spawn) return spawn.Distance() < 3000
                                                            and  spawn.Type() =="NPC"
                                                            and spawn.Level() == 60
                                                          end)
-- npcs = mq.getAllSpawns()
for i, npc in ipairs(npcs) do
  if utils.EnsureTarget(npc.ID()) then
    mq.cmdf("/say #summon")
    mq.delay(1000, function() return mq.TLO.Target.Distance() < 100 end)
  end

  if i == 10 then
    mq.exit()
  end
end