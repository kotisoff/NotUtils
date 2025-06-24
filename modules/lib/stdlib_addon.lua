-- Здесь хоронятся разные функции, дополняющие основные библиотеки.
-- Посему явного модуля здесь нет и не будет.

---Удаляет определённое кол-во предметов из руки игрока
---@param pid number
---@param amount number
function inventory.consume_selected(pid, amount)
  local invid, slot = player.get_inventory(pid);
  local itemid, count = inventory.get(invid, slot);
  ---@diagnostic disable-next-line: undefined-field
  inventory.set(invid, slot, itemid, math.clamp(-amount, -count, -1))
end

local worldtime = 0;
events.on("not_utils:world_tick", function()
  worldtime = worldtime + 1;
end)
events.on("not_utils:world_open", function()
  worldtime = 0;
end)

---Количество прошедших секунд с открытия мира. Итерируется относительно проведённого времени в игре, при паузе не тикает.
---@return number
function time.worldtime()
  return worldtime / 20;
end

---Проверяет стоит ли игрок на земле
---@param pid number
---@return boolean
function player.is_on_ground(pid)
  local entid = player.get_entity(pid);
  local entity = entities.get(entid);
  return entity.rigidbody:is_grounded();
end

-- Не важно что эти функции уже есть в нейтроне, я рассчитываю что без нейтрона моды на not_utils тоже будут шикарно работать

function table.to_arr(tbl, pattern)
  local res = {}
  for i, val in ipairs(pattern) do res[i] = tbl[val] end
  return res
end

function table.to_dict(tbl, pattern)
  local res = {}
  for i, val in ipairs(pattern) do res[val] = tbl[i] end
  return res
end

function tohex(n)
  return string.format("%x", n)
end
