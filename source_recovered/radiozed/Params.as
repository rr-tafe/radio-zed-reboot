package
{
   import org.flixel.*;
   import flash.net.SharedObject;
   
   public class Params
   {
      
      public var bot1_damage:Number;
      
      public var bot2_accuracy:Number;
      
      public var weapon1_1:Number;
      
      public var weapon1_2:Number;
      
      public var weapon3_1:Number;
      
      public var weapon3_2:Number;
      
      public var weapon5_1:Number;
      
      public var weapon5_2:Number;
      
      public var player_damage:Number;
      
      public var weapon9_1:Number;
      
      public var weapon7_2:Number;
      
      public var weapon7_1:Number;
      
      public var player_accuracy:Number;
      
      public var barricadeRepair_price:Array = new Array();
      
      public var weapon9_2:Number;
      
      public var bot1_speed:Number;
      
      private var numberOfZombieArray:Array = new Array();
      
      public var player_zHunter:Number;
      
      public var player_recharge:Number;
      
      public var weapon2_1:Number;
      
      public var weapon2_2:Number;
      
      public var weapon4_1:Number;
      
      public var weapon4_2:Number;
      
      public var weapon6_1:Number;
      
      public var weapon6_2:Number;
      
      public var weapon8_1:Number;
      
      public var weapon8_2:Number;
      
      public var bot1_accuracy:Number;
      
      public var player_luck:Number;
      
      public var bot2_speed:Number;
      
      public var bot2_damage:Number;
      
      private var shared:SharedObject;
      
      public var weapon_price:Array = new Array();
      
      private var spawnsArray:Array = new Array();
      
      public var player_speed:Number;
      
      public var barricade_price:Array = new Array();
      
      public var player_health:Number;
      
      public var specialPoints:Number;
      
      public function Params()
      {
         super();
         this.shared = SharedObject.getLocal("reloaded");
         this.specialPoints = 4;
         this.player_damage = 1;
         if(this.shared.data.playerSkills[0][2] != 2)
         {
            if(this.shared.data.playerSkills[0][1] == 2)
            {
               this.player_health = 150;
            }
            else if(this.shared.data.playerSkills[0][0] != 2)
            {
               this.player_health = 100;
            }
            else
            {
               this.player_health = 125;
            }
         }
         else
         {
            this.player_health = 200;
         }
         if(this.shared.data.playerSkills[1][2] != 2)
         {
            if(this.shared.data.playerSkills[1][1] == 2)
            {
               this.specialPoints = 11;
            }
            else if(this.shared.data.playerSkills[1][0] != 2)
            {
               this.specialPoints = 8;
            }
            else
            {
               this.specialPoints = 9;
            }
         }
         else
         {
            this.specialPoints = 12;
         }
         if(this.shared.data.playerSkills[2][2] == 2)
         {
            this.player_accuracy = 5;
         }
         else if(this.shared.data.playerSkills[2][1] == 2)
         {
            this.player_accuracy = 10;
         }
         else if(this.shared.data.playerSkills[2][0] != 2)
         {
            this.player_accuracy = 20;
         }
         else
         {
            this.player_accuracy = 15;
         }
         if(this.shared.data.playerSkills[3][2] == 2)
         {
            this.player_speed = 150;
         }
         else if(this.shared.data.playerSkills[3][1] != 2)
         {
            if(this.shared.data.playerSkills[3][0] == 2)
            {
               this.player_speed = 115;
            }
            else
            {
               this.player_speed = 100;
            }
         }
         else
         {
            this.player_speed = 130;
         }
         if(this.shared.data.playerSkills[4][2] == 2)
         {
            this.player_recharge = 0.4;
         }
         else if(this.shared.data.playerSkills[4][1] != 2)
         {
            if(this.shared.data.playerSkills[4][0] == 2)
            {
               this.player_recharge = 0.8;
            }
            else
            {
               this.player_recharge = 1;
            }
         }
         else
         {
            this.player_recharge = 0.6;
         }
         if(this.shared.data.playerSkills[5][2] != 2)
         {
            if(this.shared.data.playerSkills[5][1] != 2)
            {
               if(this.shared.data.playerSkills[5][0] == 2)
               {
                  this.player_zHunter = 1.4;
               }
               else
               {
                  this.player_zHunter = 1.2;
               }
            }
            else
            {
               this.player_zHunter = 1.6;
            }
         }
         else
         {
            this.player_zHunter = 2;
         }
         if(this.shared.data.playerSkills[6][2] == 2)
         {
            this.player_luck = 35;
         }
         else if(this.shared.data.playerSkills[6][1] != 2)
         {
            if(this.shared.data.playerSkills[6][0] == 2)
            {
               this.player_luck = 25;
            }
            else
            {
               this.player_luck = 20;
            }
         }
         else
         {
            this.player_luck = 30;
         }
         if(this.shared.data.bot1Skills[0][2] != 2)
         {
            if(this.shared.data.bot1Skills[0][1] == 2)
            {
               this.bot1_speed = 80;
            }
            else if(this.shared.data.bot1Skills[0][0] != 2)
            {
               this.bot1_speed = 60;
            }
            else
            {
               this.bot1_speed = 70;
            }
         }
         else
         {
            this.bot1_speed = 100;
         }
         if(this.shared.data.bot1Skills[1][2] != 2)
         {
            if(this.shared.data.bot1Skills[1][1] == 2)
            {
               this.bot1_damage = 20;
            }
            else if(this.shared.data.bot1Skills[1][0] != 2)
            {
               this.bot1_damage = 10;
            }
            else
            {
               this.bot1_damage = 15;
            }
         }
         else
         {
            this.bot1_damage = 25;
         }
         if(this.shared.data.bot1Skills[2][2] == 2)
         {
            this.bot1_accuracy = 5;
         }
         else if(this.shared.data.bot1Skills[2][1] == 2)
         {
            this.bot1_accuracy = 10;
         }
         else if(this.shared.data.bot1Skills[2][0] != 2)
         {
            this.bot1_accuracy = 20;
         }
         else
         {
            this.bot1_accuracy = 15;
         }
         if(this.shared.data.bot2Skills[0][2] == 2)
         {
            this.bot2_speed = 100;
         }
         else if(this.shared.data.bot2Skills[0][1] == 2)
         {
            this.bot2_speed = 80;
         }
         else if(this.shared.data.bot2Skills[0][0] != 2)
         {
            this.bot2_speed = 60;
         }
         else
         {
            this.bot2_speed = 70;
         }
         if(this.shared.data.bot2Skills[1][2] == 2)
         {
            this.bot2_damage = 50;
         }
         else if(this.shared.data.bot2Skills[1][1] != 2)
         {
            if(this.shared.data.bot2Skills[1][0] != 2)
            {
               this.bot2_damage = 20;
            }
            else
            {
               this.bot2_damage = 30;
            }
         }
         else
         {
            this.bot2_damage = 40;
         }
         if(this.shared.data.bot2Skills[2][2] == 2)
         {
            this.bot2_accuracy = 2;
         }
         else if(this.shared.data.bot2Skills[2][1] != 2)
         {
            if(this.shared.data.bot2Skills[2][0] != 2)
            {
               this.bot2_accuracy = 15;
            }
            else
            {
               this.bot2_accuracy = 10;
            }
         }
         else
         {
            this.bot2_accuracy = 5;
         }
         this.weapon1_1 = 0;
         this.weapon1_2 = 400;
         this.weapon2_1 = 800;
         this.weapon2_2 = 1000;
         this.weapon3_1 = 1400;
         this.weapon3_2 = 1800;
         this.weapon4_1 = 2400;
         this.weapon4_2 = 3000;
         this.weapon5_1 = 3800;
         this.weapon5_2 = 4200;
         this.weapon6_1 = 4800;
         this.weapon6_2 = 5800;
         this.weapon7_1 = 6400;
         this.weapon7_2 = 7200;
         this.weapon8_1 = 12000;
         this.weapon8_2 = 14000;
         this.weapon9_1 = 24000;
         this.weapon9_2 = 28000;
         this.weapon_price = [[this.weapon1_1,this.weapon1_2],[this.weapon2_1,this.weapon2_2],[this.weapon3_1,this.weapon3_2],[this.weapon4_1,this.weapon4_2],[this.weapon5_1,this.weapon5_2],[this.weapon6_1,this.weapon6_2],[this.weapon7_1,this.weapon7_2],[this.weapon8_1,this.weapon8_2],[this.weapon9_1,this.weapon9_2]];
         this.barricade_price = [[1000,3000,9000],[1000,3000,9000]];
         this.barricadeRepair_price = [[50,150,500],[50,150,500]];
      }
      
      public function spawnersArray_for_spawn(param1:Number) : Number
      {
         this.spawnsArray = [0,9,8,2,5,1,3,3,2,3,3,1,3,2,3,2,1,2,1,2,2,1,2,1,2,1,1,2,3,1,2,2,2,3,2,1,2,2,2,3,2,1,2,2,2,3,2,1,2,2,2,3,2,1,2,2,2,3,2,1,2,2,2,3,2,1,2,2,2,3,2,1,2,2,2,3,2,1,2,2,2,3,2,1,2,2,2,3,2,1,2,2,2,3,2,1,2,2,2,3,2,1,2,2,2,3,2,1,2,2,2,3,2,1,2,2,2,3,2,1,2,2,2,3,2,1,2,2,2,3,2,1,2,2,2,3,2,1,2,2,2,3,2,1,2,2,2,3,2,1,2,2,2,3,2,1,2,2,2,3,2,1,2,2,2,3,2,1,2,2,2,3,2,1,2,2,2,3,2,1,2,2,2,3,2,1,2,2,2,3,2,1,2,2,2,3,2,1,2,2,2,3,2,1,2,2,2,3,2,1,2,2,2,3,2,1,2,2,2,3,2,1,2,2,2,3,2,1,2,2,2,3,2,1,2,2,2,3,2,1,2,2,2,3,2,1];
         return Number(this.spawnsArray[param1]);
      }
      
      public function achievements() : void
      {
         var _loc5_:int = 0;
         var _loc1_:Number = this.shared.data.bulletHit / (this.shared.data.bulletMiss + this.shared.data.bulletHit);
         var _loc2_:Number = this.shared.data.bulletMiss + this.shared.data.bulletHit;
         if(this.shared.data.archivement[0][0] == 0 && this.shared.data.bulletShot[0] > 500)
         {
            this.shared.data.archivement[0][0] = 1;
            this.shared.data.score += 1000;
         }
         if(this.shared.data.archivement[0][1] == 0 && this.shared.data.zombieKilled > 5)
         {
            this.shared.data.archivement[0][1] = 1;
            this.shared.data.score += 1000;
         }
         if(this.shared.data.archivement[0][2] == 0 && this.shared.data.zombieKilled > 80)
         {
            this.shared.data.archivement[0][2] = 1;
            this.shared.data.score += 3000;
         }
         if(this.shared.data.archivement[0][3] == 0 && this.shared.data.zombieKilled > 150)
         {
            this.shared.data.archivement[0][3] = 1;
            this.shared.data.score += 5000;
         }
         if(this.shared.data.archivement[0][4] == 0 && this.shared.data.zombieKilled > 350)
         {
            this.shared.data.archivement[0][4] = 1;
            this.shared.data.score += 5000;
         }
         if(this.shared.data.archivement[0][5] == 0 && this.shared.data.zombieKilled > 500)
         {
            this.shared.data.archivement[0][5] = 1;
            this.shared.data.score += 5000;
         }
         if(this.shared.data.archivement[1][0] == 0 && this.shared.data.zombieKilled > 700)
         {
            this.shared.data.archivement[1][0] = 1;
            this.shared.data.score += 5000;
         }
         if(this.shared.data.archivement[1][1] == 0 && this.shared.data.zombieKilled > 900)
         {
            this.shared.data.archivement[1][1] = 1;
            this.shared.data.sp += 5;
         }
         if(this.shared.data.archivement[1][2] == 0 && this.shared.data.zombieKilled > 1200)
         {
            this.shared.data.archivement[1][2] = 1;
            this.shared.data.sp += 5;
         }
         if(this.shared.data.archivement[1][4] == 0 && this.shared.data.barricadesUpgrade[0][2] == 2 && this.shared.data.barricadesUpgrade[1][2] == 2)
         {
            this.shared.data.archivement[1][4] = 1;
            this.shared.data.sp += 5;
         }
         if(this.shared.data.archivement[1][5] == 0 && this.shared.data.bulletShot[7] > 300)
         {
            this.shared.data.archivement[1][5] = 1;
            this.shared.data.score += 3000;
         }
         if(this.shared.data.archivement[2][0] == 0 && this.shared.data.bulletShot[2] > 3000)
         {
            this.shared.data.archivement[2][0] = 1;
            this.shared.data.score += 3000;
         }
         if(this.shared.data.archivement[2][1] == 0 && this.shared.data.maxLvl >= 2)
         {
            this.shared.data.archivement[2][1] = 1;
            this.shared.data.score += 2000;
         }
         if(this.shared.data.archivement[2][2] == 0 && this.shared.data.maxLvl >= 3)
         {
            this.shared.data.archivement[2][2] = 1;
            this.shared.data.score += 3000;
         }
         if(this.shared.data.archivement[2][3] == 0 && this.shared.data.maxLvl >= 5)
         {
            this.shared.data.archivement[2][3] = 1;
            this.shared.data.score += 5000;
         }
         if(this.shared.data.archivement[2][4] == 0 && this.shared.data.maxLvl >= 7)
         {
            this.shared.data.archivement[2][4] = 1;
            this.shared.data.score += 7000;
         }
         if(this.shared.data.archivement[2][5] == 0 && this.shared.data.maxLvl >= 11)
         {
            this.shared.data.archivement[2][5] = 1;
            this.shared.data.score += 11000;
         }
         if(this.shared.data.archivement[3][0] == 0 && this.shared.data.maxLvl >= 13)
         {
            this.shared.data.archivement[3][0] = 1;
            this.shared.data.score += 13000;
         }
         if(this.shared.data.archivement[3][1] == 0 && this.shared.data.maxLvl >= 17)
         {
            this.shared.data.archivement[3][1] = 1;
            this.shared.data.score += 17000;
         }
         if(this.shared.data.archivement[3][2] == 0 && this.shared.data.maxLvl >= 19)
         {
            this.shared.data.archivement[3][2] = 1;
            this.shared.data.score += 19000;
         }
         if(this.shared.data.archivement[3][3] == 0 && this.shared.data.maxLvl >= 23)
         {
            this.shared.data.archivement[3][3] = 1;
            this.shared.data.score += 23000;
         }
         if(this.shared.data.archivement[3][4] == 0 && this.shared.data.bulletHit + this.shared.data.bulletMiss >= 5000)
         {
            this.shared.data.archivement[3][4] = 1;
            this.shared.data.score += 5000;
         }
         if(this.shared.data.archivement[3][5] == 0 && this.shared.data.playerSkills[1][2] == 2)
         {
            this.shared.data.archivement[3][5] = 1;
            this.shared.data.sp += 5;
         }
         if(this.shared.data.archivement[4][0] == 0 && this.shared.data.zombieKilled > 1500)
         {
            this.shared.data.archivement[4][0] = 1;
            this.shared.data.sp += 5;
         }
         if(this.shared.data.archivement[4][2] == 0 && this.shared.data.playerWeapons[0][0] == 2 && this.shared.data.playerWeapons[1][0] == 2 && this.shared.data.playerWeapons[2][0] == 2 && this.shared.data.playerWeapons[3][0] == 2 && this.shared.data.playerWeapons[4][0] == 2 && this.shared.data.playerWeapons[5][0] == 2 && this.shared.data.playerWeapons[6][0] == 2 && this.shared.data.playerWeapons[7][0] == 2 && this.shared.data.playerWeapons[8][0] == 2)
         {
            this.shared.data.archivement[4][2] = 1;
            this.shared.data.score += 5000;
         }
         if(this.shared.data.archivement[4][4] == 0 && this.shared.data.bot1Skills[0][2] == 2 && this.shared.data.bot1Skills[1][2] == 2 && this.shared.data.bot1Skills[2][2] == 2)
         {
            if(this.shared.data.bot2Skills[0][2] == 2 && this.shared.data.bot2Skills[1][2] == 2 && this.shared.data.bot2Skills[2][2] == 2)
            {
               this.shared.data.archivement[4][4] = 1;
               this.shared.data.sp += 20;
            }
         }
         if(this.shared.data.archivement[4][5] == 0 && this.shared.data.sp > 50)
         {
            this.shared.data.archivement[4][5] = 1;
            this.shared.data.sp += 25;
         }
         if(this.shared.data.archivement[5][0] == 0 && this.shared.data.playerSkills[6][2] == 2)
         {
            this.shared.data.archivement[5][0] = 1;
            this.shared.data.money += 10000;
            this.shared.data.moneyEarned = 10000;
         }
         if(this.shared.data.archivement[5][1] == 0 && _loc1_ > 0.6 && _loc2_ >= 1000)
         {
            this.shared.data.archivement[5][1] = 1;
            this.shared.data.score += 5000;
         }
         if(this.shared.data.archivement[5][2] == 0 && _loc1_ > 0.6 && _loc2_ >= 7000)
         {
            this.shared.data.archivement[5][2] = 1;
            this.shared.data.score += 7000;
         }
         if(this.shared.data.archivement[5][3] == 0 && this.shared.data.bulletShot[1] > 200)
         {
            this.shared.data.archivement[5][3] = 1;
            this.shared.data.score += 3000;
         }
         if(this.shared.data.archivement[5][4] == 0 && this.shared.data.playerSkills[0][2] == 2 && this.shared.data.playerSkills[1][2] == 2 && this.shared.data.playerSkills[2][2] == 2 && this.shared.data.playerSkills[3][2] == 2 && this.shared.data.playerSkills[4][2] == 2 && this.shared.data.playerSkills[5][2] == 2 && this.shared.data.playerSkills[6][2] == 2)
         {
            this.shared.data.archivement[5][4] = 1;
            this.shared.data.score += 10000;
         }
         if(this.shared.data.archivement[5][5] == 0 && this.shared.data.headShoot > 10)
         {
            this.shared.data.archivement[5][5] = 1;
            this.shared.data.score += 1000;
         }
         if(this.shared.data.archivement[6][0] == 0 && this.shared.data.headShoot > 50)
         {
            this.shared.data.archivement[6][0] = 1;
            this.shared.data.score += 2000;
         }
         if(this.shared.data.archivement[6][1] == 0 && this.shared.data.headShoot > 300)
         {
            this.shared.data.archivement[6][1] = 1;
            this.shared.data.score += 3000;
         }
         if(this.shared.data.archivement[6][2] == 0 && this.shared.data.headShoot > 500)
         {
            this.shared.data.archivement[6][2] = 1;
            this.shared.data.score += 5000;
         }
         if(this.shared.data.archivement[6][3] == 0 && this.shared.data.headShoot > 3000)
         {
            this.shared.data.archivement[6][3] = 1;
            this.shared.data.score += 6000;
         }
         if(this.shared.data.archivement[6][4] == 0 && this.shared.data.bulletShot[8] > 5000)
         {
            this.shared.data.archivement[6][4] = 1;
            this.shared.data.score += 3000;
         }
         var _loc3_:Boolean = true;
         var _loc4_:int = 0;
         while(_loc4_ < this.shared.data.archivement.length)
         {
            _loc5_ = 0;
            while(_loc5_ < this.shared.data.archivement[_loc4_].length)
            {
               if(this.shared.data.archivement[_loc4_][_loc5_] == 0)
               {
                  _loc3_ = false;
                  break;
               }
               _loc5_++;
            }
            _loc4_++;
         }
         if(_loc3_ == true)
         {
            this.shared.data.archivement[6][5] = 1;
            this.shared.data.score += 42;
         }
      }
      
      public function numberOfZombie(param1:Number) : Number
      {
         this.numberOfZombieArray = [0,15,15,10,16,15,20,25,20,32,35,30,35,40,35,35,35,40,25,40,45,50,60,60,60,65,60,70,75,80,80,65,60,80,85,80,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100];
         return Number(this.numberOfZombieArray[param1]);
      }
   }
}

