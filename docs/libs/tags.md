# Модуль *tags*

Позволяет читать теги предметов/блоков. Полезно для крафтов и остальных случаев, когда нужно выделить определённый ряд предметов по определённому признаку.

## Импортирование и пример

```lua
local tags = require "not_utils:main".tags;

local blocks = tags.get_blocks_by_tags("lamps");
  
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
-- Получает идентификаторы предметов, у которых есть один из тегов.
function api.get_items_by_tags(...: string): integer[]

-- Получает теги по идентификатору предмета.
function api.get_tags_by_itemid(itemid: integer): string[]

-- Получает идентификаторы предметов, у которых есть все перечисленные теги.
function api.get_items_have_tags(...: string): integer[]

-- Добавляет теги предмету по указанному идентификатору.
function api.add_tags_to_item(itemid: integer, ...: string)
```

### Блоки

```lua
-- Получает идентификаторы блоков, у которых есть один из тегов.
function api.get_blocks_by_tags(...: string): integer[]

-- Получает теги по идентификатору блока.
function api.get_tags_by_blockid(blockid: integer): string[]

-- Получает идентификаторы блоков, у которых есть все перечисленные теги.
function api.get_blocks_have_tags(...: string): integer[]

-- Добавляет теги блоку и его предмету по указанному идентификатору.
function api.add_tags_to_block(blockid: integer, ...: string)
```

## Добавление своих тегов

Для задуманного создайте блок и впишите туда следующее

```json
{
  "not_utils:tags@append": [ "Уже здесь указывайте новые теги" ]
}
```

[Вернуться на главную](../index.md)
