local module = {}

---@enum nu.Logger.levels
local logLevels = {
  ---Silent
  S = "S",
  ---Info
  I = "I",
  ---Warn
  W = "W",
  ---Error
  E = "E"
}

local Logger = {};

---@param logLevel nu.Logger.levels
local function prefix(name, logLevel)
  local date = os.date("%Y/%m/%d %H:%M:%S%z    ");
  local log_prefix = string.format("[%s] %s %s ", logLevel, date, module.format_name(name));
  return log_prefix
end

---@param logLevel nu.Logger.levels
function Logger:log(logLevel, ...)
  table.insert(self.history, prefix(self.name, logLevel) .. table.concat({ ... }, " "));
end

function Logger:print()
  if #self.history == 0 then return end;
  print(table.concat(self.history, "\n"));
  self.history = {};
end

---@param logLevel nu.Logger.levels
function Logger:println(logLevel, ...)
  print(prefix(self.name, logLevel) .. table.concat({ ... }, " "))
end

function Logger:clear_history()
  self.history = {};
end

local loggers = {};

---@param name string
function module.new(name)
  if loggers[name] then
    return loggers[name]
  else
    ---@class nu.Logger
    ---@field log fun(self: nu.Logger, logLevel: nu.Logger.levels, ...)
    ---@field print fun(self: nu.Logger)
    ---@field println fun(self: nu.Logger, logLevel: nu.Logger.levels, ...)
    ---@field clear_history fun(self: nu.Logger)
    local logger = setmetatable({
        name = name, history = {}, levels = logLevels
      },
      { __index = Logger }
    )

    loggers[name] = logger;
    return logger;
  end
end

---Форматирует строку в строку типа префикса логгера.
---@param name string
function module.format_name(name)
  local len = 20;
  local spaces_count = len - #name;

  local spaces = string.rep(" ", spaces_count);

  return string.format("[%s%s]", spaces, name);
end

return module
