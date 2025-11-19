require "multiplayer/chat/init"
local nu_events = require "nu_events"

function on_hud_open(playerid)
  nu_events.emit("hud_open", playerid);
end
