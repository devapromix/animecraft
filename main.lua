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
local prev_direction = 1
local idle_amp = 1
local decay_rate = 5  -- Швидкість затухання амплітуди при зупинці
local head_rotation = 0  -- Кут повороту голови
local head_half_size = 9  -- Половина розміру голови (18x18 пікселів)
local max_head_angle = math.pi / 8
local limb_offset = 30 

function love.load(args)
	math.randomseed(os.time())
	--love.graphics.setDefaultFilter("nearest", "nearest")
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
	local head_y = y + head_half_size * s  -- Позиція центру голови
	local head_x = x + head_half_size * s  -- Позиція центру голови
	
	-- Найдальший шар: ноги та задня рука (arm1)
	love.graphics.draw(leg1, center_x + limb_offset * dir, leg_y, v * dir, -s * dir, s, joint_offset, 0)
	love.graphics.draw(leg2, center_x + limb_offset * dir, leg_y, h * dir, s * dir, s, joint_offset, 0)
	love.graphics.draw(arm1, center_x + limb_offset * dir, arm_y, arm_v * dir, -s * dir, s, joint_offset, 0)
	
	-- Середній шар: тулуб та голова
	n = 0 h = 0 if dir == -1 then n = n - 60 h = h - 60 end
	love.graphics.draw(body, center_x + n, y + (18 * s) - 20, 0, s)
	love.graphics.draw(head, head_x + h, head_y, head_rotation * dir, s * dir, s, head_half_size, head_half_size)
	
	-- Найближчий шар: передня рука (arm2)
	love.graphics.draw(arm2, center_x + limb_offset * dir, arm_y, arm_h * dir, s * dir, s, joint_offset, 0)
end

function love.draw()
	d(x_pos, 500, 5, direction)
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
	local new_direction = direction
	if love.keyboard.isDown("left") then
		x_pos = x_pos - move_speed * dt
		new_direction = -1
	end
	if love.keyboard.isDown("right") then
		x_pos = x_pos + move_speed * dt
		new_direction = 1
	end
	
	-- Компенсація стрибка при зміні напрямку
	if new_direction ~= prev_direction and moving then
		x_pos = x_pos - limb_offset * (new_direction - prev_direction)
		prev_direction = new_direction
	end
	direction = new_direction
	
	-- Рух голови
	if moving then
		-- Анімовано до центру при русі
		head_rotation = head_rotation * math.exp(-speed * dt)
	else
		-- Контроль головою тільки коли не рухається
		local head_delta = 0
		if love.keyboard.isDown("o") then
			head_delta = -speed * dt  -- Вгору
		end
		if love.keyboard.isDown("l") then
			head_delta = speed * dt  -- Вниз
		end
		head_rotation = head_rotation + head_delta
	end
	
	-- Clamp до ±45°
	head_rotation = math.max(-max_head_angle, math.min(max_head_angle, head_rotation))
end

function love.keypressed(key, unicode) 
	if key == 'space' then
	end
end

function love.mousepressed(x, y, button, istouch, presses) end

function love.keyreleased(key) end