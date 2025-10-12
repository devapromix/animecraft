local tree = {}

local tree_parts = {}
local bs = 50
local zone_width = 350
local zone_height = 400

function tree.generate(x, y)
    tree_parts = {}
    local height = math.random(3, 5)
    local trunk_x = x + (zone_width / 2) - (bs / 2)
    local trunk_bottom_y = y + zone_height
    local trunk_ys = {}
    for i = 1, height do
        local trunk_part_y = trunk_bottom_y - (i - 1) * bs
        table.insert(tree_parts, {x = trunk_x, y = trunk_part_y, type = 'trunk'})
        table.insert(trunk_ys, trunk_part_y)
    end
    local top_y = trunk_bottom_y - (height - 1) * bs
    local start_leaf_y = trunk_bottom_y - 2 * bs
    local upper_leaf_y = math.max(top_y - 2 * bs, y)
    local trunk_set = {}
    for _, ty in ipairs(trunk_ys) do
        trunk_set[ty] = true
    end
    local current_y = start_leaf_y
    local current_side = math.random(1, 2)
    local consecutive_no_trunk = 0
    while current_y >= upper_leaf_y do
        local has_trunk = trunk_set[current_y] or false
        for dx = -current_side, current_side do
            if not (dx == 0 and has_trunk) then
                local leaf_x = trunk_x + dx * bs
                table.insert(tree_parts, {x = leaf_x, y = current_y, type = 'leaves'})
            end
        end
        local next_side
        if has_trunk then
            consecutive_no_trunk = 0
            if current_y == top_y then
                next_side = current_side - 1
            else
                next_side = current_side + 1
            end
        else
            consecutive_no_trunk = consecutive_no_trunk + 1
            next_side = current_side - 1
            if next_side < 1 then
                next_side = 0
            end
        end
        next_side = math.min(next_side, 3)
        if consecutive_no_trunk >= 2 or next_side <= 0 then
            break
        end
        current_side = next_side
        current_y = current_y - bs
    end
end

function tree.load()
    trunk_img = love.graphics.newImage("assets/env/trees/oak/trunk.png")
    leaves_img = love.graphics.newImage("assets/env/trees/oak/leaves.png")
end

function tree.draw()
    love.graphics.setColor(1, 1, 1)
    for _, part in ipairs(tree_parts) do
        if part.type == 'trunk' then
            love.graphics.draw(trunk_img, part.x, part.y)
        else
            love.graphics.draw(leaves_img, part.x, part.y)
        end
    end
end

return tree