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

local max_world_height = 255;

---@param x number
---@param z number
---@param check_solid? bool
function block.get_highest_block_y(x, z, check_solid)
  local y = max_world_height;

  while check_solid and (not block.is_solid_at(x, y, z)) or (block.get(x, y, z) == 0) do
    y = y - 1;
  end

  return y;
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

---@param tbl table
---@param pattern table
---@param ignored_symb? str
function table.to_arr(tbl, pattern, ignored_symb)
  local res = {}
  for i, val in ipairs(pattern) do res[i] = tbl[val] or ignored_symb end
  return res
end

---@param tbl table
---@param pattern table
---@param ignored_symb? str
function table.to_dict(tbl, pattern, ignored_symb)
  local res = {}
  for i, val in ipairs(pattern) do res[val] = tbl[i] ~= ignored_symb and tbl[i] or nil end
  return res
end

---@param tbl table
function table.reverse(tbl)
  local t = {};

  for key, value in ipairs(tbl) do
    t[#tbl - key + 1] = value;
  end

  return t;
end

---@param tbl table
function table.keys(tbl)
  local keys = {};

  for key, _ in pairs(tbl) do
    table.insert(keys, key);
  end

  return keys;
end

---@param n number
function tohex(n)
  return string.format("%x", n)
end

---Проверяет равнозначность векторов
---@param veca vector
---@param vecb vector
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

---Округляет значения вектора до нижнего значения
---@param vec vector
local function vec_floor(vec)
  local t

  for index, value in ipairs(vec) do
    t[index] = math.floor(value);
  end

  return t;
end

---Возвращает тип значения, лежащего в строке и функцию для его парсинга
---@param str string
---@return string, function
function string.type(str)
    if not str then
        return "nil", function (s)
            if s then
                return s
            end
        end
    end

    str = str:lower()

    if tonumber(str) then
        return "number", tonumber
    elseif str == "true" or str == "false" then
        return "boolean", function(s) return s:lower() == "true" end
    elseif pcall(json.parse, str) then
        return "table", json.parse
    end

    return "string", tostring
end

---Удаляет кавычки из строки
---@param str string
---@return string
function string.trim_quotes(str)
    if str:sub(1, 1) == "'" or str:sub(1, 1) == '"' then
        str = str:sub(2)
    end

    if str:sub(-1) == "'" or str:sub(-1) == '"' then
        str = str:sub(1, -2)
    end

    return str
end

---Разделяет строку по пробелам, обращая внимание на ккавычки и скобки
---@param str string
---@return table
function string.soft_space_split(str)
    local result = {}
    local current = {}
    local in_quotes = false
    local bracket_level = 0
    local brace_level = 0

    for i = 1, #str do
        local char = str:sub(i, i)

        if char == '"' and bracket_level == 0 and brace_level == 0 then
            in_quotes = not in_quotes
            table.insert(current, char)
        elseif not in_quotes then
            if char == '[' then
                bracket_level = bracket_level + 1
            elseif char == ']' then
                bracket_level = bracket_level - 1
            elseif char == '{' then
                brace_level = brace_level + 1
            elseif char == '}' then
                brace_level = brace_level - 1
            elseif char == ' ' and bracket_level == 0 and brace_level == 0 then
                if #current > 0 then
                    table.insert(result, table.concat(current))
                    current = {}
                end
                goto continue
            end
            table.insert(current, char)
        else
            table.insert(current, char)
        end

        ::continue::
    end

    if #current > 0 then
        table.insert(result, table.concat(current))
    end

    return result
end

vec4.equals = vec_equals;
vec3.equals = vec_equals;
vec2.equals = vec_equals;

vec4.floor = vec_floor;
vec3.floor = vec_floor;
vec2.floor = vec_floor;
