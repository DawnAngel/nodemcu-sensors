local nats = {
    _VERSION     = 'lua-nodemcu-nats 0.0.2',
    _DESCRIPTION = 'LUA NodeMcu client for NATS messaging system. https://nats.io',
    _COPYRIGHT   = 'Copyright (C) 2015 Eric Pinto',
}


-- ### Library requirements ###

local cjson  = require('cjson')


-- ### default_values ###

local defaults = {
    host = '127.0.0.1',
    port = 4242,
}

local client_defaults = {
    user     = nil,
    pass     = nil,
    lang     = 'lua',
    version  = '0.0.2',
    verbose  = false,
    pedantic = false,
}

local function merge_defaults(parameters, defaults)
    if parameters == nil then
        parameters = {}
    end
    for k, v in pairs(defaults) do
        if parameters[k] == nil then
            parameters[k] = defaults[k]
        end
    end
    return parameters
end

-- ### Socket connection methods ###

local function create_connection(parameters)
    if parameters.socket then
        return parameters.socket
    end

    local socket = net.createConnection(net.TCP, 0)

    socket:connect(tonumber(parameters.port), parameters.host)

    return socket
end

local function do_request(socket, request)
    socket:send(request)
end

local function response_reader(socket)
    socket:on("receive", function(_, payload)
        local slices = {}

        for slice in payload:gmatch('[^%s]+') do
            table.insert(slices, slice)
        end

        -- PING
        if slices[1] == 'PING' then
            nats.pong()

        -- INFO
        elseif slices[1] == 'INFO' then
            nats.server_config = cjson.decode(slices[2])
        end
    end)
end

-- ### NATS methods ###

function nats.config(...)
    local args, parameters = {...}, nil

    if #args == 1 then
        parameters = args[1]
    elseif #args > 1 then
        local host, port = unpack(args)
        parameters = { host = host, port = port }
    end

    nats.socket = create_connection(merge_defaults(parameters, defaults))
end

function nats.connect(client)
    local config = merge_defaults(client, client_defaults)

    response_reader(nats.socket)

    do_request(nats.socket, 'CONNECT ' .. cjson.encode(config) .. '\r\n')
end

function nats.publish(subject, payload)
    do_request(nats.socket, 'PUB ' .. subject .. ' ' .. #payload .. '\r\n')
    do_request(nats.socket, payload .. '\r\n')
end

function nats.pong()
    do_request(nats.socket, 'PONG\r\n')
end

function nats.on_disconnect(callback)
    nats.socket:on("disconnection", callback)
end

return nats
