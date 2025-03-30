---@class NotUtils
local not_utils = {};

require "additional_functions";

not_utils.Logger = require "logger";
not_utils.coroutines = require "coroutines";
not_utils.ResourceLoader = require "resource_loader";
not_utils.utils = require "utils";
not_utils.title = require "title";

return not_utils;
