-- Light Sensor with 3 levels
-- Tested with Lua NodeMCU 0.9.6 build 20150704 integer

local sensor = {}

sensor.id = 'nodemcu-light-3-levels'

local ACTIVE_VALUE = 0

local PIN_LEVEL_LOW    = 1
local PIN_LEVEL_MEDIUM = 2
local PIN_LEVEL_HIGH   = 3

function sensor.setup()
    gpio.mode(PIN_LEVEL_LOW, gpio.INPUT)
    gpio.mode(PIN_LEVEL_MEDIUM, gpio.INPUT)
    gpio.mode(PIN_LEVEL_HIGH, gpio.INPUT)
end

function sensor.get_data()
    local light_level

    if gpio.read(PIN_LEVEL_HIGH) == ACTIVE_VALUE then
        light_level = 100
    elseif gpio.read(PIN_LEVEL_MEDIUM) == ACTIVE_VALUE then
        light_level = 66
    elseif gpio.read(PIN_LEVEL_LOW) == ACTIVE_VALUE then
        light_level = 33
    else
        light_level = 0
    end

    return light_level
end

return sensor
