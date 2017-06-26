EMPTY = " "
FLOOR = "0"
WALL = "W"

WIDTH = 50
HEIGHT = 30

grid = Array.new(HEIGHT){ Array.new(WIDTH,EMPTY) }

# controller
c_x = WIDTH / 2
c_y = HEIGHT / 2

# current direction
cdir = rand(4);
# odds of changing direction
odds = 1

c = 0
while(c < 200)
  grid[c_y][c_x] = FLOOR

  if rand(odds+1) == odds
    cdir = rand(4);
  end

  degrees = (cdir * 90) * Math::PI / 180

  xdir = 1 * Math.sin(degrees)
  ydir = 1 * Math.cos(degrees)

  c_x += xdir
  c_y += ydir

  c_x = [1, c_x, WIDTH-2].sort[1]
  c_y = [1, c_y, HEIGHT-2].sort[1]

  c += 1
end

(1..HEIGHT-1).each do |y|
  (1..WIDTH-1).each do |x|
    if grid[y][x] == FLOOR
      # check for empty squares around
      grid[y-1][x] = WALL if grid[y-1][x] == EMPTY
      grid[y+1][x] = WALL if grid[y+1][x] == EMPTY
      grid[y][x-1] = WALL if grid[y][x-1] == EMPTY
      grid[y][x+1] = WALL if grid[y][x+1] == EMPTY
    end
  end
end

# Write the map to a file
grid.each do |row|
  File.open("./map_#{Time.now.to_i}.txt",'a'){|f| f.write("#{row.join('')}\n") }
end
