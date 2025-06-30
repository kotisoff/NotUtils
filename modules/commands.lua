local _mp = require "multiplayer/main"
local title = require "lib/title"
local mp = _mp.api.server
local cl = _mp.api.client


local pack_id = "not_utils"
local packets = {
  title = tohex(1)
}

if _mp.name == "neutron" then
  if _mp.mode == "server" then
    mp.console.set_command("title: players=<string> mode=<string> text=<string> -> Выводит текст на экран", {},
      function(args, client)
        local mode = args.mode
        local text = args.text

        ---@type string
        local players = args.players

        if string.starts_with(players, "@") then
          local players_mode = string.sub(players, 2, 2)
          print(players_mode)
          if players_mode == "a" then
            mp.events.echo(pack_id, packets.title, mp.bson.serialize({ mode, text }))
          elseif players_mode == "s" then
            mp.events.tell(pack_id, packets.title, client, mp.bson.serialize({ mode, text }))
          end
        else
          local target_client = mp.accounts.get_client_by_name(players)
          if not target_client then
            return mp.console.tell("Не удалось вывести сообщение: игрок не найден.", client)
          end

          mp.events.tell(pack_id, packets.title, target_client, mp.bson.serialize({ mode, text }))
        end

        mp.console.tell("Сообщение выведено.", client)
      end)
  elseif _mp.mode == "client" then
    cl.events.on(pack_id, packets.title, function(bytes)
      ---@type ["title"|"actionbar"|"subtitle", str]
      local args = cl.bson.deserialize(bytes)
      local mode, text = unpack(args)

      local module = title[mode]
      if not module then return console.log(string.format('Режим "%s" не найден.', mode)) end
      module:show(text)
    end)
  end
elseif _mp.name == "standalone" then
  console.add_command("title mode:str text:str", "Выводит текст на экран", function(args)
    local mode, text = unpack(args)
    local module = title[mode]
    if not module then return console.log(string.format('Режим "%s" не найден.', mode)) end
    module:show(text)
  end)
end
