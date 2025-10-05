require "import"

local time = 0
local phase = 0
local speed = 4  -- Швидкість коливання (радіани за секунду)
local leg_amp = 0.5  -- Амплітуда для ніг (радіани, ~28 градусів)
local arm_amp = 0.3  -- Амплітуда для рук (менша, для природності)
local joint_offset = 3  -- X-offset для точки кріплення (верхня середина спрайту, припускаючи ширину ~6 пікселів)
local move_speed = 200  -- Швидкість руху (пікселів за секунду)
local x_pos = 100
local direction = 1
local idle_amp = 1
local decay_rate = 5  -- Швидкість затухання амплітуди при зупинці

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

function d(x, y, s, dir)
	local center_x = x + (3 * s)
	local leg_y = y + (42 * s)
	local arm_y = y + (18 * s) + 10
	local arm_left = 30
	local leg_left = 30
	
	-- Найдальший шар: ноги та задня рука (arm1)
	love.graphics.draw(leg1, center_x + leg_left * dir, leg_y, v * dir, -s * dir, s, joint_offset, 0)
	love.graphics.draw(leg2, center_x + leg_left * dir, leg_y, h * dir, s * dir, s, joint_offset, 0)
	love.graphics.draw(arm1, center_x + arm_left * dir, arm_y, arm_v * dir, -s * dir, s, joint_offset, 0)
	
	-- Середній шар: тулуб та голова
	love.graphics.draw(body, center_x, y + (18 * s), 0, s * dir, s, joint_offset, 0)
	love.graphics.draw(head, center_x, y, 0, s * dir, s, joint_offset, 0)
	
	-- Найближчий шар: передня рука (arm2)
	love.graphics.draw(arm2, center_x + arm_left * dir, arm_y, arm_h * dir, s * dir, s, joint_offset, 0)
end

function love.draw()
	d(x_pos, 100, 5, direction)
end

function love.update(dt)
	phase = phase + dt * speed
	
	local moving = love.keyboard.isDown("left") or love.keyboard.isDown("right")
	
	if moving then
		idle_amp = 1
	else
		idle_amp = math.max(0, idle_amp - dt * decay_rate)
	end
	
	local theta = phase
	
	-- Обертання для ніг: v для лівої, h для правої (з фазовим зсувом)
	v = math.sin(theta) * leg_amp * idle_amp
	h = math.sin(theta + math.pi) * leg_amp * idle_amp
	
	-- Обертання для рук: синхронізовано протилежно до ніг (ліва рука з правою ногою, права рука з лівою)
	arm_v = h * (arm_amp / leg_amp) * idle_amp  -- Ліва рука як права нога, але з меншою амплітудою
	arm_h = v * (arm_amp / leg_amp) * idle_amp  -- Права рука як ліва нога
	
	-- Рух
	if love.keyboard.isDown("left") then
		x_pos = x_pos - move_speed * dt
		direction = -1
	end
	if love.keyboard.isDown("right") then
		x_pos = x_pos + move_speed * dt
		direction = 1
	end
end

function love.keypressed(key, unicode) 
	if key == 'space' then
	end
end

function love.mousepressed(x, y, button, istouch, presses) end

function love.keyreleased(key) end