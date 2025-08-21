local _mp = require "multiplayer/main"
if _mp.mode ~= "standalone" then return end

local mp = _mp.api.server

local chat_controller = require "multiplayer/chat/chat"

console.add_command(
    "chat message:str",
    "Send message",
    function (args)
        chat_controller.command(args[1], mp.accounts.get_client_by_name(""))
    end
)
console.submit = function (command)
    local name, _ = command:match("^(%S+)%s*(.*)$")

    if name == "chat" then
        console.execute(command)
    else
        console.execute("chat '/"..command.."'")
    end
end