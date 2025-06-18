local api_list = {
  "neutron",
  "standalone"
}

local module = {
  ---@type "standalone" | "server" | "client"
  mode = "standalone",
  ---@type { server: neutron.server | nil, client: neutron.client | nil }
  api = nil
}


---@class not_utils.mp.api_template
---@field check fun(): boolean
---@field mode fun(): "standalone" | "client" | "server"
---@field server_api fun(): neutron.server
---@field client_api fun(): neutron.client

if not module.api then
  for _, value in ipairs(api_list) do
    ---@type not_utils.mp.api_template
    local temp_api = require("multiplayer/api/" .. value)

    if temp_api.check() then
      local mode = temp_api.mode()
      local api = {}
      if mode == "client" or mode == "standalone" then
        api.client = temp_api.client_api()
      end
      if mode == "server" or mode == "standalone" then
        api.server = temp_api.server_api()
      end

      module = {
        mode = temp_api.mode(),
        api = api
      }
      break
    end
  end
end

return module
