local _mp = require "multiplayer/main"
if _mp.mode ~= "standalone" then return end

local mp = _mp.api.server

local chat_controller = require "multiplayer/chat/chat"

console.add_command(
    "chat message:str",
    "Send message",
    function(args)
        local identity = mp.sandbox.players.get_by_pid(hud.get_player()).identity;
        local client = mp.accounts.by_identity.get_client(identity)
        chat_controller.command(args[1], client)
    end,
    false
)

console.submit = function(command)
    local name, body = command:match("^(%S+)%s*(.*)$")

    if name == "chat" then
        console.execute(command)
    elseif string.starts_with(name, "/") then
        local valid_name = string.sub(name, 2)
        -- if rules.get("cheat-commands") then

        -- end
        if #body > 0 then body = " " .. body end

        print(valid_name, body);
        local msg = console.execute(valid_name .. body);
        console.log(msg);
    else
        console.execute("chat '/" .. command .. "'")
    end
end
