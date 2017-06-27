def clamp(num,min,max)
  [min, num, max].sort[1]
end

WIDTH = 12;
HEIGHT = 8;
EMPTY = " "

START = "S"
PRIMARY = "P"
OPTIONAL = "O"
EXIT = "E"

grid = Array.new(HEIGHT){ Array.new(WIDTH,EMPTY) }

# Primary path controller
c_x = 0 # Start at the left
c_y = rand(1..HEIGHT-1) # Start at a random height

grid[c_y][c_x] = START

while(c_x < WIDTH-1)

  d = [-1,1].sample
  
  n_y = clamp((c_y + d),0,HEIGHT-1)
  
  if grid[n_y][c_x] == EMPTY
    c_y = n_y
  else
    c_x += 1
  end
  
  c_x = clamp(c_x,0,WIDTH-1)
  
  grid[c_y][c_x] = PRIMARY
end

grid[c_y][c_x] = EXIT

(0..HEIGHT-1).each do |y|
  (0..WIDTH-1).each do |x|
    if grid[y][x] == PRIMARY
      o_x = x
      o_y = y
      # optional rooms around it
      optional_direction = rand(4)
      case optional_direction
        when 0
        o_y -= 1
        when 1
        o_x += 1
        when 2
        o_y += 1
        when 3
        o_x -= 1
      end
      
      o_x = clamp(o_x,0,WIDTH-1)
      o_y = clamp(o_y,0,HEIGHT-1)
      
      if grid[o_y][o_x] == EMPTY
        grid[o_y][o_x] = OPTIONAL
      end
    end
  end
end

puts grid.map{|l| l.join("") }
