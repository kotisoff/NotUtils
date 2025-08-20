# Модуль *event_provider*

Позволяет создать объект с ивентами определённого пака. Самостоятельно не предоставляет ивенты, но пару автодополнений есть (их нужно имитировать самим).
Полезен, когда не удобно каждый раз прописывать чё то типа `events.emit("packid:event")`.
Работает на движковых ивентах и соответственно аналогично им.

## Импортирование и пример

```lua
-- Импортируем not_utils и из него ивент провайдер
local EventProvider = require "not_utils:main".EventProvider;

-- Создадим новый инстанс ивентов
local my_events = EventProvider.new("my_pack");

-- Доббавляем листенер
my_events.on("my_event", function(...)
  print(...); -- 1 2 3
  return { ... };
end);

-- Эмитим ивент и выводим результат
local result = my_events.emit("my_event", 1, 2, 3);
print(unpack(result)) -- 1 2 3
```

## Поля

```lua
-- Хранит в себе идентификатор пака, который фигурирует в ивентах. (Изменение ничего не даст, даже не пытайтесь)
my_events.pack_id: str
```

## Методы

```lua
-- Эмитит ивент и возвращает результат.
function my_events.emit(event: str, ...: any): any

-- Добавляет листенер ивента
function my_events.on(event: str, func: fun(...): any)
```

[Вернуться на главную](../index.md)
