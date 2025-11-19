local module = {};

---@alias eventlist "first_tick" | "world_tick" | "hud_open" | str

---@class nu.libs.event_provider
---@field pack_id str PACK ID
---@field on fun(event: eventlist, func: fun(...): any)
---@field emit fun(event: eventlist, ...: any): any

---@type nu.libs.event_provider[]
local event_providers = {};

local function format_event(packid, event)
  return string.format("%s:%s", packid, event);
end

---@param packid str
---@param event eventlist
local function emit(packid, event, ...)
  return events.emit(format_event(packid, event), ...);
end

---@param packid str
---@param event eventlist
---@param func fun(...): any
local function on(packid, event, func)
  return events.on(format_event(packid, event), func);
end

---@param packid str
---@return nu.libs.event_provider
function module.new(packid)
  if not pack.is_installed(packid) then
    error(string.format('Pack "%s" not found', packid));
  end;

  if event_providers[packid] then
    return event_providers[packid];
  else
    local instance = {
      pack_id = packid,

      ---@param event eventlist
      emit = function(event, ...)
        emit(packid, event, ...);
      end,

      ---@param event eventlist
      ---@param func fun(...): any
      on = function(event, func)
        on(packid, event, func)
      end
    }

    event_providers[packid] = instance;

    return instance;
  end
end

return module;
