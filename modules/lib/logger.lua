local module = {}

---@class Logger
---@field private name string
---@field private history string[]
---@field private prefix fun(self, level: not_utils.logger.levels): string
---@field private filepath fun(self): string
local logger = {
  history = {},

  ---@enum not_utils.logger.levels
  levels = {
    ---Silent
    S = "S",
    ---Info
    I = "I",
    ---Warn
    W = "W",
    ---Error
    E = "E"
  }
}

---@param logLevel not_utils.logger.levels
function logger:prefix(logLevel)
  local date = os.date("%Y/%m/%d %H:%M:%S%z    ");
  local log_prefix = string.format("[%s] %s %s ", logLevel, date, module.format_name(self.name));
  return log_prefix
end

---@param logLevel not_utils.logger.levels
function logger:log(logLevel, ...)
  table.insert(self.history, self:prefix(logLevel) .. table.concat({ ... }, " "));
end

function logger:clear()
  self.history = {};
end

function logger:print()
  if #self.history == 0 then return end;
  print(table.concat(self.history, "\n"));
  self.history = {};
end

---@param logLevel not_utils.logger.levels
function logger:println(logLevel, ...)
  print(self:prefix(logLevel) .. table.concat({ ... }, " "))
end

local loggers = {};


---@param name string
---@return Logger
function module.new(name)
  if loggers[name] then
    return loggers[name]
  else
    local instance = setmetatable({ name = name }, { __index = logger });
    loggers[name] = instance;
    return instance;
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
