extern bool gGranColombiaCitizenshipSent = false;
extern bool gGranColombiaLlanerosSent = false;
extern bool gGranColombiaNationalHeroSent = false;
extern bool gGranColombiaColombianArmySent = false;
extern bool gGranColombiaColombianNavySent = false;

extern int gGranColombiaIndependenceGuardMaintain = -1;
extern int gGranColombiaLlaneroMaintain = -1;
extern int gGranColombiaSkirmisherMaintain = -1;
extern int gGranColombiaGatlingGunMaintain = -1;
extern int gGranColombiaIroncladMaintain = -1;

//==============================================================================
// granColombiaRevolutionManager
//==============================================================================
rule granColombiaRevolutionManager
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
   int wantedIndependenceGuards = 0;
   int wantedLlaneros = 0;
   int wantedSkirmishers = 0;
   
   if (totalEnemyUnits > 5)
   {
      if (enemyCavalryCount + enemyShockInfCount > enemyHeavyInfCount + enemyLightInfCount)
      {
         wantedIndependenceGuards = militaryPop * 0.50;
         wantedLlaneros = militaryPop * 0.25;
         wantedSkirmishers = militaryPop * 0.25;
      }
      else if (enemyHeavyInfCount > enemyLightInfCount)
      {
         wantedIndependenceGuards = militaryPop * 0.30;
         wantedLlaneros = militaryPop * 0.35;
         wantedSkirmishers = militaryPop * 0.35;
      }
      else if (enemyLightInfCount > 15)
      {
         wantedIndependenceGuards = militaryPop * 0.35;
         wantedLlaneros = militaryPop * 0.40;
         wantedSkirmishers = militaryPop * 0.25;
      }
      else
      {
         wantedIndependenceGuards = militaryPop * 0.45;
         wantedLlaneros = militaryPop * 0.30;
         wantedSkirmishers = militaryPop * 0.25;
      }
   }
   else
   {
      wantedIndependenceGuards = militaryPop * 0.45;
      wantedLlaneros = militaryPop * 0.30;
      wantedSkirmishers = militaryPop * 0.25;
   }
   
   int independenceGuardBL = kbGetBuildLimit(cMyID, cUnitTypeMusketeer);
   int llaneroBL = kbGetBuildLimit(cMyID, cUnitTypedeREVLlanero);
   int skirmisherBL = kbGetBuildLimit(cMyID, cUnitTypeSkirmisher);
   
   if ((independenceGuardBL > 0) && (wantedIndependenceGuards > independenceGuardBL))
   {
      wantedIndependenceGuards = independenceGuardBL;
   }
   if ((llaneroBL > 0) && (wantedLlaneros > llaneroBL))
   {
      wantedLlaneros = llaneroBL;
   }
   if ((skirmisherBL > 0) && (wantedSkirmishers > skirmisherBL))
   {
      wantedSkirmishers = skirmisherBL;
   }
   
   if (wantedIndependenceGuards < 15)
   {
      wantedIndependenceGuards = 15;
   }
   if (wantedLlaneros < 8)
   {
      wantedLlaneros = 8;
   }
   if (wantedSkirmishers < 10)
   {
      wantedSkirmishers = 10;
   }
   
   if (kbProtoUnitAvailable(cUnitTypeMusketeer) == true && gGranColombiaIndependenceGuardMaintain == -1)
   {
      gGranColombiaIndependenceGuardMaintain = createSimpleMaintainPlan(cUnitTypeMusketeer, wantedIndependenceGuards, false, mainBaseID, 1);
      aiPlanSetDesiredPriority(gGranColombiaIndependenceGuardMaintain, 80);
      aiPlanSetActive(gGranColombiaIndependenceGuardMaintain, true);
      debugMilitary("Gran Colombia: Created Independence Guard maintain plan");
   }
   else if (gGranColombiaIndependenceGuardMaintain >= 0)
   {
      aiPlanSetVariableInt(gGranColombiaIndependenceGuardMaintain, cTrainPlanNumberToMaintain, 0, wantedIndependenceGuards);
   }
   
   if (gGranColombiaLlanerosSent == true)
   {
      if (kbProtoUnitAvailable(cUnitTypedeREVLlanero) == true && gGranColombiaLlaneroMaintain == -1)
      {
         gGranColombiaLlaneroMaintain = createSimpleMaintainPlan(cUnitTypedeREVLlanero, wantedLlaneros, false, mainBaseID, 1);
         aiPlanSetDesiredPriority(gGranColombiaLlaneroMaintain, 70);
         aiPlanSetActive(gGranColombiaLlaneroMaintain, true);
         debugMilitary("Gran Colombia: Created Llanero maintain plan");
      }
      else if (gGranColombiaLlaneroMaintain >= 0)
      {
         aiPlanSetVariableInt(gGranColombiaLlaneroMaintain, cTrainPlanNumberToMaintain, 0, wantedLlaneros);
      }
   }
   
   if (kbProtoUnitAvailable(cUnitTypeSkirmisher) == true && gGranColombiaSkirmisherMaintain == -1)
   {
      gGranColombiaSkirmisherMaintain = createSimpleMaintainPlan(cUnitTypeSkirmisher, wantedSkirmishers, false, mainBaseID, 1);
      aiPlanSetDesiredPriority(gGranColombiaSkirmisherMaintain, 65);
      aiPlanSetActive(gGranColombiaSkirmisherMaintain, true);
      debugMilitary("Gran Colombia: Created Skirmisher maintain plan");
   }
   else if (gGranColombiaSkirmisherMaintain >= 0)
   {
      aiPlanSetVariableInt(gGranColombiaSkirmisherMaintain, cTrainPlanNumberToMaintain, 0, wantedSkirmishers);
   }
   
   debugMilitary("Gran Colombia army composition: Independence Guards=" + wantedIndependenceGuards + 
                 ", Llaneros=" + wantedLlaneros +
                 ", Skirmishers=" + wantedSkirmishers);
}

//==============================================================================
// granColombiaEconomyManager
//==============================================================================
rule granColombiaEconomyManager
inactive
minInterval 45
{
   
   float currentFood = kbResourceGet(cResourceFood);
   float currentWood = kbResourceGet(cResourceWood);
   float currentCoin = kbResourceGet(cResourceGold);
   
   int currentSettlers = kbUnitCount(cMyID, gEconUnit, cUnitStateAlive);
   
   bool hasEconomyCards = gGranColombiaCitizenshipSent;
   
   if (hasEconomyCards == false)
   {
      debugMilitary("Gran Colombia Economy: No economy cards sent yet! Resources: F=" + currentFood + 
                    " W=" + currentWood + " C=" + currentCoin);
   }
   else
   {
      debugMilitary("Gran Colombia Economy: Settlers=" + currentSettlers + 
                    ", Resources: F=" + currentFood + " W=" + currentWood + " C=" + currentCoin);
   }
   
   if (gGranColombiaLlanerosSent == true)
   {
      int cowCount = kbUnitCount(cMyID, cUnitTypeCow, cUnitStateAlive);
      int llaneroCount = kbUnitCount(cMyID, cUnitTypedeREVLlanero, cUnitStateAlive);
      
      if (cowCount > 0)
      {
         debugMilitary("Gran Colombia Economy: Cows=" + cowCount + " available for Llanero gathering");
      }
   }
   
   if (currentFood < 500)
   {
      debugMilitary("Gran Colombia Economy: LOW FOOD - critical for unit production");
   }
}

//==============================================================================
// granColombiaCitizenshipManager
//==============================================================================
rule granColombiaCitizenshipManager
inactive
minInterval 45
{
   if (gGranColombiaCitizenshipSent == false)
   {
      if (kbTechGetStatus(cTechDEHCREVCitizenship) == cTechStatusActive)
      {
         gGranColombiaCitizenshipSent = true;
         debugMilitary("Gran Colombia: Citizenship activated - economy restored!");
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
      
      debugMilitary("Gran Colombia Citizenship: Settlers=" + currentSettlers + "/" + wantedSettlers);
   }
}

//==============================================================================
// granColombiaLlaneroManager
//==============================================================================
rule granColombiaLlaneroManager
inactive
minInterval 45
{
   if (gGranColombiaLlanerosSent == false)
   {
      if (kbTechGetStatus(cTechDEHCREVLlaneros) == cTechStatusActive)
      {
         gGranColombiaLlanerosSent = true;
         debugMilitary("Gran Colombia: Llaneros card activated!");
      }
      else
      {
         return;
      }
   }
   
   int llaneroCount = kbUnitCount(cMyID, cUnitTypedeREVLlanero, cUnitStateAlive);
   int cowCount = kbUnitCount(cMyID, cUnitTypeCow, cUnitStateAlive);
   int livestockPenCount = kbUnitCount(cMyID, cUnitTypeLivestockPen, cUnitStateAlive);
   
   debugMilitary("Gran Colombia Llaneros: Llaneros=" + llaneroCount + 
                 ", Cows=" + cowCount + ", Livestock Pens=" + livestockPenCount);
   
}

//==============================================================================
// granColombiaNavyManager
//==============================================================================
rule granColombiaNavyManager
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
   int frigateCount = kbUnitCount(cMyID, cUnitTypeFrigate, cUnitStateAlive);
   int sloopCount = kbUnitCount(cMyID, cUnitTypedeSloop, cUnitStateAlive);
   
   int enemyPlayer = aiGetMostHatedPlayerID();
   int enemyNavyCount = kbUnitCount(enemyPlayer, cUnitTypeAbstractWarShip, cUnitStateAlive);
   
   int wantedIronclads = 2;
   
   if (enemyNavyCount > 5)
   {
      wantedIronclads = 4;
   }
   
   debugMilitary("Gran Colombia Navy: Ironclads=" + ironcladCount + "/" + wantedIronclads +
                 ", Frigates=" + frigateCount + ", Sloops=" + sloopCount);
   
}

//==============================================================================
// granColombiaArtilleryManager
//==============================================================================
rule granColombiaArtilleryManager
inactive
minInterval 45
{
   int mainBaseID = kbBaseGetMainID(cMyID);
   
   int gatlingGunCount = kbUnitCount(cMyID, cUnitTypexpGatlingGun, cUnitStateAlive);
   
   int enemyPlayer = aiGetMostHatedPlayerID();
   int enemyInfantryCount = kbUnitCount(enemyPlayer, cUnitTypeAbstractInfantry, cUnitStateAlive);
   int enemyHeavyInfCount = kbUnitCount(enemyPlayer, cUnitTypeAbstractHeavyInfantry, cUnitStateAlive);
   
   int wantedGatlingGuns = 0;
   
   if (enemyHeavyInfCount > 20)
   {
      wantedGatlingGuns = 6;
   }
   else if (enemyInfantryCount > 30)
   {
      wantedGatlingGuns = 4;
   }
   else
   {
      wantedGatlingGuns = 2;
   }
   
   if (wantedGatlingGuns > 8)
   {
      wantedGatlingGuns = 8;
   }
   
   if (wantedGatlingGuns > 0)
   {
      if (kbProtoUnitAvailable(cUnitTypexpGatlingGun) == true && gGranColombiaGatlingGunMaintain == -1)
      {
         gGranColombiaGatlingGunMaintain = createSimpleMaintainPlan(cUnitTypexpGatlingGun, wantedGatlingGuns, false, mainBaseID, 1);
         aiPlanSetDesiredPriority(gGranColombiaGatlingGunMaintain, 55);
         aiPlanSetActive(gGranColombiaGatlingGunMaintain, true);
         debugMilitary("Gran Colombia: Created Gatling Gun maintain plan");
      }
      else if (gGranColombiaGatlingGunMaintain >= 0)
      {
         aiPlanSetVariableInt(gGranColombiaGatlingGunMaintain, cTrainPlanNumberToMaintain, 0, wantedGatlingGuns);
      }
   }
   
   debugMilitary("Gran Colombia artillery: Gatling Guns=" + gatlingGunCount + "/" + wantedGatlingGuns);
}

//==============================================================================
// granColombiaCardEffectTracker
//==============================================================================
rule granColombiaCardEffectTracker
inactive
minInterval 30
{
   if ((gGranColombiaCitizenshipSent == false) && 
       (kbTechGetStatus(cTechDEHCREVCitizenship) == cTechStatusActive))
   {
      gGranColombiaCitizenshipSent = true;
      xsEnableRule("granColombiaCitizenshipManager");
      debugMilitary("Gran Colombia: Citizenship activated - economy can be restored!");
   }
   
   if ((gGranColombiaLlanerosSent == false) && 
       (kbTechGetStatus(cTechDEHCREVLlaneros) == cTechStatusActive))
   {
      gGranColombiaLlanerosSent = true;
      debugMilitary("Gran Colombia: Llaneros card activated - cavalry enabled!");
   }
   
   if ((gGranColombiaNationalHeroSent == false) && 
       (kbTechGetStatus(cTechDEHCREVNationalHero) == cTechStatusActive))
   {
      gGranColombiaNationalHeroSent = true;
      debugMilitary("Gran Colombia: National Hero activated - Simon Bolivar arrived!");
   }
   
   if ((gGranColombiaColombianArmySent == false) && 
       (kbTechGetStatus(cTechDEHCREVColombianArmy) == cTechStatusActive))
   {
      gGranColombiaColombianArmySent = true;
      debugMilitary("Gran Colombia: Colombian Army activated - Imperial upgrades available!");
   }
   
   if ((gGranColombiaColombianNavySent == false) && 
       (kbTechGetStatus(cTechDEHCREVColombianNavy) == cTechStatusActive))
   {
      gGranColombiaColombianNavySent = true;
      debugMilitary("Gran Colombia: Colombian Navy activated - Sloops replace Caravels!");
   }
}

//==============================================================================
// granColombiaCardManager
//==============================================================================
rule granColombiaCardManager
inactive
minInterval 90
{
   float currentFood = kbResourceGet(cResourceFood);
   float currentWood = kbResourceGet(cResourceWood);
   float currentCoin = kbResourceGet(cResourceGold);
   
   int currentMilitary = aiGetMilitaryPop();
   int gameTime = xsGetTime();
   
   debugMilitary("Gran Colombia Card Manager: Evaluating card priorities");
}

//==============================================================================
// granColombiaBolivarManager
//==============================================================================
rule granColombiaBolivarManager
inactive
minInterval 60
{
   if (gGranColombiaNationalHeroSent == false)
   {
      if (kbTechGetStatus(cTechDEHCREVNationalHero) == cTechStatusActive)
      {
         gGranColombiaNationalHeroSent = true;
         debugMilitary("Gran Colombia: Simon Bolivar arrived!");
      }
      else
      {
         return;
      }
   }
   
   int bolivarCount = kbUnitCount(cMyID, cUnitTypedeREVBolivar, cUnitStateAlive);
   
   if (bolivarCount > 0)
   {
      debugMilitary("Gran Colombia Bolivar: Active - providing +5% HP aura to nearby units");
   }
   else
   {
      debugMilitary("Gran Colombia Bolivar: Incapacitated - waiting to recover");
   }
   
}

//==============================================================================
// granColombiaRaidManager
//==============================================================================
rule granColombiaRaidManager
inactive
minInterval 60
{
   if (gGranColombiaLlanerosSent == false)
   {
      return;
   }
   
   int llaneroCount = kbUnitCount(cMyID, cUnitTypedeREVLlanero, cUnitStateAlive);
   
   if (llaneroCount >= 8)
   {
      debugMilitary("Gran Colombia Raid: Have " + llaneroCount + " Llaneros available for raiding");
   }
   else
   {
      debugMilitary("Gran Colombia Raid: Only " + llaneroCount + " Llaneros - building up forces");
   }
}

//==============================================================================
// granColombiaMercenaryManager
//==============================================================================
rule granColombiaMercenaryManager
inactive
minInterval 60
{
   
   int highlanderCount = kbUnitCount(cMyID, cUnitTypeMercHighlander, cUnitStateAlive);
   int jaegerCount = kbUnitCount(cMyID, cUnitTypeMercJaeger, cUnitStateAlive);
   int harquebusierCount = kbUnitCount(cMyID, cUnitTypedeMercHarquebusier, cUnitStateAlive);
   
   int totalMercs = highlanderCount + jaegerCount + harquebusierCount;
   
   if (totalMercs > 0)
   {
      debugMilitary("Gran Colombia Mercenaries: Highlanders=" + highlanderCount +
                    ", Jaegers=" + jaegerCount + ", Harquebusiers=" + harquebusierCount);
   }
   
}

//==============================================================================
// granColombiaColombianArmyManager
//==============================================================================
rule granColombiaColombianArmyManager
inactive
minInterval 60
{
   if (gGranColombiaColombianArmySent == false)
   {
      if (kbTechGetStatus(cTechDEHCREVColombianArmy) == cTechStatusActive)
      {
         gGranColombiaColombianArmySent = true;
         debugMilitary("Gran Colombia: Colombian Army activated!");
      }
      else
      {
         return;
      }
   }
   
   debugMilitary("Gran Colombia: Imperial infantry upgrades available at -60% cost!");
   
}
