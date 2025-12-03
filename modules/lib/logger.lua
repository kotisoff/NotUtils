local module = {}

---@enum not_utils.Logger.levels
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

---@param logLevel not_utils.Logger.levels
local function prefix(name, logLevel)
  local date = os.date("%Y/%m/%d %H:%M:%S%z    ");
  local log_prefix = string.format("[%s] %s %s ", logLevel, date, module.format_name(name));
  return log_prefix
end

---@param logLevel not_utils.Logger.levels
function Logger:log(logLevel, ...)
  table.insert(self.history, prefix(self.name, logLevel) .. table.concat({ ... }, " "));
end

function Logger:print()
  if #self.history == 0 then return end;
  print(table.concat(self.history, "\n"));
  self.history = {};
end

---@param logLevel not_utils.Logger.levels
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
    ---@class not_utils.Logger
    ---@field log fun(self: not_utils.Logger, logLevel: not_utils.Logger.levels, ...)
    ---@field print fun(self: not_utils.Logger)
    ---@field println fun(self: not_utils.Logger, ...)
    ---@field clear_history fun(self: not_utils.Logger)
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
