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
	grid_draw(GRID)
	if DEBUG then debug_draw() end
end


function love.keypressed(k)

end


function love.keyreleased(k)
	if k == 'q' then love.event.quit() end
	if k == 'p' then DEBUG = not DEBUG end
end
