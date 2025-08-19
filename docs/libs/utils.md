# Модуль *utils*

Добавляет различные полезные функции.

## Импортирование и пример

```lua
-- Импортируем not_utils и из него опять утилиты (странно как то получается).
local utils = require "not_utils:main".utils;

-- А дальше читайте доки функций.
```

## Функции

```lua
-- Парсит строку и возвращает функцию
function utils.parse_function_string(str: string): fun(...)

-- Выполняет функцию с некоторым шансом
function utils.random_cb(chance: number, cb: func): any

-- Возвращает идентификатор предмета вне зависимости является ли он блоком или предметом
function utils.index_item(itemname: string): number | nil
```

[Вернуться на главную](../index.md)
