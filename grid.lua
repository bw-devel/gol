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
  local probability = love.math.random() / 4.0 + 0.25
  --local probability = 0.0

  for x = 1, w, 1 do
    out.grid[x] = {}
    for y = 1, h, 1 do
      out.grid[x][y] = {
        x            = x,
        y            = y,
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


function grid_update(dt)

  -- process all transitional flags
  for x = 1, GRID.w, 1 do
    for y = 1, GRID.h, 1 do
      local cell = GRID.grid[x][y]

      -- process deaths and births
      if cell.isDying then
        cell.isAlive = false
        cell.isDying = false
        cell.isBirthing = false
      elseif cell.isBirthing then
        cell.isAlive = true
        cell.isDying = false
        cell.isBirthing = false
      end
    end
  end

  grid_update_neighbors()

  -- process for life/death
  for x = 1, GRID.w, 1 do
    for y = 1, GRID.h, 1 do
      local cell = GRID.grid[x][y]

      -- process alive cells
      if cell.isAlive then
        cell.isDying = not (cell.numNeighbors == 2 or cell.numNeighbors == 3)
      else -- process dead cells
        cell.isBirthing = cell.numNeighbors == 3
      end
    end
  end
end


function grid_draw()
	for x = 1, GRID.w, 1 do
		for y = 1, GRID.h, 1 do

      local cell = GRID.grid[x][y]

      lgsetcol(0.3, 0.3, 0.3, 1.0)
      if cell.isAlive then
        lgrect('fill', (x - 1) * GRID.cellSize, (y - 1) * GRID.cellSize,
  			  GRID.cellSize, GRID.cellSize)

        if DEBUG then
          lgsetcol(1.0, 1.0, 1.0, 1.0)
          love.graphics.print(cell.numNeighbors,
            (x - 1) * GRID.cellSize, (y - 1) * GRID.cellSize)
        end
      end

      if cell.mousedOver then
        lgsetcol(1.0, 1.0, 1.0, 0.5)
        lgrect('fill', (x - 1) * GRID.cellSize, (y - 1) * GRID.cellSize,
  			  GRID.cellSize, GRID.cellSize)
      end
		end
	end
end

function count_neighbors(cell)

  local neighborCount = 0
  local n = nil

  --n
  if cell.y > 1 then
    n = GRID.grid[cell.x][cell.y - 1]
    if n.isAlive then neighborCount = neighborCount + 1 end
  end

  --ne
  if cell.y > 1 and cell.x < GRID.w then
    n = GRID.grid[cell.x + 1][cell.y - 1]
    if n.isAlive then neighborCount = neighborCount + 1 end
  end

  --e
  if cell.x < GRID.w then
    n = GRID.grid[cell.x + 1][cell.y]
    if n.isAlive then neighborCount = neighborCount + 1 end
  end

  --se
  if cell.x < GRID.w and cell.y < GRID.h then
    n = GRID.grid[cell.x + 1][cell.y +1]
    if n.isAlive then neighborCount = neighborCount + 1 end
  end

  --s
  if cell.y < GRID.h then
    n = GRID.grid[cell.x][cell.y  + 1]
    if n.isAlive then neighborCount = neighborCount + 1 end
  end

  --sw
  if cell.x > 1 and cell.y < GRID.h then
    n = GRID.grid[cell.x - 1][cell.y + 1]
    if n.isAlive then neighborCount = neighborCount + 1 end
  end

  --w
  if cell.x > 1 then
    n = GRID.grid[cell.x - 1][cell.y]
    if n.isAlive then neighborCount = neighborCount + 1 end
  end

  --nw
  if cell.x > 1 and cell.y > 1 then
    n = GRID.grid[cell.x - 1][cell.y - 1]
    if n.isAlive then neighborCount = neighborCount + 1 end
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

function grid_update_neighbors()
  for x = 1, GRID.w, 1 do
    for y = 1, GRID.h, 1 do
      GRID.grid[x][y].numNeighbors = count_neighbors(GRID.grid[x][y])
    end
  end
end
