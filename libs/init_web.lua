
html_title = '<h1>Sensor Data</h1>'

sensor = require('sensor')
utils  = require('utils')
config = require('config')

sensor.setup()

function sensor_data_to_html()
    return "<h3><b>" .. sensor.id .. ":</b> <i>" .. tostring(utils.avg_values(sensor.get_data, 10, 1000)) .. "</i></h3>"
end

function setup_http_server(get_data_formatted)
    srv=net.createServer(net.TCP)
        srv:listen(80,function(conn)
        data_formatted = get_data_formatted()
        conn:send("<!DOCTYPE html><html><body>" .. html_title .. data_formatted .. "</body></html>")
        conn:on("sent",function(conn) conn:close() end)
    end)
end

function wait_for_network()
    if wifi.sta.getip() ~= nil then
        print('Connected to ip: '..tostring(wifi.sta.getip()))
        tmr.stop(0)
        setup_http_server(sensor_data_to_html)
    end
end

wifi.setmode(wifi.STATION)
wifi.sta.config(config.wifi.ssid, config.wifi.pass)

tmr.alarm(0, 1000, 1, wait_for_network)
