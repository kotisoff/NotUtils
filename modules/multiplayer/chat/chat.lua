local states = require "multiplayer/chat/chat_states"
local module = {}

local no_logged_commands = {}
local handlers = {}

local COMMAND_PREFIX = '/'

function module.echo(message)
   console.log(message)
end

function module.echo_with_mentions(message)
    console.log(message)
end

function module.tell(message, client)
    console.log(message)
end

function module.command(message, client)
    local state = states.get_state(client)

    if message[1] ~= COMMAND_PREFIX and not state then
        module.echo("[you] " .. message)
        return false
    end

    if not state then
        message = string.sub(message, 2)
    end

    local args = string.soft_space_split(message)
    local executable = args[1]
    table.remove(args, 1)

    if not client.account.is_logged and not table.has(no_logged_commands, executable) then
        return
    end

    if handlers[executable] and not state then
        handlers[executable].handler(args, client)
    elseif state then
        handlers[state.id].handler(message, state, client)
    else
        module.tell("[#ff0000] Unknow command: " .. executable, client)
    end
end

function module.add_command(schem, handler, is_no_logged)
    if handlers[schem[1]] then
        return false
    end

    if is_no_logged then
        table.insert(no_logged_commands, schem[1])
    end

    handlers[schem[1]] = { handler = handler, schem = schem }
    return true
end

function module.set_state_handler(state, handler)
    if handlers[state.id] then
        return false
    end

    handlers[state.id] = { handler = handler }
end

function module.get_handlers()
    local pairs_handlers = {}

    for key, handler in pairs(handlers) do
        if type(key) ~= "number" then
            pairs_handlers[key] = handler
        end
    end
    return pairs_handlers
end

return module
