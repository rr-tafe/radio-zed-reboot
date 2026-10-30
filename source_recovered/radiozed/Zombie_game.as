package
{
   import OBF_1c07.*;
   import org.flixel.*;
   import flash.net.SharedObject;
   
   public class Zombie_game extends FlxGame
   {
      
      private var shared:SharedObject = SharedObject.getLocal("reloaded");
      
      public function Zombie_game()
      {
         if(this.shared.data.visits == undefined || this.shared.data.visits == 2)
         {
            this.shared.data.visits = 1;
            this.shared.data.lvl = 1;
            this.shared.data.score = 0;
            this.shared.data.sp = 0;
            this.shared.data.money = 0;
            this.shared.data.stat = [0,0,0,0,0,0,0];
            this.shared.data.bulletMiss = 0;
            this.shared.data.bulletHit = 0;
            this.shared.data.headShoot = 0;
            this.shared.data.zombieKilled = 0;
            this.shared.data.maxLvl = 0;
            this.shared.data.moneyEarned = 0;
            this.shared.data.bulletMissOnLvl = 0;
            this.shared.data.leftBarricade = 100;
            this.shared.data.rightBarricade = 100;
            this.shared.data.leftBarricade_Max = 100;
            this.shared.data.rightBarricade_Max = 100;
            this.shared.data.leftBarricade_lvl = 0;
            this.shared.data.rightBarricade_lvl = 0;
            this.shared.data.bulletShot = [0,0,0,0,0,0,0,0,0];
            this.shared.data.playerSkills = [[0,0,0],[0,0,0],[0,0,0],[0,0,0],[0,0,0],[0,0,0],[0,0,0]];
            this.shared.data.bot1Skills = [[0,0,0],[0,0,0],[0,0,0]];
            this.shared.data.bot2Skills = [[0,0,0],[0,0,0],[0,0,0]];
            this.shared.data.playerWeapons = [[2,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0]];
            this.shared.data.barricadesUpgrade = [[0,0,0],[0,0,0]];
            this.shared.data.archivement = [[0,0,0,0,0,0],[0,0,0,0,0,0],[0,0,0,0,0,0],[0,0,0,0,0,0],[0,0,0,0,0,0],[0,0,0,0,0,0],[0,0,0,0,0,0]];
         }
         super(640,480,Menu,1);
         FlxState.bgColor = 16777215;
      }
   }
}

