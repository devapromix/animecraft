local forest = {}
local forest_trees = {}
local tree = require("tree")

local NUM_TREES = 15
local TREE_Y = 420

function forest.generate()
    forest_trees = {}
    local screen_width = love.graphics.getWidth()
    
    for i = 1, NUM_TREES do
        local tx = math.ceil(math.random(-200, window.width) / 100) * 100
        local parts = tree.generate(tx, TREE_Y)
        forest_trees[i] = {parts = parts}
    end
end

function forest.load()
    tree.load()
end

function forest.draw()
    for _, tree_data in ipairs(forest_trees) do
        tree.draw_parts(tree_data.parts)
    end
end

return forest