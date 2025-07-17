local api_list = {
  "neutron",
  "standalone"
}

local module = {
  ---@type "standalone" | "server" | "client"
  mode = "standalone",
  ---@type "standalone" | "neutron" | str
  name = "standalone",
  ---@type { server: neutron.server, client: neutron.client }
  api = nil
}


---@class not_utils.mp.api_template
---@field check fun(): boolean
---@field mode fun(): "standalone" | "client" | "server"
---@field load fun(): { server: neutron.server, client: neutron.client }

if not module.api then
  for _, value in ipairs(api_list) do
    ---@type not_utils.mp.api_template
    local temp_api = require("multiplayer/api/" .. value)

    if temp_api.check() then
      local mode = temp_api.mode();
      local api = temp_api.load();

      module = {
        mode = mode,
        api = api,
        name = value
      }
      break
    end
  end
end

return module
