-- Utils lib

local utils = {}

function utils.avg_values(reader_function, samples, delay)
    local count = samples
    local drop  = (count * 75) / 100
    local total = 0
    local data

    for i=1,samples do
        data = reader_function()
        if drop > 0 and data == 0 then
            drop  = drop - 1
            count = count - 1
        end
        total = total + data
        tmr.delay(delay)
    end

    return total / count
end

return utils
