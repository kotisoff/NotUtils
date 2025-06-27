-- Здесь хоронятся разные функции, дополняющие основные библиотеки.
-- Посему явного модуля здесь нет и не будет.

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

---@param num number
---@param digits number Number of digits after comma.
---@return number
function math.round_to(num, digits)
  local accuracy = 10 ^ digits;
  return (math.floor(num) * accuracy) / accuracy
end
