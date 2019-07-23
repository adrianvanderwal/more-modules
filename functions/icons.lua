function get_layered_icon(type, tier)
    local icons = {
        {
            icon = '__more-modules__/graphics/module/' .. type .. '-module.png',
            icon_size = 32
        }
    }
    local number = tostring(tier)
    local t = {}
    for i = 1, #number do
        t[i] = number:sub(i, i)
    end

    -- the return table
    --local icons = {}

    local scale = 0.5
    local shift = {x = 5, y = -7}
    --local tint = {r = 1, g = 0, b = 0}
    for i = #t, 1, -1 do
        -- get icon, scale and shift based on i(?)
        --log('graphics/number/' .. t[i] .. '.lua')
        table.insert(
            icons,
            {
                icon = '__more-modules__/graphics/numbers/' .. t[i] .. '.png',
                icon_size = 32,
                scale = scale,
                shift = shift,
                --tint = tint
            }
        )
    end
    return icons
end
