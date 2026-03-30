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
    local name, _ = command:match("^(%S+)%s*(.*)$")

    if name == "chat" then
        console.execute(command)
    else
        console.execute("chat '/" .. command .. "'")
    end
end
