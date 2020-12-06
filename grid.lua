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
      if love.math.random() < probability then
        out.grid[x][y] = 0
      else
        out.grid[x][y] = 1
      end
    end
  end
  return out
end


function grid_update(obj, dt)

end


function grid_draw()


end
