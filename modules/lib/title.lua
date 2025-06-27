local coroutines = require "lib/coroutines";

local title = {};
title.utils = {};
title.document = {};

events.on("not_utils:hud_open", function()
  title.document = Document.new("not_utils:title");
  hud.open_permanent("not_utils:title");
end)

function title.utils.set_opacity(name, opacity)
  local el = title.document[name];
  local r, g, b, _ = unpack(el.color);
  el.color = { r, g, b, opacity };
end

local function new_title_component(name)
  return setmetatable(
    { name = name, is_shown = false, break_show = false },
    {
      __index = {
        ---@param text string
        ---@param show_time number | nil
        ---@param breakfunc (fun(tempdata:any): boolean) | nil True stops function.
        show = function(self, text, show_time, breakfunc)
          show_time = show_time or 5;
          breakfunc = breakfunc or function(temp) return false end;

          if self.is_shown then self.break_show = true end;
          coroutines.create(function()
            self.is_shown = true;

            title.document[self.name .. "-root"].visible = true;
            title.document[self.name].text = text;
            title.utils.set_opacity(self.name, 255);

            coroutines.sleep(
              show_time,
              {
                break_function = function(data) return self.break_show or breakfunc(data); end,
                cycle_task = function(data, time)
                  if time > (show_time - 1) then
                    local step = 255 / 20;
                    local opacity = data.opacity or 255;
                    opacity = opacity - step;
                    title.utils.set_opacity(name, math.floor(opacity));
                    data.opacity = opacity;
                  end
                end,
                time_function = time.worldtime
              }
            )

            title.utils.set_opacity(self.name, 0);

            self.is_shown = false;
            self.break_show = false;

            title.document[self.name .. "-root"].visible = false;
          end)
        end
      }
    })
end

title.types = {
  actionbar = "actionbar",
  title = "title",
  subtitle = "subtitle"
}

title.actionbar = new_title_component("actionbar");
title.title = new_title_component("title");
title.subtitle = new_title_component("subtitle");

return title;
