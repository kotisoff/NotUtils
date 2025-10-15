local nu_events = require "nu_events"
local module = {};
local threads = {};

---@param func fun()
function module.create(func)
  local co = coroutine.create(func);
  table.insert(threads, co);
  return co
end

---@class sleep_options
---@field time_function? fun(): number Seconds. Default: time.uptime.
---@field break_function? fun(temp_data: table, elapsed_seconds: number): boolean Breaks sleep if true.
---@field cycle_task? fun(temp_data: table, elapsed_seconds: number) Task to run every tick of sleep.

---@param time_seconds number Time in seconds.
---@param options? sleep_options
---@return boolean status Status of sleep. true if success, false if broken.
function module.sleep(time_seconds, options)
  options = options or {};

  local get_time = options.time_function or time.uptime;
  local _break = options.break_function;

  -- Locals
  local temp_data = {};
  local start = get_time()
  local get_elapsed = function() return get_time() - start end;

  -- Coroutine sleeping
  while get_time() - start < time_seconds do
    local elapsed = get_elapsed();

    if _break and _break(temp_data, elapsed) then
      return false
    end
    options.cycle_task(temp_data, elapsed);

    coroutine.yield();
  end

  return true;
end

nu_events.on("world_tick", function()
  for index, co in pairs(threads) do
    coroutine.resume(co);
    if coroutine.status(co) == "dead" then
      table.remove(threads, index);
    end
  end
end)

return module;
