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
  --local probability = love.math.random() / 4.0 + 0.25
  local probability = 0.0

  for x = 1, w, 1 do
    out.grid[x] = {}
    for y = 1, h, 1 do
      out.grid[x][y] = {
        isAlive      = love.math.random() < probability,
        isDying      = false,
        isBirthing   = false,
        mousedOver   = false,
        numNeighbors = 0
      }
    end
  end
  return out
end


function grid_update(obj, dt)

  -- process all transitional flags
  for x = 1, obj.w, 1 do
    for y = 1, obj.h, 1 do
      local this = obj.grid[x][y]
      -- process flags
      if this.isDying then
        this.isDying = false
        this.isAlive = false
        this.isBirthing = false
      elseif this.isBirthing then
        this.isAlive = true
        this.isDying = false
        this.isBirthing = false
      end
    end
  end

  -- process for life/death
  for x = 1, obj.w, 1 do
    for y = 1, obj.h, 1 do
      local this = obj.grid[x][y]

      this.numNeighbors = count_neighbors(x, y)

      -- process alive cells
      if this.isAlive then
        if this.numNeighbors < 2 then
          this.isDying = true
        elseif this.numNeighbors > 3 then
          this.isDying = true
        end
      else -- process dead cells
        if this.numNeighbors > 3 then
          this.isBirthing = true
        end
      end
    end
  end
end


function grid_draw(obj)
	for x = 1, obj.w, 1 do
		for y = 1, obj.h, 1 do

      lgsetcol(0.3, 0.3, 0.3, 1.0)
      if obj.grid[x][y].isAlive then

        lgrect('fill', (x - 1) * obj.cellSize, (y - 1) * obj.cellSize,
  			  obj.cellSize, obj.cellSize)

        if DEBUG then
          lgsetcol(1.0, 1.0, 1.0, 1.0)
          love.graphics.print(obj.grid[x][y].numNeighbors, (x - 1) * obj.cellSize, (y - 1) * obj.cellSize)
        end
      end

      if obj.grid[x][y].mousedOver then
        lgsetcol(1.0, 1.0, 1.0, 0.5)
        lgrect('fill', (x - 1) * obj.cellSize, (y - 1) * obj.cellSize,
  			  obj.cellSize, obj.cellSize)
      end
		end
	end
end

function count_neighbors(x, y)

  local neighborCount = 0
  --n
  if y > 1 then
    if GRID.grid[x][y - 1].isAlive then neighborCount = neighborCount + 1 end
  end

  --e
  if x < GRID.w then
    if GRID.grid[x + 1][y].isAlive then neighborCount = neighborCount + 1 end
  end

  --s
  if y < GRID.h then
    if GRID.grid[x][y + 1].isAlive then neighborCount = neighborCount + 1 end
  end

  --w
  if x > 1 then
    if GRID.grid[x - 1][y].isAlive then neighborCount = neighborCount + 1 end
  end

  return neighborCount
end


function grid_mouseover()
  for x = 1, GRID.w, 1 do
    for y = 1, GRID.h, 1 do
      GRID.grid[x][y].mousedOver = (MX == x - 1 and MY == y - 1)
    end
  end
end
