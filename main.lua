require "import"

function love.load(args)
	math.randomseed(os.time())
	love.graphics.setDefaultFilter("nearest", "nearest")
	love.window.setVSync(1)

	body = love.graphics.newImage("assets/mobs/stive/body.png")
	head = love.graphics.newImage("assets/mobs/stive/head.png")
end

function d(x, y, s)
	love.graphics.draw(head, x, y, 0, s)
	love.graphics.draw(body, x + (3 * s), y + (18 * s), 0, s)
end

function love.draw()
	d(100, 100, 5)
end

function love.update(dt)

end

function love.keypressed(key, unicode) end

function love.mousepressed(x, y, button, istouch, presses) end

function love.keyreleased(key) end



