# For use later
def clamp(num,min,max)
  [min, num, max].sort[1]
end

# Initialize
WIDTH = 100;
HEIGHT = 5;
EMPTY = " "

# Room types
START = "S"
PRIMARY = "P"
OPTIONAL = "O"
EXIT = "E"

# Blank 2D array
grid = Array.new(HEIGHT){ Array.new(WIDTH,EMPTY) }

# Primary path controller
c_x = 0 # Start at the left
c_y = rand(1..HEIGHT-1) # Start at a random height

# Set our start point
grid[c_y][c_x] = START

# Keep going until we reach the right-hand column
while(c_x < WIDTH-1)
  # Pick a random direction to move - up or down
  d = [-1,1].sample
  
  # Make sure this new direction is within the grid
  n_y = clamp((c_y + d),0,HEIGHT-1)
  
  # If the new space is empty
  if grid[n_y][c_x] == EMPTY
    # Move into it
    c_y = n_y
  else
    # Move to the next column
    # but keep our current height
    c_x += 1
  end
  
  # Make sure the x coordinate is inside the grid
  c_x = clamp(c_x,0,WIDTH-1)
  
  # This is a primary path room
  grid[c_y][c_x] = PRIMARY
end

# The last room built should be the exit
grid[c_y][c_x] = EXIT

# Loop through the level to place optional side-rooms
(0..HEIGHT-1).each do |y|
  (0..WIDTH-1).each do |x|
    # If we find a primary room (inc. start/end)
    if grid[y][x] == PRIMARY || grid[y][x] == START || grid[y][x] == EXIT
      # Store its X and Y coords
      o_x = x
      o_y = y
      
      # Choose a random side to place the room
      optional_direction = rand(4)
      # Update the X or Y coordinate as required
      case optional_direction
      when 0 # Above
        o_y -= 1
      when 1 # Left
        o_x += 1
      when 2 # Below
        o_y += 1
      when 3 # Right
        o_x -= 1
      end
      
      # Make sure we're still inside the grid
      o_x = clamp(o_x,0,WIDTH-1)
      o_y = clamp(o_y,0,HEIGHT-1)
      
      # If the new space is empty
      if grid[o_y][o_x] == EMPTY
        # Place an optional room
        grid[o_y][o_x] = OPTIONAL
      end
    end
  end
end

puts grid.map{|l| l.join("") }
