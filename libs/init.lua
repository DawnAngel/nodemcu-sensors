
html_title = '<h1>Sensor Data</h1>'

sensor = require('sensor')
utils  = require('utils')
config = require('config')
cjson  = require('cjson')
nats   = require('nats')

sensor.setup()

function sensor_data_to_nats()
    local payload = {
        id   = sensor.id,
        data = tostring(utils.avg_values(sensor.get_data, 10, 1000)),
    }

    nats.publish(config.nats.subject, cjson.encode(payload))
end

function wait_for_network()
    if wifi.sta.getip() ~= nil then
        print('Connected to ip: '..tostring(wifi.sta.getip()))
        tmr.stop(0)

        nats.config(config.nats.connection)
        nats.connect(config.nats.client)

        tmr.alarm(0, 1000, 1, sensor_data_to_nats)

        -- Reset on disconnected
        nats.on_disconnect(node.restart)
    end
end

wifi.setmode(wifi.STATION)
wifi.sta.config(config.wifi.ssid, config.wifi.pass)

tmr.alarm(0, 1000, 1, wait_for_network)
