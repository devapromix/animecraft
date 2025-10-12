-- tree.lua
local tree = {}

-- Константи
local BLOCK_SIZE = 50
local ZONE_WIDTH = 350
local ZONE_HEIGHT = 400
local MIN_HEIGHT = 4
local MAX_HEIGHT = 7
local MAX_LEAF_WIDTH = 3

tree.trunk_img = nil
tree.leaves_img = nil

function tree.generate(x, y)
    local parts = {}
    local height = math.random(MIN_HEIGHT, MAX_HEIGHT)
    local trunk_x = x + (ZONE_WIDTH / 2) - (BLOCK_SIZE / 2)
    local trunk_bottom_y = y + ZONE_HEIGHT
    
    -- Генеруємо стовбур і зберігаємо Y координати
    local trunk_ys = {}
    for i = 1, height do
        local trunk_part_y = trunk_bottom_y - (i - 1) * BLOCK_SIZE
        table.insert(parts, {x = trunk_x, y = trunk_part_y, type = 'trunk'})
        trunk_ys[trunk_part_y] = true  -- Одразу як set
    end
    
    -- Параметри листя
    local top_y = trunk_bottom_y - (height - 1) * BLOCK_SIZE
    local start_leaf_y = trunk_bottom_y - 2 * BLOCK_SIZE
    local upper_leaf_y = math.max(top_y - 2 * BLOCK_SIZE, y)
    
    -- Генеруємо листя
    local current_y = start_leaf_y
    local current_width = math.random(1, 2)
    local rows_without_trunk = 0
    
    while current_y >= upper_leaf_y do
        local has_trunk = trunk_ys[current_y]
        
        -- Додаємо листя в поточному ряді
        for dx = -current_width, current_width do
            table.insert(parts, {
                x = trunk_x + dx * BLOCK_SIZE, 
                y = current_y, 
                type = 'leaves'
            })
        end
        
        -- Визначаємо ширину наступного ряду
        if has_trunk then
            rows_without_trunk = 0
            if current_y == top_y then
                current_width = math.max(1, current_width - 1)
            else
                current_width = math.min(MAX_LEAF_WIDTH, current_width + 1)
            end
        else
            rows_without_trunk = rows_without_trunk + 1
            current_width = math.max(0, current_width - 1)
        end
        
        -- Зупиняємося якщо крона закінчилась
        if rows_without_trunk >= 2 or current_width <= 0 then
            break
        end
        
        current_y = current_y - BLOCK_SIZE
    end
    
    return parts
end

function tree.load()
    tree.trunk_img = love.graphics.newImage("assets/env/trees/oak/trunk.png")
    tree.leaves_img = love.graphics.newImage("assets/env/trees/oak/leaves.png")
end

function tree.draw_parts(parts)
    love.graphics.setColor(1, 1, 1)
    
    -- Спочатку малюємо всі стовбури, потім все листя (менше переключень текстури)
    for _, part in ipairs(parts) do
        if part.type == 'trunk' then
            love.graphics.draw(tree.trunk_img, part.x, part.y)
        end
    end
    
    for _, part in ipairs(parts) do
        if part.type == 'leaves' then
            love.graphics.draw(tree.leaves_img, part.x, part.y)
        end
    end
end

return tree