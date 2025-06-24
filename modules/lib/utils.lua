local utils = {};

local Logger = require "lib/logger";
local log = Logger.new("not_utils", "utils");

--[[
Usage:

Some item
```json
{
  ...,
  "modid:func_prop": "function(arg1) print("Hello world!", arg1) end"
  ...
}
```

Any module
```lua
local props = item.properties[itemid];
local func = not_utils.utils.parse_callback_string(props["modid:func_prop"]);
func("Meow"); -- Hello world! Meow
```

Also works in any other ways.
]]

---Parse function strings.
---@param prop string Property value. path or path@func or function(...) end
---@return fun(...)
function utils.parse_function_string(prop)
  local func = function(...) end;

  -- Callback as string function
  ---@diagnostic disable-next-line: undefined-field
  if string.starts_with(prop, "function(") then
    local fn, error = loadstring("(" .. prop .. ")(...)");
    if error then
      log:println(
        "Error occured while parsing function:\n" .. prop
      )
    elseif fn then
      func = fn;
    end
  else
    -- Callback as script path and function name.
    ---@diagnostic disable-next-line: undefined-field
    local filepath, func_name = unpack(string.split(prop, "@"));
    local module = require(filepath);

    if func_name then
      func = module[func_name];
    else
      func = module;
    end
  end

  return func;
end

---Random callback.
---@param chance number 0..1
---@param cb fun(): any
function utils.random_cb(chance, cb)
  if chance > math.random() then
    return cb()
  end
  return nil
end

---Get index of item even if itemname is blockname.
---@param itemname string|number
---@return number|nil
function utils.index_item(itemname)
  if not itemname or type(itemname) == "number" then
    return itemname;
  end

  local itemid = nil;

  itemid = item.index(itemname)
  if not itemid then
    itemid = item.index(itemname .. ".item");
  end

  return itemid;
end

return utils;
