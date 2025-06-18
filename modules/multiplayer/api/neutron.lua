local module = {}

---@return boolean
function module.check()
  return not not _G["$Neutron"]
end

---@return "standalone" | "client" | "server"
function module.mode()
  return _G["$Neutron"]
end

function module.server_api()
  ---@type neutron.server
  local api = require "server:api/api".server

  return api
end

function module.client_api()
  ---@type neutron.client
  local api = require "multiplayer:api/api".client

  return api
end

return module
