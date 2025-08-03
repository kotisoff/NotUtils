local title = require "lib/title";

local old_text = table.copy(title.types);

---@param key str
---@param el voxelcore.ui.document.label
local function check_difference(key, el)
  local text = el.text;
  if old_text[key] ~= text then
    old_text[key] = text;
    return true
  end

  return false;
end

local function center_text(root, el)
  root.size = el.size;
  local center = gui.get_viewport()[1] / 2;
  local el_center = el.size[1] / 2;
  root.pos = { center - el_center, root.pos[2] }
end


events.on("not_utils:world_tick", function()
  for key, _ in pairs(title.types) do
    local el = document[key] --[[@as voxelcore.ui.document.label]];

    if check_difference(key, el) then
      local root = document[key .. "-root"];
      center_text(root, el)
    end
  end
end)
