local more_module_slots_defines = require('defines')
local module_types = {
    ['speed'] = true,
    ['productivity'] = true,
    ['effectivity'] = true
}

-- remove vanilla modules

-- insert new ones
for type, _ in pairs(module_types) do
    for i = 1, settings.startup[more_module_slots_defines.names.settings.more_modules_tiers].value, 1 do
        if type == 'speed' then

        end
    end
end

-- rebuild modules from the ground up.
-- if module-0
-- add items, recipes and tech

-- change recipes that require module-1's
for _, module_type in pairs(module_types) do
    -- get base module
    local module_name = module_type.name
    local module_item = table.deepcopy(data.raw.module[module_name .. '-module'])
    local module_recipe = table.deepcopy(data.raw.recipe[module_name .. '-module'])
    local module_technology = table.deepcopy(data.raw.technology[module_name .. '-module'])
    -- redo tier 1 modules
    -- rename tier 1 module item
    local tier_1_item = table.deepcopy(data.raw.module[module_name .. '-module'])
    tier_1_item.name = module_name .. '-module-1'
    data.raw.module[module_name .. '-module'] = nil
    -- recipe
    local tier_1_recipe = table.deepcopy(data.raw.recipe[module_name .. '-module'])
    tier_1_recipe.name = module_name .. '-module-1'
    tier_1_recipe.result = module_name .. '-module-1'
    data.raw.recipe[module_name .. '-module'] = nil
    -- technology
    local tier_1_technology = table.deepcopy(data.raw.technology[module_name .. '-module'])
    tier_1_technology.name = module_name .. '-module-1'
    data.raw.technology[module_name .. '-module'] = nil

    data:extend({tier_1_item, tier_1_recipe, tier_1_technology})

    -- replace all tier 1 recipe items
    for _, recipe in pairs(data.raw.recipe) do
        if recipe then
            --recipe = data.raw.recipe[recipe]
            if recipe.ingredients ~= nil then
                --log(recipe.name)
                for i, ingredient in pairs(recipe.ingredients) do
                    if ingredient[1] == module_name .. '-module' then
                        local amount = ingredient[2]
                        table.remove(recipe.ingredients, i)
                        table.insert(recipe.ingredients, {module_name .. '-module-1', amount})
                    end
                end
            end
            if recipe.normal ~= nil then
                --log(recipe.name)
                for i, ingredient in pairs(recipe.normal.ingredients) do
                    if ingredient[1] == module_name .. '-module' then
                        local amount = ingredient[2]
                        table.remove(recipe.normal.ingredients, i)
                        table.insert(recipe.normal.ingredients, {module_name .. '-module-1', amount})
                    end
                end
            end
            if recipe.expensive ~= nil then
                --log(recipe.name)
                for i, ingredient in pairs(recipe.expensive.ingredients) do
                    if ingredient[1] == module_name .. '-module' then
                        local amount = ingredient[2]
                        table.remove(recipe.expensive.ingredients, i)
                        table.insert(recipe.expensive.ingredients, {module_name .. '-module-1', amount})
                    end
                end
            end
        end
    end
    -- replace technology prerequisites
    for _, technology in pairs(data.raw.technology) do
        if data.raw.technology[technology.name] and data.raw.technology[technology.name].prerequisites then
            for i, prerequisite in ipairs(data.raw.technology[technology.name].prerequisites) do
                if prerequisite == module_name .. '-module' then
                    table.remove(data.raw.technology[technology.name].prerequisites, i)
                    table.insert(data.raw.technology[technology.name].prerequisites, module_name .. '-module-1')
                end
            end
        end
        if data.raw.technology[technology.name] and data.raw.technology[technology.name].effects then
            for i, effect in ipairs(data.raw.technology[technology.name].effects) do
                if effect.type == 'unlock-recipe' and effect.recipe == module_name .. '-module' then
                    table.remove(data.raw.technology[technology.name].effects, i)
                    table.insert(data.raw.technology[technology.name].effects, {recipe = module_name .. '-module-1', type = 'unlock-recipe'})
                end
            end
        end
    end
end

--[[
        Add tier 0 modules
        Set modules to be researched earlier
    ]]
if settings.startup[more_module_slots_defines.names.settings.tier_0_modules].value then
    for _, module_type in pairs(module_types) do
        -- get base module

        local module_name = module_type.name
        local module_item = table.deepcopy(data.raw.module[module_name .. '-module'])
        local module_recipe = table.deepcopy(data.raw.recipe[module_name .. '-module'])
        local module_technology = table.deepcopy(data.raw.technology[module_name .. '-module'])

        -- add module-0 to tier 1 recipe
        table.insert(data.raw.recipe[module_name .. '-module'].ingredients, {module_name .. '-module-0', 2})

        -- adjust details for tier 0
        module_item.name = module_name .. '-module-0'
        -- module_item.icon = '__more-module-slots__/graphics/module/' .. module_name .. '-module.png'

        module_item.icons = {
            {
                icon = '__more-module-slots__/graphics/module/' .. module_name .. '-module.png',
                icon_size = 32
            }
        }

        module_item.tier = 0
        module_item.order = module_type.order .. '[' .. module_name .. ']-a[' .. module_item.name .. ']'
        module_item.effect = module_type.effect

        module_recipe.name = module_name .. '-module-0'
        module_recipe.ingredients = {
            {'electronic-circuit', 10},
            {'steel-plate', 1}
        }
        module_recipe.energy_required = 5
        module_recipe.result = module_name .. '-module-0'

        -- technology related
        module_technology.name = module_name .. '-module-0'
        module_technology.prerequisites = {
            'mms-tier-0-modules'
        }
        module_technology.unit.ingredients = {{'automation-science-pack', 1}}
        module_technology.effects = {
            {
                type = 'unlock-recipe',
                recipe = module_name .. '-module-0'
            }
        }

        data:extend(
            {
                module_item,
                module_recipe,
                module_technology
            }
        )
        -- add technology to modules prerequisites
        table.insert(data.raw.technology.modules.prerequisites, module_technology.name)
    end

    -- add the overall technology
    local module_technology = table.deepcopy(data.raw.technology.modules)
    module_technology.name = 'mms-tier-0-modules'
    module_technology.prerequisites = {
        'electronics',
        'steel-processing'
    }
    module_technology.unit.ingredients = {{'automation-science-pack', 1}}
    data:extend({module_technology})

    -- add support for module-requestor
    if mods['module-requestor'] then
        if data.raw.technology['module-requestor'] then
            data.raw.technology['module-requestor'].prerequisites = {'mms-tier-0-modules', 'construction-robotics'}
        end
    end
end
if settings.startup[more_module_slots_defines.names.settings.more_modules].value then
    -- add extra tiers above vanilla modules
    for module_type, _ in pairs(module_types) do
        if data.raw.module[module_type .. '-module-3'] then
            local item = table.deepcopy(data.raw.module[module_type .. '-3'])
            local tech = table.deepcopy(data.raw.technology[module_type .. '-3'])
            local recipe = table.deepcopy(data.raw.recipe[module_type .. '-3'])

            for i = 4, 3 + settings.startup[more_module_slots_defines.names.settings.more_modules_count].value, 1 do
                -- statements
            end
        else
            error('Tier 3 ' .. module_type .. ' module does not exist.')
        end
    end
end
