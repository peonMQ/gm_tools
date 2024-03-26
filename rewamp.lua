local mq = require 'mq'
local logger = require 'knightlinc.Write'
local utils = require 'utils'

local npcs = mq.getFilteredSpawns(function(spawn) return spawn.Distance() < 1000
                                                            and  spawn.Type() =="NPC"
                                                            and spawn.Level() < 60
                                                            and not string.find(spawn.Name(), "elven")
                                                            and not string.find(spawn.Name(), "dwarven")
                                                            and not string.find(spawn.Name(), "Kelynn")
                                                          end)
-- npcs = mq.getAllSpawns()
for _, npc in ipairs(npcs) do
  if utils.EnsureTarget(npc.ID()) then
    mq.cmdf("/say #level 60")
    mq.delay(1000, function() return mq.TLO.Target.Level() == 60 end)
  end
end