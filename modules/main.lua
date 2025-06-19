---@class NotUtils
local not_utils = {};

require "lib/stdlib_addon";

not_utils.Logger = require "lib/logger";
not_utils.coroutines = require "lib/coroutines";
not_utils.ResourceLoader = require "lib/resource_loader";
not_utils.utils = require "lib/utils";
not_utils.title = require "lib/title";
not_utils.table_compress = require "lib/table_compress"
not_utils.multiplayer = require "multiplayer/main"

return not_utils;
