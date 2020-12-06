function grid_init(screenW, screenH, cellSize)
  local w = math.floor(screenW / cellSize)
  local h = math.floor(screenH / cellSize)
  local out = {
    x=0,
    y=0,
    w=w,
    h=h,
    cellSize=cellSize,
    grid={}
  }
  local probability = 0.5
  for x = 1, w, 1 do
    out.grid[x] = {}
    for y = 1, h, 1 do
      out.grid[x][y] = {
        isAlive      = love.math.random() < probability,
        isDying      = false,
        isBirthing   = false,
        numNeighbors = 0
      }
    end
  end
  return out
end


function grid_update(obj, dt)
end


function grid_draw(obj)
  lgsetcol(0.3, 0.3, 0.3, 1.0)
	for x = 1, obj.w, 1 do
		for y = 1, obj.h, 1 do
			local type = 'line'
			if obj.grid[x][y].isAlive then type = 'fill' end

			lgrect(type, (x - 1) * obj.cellSize, (y - 1) * obj.cellSize,
			  obj.cellSize, obj.cellSize)
		end
	end
end
