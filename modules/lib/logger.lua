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

local function format_name(name)
  local len = 20;
  local spaces_count = len - #name;

  local spaces = string.rep(" ", spaces_count);

  return string.format("[%s%s]", spaces, name);
end

---@param logLevel not_utils.logger.levels
function logger:prefix(logLevel)
  local date = os.date("%Y/%m/%d %H:%M:%S%z    ");
  local log_prefix = string.format("[%s] %s %s ", logLevel, date, format_name(self.name));
  return log_prefix
end

---@param logType not_utils.logger.levels
function logger:log(logType, ...)
  table.insert(self.history, self:prefix(logType) .. table.concat({ ... }, " "));
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

local module = {
  new = function(name)
    if loggers[name] then
      return loggers[name]
    else
      local instance = setmetatable({ name = name }, { __index = logger });
      loggers[name] = instance;
      return instance;
    end
  end
}

return module
