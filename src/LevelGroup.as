package
{
  import org.flixel.*;

  public class LevelGroup extends FlxGroup 
  {
    public static const TILESETS:Object = {
      0: [BrickSprite],
      1: [BrickSprite],
      2: [BrickSprite]
    };

    public static const GUN_FITNESS:Number = 7;
    public static const LASER_FITNESS:Number = 1;
    public static const PIT_FITNESS:Number = 1;

    private var tiles:Array;
   
    public var fitness:Number = 0;

    //genetic information
    public var laserTiles:Array;
    public var gunTiles:Array;
    public var brickTiles:Object;
    public var bgTiles:Object;
    public var pits:Array;

    public var bg:FlxGroup;
    public var lasers:FlxGroup;
    public var guns:FlxGroup;
    public var bullets:FlxGroup;
    public var bricks:FlxGroup;

    public static const FEATURES:Object = {
      WALL:   0,
      SQUARE: 1,
      PIT:    2,
      GUN:    3,
      LASER:  4,
      GOAL:   5
    }

    public static const TILE_SIZE:Number = 16;

    public function LevelGroup(roomType:Number=0, shell:Boolean = false) {
      bullets = new FlxGroup();
      clearGroups();
      if(!shell) init(roomType);

    }

    public function clearGroups():void {
      if(bg) {
        remove(bg);
        remove(lasers);
        remove(guns);
        remove(bullets);
        remove(bricks);
      }

      for each(var sprite:BulletSprite in bullets.members) {
        sprite.exists = false;
        sprite.velocity.x = sprite.velocity.y = 0;
      }

      bg = new FlxGroup();
      lasers = new FlxGroup();
      guns = new FlxGroup();
      bricks = new FlxGroup();

      add(bg);
      add(lasers);
      add(guns);
      add(bullets);
      add(bricks);

      laserTiles = new Array();
      gunTiles = new Array();
      pits = new Array();

      brickTiles = {};
      bgTiles = {};

      tiles = emptyRoom();
    }

    public function reproduce(mother:LevelGroup, father:LevelGroup):LevelGroup {
      clearGroups();

      //remember to weight near tiles (+0.1 parent / -0.1 other parent for each near tile)

      //when copying tiles copy tiles from near the copied thing

      copyGuns(mother, father);
      copyLasers(mother, father);
      copyPits(mother, father);

      var x:int;
      var y:int;
      var hasLaserAt:int = 0;
      var parent:LevelGroup;
      var parentFirst:LevelGroup = father;
      var parentSecond:LevelGroup = mother;

      parent = Math.random() < 0.5 ? mother : father;
     
      for(x = 0; x < 25; x++) {
        //Roof
        hasLaserAt = 0;
        for(y = 0; y < 6; y++) {
          if(tiles[y][x] == FEATURES.LASER) hasLaserAt = y;
        }

        if(hasLaserAt > 0) {
          for(y = 0; y < hasLaserAt-2; y++) {
            if(tiles[y][x] > 0) continue;
            if(mother.brickTiles[cacheKey(x,y)] != null) {
              brickTiles[cacheKey(x,y)] = mother.brickTiles[cacheKey(x,y)];
              bricks.add(brickTiles[cacheKey(x,y)]);
            } else {
              brickTiles[cacheKey(x,y)] = father.brickTiles[cacheKey(x,y)];
              bricks.add(brickTiles[cacheKey(x,y)]);
            }
          }
        } else {
          for(y = 0; y < 6; y++) {
            if(tiles[y][x] > 0) continue;
            if(brickTiles[cacheKey(x,y-1)] != null || y == 0) {
              parent = Math.random() < 0.5 ? mother : father;
              if(parent.brickTiles[cacheKey(x,y-1)] != null || y == 0) {
                brickTiles[cacheKey(x,y)] = parent.brickTiles[cacheKey(x,y)];
                bricks.add(parent.brickTiles[cacheKey(x,y)]);
              } else {
                bgTiles[cacheKey(x,y)] = parent.bgTiles[cacheKey(x,y)];
                bg.add(parent.bgTiles[cacheKey(x,y)]);
              }
            } else {
              if(father.bgTiles[cacheKey(x,y)] != null) {
                bgTiles[cacheKey(x,y)] = father.bgTiles[cacheKey(x,y)];
                bg.add(father.bgTiles[cacheKey(x,y)]);
              } else {
                bgTiles[cacheKey(x,y)] = mother.bgTiles[cacheKey(x,y)];
                bg.add(mother.bgTiles[cacheKey(x,y)]);
              }
            }
          }
        }

        //Ground
        for(y = 6; y < tiles.length; y++) {
          if(tiles[y][x] > 0) continue;
          if(Math.random() < 0.5) {
            parentFirst = mother;
            parentSecond = father;
          } else {
            parentFirst = father;
            parentSecond = mother;
          }

          if(x >= tiles[0].length - 3) {
            if(mother.brickTiles[cacheKey(x,y)] != null) {
              brickTiles[cacheKey(x,y)] = mother.brickTiles[cacheKey(x,y)];
              bricks.add(mother.brickTiles[cacheKey(x,y)]);
              tiles[y][x] = FEATURES.WALL;
            } else {
              bgTiles[cacheKey(x,y)] = mother.bgTiles[cacheKey(x,y)];
              bg.add(mother.bgTiles[cacheKey(x,y)]);
            }
          } else if(brickTiles[cacheKey(x,y-1)] != null) {
            if(parentFirst.brickTiles[cacheKey(x,y)] != null) {
              brickTiles[cacheKey(x,y)] = parentFirst.brickTiles[cacheKey(x,y)];
              bricks.add(parentFirst.brickTiles[cacheKey(x,y)]);
            } else {
              brickTiles[cacheKey(x,y)] = parentSecond.brickTiles[cacheKey(x,y)];
              bricks.add(parentSecond.brickTiles[cacheKey(x,y)]);
            }
          } else {
            parent = Math.random() < 0.5 ? mother : father;
            if(parent.brickTiles[cacheKey(x,y)] != null) {
              brickTiles[cacheKey(x,y)] = parent.brickTiles[cacheKey(x,y)];
              bricks.add(parent.brickTiles[cacheKey(x,y)]);
            } else {
              bgTiles[cacheKey(x,y)] = parent.bgTiles[cacheKey(x,y)];
              bg.add(parent.bgTiles[cacheKey(x,y)]);
            }
          }
        }
      }

      updateGoal();
      return this;
    }

    public function randomSort(a:Object, b:Object):Number {
      return Math.random() < 0.5 ? -1 : 1;
    }

    public function copyGuns(mother:LevelGroup, father:LevelGroup):void {
      if(mother.gunTiles.length < 1 && father.gunTiles.length < 1) return;
      var motherGuns:Array = mother.gunTiles.concat();
      var fatherGuns:Array = father.gunTiles.concat();
      var gunTotal:int = motherGuns.length + fatherGuns.length;
      var numGuns:int = gunTotal;
      var gun:GunSprite;
      var safe:Boolean = true;
      var parent:LevelGroup;

      motherGuns.sort(randomSort);
      fatherGuns.sort(randomSort);

      if(numGuns > G.generation + 1) numGuns = G.generation + 1;

      for(var i:int = 0; i < numGuns; i++) {
        if(motherGuns.length == 0) {
          gun = fatherGuns.shift();
          parent = father;
        } else if(fatherGuns.length == 0) {
          gun = motherGuns.shift();
          parent = mother;
        } else if(Math.random() < 0.5) {
          gun = motherGuns.shift();
          parent = mother;
        } else {
          gun = fatherGuns.shift();
          parent = father;
        }
        if(gun == null) return;
        safe = true;
        tileRange(gun.tileX-1, gun.tileY-1, 3, 3, function(x:int, y:int):void {
          if(tiles[y][x] != -1) {
            safe = false;
          }
        });
        if(safe) {
          tileRange(gun.tileX-1, gun.tileY-1, 3, 3, function(x:int, y:int):void {
            tiles[y][x] = FEATURES.GUN;
            if(gun.tileX != x || gun.tileY != y) {
              if(parent.brickTiles[cacheKey(x,y)]) {
                brickTiles[cacheKey(x,y)] = parent.brickTiles[cacheKey(x,y)];
                bricks.add(brickTiles[cacheKey(x,y)]);
              } else if(parent.bgTiles[cacheKey(x,y)]) {
                bgTiles[cacheKey(x,y)] = parent.bgTiles[cacheKey(x,y)];
                bg.add(bgTiles[cacheKey(x,y)]);
              }
            }
          });
          gunTiles.push(gun);
        }
      }

      for each(gun in gunTiles) {
        guns.add(gun);
        fitness += GUN_FITNESS;
      }
    }

    public function copyLasers(mother:LevelGroup, father:LevelGroup):void {
      if(mother.laserTiles.length < 1 && father.laserTiles.length < 1) return;
      var motherLasers:Array = mother.laserTiles.concat();
      var fatherLasers:Array = father.laserTiles.concat();
      var laserTotal:int = motherLasers.length + fatherLasers.length;
      var numLasers:int = Math.ceil(Math.random() * laserTotal/2) + laserTotal/2;
      var laser:LaserSprite;
      var safe:Boolean = true;
      var parent:LevelGroup;

      motherLasers.sort(randomSort);
      fatherLasers.sort(randomSort);
      
      var laserMin:int = G.generation * 2;

      if(numLasers < laserMin) {
        if(laserTotal < laserMin) numLasers = laserTotal;
        else numLasers = laserMin;
      }

      for(var i:int = 0; i < numLasers; i++) {
        if(motherLasers.length == 0) {
          laser = fatherLasers.shift();
          parent = father;
        } else if(fatherLasers.length == 0) {
          laser = motherLasers.shift();
          parent = mother;
        } else if(Math.random() < 0.5) {
          laser = motherLasers.shift();
          parent = mother;
        } else {
          laser = fatherLasers.shift();
          parent = father;
        }
        if(laser == null) return;
        safe = true;
        tileRange(laser.tileX, laser.tileY-1, 1, 3, function(x:int, y:int):void {
          if(tiles[y][x] != -1) {
            safe = false;
          }
        });
        if(safe) {
          tileRange(laser.tileX, laser.tileY-1, 1, 3, function(x:int, y:int):void {
            tiles[y][x] = FEATURES.LASER;
            if(laser.tileX != x || laser.tileY != y) {
              if(parent.brickTiles[cacheKey(x,y)]) {
                brickTiles[cacheKey(x,y)] = parent.brickTiles[cacheKey(x,y)];
                bricks.add(brickTiles[cacheKey(x,y)]);
              } else if(parent.bgTiles[cacheKey(x,y)]) {
                bgTiles[cacheKey(x,y)] = parent.bgTiles[cacheKey(x,y)];
                bg.add(bgTiles[cacheKey(x,y)]);
              }
            }
          });
          laserTiles.push(laser);
        }
      }

      for each(laser in laserTiles) {
        lasers.add(laser);
        fitness += LASER_FITNESS;
      }
    }

    public function copyPits(mother:LevelGroup, father:LevelGroup):void {
      if(mother.pits.length < 1 && father.pits.length < 1) return;
      var motherPits:Array = mother.pits.concat();
      var fatherPits:Array = father.pits.concat();
      var numPits:int = motherPits.length + fatherPits.length;
      var pit:Array;
      var parent:LevelGroup;

      motherPits.sort(randomSort);
      fatherPits.sort(randomSort);

      for(var i:int = 0; i < numPits; i++) {
        if(motherPits.length == 0) {
          pit = fatherPits.shift();
          parent = father;
        } else if(fatherPits.length == 0) {
          pit = motherPits.shift();
          parent = mother;
        } else if(Math.random() < 0.5) {
          pit = motherPits.shift();
          parent = mother;
        } else {
          pit = fatherPits.shift();
          parent = father;
        }
        if(pit == null) return;
        tileRange(pit[0]-1, tiles.length-7, pit[1] + 2, 7, function(x:int, y:int):void {
          if(x > tiles[0].length - 4) return;
          if(tiles[y][x] != -1) return;
          tiles[y][x] = FEATURES.PIT;
          if(parent.brickTiles[cacheKey(x,y)]) {
            brickTiles[cacheKey(x,y)] = parent.brickTiles[cacheKey(x,y)];
            bricks.add(brickTiles[cacheKey(x,y)]);
          } else if(parent.bgTiles[cacheKey(x,y)]) {
            bgTiles[cacheKey(x,y)] = parent.bgTiles[cacheKey(x,y)];
            bg.add(bgTiles[cacheKey(x,y)]);
          }
        });
        pits.push(pit);
      }
    }

    public function cacheKey(X:Number, Y:Number):String {
      return "" + X + ":" + Y;
    }

    public function emptyRoom():Array {
      var newRoom:Array = [];
      var roomWidth:Number = 25;
      var roomHeight:Number = 15;
      var x:int = 0;
      var y:int = 0;

      //Make sure it's always surrounded by wall
      for(y = 0; y < roomHeight; y++) {
        newRoom[y] = new Array();
        for(x = 0; x < roomWidth; x++) {
          if(x == 0 || y == 0 || x == roomWidth-1) newRoom[y][x] = 0;
          else newRoom[y][x] = -1;
        }
      }

      return newRoom;
    }

    public function init(roomType:Number):void {
      if(roomType == 0) {
        initializePits();
      } 

      //Lay down bricks for empty area
      var topThickness:Number = 3;
      var bottomThickness:Number = 4;
      var y:int = 1; //Fuck AS3

      for(var x:int = 0; x < tiles[0].length; x++) {
        for(y = 1; y < topThickness; y++) {
          if(tiles[y][x] != -1) break;
          tiles[y][x] = FEATURES.WALL;
        }
        if(Math.random() <= 0.2) {
          if(topThickness >= (roomType == 2 ? 3 : 4)) topThickness--;
          else if(topThickness <= 2) topThickness++;
          else if(Math.random() <= 0.5) topThickness--;
          else topThickness++;
        }
      }

      for(x = 0; x < tiles[0].length; x++) {
        for(y = tiles.length-1; y >= tiles.length - bottomThickness; y--) {
          if(tiles[y][x] != -1) break;
          tiles[y][x] = FEATURES.WALL;
        }
        if(x >= 2 && Math.random() <= 0.2 && x < tiles[0].length - 4) {
          if(bottomThickness >= 5) bottomThickness--;
          else if(bottomThickness <= 3) bottomThickness++;
          else if(Math.random() <= 0.5) bottomThickness--;
          else bottomThickness++;
        }
      }
      
      if(roomType == 1) initializeGuns();
      if(roomType == 2) initializeLasers();

      for(y = 0; y < tiles.length; y++) {
        for(x = 0; x < tiles[0].length; x++) {
          //LAY THOSE BRICKS DOWN
          if(tiles[y][x] == FEATURES.WALL) {
            brickTiles[cacheKey(x,y)] = new BrickSprite(x, y, roomType);
            brickTiles[cacheKey(x,y)].allowCollisions = FlxObject.LEFT | FlxObject.RIGHT | FlxObject.UP; //TODO
            if(y > 0 && tiles[y-1][x] != 0) brickTiles[cacheKey(x,y)].allowCollisions |= FlxObject.UP;
            bricks.add(brickTiles[cacheKey(x,y)]);
          } else {
            bgTiles[cacheKey(x,y)] = (bg.recycle(WallSprite) as WallSprite).init(x, y, roomType);
          }
        }
      }
    }

    public function initializeLasers():void {
      var topThickness:Number = 4;
      var y:int = 1;
      var laser:LaserSprite;

      for(var x:int = 3; x < tiles[0].length - 3; x++) {
        for(y = 1; y < topThickness; y++) {
          if(tiles[y][x] == 0) {
            continue;
          } else if (tiles[y][x] == -1) {
            if(Math.random() < 0.4) {
              tiles[y][x] = FEATURES.LASER;
              laserTiles.push(new LaserSprite(x,y));
            }
            break;
          }
        }
      }

      for each(laser in laserTiles) {
        fitness += LASER_FITNESS;
        lasers.add(laser);
      }
    }

    public function initializeGuns():void {
      var topThickness:Number = 4;
      var y:int = 1;
      var gun:GunSprite;
      var safe:Boolean = false;
      var generated:Boolean = false;

      do {
        for(var i:int = 0; i < 3; i++) {
          generated = false;
          tileRange(3 + i*(i == 2 ? 5 : 6), 4, 6, 8, function(x:int, y:int):void {
            if (Math.random() < 0.02 && !generated) {
              if(tiles[y][x] != -1) return;
                safe = true;
                tileRange(x, y, 3, 3, function(j:int, k:int):void {
                  if(tiles[k][j] != -1) {
                    safe = false;
                  }
                });
                if(safe) {
                  tileRange(x, y, 3, 3, function(j:int, k:int):void {
                    tiles[k][j] = FEATURES.GUN;
                  });
                  gunTiles.push(new GunSprite(x+1, y+1, bullets));
                  generated = true;
                }
              }
          });
        }
      } while(gunTiles.length == 0)

      for each(gun in gunTiles) {
        fitness += GUN_FITNESS;
        guns.add(gun);
      }
    }

    public function tileRange(X:int, Y:int, width:int, height:int, callback:Function):void {
      var x:int;
      var y:int;

      for(x = X; x < X+width; x++)
        for(y = Y; y < Y+height; y++)
          callback(x, y);
    }

    public override function update():void {
      if(!G.paused) super.update();
    }

    public function initializePits():void {
      var tileIndex:Number = 7;
      var digLength:Number = 0;
      var digMax:Number = 7;
      var currentPit:Array = null;
      var y:int;

      while(pits.length == 0) {
        for(var x:int = 3; x < tiles[tileIndex].length - 3; x++) {
          if(digLength <= digMax && Math.random() <= 0.3 && !(digLength == 0 && x >= tiles[0].length - 4)) {
            fitness += PIT_FITNESS;
            if(digLength == 0) currentPit = [x, 1];
            digLength++;
            for(y = tileIndex; y < tiles.length; y++) { tiles[y][x] = FEATURES.PIT; }
          } else {
            if(digLength > 0 && digLength < 3) {
              fitness += PIT_FITNESS;
              digLength++;
              for(y = tileIndex; y < tiles.length; y++) { tiles[y][x] = FEATURES.PIT; }
            } else {
              if(digLength > 0 && currentPit) {
                currentPit[1] = digLength;
                pits.push(currentPit);
              }
              digLength = 0;
            }
          }
          if(digLength > 0 && currentPit) {
            currentPit[1] = digLength;
            pits.push(currentPit);
          }
        }
      }
    }

    //reset all the tiles
    public function rebase():void {
      for each(var sprite:BulletSprite in bullets.members) {
        sprite.exists = false;
        sprite.velocity.x = sprite.velocity.y = 0;
      }
      for each(var laserSprite:LaserSprite in laserTiles) {
        laserSprite.init(laserSprite.tileX, laserSprite.tileY);
      }
      for each(var gunSprite:GunSprite in gunTiles) {
        gunSprite.init(gunSprite.tileX, gunSprite.tileY, bullets);
      }
      
      updateGoal();
    }

    public function updateGoal():void {
      //Add the goal
      for (var n:Number = tiles.length - 1; n > 1; n--) {
        if(tiles[n][tiles[n].length-3] == -1) {
          (FlxG.state as PlayState).goal.init(22, n);
          break;
        }
      }
    }
  }
}
