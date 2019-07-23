function trunc(num, digits)
    local mult = 10 ^ (digits)
    return math.modf(num * mult) / mult
end

-- functions for creation of modules
function get_speed_bonus(tier)
    local bonus = 0.2
    if tier == 1 then
        return bonus
    end
    local difference = 0.1
    for i = 2, tier, 1 do
        bonus = bonus + difference
        difference = difference * 2
    end
    return bonus
end

function get_speed_module_effects(tier)
    return {
        --speed = {bonus = get_speed_bonus(tier)},
        speed = {bonus = 0.2 + 0.1 * (2 ^ (tier - 1) - 1)},
        consumption = {bonus = (0.1 * tier + 0.4)}
    }
end
function get_productivity_module_effects(tier)
    return {
        productivity = {bonus = (0.02 + 0.02 ^ tier)},
        consumption = {bonus = (0.2 * tier + 0.2)},
        pollution = {bonus = (0.025 * tier + 0.025)},
        speed = {bonus = -0.15}
    }
end
function get_effectivity_module_effects(tier)
    return {
        consumption = {bonus = -(0.10 * tier + 0.20)}
    }
end

function get_module_recipe(type, tier)
    -- exception for tier 1
    if tier == 1 then
        return {
            {'electronic-circuit', 5},
            {'advanced-circuit', 5}
        }
    end
    return {
        {'advanced-circuit', 5},
        {'processing-unit', 5},
        {type .. '-module-' .. tier - 1, tier + 2}
    }
end
