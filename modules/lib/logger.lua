local module = {}

---@enum not_utils.logger.levels
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

---@param logLevel not_utils.logger.levels
---@param logger Logger
local function prefix(logLevel, logger)
  local date = os.date("%Y/%m/%d %H:%M:%S%z    ");
  local log_prefix = string.format("[%s] %s %s ", logLevel, date, module.format_name(logger.name));
  return log_prefix
end

---@param logLevel not_utils.logger.levels
---@param logger Logger
local function log(logLevel, logger, ...)
  table.insert(logger.history, prefix(logLevel, logger) .. table.concat({ ... }, " "));
end

---@param logger Logger
local function print_history(logger)
  if #logger.history == 0 then return end;
  print(table.concat(logger.history, "\n"));
  logger.history = {};
end

---@param logLevel not_utils.logger.levels
---@param logger Logger
local function println(logLevel, logger, ...)
  print(prefix(logLevel, logger) .. table.concat({ ... }, " "))
end

local loggers = {};


---@param name string
function module.new(name)
  if loggers[name] then
    return loggers[name]
  else
    ---@class Logger
    local logger = {
      name = name,
      history = {},
      levels = logLevels
    }

    ---@param logLevel not_utils.logger.levels
    logger.log = function(logLevel, ...)
      log(logLevel, logger, ...);
    end

    logger.clear_history = function()
      logger.history = {};
    end

    logger.print = function()
      print_history(logger);
    end

    ---@param logLevel not_utils.logger.levels
    logger.println = function(logLevel, ...)
      println(logLevel, logger, ...);
    end

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
