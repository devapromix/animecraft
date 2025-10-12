-- forest.lua
local forest = {}
local forest_trees = {}
local num_trees = 20
local tree = require("tree")

function forest.generate()
    forest_trees = {}
    for i = 1, num_trees do
        local tx = math.random(-400, window.width)
        local ty = 420
        local parts = tree.generate(tx, ty)
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