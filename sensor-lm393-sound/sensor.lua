-- Sound Sensor with 3 levels
-- Tested with Lua NodeMCU 0.9.6 build 20150704 integer

local sensor = {}

sensor.id = 'nodemcu-sound-3-levels'

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
    local sound_level

    if gpio.read(PIN_LEVEL_HIGH) == ACTIVE_VALUE then
        sound_level = 100
    elseif gpio.read(PIN_LEVEL_MEDIUM) == ACTIVE_VALUE then
        sound_level = 66
    elseif gpio.read(PIN_LEVEL_LOW) == ACTIVE_VALUE then
        sound_level = 33
    else
        sound_level = 0
    end

    return sound_level
end

return sensor
