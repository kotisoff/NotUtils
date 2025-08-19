# Модуль *table_compress*

Модуль для сжатия/разжатия ключей таблицы. Полезно для передачи таблиц по сети, если наименования предсказуемы.

## Импортирование и пример

```lua
local table_compress = require "not_utils:main".table_compress;

local t = {
  aboba = 1,
  ogo = 10,
  goida = 11,
  e = {
    ahu = "et",
    eb = "anuca"
  }
}

local t2 = {
  aboba = 0,
  ogo = 1,
  goida = 2,
  e = {
    ahu = 0,
    eb = -0
  }
}
  
local compressed = table_compress.compress(t);

local decompressed = table_compress.decompress(compressed, t2);
```

## Методы

```lua
-- Рекурсивно сжимает ключи таблицы до минимально возможного количества символов.
table_compress.compress(data: table): table

-- Разжимает таблицу сопоставляя ключи с ключами полноценной таблицы
table_compress.decompress(data: table, origin: table): table
```

[Вернуться на главную](../index.md)
