local nu_events = require "nu_events"
local coroutines = require "lib/coroutines";

local title = {};
title.utils = {};
title.document = {};

nu_events.on("hud_open", function()
  title.document = Document.new("not_utils:title");
  hud.open_permanent("not_utils:title");
end)

local function set_opacity(name, opacity)
  local el = title.document[name];
  local r, g, b, _ = unpack(el.color);
  el.color = { r, g, b, opacity };
end

---@class nu.TitleComponent
---@field name str
---@field _shown bool
---@field _break bool
local TitleComponent = {}
TitleComponent.__index = TitleComponent;

---@param text string
---@param duration number | nil
---@param stop_function (fun(tempdata:any): boolean | nil) | nil
function TitleComponent:show(text, duration, stop_function)
  duration = duration or 5;
  local stop = stop_function or function() return false end;

  if self._shown then self._break = true end;

  coroutines.create(function()
    self._shown = true;

    title.document[self.name .. "-root"].visible = true;
    title.document[self.name].text = text;

    set_opacity(self.name, 255);

    coroutines.sleep(duration
      {
        break_function = function(data) return self._break or stop(data); end,
        cycle_task = function(data, time)
          if time > (duration - 1) then
            local step = 255 / 20;

            local opacity = data.opacity or 255;
            opacity = opacity - step;

            set_opacity(self.name, math.floor(opacity));
            data.opacity = opacity;
          end
        end,
        time_function = time.worldtime
      }
    )

    set_opacity(self.name, 0);

    self._shown = false;
    self._break = false;

    title.document[self.name .. "-root"].visible = false;
  end)
end

---@return nu.TitleComponent
local function new_title_component(name)
  local component = setmetatable({ name = name, _shown = false, _break = false }, TitleComponent);

  return component
end

title.types = {
  actionbar = "",
  title = "",
  subtitle = ""
}

title.actionbar = new_title_component("actionbar");
title.title = new_title_component("title");
title.subtitle = new_title_component("subtitle");

return title;
