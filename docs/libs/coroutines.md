# Модуль *coroutines*

Обычная обёртка над корутинами. Добавляет бафнутый sleep (с дополнительными параметрами) и интервал.
Устарел ввиду [модуля шедулера](https://github.com/MihailRis/voxelcore/blob/dev/res/modules/schedule.lua) в движке.

## Импортирование и пример

```lua
-- Импортируем not_utils и из него корутины
local cor = require "not_utils:main".coroutines;

-- Выводим текст на экран
cor.create(function()
  local status = cor.sleep(5, 
    { 
      time_function = time.worldtime,
      cycle_task = function(data, passed_time) print(passed_time); data.passed = passed_time end,
      break_function = function(data) return data.passed > 3 end
    }
  )

  print("Ого, false:", status);
end)
```

## Методы

```lua
-- Создаёт корутину и постоянно её продлевает.
function cor.create(func: function): thread

-- Задерживает корутину и имеет много параметров. Также возвращает true или false в зависимости была ли задержка оборвана.
function cor.sleep(seconds: number,
  options: { 
    time_function: fun(): number, -- Функция для отсчёта времени
    break_function: fun(temp: table): boolean, -- Если возвращает true, то sleep обрывается
    cycle_task: fun(temp: table, passed_time: number) -- Задача, которая будет выполняться всё время до конца или обрывания
  }
): boolean
```

[Вернуться на главную](../index.md)
