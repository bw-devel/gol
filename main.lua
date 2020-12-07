require('./helpers')
require('./debug')
require('./grid')

function love.load()
	DEBUG    = debug_init()
	PAUSED   = true

	WIDTH    = love.graphics.getWidth()
	HEIGHT   = love.graphics.getHeight()
	CELLSIZE = 64
	GRID     = grid_init(WIDTH, HEIGHT, CELLSIZE)
	tickTime = 0.5
	timer 	 = 0.5

	MX = 0
	MY = 0
	MX_clicked = -1
	MY_clicked = -1

	font = love.graphics.newFont('assets/fonts/712_serif.ttf', 24)
	love.graphics.setFont(font)

	lgsetbgcol(0.13, 0.15, 0.17, 1.0)
end


function love.update(dt)
	WIDTH = love.graphics.getWidth()
	HEIGHT = love.graphics.getHeight()

	MX = math.floor(love.mouse.getX() / CELLSIZE)
	MY = math.floor(love.mouse.getY() / CELLSIZE)

	grid_mouseover()
	grid_update_neighbors()

	if PAUSED then
		timer = tickTime
	else
		timer = timer - dt
		if timer <= 0.0 then
			timer = tickTime
			grid_update(dt)
		end
	end

	if DEBUG then debug_update(dt) end
end


function love.draw()
	grid_draw()
	if DEBUG then debug_draw() end
	overlay_draw()
end


function love.keypressed(k)

end


function love.keyreleased(k)
	if k == 'q' then love.event.quit() end
	if k == 'p' then DEBUG = not DEBUG end
	if k == 'r' then GRID  = grid_init(WIDTH, HEIGHT, CELLSIZE) end
	if k == 'space' then PAUSED = not PAUSED end
end

function love.mousepressed(x, y, button, isTouch)
	if button == 1 then
		MX_clicked = math.floor(x / CELLSIZE)
		MY_clicked = math.floor(y / CELLSIZE)
	end
end

function love.mousereleased(x, y, button, isTouch)
	if MX == MX_clicked and MY == MY_clicked and button == 1 then
		MX = MX + 1
		MY = MY + 1
		if GRID.grid[MX][MY].isAlive then
			GRID.grid[MX][MY].isAlive = false
			GRID.grid[MX][MY].isDying = false
			GRID.grid[MX][MY].isBirthing = false
		else
			GRID.grid[MX][MY].isAlive = true
			GRID.grid[MX][MY].isDying = false
			GRID.grid[MX][MY].isBirthing = false
		end
		MX_clicked = -1
		MY_clicked = -1
	end
end

function overlay_draw()
	local txts = {
		"[space] Pause/Un-Pause",
		"[P] Toggle Debug",
		"[Q] Quit",
		"[Mouse] Toggle cells"
	}

	local txt = ""
	for i = 1, #txts, 1 do
		txt = txt .. txts[i]
		if i < #txts then
			txt = txt .. "      "
		end
	end

	local w = font:getWidth(txt)
	local h = font:getHeight()
	local x = math.floor(WIDTH / 2 - (w / 2))
	local y = HEIGHT - 8 - h
	lgsetcol(0.0, 0.0, 0.0, 0.25)
	lgrect('fill', x - 4, y - 4, w + 8, h + 8)
	lgsetcol(0.0, 0.0, 0.0, 0.75)
	love.graphics.print(txt, x + 2, HEIGHT - 24 + 2)
	lgsetcol(1.0, 1.0, 1.0, 0.75)
	love.graphics.print(txt, x, HEIGHT - 24)


end
