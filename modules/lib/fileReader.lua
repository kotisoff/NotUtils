---@class nu.file_reader
---@field paths str[]
---@field buffer table<str, any>
local reader = {}
reader.__index = reader;

---Получает список файлов по указанному пути.
---@param path str
---@param options? { recursive?: bool }
---@param temp? table Parameter for recursion
function reader:list(path, options, temp)
  options = options or {};
  temp = temp or {};

  if not file.exists(path) then return self end;

  local files = file.list(path);

  for _, value in ipairs(files) do
    table.insert_unique(self.paths, value);

    if file.isfile(value) then
      self.buffer[value] = ""
    elseif options.recursive == true and not temp[value] then
      temp[value] = true;
      self:list(value, options, temp);
    end
  end

  return self;
end

---Читает файлы и опционально обрабатывает их.
---@param callback? fun(data: any, path: str): any | nil Функция для преобразования объекта.
function reader:read(callback)
  for path, _ in pairs(table.copy(self.buffer)) do
    if not file.exists(path) then goto continue end;

    local data = file.read(path);

    if callback then
      data = callback(data, path);
    end

    self.buffer[path] = data;

    ::continue::
  end

  return self;
end

---Очищает все данные.
function reader:clear()
  self.paths = {};
  self.buffer = {};

  return self;
end

---Фильтрует данные файлов через указанную функцию.
---@param callback fun(data: any, path: str, buffer: table<str, any>): bool Если true => объект остаётся в таблице; false => выбрасывается из таблицы
function reader:filter(callback)
  local buffer = {};

  for path, data in pairs(self.buffer) do
    if callback(data, path, self.buffer) then
      buffer[path] = data;
    else
      local index = table.index(self.paths, path);
      if index then
        table.remove(self.paths, index);
      end
    end
  end
  self.buffer = buffer;

  return self;
end

---Перебирает данные файлов и подставляет их в указанную функцию.
---@param callback fun(data: any, path: str, buffer: table<str, any>): any | nil Функция для преобразования объекта.
---@param replace? boolean
function reader:for_each(callback, replace)
  local copy = table.copy(self.buffer);

  for path, data in pairs(copy) do
    local val = callback(data, path, copy);
    if replace then
      self.buffer[path] = val;
    end
  end

  return self;
end

---Фильтрует пути файлов через указанную функцию.
---@param callback fun(data?: any, path: str, buffer: table<str, any>): bool Если true => объект остаётся в таблице; false => выбрасывается из таблицы
function reader:filter_paths(callback)
  local c_buffer, c_paths = self:values();
  local paths = {};

  for index, path in pairs(c_paths) do
    local data = c_buffer[path];

    if callback(data, path, c_buffer) then
      paths[index] = path;
    else
      self.buffer[path] = nil;
    end
  end

  self.paths = paths;

  return self;
end

---Перебирает пути файлов и подставляет их в указанную функцию.
---@param callback fun(data?: any, path: str, buffer: table<str, any>): any | nil Функция для преобразования объекта.
---@param replace? boolean
function reader:for_each_path(callback, replace)
  local copy = table.copy(self.paths);

  for _, path in pairs(copy) do
    local data = self.buffer[path];

    local val = callback(data, path, copy);
    if replace then
      self.buffer[path] = val;
    end
  end

  return self;
end

---Возвращает значения fs_reader.
---@return table<str, any> buffer, str[] paths
function reader:values()
  local buffer = table.deep_copy(self.buffer);
  local paths = table.deep_copy(self.paths);

  return buffer, paths;
end

local module = {}

---Создаёт новый экземпляр fs_reader.
function module.new()
  return setmetatable({ paths = {}, buffer = {} }, reader);
end

return module;
