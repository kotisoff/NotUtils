# Модуль *BitBuffer*

Модуль, который позволяет объявить объект BitBuffer'а, который хранит в себе массив бит и позволяет легко получать или добавлять разные значения побитово или побайтово.

## Импортирование и пример

```lua
-- Импортируем not_utils и из него буффер
local buf = require "not_utils:main".BitBuffer

-- Создадим новый инстанс буффера
local buffer = buf:new()

-- Теперь можно пользоваться буффером
```

## Поля

```lua
-- Текущая позиция в битах (начиная с 1)
buffer.pos

-- Текущий незавершённый байт (в который пишутся биты)
buffer.current

-- Массив всех полностью заполненных байтов (Bytearray или таблица)
buffer.bytes
```

## Методы на запись (побитовая)

```lua
-- Добавляет один бит (true/false или 1/0)
buffer:put_bit(bit: boolean)

-- Добавляет беззнаковое целое число заданной битовой длины (1–64)
buffer:put_uint(num: number, width: number)
```

## Методы на запись (побайтовая и типизированная)

Эти методы автоматически выравнивают позицию до границы байта и записывают данные как в обычном DataBuffer.

```lua
-- Записывает сырые байты из таблицы или Bytearray
buffer:put_bytes(bytes: table|Bytearray)

-- Записывает байт (0–255)
buffer:put_byte(byte: number)

-- Записывает uint16 (0–65535)
buffer:put_uint16(value: number)

-- Записывает uint24 (0–16777215)
buffer:put_uint24(value: number)

-- Записывает uint32 (0–4294967295)
buffer:put_uint32(value: number)

-- Записывает int16, int32, int64
buffer:put_sint16(value: number)
buffer:put_sint32(value: number)
buffer:put_int64(value: number)

-- Записывает нормализованные float (–1.0 .. 1.0)
buffer:put_norm8(value: number)   -- 8-битный  [-1.0; 1.0]
buffer:put_norm16(value: number)  -- 16-битный [-1.0; 1.0]

-- Записывает float/double
buffer:put_float16(value: number)  -- half-precision
buffer:put_float32(value: number)  -- single
buffer:put_float64(value: number)  -- double

-- Записывает строку UTF-8 (завершается байтом 255)
buffer:put_string(str: string)

-- Записывает boolean
buffer:put_bool(value: boolean)

-- Универсальная запись любого поддерживаемого значения с префиксом типа
buffer:put_any(value: any)
```

## Методы на чтение (побитовая)

```lua
-- Читает один бит
buffer:get_bit() -> boolean

-- Читает беззнаковое целое заданной битовой длины
buffer:get_uint(width: number) -> number
```

## Методы на чтение (побайтовая и типизированная)

```lua
buffer:get_bytes(count: number?) -> Bytearray|table
buffer:get_byte() -> number
buffer:get_uint16() -> number
buffer:get_uint24() -> number
buffer:get_uint32() -> number
buffer:get_sint16() -> number
buffer:get_sint32() -> number
buffer:get_int64() -> number
buffer:get_norm8() -> number
buffer:get_norm16() -> number
buffer:get_float16() -> number
buffer:get_float32() -> number
buffer:get_float64() -> number
buffer:get_string() -> string
buffer:get_bool() -> boolean

-- Универсальное чтение значения с префиксом типа
buffer:get_any() -> any
```

## Методы работы с позицией

```lua
-- Возвращает текущую позицию в битах
buffer:get_position() -> number

-- Устанавливает позицию в битах
buffer:set_position(pos: number)

-- Смещает позицию на указанное количество бит
buffer:move_position(step: number)

-- Выравнивает позицию до следующей границы байта (дописывает нули)
buffer:next()

-- Сброс позиции в начало
buffer:reset()
```

## Другие методы

```lua
-- Принудительно сбрасывает текущий незавершённый байт в буфер (добавляет его, даже если он не полный)
-- Рекомендуется вызывать в конце записи
buffer:flush()

-- Возвращает текущее количество полных байтов в буфере
buffer:size() -> number

-- Возвращает все байты (включая незавершённый, если он есть) как Bytearray
-- Если передан count — читает указанное количество байтов побитово
buffer:get_bytes(count: number?) -> Bytearray

-- Заменяет внутренний массив байтов
buffer:set_bytes(bytes: table|Bytearray)

-- Записывает содержимое другого BitBuffer/DataBuffer
buffer:put_buffer(other_buffer: BitBuffer|DataBuffer)
```

Остальные методы и поведение полностью совместимы с модулем [DataBuffer](https://github.com/MihailRis/voxelcore/blob/main/doc/ru/scripting/modules/core_data_buffer.md).

[Вернуться на главную](../index.md)