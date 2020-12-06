function lgsetcol(r,g,b,a)
  love.graphics.setColor(r,g,b,a)
end

function lgrect(t, x, y, w, h)
  love.graphics.rectangle(t, x, y, w, h)
end

function lmrand(f)
  return love.math.random(f)
end

function lgsetbgcol(r,g,b,a)
  love.graphics.setBackgroundColor(r, g, b, a)
end
