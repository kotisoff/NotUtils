# Модуль *stdlib_addon*

Добавляет различные глобальные функции и дополняет основные библиотеки.

## Функции

```lua
-- Количество прошедших секунд с открытия мира. Итерируется относительно проведённого времени в игре, при паузе не тикает.
function time.worldtime(): number

-- Проверяет стоит ли игрок на земле
function player.is_on_ground(pid: int): boolean

-- Проверка на возможность добавления предмета в инвентарь.
function inventory.can_add_item(itemid: int, count: int, invid: int, data?: { invsize?: int, stacksize?: int }): boolean

-- Преобразует таблицу в массив значений по паттерну ключей
function table.to_arr(tbl: table, pattern: table, ignored_symb?: str): any[]

-- Преобразует массив значений в таблицу по паттерну ключей
function table.to_dict(tbl: table, pattern: table, ignored_symb?: str): table

-- Разворачивает таблицу
function table.reverse(tbl: table): table

-- Возвращает массив ключей таблицы
function table.keys(tbl: table): string[]

-- Превращает число в hex значение
function tohex(n: number): string

-- Округляет число до digits чисел после запятой
function math.round_to(num: number, digits: integer): number

-- Проверяет равны ли векторы
function vector.equals(veca: vector, vecb: vector): boolean

-- Округляет вектор до нижнего значения
function vector.floor(vec: vector): vector
```
