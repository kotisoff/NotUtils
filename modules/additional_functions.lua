-- Здесь хоронятся разные функции, дополняющие основные библиотеки.
-- Посему явного модуля здесь нет и не будет.

function inventory.consume_selected(pid, amount)
  local invid, slot = player.get_inventory(pid);
  local itemid, count = inventory.get(invid, slot);
  ---@diagnostic disable-next-line: undefined-field
  inventory.set(invid, slot, itemid, math.clamp(amount, -count, -1))
end

local worldtime = 0;
events.on("not_utils:world_tick", function()
  worldtime = worldtime + 1;
end)
events.on("not_utils:world_open", function()
  worldtime = 0;
end)

---Ticks from opening world. Pauses if world is paused. Seconds.
---@return number
function time.worldtime()
  return worldtime / 20;
end

function player.is_on_ground(pid)
  local entid = player.get_entity(pid);
  local entity = entities.get(entid);
  return entity.rigidbody:is_grounded();
end
