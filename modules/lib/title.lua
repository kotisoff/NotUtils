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

local function new_title_component(name)
  local component = {
    name = name
  }

  local internal_state = {
    _shown = false,
    _break = false
  };

  ---@param text string
  ---@param show_time number | nil
  ---@param breakfunc (fun(tempdata:any): boolean) | nil True stops function.
  component.show = function(text, show_time, breakfunc)
    show_time = show_time or 5;
    breakfunc = breakfunc or function(temp) return false end;

    local state = internal_state;

    if state._shown then state._break = true end;

    coroutines.create(function()
      state._shown = true;

      title.document[name .. "-root"].visible = true;
      title.document[name].text = text;
      set_opacity(name, 255);

      coroutines.sleep(
        show_time,
        {
          break_function = function(data) return component.break_show or breakfunc(data); end,
          cycle_task = function(data, time)
            if time > (show_time - 1) then
              local step = 255 / 20;

              local opacity = data.opacity or 255;
              opacity = opacity - step;

              set_opacity(name, math.floor(opacity));
              data.opacity = opacity;
            end
          end,
          time_function = time.worldtime
        }
      )

      set_opacity(name, 0);

      component.is_shown = false;
      component.break_show = false;

      title.document[name .. "-root"].visible = false;
    end)
  end

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
