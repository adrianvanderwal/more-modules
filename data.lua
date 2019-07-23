require('functions/icons')

get_layered_icon('speed', 100)

data.raw.module['speed-module'].icon = nil
data.raw.module['speed-module'].icons = get_layered_icon('speed', 1)

log(serpent.block(data.raw.module['speed-module']))

--get_icon_number(1)

--get_icon_number(100)

--get_icon_number(1234567890)
