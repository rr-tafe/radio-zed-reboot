package
{
   import org.flixel.*;
   import flash.net.SharedObject;
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   import flash.ui.Mouse;
   
   public class PlayLvl extends FlxState
   {
      
      protected var _player:Player;
      
      private var Img_clear_data_Graphic:Class = playLvl_Img_clear_data_Graphic;
      
      private var ImgMap2_bulletBlock:Class = playLvl_ImgMap2_bulletBlock;
      
      private var markerRight:Bot_Marker;
      
      private var _shop:Shop;
      
      private var botPosition:Number = 0;
      
      private var zombiesKilledOnLvl:Number = 0;
      
      private var healthBar:FlxText;
      
      private var pist:PlayerArm;
      
      private var ImgCityBack2:Class = playLvl_ImgCityBack2;
      
      private var ImgCityBack3:Class = playLvl_ImgCityBack3;
      
      private var headShoot:Number = 0;
      
      private var tempRightBarricade:Number;
      
      private var door1_down:DoorDown;
      
      private var _active:Boolean = false;
      
      private var rightBarricade:Barricade;
      
      private var bulletHit:Number = 0;
      
      private var tempLeftBarricade:Number;
      
      private var ImgPlayerGUI:Class = playLvl_ImgPlayerGUI;
      
      private var Img_clear_data_Graphic_Light:Class = playLvl_Img_clear_data_Graphic_Light;
      
      private var ImgBackgr2:Class = playLvl_ImgBackgr2;
      
      private var ImgLine:Class = playLvl_ImgLine;
      
      private var dieZombieOnLevel:Number = 0;
      
      private var bulletMiss:Number = 0;
      
      private var bullet_Block1:BulletBlock;
      
      private var ImgSponsorLogo:Class = playLvl_ImgSponsorLogo;
      
      private var door1:DoorUp;
      
      private var door2:DoorUp;
      
      private var ImgBackgr3:Class = playLvl_ImgBackgr3;
      
      private var door4:DoorUp;
      
      private var bullet_Block7:BulletBlock;
      
      protected var _doorsDown:FlxGroup = new FlxGroup();
      
      private var door3:DoorUp;
      
      private var friend1_Arm:BotArm;
      
      private var scoreOnLvl:Number = 0;
      
      private var bullet_Block3:BulletBlock;
      
      protected var friend1:BotFriend;
      
      protected var friend2:BotFriend;
      
      private var zombieOnLvl:Number;
      
      private var cursor:Cursor;
      
      private var door3_down:DoorDown;
      
      private var bullet_Block5:BulletBlock;
      
      private var Img_dialog:Class = playLvl_Img_dialog;
      
      protected var shared:SharedObject;
      
      protected var _littleGibs:FlxEmitter;
      
      protected var _bots:FlxGroup;
      
      private var Img_dialog_button:Class = playLvl_Img_dialog_button;
      
      protected var lvlText:FlxText;
      
      protected var _spawners:FlxGroup;
      
      protected var _bullets:FlxGroup;
      
      private var t:FlxTilemap;
      
      private var bullet_Block6:BulletBlock;
      
      private var ImgCredits:Class = playLvl_ImgCredits;
      
      private var bullet_Block2:BulletBlock;
      
      private var bullet_Block4:BulletBlock;
      
      private var ImgMenuSign:Class = playLvl_ImgMenuSign;
      
      private var markerLeft:Bot_Marker;
      
      private var ImgHelp:Class = playLvl_ImgHelp;
      
      private var escapeMenu:Boolean = false;
      
      private var bullet_Block_group:FlxGroup = new FlxGroup();
      
      private var ImgHelpWindow:Class = playLvl_ImgHelpWindow;
      
      private var ImgBackgr:Class = playLvl_ImgBackgr;
      
      private var blockRight:Block;
      
      private var blockLeft:Block;
      
      private var ImgMap2:Class = playLvl_ImgMap2;
      
      private var ImgMap3:Class = playLvl_ImgMap3;
      
      private var playerGUI:FlxSprite;
      
      private var ImgTiles:Class = playLvl_ImgTiles;
      
      private var blackScr:BlackScreen = new BlackScreen();
      
      protected var _blocks:FlxGroup;
      
      protected var marker_for_bots:FlxGroup = new FlxGroup();
      
      private var leftBarricade:Barricade;
      
      private var param:Params = new Params();
      
      private var ImgCityBack:Class = playLvl_ImgCityBack;
      
      private var ImgMap:Class = playLvl_ImgMap;
      
      private var blackStart:Boolean = false;
      
      private var door2_down:DoorDown;
      
      protected var _targets:FlxGroup = new FlxGroup();
      
      private var ImgSpaceMoon:Class = playLvl_ImgSpaceMoon;
      
      private var markerTwo:Bot_Marker;
      
      private var markerOne:Bot_Marker;
      
      private var Imglogo:Class = playLvl_Imglogo;
      
      protected var _objects:FlxGroup;
      
      private var friend2_Arm:BotArm;
      
      private var ImgCursor:Class = playLvl_ImgCursor;
      
      protected var _doorsUp:FlxGroup = new FlxGroup();
      
      protected var _enemies:FlxGroup;
      
      private var ImgSponsorLogo_light:Class = playLvl_ImgSponsorLogo_light;
      
      private var moneyOnLvl:Number = 0;
      
      private var ImgSpaceMoon1:Class = playLvl_ImgSpaceMoon1;
      
      private var ImgSpaceMoon3:Class = playLvl_ImgSpaceMoon3;
      
      private var ImgSpaceMoon4:Class = playLvl_ImgSpaceMoon4;
      
      private var _blackTime:Number = 3;
      
      private var ImgSpaceMoon2:Class = playLvl_ImgSpaceMoon2;
      
      private var ImgGibs:Class = playLvl_ImgGibs;
      
      private var player:Player;
      
      private var door4_down:DoorDown;
      
      private var _radio:Radio;
      
      public function PlayLvl()
      {
         super();
      }
      
      override public function create() : void
      {
         var backCity2:FlxSprite;
         var backCity3:FlxSprite;
         var sponsorLogo_Graphic_light:FlxSprite;
         var zombSpawnRight:Spawner;
         var zombLimit:Number;
         var i:int;
         var sponsorLogo:FlxButton;
         var sponsorLogo_Graphic:FlxSprite;
         var logo:FlxSprite;
         var zombSpawnLeft:Spawner;
         var backCity:FlxSprite;
         var spaceSprite:FlxSprite;
         var bulletBlocksFun:Function;
         var backChoose:int = 0;
         var backGr:FlxSprite = null;
         var sponsorLogo_Push:Function = null;
         var spriteHelp:FlxSprite = null;
         var t:FlxTilemap = null;
         var bullet_BlockL:BulletBlock = null;
         var bullet_BlockR:BulletBlock = null;
         var bullet_Block2L:BulletBlock = null;
         var bullet_Block2R:BulletBlock = null;
         var bullet_Block22:BulletBlock = null;
         var bullet_Block22L:BulletBlock = null;
         var bullet_Block22R:BulletBlock = null;
         sponsorLogo_Push = function():void
         {
            if(shared.data.archivement[4][1] == 0)
            {
               shared.data.archivement[4][1] = 1;
               shared.data.sp += 5;
            }
            var _loc2_:URLRequest = new URLRequest("http://www.andkon.com/arcade/");
            navigateToURL(_loc2_,"_blank");
         };
         this.shared = SharedObject.getLocal("reloaded");
         this.shared.data.bulletMissOnLvl = 0;
         this.tempLeftBarricade = this.shared.data.leftBarricade;
         this.tempRightBarricade = this.shared.data.rightBarricade;
         backChoose = Math.random() * 5;
         spaceSprite = new FlxSprite(0,0);
         spaceSprite.solid = false;
         spaceSprite.scrollFactor.x = spaceSprite.scrollFactor.y = 0;
         if(backChoose != 0)
         {
            if(backChoose == 1)
            {
               spaceSprite.loadGraphic(this.ImgSpaceMoon2);
            }
            else if(backChoose != 2)
            {
               if(backChoose == 3)
               {
                  spaceSprite.loadGraphic(this.ImgSpaceMoon3);
               }
               else if(backChoose == 4)
               {
                  spaceSprite.loadGraphic(this.ImgSpaceMoon4);
               }
            }
            else
            {
               spaceSprite.loadGraphic(this.ImgSpaceMoon2);
            }
         }
         else
         {
            spaceSprite.loadGraphic(this.ImgSpaceMoon);
         }
         add(spaceSprite);
         backCity = new FlxSprite(0,336,this.ImgCityBack);
         backCity.scrollFactor.x = backCity.scrollFactor.y = 0.1;
         backCity.solid = false;
         add(backCity);
         backCity2 = new FlxSprite(100,316,this.ImgCityBack2);
         backCity2.scrollFactor.x = backCity2.scrollFactor.y = 0.3;
         backCity2.solid = false;
         add(backCity2);
         backCity3 = new FlxSprite(0,336,this.ImgCityBack3);
         backCity3.scrollFactor.x = backCity3.scrollFactor.y = 0.4;
         backCity3.solid = false;
         add(backCity3);
         if(this.shared.data.lvl == 1 || this.shared.data.lvl == 2)
         {
            spriteHelp = new FlxSprite(580,66,this.ImgHelp);
            spriteHelp.scrollFactor.x = spriteHelp.scrollFactor.y = 1;
            spriteHelp.solid = false;
            add(spriteHelp);
         }
         if(this.shared.data.lvl < 9)
         {
            backGr = new FlxSprite(0,0,this.ImgBackgr);
         }
         else if(this.shared.data.lvl >= 19)
         {
            backGr = new FlxSprite(0,0,this.ImgBackgr3);
         }
         else
         {
            backGr = new FlxSprite(0,0,this.ImgBackgr2);
         }
         backGr.scrollFactor.x = backGr.scrollFactor.y = 1;
         backGr.solid = false;
         add(backGr);
         this.zombieOnLvl = this.param.numberOfZombie(this.shared.data.lvl);
         this.shared.data.zombieOnLvl = this.zombieOnLvl * 2;
         this._littleGibs = new FlxEmitter();
         this._littleGibs.delay = 1.5;
         this._littleGibs.setXSpeed(-30,30);
         this._littleGibs.setYSpeed(-200,0);
         this._littleGibs.createSprites(this.ImgGibs,170,1,true,1);
         this._blocks = new FlxGroup();
         this._bullets = new FlxGroup();
         this._bots = new FlxGroup();
         this._spawners = new FlxGroup();
         if(this.shared.data.lvl >= 9)
         {
            if(this.shared.data.lvl >= 19)
            {
               this.door1 = new DoorUp(362,400);
               add(this.door1);
               this.door1_down = new DoorDown(362,320);
               add(this.door1_down);
               this._doorsUp.add(this.door1);
               this.door2 = new DoorUp(508,320);
               add(this.door2);
               this.door2_down = new DoorDown(508,240);
               add(this.door2_down);
               this._doorsUp.add(this.door2);
               this.door3 = new DoorUp(652,240);
               add(this.door3);
               this.door3_down = new DoorDown(652,160);
               add(this.door3_down);
               this._doorsUp.add(this.door3);
               this.markerOne = new Bot_Marker(345,335,370,"one");
               add(this.markerOne);
               this.marker_for_bots.add(this.markerOne);
               this.markerTwo = new Bot_Marker(350,250,335,"two");
               add(this.markerTwo);
               this.marker_for_bots.add(this.markerTwo);
               this.markerLeft = new Bot_Marker(54,405,230,"left");
               add(this.markerLeft);
               this.marker_for_bots.add(this.markerLeft);
               this.markerRight = new Bot_Marker(776,405,210,"right");
               add(this.markerRight);
               this.marker_for_bots.add(this.markerRight);
               this.friend1_Arm = new BotArm(345,707,1);
               this.friend2_Arm = new BotArm(360,690,2);
               this.friend1 = new BotFriend(496,315,this.player,this._bullets.members,this.friend1_Arm,1,330,707);
               this.friend2 = new BotFriend(496,230,this.player,this._bullets.members,this.friend2_Arm,2,330,707);
            }
            else
            {
               this.door1 = new DoorUp(583,400);
               add(this.door1);
               this.door1_down = new DoorDown(583,320);
               add(this.door1_down);
               this._doorsUp.add(this.door1);
               this.door2 = new DoorUp(439,320);
               add(this.door2);
               this.door2_down = new DoorDown(439,240);
               add(this.door2_down);
               this._doorsUp.add(this.door2);
               this.door3 = new DoorUp(583,240);
               add(this.door3);
               this.door3_down = new DoorDown(583,160);
               add(this.door3_down);
               this._doorsUp.add(this.door3);
               this.markerOne = new Bot_Marker(345,335,370,"one");
               add(this.markerOne);
               this.marker_for_bots.add(this.markerOne);
               this.markerTwo = new Bot_Marker(350,250,335,"two");
               add(this.markerTwo);
               this.marker_for_bots.add(this.markerTwo);
               this.markerLeft = new Bot_Marker(54,405,230,"left");
               add(this.markerLeft);
               this.marker_for_bots.add(this.markerLeft);
               this.markerRight = new Bot_Marker(776,405,210,"right");
               add(this.markerRight);
               this.marker_for_bots.add(this.markerRight);
               this.friend1_Arm = new BotArm(345,707,1);
               this.friend2_Arm = new BotArm(360,690,2);
               this.friend1 = new BotFriend(496,315,this.player,this._bullets.members,this.friend1_Arm,1,335,707);
               this.friend2 = new BotFriend(496,230,this.player,this._bullets.members,this.friend2_Arm,2,346,695);
            }
         }
         else
         {
            this.door1 = new DoorUp(556,400);
            add(this.door1);
            this.door1_down = new DoorDown(556,320);
            add(this.door1_down);
            this._doorsUp.add(this.door1);
            this.door2 = new DoorUp(456,320);
            add(this.door2);
            this.door2_down = new DoorDown(456,240);
            add(this.door2_down);
            this._doorsUp.add(this.door2);
            this.door3 = new DoorUp(-583,-240);
            add(this.door3);
            this.door3_down = new DoorDown(-583,-160);
            add(this.door3_down);
            this._doorsUp.add(this.door3);
            this._doorsDown.add(this.door1_down);
            this._doorsDown.add(this.door2_down);
            this.markerOne = new Bot_Marker(406,335,260,"one");
            add(this.markerOne);
            this.marker_for_bots.add(this.markerOne);
            this.markerTwo = new Bot_Marker(406,250,260,"two");
            add(this.markerTwo);
            this.marker_for_bots.add(this.markerTwo);
            this.markerLeft = new Bot_Marker(54,405,260,"left");
            add(this.markerLeft);
            this.marker_for_bots.add(this.markerLeft);
            this.markerRight = new Bot_Marker(721,405,270,"right");
            add(this.markerRight);
            this.marker_for_bots.add(this.markerRight);
            this.friend1_Arm = new BotArm(345,707,1);
            this.friend2_Arm = new BotArm(360,690,2);
            this.friend1 = new BotFriend(496,315,this.player,this._bullets.members,this.friend1_Arm,1);
            this.friend2 = new BotFriend(496,230,this.player,this._bullets.members,this.friend2_Arm,2);
         }
         this.pist = new PlayerArm(100,100);
         this.player = new Player(556,315,this._bullets.members,this.pist);
         this._targets.add(this.player);
         this.friend1.thisDef = this.friend1.leftDef;
         this.friend2.thisDef = this.friend2.rightDef;
         if(this.shared.data.lvl >= 9)
         {
            if(this.shared.data.lvl >= 19)
            {
               this.leftBarricade = new Barricade(280,397,0);
               add(this.leftBarricade);
               this.blockLeft = new Block(this.leftBarricade.x + 6,417);
               this.bullet_Block_group.add(this.blockLeft);
               this._blocks.add(this.blockLeft);
               this._targets.add(this.leftBarricade);
               this.rightBarricade = new Barricade(746,397,1);
               this.rightBarricade.facing = 0;
               add(this.rightBarricade);
               this.blockRight = new Block(this.rightBarricade.x,417);
               this.bullet_Block_group.add(this.blockRight);
               this._blocks.add(this.blockRight);
               this._targets.add(this.rightBarricade);
               this._radio = new Radio(446,128);
               add(this._radio);
               FlxG.follow(this.player,1);
               FlxG.followAdjust(0.1,0);
               FlxG.followBounds(500,0,800,0,true);
               t = new FlxTilemap();
               t.auto = FlxTilemap.ALT;
               t.loadMap(FlxTilemap.pngToCSV(this.ImgMap3,false,2),this.ImgTiles);
               t.visible = false;
               t.follow();
               this.bullet_Block1 = new BulletBlock(350,192,355,25);
               this.bullet_Block_group.add(this.bullet_Block1);
               bullet_BlockL = new BulletBlock(336,210,20,30);
               this.bullet_Block_group.add(bullet_BlockL);
               bullet_BlockR = new BulletBlock(700,210,20,30);
               this.bullet_Block_group.add(bullet_BlockR);
               this.bullet_Block2 = new BulletBlock(350,272,355,25);
               this.bullet_Block_group.add(this.bullet_Block2);
               bullet_Block2L = new BulletBlock(336,290,20,30);
               this.bullet_Block_group.add(bullet_Block2L);
               bullet_Block2R = new BulletBlock(700,290,20,30);
               this.bullet_Block_group.add(bullet_Block2R);
               bullet_Block22 = new BulletBlock(350,352,355,25);
               this.bullet_Block_group.add(bullet_Block22);
               bullet_Block22L = new BulletBlock(336,368,20,30);
               this.bullet_Block_group.add(bullet_Block22L);
               bullet_Block22R = new BulletBlock(700,368,20,30);
               this.bullet_Block_group.add(bullet_Block22R);
               this.bullet_Block3 = new BulletBlock(0,432,1280,48);
               this.bullet_Block_group.add(this.bullet_Block3);
            }
            else
            {
               bulletBlocksFun = function():void
               {
                  bullet_Block1 = new BulletBlock(397,192,259,25);
                  bullet_Block_group.add(bullet_Block1);
                  var _loc1_:BulletBlock = new BulletBlock(384,210,20,30);
                  bullet_Block_group.add(_loc1_);
                  var _loc2_:BulletBlock = new BulletBlock(653,210,20,30);
                  bullet_Block_group.add(_loc2_);
                  bullet_Block2 = new BulletBlock(367,272,322,25);
                  bullet_Block_group.add(bullet_Block2);
                  var _loc3_:BulletBlock = new BulletBlock(352,290,20,30);
                  bullet_Block_group.add(_loc3_);
                  var _loc4_:BulletBlock = new BulletBlock(686,290,20,30);
                  bullet_Block_group.add(_loc4_);
                  var _loc5_:BulletBlock = new BulletBlock(350,352,355,25);
                  bullet_Block_group.add(_loc5_);
                  var _loc6_:BulletBlock = new BulletBlock(336,368,20,30);
                  bullet_Block_group.add(_loc6_);
                  var _loc7_:BulletBlock = new BulletBlock(700,368,20,30);
                  bullet_Block_group.add(_loc7_);
                  bullet_Block3 = new BulletBlock(0,432,1680,48);
                  bullet_Block_group.add(bullet_Block3);
               };
               this.leftBarricade = new Barricade(280,397,0);
               add(this.leftBarricade);
               this.blockLeft = new Block(this.leftBarricade.x + 6,417);
               this.bullet_Block_group.add(this.blockLeft);
               this._blocks.add(this.blockLeft);
               this._targets.add(this.leftBarricade);
               this.rightBarricade = new Barricade(746,397,1);
               this.rightBarricade.facing = 0;
               add(this.rightBarricade);
               this.blockRight = new Block(this.rightBarricade.x,417);
               this.bullet_Block_group.add(this.blockRight);
               this._blocks.add(this.blockRight);
               this._targets.add(this.rightBarricade);
               this._radio = new Radio(446,128);
               add(this._radio);
               FlxG.follow(this.player,1);
               FlxG.followAdjust(0.1,0);
               FlxG.followBounds(500,0,800,0,true);
               t = new FlxTilemap();
               t.auto = FlxTilemap.ALT;
               t.loadMap(FlxTilemap.pngToCSV(this.ImgMap2,false,2),this.ImgTiles);
               t.visible = false;
               t.follow();
               bulletBlocksFun();
            }
         }
         else
         {
            this.leftBarricade = new Barricade(317,397,0);
            add(this.leftBarricade);
            this.blockLeft = new Block(this.leftBarricade.x + 6,417);
            this.bullet_Block_group.add(this.blockLeft);
            this._blocks.add(this.blockLeft);
            this._targets.add(this.leftBarricade);
            this.rightBarricade = new Barricade(716,397,1);
            this.rightBarricade.facing = 0;
            add(this.rightBarricade);
            this.blockRight = new Block(this.rightBarricade.x,417);
            this.bullet_Block_group.add(this.blockRight);
            this._blocks.add(this.blockRight);
            this._targets.add(this.rightBarricade);
            this._radio = new Radio(586,208);
            add(this._radio);
            FlxG.follow(this.player,1);
            FlxG.followAdjust(0.1,0);
            FlxG.followBounds(500,0,800,0,true);
            t = new FlxTilemap();
            t.auto = FlxTilemap.ALT;
            t.loadMap(FlxTilemap.pngToCSV(this.ImgMap,false,2),this.ImgTiles);
            t.visible = false;
            t.follow();
            this.bullet_Block1 = new BulletBlock(415,272,242,18);
            this.bullet_Block_group.add(this.bullet_Block1);
            this.bullet_Block2 = new BulletBlock(415,352,242,18);
            this.bullet_Block_group.add(this.bullet_Block2);
            this.bullet_Block3 = new BulletBlock(0,432,1680,48);
            this.bullet_Block_group.add(this.bullet_Block3);
            this.bullet_Block4 = new BulletBlock(400,290,17,27);
            this.bullet_Block_group.add(this.bullet_Block4);
            this.bullet_Block5 = new BulletBlock(400,365,17,33);
            this.bullet_Block_group.add(this.bullet_Block5);
            this.bullet_Block6 = new BulletBlock(655,292,17,25);
            this.bullet_Block_group.add(this.bullet_Block6);
            this.bullet_Block7 = new BulletBlock(655,372,17,25);
            this.bullet_Block_group.add(this.bullet_Block7);
         }
         this._blocks.add(t);
         add(this._spawners);
         add(this._littleGibs);
         add(this._blocks);
         add(this._bots);
         i = 0;
         while(i < 100)
         {
            this._bullets.add(new Bullet(this.player));
            i++;
         }
         add(this._bullets);
         this._enemies = new FlxGroup();
         this._enemies.add(this._spawners);
         this._enemies.add(this._bots);
         this._objects = new FlxGroup();
         this._objects.add(this._bots);
         this._objects.add(this.player);
         this._objects.add(this.friend1);
         this._objects.add(this.friend2);
         this._objects.add(this._littleGibs);
         add(this.friend1);
         add(this.friend1_Arm);
         add(this.friend2);
         add(this.friend2_Arm);
         add(this.player);
         add(this.pist);
         zombLimit = this.param.spawnersArray_for_spawn(this.shared.data.lvl);
         FlxG.log(zombLimit);
         zombSpawnLeft = new Spawner(1,400,this._bots,this._littleGibs,this.player,this._radio,this._doorsDown,this._doorsUp,this.zombieOnLvl,this._targets,zombLimit);
         this._spawners.add(zombSpawnLeft);
         add(zombSpawnLeft);
         zombSpawnRight = new Spawner(1051,400,this._bots,this._littleGibs,this.player,this._radio,this._doorsDown,this._doorsUp,this.zombieOnLvl,this._targets,zombLimit);
         this._spawners.add(zombSpawnRight);
         add(zombSpawnRight);
         this.lvlText = new FlxText(17,4,FlxG.width).setFormat(null,8,14868183,null,2309720);
         this.lvlText.scrollFactor.x = this.lvlText.scrollFactor.y = 0;
         this.lvlText.text = "Radio Zed";
         add(this.lvlText);
         this.healthBar = new FlxText(this.player.x,this.player.y,FlxG.width,String(this.player.health));
         this.healthBar.color = 14868183;
         this.healthBar.size = 8;
         add(this.healthBar);
         logo = new FlxSprite(5,5,this.Imglogo);
         logo.scrollFactor.x = logo.scrollFactor.y = 0;
         add(logo);
         sponsorLogo_Graphic = new FlxSprite(0,0,this.ImgSponsorLogo);
         sponsorLogo_Graphic_light = new FlxSprite(0,0,this.ImgSponsorLogo_light);
         sponsorLogo = new FlxButton(583,5,sponsorLogo_Push);
         sponsorLogo.scrollFactor.x = sponsorLogo.scrollFactor.y = 0;
         sponsorLogo.loadGraphic(sponsorLogo_Graphic,sponsorLogo_Graphic_light);
         add(sponsorLogo);
         this.playerGUI = new FlxSprite(this.player.x,this.player.y,this.ImgPlayerGUI);
         add(this.playerGUI);
         this.cursor = new Cursor(this.player);
         add(this.cursor);
         add(this.bullet_Block_group);
         add(this.blackScr);
      }
      
      protected function OBF_1c03(param1:FlxObject, param2:FlxObject) : void
      {
         if(param1 is Bot_Marker && param2.health > 0 && param2 is zombie1)
         {
            if(param1 == this.markerOne && this.friend1.acceleration.x == 0)
            {
               this.friend1.facing = this.friend1._arm.facing;
               this.friend1.shoot(param2.x,param2.y);
            }
            else if(this.friend1.thisDef == this.friend1.leftDef && param1 == this.markerLeft && this.friend1.acceleration.x == 0)
            {
               this.friend1.facing = this.friend1._arm.facing;
               this.friend1.shoot(param2.x,param2.y);
            }
            else if(this.friend1.thisDef == this.friend1.rightDef && param1 == this.markerRight && this.friend1.acceleration.x == 0)
            {
               this.friend1.facing = this.friend1._arm.facing;
               this.friend1.shoot(param2.x,param2.y);
            }
            if(!(param1 == this.markerTwo && this.friend2.acceleration.x == 0))
            {
               if(this.friend2.thisDef == this.friend2.leftDef && param1 == this.markerLeft && this.friend2.acceleration.x == 0)
               {
                  this.friend2.facing = this.friend2._arm.facing;
                  this.friend2.shoot(param2.x,param2.y);
               }
               else if(this.friend2.thisDef == this.friend2.rightDef && param1 == this.markerRight && this.friend2.acceleration.x == 0)
               {
                  this.friend2.facing = this.friend2._arm.facing;
                  this.friend2.shoot(param2.x,param2.y);
               }
            }
            else
            {
               this.friend2.facing = this.friend2._arm.facing;
               this.friend2.shoot(param2.x,param2.y);
            }
         }
      }
      
      override public function update() : void
      {
         var cancelDataPush:Function;
         var deleteDataPush:Function;
         var clearData_dialog:FlxSprite = null;
         var clearData_dialog_text:FlxText = null;
         var _clearData_dialog_choose_text:String = null;
         var clearData_dialog_choose_text:FlxText = null;
         var clearDataButton_Graphic:FlxSprite = null;
         var clearDataButton_Graphic_Light:FlxSprite = null;
         var deleteData:FlxButton = null;
         var cancelData:FlxButton = null;
         FlxG.followBounds(30,0,1055,480,false);
         if(FlxG.keys.justPressed("F"))
         {
            if(!(this.botPosition == 0 || this.botPosition == 1))
            {
               if(this.botPosition == 2)
               {
                  this.botPosition = 0;
               }
            }
            else
            {
               this.botPosition += 1;
            }
            if(this.botPosition != 0)
            {
               if(this.botPosition == 1)
               {
                  this.friend1.thisDef = this.friend1.leftDef;
                  this.friend2.thisDef = this.friend2.leftDef;
               }
               else if(this.botPosition == 2)
               {
                  this.friend1.thisDef = this.friend1.rightDef;
                  this.friend2.thisDef = this.friend2.rightDef;
               }
            }
            else
            {
               this.friend1.thisDef = this.friend1.leftDef;
               this.friend2.thisDef = this.friend2.rightDef;
            }
         }
         else if(!((this.player.overlaps(this.door1) == true || this.player.overlaps(this.door2) == true || this.player.overlaps(this.door3) == true) && (FlxG.keys.justPressed("DOWN") || FlxG.keys.justPressed("S"))))
         {
            if((this.player.overlaps(this.door1_down) == true || this.player.overlaps(this.door2_down) == true || this.player.overlaps(this.door3_down) == true) && (FlxG.keys.justPressed("DOWN") || FlxG.keys.justPressed("S")))
            {
               this.player.y += 79;
            }
         }
         else
         {
            this.player.y -= 81;
         }
         if(FlxG.keys.justPressed("ESCAPE"))
         {
            if(this.escapeMenu == false)
            {
               deleteDataPush = function():void
               {
                  shared.data.leftBarricade = tempLeftBarricade;
                  shared.data.rightBarricade = tempRightBarricade;
                  FlxG.state = new Menu();
               };
               cancelDataPush = function():void
               {
                  Mouse.hide();
                  escapeMenu = false;
                  clearData_dialog.kill();
                  clearData_dialog_text.kill();
                  clearData_dialog_choose_text.kill();
                  deleteData.kill();
                  cancelData.kill();
               };
               Mouse.show();
               this.escapeMenu = true;
               clearData_dialog = new FlxSprite(235,222,this.Img_dialog);
               clearData_dialog.scrollFactor.x = clearData_dialog.scrollFactor.y = 0;
               add(clearData_dialog);
               clearData_dialog_text = new FlxText(243,225,FlxG.width,"     Return in to main menu?").setFormat(null,8,11052705,"left",2309720);
               clearData_dialog_text.scrollFactor.x = clearData_dialog_text.scrollFactor.y = 0;
               add(clearData_dialog_text);
               _clearData_dialog_choose_text = "Return                  Cancel";
               clearData_dialog_choose_text = new FlxText(259,242,FlxG.width,_clearData_dialog_choose_text).setFormat(null,8,14868183,"left",2309720);
               clearData_dialog_choose_text.scrollFactor.x = clearData_dialog_choose_text.scrollFactor.y = 0;
               add(clearData_dialog_choose_text);
               clearDataButton_Graphic = new FlxSprite(0,0,this.Img_dialog_button);
               clearDataButton_Graphic.alpha = 0;
               clearDataButton_Graphic_Light = new FlxSprite(0,0,this.Img_dialog_button);
               deleteData = new FlxButton(238,241,deleteDataPush);
               deleteData.scrollFactor.x = deleteData.scrollFactor.y = 0;
               deleteData.loadGraphic(clearDataButton_Graphic,clearDataButton_Graphic_Light);
               add(deleteData);
               clearDataButton_Graphic = new FlxSprite(0,0,this.Img_dialog_button);
               clearDataButton_Graphic.alpha = 0;
               clearDataButton_Graphic_Light = new FlxSprite(0,0,this.Img_dialog_button);
               cancelData = new FlxButton(323,241,cancelDataPush);
               cancelData.scrollFactor.x = cancelData.scrollFactor.y = 0;
               cancelData.loadGraphic(clearDataButton_Graphic,clearDataButton_Graphic_Light);
               add(cancelData);
            }
         }
         FlxU.collide(this._blocks,this._objects);
         FlxU.overlap(this._bullets,this._enemies,this.OBF_1c05);
         FlxU.overlap(this.marker_for_bots,this._enemies,this.OBF_1c03);
         FlxU.overlap(this._bullets,this.bullet_Block_group,this.OBF_1c04);
         this.cursor.x = FlxG.mouse.x;
         this.cursor.y = FlxG.mouse.y;
         this.lvlText.text = "Wave: " + String(this.shared.data.lvl) + "   " + "Score: " + String(this.shared.data.score + this.scoreOnLvl) + "   " + "Money: " + String(this.shared.data.money + this.moneyOnLvl);
         super.update();
         if(this.player.health > 0)
         {
            this.healthBar.x = this.player.x + 5;
            this.healthBar.y = this.player.y - 20;
            this.playerGUI.x = this.player.x - 4;
            this.playerGUI.y = this.player.y - 17;
            this.healthBar.text = String(this.player._bulletNumber) + "\n" + String(this.player.health);
            if(this.player._bulletNumber == 0)
            {
               this.healthBar.text = "Reloading... " + "\n" + String(this.player.health);
            }
         }
         else
         {
            this.player.health = 0;
            this.healthBar.kill();
            this.playerGUI.kill();
         }
         if(this.leftBarricade.health <= 0 && this.blockLeft.health > 0)
         {
            this.blockLeft.health = 0;
            this.blockLeft.kill();
         }
         else if(this.rightBarricade.health <= 0 && this.blockRight.health > 0)
         {
            this.blockRight.health = 0;
            this.blockRight.kill();
         }
         if(this.player.health <= 0 || this._radio.health <= 0)
         {
            this.shared.data.leftBarricade = this.tempLeftBarricade;
            this.shared.data.rightBarricade = this.tempRightBarricade;
            if(this.blackStart == false)
            {
               this.blackStart = true;
               this.blackScr.startTick();
            }
            if(this.blackScr.alpha > 0.95)
            {
               this.shared.data.archivement[4][3] = 1;
               FlxG.state = new BlackScreenDialog(this.shared.data.score + this.scoreOnLvl);
            }
         }
         else if(this.shared.data.zombieOnLvl <= 0)
         {
            if(this.blackStart == false)
            {
               this.blackStart = true;
               this.blackScr.startTick();
            }
            if(this.blackScr.alpha > 0.95)
            {
               this.shared.data.sp += this.param.specialPoints;
               this.shared.data.money += this.moneyOnLvl;
               this.shared.data.bulletMiss = this.player.allBullet - this.bulletHit;
               this.shared.data.bulletHit += this.bulletHit;
               this.shared.data.headShoot += this.headShoot;
               this.shared.data.score += this.scoreOnLvl;
               this.shared.data.zombieKilled += this.zombiesKilledOnLvl;
               this.shared.data.moneyEarned += this.moneyOnLvl;
               if(this.shared.data.lvl > this.shared.data.maxLvl)
               {
                  this.shared.data.maxLvl = this.shared.data.lvl;
               }
               this.param.achievements();
               this.player.kill();
               if(this.shared.data.lvl > 60)
               {
                  FlxG.state = new WinScreenDialog();
               }
               else
               {
                  this.shared.data.lvl += 1;
                  FlxG.state = new Shop();
               }
            }
         }
      }
      
      protected function OBF_1c05(param1:Bullet, param2:FlxObject) : void
      {
         var _loc3_:Number = NaN;
         if(param1 is Bullet && param2.health > 0)
         {
            if(param1.bulletInitial == 1)
            {
               this.bulletHit += 1;
            }
            param1.kill();
         }
         if(param2 is zombie1 && param2.health > 0)
         {
            param2.acceleration.x = 0;
            if(!(param1.y > param2.y && param1.y - 7 < param2.y && param1.bulletInitial == 1))
            {
               param2.hurt(param1._damage);
            }
            else
            {
               param2.hurt(param1._damage * this.param.player_zHunter);
               this.headShoot += 1;
            }
            if(param2.health <= 0)
            {
               --this.shared.data.zombieOnLvl;
               this.scoreOnLvl += 100;
               this.zombiesKilledOnLvl += 1;
               _loc3_ = Math.random() * 20;
               _loc3_ = Math.floor(_loc3_);
               _loc3_ += this.param.player_luck;
               this.moneyOnLvl += _loc3_;
            }
         }
      }
      
      protected function OBF_1c04(param1:FlxObject, param2:FlxObject) : void
      {
         if(param1 is Bullet)
         {
            if(param1.bulletInitial1 == 1)
            {
               this.bulletMiss += 1;
            }
            param1.kill();
         }
      }
   }
}

