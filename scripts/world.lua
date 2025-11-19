require "main";
require "lib/coroutines";
local nu_events = require "nu_events"

function on_world_tick(tps)
  nu_events.emit("world_tick", tps);
end

function on_world_open()
  nu_events.emit("world_open");
end

function on_world_quit()
  events.remove_by_prefix(PACK_ID);
end
