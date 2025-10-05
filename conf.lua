config = {

	debug = false,
	
	audio = {
		volume = 0.3,
	},
	
	game = {
		name = 'Heroes of Elvion',
		version = '0.1.0',
	},
	
	map = {
        width = 50,
        height = 50,
	},

	messages = {
		width = 98,
		height = 28,
		max = 200,
	},

	status = {
		width = 41,
		height = 12,
	},

	screen = {
		width = 100,
		height = 30,
	},

	view = {
		width = 56,
		height = 28,
	},
	
	info = {
		top = 29,
	},
	
	font = {
		name = "Minecraft.otf",
		fullscreen_size = 30,
		window_size = 18,
	},

}

window = {
	width = 1600,
	height = 900,
	fullscreen = false,
}

for _, v in ipairs(arg) do
    if v == "-d" then
        config.debug = true
        break
    end
end

function love.conf (t)
	local mode = ""
	if config.debug then
		mode = " [DEBUG]"
	end
	t.console = config.debug
	t.window.fullscreen = window.fullscreen
	t.window.msaa = 0
	t.window.fsaa = 0
	t.window.display = 1
	t.window.resizable = false
	t.window.vsync = false
	t.identity = config.game.name
	t.window.title = config.game.name .. mode
	t.window.width = window.width
	t.window.height = window.height
end