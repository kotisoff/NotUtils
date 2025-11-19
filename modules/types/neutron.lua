--[[
  Neutron/Quartz Lua Types
  Neutron version: v1.0.0 / Quartz version: v0.1.5
  Version: v0.0.4
  ]]

---@diagnostic disable: duplicate-doc-field
---@diagnostic disable: duplicate-doc-alias

-- ========================aliases==========================

---@alias neutron.utils.proxy_table table
---@alias neutron.sandbox.blocks.slot { slot_id: int, item_id: int, item_count: int }

-- ========================classes==========================

---@class neutron.class.account
---@field username string Имя аккаунта
---@field active boolean Статус активности аккаунта (false - вне сети)
---@field is_logged boolean Статус авторизации аккаунта
---@field role string Название роли аккаунта

---@class neutron.class.player
---@field username string Имя игрока (идентично имени аккаунта)
---@field active boolean Статус активности игрока (false - вне сети)
---@field pid number PlayerID игрока
---@field region_pos { x: number, z: number } Позиция региона 2x2 чанка, в котором находится игрок

---@class neutron.class.client
---@field active boolean Статус активности клиента (false - вне сети)
---@field account neutron.class.account Аккаунт, привязанный к клиенту
---@field player neutron.class.player Игрок, привязанный к клиенту

-- ========================shared===========================

---@class neutron.shared.bson
---@field serialize fun(tbl: table): bytearray Возвращает tbl в виде байт
---@field deserialize fun(buf: bytearray): table Читает таблицу из массива байт

---@alias neutron.class.inventory {id: integer, count: integer, meta?: table}[]

---@class neutron.shared.inventory_data
---@field serialize fun(inv: neutron.class.inventory): bytearray Возвращает inv в виде байт
---@field deserialize fun(bytes: bytearray): neutron.class.inventory Читает инвентарь из массива байт

---@alias neutron.util.pos { x: int, y: int, z: int }

-- ========================server===========================

-- Server.accounts

---@class neutron.server.accounts.roles
---@field get fun(account: neutron.class.account): table Возвращает конфиг роли по аккаунту
---@field get_rules fun(account: neutron.class.account, category: boolean): table Возвращает таблицу правил роли по аккаунту. Category - категория тех правил, которые надо вернуть (false -> game_rules / true -> server_rules)
---@field is_higher fun(role1: table, role2: table): boolean Возвращает true если первая роль имеет больший приоритет, чем вторая
---@field exists fun(role: table): boolean Возвращает true если роль существует

---@class neutron.server.accounts
---@field get_account_by_name fun(username: string): neutron.class.account Возвращает класс типа Account игрока с ником username
---@field get_client fun(account: neutron.class.account): neutron.class.client Возвращает класс типа Client игрока с аккаунтом account.
---@field get_client_by_name fun(username: string): neutron.class.client Возвращает класс типа Client игрока с ником username
---@field kick fun(account: neutron.class.account, reason?: string, soft?: boolean) Кикает аккаунт account с сервера с причиной reason. Если **soft** равен **true**, то кик произойдёт не сразу, а после обработки пакетов, что обеспечит гарантированную отправку сообщения с причиной ошибки.
---@field roles neutron.server.accounts.roles

-- Server.console

---@class neutron.console.state
---@field move_to fun(self: neutron.console.state, state: neutron.console.state) Переход между состояниями
---@field clear fun(self: neutron.console.state) Выход из состояния
---@field update_data fun(self: neutron.console.state, key: string, data: any) Сохранение данных в хранилище состояния
---@field get_data fun(self: neutron.console.state, key?: string): any | nil Получение данных из хранилища состояний

---@alias neutron.console.colors { red: string, yellow: string, blue: string, black: string, green: string, white: string }

---@class neutron.server.console
---@field set_command fun(scheme: string, permissions: table<table<string>>, handler: fun(args: table<string,any>, client: neutron.class.client), allow_not_authorized?: boolean) Создаёт команду. Подробнее: https://github.com/Xertis/Neutron-Server/blob/main/docs/API/Библиотеки/сервер/console.md
---@field create_state fun(name: string): neutron.console.state Создание состояния по имени
---@field set_state fun(state: neutron.console.state, client: neutron.class.client) Установка состояния клиенту
---@field set_state_handler fun(state: neutron.console.state, handler: fun(message: string, state: neutron.console.state, client: neutron.class.client)) Объявление обработчика состояния
---@field tell fun(message: string, client: neutron.class.client) Отправляет в чат клиента client сообщение message
---@field echo fun(message: string) Отправляет в чат всем клиентам сообщение message
---@field execute fun(message: string, client: neutron.class.client) Выполняет команду из message, как будто бы его отправил в консоль client
---@field colors neutron.console.colors Хранит в себе эти заготовленные цвета, в console.tell / console.echo желательно использовать именно их

-- Server.database

---@alias neutron.db.response_code 200 | 101 | 102 | 201 Success: 200, DatabaseExists: 101, DatabaseNotExists: 102, TableExists: 201
---@alias neutron.db.Column { column_type: string, config: table }

---@class neutron.db.session
---@field init_table fun(self: neutron.db.session, config: {__tablename__: string}): neutron.db.session
---@field order_by fun(self: neutron.db.session, field: string, reverse?: boolean): neutron.db.session Перед использованием таблиц надо их проинициализировать (Даже если они уже были созданы)
---@field first fun(self: neutron.db.session): any Возвращает первый элемент из результатов запроса.
---@field last fun(self: neutron.db.session): any Возвращает последний элемент из результатов запроса.
---@field all fun(self: neutron.db.session): table<any> Возвращает все элементы из результатов запроса.
---@field count fun(self: neutron.db.session): integer Возвращает все элементы из результатов запроса
---@field query fun(self: neutron.db.session, query: string): neutron.db.session Поиск по таблице
---@field limit fun(self: neutron.db.session, n: integer): neutron.db.session Возвращает первые n значений.
---@field filter fun(self: neutron.db.session, filter: table): neutron.db.session Возвращает только те значния, которые соответствуют фильтру.
---@field add fun(self: neutron.db.session, tablename: string, data: table) Добавление данных
---@field update fun(self: neutron.db.session, tablename: string, primary_key_value: any, data: table) Обновление данных
---@field delete fun(self: neutron.db.session, tablename: string, filter: table) Удаление данных. Очистит всю таблицу, если передана пустая таблица со значениями
---@field remove_table fun(self: neutron.db.session, tablename: string) Удаление таблицы

---@class neutron.server.db.db
---@field register fun(): nil | neutron.db.response_code Создаёт базу данных, если база уже существует вернёт код DatabaseExists
---@field exists fun(pack: string): boolean Проверяет существует ли база данных
---@field login fun(): neutron.db.session | neutron.db.response_code Возвращает сессию для управления базой данных.

---@class neutron.server.db.items
---@field Column fun(type: string, config?: table): neutron.db.Column Возвращает объект Column. Используется при инициализации таблицы.

---@class neutron.server.db
---@field db neutron.server.db.db
---@field items neutron.server.db.items
---@field types { codes: table<string, number>, indexes: table<string> } Таблица доступных типов данных

-- Server.entities

---@class neutron.entity.field
---@field maximum_deviation number Максимальное отклонение
---@field evaluate_deviation fun(distance_to_player: number, server_value: any, client_value: any): number Оценка отклонения
---@field provider? fun(uid, field_name): boolean | any Для своих полей: Получения значения поля. Для компонентов: Получение значения поля, всегда bool. Если provider вернёт true, компонент включится у клиента, если false - выключится.

---@class neutron.entity.registration_config
---@field standart_fields? table<string, neutron.entity.field>
---@field custom_fields? table<string, neutron.entity.field>
---@field textures? table<string, neutron.entity.field>
---@field models? table<string, neutron.entity.field>
---@field components? table<string, neutron.entity.field>

---@class neutron.server.entities.players
---@field add_field fun( field_type: string, key: string, field: neutron.entity.field ) Функция именно что ДОБАВЛЯЕТ новые поля ВСЕМ игрокам, а не заменяет старые, если создаваемое поле уже существует, функция вернёт false во избежании конфликтов

---@class neutron.server.entities
---@field register fun(entity_name: string, config: neutron.entity.registration_config, spawn_handler: fun(name: string, args: table | nil, client: neutron.class.client)) Регистрация сущности
---@field eval { NotEquals: (fun(): number), Always: (fun(): number), Never: (fun(): number) }
---@field players neutron.server.entities.players
---@field types { Custom: string, Standart: string, Models: string, Textures: string, Components: string } Доступные типы

-- Server.env

---@class neutron.server.env.public
---@field create fun(pack: str, name: str): neutron.utils.proxy_table Создаёт прокси-таблицу, доступ к которой имеют все клиенты. Может хранить только пары ключ-значение. Значение может быть только типами string, number, nil или bool

---@class neutron.server.env.private
---@field create fun(pack: str, name: str, client: neutron.class.client): neutron.utils.proxy_table Создаёт прокси таблицу, доступ к которой есть только у одного клиента. Может хранить только пары ключ-значение. Значение может быть только типами string, number, nil или bool

---@class neutron.server.env
---@field public neutron.server.env.public
---@field private neutron.server.env.private

-- Server.events

---@class neutron.server.events
---@field tell fun(pack: string, event: string, client: neutron.class.client, bytes: bytearray) Отправляет событие event с данными bytes моду pack на сторону указанного клиента client.
---@field echo fun(pack: string, event: string, bytes: bytearray) Отправляет событие event с данными bytes моду pack всем подключённым клиентам.
---@field on fun(pack: string, event: string, func: fun(client: neutron.class.client, bytes: bytearray)) Регистрирует функцию func, которая будет вызвана при получении события event от мода pack. В функцию передаются данные bytes и Client, с которого пришло сообщение

-- Server.middlewares

---@alias neutron.alias.middleware_fun fun(packet: table, client: neutron.class.client): boolean|nil

---@class neutron.server.middlewares.packets
---@field ServerMsg table Пакеты, отправляемые сервером
---@field ClientMsg table Пакеты, отправляемые клиентом

---@class neutron.server.middlewars.receive
---@field add_middleware fun(packet_type: string, middleware: neutron.alias.middleware_fun): boolean | nil Добавление middleware
---@field add_general_middleware fun(middleware: neutron.alias.middleware_fun): boolean | nil Добавление общего обработчика для всех пакетов

---@class neutron.server.middlewares
---@field packets neutron.server.middlewares.packets
---@field receive neutron.server.middlewars.receive

-- Server.protocol

---@class neutron.server.protocol
---@field tell fun(client: neutron.class.client, packet_type: string, data: table) Отправляет пакет указанному клиенту.
---@field echo fun(packet_type: string, data: table) Отправляет пакет всем клиентам.

-- Server.rpc

---@class neutron.server.rpc.emitter
---@field create_tell fun(pack: string, event: string): fun(client: neutron.class.client, ...) Возвращает функцию, которая принимает клиент, которому надо отправить ивент и неограниченное кол-во аргументов. Полученные аргументы сериализуются с помощью проприетарного bson и отправляются клиенту
---@field create_echo fun(pack: string, event: string): fun(...) Идентичен rpc.create_tell, за исключением того, что возвращаемая функция не принимает client и отправляет ивент всем клиентам

---@class neutron.server.rpc
---@field emitter neutron.server.rpc.emitter

-- Server.tasks
---@class neutron.server.tasks
---@field add_task fun(task: function) Создаёт задачу, которая будет удалена после первого выполнения.

-- Server.sandbox

---@class neutron.server.sandbox.players
---@field get_all fun(): table<string, neutron.class.player> Возвращает таблицу со всеми игроками онлайн. Где ключи - ники игроков, а значения - их объект Player
---@field get_in_radius fun(pos: {x:number, y:number,z:number}, radius: number): table<string, neutron.class.player> Возвращает таблицу игроков в определённом радиусе
---@field get_player fun(account: neutron.class.account): neutron.class.player Возвращает объект игрока по аккаунту
---@field get_by_pid fun(pid): neutron.class.player | nil Возвращает объект игрока по pid
---@field sync_states fun(player: neutron.class.player, states: {pos?: {x:number, y: number, z: number}, rot?: { yaw: number, pitch: number }, cheats?: { noclip: bool, flight: bool }}) Изменяет игрока в соответствии с таблицой **states** и принудительно отправляет эти данные на клиент.

---@class neutron.server.sandbox.blocks
---@field sync_inventory fun(pos: neutron.util.pos, client: neutron.class.client) Синхронизирует инвентарь.
---@field sync_slot fun(pos: neutron.util.pos, slot: neutron.sandbox.blocks.slot, client: neutron.class.client) Синхронизирует определённый слот инвентаря.

---@class neutron.server.sandbox
---@field players neutron.server.sandbox.players
---@field blocks neutron.server.sandbox.blocks

-- Server.audio

---@class neutron.class.speaker
---@field stop fun(self: neutron.class.speaker) Остановка спикера
---@field pause fun(self: neutron.class.speaker) Приостановка спикера
---@field resume fun(self: neutron.class.speaker) Возобновление воспроизведения
---@field is_loop fun(self: neutron.class.speaker): boolean Проверка зацикливания
---@field set_loop fun(self: neutron.class.speaker, loop: boolean) Установка зацикливания
---@field get_volume fun(self: neutron.class.speaker): number Получение громкости
---@field set_volume fun(self: neutron.class.speaker, volume: number) Установка громкости
---@field get_pitch fun(self: neutron.class.speaker): number Получение скорости звука
---@field set_pitch fun(self: neutron.class.speaker, pitch: number) Установка скорости звука
---@field get_time fun(self: neutron.class.speaker): number Получение текущего времени воспроизведения
---@field set_time fun(self: neutron.class.speaker, time: number) Установка времени воспроизведения
---@field get_position fun(self: neutron.class.speaker): number, number, number Получение позиции спикера в мире
---@field set_position fun(self: neutron.class.speaker, x: number, y: number, z: number) Установка позиции спикера в мире
---@field get_velocity fun(self: neutron.class.speaker): number, number, number Получить скорость движения источника звука в мире
---@field set_velocity fun(self: neutron.class.speaker, x: number, y: number, z: number) Установить скорость движения источника звука в мире
---@field get_duration fun(self: neutron.class.speaker): number Получение длительности. Возвращает 0 из-за технических ограничений, если продолжительность звука не зарегистрирована.
---@field get_time_left fun(self: neutron.class.speaker): number | nil Получение оставшегося времени до конца воспроизведения звука. Возвращает nil из-за технических ограничений, если продолжительность звука не зарегистрирована.
---@field id integer Идентификатор спикера

---@class neutron.server.audio
---@field play_stream fun(name: string, x: number, y: number, z: number, volume: number, pitch: number, channel?: string, loop?: boolean): integer, neutron.class.speaker Воспроизведение 3D-аудиопотока. Возвращает ID спикера и объект Speaker.
---@field play_sound fun(name: string, x: number, y: number, z: number, volume: number, pitch: number, channel?: string, loop?: boolean): integer, neutron.class.speaker Воспроизведение звука в 3D. Возвращает ID спикера и объект Speaker.
---@field play_stream_2d fun(name: string, volume: number, pitch: number, channel?: string, loop?: boolean): integer, neutron.class.speaker Воспроизведение 2D-аудиопотока. Возвращает ID спикера и объект Speaker.
---@field play_sound_2d fun(name: string, volume: number, pitch: number, channel?: string, loop?: boolean): integer, neutron.class.speaker Воспроизведение звука в 2D. Возвращает ID спикера и объект Speaker.
---@field count_speakers fun(): number Возвращает количество активных спикеров.
---@field count_streams fun(): number Возвращает количество активных аудиопотоков.
---@field register_duration fun(name: string, duration: number) Регистрирует продолжительность звука в секундах

-- Server.blockwraps

---@class neutron.gfx.blockwrap
---@field unwrap fun(self: neutron.gfx.blockwrap) Удаляет обёртку блока из мира.
---@field set_pos fun(self: neutron.gfx.blockwrap, position: vec3) Устанавливает новую позицию обёртки.
---@field get_pos fun(self: neutron.gfx.blockwrap): vec3 Возвращает текущую позицию обёртки.
---@field set_texture fun(self: neutron.gfx.blockwrap, texture: string) Устанавливает новую текстуру обёртки.
---@field get_texture fun(self: neutron.gfx.blockwrap): string Возвращает текущую текстуру обёртки.

---@class neutron.server.blockwraps
---@field wrap fun(position: vec3, texture: string): integer, neutron.gfx.blockwrap Создаёт обёртку блока в указанной позиции с заданной текстурой. Возвращает ID обёртки и объект BlockWrap для управления.
---@field unwrap fun(id: integer) Удаляет обёртку блока по её ID.
---@field set_pos fun(id: integer, pos: vec3) Устанавливает позицию обёртки
---@field set_texture fun(id: integer, texture: string) Устанавливает текстуру обёртки

-- Server.particles

---@class neutron.gfx.particle
---@field stop fun(self: neutron.gfx.particle) Удаление эммитера частиц
---@field is_alive fun(self: neutron.gfx.particle): boolean Получение состояния эммитера
---@field get_origin fun(self: neutron.gfx.particle): table|number Получение origin эммитера
---@field set_origin fun(self: neutron.gfx.particle, origin: table|number) Изменение origin эммитера
---@field get_pos fun(self: neutron.gfx.particle): vec3 Получение позиции эммитера

---@class neutron.server.particles
---@field emit fun(origin: vec3 | number, count: number, preset: voxelcore.class.particle, extension?: voxelcore.class.particle): neutron.gfx.particle Создаёт частицу. Возвращает объект партиклов или nil, если эффект не найден.
---@field get fun(id: integer): neutron.gfx.particle | nil Получает частицу. Возвращает объект партиклов или nil, если эффект не найден.

-- Server text3d

---@class neutron.gfx.text3d
---@field hide fun(self: neutron.gfx.text3d) Удаляет из мира
---@field get_text fun(self: neutron.gfx.text3d): string Возвращает текст
---@field set_text fun(self: neutron.gfx.text3d, text: string) Устанавливает текст
---@field get_pos fun(self: neutron.gfx.text3d): vec3 Возвращает позицию
---@field set_pos fun(self: neutron.gfx.text3d, pos: vec3) Устанавливает позицию
---@field get_axis_x fun(self: neutron.gfx.text3d): vec3 Возвращает вектор оси X
---@field set_axis_x fun(self: neutron.gfx.text3d, axis: vec3) Устанавливает вектор оси X
---@field get_axis_y fun(self: neutron.gfx.text3d): vec3 Возвращает вектор оси Y
---@field set_axis_y fun(self: neutron.gfx.text3d, axis: vec3) Устанавливает вектор оси X
---@field set_rotation fun(self: neutron.gfx.text3d, rot: mat4) Устанавливает вектора осей
---@field update_settings fun(self: neutron.gfx.text3d, preset: voxelcore.class.text3d) Обновляет настройки отображения

---@class neutron.server.text3d
---@field show fun(position: vec3, text: string, preset: voxelcore.class.text3d, extension?: voxelcore.class.text3d): number, neutron.gfx.text3d Создаёт 3D текст в указанной позиции с заданными параметрами. Возвращает ID текста и объект для управления.
---@field hide fun(id: integer) Удаляет из мира
---@field get_text fun(id: integer): string Возвращает текст
---@field set_text fun(id: integer, text: string) Устанавливает текст
---@field get_pos fun(id: integer): vec3 Возвращает позицию
---@field set_pos fun(id: integer, pos: vec3) Устанавливает позицию
---@field get_axis_x fun(id: integer): vec3 Возвращает вектор оси X
---@field set_axis_x fun(id: integer, axis: vec3) Устанавливает вектор оси X
---@field get_axis_y fun(id: integer): vec3 Возвращает вектор оси Y
---@field set_axis_y fun(id: integer, axis: vec3) Устанавливает вектор оси X
---@field set_rotation fun(id: integer, rot: mat4) Устанавливает вектора осей
---@field update_settings fun(id: integer, preset: voxelcore.class.text3d) Обновляет настройки отображения

-- Server.weather

---@class neutron.class.weather
---@field remove fun(self: neutron.class.weather) Удаление погодного эффекта
---@field move fun(self: neutron.class.weather, x: number, z: number) Только для "point"! Перемещение центра эффекта
---@field set_radius fun(self: neutron.class.weather, radius: number) Только для "point"! Изменение радиуса действия
---@field set_duration fun(self: neutron.class.weather, duration: number) Только для "point"! Изменение продолжительности
---@field set_finish_handler fun(self: neutron.class.weather, handler: function) Только для "point"! Изменение обработчика окончания погоды
---@field set_heightmap_generator fun(self: neutron.class.weather, handler: (fun(x: number, z: number, seed: number): voxelcore.class.HeightMap)) Только для "heightmap"! Установка генератора карты высот
---@field set_height_range fun(self: neutron.class.weather, min: number, max: number) Только для "heightmap"! Установка диапазона высот
---@field get_config fun(self: neutron.class.weather): neutron.class.weather.config Получение конфигурации
---@field get_wid fun(self: neutron.class.weather): number Получение ID эффекта
---@field get_type fun(self: neutron.class.weather): "point"|"heightmap" Получение типа эффекта
---@field is_active fun(self: neutron.class.weather): boolean Проверка активности

---@class neutron.class.weather.region
---@field type "point" | "heightmap" Тип эффекта
---@field x? number Только для "point"! X координата центра эффекта
---@field z? number Только для "point"! Z координата центра эффекта
---@field radius? number Только для "point"! Радиус действия в блоках
---@field duration? number Только для "point"! Продолжительность в секундах (-1 для бесконечного эффекта)
---@field on_finished? function | nil Только для "point"! Функция обратного вызова при завершении эффекта (может быть nil)
---@field heightmap_generator? fun(x: number, z: number, seed: number): voxelcore.class.HeightMap Только для "heightmap"! Функция генерации карты высот
---@field range? [number, number] [min, max] Только для "heightmap"! Диапазон значений высот

---@class neutron.class.weather.config
---@field weather voxelcore.class.weather Настройки погодного эффекта
---@field name? string Имя эффекта
---@field time number Время перехода между состояниями

---@class neutron.server.weather
---@field create fun(region: neutron.class.weather.region, config: neutron.class.weather.config): neutron.class.weather Создаёт погодного эффекта
---@field get fun(wid: number): neutron.class.weather | nil Возвращает объект погоды или nil, если эффект не найден.
---@field get_by_pos fun(x: number, z: number): neutron.class.weather | nil Возвращает объект погоды на указанных координатах или nil.

-- Server.constants

---@class neutron.server.constants.config.game
---@field content_packs string[]
---@field plugins string[]
---@field worlds table<string, { seed: string, generator: string }>
---@field main_world string

---@class neutron.server.constants.config.server
---@field version string
---@field max_players integer
---@field name string
---@field port integer
---@field auto_save_interval number
---@field chunks_loading_distance integer
---@field chunks_loading_speed integer
---@field password_auth boolean
---@field dev_mode boolean
---@field whitelist string[]
---@field blacklist string[]

---@class neutron.server.constants.config.roles.class.role.game_rules
---@field cheat-commands boolean
---@field allow-content-access boolean
---@field allow-flight boolean
---@field allow-noclip boolean
---@field allow-attack boolean
---@field allow-destroy boolean
---@field allow-cheat-movement boolean
---@field allow-debug-cheats boolean
---@field allow-fast-interaction boolean

---@class neutron.server.constants.config.roles.class.role.server_rules
---@field kick boolean
---@field role_management boolean
---@field time_management boolean

---@class neutron.server.constants.config
---@field game neutron.server.constants.config.game
---@field server neutron.server.constants.config.server
---@field roles table<string, { priority: integer, game_rules: neutron.server.constants.config.roles.class.role.game_rules, server_rules: neutron.server.constants.config.roles.class.role.server_rules }> | { default_role: string }

---@class neutron.server.constants
---@field render_distance integer
---@field tps { tps: number, mspt: number }
---@field config neutron.server.constants.config

-- ========================client===========================

-- Client.entities

---@class neutron.client.entities
---@field set_handler fun(entities_table: table<string>, handler: fun(uid:number, def: number, dirty: table)) Указание обработчика
---@field desync fun(name: string) Принимает строковый айди сущности и делает её десинхронной. Десинхронные сущности - сущности, которые видны только клиенту. Их можно заспавнить через entities.spawn на клиенте и при этом они не будут отслеживаться стандартными методами ядра
---@field sync fun(name: string) Принимает строковый айди сущности и делает её синхронной. Синхронные сущности нельзя заспавнить через entities.spawn на клиенте и они будут отслеживаться стандартными методами ядра.

-- Client.env

---@class neutron.client.env
---@field create_env fun(pack: string, env_name: string): neutron.utils.proxy_table Создает прокси-таблицу с автоматической синхронизацией данных при изменении значений. Может хранить только пары ключ-значение. Значение может быть только типами string, number, nil или bool

-- Client.events

---@class neutron.client.events
---@field send fun(pack: string, event: string, bytes: bytearray) Отправляет событие event с данными bytes моду pack на сервер.
---@field on fun(pack: string, event: string, func: fun(bytes: bytearray)) Регистрирует функцию func, которая будет вызвана при получении события event от мода pack. В функцию передаются данные bytes.

-- Client.rpc

---@class neutron.client.rpc.emitter
---@field create_send fun(pack: string, event: string): fun(...) Возвращает функцию, которая принимает неограниченное кол-во аргументов. Полученные аргументы сериализуются с помощью проприетарного bson и отправляются серверному моду pack в ивент event

---@class neutron.client.rpc
---@field emitter neutron.client.rpc.emitter

-- Client.sandbox

---@class neutron.client.sandbox.blocks
---@field sync_inventory fun(pos: neutron.util.pos) Синхронизирует инвентарь.
---@field sync_slot fun(pos: neutron.util.pos, slot: neutron.sandbox.blocks.slot) Синхронизирует определённый слот инвентаря.

---@class neutron.client.sandbox
---@field blocks neutron.client.sandbox.blocks

-- =========================total===========================

---@class neutron.client
---@field entities neutron.client.entities
---@field bson neutron.shared.bson
---@field inventory_data neutron.shared.inventory_data
---@field env neutron.client.env
---@field events neutron.client.events
---@field rpc neutron.client.rpc
---@field sandbox neutron.client.sandbox

---@class neutron.server
---@field accounts neutron.server.accounts
---@field bson neutron.shared.bson
---@field inventory_data neutron.shared.inventory_data
---@field console neutron.server.console
---@field db neutron.server.db
---@field entities neutron.server.entities
---@field env neutron.server.env
---@field events neutron.server.events
---@field middlewares neutron.server.middlewares
---@field protocol neutron.server.protocol
---@field rpc neutron.server.rpc
---@field tasks neutron.server.tasks
---@field sandbox neutron.server.sandbox
---@field audio neutron.server.audio
---@field particles neutron.server.particles
---@field weather neutron.server.weather
---@field text3d neutron.server.text3d
---@field blockwraps neutron.server.blockwraps
---@field constants neutron.server.constants
