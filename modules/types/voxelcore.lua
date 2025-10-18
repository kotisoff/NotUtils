--[[
  ВНИМАНИЕ
  Старайтесь не импортировать этот скрипт. Он работает просто находясь в поле зрения языкового сервера.
  При импорте он может сломать работу мода/модов, но защита от дебилов имеется.
  ]]

--[[
    VoxelCore Lua Types
    Engine version: 0.29-pre0.30
    Version: v0.0.6
    ]]

---@diagnostic disable: duplicate-doc-alias
---@diagnostic disable: duplicate-doc-field

-- =================aliases=and=shortcuts===================

-- Aliases

---@alias mat4 number[] Матрица трансформации размерностью 4x4.
---@alias quat number[] Кватернион
---@alias vector number[] Вектор любой длины
---@alias vec4 [number, number, number, number] Вектор размерностью 4
---@alias vec3 [number, number, number] Вектор размерностью 3
---@alias vec2 [number, number] Вектор размерностью 2
---@alias bytearray voxelcore.Bytearray|table<int> Массив байт. Собран на ffi и метатаблицах.

-- Short names

---@alias int integer
---@alias str string
---@alias bool boolean

-- =========================funcs===========================

---@type fun(x: table): bool Возвращает true, если переданная таблица является массивом, тоесть если каждый ключ это целое число больше или равное единице и если каждый ключ следует за прошлым.
is_array = is_array;

---@type fun(path: str): str, str Разбивает путь на две части и возвращает их: входную точку и путь к файлу.
parse_path = parse_path;

---@type fun(iters: int, func: function, ...) Вызывает функцию func iters раз, передавая ей аргументы ..., а после выводит в консоль время в микросекундах, которое прошло с момента вызова timeit.
timeit = timeit;

---@type fun(timesec: number) Вызывает остановку корутины до тех пор, пока не пройдёт количество секунд, указанное в timesec. Функция может быть использована только внутри корутины.
sleep = sleep;

---@type fun(co: thread): result: any, error: str Ожидает завершение переданной корутины, возвращая поток управления. Функция может быть использована только внутри корутины. Аналог *pcall*.
await = await;

---@type fun(bytes: bytearray): str Возвращает строковое представление массива байт
Bytearray_as_string = Bytearray_as_string;

---@type fun(...): bytearray Собирает аргументы в массив байт
Bytearray_construct = Bytearray_construct;

---@type fun(bytes: bytearray | str, chksum: int): int Вычисляет контрольную сумму массива байт
crc32 = crc32;

-- =========================math============================

---@class voxelcore.math
---@field clamp fun(_in: number, low: number, high: number): number Ограничивает число _in по лимитам low и high. Т.е.: Если _in больше чем high - вернётся high, если _in меньше чем low - вернётся low. В противном случае вернётся само число.
---@field rand fun(min: number, max: number): number Возвращает случайное дробное число в диапазоне от low до high.
---@field normalize fun(num: number, places?: number): number Возвращает нормализованное значение num относительно conf.
---@field round fun(num: number, places?: number): number Возвращает округлённое значение num до указанного количества знаков после запятой places.
---@field sum fun(...): number Возвращает сумму всех принимаемых аргументов.
---@field sum fun(x: number, t: number[]): number Возвращает сумму всех принимаемых аргументов.
---@field normal_random fun(): number Рандом из генератора в C++
math = math

-- =========================table===========================

---@class voxelcore.table
---@field copy fun(t: table): table Создаёт и возвращает копию переданной таблицы путём создания новой и копирования в неё всех элементов из переданной.
---@field deep_copy fun(t: table): table Функция глубокого копирования создает полную копию исходной таблицы, включая все её вложенные таблицы.
---@field count_pairs fun(t: table): int Возвращает количество пар в переданной таблице.
---@field random fun(t: table): any Возвращает один элемент из переданной таблицы на случайной позиции.
---@field has fun(t: table, x: any): bool Возвращает true, если x содержится в t.
---@field index fun(t: table, x: any): int Возвращает индекс обьекта x в t. Если переданный обьект не содержится в таблице, то функция вернёт значение -1.
---@field remove_value fun(t: table, x: any) Удаляет элемент x из t.
---@field shuffle fun(t: table): table Перемешивает значения в таблице.
---@field merge fun(t1: table, t2: table): table Добавляет в таблицу t1 значения из таблицы t2. Если в таблице t2 присутствует ключ из t1, то значение ключа не будет изменено.
---@field map fun(t: table, func: (fun(index: str | number, value: any): any)): table Проходится по таблице и применяет ко всем её элементам func, которая возвращает новое значение элемента.
---@field filter fun(t: table, func: (fun(index: str | number, value: any): bool)): table Проходится по таблице с помощью func, которая возвращает true если элемент надо сохранить и false, если его надо удалить.
---@field set_default fun(t: table, key: number | str, default: any): any Позволяет безопасно получать значение по указанному ключу. Если ключ существует в таблице, метод вернет его значение. Если ключ отсутствует, метод установит его со значением default и вернет его.
---@field flat fun(t: table): table Возвращает "плоскую" версию исходной таблицы.
---@field deep_flat fun(t: table): table Возвращает глубокую "плоскую" версию исходной таблицы.
---@field sub fun(arr: table, start?: number, stop?: number): table Возвращает обрезанную версию таблицы с индекса start до индекса stop включительно, при этом пары ключ-значение не сохраняются в новой таблице. При значениях nil начинает с 1 и заканчивает #arr соответственно.
---@field tostring fun(t: table): str Конвертирует переданную таблицу в строку.
table = table

-- ========================string===========================

---@class voxelcore.string
---@field explode fun(separator: str, str: str, withpattern: bool): str[] Разбивает строку str на части по указанному разделителю/выражению separator и возвращает результат ввиде таблицы из строк. Если withpattern равен true, то параметр separator будет определяться как регулярное выражение.
---@field split fun(str: str, delimeter: str): table<str> Разбивает строку str на части по указанному разделителю delimiter и возвращает результат ввиде таблицы из строк.
---@field pattern_safe fun(str: str): str Экранирует специальные символы в строке, такие как ()[]+-.$%^?* в формате %символ. Символ NUL (\0) будет преобразован в %z.
---@field formatted_time fun(seconds: number, format: str): str | table Разбивает секунды на часы, минуты и миллисекунды и форматирует в format с следующим порядком параметров: минуты, секунды, миллисекунды и после возвращает результат. Если format не указан, то возвращает таблицу, где: h - hours, m - minutes, s - seconds, ms - milliseconds.
---@field replace fun(str: str, tofind: str, toreplace: str): str Заменяет все подстроки в str, равные tofind на toreplace и возвращает строку со всеми измененными подстроками.
---@field trim fun(str: str, char: str): str Удаляет все символы, равные char из строки str с левого и правого конца и возвращает результат. Если параметр char не определен, то будут выбраны все пустые символы.
---@field trim_left fun(str: str, char: str): str Удаляет все символы, равные char из строки str с левого конца и возвращает результат. Если параметр char не определен, то будут выбраны все пустые символы.
---@field trim_right fun(str: str, char: str): str Удаляет все символы, равные char из строки str с правого конца и возвращает результат. Если параметр char не определен, то будут выбраны все пустые символы.
---@field starts_with fun(str: str, start: str): bool Возвращает true, если строка str начинается на подстроку start
---@field ends_with fun(str: str, endStr: str): bool Возвращает true, если строка str заканчивается на подстроку endStr
---@field escape fun(str: str): str Экранирует строку. Является псевдонимом utf8.escape.
---@field pad fun(str: str, size: number, char?: str): str Добавляет char слева и справа от строки, пока её размер не будет равен size. По стандарту char равен символу пробела
---@field left_pad fun(str: str, size: number, char?: str): str Добавляет char слева от строки, пока её размер не будет равен size. По стандарту char равен символу пробела
---@field right_pad fun(str: str, size: number, char?: str): str Добавляет char справа от строки, пока её размер не будет равен size. По стандарту char равен символу пробела
string = string

-- =======================coroutine=========================

---@class voxelcore.coroutine
---@field stop nil | (fun(co: thread): noerror: bool, errorobject: any)
coroutine = coroutine

-- ==========================os=============================

---@class voxelcore.os
---@field pid int Идентификатор процесса движка

-- =========================debug===========================

---@class voxelcore.libdebug
---@field print fun(...) Рекурсивно читает и выводит в консоль объект. Максимальная глубина: 10.
---@field error fun(message: str) Выводит в консоль сообщение в виде ошибки
---@field warning fun(message: str) Выводит в консоль сообщение в виде предупреждения
---@field log fun(message: str) Выводит в консоль сообщение
---@field count_frames fun(): int Выводит количество неких кадров
---@field get_traceback fun(start: int): debuginfo[] Возвращает трейсбек в виде массива debuginfo
---@field pause fun(reason: str, message: str)
---@field __pull_events nil | fun(): table Внутренняя функция. Осторожно, пошлёт вас лесом
---@field __sendvalue nil | fun(value: any, frame: int, local_index: int, keys: (str | nil)[]) Внутренняя функция. Осторожно, пошлёт вас лесом
---@field is_debugging fun(): bool
---@field set_breakpoint fun(source: int, line: int)
---@field remove_breakpoint fun(source: int, line: int)
debug = debug

-- ========================stdcomp==========================

---Сомнительная библиотека. Лучше использовать entities.
---@class voxelcore.stdcomp
---@field __reset fun() Удаляет все энтити (из lua, не связано напрямую с движком)
---@field get_Entity fun(eid: int): voxelcore.class.entity Возращает энтити по идентификатору
---@field get_all fun(eids?: int[]): table<int, voxelcore.class.entity> Возвращает все энтити по идентификаторам
---@field new_Entity fun(eid: int): voxelcore.class.entity Создаёт нового энтити (из lua, не связано напрямую с движком)
---@field remove_Entity fun(eid: int) Удаляет энтити (из lua, не связано напрямую с движком)
---@field render fun(delta: number) Вызывает все события on_render всех энтити
---@field update fun(tps: number, parts: number, part: number) Вызывает все события on_update всех энтити
stdcomp = stdcomp

-- =========================core============================

---Библиотека для управления работой движка. По идее скрытая, но доступна в скриптинге
---@class voxelcore.libcore
---@field blank fun() Ничего не делает. xD
---@field capture_output fun(func: function): str Перехватывает все принты и возвращает их в виде строки
---@field new_world fun(name: str, seed: str, generator: str, local_player?: int) Создаёт новый мир и открывает его.
---@field open_world fun(name: str) Открывает мир по названию.
---@field reopen_world fun() Переоткрывает мир.
---@field save_world fun() Сохраняет мир.
---@field close_world fun(save_world: bool) Закрывает мир.
---@field delete_world fun(name: str) Удаляет мир по названию.
---@field set_setting fun(name: str, value: any) Устанавливает значение настройки. Бросает исключение, если настройки не существует.
---@field get_setting_info fun(name: str): { def: any, min?: number, max?: number } Возвращает таблицу с информацией о настройке. Бросает исключение, если настройки не существует.
---@field get_version fun(): int, int Возвращает мажорную и минорную версии движка.
---@field is_content_loaded fun(): bool Проверяет, загружен ли контент.
---@field reset_content fun() Сбрасывает контент загруженных паков.
---@field load_content fun() Загружает контент конфигурированных паков.
---@field open_folder fun(path: str) Открывает движком папку по указанного пути
---@field open_url fun(url: str) Открывает URL в браузере
---@field quit fun() Завершает выполнение движка, выводя стек вызовов для ослеживания места вызова функции.
---@field reconfig_packs fun(add_packs: str[], remove_packs: str[]) Обновляет конфигурацию паков, проверяя её корректность (зависимости и доступность паков). Автоматически добавляет зависимости.
---@field get_setting fun(name: str): any Возвращает значение настройки. Бросает исключение, если настройки не существует.
---@field set_setting fun(name: str, value: any) Устанавливает значение настройки. Бросает исключение, если настройки не существует.
---@field str_setting fun(name: str): str Возвращает значение настройки в виде строки.
core = core

-- ==========================app============================

---Библиотека для высокоуровневого управления работой движка, доступная только в режиме сценария или теста.
---@class voxelcore.libapp Библиотека для высокоуровневого управления работой движка, доступная только в режиме сценария или теста.
---@field tick fun() Выполняет один такт основного цикла движка.
---@field sleep fun(time: number) Ожидает указанное время в секундах, выполняя основной цикл движка.
---@field sleep_until fun(predicate: (fun():bool), max_ticks?: number) Ожидает истинности утверждения (условия), проверяемого функцией, выполнячя основной цикл движка.
---@field quit fun() Завершает выполнение движка, выводя стек вызовов для ослеживания места вызова функции.
---@field reconfig_packs fun(add_packs: str[], remove_packs: str[]) Обновляет конфигурацию паков, проверяя её корректность (зависимости и доступность паков). Автоматически добавляет зависимости.
---@field config_packs fun(packs: str[]) Обновляет конфигурацию паков, автоматически удаляя лишние, добавляя отсутствующие в прошлой конфигурации. Использует app.reconfig_packs.
---@field is_content_loaded fun(): bool Проверяет, загружен ли контент.
---@field new_world fun(name: str, seed: str, generator: str, local_player?: int) Создаёт новый мир и открывает его.
---@field open_world fun(name: str) Открывает мир по названию.
---@field reopen_world fun() Переоткрывает мир.
---@field save_world fun() Сохраняет мир.
---@field close_world fun(save_world: bool) Закрывает мир.
---@field delete_world fun(name: str) Удаляет мир по названию.
---@field get_version fun(): int, int Возвращает мажорную и минорную версии движка.
---@field get_setting fun(name: str): any Возвращает значение настройки. Бросает исключение, если настройки не существует.
---@field set_setting fun(name: str, value: any) Устанавливает значение настройки. Бросает исключение, если настройки не существует.
---@field get_setting_info fun(name: str): { def: any, min?: number, max?: number } Возвращает таблицу с информацией о настройке. Бросает исключение, если настройки не существует.
---@field reset_content fun() Сбрасывает контент загруженных паков.
---@field load_content fun() Загружает контент конфигурированных паков.
---@field script str
app = app

-- ========================base64===========================

---Библиотека для base64 кодирования/декодирования.
---@class voxelcore.libbase64
---@field encode fun(bytes: table | bytearray): str Кодирует массив байт в base64 строку
---@field decode fun(base64string: str, usetable?: bool): table | bytearray Декодирует base64 строку в ByteArray или таблицу чисел, если второй аргумент установлен на true
base64 = base64

-- =======================Bytearray=========================

---Класс FFIBytearray
---@class voxelcore.Bytearray
---@field append fun(self: bytearray, b: bytearray | int) Дополняет массив байт
---@field clear fun(self: bytearray) Очищает массив байт
---@field get_capacity fun(self: bytearray) Возвращает размер массива байт
---@field insert fun(self: bytearray, index_or_val: int, val?: int) Устанавливает или дополняет массив байт
---@field remove fun(self: bytearray, index: int, elements?: int) Удаляет elements или 1 значение из массива байт начиная с позиции index
---@field reserve fun(self: bytearray, new_capacity: int) Расширяет массив байт до new_capacity
---@field trim fun(self: bytearray) Устанавливает максимальный размер массива байт до настоящего размера

---@type voxelcore.Bytearray | (fun(...): bytearray)
Bytearray = Bytearray

-- ========================random===========================

---@class voxelcore.librandom.Random
---@field random fun(self: voxelcore.librandom.Random): number Генерирует случайное число в диапазоне [0..1)
---@field random fun(self: voxelcore.librandom.Random, n: number): number Генерирует случайное целое число в диапазоне [0..n]
---@field random fun(self: voxelcore.librandom.Random, a: number, b: number): number Генерирует случайное целое число в диапазоне [a..b]
---@field seed fun(self: voxelcore.librandom.Random, seed: number) Устанавливает сид генератора

---@class voxelcore.librandom
---@field random fun(): number Генерирует случайное число в диапазоне [0..1)
---@field random fun(n: number): number Генерирует случайное целое число в диапазоне [0..n]
---@field random fun(a: number, b: number) Генерирует случайное целое число в диапазоне [a..b]
---@field bytes fun(n: number): bytearray Генерирует случайный массив байт длиной n
---@field uuid fun(): str Генерирует UUID версии 4
---@field Random fun(seed?: number): voxelcore.librandom.Random Создаёт изолированный генератор с использованием сида.

-- =========================block===========================

---@class voxelcore.libblock.raycast_result
---@field block int id блока
---@field endpoint vec3 точка качания луча
---@field iendpoint vec3 позиция блока, которого касается луч
---@field length number длина луча
---@field normal vec3 вектор нормали поверхности, которой касается луч

---@class voxelcore.libblock.material
---@field breakSound str Звук разрушения
---@field placeSound str Звук установки
---@field stepsSound str Звук шагов
---@field hitSound str Звук удара
---@field name str Название материала

---@alias voxelcore.libblock.material.sounds
---| '"breakSound"' Звук разрушения
---| '"placeSound"' Звук установки
---| '"stepsSound"' Звук шагов
---| '"hitSound"' Звук удара

---Библиотека block.
---@class voxelcore.libblock Библиотека block.
---@field name fun(blockid: int): str Возвращает строковый id блока по его числовому id.
---@field index fun(name: str): int Возвращает числовой id блока, принимая в качестве агрумента строковый
---@field material fun(blockid: int): str Возвращает id материала блока.
---@field materials table<str, voxelcore.libblock.material> Таблица материалов по их полным именам (пример: base:carpet)
---@field properties table<int, table<str, any>> Таблица пользовательских свойств блоков (см. ../../block-properties.md)(git)
---@field caption fun(blockid: int): str  Возвращает название блока, отображаемое в интерфейсе.
---@field get fun(x: int, y: int, z: int): int Возвращает числовой id блока на указанных координатах. Если чанк на указанных координатах не загружен, возвращает -1.
---@field get_states fun(x: int, y: int, z: int): int Возвращает полное состояние (поворот + сегмент + доп. информация) в виде целого числа
---@field set_states fun(x: int, y: int, z: int, states: int) Устанавливает блоку полное состояние (поворот + сегмент + доп. информация) на заданных координатах.
---@field set fun(x: int, y: int, z: int, id: int, states?: int, cancel_update?: bool) Устанавливает блок с заданным числовым id и состоянием (0 - по-умолчанию) на заданных координатах.
---@field place fun(x: int, y: int, z: int, id: int, states?: int, playerid?: int) Устанавливает блок с заданным числовым id и состоянием (0 - по-умолчанию) на заданных координатах от лица игрока, вызывая событие on_placed.
---@field destruct fun(x: int, y: int, z: int, playerid?: int) Ломает блок на заданных координатах от лица игрока, вызывая событие on_broken.
---@field compose_state fun(state: [ int, int, int ]): int Собирает полное состояние в виде целого числа
---@field decompose_state fun(state: int): [int, int, int] Разбирает полное состояние на: вращение, сегмент, пользовательские биты
---@field is_solid_at fun(x: int, y: int, z: int): bool Проверяет, является ли блок на указанных координатах полным
---@field is_replaceable_at fun(x: int, y: int, z: int): bool Проверяет, можно ли на заданных координатах поставить блок (примеры: воздух, трава, цветы, вода)
---@field defs_count fun(): int Возвращает количество id доступных в загруженном контенте блоков
---@field get_picking_item fun(id: int): int Возвращает числовой id предмета, указанного в свойстве *picking-item*.
---@field raycast fun(start: vec3, dir: vec3, max_distance: number, dest?: str[], filter?: str[]): voxelcore.libblock.raycast_result | nil Бросает луч из точки start в направлении dir. Max_distance указывает максимальную длину луча. Аргумент filter позволяет указать какие блоки являются "прозрачными" для луча, прим.: {"base:glass","base:water"}. Для использования агрумент dest нужно чем-то заполнить (можно nil), это сделано для обратной совместимости. Функция возвращает таблицу с результатами или nil, если луч не касается блока. Для результата будет использоваться целевая (dest) таблица вместо создания новой, если указан опциональный аргумент.
---@field get_X fun(x: int, y: int, z: int): int, int, int Возвращает целочисленный единичный вектор X блока на указанных координатах с учётом его вращения (три целых числа). Если поворот отсутствует, возвращает 1, 0, 0
---@field get_X fun(id: int, rotation: int): int, int, int Возвращает целочисленный единичный вектор X блока на указанных координатах с учётом его вращения (три целых числа). Если поворот отсутствует, возвращает 1, 0, 0
---@field get_Y fun(x: int, y: int, z: int): int, int, int Возвращает целочисленный единичный вектор Y блока на указанных координатах с учётом его вращения (три целых числа). Если поворот отсутствует, возвращает 0, 1, 0
---@field get_Y fun(id: int, rotation: int): int, int, int Возвращает целочисленный единичный вектор Y блока на указанных координатах с учётом его вращения (три целых числа). Если поворот отсутствует, возвращает 0, 1, 0
---@field get_Z fun(x: int, y: int, z: int): int, int, int Возвращает целочисленный единичный вектор Z блока на указанных координатах с учётом его вращения (три целых числа). Если поворот отсутствует, возвращает 0, 0, 1
---@field get_Z fun(id: int, rotation: int): int, int, int Возвращает целочисленный единичный вектор Z блока на указанных координатах с учётом его вращения (три целых числа). Если поворот отсутствует, возвращает 0, 0, 1
---@field get_rotation fun(x: int, y: int, z: int): int Возвращает индекс поворота блока в его профиле вращения (не превышает 7).
---@field set_rotation fun(x: int, y: int, z: int, rotation: int) Устанавливает вращение блока по индексу в его профиле вращения.
---@field get_rotation_profile fun(id: int): str Возвращает имя профиля вращения (none/pane/pipe)
---@field is_extended fun(id: int): bool Проверяет, является ли блок расширенным.
---@field get_size fun(id: int): int, int, int Возвращает размер блока.
---@field is_segment fun(x: int, y: int, z: int): bool Проверяет является ли блок сегментом расширенного блока, не являющимся главным.
---@field seek_origin fun(x: int, y: int, z: int): int, int, int Возвращает позицию главного сегмента расширенного блока или исходную позицию, если блок не является расширенным.
---@field get_user_bits fun(x: int, y: int, z: int, offset: int, bits: int): int Возвращает выбранное число бит с указанного смещения в виде целого беззнакового числа
---@field set_user_bits fun(x: int, y: int, z: int, offset: int, bits: int, value: int) Записывает указанное число бит значения value в user bits по выбранному смещению
---@field get_hitbox fun(id: int, rotation_index: int): [vec3, vec3] Возвращает массив из двух векторов (массивов из 3 чисел): 1. Минимальная точка хитбокса 2. Размер хитбокса 3. Индекс поворота блока
---@field get_model fun(id: int): str Возвращает тип модели блока (block/aabb/custom/...)
---@field model_name fun(id: int): str Возвращает имя модели блока
---@field get_textures fun(id: int): [str, str, str, str, str, str] Возвращает массив из 6 текстур, назначенных на стороны блока
---@field set_field fun(x: int, y: int, z: int, name: str, value: bool|int|number|str, index?: int) Записывает значение в указанное поле блока. Бросает исключение при несовместимости типов, выходе за границы массива. Ничего не делает при отсутствии поля у блока
---@field get_field fun(x: int, y: int, z: int, name: str, index?: int): bool|int|number|str|nil Возвращает значение записанное в поле блока. Возвращает nil если поле не существует или ни в одно поле блока не было произведено записи. Бросает исключение при выходе за границы массива.
---@field get_variant fun(x: int, y: int, z: int): int Возвращает индекс варианта блока
---@field set_variant fun(x: int, y: int, z: int, index: int): int Устанавливает вариант блока по индексу
---@field has_tag fun(id: int, tag: str): bool Проверяет наличие тега у блока
---@field __get_tags fun(itemid: int): table<str, bool> Возвращает таблицу из тегов этого блока.
---@field reload_script fun(name: str) Перезагружает скрипт блока
block = block

-- =======================byteutil==========================

---Библиотека предоставляет функции для работы с массивами байт, представленными в виде таблиц или Bytearray
---@class voxelcore.libbyteutil Библиотека предоставляет функции для работы с массивами байт, представленными в виде таблиц или Bytearray.
---@field pack fun(format: str, ...): bytearray Возвращает массив байт, содержащий переданные значения, упакованные в соответствии со строкой формата. Аргументы должны точно соответствовать значениям, требуемым форматом.
---@field tpack fun(format: str, ...): table Возвращает массив байт, содержащий переданные значения, упакованные в соответствии со строкой формата. Аргументы должны точно соответствовать значениям, требуемым форматом.
---@field unpack fun(format: str, bytes: table|bytearray): ... Извлекает значения из массива байт, ориентируясь на строку формата.
byteutil = byteutil

-- ========================cameras==========================

---Библиотека предназначена для работы с камерами.
---@class voxelcore.class.camera
---@field get_index fun(self: voxelcore.class.camera): int Возвращает индекс камеры
---@field get_name fun(self: voxelcore.class.camera): str Возвращает имя камеры
---@field get_pos fun(self: voxelcore.class.camera): vec3 Возвращает позицию камеры
---@field set_pos fun(self: voxelcore.class.camera, pos: vec3) Устанавливает позицию камеры
---@field get_rot fun(self: voxelcore.class.camera): mat4 Возращает вращение камеры
---@field set_rot fun(self: voxelcore.class.camera, rot: mat4) Устанавливает вращение камеры
---@field get_zoom fun(self: voxelcore.class.camera): number Возвращает значение приближения камеры
---@field set_zoom fun(self: voxelcore.class.camera, zoom: number) Устанавливает значение приближения камеры
---@field get_fov fun(self: voxelcore.class.camera): number Возвращает угол поля зрения камеры по Y (в градусах)
---@field set_fov fun(self: voxelcore.class.camera, fov: number) Устанавливает угол поля зрения камеры по Y (в градусах)
---@field is_flipped fun(self: voxelcore.class.camera): bool Возвращает true если ось Y отражена
---@field set_flipped fun(self: voxelcore.class.camera, flipped: bool) Отражает ось Y при значении true
---@field is_perspective fun(self: voxelcore.class.camera): bool Проверяет, включен ли режим перспективы
---@field set_perspective fun(self: voxelcore.class.camera, perspective: bool) Включает/выключает режим перспективы
---@field get_front fun(self: voxelcore.class.camera): vec3 Возвращает вектор направления камеры
---@field get_right fun(self: voxelcore.class.camera): vec3 Возвращает вектор направления направо
---@field get_up fun(self: voxelcore.class.camera): vec3 Возвращает вектор направления вверх
---@field look_at fun(self: voxelcore.class.camera, point: vec3) Направляет камеру на заданную точку
---@field look_at fun(self: voxelcore.class.camera, point: vec3, lerp: number) Направляет камеру на заданную точку с фактором интерполяции

---@class voxelcore.libcameras
---@field get fun(name: str): voxelcore.class.camera Возвращает камеру по имени.
---@field get fun(index: int): voxelcore.class.camera Возвращает камеру по индексу.
cameras = cameras

-- =======================entities==========================

---Библиотека предназначена для работы с реестром сущностей.
---@class voxelcore.libentities Библиотека предназначена для работы с реестром сущностей.
---@field get fun(uid: int): voxelcore.class.entity Возвращает сущность по уникальному идентификатору.
---@field spawn fun(name: str, pos: vec3, args?: table<string, any>): voxelcore.class.entity Создает указанную сущность
---@field exists fun(uid: int): bool Проверяет наличие сущности по уникальному идентификатору
---@field get_def fun(uid: int): int Возвращает индекс определения сущности по UID
---@field def_name fun(uid: int): str Возвращает имя определения сущности по индексу (строковый ID)
---@field def_hitbox fun(uid: int): vec3 Возвращает значение свойства 'hitbox' сущности
---@field def_index fun(uid: int): int Возвращает индекс определения сущности по имени (числовой ID)
---@field defs_count fun(): int Возвращает число доступных определений сущностей
---@field get_all fun(): table Возвращает таблицу всех загруженных сущностей
---@field get_all fun(uids: int[]): table Возвращает таблицу загруженных сущностей по переданному списку UID
---@field get_all_in_box fun(pos: vec3, size: vec3): int[] Возвращает список UID сущностей, попадающих в прямоугольную область
---@field get_all_in_radius fun(center: vec3, radius: number): int[] Возвращает список UID сущностей, попадающих в радиус
---@field raycast fun(start: vec3, dir: vec3, max_distance: number, ignore: int, destination?: str[], filter?: str[]): voxelcore.libblock.raycast_result|table|nil Функция является расширенным вариантом block.raycast. Возвращает таблицу с результатами если луч касается блока, либо сущности.
---@field reload_component fun(name: str) Перезагружает скрипт энтити
entities = entities

-- =========================file============================

---Библиотека функций для работы с файлами
---@class voxelcore.libfile Библиотека функций для работы с файлами
---@field resolve fun(path: str): str Функция приводит запись точка_входа:путь (например user:worlds/house1) к обычному пути. (например C://Users/user/.voxeng/worlds/house1). Функцию не нужно использовать в сочетании с другими функциями из библиотеки, так как они делают это автоматически. Возвращаемый путь не является каноническим и может быть как абсолютным, так и относительным.
---@field read fun(path: str): str Читает весь текстовый файл и возвращает в виде строки
---@field readlines fun(path: str): str[] Читает весь текстовый файл и возвращает в виде массива строк
---@field read_bytes fun(path: str, usetable?: bool): bytearray|table Читает файл в массив байт. При значении usetable = false возвращает Bytearray вместо table.
---@field is_writeable fun(path: str): bool Проверяет, доступно ли право записи по указанному пути.
---@field write fun(path: str, text: str) Записывает текст в файл (с перезаписью)
---@field write_bytes fun(path: str, data: bytearray|table) Записывает массив байт в файл (с перезаписью)
---@field length fun(path: str): int Возвращает размер файла в байтах, либо -1, если файл не найден
---@field exists fun(path: str): bool Проверяет, существует ли по данному пути файл или директория
---@field isfile fun(path: str): bool Проверяет, существует ли по данному пути файл
---@field isdir fun(path: str): bool Проверяет, существует ли по данному пути директория
---@field mkdir fun(path: str): bool Создает директорию. Возвращает true если была создана новая директория
---@field mkdirs fun(path: str): bool Создает всю цепочку директорий. Возвращает true если были созданы директории.
---@field list fun(path: str): str[] Возвращает список файлов и директорий в указанной.
---@field list_all_res fun(path: str): str[] Возвращает список файлов и директорий в указанной без указания конкретной точки входа.
---@field find fun(path: str): str Ищет файл от последнего пака до res. Путь указывается без префикса. Возвращает путь с нужным префиксом. Если файл не найден, возвращает nil.
---@field remove fun(path: str): bool Удаляет файл. Возращает true если файл существовал. Бросает исключение при нарушении доступа.
---@field remove_tree fun(path: str): int Рекурсивно удаляет файлы. Возвращает число удаленных файлов.
---@field read_combined_list fun(path: str): table[] Совмещает массивы из JSON файлов разных паков.
---@field read_combined_object fun(path: str): table[] Совмещает объекты из JSON файлов разных паков.
---@field mount fun(path: str): str Монтирует ZIP-архив как файловой системе. Возвращает имя точки входа.
---@field unmount fun(mount_path: str): str Размонтирует точку входа.
---@field create_zip fun(dir: str, dest_file: str): str Создаёт ZIP-архив из содержимого указанной директории.
---@field name fun(path: str): str Извлекает имя файла из пути. Пример: world:data/base/config.toml -> config.toml.
---@field stem fun(path: str): str Извлекает имя файла из пути, удаляя расширение. Пример: world:data/base/config.toml -> config.
---@field ext fun(path: str): str Извлекает расширение из пути. Пример: world:data/base/config.toml -> toml.
---@field prefix fun(path: str): str Извлекает точку входа (префикс) из пути. Пример: world:data/base/config.toml -> world.
---@field parent fun(path: str): str Возвращает путь на уровень выше. Пример: world:data/base/config.toml -> world:data/base
---@field path fun(path: str): str Убирает точку входа (префикс) из пути. Пример: world:data/base/config.toml -> data/base/config.toml
---@field join fun(dir: str, path: str): str Соединяет путь. Пример: file.join("world:data", "base/config.toml) -> world:data/base/config.toml. Следует использовать данную функцию вместо конкатенации с /, так как префикс:/путь не является валидным.
---@field open fun(path: str, mode: str): voxelcore.class.io_stream Открывает поток для записи/чтения в файл по указанному пути. Режим может быть составлен из "r", "w", "b", а также "+" (для "w")
---@field open_named_pipe fun(path: str, mode: str): voxelcore.class.io_stream Открывает поток для записи/чтения в Named Pipe по указанному пути. Режим может быть составлен только из "r", "w", "b". `/tmp/` или `\\\\.\\pipe\\` добавлять не нужно - движок делает это автоматически.
---@field __open_descriptor fun(path: str, mode: str): int Создаёт поток
---@field __has_descriptor fun(descriptor: int): bool Проверяет наличие потока
---@field __read_descriptor fun(descriptor: int, max_len: int): bytearray Читает из потока
---@field __write_descriptor fun(descriptor: int, data: str) Пишет в поток
---@field __flush_descriptor fun(descriptor: int) Записывает все данные из write-буфера в поток
---@field __close_descriptor fun(descriptor: int): bool Закрывает поток
---@field __close_all_descriptors fun() Закрывает все потоки
file = file

-- ======================compression========================

---@class voxelcore.class.libcompression
---@field encode fun(data: bytearray, algorithm?: "gzip", usetable?: bool): bytearray
---@field decode fun(data: bytearray, algorithm?: "gzip", usetable?: bool): bytearray

-- =======================io_stream=========================


---@alias voxelcore.class.io_stream.data bytearray | int[] | str | str[]
---@alias voxelcore.class.io_stream.mode "default" | "yield" | "buffered"
---@alias voxelcore.class.io_stream.flushmode "all" | "buffer"

---@class voxelcore.class.io_stream
---@field is_binary_mode fun(self: voxelcore.class.io_stream): bool Возвращает true, если поток используется в двоичном режиме
---@field set_binary_mode fun(self: voxelcore.class.io_stream, flag: bool) Включает или выключает двоичный режим
---@field get_mode fun(self: voxelcore.class.io_stream): voxelcore.class.io_stream.mode Возвращает режим работы потока
---@field set_mode fun(self: voxelcore.class.io_stream, mode:  voxelcore.class.io_stream.mode) Задаёт режим работы потока. Выбрасывает ошибку, если передан неизвестный режим
---@field get_flush_mode fun(self: voxelcore.class.io_stream): voxelcore.class.io_stream.flushmode Возвращает режим работы flush
---@field set_flush_mode fun(self: voxelcore.class.io_stream, mode: voxelcore.class.io_stream.flushmode) Задаёт режим работы flush
---@field read fun(self: voxelcore.class.io_stream, arg?: int | str, use_table_or_trim?: bool): voxelcore.class.io_stream.data | ... Читает данные из потока. Читайте доки: https://github.com/MihailRis/voxelcore/blob/main/doc/ru/scripting/io_stream.md
---@field write fun(self: voxelcore.class.io_stream, arg: voxelcore.class.io_stream.data, ...) Записывает данные в поток. Читайте доки: https://github.com/MihailRis/voxelcore/blob/main/doc/ru/scripting/io_stream.md
---@field read_line fun(self: voxelcore.class.io_stream): str Читает одну строку с окончанием CRLF/LF из потока вне зависимости от двоичного режима
---@field write_line fun(self: voxelcore.class.io_stream, line: str) Записывает одну строку с окончанием LF в поток вне зависимости от двоичного режима
---@field read_fully fun(self: voxelcore.class.io_stream, useTable?: bool): voxelcore.class.io_stream.data Читает все доступные данные из потока. Читайте доки: https://github.com/MihailRis/voxelcore/blob/main/doc/ru/scripting/io_stream.md
---@field available fun(self: voxelcore.class.io_stream, length?: int): int | bool Если length определён, то возвращает true, если length байт доступно к чтению. Иначе возвращает false. Если не определён, то возвращает количество байт, которое можно прочитать
---@field get_max_buffer_size fun(self: voxelcore.class.io_stream): int Возвращает максимальный размер буферов
---@field set_max_buffer_size fun(self: voxelcore.class.io_stream, size: int) Задаёт новый максимальный размер буферов
---@field is_alive fun(self: voxelcore.class.io_stream): bool Возвращает true, если поток открыт на данный момент
---@field is_closed fun(self: voxelcore.class.io_stream): bool Возвращает true, если поток закрыт на данный момент
---@field close fun(self: voxelcore.class.io_stream) Закрывает поток
---@field flush fun(self: voxelcore.class.io_stream) Записывает все данные из write-буфера в поток в buffer/all flush-режимах. Вызывает ioLib.flush() в all flush-режиме

---@class voxelcore.class.io_stream.lib
---@field read fun(descriptor: int, max_len: int): bytearray Читает из потока
---@field write fun(descriptor: int, data: str) Пишет в поток
---@field flush fun(descriptor: int) Записывает все данные из write-буфера в поток
---@field is_alive fun(descriptor: int): bool Возвращает true, если поток открыт на данный момент
---@field close fun(descriptor: int) Закрывает поток

---@class voxelcore.class.io_stream.constructor
---@field new fun(descriptor: int, binaryMode: bool, ioLib: voxelcore.class.io_stream.lib, mode?: voxelcore.class.io_stream.mode, flushmode?: voxelcore.class.io_stream.flushmode): voxelcore.class.io_stream Создаёт новый поток с переданным дескриптором и использующим переданную I/O библиотеку. (Более подробно в core:io_stream.lua)
io_stream = io_stream

-- ===================data=serializers======================

---Библиотека содержит функции для сериализации и десериализации таблиц
---@class voxelcore.json
---@field tostring fun(object: table, human_readable?: bool): str Сериализует объект в JSON строку. При значении второго параметра true будет использовано многострочное форматирование, удобное для чтения человеком, а не компактное, использующееся по-умолчанию.
---@field parse fun(code: str): table Парсит JSON строку в таблицу.
json = json

---Библиотека содержит функции для сериализации и десериализации таблиц
---@class voxelcore.toml
---@field tostring fun(object: table): str Сериализует объект в TOML строку.
---@field parse fun(code: str): table Парсит TOML строку в таблицу.
toml = toml

---Библиотека содержит функции для сериализации и десериализации таблиц
---@class voxelcore.yaml
---@field tostring fun(object: table): str Сериализует объект в YAML строку.
---@field parse fun(code: str): table Парсит YAML строку в таблицу.
yaml = yaml

---Библиотека содержит функции для работы с двоичным форматом обмена данными vcbjson(git).
---@class voxelcore.bjson
---@field tobytes fun(object: table, compression?: bool): table|bytearray Кодирует таблицу в массив байт
---@field frombytes fun(code: table|bytearray): table Декодирует массив байт в таблицу
bjson = bjson

-- ====================gfx.blockwraps=======================

---Библиотека для работы с обертками блоков.
---@class voxelcore.libgfx.blockwraps Библиотека для работы с обертками блоков.
---@field wrap fun(position: vec3, texture: str): int Создаёт обертку на указанной позиции, с указанной текстурой. Возвращает id обёртки.
---@field unwrap fun(id: int) Удаляет обертку, если она существует.
---@field set_pos fun(id: int, position: vec3) Меняет позицию обёртки, если она существует.
---@field set_texture fun(id: int, texture: str) Меняет текстуру обёртки, если она существует.
local blockwraps = {}

-- =====================gfx.particles=======================

---@class voxelcore.class.particle
---@field texture?	str Текстура частицы.	
---@field frames? str[] Кадры анимации (массив имен текстур). Должны находиться в одном атласе.	
---@field lighting? bool Освещение.	
---@field collision? bool Обнаружение столкновений.	
---@field max_distance? number Максимальная дистанция от камеры, при которой происходит спавн частиц.	
---@field spawn_interval? number Интервал спавна частиц в секундах.	
---@field lifetime? number Среднее время жизни частиц в секундах.	
---@field lifetime_spread? number Максимальное отклонение времени жизни частицы (от 0.0 до 1.0).	
---@field velocity? vec3 Начальная линейная скорость частиц.	
---@field acceleration? vec3 Ускорение частиц.	
---@field explosion? vec3 Сила разлёта частиц при спавне.	
---@field size? vec3 Размер частиц.	
---@field size_spread? number Максимальное отклонение времени размера частиц.	
---@field angle_spread? number Максимальное отклонение начального угла поворота (от 0 до 1)	
---@field min_angular_vel? number Минимальная угловая скорость (радианы в сек.). Неотрицательное.	
---@field max_angular_vel? number Максимальная угловая скорость (радианы в сек.). Неотрицательное.	
---@field spawn_shape? "ball"|"sphere"|"box" Форма области спавна частиц. (ball/sphere/box)	
---@field spawn_spread? vec3 Размер области спавна частиц.	
---@field random_sub_uv? number Размер случайного подрегиона текстуры (1 - будет использована вся текстура).	

---Библиотека для упрпавления частицами.
---@class voxelcore.libgfx.particles Библиотека для упрпавления частицами.
---@field emit fun(origin: vec3|int, count: int, preset: voxelcore.class.particle, extension?: voxelcore.class.particle)
---@field stop fun(id: int)
---@field is_alive fun(id: int): bool
---@field get_origin fun(id: int): vec3|int
---@field set_origin fun(id: int, origin: vec3|int)
local particles = {}

-- ======================gfx.weather========================

---@class voxelcore.class.weather.fall
---@field texture? str Текстура осадков
---@field noise? str Шум осадков
---@field vspeed? number Вертикальная скорость осадков
---@field hspeed? number Максимальная горизонтальная скорость осадков	
---@field scale? number Масштаб UV развертки осадков	
---@field min_opacity? number Минимальный множитель alpha-канала осадков	
---@field max_opacity? number Максимальный множитель alpha-канала осадков	
---@field max_intencity? number Масимальная интенсивность осадков	
---@field opaque? bool Отключение полупрозрачности осадков	
---@field splash? voxelcore.class.particle Таблица настроек частиц всплесков от осадков	

---@class voxelcore.class.weather
---@field fall? voxelcore.class.weather.fall Осадки
---@field clouds? number Облачность
---@field fog_opacity? number Максимальная плотность тумана
---@field fog_dencity? number Плотность тумана
---@field fog_curve? number Кривая тумана
---@field thunder_rate? number Частота грома

---Библиотека для управления аудио/визуальными погодными эффектами.
---@class voxelcore.libgfx.weather Библиотека для управления аудио/визуальными погодными эффектами.
---@field change fun(weather: voxelcore.class.weather, time: number, name?: str) Плавно переключает погоду
---@field get_current fun(): str Возвращает имя пресета погоды
---@field get_current_data fun(): voxelcore.class.weather Возвращает копию таблицы настроек погоды
---@field get_fall_intensity fun(): number Возвращает текущую интенсивность осадков
---@field is_transition fun(): bool Проверяет, происходит ли в данный момент переключение погоды
local weather = {}

-- ======================gfx.text3d=========================

---@alias voxelcore.class.text3d.display_types "static_billboard" | "y_free_billboard" | "xy_free_billboard" | "projected"

---@class voxelcore.class.text3d
---@field display? voxelcore.class.text3d.display_types Формат отображения
---@field color? vec4 Цвет текста
---@field scale? number Масштаб
---@field render_distance? number Дистанция отрисовки текста
---@field xray_opacity? number Коэффициент видимости через препятствия (просвечивание)
---@field perspective? number Коэффициент перспективы

---Библиотека для управления 2D текстом в 3D пространстве
---@class voxelcore.libgfx.text3d Библиотека для управления 2D текстом в 3D пространстве
---@field show fun(position: vec3, text: str, preset: voxelcore.class.text3d, extension?: voxelcore.class.text3d): int Создаёт 3D текст, возвращая его id.
---@field hide fun(id: int) Удаляет 3D текст.
---@field get_text fun(id: int): str Геттер текста.
---@field set_text fun(id: int, text: str) Сеттер текста.
---@field get_pos fun(id: int): vec3 Геттер позиции текста.
---@field set_pos fun(id: int, pos: vec3) Сеттер позиции текста.
---@field get_axis_x fun(id: int): vec3 Геттер вектора X.
---@field set_axis_x fun(id: int, pos: vec3) Сеттер вектора X.
---@field get_axis_y fun(id: int): vec3 Геттер вектора Y.
---@field set_axis_y fun(id: int, pos: vec3) Сеттер вектора Y.
---@field set_rotation fun(id: int, rotation: mat4) Устанавливает вращение текста (Устанавливает повернутые вектора X,Y).
---@field update_settings fun(id: int, preset: voxelcore.class.text3d) Обновляет настройки отображения текста.
local text3d = {}

-- ====================gfx.posteffects======================

---Библиотека для работы с эффектами пост-обработки
---@class voxelcore.libgfx.posteffects Библиотека для работы с эффектами пост-обработки
---@field index fun(name: str): int Возвращает индекс слота эффектов по имени (пак:имя_слота). При отсутствии указанного слота возвращает -1
---@field set fun(slot: int, effect: str) Назначает эффект на слот
---@field get_intensity fun(slot: int): number Возвращает интенсивность эффекта (от 0.0 до 1.0). Если слот пуст, возвращает 0.0
---@field set_intensity fun(slot: int, intensity: number) Устанавливает интенсивность эффекта (от 0.0 до 1.0). Корректность обработки параметра между значениями 0.0 и 1.0 зависит от эффекта
---@field is_active fun(slot: int): bool Возвращает true если слот не пуст и интенсивность эффекта ненулевая
---@field set_params fun(params: table) Устанавливает значения параметров (директивы 'param')
---@field set_array fun(slot: int, name: str, data: str) Устанавливает значения в массив. slot: индекс слота эффектов; name: имя параметра (масссива); data: строка данных (используйте функцию Bytearray_as_string)
---@field set_effect fun(slot: int, name: str) Назначает эффект на слот
local posteffects = {}

-- ==========================gfx============================

---Библиотеки для работы с графическими эффектами
gfx = gfx or {
  text3d = text3d,
  blockwraps = blockwraps,
  weather = weather,
  particles = particles,
  posteffects = posteffects
}

-- ==========================gui============================

---Библиотека содержит функции для доступа к свойствам UI элементов. Вместо gui следует использовать объектную обертку, предоставляющую доступ к свойствам через мета-методы __index, __newindex: document
---@class voxelcore.libgui Библиотека содержит функции для доступа к свойствам UI элементов. Вместо gui следует использовать объектную обертку, предоставляющую доступ к свойствам через мета-методы __index, __newindex: document
---@field str fun(text: str, context: str): str Возращает переведенный текст.
---@field get_viewport fun(): [int, int] Возвращает размер главного контейнера (окна).
---@field get_env fun(document: str): table Возвращает окружение (таблица глобальных переменных) указанного документа.
---@field get_locales_info fun(): table<str, table> Возвращает информацию о всех загруженных локалях (res/texts/*).
---@field clear_markup fun(language: str, text: str): str Удаляет разметку из текста.
---@field escape_markup fun(language: str, text: str): str Экранирует разметку в тексте.
---@field alert fun(message: str, on_ok?: function) Выводит окно с сообщением. Не останавливает выполнение кода.
---@field confirm fun(message: str, on_confirm: function, on_deny?: function, yes_text?: str, no_text?: str) Запрашивает у пользователя подтверждение действия. Не останавливает выполнение кода.
---@field load_document fun(path: str, name: str, args: table): str Загружает UI документ с его скриптом, возвращает имя документа, если успешно загружен.
---@field getattr fun(docname: str, elementname: str, key: str): any Возвращает значение параметра элемента. (Лучше использовать класс Element или Document).
---@field setattr fun(docname: str, elementname: str, key: str, value: any) Устанавливает значение параметра элемента. (Лучше использовать класс Element или Document).
---@field template fun(name: str, params: table<str, any>): str Возвращает темплейт как строку xml элемента. (Параметры в xml'ке темплейта можно использовать с помощью "%{param_name}")
---@field str fun(text: str, context?: str): str Возвращает перевод строки.
---@field root voxelcore.ui.document.any Корневой UI документ
gui = gui

-- ==========================hud============================

---Библиотека hud
---@class voxelcore.libhud Библиотека hud
---@field _is_content_access fun(): bool Возвращает может ли игрок брать вещи из контент-панели в инвентаре
---@field _set_content_access fun(flag: bool) Переключает возможность игроку брать вещи из контент-панели в инвентаре
---@field _set_debug_cheats fun(flag: bool) Переключает возможность игроку использовать дебаг-читы из F3
---@field open_inventory fun() Открывает инвентарь.
---@field close_inventory fun() Закрывает инвентарь.
---@field open fun(layoutid: str, disablePlayerInventory?: bool, invid?: int): int Открывает инвентарь и UI. Если макет UI не существует - бросается исключение. Если invid не указан, создаётся виртуальный (временный) инвентарь. Возвращает invid или id виртуального инвентаря.
---@field open_block fun(x: int, y: int, z: int): int, str Открывает инвентарь и UI блока. Если блок не имеет макета UI - бросается исключение. Возвращает id инвентаря блока  (при *"inventory-size"=0* создаётся виртуальный инвентарь, который удаляется после закрытия), и id макета UI.
---@field show_overlay fun(layoutid: str, playerinv: bool, args?: table) Показывает элемент в режиме оверлея. Также показывает инвентарь игрока, если playerinv - **true**.  Через args можно указать массив значений параметров, что будут переданы в on_open показываемого оверлея.
---@field open_permanent fun(layout: str) Добавляет постоянный элемент на экран. Элемент не удаляется при закрытии инвентаря. Чтобы не перекрывать затенение в режиме инвентаря нужно установить z-index элемента меньшим чем -1. В случае тега inventory, произойдет привязка слотов к инвентарю игрока.
---@field close fun(layoutid: str) Удаляет элемент с экрана.
---@field get_block_inventory fun(): int Дает ID инвентаря открытого блока или 0.
---@field get_player fun(): int Дает ID игрока, к которому привязан пользовательский интерфейс.
---@field pause fun() Открывает меню паузы.
---@field resume fun() Закрывает меню паузы.
---@field is_paused fun(): bool Возвращает true если открыто меню паузы.
---@field is_inventory_open fun(): bool Возвращает true если открыт инвентарь или оверлей.
---@field set_allow_pause fun(flag: bool) Устанавливает разрешение на паузу. При значении false меню паузы не приостанавливает игру.
---@field hand_controller function Функция, управляющая именованным скелетом 'hand' (см. gfx.skeletons).
---@field reload_script fun(layout: str) Перезагружает скрипт лейаута
hud = hud

-- =========================input===========================

---@alias voxelcore.libinput.bindings
---| 'hud.inventory'
---| 'hud.chat'
---| 'camera.zoom'
---| 'camera.mode'
---| 'movement.forward'
---| 'movement.right'
---| 'movement.left'
---| 'movement.back'
---| 'movement.jump'
---| 'movement.crouch'
---| 'movement.cheat'
---| 'player.attack'
---| 'player.build'
---| 'player.destroy'
---| 'player.pick'
---| 'player.drop'
---| 'player.flight'
---| 'player.noclip'
---| 'player.fast_interaction'
---| 'chunks.reload'
---| 'devtools.console'
---| str

---Библиотека input
---@class voxelcore.libinput Библиотека input
---@field keycode fun(keyname: str): int Возвращает код клавиши по имени, либо -1
---@field mousecode fun(mousename: str): int Возвращает код кнопки мыши по имени, либо -1
---@field add_callback fun(bindname: voxelcore.libinput.bindings, callback: function, document?: table) Назначает функцию, которая будет вызываться при активации привязки. Можно привязать время жизни функции к UI контейнеру, вместо HUD. В таком случае, input.add_callback можно использовать до вызова on_hud_open.
---@field get_mouse_pos fun(): [int, int] Возвращает позицию курсора на экране.
---@field get_bindings fun(): str[] Возвращает названия всех доступных привязок.
---@field get_binding_text fun(bindname: str): str Возвращает текстовое представление кнопки по имени привязки.
---@field is_active fun(bindname: voxelcore.libinput.bindings): bool Проверяет активность привязки.
---@field set_enabled fun(bindname: voxelcore.libinput.bindings, flag: bool) Включает/выключает привязку до выхода из мира.
---@field is_pressed fun(code: str): bool Проверяет активность ввода по коду, состоящему из: 1. типа ввода: key (клавиша) или mouse (кнопка мыши) 2. код ввода: имя клавиши или имя кнопки мыши (left, middle, right)
---@field reset_bindings fun() Сбрасывает установленные бинды до стандартных
input = input

-- =======================inventory=========================

---Библиотека функций для работы с инвентарем.
---@class voxelcore.libinventory
---@field get fun(invid: int, slot: int): int, int Возвращает id предмета и его количество. id = 0 (core:empty) обозначает, что слот пуст.
---@field set fun(invid: int, slot: int, itemid: int, count: int) Устанавливает содержимое слота, удаляя содержащиеся данные.
---@field set_count fun(invid: int, slot: int, count: int) Устанавливает количество предмета в слоте не затрагивая данные при ненулевом значении аргумента.
---@field size fun(invid: int): int Возвращает размер инвентаря (число слотов). Если указанного инвентаря не существует, бросает исключение.
---@field add fun(invid: int, itemid: int, count: int, data?: table): int Добавляет предмет в инвентарь. Если не удалось вместить все количество, возвращает остаток.
---@field find_by_item fun(invid: int, itemid: int, range_begin?: int, range_end?: int, min_count?: int): int Возвращает индекс первого подходящего под критерии слота в заданном диапазоне. Если подходящий слот не был найден, возвращает nil
---@field get_block fun(x: int, y: int, z: int): int Функция возвращает id инвентаря блока. Если блок не может иметь инвентарь - возвращает 0.
---@field bind_block fun(invid: int, x: int, y: int, z: int) Привязывает указанный инвентарь к блоку.
---@field unbind_block fun(x: int, y: int, z: int) Отвязывает инвентарь от блока.
---@field remove fun(invid: int) Удаляет инвентарь.
---@field has_data fun(invid: int, slot: int, name: str): bool Проверяет наличие локального свойства по имени без копирования его значения. Предпочтительно для таблиц, но не примитивных типов.
---@field get_data fun(invid: int, slot: int, name: str): any Возвращает копию значения локального свойства предмета по имени или nil.
---@field set_data fun(invid: int, slot: int, name: str, value: any) Устанавливает значение локального свойства предмета по имени. Значение nil удаляет свойство.
---@field get_all_data fun(invid: int , slot: int): table<str, any> Возвращает копию таблицы всех локальных свойств предмета.
---@field create fun(size: int): int Создаёт инвентарь и возвращает id.
---@field clone fun(invid: int): int Создает копию инвентаря и возвращает id копии. Если копируемого инвентаря не существует, возвращает 0.
---@field move fun(invA: int, slotA: int, invB: int, slotB?: int) Перемещает предмет из slotA инвентаря invA в slotB инвентаря invB. invA и invB могут указывать на один инвентарь. slotB будет выбран автоматически, если не указывать явно. Перемещение может быть неполным, если стек слота заполнится.
---@field move_range fun(invA: int, slotA: int, invB: int, rangeBegin: int, rangeEnd?: int) Перемещает предмет из slotA инвентаря invA в подходящий слот, находящийся в указанном отрезке инвентаря invB. invA и invB могут указывать на один инвентарь. rangeBegin - начало отрезка. rangeEnd - конец отрезка. Перемещение может быть неполным, если доступные слоты будут заполнены.
---@field decrement fun(invid: int, slot: int, count?: int) Уменьшает количество предмета в слоте на 1.
---@field use fun(invid: int, slot: int) Уменьшает счётчик оставшихся использований / прочность предмета, создавая локальное свойство `uses` при отсутствии. Удаляет один предмет из слота при достижении нулевого значения счётчика. При отсутствии в JSON предмета свойства `uses` ничего не делает. См. свойство предметов `uses`
---@field get_caption fun(invid: int, slot: int): str Получает имя предмета в слоте
---@field set_caption fun(invid: int, slot: int, caption: str) Задает имя предмету в слоте
---@field get_description fun(invid: int, slot: int): str Получает описание предмета в слоте
---@field set_description fun(invid: int, slot: int, description: str) Задает описание предмету в слоте
inventory = inventory

-- =========================item============================

---Библиотека item
---@class voxelcore.libitem Библиотека item
---@field name fun(itemid: int): str Возвращает строковый id предмета по его числовому id (как block.name)
---@field index fun(name: str): int Возвращает числовой id предмета по строковому id (как block_index)
---@field caption fun(itemid: int): str Возвращает название предмета, отображаемое в интерфейсе.
---@field description fun(itemid: int): str Возвращает описание предмета, отображаемое в интерфейсе.
---@field properties table<int, table<str, any>> Таблица пользовательских свойств блоков (см. ../../item-properties.md)(git)
---@field stack_size fun(itemid: int): int Возвращает максимальный размер стопки для предмета.
---@field defs_count fun(): int Возвращает общее число доступных предметов (включая сгенерированные)
---@field icon fun(itemid: int): str Возвращает имя иконки предмета для использования в свойстве 'src' элемента image
---@field placing_block fun(itemid: int): int Возвращает числовой id блока, назначенного как 'placing-block' или 0
---@field model_name fun(itemid: int): str Возвращает значение свойства `model-name`
---@field emission fun(itemid: int): str Возвращает emission параметр у предмета
---@field uses fun(itemid: int): int Возвращает значение свойства `uses`
---@field __get_tags fun(itemid: int): table<str, bool> Возвращает таблицу из тегов этого предмета.
---@field has_tag fun(itemid: int, tag: str): bool Проверяет наличие тега у предмета
---@field reload_script fun(name: str) Перезагружает скрипт предмета
item = item

-- ========================matrix===========================

---mat4 содержит набор функций для работы с матрицами трансформации размерностью 4x4.
---@class voxelcore.libmat4 mat4 содержит набор функций для работы с матрицами трансформации размерностью 4x4.
---@field idt fun(): mat4 Создает единичную матрицу
---@field idt fun(dst: mat4) Записывает единичную матрицу в dst
---@field determinant fun(m: mat4): number Вычисляет определитель матрицы
---@field from_quat fun(quaternion: quat): mat4 Создает матрицу вращения по кватерниону
---@field from_quat fun(quaternion: quat, dst: mat4) Записывает матрицу вращения по кватерниону в dst
---@field mul fun(a: mat4, b: mat4|vector): mat4 Возвращает результат умножения матриц
---@field mul fun(a: mat4, v: mat4|vector, dst: mat4) Записывает результат умножения матриц в dst
---@field inverse fun(m: mat4): mat4 Возвращает результат инверсии матрицы
---@field inverse fun(m: mat4, dst: mat4) Записывает результат инверсии матрицы в dst
---@field transpose fun(m: mat4): mat4 Возвращает результат транспонирования матрицы
---@field transpose fun(m: mat4, dst: mat4) Записывает результат транспонирования матрицы в dst
---@field translate fun(translation: vec3): mat4 Создает матрицу смещения
---@field translate fun(m: mat4, translation: vec3): mat4 Возвращает результат применения смещения к матрице m
---@field translate fun(m: mat4, translation: vec3, dst: mat4) Записывает результат применения смещения к матрице m в dst
---@field scale fun(scale: vec3): mat4 Создает матрицу масштабирования
---@field scale fun(m: mat4, scale: vec3): mat4 Возвращает результат применения масштабирования к матрице m
---@field scale fun(m: mat4, scale: vec3, dst: mat4) Записывает результат применения масштабирования к матрице m в dst
---@field rotate fun(axis: vec3, angle: number): mat4 Создает матрицу поворота (angle - угол поворота) по заданной оси (axis - единичный вектор)
---@field rotate fun(m: mat4, axis: vec3, angle: number): mat4 Возвращает результат применения вращения к матрице m
---@field rotate fun(m: mat4, axis: vec3, angle: number, dst: mat4) Записывает результат применения вращения к матрице m в dst
---@field decompose fun(m: mat4): { scale: vec3, rotation: mat4, quaternion: quat, translation: vec3, skew: vec3, perspective: vec4 } | nil Раскладывает матрицу трансформации на составляющие.
---@field look_at fun(eye: vec3, center: vec3, up: vec3): mat4 Создает матрицу вида с точки 'eye' на точку 'center', где вектор 'up' определяет верх.
---@field look_at fun(eye: vec3, center: vec3, up: vec3, dst: mat4) Записывает матрицу вида в dst
---@field tostring fun(m: mat4, multiline?: bool): str Возвращает строку представляющую содержимое матрицы, многострочную, если multiline = true
mat4 = mat4

-- ========================network==========================

---@class voxelcore.class.tcp_socket
---@field send fun(self: voxelcore.class.tcp_socket, data: table|bytearray|str) Отправляет массив байт
---@field recv fun(self: voxelcore.class.tcp_socket, length: int, usetable?: bool): table|bytearray|nil Читает полученные данные. В случае ошибки возвращает nil (сокет закрыт или несуществует). Если данных пока нет, возвращает пустой массив байт.
---@field close fun(self: voxelcore.class.tcp_socket) Закрывает соединение
---@field available fun(self: voxelcore.class.tcp_socket): int Возвращает количество доступных для чтения байт данных
---@field is_alive fun(self: voxelcore.class.tcp_socket): bool Проверяет, что сокет существует и не закрыт.
---@field is_connected fun(self: voxelcore.class.tcp_socket): bool Проверяет наличие соединения (доступно использование socket:send(...)).
---@field get_address fun(self: voxelcore.class.tcp_socket): address: str, port: int Возвращает адрес и порт соединения.
---@field is_nodelay fun(): bool Возвращает состояние NoDelay
---@field set_nodelay fun(state: bool) Устанавливает состояние NoDelay

---@class voxelcore.class.tcp_serversocket
---@field close fun(self: voxelcore.class.tcp_serversocket) Закрывает сервер, разрывая соединения с клиентами.
---@field is_open fun(self: voxelcore.class.tcp_serversocket): bool Проверяет, существует и открыт ли TCP сервер.
---@field get_port fun(self: voxelcore.class.tcp_serversocket): int Возвращает порт сервера.

---@class voxelcore.class.udp_socket
---@field send fun(self: voxelcore.class.udp_socket, data: table | bytearray | str) Отправляет датаграмму на адрес и порт, заданные при открытии сокета
---@field close fun(self: voxelcore.class.udp_socket) Закрывает сокет
---@field is_open fun(self: voxelcore.class.udp_socket): bool Проверяет открыт ли сокет
---@field get_address fun(self: voxelcore.class.udp_socket): address: str, port: int Возвращает адрес и порт, на которые привязан сокет

---@class voxelcore.class.udp_serversocket
---@field send fun(self: voxelcore.class.udp_serversocket, address: str, port: int, data: table | bytearray | str) Отправляет датаграмму на переданный адрес и порт
---@field close fun(self: voxelcore.class.udp_serversocket) Завершает принятие датаграмм
---@field is_open fun(self: voxelcore.class.udp_serversocket): bool Проверяет возможность принятия датаграмм
---@field get_port fun(self: voxelcore.class.udp_serversocket): int Возвращает порт, который слушает сервер


---Библиотека для работы с сетью.
---@class voxelcore.libnetwork Библиотека для работы с сетью.
---@field get fun(url: str, callback: fun(data:str), onfailure?: fun(response:int), headers?: string[]) Выполняет GET запрос к указанному URL с указанными заголовками. После получения ответа, передаёт текст в функцию callback. В случае ошибки в onfailure будет передан HTTP-код ответа.
---@field get_binary fun(url: str, callback: fun(data: table|bytearray), onfailure?: fun(response:int), headers?: string[]) Выполняет GET запрос к указанному URL с указанными заголовками. После получения ответа, передаёт данные в функцию callback. В случае ошибки в onfailure будет передан HTTP-код ответа.
---@field post fun(url: str, data: table, callback: fun(data:str), onfailure?: fun(response:int), headers?: string[]) Выполняет POST запрос к указанному URL с указанными заголовками. На данный момент реализована поддержка только `Content-Type: application/json`. После получения ответа, передаёт текст в функцию callback. В случае ошибки в onfailure будет передан HTTP-код ответа.
---@field tcp_connect fun(address: str, port: int, callback: fun(socket: voxelcore.class.tcp_socket)): voxelcore.class.tcp_socket Инициирует TCP подключение.
---@field tcp_open fun(port: int, callback: fun(socket: voxelcore.class.tcp_socket)): voxelcore.class.tcp_serversocket Открывает TCP-сервер.
---@field udp_connect fun(address: str, port: int, datagram_handler: fun(data: bytearray), callback?: fun(socket: voxelcore.class.udp_socket)): voxelcore.class.udp_socket Открывает UDP-сокет с привязкой к удалённому адресу и порту
---@field udp_open fun(port: int, datagram_handler: fun(address: str, port: int, data: bytearray, server: voxelcore.class.udp_serversocket)): voxelcore.class.udp_serversocket Открывает UDP-сервер на указанном порту
---@field get_total_upload fun(): int Возвращает приблизительный объем отправленных данных (включая соединения с localhost) в байтах.
---@field get_total_download fun(): int Возвращает приблизительный объем полученных данных (включая соединения с localhost) в байтах.
network = network

-- =========================pack============================

---@class voxelcore.class.packinfo
---@field id str Буквенный идентификатор мода
---@field title str Название мода
---@field creator str Создатель(и) мода
---@field description str Описание
---@field version str Версия
---@field path str Путь до мода
---@field icon? str Название текстуры иконки. Отсутствует в headless режиме
---@field dependencies str[] Строки в формате {lvl}{id}@{version}, где lvl: ! - required, ? - optional, ~ - weak, а version: '*' или любая другая строка.
---@field has_indices bool Есть ли у пака новые айди.

---Библиотека pack
---@class voxelcore.libpack Библиотека pack
---@field is_installed fun(packid: str): bool Проверяет наличие установленного пака в мире
---@field data_file fun(packid: str, filename: str): str Возвращает путь к файлу данных и создает недостающие директории в пути. (возвращает: world:data/packid/filename)
---@field shared_file fun(packid: str, filename: str): str Возвращает путь к файлу данных и создает недостающие директории в пути. (возвращает: config:packid/filename)
---@field get_folder fun(packid: str): str Возвращает путь к папке установленного контент-пака.
---@field is_installed fun(packid: str): bool Проверяет наличие контент-пака в мире
---@field get_installed fun(): str[] Возращает id всех установленных в мире контент-паков.
---@field get_available fun(): str[] Возвращает id всех доступных, но не установленных в мире контент-паков.
---@field get_base_packs fun(): str[] Возвращает id всех базовых паков (неудаляемых)
---@field get_info fun(packid: str): voxelcore.class.packinfo Возвращает информацию о паке (не обязательно установленном).
---@field get_info fun(packsid: str[]): table<string, voxelcore.class.packinfo> Возвращает информацию о нескольких паках (не обязательно установленных).
---@field assemble fun(packs: table<string, voxelcore.class.packinfo>): table<string, voxelcore.class.packinfo> Проверяет корректность конфигурации и добавляет зависимости, возвращая полную.
---@field request_writeable fun(packid: str, callback: fun(str)) Запрашивает у пользователя право на модификацию пака. При подтвержении новая точка входа будет передана в callback.
---@field assemble fun(packdata: table): str[] Собирает пак и возвращает массив идентификаторов которые он добавляет
---@field unload fun(packid: str) Выгружает пак (а точнее просто удаляет все его ивенты)
pack = pack

-- ========================player===========================

---Библиотека player
---@class voxelcore.libplayer Библиотека player
---@field create fun(name: str): int Создаёт игрока и возвращает его id.
---@field delete fun(id: int) Удаляет игрока по id.
---@field get_pos fun(playerid?: int): number, number, number Возвращает x, y, z координаты игрока
---@field set_pos fun(playerid?: int, x: number, y: number, z: number) Устанавливает x, y, z координаты игрока
---@field get_vel fun(playerid?: int): number, number, number Возвращает x, y, z линейной скорости игрока
---@field set_vel fun(playerid?: int, x: number, y: number, z: number) Устанавливает x, y, z линейной скорости игрока
---@field get_rot fun(playerid?: int, lerp?: bool): number, number, number Возвращает x, y, z вращения камеры (в радианах). Интерполяция актуальна в случаях, когда частота обновления вращения ниже частоты кадров.
---@field set_rot fun(playerid?: int, x: number, y: number, z: number) Устанавливает x, y, z вращения камеры (в радианах)
---@field get_dir fun(playerid?: int): vec3 Позволяет получить вектор направления камеры игрока. Параметр playerid работает только если переназначить функцию, гарантированно с Quartz.
---@field get_inventory fun(playerid?: int): int, int Возвращает id инвентаря игрока и индекс выбранного слота (от 0 до 9)
---@field is_flight fun(playerid?: int): bool Геттер режима полета
---@field set_flight fun(playerid?: int, flag: bool) Сеттер режима полета
---@field is_noclip fun(playerid?: int): bool Геттер noclip режима (выключенная коллизия игрока)
---@field set_noclip fun(playerid?: int, flag: bool) Сеттер noclip режима (выключенная коллизия игрока)
---@field is_infinite_items fun(playerid?: int): bool Геттер бесконечных предметов (не удаляются из инвентаря при использовании)
---@field set_infinite_items fun(playerid?: int, flag: bool) Сеттер бесконечных предметов (не удаляются из инвентаря при использовании)
---@field is_instant_destruction fun(playerid?: int): bool Геттер мгновенного разрушения блоков при активации привязки player.destroy.
---@field set_instant_destruction fun(playerid?: int, flag: bool) Сеттер мгновенного разрушения блоков при активации привязки player.destroy.
---@field is_loading_chunks fun(playerid?: int): bool Геттер свойства, определяющего, прогружает ли игрок чанки вокруг.
---@field set_loading_chunks fun(playerid?: int, flag: bool) Сеттер свойства, определяющего, прогружает ли игрок чанки вокруг.
---@field get_interaction_distance fun(playerid?: int): number Геттер свойства, определяющего максимальную дистанцию взаимодействия.
---@field set_interaction_distance fun(playerid?: int, distance: number) Сеттер свойства, определяющего максимальную дистанцию взаимодействия.
---@field get_spawnpoint fun(playerid?: int): number, number, number Геттер точки спавна игрока
---@field set_spawnpoint fun(playerid?: int, x: number, y: number, z: number) Сеттер точки спавна игрока
---@field is_suspended fun(playerid?: int): bool Геттер статуса "заморозки" игрока
---@field set_suspended fun(playerid?: int, flag: bool) Сеттер статуса "заморозки" игрока
---@field get_camera fun(playerid?: int): int Возвращает идентификатор текущей камеры игрока (Если есть, иначе nil, обычно есть)
---@field set_camera fun(playerid?: int, cameraid: int) Устанавливает идентификатор текущей камеры игрока
---@field get_name fun(playerid?: int): str Геттер имени игрока
---@field set_name fun(playerid?: int, name: str) Сеттер имени игрока
---@field set_selected_slot fun(playerid?: int, slotid: int) Устанавливает индекс выбранного слота
---@field get_selected_block fun(playerid?: int): number, number, number Возвращает координаты выделенного блока, либо nil
---@field get_selected_entity fun(playerid?: int): int Возвращает уникальный идентификатор сущности, на которую нацелен игрок
---@field get_entity fun(playerid?: int): int Возвращает уникальный идентификатор сущности игрока
---@field get_all_in_radius fun(center: vec3, radius: number): int[] Возвращает массив id игроков в пределах сферы с центром `center` и радиусом `radius`.
---@field get_all fun(): int[] Возвращает массив id всех активных игроков.
---@field get_nearest fun(position: vec3): int | nil Возвращает id ближайшего к указанной позиции игрока, либо nil если игроков нет.
player = player

-- ======================quaternion=========================

---Библиотека для работы с кватернионами.
---@class voxelcore.libquat Библиотека для работы с кватернионами.
---@field from_mat4 fun(m: mat4): quat Создает кватернион на основе матрицы вращения
---@field from_mat4 fun(m: mat4, dst: quat) Создает кватернион на основе матрицы вращения
---@field slerp fun(a: quat, b: quat, t: number): quat создает кватернион как интерполяцию между a и b, где t - фактор интерполяции
---@field slerp fun(a: quat, b: quat, t: number, dst: quat) создает кватернион как интерполяцию между a и b, где t - фактор интерполяции
---@field tostring fun(q: quat): str возвращает строку представляющую содержимое кватерниона
quat = quat

-- =========================rules===========================

---@alias voxelcore.class.rulelist "cheat-commands" | "allow-content-access" | "allow-flight" | "allow-noclip" | "allow-attack" | "allow-destroy" | "allow-cheat-movement" | "allow-debug-cheats" | "allow-fast-interaction" | str

---Библиотека rules
---@class voxelcore.librules Библиотека rules
---@field create fun(name: str, default: bool, handler?: function): int Создаёт правило. Если указан обработчик, возвращает id для возможности удаления.
---@field listen fun(name: voxelcore.class.rulelist, handler?: function): int Добавляет обработчик изменения значения правила. Возвращает id для возможности удаления. Также позволяет подписаться на правило до его создания.
---@field unlisten fun(name: voxelcore.class.rulelist, id: int) Удаляет обработчик правила по id, если он существует.
---@field get fun(name: voxelcore.class.rulelist): bool | nil Возвращает значение правила или nil, если оно ещё не было создано.
---@field set fun(name: voxelcore.class.rulelist, value: bool) Устанавливает значение правила, вызывая обработчики. Может использоваться и до создания правила.
---@field reset fun(name: voxelcore.class.rulelist) Сбрасывает значение правила к значению по-умолчанию.
---@field nexid int Возможно вы имели ввиду nextid xD
---@field nextid int Следующий идентификатор правила
---@field rules table<str, {default: bool, listeners: function[], value: bool}>
rules = rules

-- =========================time============================

---Библиотека time
---@class voxelcore.libtime Библиотека time
---@field uptime fun(): number Возвращает время с момента запуска движка в секундах.
---@field delta fun(): number Возвращает дельту времени (время прошедшее с предыдущего кадра)
---@field post_runnable fun(func: function) Вызывает функцию после такта обновления движка
---@field utc_time fun(): int Возвращает время UTC в секундах
---@field local_time fun(): int Возвращает локальное (системное) время в секундах
---@field utc_offset fun(): int Возвращает смещение локального времени от UTC в секундах
time = time

-- =========================utf-8===========================

---Библиотека предоставляет функции для работы с UTF-8.
---@class voxelcore.libutf8 Библиотека предоставляет функции для работы с UTF-8.
---@field tobytes fun(text: str, usetable?: bool): bytearray|table Конвертирует UTF-8 строку в Bytearray или массив чисел если второй аргумент - true
---@field tostring fun(bytes: bytearray|table): str Конвертирует Bytearray или массив чисел в UTF-8 строку
---@field length fun(text: str): int Возвращает длину юникод-строки
---@field codepoint fun(chars: str): int Возвращает код первого символа строки
---@field encode fun(codepoint: int): str Кодирует код в в UTF-8
---@field sub fun(text: str, startchar: int, endchar?: int): str Возвращает подстроку от позиции startchar до endchar включительно
---@field upper fun(text: str): str Переводит строку в вверхний регистр
---@field lower fun(text: str): str Переводит строку в нижний регистр
---@field escape fun(text: str): str Экранирует строку
utf8 = utf8

-- ========================session==========================

---@class voxelcore.session
---@field get_entry fun(name: "commands_history" | "new_world" | str): any Возвращает некий энтри
---@field reset_entry fun(name: "commands_history" | "new_world" | str) Удаляет некий энтри
---@field entries table<str, any> Таблица этих самых энтри
session = session

-- ========================vector===========================

---vector содержит набор функций для работы с векторами размерностью 2, 3 или 4.
---@class voxelcore.libvector vector содержит набор функций для работы с векторами размерностью 2, 3 или 4.
---@field add fun(a: vector, b: vector|number): vector Возвращает результат сложения векторов
---@field add fun(a: vector, b: vector|number, dst: vector) Записывает результат сложения двух векторов в dst
---@field sub fun(a: vector, b: vector|number): vector Возвращает результат вычитания векторов
---@field sub fun(a: vector, b: vector|number, dst: vector) Записывает результат вычитания двух векторов в dst
---@field mul fun(a: vector, b: vector|number): vector Возвращает результат умножения векторов
---@field mul fun(a: vector, b: vector|number, dst: vector) Записывает результат умножения двух векторов в dst
---@field div fun(a: vector, b: vector|number): vector Возвращает результат деления векторов
---@field div fun(a: vector, b: vector|number, dst: vector) Записывает результат деления двух векторов в dst
---@field inverse fun(vec: vector): vector Возвращает результат инверсии (противоположный) вектора
---@field inverse fun(vec: vector, dst: vector) Записывает инвертированный вектор в dst
---@field normalize fun(vec: vector): vector Возвращает нормализованный вектор
---@field normalize fun(vec: vector, dst: vector) Записывает нормализованный вектор в dst
---@field length fun(vec: vector): number Возвращает длину вектора
---@field abs fun(vec: vector): vector Возвращает вектор с абсолютными значениями
---@field abs fun(vec: vector, dst: vector) Записывает абсолютное значение вектора в dst
---@field round fun(vec: vector): vector Возвращает вектор с округленными значениями
---@field round fun(vec: vector, dst: vector) Записывает округленный вектор в dst
---@field pow fun(vec: vector, exponent: number): vector Возвращает вектор с элементами, возведенными в степень
---@field pow fun(vec: vector, exponent: number, dst: vector) Записывает вектор, возведенный в степень, в dst
---@field dot fun(vecA: vector, vecB: vector): vector Возвращает скалярное произведение векторов
---@field distance fun(a: vector, b: vector): number Возвращает расстояние между двумя векторами
---@field tostring fun(vec: vector): str Возвращает строку представляющую содержимое вектора

---@class voxelcore.libvec2: voxelcore.libvector
---@field angle fun(v: vec2): number Возвращает угол направления вектора v в градусах [0, 360]
---@field angle fun(x: number, y: number): number Возвращает угол направления вектора {x, y} в градусах [0, 360]
vec2 = vec2

---@class voxelcore.libvec3: voxelcore.libvector
---@field spherical_rand fun(radius: number): vec3 Возвращает случайный вектор, координаты которого равномерно распределены на сфере заданного радиуса
---@field spherical_rand fun(radius: number, dst: vec3) Записывает случайный вектор, координаты которого равномерно распределены на сфере заданного радиуса в dst
vec3 = vec3

---@class voxelcore.libvec4: voxelcore.libvector
vec4 = vec4

-- =========================world===========================

---Библиотека world
---@class voxelcore.libworld Библиотека world
---@field is_open fun(): bool Проверяет, открыт ли мир
---@field get_list fun(): { name: str, icon: str, version: [int, int] }[] Возвращает информацию о мирах.
---@field get_day_time fun(): number Возвращает текущее игровое время от 0.0 до 1.0, где 0.0 и 1.0 - полночь, 0.5 - полдень.
---@field set_day_time fun(time: number) Устанавливает указанное игровое время.
---@field get_day_time_speed fun(): number Устанавливает указанную скорость смены времени суток.
---@field set_day_time_speed fun(value: number) Возвращает скорость скорость смены времени суток.
---@field get_total_time fun(): number Возвращает суммарное время, прошедшее в мире.
---@field get_seed fun(): int Возвращает зерно мира.
---@field get_generator fun(): str Возвращает имя генератора.
---@field exists fun(name: str): bool Проверяет существование мира по имени.
---@field is_day fun(): bool Проверяет является ли текущее время днём. От 0.333(8 утра) до 0.833(8 вечера).
---@field is_night fun(): bool Проверяет является ли текущее время ночью. От 0.833(8 вечера) до 0.333(8 утра).
---@field count_chunks fun(): int Возвращает общее количество загруженных в память чанков
---@field get_chunk_data fun(x: int, z: int): bytearray | nil Возвращает сжатые данные чанка для отправки. Если чанк не загружен, возвращает сохранённые данные.
---@field set_chunk_data fun(x: int, z: int, data: bytearray)  Изменяет чанк на основе сжатых данных. Возвращает true если чанк существует.
---@field save_chunk_data fun(x: int, z: int, data: bytearray) Сохраняет данные чанка в регион. Изменения будет записаны в файл только после сохранения мира.
---@field reload_script fun(packid: str) Перезагружает скрипт мира определённого пака
world = world

-- ========================events===========================

---События движка
---@class voxelcore.libevents
---@field on fun(code: str, handler: function) Добавляет обработчик события по его коду, не ограничиваясь стандартными.
---@field reset fun(code: str, handler?: function) Удаляет событие, добавляя обработчик, если указан.
---@field emit fun(code: str, ...): any Генерирует событие по коду. Если событие не существует, ничего не произойдет. Существование события определяется наличием обработчиков.
---@field remove_by_prefix fun(packid: str) Удаляет все события с префиксом packid:. Вы выходе из мира выгружаются события всех паков, включая core:.
---@field handlers table<str, function[]> Все хендлеры ивентов
events = events

-- =========================audio===========================

---Библиотека для управления звуками
---@class voxelcore.libaudio
---@field play_stream fun(name: str, x: number, y: number, z: number, volume: number, pitch: number, channel?: str, loop?: bool): int Воспроизводит потоковое аудио из указанного файла, на указанной позиции в мире. Возвращает id спикера.
---@field play_sound fun(name: string, x: number, y: number, z: number, volume: number, pitch: number, channel?: string, loop?: boolean): int Воспроизводит потоковое аудио из указанного файла. Возвращает id спикера.
---@field play_stream_2d fun(name: string, volume: number, pitch: number, channel?: string, loop?: boolean): int Воспроизводит звук на указанной позиции в мире. Возвращает id спикера.
---@field play_sound_2d fun(name: string, volume: number, pitch: number, channel?: string, loop?: boolean): int Воспроизводит звук. Возвращает id спикера.
---@field stop fun(speakerid: int) Остановить воспроизведение спикера
---@field pause fun(speakerid: int) Поставить спикер на паузу
---@field resume fun(speakerid: int) Снять спикер с паузы
---@field is_loop fun(speakerid: int): bool Проверить, зациклено ли аудио (false если не существует)
---@field set_loop fun(speakerid: int, loop: bool) Установить зацикливание аудио
---@field get_volume fun(speakerid: int): number Получить громкость спикера (0.0 если не существует)
---@field set_volume fun(speakerid: int, volume: number) Установить громкость спикера
---@field get_pitch fun(speakerid: int): number Получить скорость воспроизведения (1.0 если не существует)
---@field set_pitch fun(speakerid: int, pitch: number) Установить скорость воспроизведения
---@field get_time fun(speakerid: int): number Получить временную позицию аудио в секундах (0.0 если не существует)
---@field set_time fun(speakerid: int, time: number) Установить временную позицию аудио в секундах
---@field get_position fun(speakerid: int): number, number, number Получить позицию источника звука в мире (nil если не существует)
---@field set_position fun(speakerid: int, x: number, y: number, z: number) Установить позицию источника звука в мире
---@field get_velocity fun(speakerid: int): number, number, number Получить скорость движения источника звука в мире (nil если не существует)
---@field set_velocity fun(speakerid: int, x: number, y: number, z: number) Установить скорость движения источника звука в мире
---@field get_duration fun(speakerid: int): number Получить длительность аудио в секуднах, проигрываемого источником. Возвращает 0, если не спикер не существует. Так же возвращает 0, если длительность неизвестна (пример: радио).
---@field count_speakers fun(): int Получить текущее число активных спикеров
---@field count_streams fun(): int Получить текущее число проигрываемых аудио-потоков
audio = audio

-- ========================console==========================

---@class voxelcore.libconsole.command_info
---@field kwargs any[] Практически никогда не используется
---@field description str
---@field name str
---@field args { optional?: bool, type: str, name: str }[]

---@class voxelcore.libconsole
---@field add_command fun(scheme: str, description: str, handler: fun(args: any[], kwargs: str[])) Создаёт команду
---@field log fun(message: str) Выводит сообщение в консоль
---@field chat fun(message: str) Выводит сообщение в чат
---@field get_commands_list fun(): str[] Возвращает список команд
---@field get_command_info fun(name: str): voxelcore.libconsole.command_info Возвращает данные команды
---@field get fun(name: str): any Получает команду. (Правда странно как-то, я так и не понял как им оперировать).
---@field set fun(name: str, value: any) Устанавливает команду. (Не уверен как оно работает).
---@field execute fun(command: str) Выполняет команду
---@field cheats str[] Список чит команд
---@field submit? fun(message: str) Служебная функция
console = console

-- ========================assets===========================

---@class voxelcore.libassets
---@field load_texture fun(bytes: str|bytearray, texture: str) Загружает тектуру по пути из path_or_bytes если это строка или использует массив байт из path_or_bytes и загружает на место texture.
---@field parse_model fun(format: "xml"|"vcm", path: str, modelname: str) Загружает модель по пути path, парсит относительно format и заменяет/добавляет modelname в регистре.
assets = assets

-- ================entity=component=system==================

---@class voxelcore.class.entity.transform
---@field get_pos fun(self: voxelcore.class.entity.transform): vec3 Возвращает позицию сущности
---@field set_pos fun(self: voxelcore.class.entity.transform, pos: vec3) Устанавливает позицию сущности
---@field get_size fun(self: voxelcore.class.entity.transform): vec3 Возвращает масштаб сущности
---@field set_size fun(self: voxelcore.class.entity.transform, size: vec3) Устанавливает масштаб сущности
---@field get_rot fun(self: voxelcore.class.entity.transform): mat4 Возвращает вращение сущности
---@field set_rot fun(self: voxelcore.class.entity.transform, rotation: mat4) Устанавливает вращение сущности

---@alias voxelcore.class.entity.body_types "dyncamic" | "kinematic" | "static"

---@class voxelcore.class.entity.rigidbody
---@field is_enabled fun(self: voxelcore.class.entity.rigidbody): bool Проверяет, включен ли рассчет физики тела
---@field set_enabled fun(self: voxelcore.class.entity.rigidbody, flag: bool) Включает/выключает рассчет физики тела
---@field get_vel fun(self: voxelcore.class.entity.rigidbody): vec3 Возвращает линейную скорость
---@field set_vel fun(self: voxelcore.class.entity.rigidbody, vel: vec3) Устанавливает линейную скорость
---@field get_size fun(self: voxelcore.class.entity.rigidbody): vec3 Возвращает размер хитбокса
---@field set_size fun(self: voxelcore.class.entity.rigidbody, size: vec3) Устанавливает размер хитбокса
---@field get_gravity_scale fun(self: voxelcore.class.entity.rigidbody): vec3 Возвращает множитель гравитации
---@field set_gravity_scale fun(self: voxelcore.class.entity.rigidbody, scale: vec3) Устанавливает множитель гравитации
---@field get_linear_damping fun(self: voxelcore.class.entity.rigidbody): number Возвращает множитель затухания линейной скорости (используется для имитации сопротивления воздуха и трения)
---@field set_linear_damping fun(self: voxelcore.class.entity.rigidbody, value: number) Устанавливает множитель затухания линейной скорости
---@field is_vdamping fun(self: voxelcore.class.entity.rigidbody): bool Проверяет, включено ли вертикальное затухание скорости
---@field set_vdamping fun(self: voxelcore.class.entity.rigidbody, flag: bool) Включает/выключает вертикальное затухание скорости
---@field is_grounded fun(self: voxelcore.class.entity.rigidbody): bool Проверяет, находится ли сущность на земле (приземлена)
---@field is_crouching fun(self: voxelcore.class.entity.rigidbody): bool Проверяет, находится ли сущность в "крадущемся" состоянии (не может упасть с блоков)
---@field set_crouching fun(self: voxelcore.class.entity.rigidbody, flag: bool) Включает/выключает "крадущееся" состояние
---@field get_body_type fun(self: voxelcore.class.entity.rigidbody): voxelcore.class.entity.body_types Возвращает тип физического тела (dynamic/kinematic)
---@field set_body_type fun(self: voxelcore.class.entity.rigidbody, type: voxelcore.class.entity.body_types) Устанавливает тип физического тела

---@class voxelcore.class.entity.skeleton
---@field index fun(self: voxelcore.class.entity.skeleton, name: str): int Возвращает индекс кости по имени или nil
---@field get_model fun(self: voxelcore.class.entity.skeleton, index: int): str Возвращает имя модели, назначенной на кость с указанным индексом
---@field set_model fun(self: voxelcore.class.entity.skeleton, index: int, name: str) Переназначает модель кости с указанным индексом. Сбрасывает до изначальной, если не указывать имя
---@field get_matrix fun(self: voxelcore.class.entity.skeleton, index: int): mat4 Возвращает матрицу трансформации кости с указанным индексом
---@field set_matrix fun(self: voxelcore.class.entity.skeleton, index: int, matrix: mat4) Устанавливает матрицу трансформации кости с указанным индексом
---@field get_texture fun(self: voxelcore.class.entity.skeleton, key: str): str Возвращает текстуру по ключу (динамически назначаемые текстуры - '$имя')
---@field set_texture fun(self: voxelcore.class.entity.skeleton, key: str, value: str) Назначает текстуру по ключу
---@field is_visible fun(self: voxelcore.class.entity.skeleton, index?: int): bool Проверяет статус видимости кости по индесу или всего скелета, если индекс не указан
---@field set_visible fun(self: voxelcore.class.entity.skeleton, index?: int, status: bool) Устанавливает статус видимости кости по индексу или всего скелета, если индекс не указан
---@field get_color fun(self: voxelcore.class.entity.skeleton): vec3 Возвращает цвет сущности
---@field set_color fun(self: voxelcore.class.entity.skeleton, color: vec3) Устанавливает цвет сущности

---@alias voxelcore.class.entity.components "core:pathfinding" | str

---@class voxelcore.class.entity
---@field despawn fun(self: voxelcore.class.entity) Удаляет сущность (сущность может продолжать существовать до завершения кадра, но не будет отображена в этом кадре)
---@field def_index fun(self: voxelcore.class.entity): eid: int Возвращает индекс определения сущности (числовой ID)
---@field def_name fun(self: voxelcore.class.entity): entity_name: str Возвращает имя определения сущности (строковый ID)
---@field get_skeleton fun(self: voxelcore.class.entity): skeleton_name: str Возращает имя скелета сущности
---@field set_skeleton fun(self: voxelcore.class.entity, name: str) Заменяет скелет сущности
---@field get_uid fun(self: voxelcore.class.entity): int Возращает уникальный идентификатор сущности
---@field get_component fun(self: voxelcore.class.entity, name: voxelcore.class.entity.components): component: table | nil Возвращает компонент по имени
---@field has_component fun(self: voxelcore.class.entity, name: voxelcore.class.entity.components): has_component: bool Проверяет наличие компонента по имени
---@field set_enabled fun(self: voxelcore.class.entity, name: str, flag: bool) Включает/выключает компонент по имени
---@field get_player fun(self: voxelcore.class.entity): pid: int | nil Возвращает id игрока, к которому привязана сущность
---@field transform voxelcore.class.entity.transform Компонент отвечает за позицию, масштаб и вращение сущности.
---@field rigidbody voxelcore.class.entity.rigidbody Компонент отвечает за физическое тело сущности.
---@field skeleton voxelcore.class.entity.skeleton Компонент отвечает за скелет сущности. См. риггинг. (git)
---@field components table<string, table> Таблица компонентов.

---Доступен при получении или в компоненте сущности
---@type voxelcore.class.entity
entity = entity

-- ======================pathfinding========================

---@class voxelcore.class.pathfinding
---@field set_target fun(target: vec3) Установка цели для агента
---@field get_target fun(): target: vec3 | nil Получение текущей цели агента
---@field get_route fun(): route: vec3[] | nil Получение текущего маршрута агента
---@field create_agent fun(): agent: int Создаёт нового агента и возвращает его идентификатор
---@field remove_agent fun(agent: int): bool Удаление агента по идентификатору, если он существует. Возвращает булевое значение того существовал он или нет.
---@field set_enabled fun(agent: int, enabled: bool) Установка состояния агента
---@field is_enabled fun(agent: int): enabled: bool Возвращает состояние агента
---@field make_route fun(start: vec3, target: vec3): vec3[] Создание маршрута на основе заданных точек
---@field make_route_async fun(agent: int, start: vec3, target: vec3) Асинхронное создание маршрута на основе заданных точек (получение маршрута происходит в pull_route)
---@field pull_route fun(agent: int): route: vec3[] | nil Получение маршрута, который агент уже нашел. Используется для получения маршрута после асинхронного поиска. Если поиск ещё не завершён, возвращает nil. Если маршрут не найден, возвращает пустую таблицу.
---@field set_max_visited fun(agent: int, max_visited: int) Установка максимального количества посещенных блоков для агента. Используется для ограничения объема работы алгоритма поиска пути.
---@field avoid_tag fun(agent: int, tag?: string, cost?: int) Добавление тега избегаемых блоков. По умолчанию: cost = 10.

---Доступен при получении из компонента сущности
---@type voxelcore.class.pathfinding
pf = pf

-- =======================document==========================

---@alias voxelcore.ui.document.any voxelcore.ui.document.base_element | voxelcore.ui.document.container | voxelcore.ui.document.textbox | voxelcore.ui.document.trackbar | voxelcore.ui.document.pagebox | voxelcore.ui.document.checkbox | voxelcore.ui.document.button | voxelcore.ui.document.label | voxelcore.ui.document.image | voxelcore.ui.document.canvas | voxelcore.ui.document.iframe | voxelcore.ui.document.inventory

---Доступен при получении или в скрипте лейаута
---@type table<str, voxelcore.ui.document.any>
document = document

---@class voxelcore.Document
---@field new fun(name: str): document: table<str, voxelcore.ui.document.any>
Document = Document

---@class voxelcore.Element
---@field new fun(docname: str, name: str): element: table
Element = Element

---@class voxelcore.ui.document.base_element
---@field id str идентификатор элемента. запись: нет
---@field pos vec2 позиция элемента внутри контейнера
---@field wpos vec2 позиция элемента в окне
---@field size vec2 размер элемента
---@field interactive bool возможность взаимодействия с элементом
---@field enabled bool визуально обозначаемая версия interactive
---@field visible bool видимость элемента
---@field focused bool фокус на элементе
---@field color vec4 цвет элемента
---@field hoverColor vec4 цвет при наведении
---@field pressedColor vec4 цвет при нажатии
---@field tooltip str текст всплывающей подсказки
---@field tooltipDelay number задержка всплывающей подсказки
---@field contentOffset vec2 смещение содержимого. запись: нет
---@field cursor str курсор, отображаемый при наведении
---@field parent voxelcore.ui.document.base_element | table родительский элемент или nil. запись: нет
---@field moveInto fun(self: voxelcore.ui.document.any, container: voxelcore.ui.document.any) перемещает элемент в указанный контейнер (указывается элемент, а не id)
---@field destruct fun(self: voxelcore.ui.document.any) удаляет элемент
---@field reposition fun(self: voxelcore.ui.document.any) обновляет позицию элемента на основе функции позиционирования

---@class voxelcore.ui.document.container: voxelcore.ui.document.base_element
---@field scroll number прокрутка содержимого
---@field clear fun(self: voxelcore.ui.document.any) очищает контент
---@field add fun(self: voxelcore.ui.document.any, xml: str) добавляет элемент, создавая его по xml коду. Пример: container:add("<image src='test'/>")
---@field setInterval fun(self: voxelcore.ui.document.any, interval: integer, callback: function) назначает функцию на повторяющееся выполнение с заданным в миллисекундах интервалом
---@field refresh fun() Обновляет элемент

---@class voxelcore.ui.document.textbox: voxelcore.ui.document.base_element
---@field text str введенный текст или заполнитель
---@field placeholder str заполнитель (используется если ничего не было введено)
---@field hint str текст, отображаемый, когда ничего не введено
---@field caret int позиция каретки. textbox.caret = -1 установит позицию в конец текста
---@field editable bool изменяемость текста
---@field edited bool был ли изменён текст с последней установки/сброса свойства. запись: только false
---@field multiline bool поддержка многострочности
---@field lineNumbers bool отображение номеров строк
---@field textWrap bool автоматический перенос текста (только при multiline: "true")
---@field valid bool является ли введенный текст корректным
---@field textColor vec4 цвет текста
---@field syntax str подсветка синтаксиса ("lua" - Lua)
---@field markup str язык разметки текста ("md" - Markdown)
---@field paste fun(self: voxelcore.ui.document.any, text: str) вставляет указанный текст на позицию каретки
---@field lineAt fun(self: voxelcore.ui.document.any, pos: int): int определяет номер строки по позиции в тексте
---@field linePos fun(self: voxelcore.ui.document.any, line: int): int определяет позицию начала строки в тексте

---@class voxelcore.ui.document.trackbar: voxelcore.ui.document.base_element
---@field value number выбранное значение
---@field min number минимальное значение
---@field max number максимальное значение
---@field step number шаг деления
---@field trackWidth number ширина управляющего элемента
---@field trackColor vec4 цвет управляющего элемента

---@class voxelcore.ui.document.pagebox: voxelcore.ui.document.container
---@field page str текущая страница
---@field back fun(self: voxelcore.ui.document.any) переключает на прошлую страницу
---@field reset fun(self: voxelcore.ui.document.any) сбрасывает страницу и историю переключений

---@class voxelcore.ui.document.checkbox: voxelcore.ui.document.base_element
---@field checked bool состояние отметки

---@class voxelcore.ui.document.button: voxelcore.ui.document.container
---@field text str текст кнопки

---@class voxelcore.ui.document.label: voxelcore.ui.document.base_element
---@field text str текст метки
---@field markup str язык разметки текста ("md" - Markdown)

---@class voxelcore.ui.document.image: voxelcore.ui.document.base_element
---@field src str отображаемая текстура
---@field region vec4 под-регион изображения

---@class voxelcore.ui.document.canvas: voxelcore.ui.document.base_element
---@field data voxelcore.ui.canvas пиксели холста

---@class voxelcore.ui.document.iframe: voxelcore.ui.document.base_element
---@field src str id встраиваемого документа

---@class voxelcore.ui.document.inventory: voxelcore.ui.document.base_element
---@field inventory int id инвентаря, к которому привязан элемент

-- ======================RadioGroup=========================

---@class voxelcore.class.RadioGroup
---@field set fun(self: voxelcore.class.RadioGroup, key: str)

---@type fun(elements: str[], onset: fun(mode: str), default: str): voxelcore.class.RadioGroup Создаёт новый переключатель типа Radio.
RadioGroup = RadioGroup

-- ========================canvas===========================

---@class voxelcore.ui.canvas
---@field at fun(self: voxelcore.ui.canvas, x: int, y: int): vec4 возвращает RGBA пиксель по указанным координатам
---@field set fun(self: voxelcore.ui.canvas, x: int, y: int, rgba: int) изменяет RGBA пиксель по указанным координатам
---@field set fun(self: voxelcore.ui.canvas, x: int, y: int, r: int, g: int, b: int, a?: int) изменяет RGBA пиксель по указанным координатам
---@field line fun(self: voxelcore.ui.canvas, x1: int, y1: int, x2: int, y2: int, rgba: int) рисует линию с указанным RGBA цветом
---@field line fun(self: voxelcore.ui.canvas, x1: int, y1: int, x2: int, y2: int, r: int, g: int, b: int, a?: int) рисует линию с указанным RGBA цветом
---@field blit fun(self: voxelcore.ui.canvas, src: voxelcore.ui.canvas, dst_x: int, dst_y: int) рисует src-холст на указанных координатах
---@field clear fun(self: voxelcore.ui.canvas, rgba?: int) очищает холст
---@field clear fun(self: voxelcore.ui.canvas, r: int, g: int, b: int, a?: int) заполняет холст указанным RGBA цветом
---@field update fun(self: voxelcore.ui.canvas) применяет изменения и загружает холст в видеопамять
---@field set_data fun(self: voxelcore.ui.canvas, data: table) заменяет данные пикселей (ширина * высота * 4 чисел)
---@field create_texture fun(self: voxelcore.ui.canvas, name: str) создаёт и делится текстурой с рендерером

-- ====================world=generator======================

---@alias voxelcore.class.HeightMapConstructor fun(width, height)

---@class voxelcore.class.HeightMap
---@field noiseSeed number
---@field abs fun(self: voxelcore.class.HeightMap): voxelcore.class.HeightMap Приводит значения высот к абсолютным.
---@field add fun(value: voxelcore.class.HeightMap|number): voxelcore.class.HeightMap Прибавление
---@field sub fun(value: voxelcore.class.HeightMap|number): voxelcore.class.HeightMap Вычитание
---@field mul fun(value: voxelcore.class.HeightMap|number): voxelcore.class.HeightMap Умножение
---@field pow fun(value: voxelcore.class.HeightMap|number): voxelcore.class.HeightMap Возведение в степень
---@field min fun(value: voxelcore.class.HeightMap|number): voxelcore.class.HeightMap Минимум
---@field max fun(value: voxelcore.class.HeightMap|number): voxelcore.class.HeightMap Максимум
---@field mixin fun(value: voxelcore.class.HeightMap|number, t: voxelcore.class.HeightMap): voxelcore.class.HeightMap Перемешивание
---@field dump fun(path: string) Ссоздает изображение на основе карты высот переводя значения из дипазона [-1.0, 1.0] в значения яркости [0, 255], сохраняя в указанный файл.
---@field noise fun(offset: vec2, scale: number, octaves?: integer, multiplier?: number, shiftMapX?: voxelcore.class.HeightMap, shiftMapY: voxelcore.class.HeightMap) Метод генерирующий симплекс-шум, прибавляя его к имеющимся значениям.
---@field cellnoise fun(offset: vec2, scale: number, octaves?: integer, multiplier?: number, shiftMapX?: voxelcore.class.HeightMap, shiftMapY: voxelcore.class.HeightMap) Аналог heightmap:noise генерирующий клеточный шум.
---@field resize fun(width: number, height: number, lerp: "nearest"|"linear"|"cubic"): voxelcore.class.HeightMap Изменяет размер карты высот.
---@field crop fun(x: number, y: number, width: number, height: number): voxelcore.class.HeightMap Обрезает карту высот до заданной области.
---@field at fun(x:number,y:number): number Возвращает значение высота на заданной позиции.

---@type voxelcore.class.HeightMapConstructor
Heightmap = Heightmap

---@class voxelcore.class.VoxelFragment
---@field crop fun(self: voxelcore.class.VoxelFragment) Обрезает фрагмент до размеров содержимого
---@field place fun(self: voxelcore.class.VoxelFragment, position: vec3, rotaition?: int) Устанавливает фрагмент в мир на указанной позиции
---@field size vec3 Размер фрагмента

---@class voxelcore.generation
---@field create_fragment fun(a: vec3, b: vec3, crop: bool): voxelcore.class.VoxelFragment Создаёт фрагмент по координатам
---@field load_fragment fun(filename: str): voxelcore.class.VoxelFragment Загружает фрагмент из файла
---@field save_fragment fun(fragment: voxelcore.class.VoxelFragment, filename: str) Сохраняет фрагмент в файл
---@field get_generators fun(): str[] Возвращает таблицу из идентификаторов всех доступных генераторов
---@field get_default_generator fun(): str Возвращает генератор по умолчанию
generation = generation

-- =====================core:schedule=======================

---@class voxelcore.modules.core.schedule
---@field set_interval fun(self: voxelcore.modules.core.schedule, ms: number, callback: function, repetions?: int): int Создаёт новый интервал. Работает repetions раз или бесконечно.
---@field tick fun(self: voxelcore.modules.core.schedule, dt: number) Тикает интервалы
---@field remove_interval fun(self: voxelcore.modules.core.schedule, id: int) Удаляет интервал

-- =======================base:util=========================

---@class voxelcore.modules.base.util
---@field drop fun(pos: vec3, itemid: int, count: int, data?: any, pickup_delay?: number): voxelcore.class.entity
---@field block_loot fun(blockid: int): { item: int, count: int }[]
