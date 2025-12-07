local api_list = {
  "neutron",
  "standalone"
}

---@alias not_utils.mp.mode "standalone" | "server" | "client"

local module = {
  ---@type not_utils.mp.mode
  mode = "standalone",
  ---@type "standalone" | "neutron" | str
  name = "standalone",
  ---@type { server: neutron.server, client: neutron.client }
  api = nil
}

---@param cb fun(server: neutron.server, mode: not_utils.mp.mode): any
---@return any
function module.as_server(cb)
  if module.api.server then
    return cb(module.api.server, module.mode);
  end
end

---@param cb fun(client: neutron.client, mode: not_utils.mp.mode): any
---@return any
function module.as_client(cb)
  if module.api.client then
    return cb(module.api.client, module.mode);
  end
end

---@param vec vec3
---@return { x: number, y: number, z: number }
function module.convert_vector(vec)
  local pos = { x = vec[1], y = vec[2], z = vec[3] };

  return pos;
end

---@deprecated todo: вырезать этот ужас
function module.get_shared_field(name)
  local api = module.api;
  return (api.server and api.server[name]) or (api.client and api.client[name])
end

---@class not_utils.mp.api_template
---@field check fun(): boolean
---@field mode fun(): not_utils.mp.mode
---@field load fun(): { server: neutron.server, client: neutron.client }

if not module.api then
  for _, value in ipairs(api_list) do
    ---@type not_utils.mp.api_template
    local temp_api = require("multiplayer/api/" .. value)

    if temp_api.check() then
      module.mode = temp_api.mode();
      module.api = temp_api.load();
      module.name = value;
      break
    end
  end
end

return module
