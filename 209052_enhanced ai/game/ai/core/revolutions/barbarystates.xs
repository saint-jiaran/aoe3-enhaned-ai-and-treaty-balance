extern bool gDhimmaSent = false;
extern bool gCorsairCaptainSent = false;
extern bool gLoyalWarriorsSent = false;

extern int gBarbaryWarriorMaintain = -1;
extern int gCorsairMarksmanMaintain = -1;
extern int gBarbaryPrivateerMaintain = -1;
extern int gBarbaryFalconetMaintain = -1;
extern int gBarbaryCulverinMaintain = -1;
extern int gBarbaryGalleonMaintain = -1;

//==============================================================================
// barbaryStatesRevolutionManager
//==============================================================================
rule barbaryStatesRevolutionManager
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
   
   int enemyBarbaryWarriorTargets = enemyCavalryCount + enemyShockInfCount;
   int enemyCorsairMarksmanTargets = enemyHeavyInfCount;
   
   int totalEnemyUnits = enemyBarbaryWarriorTargets + enemyCorsairMarksmanTargets + 
                         enemyLightInfCount + enemyArtilleryCount;
   
   int militaryPop = aiGetMilitaryPop();
   int wantedBarbaryWarriors = 0;
   int wantedCorsairMarksmen = 0;
   
   if (totalEnemyUnits > 5)
   {
      float barbaryWarriorTargetRatio = 0.0;
      float corsairMarksmanTargetRatio = 0.0;
      
      if (totalEnemyUnits > 0)
      {
         barbaryWarriorTargetRatio = (enemyBarbaryWarriorTargets * 1.0) / totalEnemyUnits;
         corsairMarksmanTargetRatio = (enemyCorsairMarksmanTargets * 1.0) / totalEnemyUnits;
      }
      
      if (barbaryWarriorTargetRatio > 0.5)
      {
         wantedBarbaryWarriors = militaryPop * 0.65;
         wantedCorsairMarksmen = (militaryPop * 0.35) / 2;
      }
      else if (corsairMarksmanTargetRatio > 0.4)
      {
         wantedBarbaryWarriors = militaryPop * 0.30;
         wantedCorsairMarksmen = (militaryPop * 0.70) / 2;
      }
      else if (enemyArtilleryCount > 5)
      {
         wantedBarbaryWarriors = militaryPop * 0.55;
         wantedCorsairMarksmen = (militaryPop * 0.45) / 2;
      }
      else
      {
         wantedBarbaryWarriors = militaryPop * 0.45;
         wantedCorsairMarksmen = (militaryPop * 0.55) / 2;
      }
   }
   else
   {
      wantedBarbaryWarriors = militaryPop * 0.50;
      wantedCorsairMarksmen = (militaryPop * 0.50) / 2;
   }
   
   int barbaryWarriorBL = kbGetBuildLimit(cMyID, cUnitTypeMercBarbaryCorsair);
   int corsairMarksmanBL = kbGetBuildLimit(cMyID, cUnitTypedeAllegianceBarbaryMarksman);
   
   if ((barbaryWarriorBL > 0) && (wantedBarbaryWarriors > barbaryWarriorBL))
   {
      wantedBarbaryWarriors = barbaryWarriorBL;
   }
   if ((corsairMarksmanBL > 0) && (wantedCorsairMarksmen > corsairMarksmanBL))
   {
      wantedCorsairMarksmen = corsairMarksmanBL;
   }
   
   if (wantedBarbaryWarriors < 10)
   {
      wantedBarbaryWarriors = 10;
   }
   if (wantedCorsairMarksmen < 5)
   {
      wantedCorsairMarksmen = 5;
   }
   
   if (kbProtoUnitAvailable(cUnitTypeMercBarbaryCorsair) == true && gBarbaryWarriorMaintain == -1)
   {
      gBarbaryWarriorMaintain = createSimpleMaintainPlan(cUnitTypeMercBarbaryCorsair, wantedBarbaryWarriors, false, mainBaseID, 1);
      aiPlanSetDesiredPriority(gBarbaryWarriorMaintain, 70);
      aiPlanSetActive(gBarbaryWarriorMaintain, true);
      debugMilitary("Barbary States: Created Barbary Warrior maintain plan");
   }
   else if (gBarbaryWarriorMaintain >= 0)
   {
      aiPlanSetVariableInt(gBarbaryWarriorMaintain, cTrainPlanNumberToMaintain, 0, wantedBarbaryWarriors);
   }
   
   if (kbProtoUnitAvailable(cUnitTypedeAllegianceBarbaryMarksman) == true && gCorsairMarksmanMaintain == -1)
   {
      gCorsairMarksmanMaintain = createSimpleMaintainPlan(cUnitTypedeAllegianceBarbaryMarksman, wantedCorsairMarksmen, false, mainBaseID, 1);
      aiPlanSetDesiredPriority(gCorsairMarksmanMaintain, 65);
      aiPlanSetActive(gCorsairMarksmanMaintain, true);
      debugMilitary("Barbary States: Created Corsair Marksman maintain plan");
   }
   else if (gCorsairMarksmanMaintain >= 0)
   {
      aiPlanSetVariableInt(gCorsairMarksmanMaintain, cTrainPlanNumberToMaintain, 0, wantedCorsairMarksmen);
   }
   
   debugMilitary("Barbary States army composition: Barbary Warriors=" + wantedBarbaryWarriors + 
                 ", Corsair Marksmen=" + wantedCorsairMarksmen);
}

//==============================================================================
// barbaryStatesFishingManager
//==============================================================================
rule barbaryStatesFishingManager
inactive
minInterval 60
{
   
   if ((gNavyMap == false) || (gGoodFishingMap == false))
   {
      xsDisableSelf();
      return;
   }
   
   int dockID = getUnit(gDockUnit, cMyID, cUnitStateAlive);
   if (dockID < 0)
   {
      return;
   }
   
   if (gFishingBoatMaintainPlan >= 0)
   {
      int currentFishingBoats = kbUnitCount(cMyID, gFishingUnit, cUnitStateAlive);
      int fishingBoatBL = kbGetBuildLimit(cMyID, gFishingUnit);
      
      int wantedFishingBoats = fishingBoatBL;
      if (wantedFishingBoats < 0)
      {
         wantedFishingBoats = 20;
      }
      if (wantedFishingBoats > 30)
      {
         wantedFishingBoats = 30;
      }
      
      aiPlanSetVariableInt(gFishingBoatMaintainPlan, cTrainPlanNumberToMaintain, 0, wantedFishingBoats);
      
      aiPlanSetDesiredResourcePriority(gFishingBoatMaintainPlan, 75);
      
      debugMilitary("Barbary States fishing: Current=" + currentFishingBoats + 
                    ", Wanted=" + wantedFishingBoats);
   }
}

//==============================================================================
// barbaryStatesArtilleryManager  
//==============================================================================
rule barbaryStatesArtilleryManager
inactive
minInterval 45
{
   if (gNavyMap == false)
   {
      xsDisableSelf();
      return;
   }
   
   int mainBaseID = kbBaseGetMainID(cMyID);
   
   int privateerCount = kbUnitCount(cMyID, cUnitTypePrivateer, cUnitStateAlive);
   if (privateerCount < 1)
   {
      return;
   }
   
   int falconetCount = kbUnitCount(cMyID, cUnitTypeFalconet, cUnitStateAlive);
   int culverinCount = kbUnitCount(cMyID, cUnitTypeCulverin, cUnitStateAlive);
   int totalArtillery = falconetCount + culverinCount;
   
   int enemyPlayer = aiGetMostHatedPlayerID();
   int enemyArtilleryCount = kbUnitCount(enemyPlayer, cUnitTypeAbstractArtillery, cUnitStateAlive);
   int enemyInfantryCount = kbUnitCount(enemyPlayer, cUnitTypeAbstractInfantry, cUnitStateAlive);
   
   int wantedCulverins = 0;
   int wantedFalconets = 0;
   
   if (enemyArtilleryCount > 3)
   {
      wantedCulverins = (enemyArtilleryCount / 2) + 1;
      wantedFalconets = 2;
   }
   else
   {
      wantedFalconets = 4;
      wantedCulverins = 1;
   }
   
   if (enemyInfantryCount > 30)
   {
      wantedFalconets = wantedFalconets + 2;
   }
   
   if (wantedCulverins > 5)
   {
      wantedCulverins = 5;
   }
   if (wantedFalconets > 6)
   {
      wantedFalconets = 6;
   }
   
   if (wantedFalconets > 0)
   {
      if (kbProtoUnitAvailable(cUnitTypeFalconet) == true && gBarbaryFalconetMaintain == -1)
      {
         gBarbaryFalconetMaintain = createSimpleMaintainPlan(cUnitTypeFalconet, wantedFalconets, false, mainBaseID, 1);
         aiPlanSetDesiredPriority(gBarbaryFalconetMaintain, 50);
         aiPlanSetActive(gBarbaryFalconetMaintain, true);
         debugMilitary("Barbary States: Created Falconet maintain plan");
      }
      else if (gBarbaryFalconetMaintain >= 0)
      {
         aiPlanSetVariableInt(gBarbaryFalconetMaintain, cTrainPlanNumberToMaintain, 0, wantedFalconets);
      }
   }
   
   if (wantedCulverins > 0)
   {
      if (kbProtoUnitAvailable(cUnitTypeCulverin) == true && gBarbaryCulverinMaintain == -1)
      {
         gBarbaryCulverinMaintain = createSimpleMaintainPlan(cUnitTypeCulverin, wantedCulverins, false, mainBaseID, 1);
         aiPlanSetDesiredPriority(gBarbaryCulverinMaintain, 45);
         aiPlanSetActive(gBarbaryCulverinMaintain, true);
         debugMilitary("Barbary States: Created Culverin maintain plan");
      }
      else if (gBarbaryCulverinMaintain >= 0)
      {
         aiPlanSetVariableInt(gBarbaryCulverinMaintain, cTrainPlanNumberToMaintain, 0, wantedCulverins);
      }
   }
   
   debugMilitary("Barbary States artillery: Falconets=" + falconetCount + "/" + wantedFalconets +
                 ", Culverins=" + culverinCount + "/" + wantedCulverins);
}

//==============================================================================
// barbaryStatesNavyManager
//==============================================================================
rule barbaryStatesNavyManager
inactive
minInterval 45
{
   if (gNavyMap == false)
   {
      xsDisableSelf();
      return;
   }
   
   int mainBaseID = kbBaseGetMainID(cMyID);
   
   int privateerCount = kbUnitCount(cMyID, cUnitTypePrivateer, cUnitStateAlive);
   int xebecCount = kbUnitCount(cMyID, cUnitTypedeMercXebec, cUnitStateAlive);
   int galleyCount = kbUnitCount(cMyID, cUnitTypeGalleon, cUnitStateAlive);
   
   int enemyPlayer = aiGetMostHatedPlayerID();
   int enemyNavyCount = kbUnitCount(enemyPlayer, cUnitTypeAbstractWarShip, cUnitStateAlive);
   
   int wantedGalleons = 3;
   if (enemyNavyCount > 5)
   {
      wantedGalleons = 5;
   }
   
   if (kbProtoUnitAvailable(cUnitTypeGalleon) == true && gBarbaryGalleonMaintain == -1)
   {
      gBarbaryGalleonMaintain = createSimpleMaintainPlan(cUnitTypeGalleon, wantedGalleons, false, mainBaseID, 1);
      aiPlanSetDesiredPriority(gBarbaryGalleonMaintain, 50);
      aiPlanSetActive(gBarbaryGalleonMaintain, true);
      debugMilitary("Barbary States: Created Galleon maintain plan");
   }
   else if (gBarbaryGalleonMaintain >= 0)
   {
      aiPlanSetVariableInt(gBarbaryGalleonMaintain, cTrainPlanNumberToMaintain, 0, wantedGalleons);
   }
   
   debugMilitary("Barbary States Navy: Privateers=" + privateerCount + 
                 ", Xebecs=" + xebecCount + 
                 ", Galleons=" + galleyCount + "/" + wantedGalleons);
}

//==============================================================================
// barbaryStatesBerberManager
//==============================================================================
rule barbaryStatesBerberManager
inactive
minInterval 60
{
   
   int berberNomadCount = kbUnitCount(cMyID, cUnitTypedeNatNomad, cUnitStateAlive);
   int berberCamelCount = kbUnitCount(cMyID, cUnitTypedeNatCamelRider, cUnitStateAlive);
   
   debugMilitary("Barbary States Berbers: Nomads=" + berberNomadCount + 
                 ", Camel Riders=" + berberCamelCount);
   
   if ((berberNomadCount > 0) && (gDhimmaSent == false))
   {
      debugMilitary("Barbary States: Using Berber Nomads for economy support");
   }
}

//==============================================================================
// barbaryStatesDhimmaManager
//==============================================================================
rule barbaryStatesDhimmaManager
inactive
minInterval 45
{
   
   if (gDhimmaSent == false)
   {
      if (kbTechGetStatus(cTechDEHCREVDhimma) == cTechStatusActive)
      {
         gDhimmaSent = true;
         debugMilitary("Barbary States: Dhimma card detected - Settlers re-enabled!");
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
      
      debugMilitary("Barbary States Dhimma: Settlers=" + currentSettlers + "/" + wantedSettlers);
   }
}

//==============================================================================
// barbaryStatesCardManager
//==============================================================================
rule barbaryStatesCardManager
inactive
minInterval 90
{
   float currentFood = kbResourceGet(cResourceFood);
   float currentWood = kbResourceGet(cResourceWood);
   float currentCoin = kbResourceGet(cResourceGold);
   
   int currentMilitary = aiGetMilitaryPop();
   int gameTime = xsGetTime();
   
   debugMilitary("Barbary States Card Manager: Evaluating card priorities");
   
   if ((gCorsairCaptainSent == false) && 
       (kbTechGetStatus(cTechDEHCREVCorsairCaptain) == cTechStatusActive))
   {
      gCorsairCaptainSent = true;
      debugMilitary("Barbary States: Corsair Captain sent - treasure/crate abilities enabled");
   }
   
   if ((gLoyalWarriorsSent == false) && 
       (kbTechGetStatus(cTechDEHCREVLoyalWarriors) == cTechStatusActive))
   {
      gLoyalWarriorsSent = true;
      debugMilitary("Barbary States: Loyal Warriors sent - 15% cost reduction active");
   }
}

//==============================================================================
// barbaryStatesCardEffectTracker
//==============================================================================
rule barbaryStatesCardEffectTracker
inactive
minInterval 30
{
   if ((gDhimmaSent == false) && 
       (kbTechGetStatus(cTechDEHCREVDhimma) == cTechStatusActive))
   {
      gDhimmaSent = true;
      xsEnableRule("barbaryStatesDhimmaManager");
      debugMilitary("Barbary States: Dhimma activated - Settlers can be trained!");
   }
   
   if ((gCorsairCaptainSent == false) && 
       (kbTechGetStatus(cTechDEHCREVCorsairCaptain) == cTechStatusActive))
   {
      gCorsairCaptainSent = true;
      debugMilitary("Barbary States: Corsair Captain activated!");
   }
   
   if ((gLoyalWarriorsSent == false) && 
       (kbTechGetStatus(cTechDEHCREVLoyalWarriors) == cTechStatusActive))
   {
      gLoyalWarriorsSent = true;
      debugMilitary("Barbary States: Loyal Warriors activated - reduced merc/native costs!");
   }
}

//==============================================================================
// barbaryStatesTreasureManager
//==============================================================================
rule barbaryStatesTreasureManager
inactive
minInterval 60
{
   
   if (gCorsairCaptainSent == false)
   {
   }
   
   int heroCount = kbUnitCount(cMyID, cUnitTypeHero, cUnitStateAlive);
   
   if (heroCount > 0)
   {
      debugMilitary("Barbary States: Have " + heroCount + " heroes for treasure hunting");
      if (gCorsairCaptainSent == true)
      {
         debugMilitary("Barbary States: Corsair Captain bonus active - 2x treasure value!");
      }
   }
}
