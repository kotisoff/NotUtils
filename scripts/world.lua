require "main";
require "lib/coroutines";

function on_world_tick()
  events.emit("not_utils:world_tick");
end

function on_world_open()
  events.emit("not_utils:world_open");
end

function on_world_quit()
  events.remove_by_prefix(PACK_ID);
end
