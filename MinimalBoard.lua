local MinimalBoard = {}

function MinimalBoard.new(matrix, proprieties)
   local max_w, max_h = love.window.getMode()
   local white, black = {255,255,255}, {0,0,0}
   proprieties = proprieties or {}; proprieties.coord = proprieties.coord or {}
   local self = {
      matrix = matrix,
      outline = proprieties.outline or false,
      x1 = proprieties.coord[1] or 0,
      y1 = proprieties.coord[2] or 0,
      x2 = proprieties.coord[3] or max_w,
      y2 = proprieties.coord[4] or max_h,
      color_on = proprieties.color_on or white,
      color_off = proprieties.color_off or black,
   }
   setmetatable(self, { __index = MinimalBoard })
   return self
end

function MinimalBoard:draw()
   local sqr_w = (self.x2 - self.x1) / #self.matrix
   local sqr_h = (self.y2 - self.y1) / #self.matrix[1]
   for i=1, #self.matrix do
      for j=1, #self.matrix[i] do
         local color = self.color_off
         if self.matrix[i][j] then
            color = self.color_on
         end
         love.graphics.setColor(color)
         love.graphics.rectangle('fill', (j-1)*sqr_w+self.x1, (i-1)*sqr_h+self.y1, sqr_w, sqr_h)
         if self.outline then
            love.graphics.rectangle('line', (j-1)*sqr_w+self.x1, (i-1)*sqr_h+self.y1, sqr_w, sqr_h)
         end
      end
   end
end

return MinimalBoard