---@class NotUtils
local not_utils = {};

require "lib/stdlib_addon";
require "commands"

-- Классы (и псевдоклассы)
not_utils.Logger = require "lib/logger";
not_utils.FileReader = require "lib/fileReader"
not_utils.EventProvider = require "lib/events_provider";

-- Модули с функами
not_utils.coroutines = require "lib/coroutines";
not_utils.title = require "lib/title";
not_utils.table_compress = require "lib/table_compress"
not_utils.tags = require "lib/tags"
not_utils.utils = require "lib/utils";
not_utils.multiplayer = require "multiplayer/main"

return not_utils;
