EMPTY = " "
FLOOR = "_"
WALL = "W"

WIDTH = 100
HEIGHT = 50

grid = Array.new(HEIGHT){ Array.new(WIDTH,EMPTY) }

# controller
c_x = WIDTH / 2
c_y = HEIGHT / 2

# current direction
cdir = rand(4);
# odds of changing direction
odds = 1

c = 0
while(c < 1000)
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

# Add walls next to floors
(1..HEIGHT-2).each do |y|
  (1..WIDTH-2).each do |x|
    if grid[y][x] == FLOOR
      # check for empty squares around
      grid[y-1][x] = WALL if grid[y-1][x] == EMPTY
      grid[y+1][x] = WALL if grid[y+1][x] == EMPTY
      grid[y][x-1] = WALL if grid[y][x-1] == EMPTY
      grid[y][x+1] = WALL if grid[y][x+1] == EMPTY
    end
  end
end

# Remove single-block walls
(0..HEIGHT-1).each do |y|
  (0..WIDTH-1).each do |x|
    if grid[y][x] == WALL

      # Purely for readability
      above = (grid[y-1][x] rescue EMPTY)
      right = grid[y][x+1] rescue EMPTY
      below = grid[y+1][x] rescue EMPTY
      left = grid[y][x-1] rescue EMPTY

      # If I'm surrounded by walls and floors, I'm a floor now too
      if (above == WALL || above == FLOOR) && (right == WALL || right == FLOOR) && (below == WALL || below == FLOOR) && (left == WALL || left == FLOOR)
        # SUCCUMB TO PEER PRESSURE
        grid[y][x] = FLOOR
      elsif above == EMPTY && right == EMPTY && below == EMPTY && left == EMPTY
        grid[y][x] = EMPTY
      end
    end
  end
end

# # Write the map to a file
# filename = "./maps/#{Time.now.to_i}.txt"
# grid.each do |row|
#   File.open(filename,'a'){|f| f.write("#{row.join('')}\n") }
# end

# Draw an image
require 'chunky_png'
wall_colour = ChunkyPNG::Color.rgba(50,50,50,255)
floor_colour = ChunkyPNG::Color.rgba(rand(150)+155, rand(150)+155, rand(150)+155, 255)
png = ChunkyPNG::Image.new(WIDTH,HEIGHT, ChunkyPNG::Color::TRANSPARENT)
png_name = "./maps/#{Time.now.to_i}.png"
grid.each_with_index do |row,y|
  row.each_with_index do |cell,x|
    case cell
    when FLOOR
      png[x,y] = floor_colour
    when WALL
      png[x,y] = wall_colour
    end
  end
end
png.save(png_name, interlace: true)