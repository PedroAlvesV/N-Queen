local MinimalBoard = require 'MinimalBoard'

local k = 8

local chessboard
local matrix = {}
local queen, empty = 'Q', 0
local queen_img = love.graphics.newImage('queen.png')

local function build_board()
   local matrix = {}
   for i=1, k do
      matrix[i] = {}
      for j=1, k do
         matrix[i][j] = not ((i%2 == 0 and j%2 ~= 0) or (j%2 == 0 and i%2 ~= 0)) -- handles the checker pattern
      end
   end
   local proprieties = {
      color_on = {255,216,170},
      color_off = {190,100,0},
      coord = {0,0,600,600},
      outline = true
   }
   chessboard = MinimalBoard.new(matrix, proprieties)
end

local function set_matrix()
   for i=1, k do
      matrix[i] = {}
      for j=1, k do
         matrix[i][j] = empty
      end
   end
end

local function write_board()
   for i=1, k do
      for j=1, k do
         io.write(" "..matrix[i][j].." ")
      end
      print()
   end
   print(' ----------------------')
end

local function add_queen(n)
   local function check_square(x,y)
      for i=1, n do
         if matrix[i][y] == queen then
            return false
         end
      end
      for i=1, k do
         for j=1, k do
            if (i-j == x-y) or (i+j == x+y) then
               if matrix[i][j] == queen then
                  return false
               end
            end
         end
      end
      return true
   end
   write_board()
   if n > k then
      return true
   end
   for j=1, k do
      if check_square(n,j) then
         matrix[n][j] = queen
         if add_queen(n+1) then
            return true
         else
            matrix[n][j] = empty
         end
      end
   end
   return false
end

local function rotate()
   local rotated = {}
   for i=1, k do
      rotated[i] = {}
      for j=1, k do
         rotated[i][j] = matrix[k-j+1][i]
      end
   end
   return rotated
end

local function flip(direction)
   local flipped = {}
   if direction == 'vertical' then
      for i=1, k do
         flipped[i] = {}
         for j=1, k do
            flipped[i][j] = matrix[k-i+1][j]
         end
      end
   elseif direction == 'horizontal' then
      for i=1, k do
         flipped[i] = {}
         for j=1, k do
            flipped[i][j] = matrix[i][k-j+1]
         end
      end
   end
   return flipped
end

function love.load()
   build_board()
   set_matrix()
   add_queen(1)
end

function love.keypressed(key)
   if key == ('left') or key == ('right') then
      matrix = flip('horizontal')
   end
   if key == ('up') or key == ('down') then
      matrix = flip('vertical')
   end
   if key == ('r') then
      matrix = rotate()
      if love.keyboard.isDown('rshift') or love.keyboard.isDown('lshift') then
         matrix = rotate(); matrix = rotate()
      end
   end
end

function love.update(dt) end

function love.draw()
   local function draw_queens()
      local sqr_w = 600 / k
      local sqr_h = 600 / k
      local scale_x, scale_y = queen_img:getDimensions()
      local origin_x, origin_y = scale_x, scale_y
      scale_x = sqr_w/scale_x
      scale_y = sqr_h/scale_y
      origin_x = origin_x/2
      origin_y = origin_y/2
      for i=1, k do
         for j=1, k do
            if matrix[i][j] == queen then
               love.graphics.setColor(255,255,255)
               love.graphics.draw(queen_img, (j-1)*sqr_w+(sqr_w/2), (i-1)*sqr_h+(sqr_h/2), 0, scale_x, scale_y, origin_x, origin_y)
            end
         end
      end
   end
   love.graphics.setBackgroundColor(128, 128, 128)
   chessboard:draw()
   draw_queens()
   love.graphics.setColor(0,0,0)
   love.graphics.setFont(love.graphics.newFont(30))
   love.graphics.print("k = "..k, 604)
end