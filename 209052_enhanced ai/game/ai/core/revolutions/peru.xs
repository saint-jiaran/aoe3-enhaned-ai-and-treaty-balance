extern bool gPeruCitizenshipSent = false;
extern bool gPeruPeruvianGuardSent = false;
extern bool gPeruMorochucosCardSent = false;
extern bool gPeruAndeanWarriorsSent = false;
extern bool gPeruMachuPicchuSent = false;

extern int gPeruRevolutionaryMaintain = -1;
extern int gPeruMorochuchoMaintain = -1;
extern int gPeruHuaracaMaintain = -1;
extern int gPeruGatlingGunMaintain = -1;

//==============================================================================
// peruRevolutionManager
//==============================================================================
rule peruRevolutionManager
inactive
minInterval 30
{
   int mainBaseID = kbBaseGetMainID(cMyID);
   
   int enemyPlayer = aiGetMostHatedPlayerID();
   if (enemyPlayer < 1)
   {
      enemyPlayer = 2;
   }
   
   int enemyCavalryCount = kbUnitCount(enemyPlayer, cUnitTypeAbstractCavalry, cUnitStateAlive);
   int enemyShockInfCount = kbUnitCount(enemyPlayer, cUnitTypeAbstractCoyoteMan, cUnitStateAlive);
   int enemyHeavyInfCount = kbUnitCount(enemyPlayer, cUnitTypeAbstractHeavyInfantry, cUnitStateAlive);
   int enemyLightInfCount = kbUnitCount(enemyPlayer, cUnitTypeAbstractLightInfantry, cUnitStateAlive);
   int enemyArtilleryCount = kbUnitCount(enemyPlayer, cUnitTypeAbstractArtillery, cUnitStateAlive);
   
   int totalEnemyUnits = enemyCavalryCount + enemyShockInfCount + enemyHeavyInfCount + enemyLightInfCount;
   
   int militaryPop = aiGetMilitaryPop();
   int wantedRevolutionaries = 0;
   int wantedMorochucos = 0;
   int wantedHuaracas = 0;
   
   if (totalEnemyUnits > 5)
   {
      if (enemyArtilleryCount > 5)
      {
         wantedRevolutionaries = militaryPop * 0.35;
         wantedMorochucos = militaryPop * 0.25;
         wantedHuaracas = militaryPop * 0.40;
      }
      else if (enemyHeavyInfCount > enemyLightInfCount + 10)
      {
         wantedRevolutionaries = militaryPop * 0.45;
         wantedMorochucos = militaryPop * 0.25;
         wantedHuaracas = militaryPop * 0.30;
      }
      else if (enemyShockInfCount > 10)
      {
         wantedRevolutionaries = militaryPop * 0.35;
         wantedMorochucos = militaryPop * 0.40;
         wantedHuaracas = militaryPop * 0.25;
      }
      else if (enemyCavalryCount > 15)
      {
         wantedRevolutionaries = militaryPop * 0.50;
         wantedMorochucos = militaryPop * 0.30;
         wantedHuaracas = militaryPop * 0.20;
      }
      else
      {
         wantedRevolutionaries = militaryPop * 0.45;
         wantedMorochucos = militaryPop * 0.30;
         wantedHuaracas = militaryPop * 0.25;
      }
   }
   else
   {
      wantedRevolutionaries = militaryPop * 0.45;
      wantedMorochucos = militaryPop * 0.30;
      wantedHuaracas = militaryPop * 0.25;
   }
   
   int revolutionaryBL = kbGetBuildLimit(cMyID, cUnitTypexpColonialMilitia);
   int morochucoBL = kbGetBuildLimit(cMyID, cUnitTypeSaloonOutlawRider);
   int huaracaBL = kbGetBuildLimit(cMyID, cUnitTypedeSlinger);
   
   if ((revolutionaryBL > 0) && (wantedRevolutionaries > revolutionaryBL))
   {
      wantedRevolutionaries = revolutionaryBL;
   }
   if ((morochucoBL > 0) && (wantedMorochucos > morochucoBL))
   {
      wantedMorochucos = morochucoBL;
   }
   if ((huaracaBL > 0) && (wantedHuaracas > huaracaBL))
   {
      wantedHuaracas = huaracaBL;
   }
   
   if (wantedRevolutionaries < 15)
   {
      wantedRevolutionaries = 15;
   }
   if (wantedMorochucos < 8)
   {
      wantedMorochucos = 8;
   }
   if (wantedHuaracas < 6)
   {
      wantedHuaracas = 6;
   }
   
   if (kbProtoUnitAvailable(cUnitTypexpColonialMilitia) == true && gPeruRevolutionaryMaintain == -1)
   {
      gPeruRevolutionaryMaintain = createSimpleMaintainPlan(cUnitTypexpColonialMilitia, wantedRevolutionaries, false, mainBaseID, 1);
      aiPlanSetDesiredPriority(gPeruRevolutionaryMaintain, 80);
      aiPlanSetActive(gPeruRevolutionaryMaintain, true);
      debugMilitary("Peru: Created Revolutionary maintain plan");
   }
   else if (gPeruRevolutionaryMaintain >= 0)
   {
      aiPlanSetVariableInt(gPeruRevolutionaryMaintain, cTrainPlanNumberToMaintain, 0, wantedRevolutionaries);
   }
   
   if (gPeruMorochucosCardSent == true)
   {
      if (kbProtoUnitAvailable(cUnitTypeSaloonOutlawRider) == true && gPeruMorochuchoMaintain == -1)
      {
         gPeruMorochuchoMaintain = createSimpleMaintainPlan(cUnitTypeSaloonOutlawRider, wantedMorochucos, false, mainBaseID, 1);
         aiPlanSetDesiredPriority(gPeruMorochuchoMaintain, 70);
         aiPlanSetActive(gPeruMorochuchoMaintain, true);
         debugMilitary("Peru: Created Morochuco maintain plan");
      }
      else if (gPeruMorochuchoMaintain >= 0)
      {
         aiPlanSetVariableInt(gPeruMorochuchoMaintain, cTrainPlanNumberToMaintain, 0, wantedMorochucos);
      }
   }
   
   if (gPeruAndeanWarriorsSent == true || gPeruMachuPicchuSent == true)
   {
      if (kbProtoUnitAvailable(cUnitTypedeSlinger) == true && gPeruHuaracaMaintain == -1)
      {
         gPeruHuaracaMaintain = createSimpleMaintainPlan(cUnitTypedeSlinger, wantedHuaracas, false, mainBaseID, 1);
         aiPlanSetDesiredPriority(gPeruHuaracaMaintain, 65);
         aiPlanSetActive(gPeruHuaracaMaintain, true);
         debugMilitary("Peru: Created Huaraca maintain plan");
      }
      else if (gPeruHuaracaMaintain >= 0)
      {
         aiPlanSetVariableInt(gPeruHuaracaMaintain, cTrainPlanNumberToMaintain, 0, wantedHuaracas);
      }
   }
   
   debugMilitary("Peru army composition: Revolutionaries=" + wantedRevolutionaries + 
                 ", Morochucos=" + wantedMorochucos +
                 ", Huaracas=" + wantedHuaracas);
}

//==============================================================================
// peruEconomyManager
//==============================================================================
rule peruEconomyManager
inactive
minInterval 45
{
   
   float currentFood = kbResourceGet(cResourceFood);
   float currentWood = kbResourceGet(cResourceWood);
   float currentCoin = kbResourceGet(cResourceGold);
   
   int currentSettlers = kbUnitCount(cMyID, gEconUnit, cUnitStateAlive);
   
   bool hasEconomyCards = gPeruCitizenshipSent;
   
   if (hasEconomyCards == false)
   {
      debugMilitary("Peru Economy: No economy cards sent yet! Resources: F=" + currentFood + 
                    " W=" + currentWood + " C=" + currentCoin);
   }
   else
   {
      debugMilitary("Peru Economy: Settlers=" + currentSettlers + 
                    ", Resources: F=" + currentFood + " W=" + currentWood + " C=" + currentCoin);
   }
   
   if (gPeruMorochucosCardSent == true)
   {
      int cowCount = kbUnitCount(cMyID, cUnitTypeCow, cUnitStateAlive);
      int morochucosCount = kbUnitCount(cMyID, cUnitTypeSaloonOutlawRider, cUnitStateAlive);
      
      if (cowCount > 0)
      {
         debugMilitary("Peru Economy: Cows=" + cowCount + " available for Morochuco gathering");
      }
   }
   
   if (currentFood < 500)
   {
      debugMilitary("Peru Economy: LOW FOOD - critical for unit production");
   }
}

//==============================================================================
// peruCitizenshipManager
//==============================================================================
rule peruCitizenshipManager
inactive
minInterval 45
{
   if (gPeruCitizenshipSent == false)
   {
      if (kbTechGetStatus(cTechDEHCREVCitizenship) == cTechStatusActive)
      {
         gPeruCitizenshipSent = true;
         debugMilitary("Peru: Citizenship activated - economy restored!");
      }
      else
      {
         return;
      }
   }
   
   if (gSettlerMaintainPlan >= 0)
   {
      int currentSettlers = kbUnitCount(cMyID, gEconUnit, cUnitStateAlive);
      int settlerBL = kbGetBuildLimit(cMyID, gEconUnit);
      
      int wantedSettlers = 30;
      if ((settlerBL > 0) && (settlerBL < wantedSettlers))
      {
         wantedSettlers = settlerBL;
      }
      
      aiPlanSetVariableInt(gSettlerMaintainPlan, cTrainPlanNumberToMaintain, 0, wantedSettlers);
      aiPlanSetDesiredResourcePriority(gSettlerMaintainPlan, 70);
      
      debugMilitary("Peru Citizenship: Settlers=" + currentSettlers + "/" + wantedSettlers);
   }
}

//==============================================================================
// peruPeruvianGuardManager
//==============================================================================
rule peruPeruvianGuardManager
inactive
minInterval 45
{
   if (gPeruPeruvianGuardSent == false)
   {
      if (kbTechGetStatus(cTechDEHCREVPeruvianGuard) == cTechStatusActive)
      {
         gPeruPeruvianGuardSent = true;
         debugMilitary("Peru: Peruvian Guard activated - Revolutionaries upgraded to Peruvian Legions!");
      }
      else
      {
         return;
      }
   }
   
   int peruvianLegionCount = kbUnitCount(cMyID, cUnitTypexpColonialMilitia, cUnitStateAlive);
   
   debugMilitary("Peru: " + peruvianLegionCount + " Peruvian Legions with grenade attack");
   
}

//==============================================================================
// peruMorochucosManager
//==============================================================================
rule peruMorochucosManager
inactive
minInterval 45
{
   if (gPeruMorochucosCardSent == false)
   {
      if (kbTechGetStatus(cTechDEHCREVCowboys) == cTechStatusActive)
      {
         gPeruMorochucosCardSent = true;
         debugMilitary("Peru: Morochucos card activated!");
      }
      else
      {
         return;
      }
   }
   
   int morochucosCount = kbUnitCount(cMyID, cUnitTypeSaloonOutlawRider, cUnitStateAlive);
   int cowCount = kbUnitCount(cMyID, cUnitTypeCow, cUnitStateAlive);
   int livestockPenCount = kbUnitCount(cMyID, cUnitTypeLivestockPen, cUnitStateAlive);
   
   debugMilitary("Peru Morochucos: Morochucos=" + morochucosCount + 
                 ", Cows=" + cowCount + ", Livestock Pens=" + livestockPenCount);
   
}

//==============================================================================
// peruAndeanWarriorsManager
//==============================================================================
rule peruAndeanWarriorsManager
inactive
minInterval 45
{
   if (gPeruAndeanWarriorsSent == false)
   {
      if (kbTechGetStatus(cTechDEHCREVAmericanAlliesPeru) == cTechStatusActive)
      {
         gPeruAndeanWarriorsSent = true;
         debugMilitary("Peru: Andean Warriors activated - Huaracas available!");
      }
      else
      {
         return;
      }
   }
   
   int huaracaCount = kbUnitCount(cMyID, cUnitTypedeSlinger, cUnitStateAlive);
   
   debugMilitary("Peru Andean Warriors: Huaracas=" + huaracaCount);
   
}

//==============================================================================
// peruMachuPicchuManager
//==============================================================================
rule peruMachuPicchuManager
inactive
minInterval 60
{
   if (gPeruMachuPicchuSent == false)
   {
      if (kbTechGetStatus(cTechDEHCMachuPicchu) == cTechStatusActive)
      {
         gPeruMachuPicchuSent = true;
         debugMilitary("Peru: Machu Picchu activated - Strongholds can be built!");
      }
      else
      {
         return;
      }
   }
   
   int strongholdCount = kbUnitCount(cMyID, cUnitTypedeIncaStronghold, cUnitStateAlive);
   
   debugMilitary("Peru Machu Picchu: Strongholds=" + strongholdCount);
   
}

//==============================================================================
// peruBolivarManager
//==============================================================================
rule peruBolivarManager
inactive
minInterval 60
{
   
   int bolivarCount = kbUnitCount(cMyID, cUnitTypedeREVBolivar, cUnitStateAlive);
   
   if (bolivarCount > 0)
   {
      debugMilitary("Peru Bolivar: Active - providing +5% HP aura to nearby units");
   }
   else
   {
      debugMilitary("Peru Bolivar: Incapacitated - waiting to recover");
   }
   
}

//==============================================================================
// peruCardEffectTracker
//==============================================================================
rule peruCardEffectTracker
inactive
minInterval 30
{
   if ((gPeruCitizenshipSent == false) && 
       (kbTechGetStatus(cTechDEHCREVCitizenship) == cTechStatusActive))
   {
      gPeruCitizenshipSent = true;
      xsEnableRule("peruCitizenshipManager");
      debugMilitary("Peru: Citizenship activated - economy can be restored!");
   }
   
   if ((gPeruPeruvianGuardSent == false) && 
       (kbTechGetStatus(cTechDEHCREVPeruvianGuard) == cTechStatusActive))
   {
      gPeruPeruvianGuardSent = true;
      debugMilitary("Peru: Peruvian Guard activated - Peruvian Legions available!");
   }
   
   if ((gPeruMorochucosCardSent == false) && 
       (kbTechGetStatus(cTechDEHCREVCowboys) == cTechStatusActive))
   {
      gPeruMorochucosCardSent = true;
      debugMilitary("Peru: Morochucos card activated - cavalry enabled!");
   }
   
   if ((gPeruAndeanWarriorsSent == false) && 
       (kbTechGetStatus(cTechDEHCREVAmericanAlliesPeru) == cTechStatusActive))
   {
      gPeruAndeanWarriorsSent = true;
      debugMilitary("Peru: Andean Warriors activated - Huaracas available!");
   }
   
   if ((gPeruMachuPicchuSent == false) && 
       (kbTechGetStatus(cTechDEHCMachuPicchu) == cTechStatusActive))
   {
      gPeruMachuPicchuSent = true;
      debugMilitary("Peru: Machu Picchu activated - Strongholds can be built!");
   }
}

//==============================================================================
// peruCardManager
//==============================================================================
rule peruCardManager
inactive
minInterval 90
{
   float currentFood = kbResourceGet(cResourceFood);
   float currentWood = kbResourceGet(cResourceWood);
   float currentCoin = kbResourceGet(cResourceGold);
   
   int currentMilitary = aiGetMilitaryPop();
   int gameTime = xsGetTime();
   
   debugMilitary("Peru Card Manager: Evaluating card priorities");
}

//==============================================================================
// peruArtilleryManager
//==============================================================================
rule peruArtilleryManager
inactive
minInterval 45
{
   int mainBaseID = kbBaseGetMainID(cMyID);
   
   int gatlingGunCount = kbUnitCount(cMyID, cUnitTypexpGatlingGun, cUnitStateAlive);
   int huaracaCount = kbUnitCount(cMyID, cUnitTypedeSlinger, cUnitStateAlive);
   
   int enemyPlayer = aiGetMostHatedPlayerID();
   int enemyInfantryCount = kbUnitCount(enemyPlayer, cUnitTypeAbstractInfantry, cUnitStateAlive);
   
   int wantedGatlingGuns = 0;
   
   if (enemyInfantryCount > 30)
   {
      wantedGatlingGuns = 4;
   }
   else
   {
      wantedGatlingGuns = 2;
   }
   
   if (wantedGatlingGuns > 6)
   {
      wantedGatlingGuns = 6;
   }
   
   if (wantedGatlingGuns > 0)
   {
      if (kbProtoUnitAvailable(cUnitTypexpGatlingGun) == true && gPeruGatlingGunMaintain == -1)
      {
         gPeruGatlingGunMaintain = createSimpleMaintainPlan(cUnitTypexpGatlingGun, wantedGatlingGuns, false, mainBaseID, 1);
         aiPlanSetDesiredPriority(gPeruGatlingGunMaintain, 55);
         aiPlanSetActive(gPeruGatlingGunMaintain, true);
         debugMilitary("Peru: Created Gatling Gun maintain plan");
      }
      else if (gPeruGatlingGunMaintain >= 0)
      {
         aiPlanSetVariableInt(gPeruGatlingGunMaintain, cTrainPlanNumberToMaintain, 0, wantedGatlingGuns);
      }
   }
   
   debugMilitary("Peru artillery: Gatling Guns=" + gatlingGunCount + "/" + wantedGatlingGuns +
                 ", Huaracas=" + huaracaCount);
}

//==============================================================================
// peruNavyManager
//==============================================================================
rule peruNavyManager
inactive
minInterval 45
{
   if (gNavyMap == false)
   {
      xsDisableSelf();
      return;
   }
   
   int mainBaseID = kbBaseGetMainID(cMyID);
   
   int ironcladCount = kbUnitCount(cMyID, cUnitTypexpIronclad, cUnitStateAlive);
   
   int enemyPlayer = aiGetMostHatedPlayerID();
   int enemyNavyCount = kbUnitCount(enemyPlayer, cUnitTypeAbstractWarShip, cUnitStateAlive);
   
   int wantedIronclads = 2;
   
   if (enemyNavyCount > 5)
   {
      wantedIronclads = 4;
   }
   
   debugMilitary("Peru Navy: Ironclads=" + ironcladCount + "/" + wantedIronclads);
   
}

//==============================================================================
// peruGrenadePositioningManager
//==============================================================================
rule peruGrenadePositioningManager
inactive
minInterval 60
{
   if (gPeruPeruvianGuardSent == false)
   {
      return;
   }
   
   int peruvianLegionCount = kbUnitCount(cMyID, cUnitTypexpColonialMilitia, cUnitStateAlive);
   
   if (peruvianLegionCount >= 10)
   {
      debugMilitary("Peru Grenade Positioning: " + peruvianLegionCount + 
                    " Peruvian Legions - keep at 12-18 range for grenade volleys");
   }
   
}

//==============================================================================
// peruRaidManager
//==============================================================================
rule peruRaidManager
inactive
minInterval 60
{
   if (gPeruMorochucosCardSent == false)
   {
      return;
   }
   
   int morochucosCount = kbUnitCount(cMyID, cUnitTypeSaloonOutlawRider, cUnitStateAlive);
   
   if (morochucosCount >= 8)
   {
      debugMilitary("Peru Raid: Have " + morochucosCount + " Morochucos available for raiding");
   }
   else
   {
      debugMilitary("Peru Raid: Only " + morochucosCount + " Morochucos - building up forces");
   }
}
