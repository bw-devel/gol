require('./helpers')
require('./debug')
require('./grid')

function love.load()
	DEBUG    = debug_init()

	WIDTH    = love.graphics.getWidth()
	HEIGHT   = love.graphics.getHeight()
	CELLSIZE = 8
	GRID     = grid_init(WIDTH, HEIGHT, CELLSIZE)

	lgsetbgcol(0.13, 0.15, 0.17, 1.0)
	--font = love.graphics.newFont('assets/fonts/712_serif.ttf', 32)
	--love.graphics.setFont(font)
end


function love.update(dt)
	WIDTH = love.graphics.getWidth()
	HEIGHT = love.graphics.getHeight()

	if DEBUG then debug_update(dt) end
end


function love.draw()
	lgsetcol(0.3, 0.3, 0.3, 1.0)
	for x = 1, GRID.w, 1 do
		for y = 1, GRID.h, 1 do
			local type = 'line'
			if GRID.grid[x][y] == 1 then type = 'fill' end

			lgrect(type, (x - 1) * GRID.cellSize, (y - 1) * GRID.cellSize,
			  GRID.cellSize, GRID.cellSize)
		end
	end
	if DEBUG then debug_draw() end
end


function love.keypressed(k)

end


function love.keyreleased(k)
	if k == 'q' then love.event.quit() end
	if k == 'p' then DEBUG = not DEBUG end
end
