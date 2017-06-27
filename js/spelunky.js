var clamp = function(number, min, max) {
  return Math.max(min, Math.min(number, max));
}

var empty = "empty";
var start = "start";
var primary = "primary";
var optional = "optional";
var exit = "exit";
var impassable = "impassable";

var generate = function(width,height){
  width = parseInt(width);
  height = parseInt(height);

  $('#level').html('');

  var grid = new Array(height);
  for(var y = 0; y < height; y++){
    grid[y] = new Array(width);
  }

  // build grid
  $('#level').attr("style", "width:"+((width*22))+"px; height:"+((height*22))+"px;");
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

  c_x = 0;
  c_y = Math.floor(Math.random() * height);

  grid[c_y][c_x] = start;
  $('div#'+c_y+'-'+c_x).addClass("start");

  directions = [-1,1]

    while(c_x < width-1){
      d = directions[Math.floor(Math.random() * directions.length)];

      n_y = clamp((c_y+d),0,height-1);
      if(grid[n_y][c_x] == undefined){
        c_y = n_y;
      } else {
        c_x += 1;
      }

      c_x = clamp(c_x,0,width-1);

      grid[c_y][c_x] = primary;
      $('div#'+c_y+'-'+c_x).addClass("primary");
    }

  grid[c_y][c_x] = exit;
  $('div#'+c_y+'-'+c_x).removeClass("primary").addClass("exit");

  for(y = 0; y < height-1; y++){
    for(x = 0; x < width-1; x++){
      if(grid[y][x] == primary || grid[y][x] == start || grid[y][x] == exit){
        o_x = x;
        o_y = y;

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

        o_x = clamp(o_x,0,width-1);
        o_y = clamp(o_y,0,height-1);

        if(grid[o_y][o_x] == undefined){
          grid[o_y][o_x] = optional;
          $('div#'+o_y+'-'+o_x).addClass("optional");
        }
      }
    }
  }

  for(y = 1; y < height; y++){
    for(x = 0; x < width; x++){
      if(grid[y][x] == undefined && grid[y-1][x] != undefined){
        grid[y][x] = impassable;
        $('div#'+y+'-'+x).addClass("impassable");
      }
    }
  }
}



$('button#generate').on('click',function(){
  var width = $('input#width').val();
  var height = $('input#height').val();

  generate(width,height);
});
