# Модуль *tags*

Позволяет читать теги предметов/блоков. Полезно для крафтов и остальных случаев, когда нужно выделить определённый ряд предметов по определённому признаку.

## Импортирование и пример

```lua
local tags = require "not_utils:main".tags;

local blocks = tags.get_blocks_by_tags("base:lamps");
  
for _, blockid in ipairs(blocks) do
  print(string.format("Привет, %s!", block.name(blockid))); -- Привет всем лампам!
end
```

## Методы

### Общие

```lua
-- Получает все теги.
function api.get_all_tags(): string[]

-- Получает копию регистра тегов.
function api.get_registry(): { items: table<string, integer[]>, blocks: table<string, integer[]> }
```

### Предметы

```lua
-- Получает идентификаторы предметов, у которых есть все теги или один из них, при true/false параметра strict соответственно.
function api.item.get_by_tags(strict: bool, ...: string): integer[]

-- Получает теги по идентификатору предмета.
function api.item.get_tags(itemid: integer): string[]

-- Добавляет теги предмету по указанному идентификатору. (В рантайме, не модифицирует файлы)
function api.item.add_tags(itemid: integer, ...: string)
```

### Блоки

```lua
-- Получает идентификаторы блоков, у которых есть все теги или один из них, при true/false параметра strict соответственно.
function api.block.get_by_tags(strict: bool, ...: string): integer[]

-- Получает теги по идентификатору блока.
function api.block.get_tags(blockid: integer): string[]

-- Добавляет теги блоку и его предмету по указанному идентификатору. (В рантайме, не модифицирует файлы)
function api.block.add_tags(blockid: integer, ...: string)
```

## Добавление своих тегов

[См. документацию движка](https://github.com/MihailRis/voxelcore/blob/main/doc/ru/block-properties.md#%D1%82%D0%B5%D0%B3%D0%B8---tags)

[Вернуться на главную](../index.md)
