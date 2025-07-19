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
  if not entity then return true end
  return entity.rigidbody:is_grounded();
end

---Проверка на возможность добавления предмета в инвентарь.
---@param itemid int
---@param count int
---@param invid int
---@param data? { invsize?: int, stacksize?: int }
function inventory.can_add_item(itemid, count, invid, data)
  data = data or {};

  local size = data.invsize or inventory.size(invid);
  local stack = data.stacksize or item.stack_size(itemid);

  for slot = 0, size - 1 do
    local _itemid, _count = inventory.get(invid, slot);
    if _itemid ~= 0 then
      if itemid == _itemid and (_count + count) <= stack then
        return true;
      end
    else
      return true;
    end
  end

  return false;
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

function table.reverse(tbl)
  local t = {};

  for key, value in ipairs(tbl) do
    t[#tbl - key + 1] = value;
  end

  return t;
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

---Проверяет равнозначность векторов
---@param veca vecN
---@param vecb vecN
---@return bool
local function vec_equals(veca, vecb)
  if #veca ~= #vecb then return false end

  for index, value in ipairs(veca) do
    if value ~= vecb[index] then
      return false
    end
  end

  return true
end

vec4.equals = vec_equals;
vec3.equals = vec_equals;
vec2.equals = vec_equals;
