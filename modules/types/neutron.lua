-- UTILS

-- aliases

---@alias neutron.utils.proxy_table table

-- classes

---@class neutron.class.account
---@field username string
---@field active boolean
---@field is_logged boolean
---@field role string

---@class neutron.class.player
---@field username string
---@field active boolean
---@field pid number
---@field region_pos { x: number, z: number }

---@class neutron.class.client
---@field active boolean
---@field account neutron.class.account
---@field player neutron.class.player

-- bson

---@class neutron.utils.bson
---@field serialize fun(tbl: table): table Writes data from tbl into buffer
---@field deserialize fun(buf: any): table Reads data from buffer

-- env

-- SERVER

---@class neutron.utils.env
---@field create_env fun(pack: string, env_name: string): neutron.utils.proxy_table

-- Server.accounts

---@class neutron.server.accounts.roles
---@field get fun(account: neutron.class.account): table
---@field get_rules fun(account: neutron.class.account, category: boolean): table Category: true = game_rules; false = server_rules
---@field is_higher fun(role1: table, role2: table): boolean
---@field exists fun(role: table): boolean

---@class neutron.server.accounts
---@field get_account_by_name fun(name: string): neutron.class.account
---@field get_client fun(account: neutron.class.account): neutron.class.client
---@field kick fun(account: neutron.class.account, reason?: string)
---@field roles neutron.server.accounts.roles

-- Server.console

---@class neutron.console.state
---@field move_to fun(self: neutron.console.state, state: neutron.console.state)
---@field clear fun(self: neutron.console.state)
---@field update_data fun(self: neutron.console.state, key: string, data: any)
---@field get_data fun(self: neutron.console.state, key?: string): any | nil

---@alias neutron.console.colors { red: string, yellow: string, blue: string, black: string, green: string, white: string }

---@class neutron.server.console
---@field set_command fun(scheme: string, permissions: table<table<string>>, handler: function, allow_not_authorized: boolean) see: https://github.com/Xertis/Neutron-Server/blob/main/docs/API/Библиотеки/сервер/console.md
---@field create_state fun(name: string): neutron.console.state
---@field set_state fun(state: neutron.console.state, client: neutron.class.client)
---@field set_state_handler fun(state: neutron.console.state, handler: fun(message: string, state: neutron.console.state, client: neutron.class.client))
---@field tell fun(message: string, client: neutron.class.client)
---@field echo fun(message: string)
---@field execute fun(message: string, client: neutron.class.client)
---@field colors neutron.console.colors

-- Server.database

---@alias neutron.db.response_code 200 | 101 | 102 | 201 Success: 200, DatabaseExists: 101, DatabaseNotExists: 102, TableExists: 201
---@alias neutron.db.Column { column_type: string, config: table }

---@class neutron.db.session
---@field init_table fun(self: neutron.db.session, config: {__tablename__: string}): neutron.db.session
---@field order_by fun(self: neutron.db.session, field: string, reverse?: boolean): neutron.db.session
---@field first fun(self: neutron.db.session): any
---@field last fun(self: neutron.db.session): any
---@field all fun(self: neutron.db.session): table<any>
---@field query fun(self: neutron.db.session, query: string): neutron.db.session
---@field limit fun(self: neutron.db.session): neutron.db.session
---@field filter fun(self: neutron.db.session, filter: table): neutron.db.session
---@field add fun(self: neutron.db.session, tablename: string, data: table)
---@field update fun(self: neutron.db.session, tablename: string, primary_key_value: any, data: table)
---@field delete fun(self: neutron.db.session, tablename: string, filter: table)
---@field remove_table fun(self: neutron.db.session, tablename: string)

---@class neutron.server.db.db
---@field register fun(): nil | neutron.db.response_code
---@field exists fun(pack: string): boolean
---@field login fun(): neutron.db.session | neutron.db.response_code

---@class neutron.server.db.items
---@field Column fun(type: string, config?: table): neutron.db.Column

---@class neutron.server.db
---@field db neutron.server.db.db
---@field items neutron.server.db.items
---@field types { codes: table<string, number>, indexes: table<string> }

-- Server.entities

---@alias neutron.entity.field { maximum_deviation: number, evaluate_deviation: (fun(distance_to_player, server_value, client_value): number), provider?: fun(uid, field_name): boolean | any }
---@alias neutron.entity.registration_config {standart_fields?: table<string, neutron.entity.field>, custom_fields?: table<string, neutron.entity.field>, textures?: table<string, neutron.entity.field>, models?: table<string, neutron.entity.field>, components?: table<string, neutron.entity.field> }

---@class neutron.server.entities.players
---@field add_field fun( field_type: string, key: string, field: neutron.entity.field )

---@class neutron.server.entities
---@field register fun(entity_name: string, config: neutron.entity.registration_config, spawn_handler: fun(name: string, args: table | nil, client: neutron.class.client))
---@field eval { NotEquals: (fun(): number), Always: (fun(): number), Never: (fun(): number) }
---@field players neutron.server.entities.players
---@field types { Custom: string, Standart: string, Models: string, Textures: string, Components: string }

-- Server.events

---@class neutron.server.events
---@field tell fun(pack: string, event: string, client: neutron.class.client, bytes: any)
---@field echo fun(pack: string, event: string, bytes: any)
---@field on fun(pack: string, event: string, func: fun(client: neutron.class.client, bytes: any))

-- Server.middlewares

---@alias neutron.alias.middleware_fun fun(packet: table, client: neutron.class.client): boolean|nil

---@class neutron.server.middlewares
---@field receive { add_middleware:(fun(packet_type: string, middleware: neutron.alias.middleware_fun)), add_general_middleware: fun(middleware: neutron.alias.middleware_fun) }

-- Server.protocol

---@class neutron.server.protocol
---@field tell fun(client: neutron.class.client, packet_type: string, data: table)
---@field echo fun(packet_type: string, data: table)

-- Server.rpc

---@class neutron.server.rpc.emitter
---@field create_tell fun(pack: string, event: string): fun(client: neutron.class.client, ...)
---@field create_echo fun(pack: string, event: string): fun(...)

---@class neutron.server.rpc
---@field emitter neutron.server.rpc.emitter

-- Server.sandbox

---@class neutron.server.sandbox.players
---@field get_all fun(): table<string, neutron.class.player>
---@field get_in_radius fun(pos: {x:number, y:number,z:number}, radius: number): table<string, neutron.class.player>
---@field get_player fun(account: neutron.class.account): neutron.class.player
---@field get_by_pid fun(pid): neutron.class.player | nil
---@field set_pos fun(player: neutron.class.player, pos: {x:number, y: number, z: number})

---@class neutron.server.sandbox
---@field players neutron.server.sandbox.players

-- Server.audio

---@class neutron.class.speaker
---@field stop fun(self: neutron.class.speaker)
---@field pause fun(self: neutron.class.speaker)
---@field resume fun(self: neutron.class.speaker)
---@field is_loop fun(self: neutron.class.speaker): boolean
---@field set_loop fun(self: neutron.class.speaker, loop: boolean)
---@field get_volume fun(self: neutron.class.speaker): number
---@field set_volume fun(self: neutron.class.speaker, volume: number)
---@field get_pitch fun(self: neutron.class.speaker): number
---@field set_pitch fun(self: neutron.class.speaker, pitch: number)
---@field get_time fun(self: neutron.class.speaker): number
---@field set_time fun(self: neutron.class.speaker, time: number)
---@field get_position fun(self: neutron.class.speaker): number, number, number
---@field set_position fun(self: neutron.class.speaker, x: number, y: number, z: number)
---@field get_velocity fun(self: neutron.class.speaker): number, number, number
---@field set_velocity fun(self: neutron.class.speaker, x: number, y: number, z: number)
---@field get_duration fun(self: neutron.class.speaker): number

---@class neutron.server.audio
---@field play_stream fun(name: string, x: number, y: number, z: number, volume: number, pitch: number, channel?: string, loop?: boolean): number, neutron.class.speaker
---@field play_sound fun(name: string, x: number, y: number, z: number, volume: number, pitch: number, channel?: string, loop?: boolean): number, neutron.class.speaker
---@field play_stream_2d fun(name: string, volume: number, pitch: number, channel?: string, loop?: boolean): number, neutron.class.speaker
---@field play_sound_2d fun(name: string, volume: number, pitch: number, channel?: string, loop?: boolean): number, neutron.class.speaker
---@field count_speakers fun(): number
---@field count_streams fun(): number

-- Server.particles

---@class neutron.gfx.particle
---@field stop fun(self: neutron.gfx.particle)
---@field is_alive fun(self: neutron.gfx.particle): boolean
---@field get_origin fun(self: neutron.gfx.particle): table|number
---@field set_origin fun(self: neutron.gfx.particle, origin: table|number)
---@field get_pos fun(self: neutron.gfx.particle): vec3

---@class neutron.server.particles
---@field emit fun(origin: vec3 | number, count: number, preset: table, extension?: table): neutron.gfx.particle
---@field get fun(pid: integer): neutron.gfx.particle | nil

-- Server text3d

---@class neutron.gfx.text3d
---@field hide fun(self: neutron.gfx.text3d)
---@field get_text fun(self: neutron.gfx.text3d): string
---@field set_text fun(self: neutron.gfx.text3d, text: string)
---@field get_pos fun(self: neutron.gfx.text3d): vec3
---@field set_pos fun(self: neutron.gfx.text3d, pos: vec3)
---@field get_axis_x fun(self: neutron.gfx.text3d): vec3
---@field set_axis_x fun(self: neutron.gfx.text3d, axis: vec3)
---@field get_axis_y fun(self: neutron.gfx.text3d): vec3
---@field set_axis_y fun(self: neutron.gfx.text3d, axis: vec3)
---@field set_rotation fun(self: neutron.gfx.text3d, rot: table)
---@field update_settings fun(self: neutron.gfx.text3d, preset: table)

---@class neutron.server.text3d
---@field show fun(position: vec3, text: string, preset: table, extension?: table): number, neutron.gfx.text3d
---@field hide fun(id: number)
---@field get_text fun(id: number): string
---@field set_text fun(id: number, text: string)
---@field get_pos fun(id: number): vec3
---@field set_pos fun(id: number, pos: vec3)
---@field get_axis_x fun(id: number): vec3
---@field set_axis_x fun(id: number, axis: vec3)
---@field get_axis_y fun(id: number): vec3
---@field set_axis_y fun(id: number, axis: vec3)
---@field set_rotation fun(id: number, rot: table) Тут ваще должно быть mat4, но делать алиас для этого я ебал, ибо не шарю. ultrapohuistas
---@field update_settings fun(id: number, preset: table)

-- Server.weather

---@class neutron.class.weather
---@field remove fun(self: neutron.class.weather)
---@field move fun(self: neutron.class.weather, x: number, z: number) For "point" only
---@field set_radius fun(self: neutron.class.weather, radius: number) For "point" only
---@field set_duration fun(self: neutron.class.weather, duration: number) For "point" only
---@field set_finish_handler fun(self: neutron.class.weather, handler: function) For "point" only
---@field set_heightmap_generator fun(self: neutron.class.weather, handler: fun(x: number, z: number, seed: number): voxelcore.class.HeightMap) For "heightmap" only
---@field set_height_range fun(self: neutron.class.weather, min: number, max: number) For "heightmap" only
---@field get_config fun(self: neutron.class.weather): neutron.class.weather.config
---@field get_wid fun(self: neutron.class.weather): number
---@field get_type fun(self: neutron.class.weather): "point"|"heightmap"
---@field is_active fun(self: neutron.class.weather): boolean

---@class neutron.class.weather.region
---@field type "point" | "heightmap"
---@field x? number For "point" only!
---@field z? number For "point" only!
---@field radius? number For "point" only!
---@field duration? number For "point" only!
---@field on_finished? function | nil For "point" only!
---@field heightmap_generator? fun(x: number, z: number, seed: number): voxelcore.class.HeightMap For "heightmap" only!
---@field range? [number, number] {min, max} For "heightmap" only!

---@class neutron.class.weather.config
---@field weather table
---@field name string
---@field time number

---@class neutron.server.weather
---@field create fun(region: neutron.class.weather.region, config: neutron.class.weather.config): neutron.class.weather
---@field get fun(wid: number): neutron.class.weather | nil
---@field get_by_pos fun(x: number, z: number): neutron.class.weather | nil

-- CLIENT

-- Client.entities

---@class neutron.client.entities
---@field set_handler fun(entities_table: table<string>, handler: fun(uid:number, def: number, dirty: table))
---@field desync fun(name: string)
---@field sync fun(name: string)

-- Client.events

---@class neutron.client.events
---@field send fun(pack: string, event: string, bytes: any)
---@field on fun(pack: string, event: string, func: fun(bytes: any))

-- Client.rpc

---@class neutron.client.rpc.emitter
---@field create_send fun(pack: string, event: string): fun(...)

---@class neutron.client.rpc
---@field emitter neutron.client.rpc.emitter

---------------------------------------- Всё нахуй

---@class neutron.client
---@field entities neutron.client.entities
---@field bson neutron.utils.bson
---@field env neutron.utils.env
---@field events neutron.client.events
---@field rpc neutron.client.rpc

---@class neutron.server
---@field accounts neutron.server.accounts
---@field bson neutron.utils.bson
---@field console neutron.server.console
---@field db neutron.server.db
---@field entities neutron.server.entities
---@field env neutron.utils.env
---@field events neutron.server.events
---@field middlewares neutron.server.middlewares
---@field protocol neutron.server.protocol
---@field rpc neutron.server.rpc
---@field sandbox neutron.server.sandbox
---@field audio neutron.server.audio
---@field particles neutron.server.particles
---@field text3d neutron.server.text3d
---@field weather neutron.server.weather

---------------------------------------- Теперь точно Всё нахуй
