local module = {};
local coroutines = {};

---@param func fun()
function module.create(func)
  local co = coroutine.create(func);
  table.insert(coroutines, co);
  return co
end

---@class sleep_options
---@field time_function? fun(): number Seconds. Default: time.uptime.
---@field break_function? fun(temp: table): boolean Breaks sleep if true.
---@field cycle_task? fun(temp: table, passed: number) Task to run every tick of sleep.

---@param time_seconds number Time in seconds.
---@param options? sleep_options
---@return boolean status Status of sleep. true if success, false if broken.
function module.sleep(time_seconds, options)
  -- Defaults
  options = options or {};
  options.time_function = options.time_function or time.uptime;
  options.break_function = options.break_function or function() return false end;
  options.cycle_task = options.cycle_task or function(temp, passed) end;

  -- Locals
  local temp = {};
  local start = options.time_function();

  -- Coroutine sleeping
  while options.time_function() - start < time_seconds do
    if options.break_function(temp) then return false end
    options.cycle_task(temp, options.time_function() - start);
    coroutine.yield();
  end

  return true;
end

---@param func function
---@param time_seconds number
---@param time_function? fun(): number
function module.set_interval(func, time_seconds, time_function)
  time_function = time.uptime;
  local _break = false;

  local start = time_function() - time_seconds;
  while not _break do
    if time_function() - start > time_seconds then
      start = time_function();
      func();
    end
    coroutine.yield();
  end

  return function()
    _break = true;
  end
end

events.on("not_utils:world_tick", function()
  for index, co in pairs(coroutines) do
    coroutine.resume(co);
    if coroutine.status(co) == "dead" then
      table.remove(coroutines, index);
    end
  end
end)

return module;
