require "import"

local v, h, j, k = 0, 0, true, false

function love.load(args)
	math.randomseed(os.time())
	love.graphics.setDefaultFilter("nearest", "nearest")
	love.window.setVSync(1)

	body = love.graphics.newImage("assets/mobs/stive/body.png")
	head = love.graphics.newImage("assets/mobs/stive/head.png")
	leg1 = love.graphics.newImage("assets/mobs/stive/leg.png")
	leg2 = love.graphics.newImage("assets/mobs/stive/leg.png")
end

function d(x, y, s)
	love.graphics.draw(leg1, x + (3 * s), y + (42 * s), v, s)
	love.graphics.draw(leg2, x + (3 * s), y + (42 * s), h, s)
	love.graphics.draw(body, x + (3 * s), y + (18 * s), 0, s)
	love.graphics.draw(head, x, y, 0, s)
end

function love.draw()
	d(100, 100, 5)
end

function love.update(dt)
		if j == true then
			v = v + dt
			if v > 0.7 then
				j = false
			end
		else
			v = v - dt
			if v < -0.7 then
				j = true
			end
		end
		if k == true then
			h = h + dt
			if h > 0.7 then
				k = false
			end
		else
			h = h - dt
			if h < -0.7 then
				k = true
			end
		end

end

function love.keypressed(key, unicode) 
	if key == 'space' then
	end
end

function love.mousepressed(x, y, button, istouch, presses) end

function love.keyreleased(key) end



