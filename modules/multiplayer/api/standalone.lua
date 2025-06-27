-- ========================module===========================

local module = {}

---@return boolean
function module.check()
  return true
end

---@return "standalone" | "client" | "server"
function module.mode()
  return "standalone"
end

-- ======================class=utils========================

---@param object any
---@param data { id: int }
local function wrap_object(object, data)
  local __index = {}
  for key, value in pairs(object) do
    __index[key] = function(self, ...)
      value(self.id, ...)
    end
  end

  return setmetatable(data, { __index = __index })
end

---@return neutron.class.account
local function get_account()
  return {
    username = "Player",
    active = true,
    is_logged = true,
    role = "member"
  }
end

---@return neutron.class.player
local function get_player()
  local pid = hud.get_player()
  local x, _, z = player.get_pos(pid)
  local region_pos = { x = math.floor(x / 16), z = math.floor(z / 16) }

  return {
    username = "Player",
    active = true,
    pid = pid,
    region_pos = region_pos
  }
end

---@return neutron.class.client
local function get_client()
  return {
    active = true,
    account = get_account(),
    player = get_player()
  }
end

-- ====================shared=objects=======================

---@type neutron.shared.bson
local bson = {
  serialize = function(tbl)
    return tbl
  end,
  deserialize = function(buf)
    return buf
  end
}

---@type neutron.shared.inventory_data
local inventory_data = {
  serialize = function(inv)
    return inv
  end,
  deserialize = function(buf)
    return buf
  end
}

-- =====================server=audio========================

local function create_speaker(id)
  ---@type neutron.class.speaker
  local speaker = wrap_object(audio, { id = id })
  function speaker:get_time_left()
    local осталось_секунд_блядь = speaker:get_duration() - speaker:get_time()
    return math.max(осталось_секунд_блядь, 0)
  end

  return speaker
end

---@type neutron.server.audio
local audio = {
  play_sound = function(...)
    local id = audio.play_sound(...)
    return id, create_speaker(id)
  end,
  play_sound_2d = function(...)
    local id = audio.play_sound_2d(...)
    return id, create_speaker(id)
  end,
  play_stream = function(...)
    local id = audio.play_stream(...)
    return id, create_speaker(id)
  end,
  play_stream_2d = function(...)
    local id = audio.play_stream_2d(...)
    return id, create_speaker(id)
  end,
  count_speakers = audio.count_speakers,
  count_streams = audio.count_streams,
  register_duration = function(name, duration)
    -- А, да? ну ладно.
  end
}

-- ===================module=server=api=====================

---@return neutron.server
function module.server_api()
  ---@type neutron.server
  local api = {
    accounts = {
      get_account_by_name = function(name)
        return get_account()
      end,
      get_client = function(account)
        return get_client()
      end,
      get_client_by_name = function(username)
        return get_client()
      end,
      kick = function(account, reason) end,
      roles = {
        get = function(account)
          return { "member" }
        end,
        get_rules = function(account, category)
          return {}
        end,
        is_higher = function(role1, role2)
          return false
        end,
        exists = function(role)
          if role == "member" then
            return true
          end
          return false
        end
      }
    },
    bson = bson,
    inventory_data = inventory_data,
    console = {
      set_command = function(scheme, permissions, handler, allow_not_authorized) end,
      create_state = function(name) return {} end,
      set_state = function(...) end,
      set_state_handler = function(...) end,
      tell = function(message, client)
        console.log(message)
      end,
      echo = function(message)
        console.log(message)
      end,
      execute = function(message, client)
        console.execute(message)
      end,
      colors = {
        red = "[#ff0000]",
        yellow = "[#ffff00]",
        blue = "[#0000FF]",
        black = "[#000000]",
        green = "[#00FF00]",
        white = "[#FFFFFF]"
      }
    },
    ---@diagnostic disable-next-line: assign-type-mismatch
    db = nil,
    entities = {
      register = function(...) end,
      eval = {
        NotEquals = function() return 0 end,
        Always = function() return 0 end,
        Never = function() return 0 end
      },
      types = {
        Custom = "custom_fields",
        Standart = "standart_fields",
        Models = "models",
        Textures = "textures",
        Components = "components"
      },
      players = {
        add_field = function(...) end
      }
    },
    events = {
      tell = function(pack, event, client, bytes)
        events.emit(pack .. ':s:' .. event, bytes)
      end,
      echo = function(pack, event, bytes)
        events.emit(pack .. ':s:' .. event, bytes)
      end,
      on = function(pack, event, func)
        events.on(pack .. ':c:' .. event, function(data)
          func(get_client(), data)
        end)
      end
    },
    ---@diagnostic disable-next-line: assign-type-mismatch
    middlewares = nil,
    ---@diagnostic disable-next-line: assign-type-mismatch
    protocol = nil,
    rpc = {
      emitter = {
        create_echo = function(pack, event)
          return function(...)
            events.emit(pack .. ':s:' .. event, ...)
          end
        end,
        create_tell = function(pack, event)
          return function(client, ...)
            events.emit(pack .. ':s:' .. event, ...)
          end
        end
      }
    },
    env = {
      private = {
        create = function()
          return {}
        end
      },
      public = {
        create = function()
          return {}
        end
      }
    },
    sandbox = {
      players = {
        get_all = function()
          local player = get_player()
          return { [player.username] = player }
        end,
        get_in_radius = function(pos, radius)
          local len = vec3.length(pos)
          if len <= radius then
            local player = get_player()
            return { [player.username] = player }
          end
          return {}
        end,
        get_player = function(account)
          return get_player()
        end,
        get_by_pid = function(pid)
          if pid == 0 then
            return get_player()
          end
        end,
        sync_states = function(_player, states)
          if states.pos then
            local pos = states.pos
            ---@diagnostic disable-next-line: need-check-nil
            player.set_pos(_player.pid, pos.x, pos.y, pos.z)
          end
          if states.rot then
            local rot = states.rot
            ---@diagnostic disable-next-line: need-check-nil
            player.set_rot(_player.pid, rot.yaw, rot.pitch, 0)
          end
          if states.cheats then
            local noclip, flight = states.cheats.noclip, states.cheats.flight
            player.set_flight(_player.pid, flight)
            player.set_noclip(_player.pid, noclip)
          end
        end
      }
    },
    audio = audio,
    particles = {
      emit = function(...)
        local id = gfx.particles.emit(...)
        ---@type neutron.gfx.particle
        local obj = wrap_object(gfx.particles, { id = id })
        obj.get_pos = function(self)
          local origin = self:get_origin()
          if type(origin) == "number" then
            local entity = entities.get(origin)
            return entity.transform:get_pos()
          end
          return origin
        end

        return obj
      end,
      get = function(id)
        if not id then error("Pizdec! PID не указан!") end
        return wrap_object(gfx.particles, { id = id })
      end
    },
    text3d = {
      show = function(position, text, preset, extension)
        local id = gfx.text3d.show(position, text, preset, extension)
        return id, wrap_object(gfx.particles, { id = id })
      end,
      hide = function(...)
        return gfx.text3d.hide(...)
      end,
      get_text = function(...)
        return gfx.text3d.get_text(...)
      end,
      set_text = function(...)
        return gfx.text3d.set_text(...)
      end,
      get_pos = function(...)
        return gfx.text3d.get_pos(...)
      end,
      set_pos = function(...)
        return gfx.text3d.set_pos(...)
      end,
      get_axis_x = function(...)
        return gfx.text3d.get_axis_x(...)
      end,
      set_axis_x = function(...)
        return gfx.text3d.set_axis_x(...)
      end,
      get_axis_y = function(...)
        return gfx.text3d.get_axis_y(...)
      end,
      set_axis_y = function(...)
        return gfx.text3d.set_axis_y(...)
      end,
      set_rotation = function(...)
        return gfx.text3d.set_rotation(...)
      end,
      update_settings = function(...)
        return gfx.text3d.update_settings(...)
      end
    },
    blockwraps = {
      wrap = function(position, texture)
        local id = gfx.blockwraps.wrap(position, texture)
        return id, wrap_object(gfx.blockwraps, { id = id })
      end,
      unwrap = function(id)
        gfx.blockwraps.unwrap(id)
      end,
      set_pos = function(id, pos)
        gfx.blockwraps.set_pos(id, pos)
      end,
      set_texture = function(id, texture)
        gfx.blockwraps.set_texture(id, texture)
      end
    },
    ---@diagnostic disable-next-line: assign-type-mismatch
    weather = nil
  }

  return api
end

---@return neutron.client
function module.client_api()
  ---@type neutron.client
  local api = {
    entities = {
      set_handler = function(...) end,
      desync = function(...) end,
      sync = function(...) end
    },
    bson = bson,
    inventory_data = inventory_data,
    env = {
      create_env = function(pack, env_name)
        return {}
      end
    },
    events = {
      send = function(pack, event, bytes)
        events.emit(pack .. ':c:' .. event, bytes)
      end,
      on = function(pack, event, func)
        events.on(pack .. ':s:' .. event, func)
      end
    },
    rpc = {
      emitter = {
        create_send = function(pack, event)
          return function(...)
            events.emit(pack .. ':c:' .. event, ...)
          end
        end
      }
    }
  }

  return api
end

return module
