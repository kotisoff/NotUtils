local module = {}

---@alias MultiplayerData { side: "client"|"server", pack_id: str, api_references: table<string, number[]> }

---@return boolean
function module.check()
  ---@type MultiplayerData
  local data = _G["$Multiplayer"];

  -- Уж лучше так, чем делать `not not N`
  if data and data.api_references["Neutron"] then
    return true;
  end

  return false;
end

---@return "standalone" | "client" | "server"
function module.mode()
  ---@type MultiplayerData
  local data = _G["$Multiplayer"];

  return data and data.side or "standalone"
end

function module.load()
  ---@type MultiplayerData
  local data = _G["$Multiplayer"];
  local temp = {};

  local api = require(string.format("%s:api/%s/api", data.pack_id, data.api_references.Neutron[1]))[data.side]

  temp[data.side] = api;
  return temp;
end

return module
