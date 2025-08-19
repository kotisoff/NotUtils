# Модуль *logger*

## Импортирование и пример

```lua
-- Импортируем not_utils и из него логгер
local Logger = require "not_utils:main".Logger;

-- Создадим новый инстанс логгера
local logger = Logger.new("TestLogger");

-- Теперь можно пользоваться логгером.
```

## Поля

```lua
-- Содержит имя логгера
logger.name

-- Содержит историю логов
logger.history
```

### Уровни логов

```lua
-- Содержит все уровни логов и комментарии к ним
logger.levels
```

Уровней логов всего 4:

- **I** - Info
- **W** - Warn
- **E** - Error
- **S** - Silent

## Методы

```lua
-- Добавляет данные в таблицу history.
function logger.log(LogLevel: "I" | "W" | "E" | "S", ...: any)

-- Выводит всю историю логов в консоль разом, не последовательно, а одним многострочным сообщением.
function logger.print()

-- Очищает историю логов
function logger.clear_history()

-- Выводит данные напрямую в консоль.
function logger.println(...: any)
```

[Вернуться на главную](../index.md)
