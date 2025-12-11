local nu_events = require "nu_events"
local module = {};
local threads = {};

---@param func fun()
function module.create(func)
  local co = coroutine.create(func);
  table.insert(threads, co);
  return co
end

---@class nu.coroutine.sleep_options
---@field time_function? fun(): number Seconds. Default: time.uptime.
---@field break_function? fun(temp_data: table, elapsed_seconds: number): boolean Breaks sleep if true.
---@field cycle_task? fun(temp_data: table, elapsed_seconds: number) Task to run every tick of sleep.

---@param time_seconds number Time in seconds.
---@param options? nu.coroutine.sleep_options
---@return boolean status Status of sleep. true if success, false if broken.
function module.sleep(time_seconds, options)
  options = options or {};

  local _time = options.time_function or time.uptime;
  local _break = options.break_function;
  local _task = options.cycle_task;

  local start = _time()
  local _elapsed = function() return _time() - start end;

  local temp_data = {};
  while _time() - start < time_seconds do
    local elapsed = _elapsed();

    if _break and _break(temp_data, elapsed) then
      return false
    end

    if _task then _task(temp_data, elapsed) end;

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
