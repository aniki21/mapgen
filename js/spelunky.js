// Keep within a range
var clamp = function(number, min, max) {
  return Math.max(min, Math.min(number, max));
}

// Setup values
var empty = "empty";
var start = "start";
var primary = "primary";
var optional = "optional";
var exit = "exit";
var impassable = "impassable";

// To prevent multi-generating on repeated clicks
var generating = false;

// Run the generation
var generate = function(width,height){
  if(generating == true){
    return true;
  }

  // Set ourselves generating
  generating = true;

  // Make sure we're using numbers
  width = parseInt(width);
  height = parseInt(height);

  // Clear the level
  $('#level').html('');

  var grid = new Array(height);
  for(var y = 0; y < height; y++){
    grid[y] = new Array(width);
  }

  // build visual grid
  $('#level').attr("style", "width:"+((width*20))+"px; height:"+((height*20))+"px;");
  $.each(grid,function(y,row){
    $.each(row, function(x,col){
      switch(col){
        case undefined:
          style = "empty";
          break;
        default:
          style = col;
          break;
      }
      $('#level').append( '<div id="'+y+'-'+x+'" class="room"></div>' );
    });
  });

  // Set our start position
  c_x = 0;
  c_y = Math.floor(Math.random() * height);
  grid[c_y][c_x] = start;
  // Draw it
  $('div#'+c_y+'-'+c_x).addClass("start");

  // Set change-of-direction options for up/down
  directions = [-1,1];

  // Keep going until we reach the other side
  while(c_x < width-1){
    // Choose whether to go up or down
    d = directions[Math.floor(Math.random() * directions.length)];

    // Make sure we're still on the grid
    n_y = clamp((c_y+d),0,height-1);

    // If the space is empty, move into it
    if(grid[n_y][c_x] == undefined){
      c_y = n_y;
    } else {
      // Otherwise move into the next column
      c_x += 1;
    }
    // Making sure we're still in bounds
    c_x = clamp(c_x,0,width-1);

    // Set the space value and draw it
    grid[c_y][c_x] = primary;
    $('div#'+c_y+'-'+c_x).addClass("primary");
  }

  // The last space is our exit
  grid[c_y][c_x] = exit;
  $('div#'+c_y+'-'+c_x).removeClass("primary").addClass("exit");

  // Add optional rooms
  // Loop through the entire grid
  for(y = 0; y < height-1; y++){
    for(x = 0; x < width-1; x++){
      // Look for primary, start and end rooms
      if(grid[y][x] == primary || grid[y][x] == start || grid[y][x] == exit){
        // Keep a track of the room's original position
        o_x = x;
        o_y = y;

        // Pick a random direction for the optional room
        direction = Math.floor(Math.random()*4);
        switch(direction){
          case 0:
            o_y -=1;
            break;
          case 1:
            o_x += 1;
            break;
          case 2:
            o_y += 1;
            break;
          case 3:
            o_x -= 1;
            break;
        }

        // Keep it inside the grid
        o_x = clamp(o_x,0,width-1);
        o_y = clamp(o_y,0,height-1);

        // If the space is empty
        if(grid[o_y][o_x] == undefined){
          // Make a room
          grid[o_y][o_x] = optional;
          $('div#'+o_y+'-'+o_x).addClass("optional");
        }
      }
    }
  }

  // Mark empty rooms impassable if there's anything above them
  for(y = 1; y < height; y++){
    for(x = 0; x < width; x++){
      if(grid[y][x] == undefined && grid[y-1][x] != undefined){
        grid[y][x] = impassable;
        $('div#'+y+'-'+x).addClass("impassable");
      }
    }
  }

  // All done!
  generating = false;
}

// React to the button click
$('button#generate').on('click',function(){
  var width = $('input#width').val();
  var height = $('input#height').val();

  generate(width,height);
});
