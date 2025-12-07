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

---@alias not_utils.mp.handle_event.available_params "client"

---@param mp_event str
---@param replace_event str
---@param handler function
---@param provide_params not_utils.mp.handle_event.available_params[]
function module.handle_event(mp_event, replace_event, handler, provide_params)
  if module.mode == "standalone" then
    local params = {};

    for _, value in ipairs(provide_params) do
      if value == "client" then
        table.insert(params, module.api.server.accounts.get_client_by_name(""));
      end
    end

    events.on(replace_event, function(...)
      for _, value in ipairs({ ... }) do
        table.insert(params, value);
      end

      handler(unpack(params));
    end)
  else
    events.on(mp_event, handler);
  end
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
