require "import"

local time = 0
local speed = 4  -- Швидкість коливання (радіани за секунду)
local leg_amp = 0.5  -- Амплітуда для ніг (радіани, ~28 градусів)
local arm_amp = 0.3  -- Амплітуда для рук (менша, для природності)
local joint_offset = 3  -- X-offset для точки кріплення (верхня середина спрайту, припускаючи ширину ~6 пікселів)

function love.load(args)
	math.randomseed(os.time())
	love.graphics.setDefaultFilter("nearest", "nearest")
	love.window.setVSync(1)

	body = love.graphics.newImage("assets/mobs/stive/body.png")
	head = love.graphics.newImage("assets/mobs/stive/head.png")
	leg1 = love.graphics.newImage("assets/mobs/stive/leg.png")
	leg2 = love.graphics.newImage("assets/mobs/stive/leg.png")
	arm1 = love.graphics.newImage("assets/mobs/stive/arm.png")
	arm2 = love.graphics.newImage("assets/mobs/stive/arm.png")
end

function d(x, y, s)
	local center_x = x + (3 * s)  -- Центр тіла для зручності
	local leg_y = y + (42 * s) - 10
	local arm_y = y + (18 * s) + 10
	local arm_left = 30
	local leg_left = 30
	
	-- Найдальший шар: ноги та задня рука (arm1)
	love.graphics.draw(leg1, center_x + leg_left, leg_y, v, -s, s, joint_offset, 0)
	love.graphics.draw(leg2, center_x + leg_left, leg_y, h, s, s, joint_offset, 0)
	love.graphics.draw(arm1, center_x + arm_left, arm_y, arm_v, -s, s, joint_offset, 0)
	
	-- Середній шар: тулуб та голова
	love.graphics.draw(body, center_x, y + (18 * s), 0, s)
	love.graphics.draw(head, center_x - (3 * s), y, 0, s)
	
	-- Найближчий шар: передня рука (arm2)
	love.graphics.draw(arm2, center_x + arm_left, arm_y, arm_h, s, s, joint_offset, 0)
end

function love.draw()
	d(100, 100, 5)
end

function love.update(dt)
	time = time + dt
	
	local theta = time * speed
	
	-- Обертання для ніг: v для лівої, h для правої (з фазовим зсувом)
	v = math.sin(theta) * leg_amp
	h = math.sin(theta + math.pi) * leg_amp
	
	-- Обертання для рук: синхронізовано протилежно до ніг (ліва рука з правою ногою, права рука з лівою)
	arm_v = h * (arm_amp / leg_amp)  -- Ліва рука як права нога, але з меншою амплітудою
	arm_h = v * (arm_amp / leg_amp)  -- Права рука як ліва нога
end

function love.keypressed(key, unicode) 
	if key == 'space' then
	end
end

function love.mousepressed(x, y, button, istouch, presses) end

function love.keyreleased(key) end