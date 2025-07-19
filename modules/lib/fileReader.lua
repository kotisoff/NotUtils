---@class not_utils.libs.FileReader_instance
---@field files str[]
---@field buffer table<str, any>
local reader = {}
reader.__index = reader;

---Получает список файлов по указанному пути.
---@param path str
---@param options? { recursive?: bool }
function reader:list(path, options)
  options = options or {};

  if not file.exists(path) then return self end;

  local files = file.list(path);

  for _, value in ipairs(files) do
    table.insert(self.files, value);
    if file.isfile(value) then self.buffer[value] = "" end

    if options.recursive == true then
      if file.isdir(value) then
        self:list(value, options);
      end
    end
  end

  return self;
end

---Читает файлы и опционально обрабатывает их через map.
---@param callback? fun(data: any, path: str, buffer: table<str, any>): any | nil Функция для преобразования объекта.
function reader:read(callback)
  for path, _ in pairs(self.buffer) do
    if not file.exists(path) then goto continue end;

    self.buffer[path] = file.read(path);

    ::continue::
  end

  if callback then
    return self:map(callback);
  else
    return self;
  end
end

---Очищает все данные.
function reader:clear()
  self.files = {};
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
      local index = table.index(self.files, path);
      table.remove(self.files, index);
    end
  end
  self.buffer = buffer;

  return self;
end

---Перебирает данные файлов и преобразует их через указанную функцию.
---@param callback fun(data: any, path: str, buffer: table<str, any>): any | nil Функция для преобразования объекта.
function reader:map(callback)
  local copy = table.copy(self.buffer);

  for path, data in pairs(copy) do
    local val = callback(data, path, copy);
    self.buffer[path] = val;
  end

  return self;
end

---Перебирает данные файлов и подставляет их в указанную функцию.
---@param callback fun(data: any, path: str, buffer: table<str, any>): any | nil Функция для преобразования объекта.
function reader:for_each(callback)
  local copy = table.copy(self.buffer);

  for path, data in pairs(copy) do
    callback(data, path, copy);
  end

  return self;
end

---Уничтожает объект и возвращает его значение.
---@return table<str, any>, str[]
function reader:destroy()
  local buffer = table.copy(self.buffer);
  local files = table.copy(self.files);

  self = nil;
  return buffer, files;
end

local module = {}

---Создаёт новый экземпляр fs_reader.
function module.new()
  return setmetatable({ files = {}, buffer = {} }, reader);
end

return module;
