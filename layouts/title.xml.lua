local title = require "title";

local function center_text(root, el)
  root.size = el.size;
  local center = gui.get_viewport()[1] / 2;
  local el_center = el.size[1] / 2;
  root.pos = { center - el_center, root.pos[2] }
end

events.on("not_utils:world_tick", function()
  for _, value in pairs(title.types) do
    local root = document[value .. "-root"];
    local el = document[value];
    center_text(root, el);
  end
end)
