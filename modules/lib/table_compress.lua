---Модуль для сжатия/разжатия ключей таблицы. Полезно для передачи таблиц по сети, если наименования предсказуемы.
---@deprecated useless
local module = {}

---Рекурсивно сжимает ключи таблицы до минимально возможного количества символов.
---@param data table таблица для сжатия
---@param compressed table|nil не заполнять, используется в рекурсии
---@return table
function module.compress(data, compressed)
  if type(data) ~= "table" or is_array(data) then return data end

  compressed = compressed or {}

  for key, value in pairs(data) do
    i = 1
    local k = string.sub(key, 1, i)
    while compressed[k] do
      i = i + 1
      k = string.sub(key, 1, i)
    end

    local v = value
    if type(v) == "table" then
      v = module.compress(v, compressed[k])
    end
    compressed[k] = v
  end

  return compressed
end

---Разжимает таблицу сопоставляя ключи с ключами полноценной таблицы
---@param data table сжатая таблица
---@param origin table точно такая же таблица, но с полноценными наименованиями
---@param decompressed table|nil не заполнять, используется в рекурсии
---@return table
function module.decompress(data, origin, decompressed)
  if type(data) ~= "table" or is_array(data) then return data end

  decompressed = decompressed or {}

  local data_keys = {}
  for key, _ in pairs(data) do
    table.insert(data_keys, key)
  end
  table.sort(data_keys, function(a, b) return #a > #b end)

  for key, _ in pairs(origin) do
    for _, data_key in pairs(data_keys) do
      if not decompressed[key] and data_key == string.sub(key, 1, #data_key) then
        local value = data[data_key]
        if type(value) == "table" then
          value = module.decompress(data[data_key], origin[key], decompressed[key])
        end
        decompressed[key] = value
      end
    end
  end

  return decompressed
end

return module
