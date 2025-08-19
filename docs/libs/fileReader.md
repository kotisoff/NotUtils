# Модуль *FileReader*

Позволяет удобно читать большое количество файлов.

## Импортирование и пример

```lua
-- Импортируем not_utils и из него ридер
local Reader = require "not_utils:main".FileReader;

-- Создадим новый инстанс ридера
local reader = Reader.new();

-- Читаем файлы
local buffer, files = reader
  :list("./", { recursive = true })
  :filter(function(data, path, buffer) return file.stem(path) == "json" end)
  :read(function(data, path, buffer) return json.parse(data) end)
  :destroy();

-- В итоге получаем таблицу имя - данные json и массив всех прочитанных путей.
```

## Методы

```lua
-- Создаёт новый инстанс ридера
Reader.new(): ReaderInstance
```

```lua
--Получает список файлов по указанному пути.
function reader:list(path: str, options: { recursive?: bool }): self
```

```lua
-- Читает файлы и опционально обрабатывает их через map.
function reader:read(callback: fun(data: any, path: str, buffer: table<str, any>): any | nil): self
```

```lua
-- Очищает все данные.
function reader:clear(): self
```

```lua
-- Фильтрует данные файлов через указанную функцию.
function reader:filter(callback: fun(data: any, path: str, buffer: table<str, any>): bool): self
```

```lua
-- Перебирает данные файлов и преобразует их через указанную функцию.
function reader:map(callback: fun(data: any, path: str, buffer: table<str, any>): any | nil): self
```

```lua
-- Перебирает данные файлов и подставляет их в указанную функцию.
function reader:for_each(callback: fun(data: any, path: str, buffer: table<str, any>): any | nil): self
```

```lua
-- Уничтожает объект и возвращает его значение.
function reader:destroy(): table<str, any>, str[]
```

[Вернуться на главную](../index.md)
