# Модуль *title*

Позволяет вывести информацию непосредственно на экран в трёх режимах: actionbar, title и subtitle.

## Импортирование и пример

```lua
-- Импортируем not_utils и из него титле
local title = require "not_utils:main".title;

-- Выводим текст на экран
title.title:show("Miau");
```

## Методы

```lua
-- Показывает текст на экране прямо над полосками здоровья.
title.actionbar:show(
  -- Текст.
  text: string,
  -- Опционально. Кол-во секунд текста на экране.
  show_time: number|nil,
  -- Опционально. Функция, которая будет сразу убирать текст, если возвращает true.
  breakfunc: function|nil
)

-- Показывает текст на экране посередине. Аргументы аналогичны actionbar.
function title.title:show(text: string, show_time: number|nil, breakfunc: function|nil)

-- Показывает текст на экране чуть ниже середины. Аргументы аналогичны actionbar.
function title.subtitle:show(text: string, show_time: number|nil, breakfunc: function|nil)
```

## Дополнение

Все типы текста на экране.

```lua
title.types
```

```lua
-- Устанавливает прозрачность элементу name в xml title от 0 до 255.
function title.utils.set_opacity(name: string, opacity: number)
```

[Вернуться на главную](../index.md)
