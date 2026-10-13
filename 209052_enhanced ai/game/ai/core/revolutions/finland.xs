extern bool gFinlandNorthernWildernessSent = false;
extern bool gFinlandGrandDuchySent = false;
extern bool gFinlandArmfeltsAutonomySent = false;
extern bool gFinlandBlockhouseCannonSent = false;

extern int gFinlandKarelianJaegerMaintain = -1;
extern int gFinlandHakkapelitMaintain = -1;
extern int gFinlandCounterDragoonMaintain = -1;
extern int gFinlandCaroleanMaintain = -1;

//==============================================================================
// finlandRevolutionManager
//==============================================================================
rule finlandRevolutionManager
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
   int wantedKarelianJaegers = 0;
   int wantedHakkapelits = 0;
   int wantedCounterDragoons = 0;
   int wantedHeavyInfantry = 0;
   
   if (totalEnemyUnits > 5)
   {
      if (enemyHeavyInfCount > enemyLightInfCount + enemyCavalryCount)
      {
         wantedKarelianJaegers = militaryPop * 0.45;
         wantedHakkapelits = (militaryPop * 0.20) / 2;
         wantedCounterDragoons = (militaryPop * 0.20) / 2;
         wantedHeavyInfantry = militaryPop * 0.15;
      }
      else if (enemyCavalryCount > 10)
      {
         wantedKarelianJaegers = militaryPop * 0.30;
         wantedHakkapelits = (militaryPop * 0.20) / 2;
         wantedCounterDragoons = (militaryPop * 0.30) / 2;
         wantedHeavyInfantry = militaryPop * 0.20;
      }
      else if (enemyArtilleryCount > 5)
      {
         wantedKarelianJaegers = militaryPop * 0.25;
         wantedHakkapelits = (militaryPop * 0.35) / 2;
         wantedCounterDragoons = (militaryPop * 0.25) / 2;
         wantedHeavyInfantry = militaryPop * 0.15;
      }
      else
      {
         wantedKarelianJaegers = militaryPop * 0.35;
         wantedHakkapelits = (militaryPop * 0.25) / 2;
         wantedCounterDragoons = (militaryPop * 0.20) / 2;
         wantedHeavyInfantry = militaryPop * 0.20;
      }
   }
   else
   {
      wantedKarelianJaegers = militaryPop * 0.40;
      wantedHakkapelits = (militaryPop * 0.25) / 2;
      wantedCounterDragoons = (militaryPop * 0.20) / 2;
      wantedHeavyInfantry = militaryPop * 0.15;
   }
   
   int karelianJaegerBL = kbGetBuildLimit(cMyID, cUnitTypeSkirmisher);
   int hakkapelitBL = kbGetBuildLimit(cMyID, cUnitTypedeFinnishRider);
   int counterDragoonBL = kbGetBuildLimit(cMyID, cUnitTypedeCounterDragoon);
   
   int heavyInfantryType = cUnitTypedeCarolean;
   if (cMyCiv == cCivRussians)
   {
      heavyInfantryType = cUnitTypedeRussianMusketeer;
   }
   int heavyInfantryBL = kbGetBuildLimit(cMyID, heavyInfantryType);
   
   if (wantedKarelianJaegers > 99)
   {
      wantedKarelianJaegers = 99;
   }
   if ((karelianJaegerBL > 0) && (wantedKarelianJaegers > karelianJaegerBL))
   {
      wantedKarelianJaegers = karelianJaegerBL;
   }
   if ((hakkapelitBL > 0) && (wantedHakkapelits > hakkapelitBL))
   {
      wantedHakkapelits = hakkapelitBL;
   }
   if ((counterDragoonBL > 0) && (wantedCounterDragoons > counterDragoonBL))
   {
      wantedCounterDragoons = counterDragoonBL;
   }
   if ((heavyInfantryBL > 0) && (wantedHeavyInfantry > heavyInfantryBL))
   {
      wantedHeavyInfantry = heavyInfantryBL;
   }
   
   if (wantedKarelianJaegers < 20)
   {
      wantedKarelianJaegers = 20;
   }
   if (wantedHakkapelits < 5)
   {
      wantedHakkapelits = 5;
   }
   if (wantedCounterDragoons < 5)
   {
      wantedCounterDragoons = 5;
   }
   if (wantedHeavyInfantry < 5)
   {
      wantedHeavyInfantry = 5;
   }
   
   if (kbProtoUnitAvailable(cUnitTypeSkirmisher) == true && gFinlandKarelianJaegerMaintain == -1)
   {
      gFinlandKarelianJaegerMaintain = createSimpleMaintainPlan(cUnitTypeSkirmisher, wantedKarelianJaegers, false, mainBaseID, 1);
      aiPlanSetDesiredPriority(gFinlandKarelianJaegerMaintain, 80);
      aiPlanSetActive(gFinlandKarelianJaegerMaintain, true);
      debugMilitary("Finland: Created Karelian Jaeger maintain plan");
   }
   else if (gFinlandKarelianJaegerMaintain >= 0)
   {
      aiPlanSetVariableInt(gFinlandKarelianJaegerMaintain, cTrainPlanNumberToMaintain, 0, wantedKarelianJaegers);
   }
   
   if (kbProtoUnitAvailable(cUnitTypedeFinnishRider) == true && gFinlandHakkapelitMaintain == -1)
   {
      gFinlandHakkapelitMaintain = createSimpleMaintainPlan(cUnitTypedeFinnishRider, wantedHakkapelits, false, mainBaseID, 1);
      aiPlanSetDesiredPriority(gFinlandHakkapelitMaintain, 70);
      aiPlanSetActive(gFinlandHakkapelitMaintain, true);
      debugMilitary("Finland: Created Hakkapelit maintain plan");
   }
   else if (gFinlandHakkapelitMaintain >= 0)
   {
      aiPlanSetVariableInt(gFinlandHakkapelitMaintain, cTrainPlanNumberToMaintain, 0, wantedHakkapelits);
   }
   
   if (gFinlandGrandDuchySent == true)
   {
      if (kbProtoUnitAvailable(cUnitTypedeCounterDragoon) == true && gFinlandCounterDragoonMaintain == -1)
      {
         gFinlandCounterDragoonMaintain = createSimpleMaintainPlan(cUnitTypedeCounterDragoon, wantedCounterDragoons, false, mainBaseID, 1);
         aiPlanSetDesiredPriority(gFinlandCounterDragoonMaintain, 65);
         aiPlanSetActive(gFinlandCounterDragoonMaintain, true);
         debugMilitary("Finland: Created Counter Dragoon maintain plan");
      }
      else if (gFinlandCounterDragoonMaintain >= 0)
      {
         aiPlanSetVariableInt(gFinlandCounterDragoonMaintain, cTrainPlanNumberToMaintain, 0, wantedCounterDragoons);
      }
   }
   
   if (kbProtoUnitAvailable(heavyInfantryType) == true && gFinlandCaroleanMaintain == -1)
   {
      gFinlandCaroleanMaintain = createSimpleMaintainPlan(heavyInfantryType, wantedHeavyInfantry, false, mainBaseID, 1);
      aiPlanSetDesiredPriority(gFinlandCaroleanMaintain, 60);
      aiPlanSetActive(gFinlandCaroleanMaintain, true);
      if (cMyCiv == cCivRussians)
      {
         debugMilitary("Finland: Created Rekrut maintain plan");
      }
      else
      {
         debugMilitary("Finland: Created Carolean maintain plan");
      }
   }
   else if (gFinlandCaroleanMaintain >= 0)
   {
      aiPlanSetVariableInt(gFinlandCaroleanMaintain, cTrainPlanNumberToMaintain, 0, wantedHeavyInfantry);
   }
   
   debugMilitary("Finland army composition: Karelian Jaegers=" + wantedKarelianJaegers + 
                 ", Hakkapelits=" + wantedHakkapelits +
                 ", Counter Dragoons=" + wantedCounterDragoons +
                 ", Heavy Infantry=" + wantedHeavyInfantry);
}

//==============================================================================
// finlandEconomyManager
//==============================================================================
rule finlandEconomyManager
inactive
minInterval 45
{
   
   float currentFood = kbResourceGet(cResourceFood);
   float currentWood = kbResourceGet(cResourceWood);
   float currentCoin = kbResourceGet(cResourceGold);
   
   int karelianJaegerCount = kbUnitCount(cMyID, cUnitTypeSkirmisher, cUnitStateAlive);
   int torpCount = kbUnitCount(cMyID, cUnitTypedeTorp, cUnitStateAlive);
   
   debugMilitary("Finland Economy: Karelian Jaegers=" + karelianJaegerCount + 
                 ", Torps=" + torpCount +
                 ", Resources: F=" + currentFood + " W=" + currentWood + " C=" + currentCoin);
   
   if (currentWood < 500)
   {
      debugMilitary("Finland Economy: LOW WOOD - critical for Karelian Jaeger production");
   }
   
   if (gFinlandNorthernWildernessSent == false)
   {
      debugMilitary("Finland Economy: Northern Wilderness not sent - limited gathering!");
   }
}

//==============================================================================
// finlandTorpManager
//==============================================================================
rule finlandTorpManager
inactive
minInterval 60
{
   
   int torpCount = kbUnitCount(cMyID, cUnitTypedeTorp, cUnitStateAlive);
   int torpBL = kbGetBuildLimit(cMyID, cUnitTypedeTorp);
   
   debugMilitary("Finland Torps: " + torpCount + "/" + torpBL);
   
}

//==============================================================================
// finlandBlockhouseManager
//==============================================================================
rule finlandBlockhouseManager
inactive
minInterval 60
{
   
   int blockhouseCount = kbUnitCount(cMyID, cUnitTypeBlockhouse, cUnitStateAlive);
   
   debugMilitary("Finland Blockhouses: " + blockhouseCount + " (no limit)");
   
   if (gFinlandBlockhouseCannonSent == true)
   {
      debugMilitary("Finland Blockhouses: Artillery attack enabled!");
   }
   
}

//==============================================================================
// finlandCardEffectTracker
//==============================================================================
rule finlandCardEffectTracker
inactive
minInterval 30
{
   if ((gFinlandNorthernWildernessSent == false) && 
       (kbTechGetStatus(cTechDEHCREVNothernWilderness) == cTechStatusActive))
   {
      gFinlandNorthernWildernessSent = true;
      debugMilitary("Finland: Northern Wilderness activated - Karelian Jaegers can gather all resources!");
   }
   
   if ((gFinlandArmfeltsAutonomySent == false) && 
       (kbTechGetStatus(cTechDEHCREVArmfeltsAutonomy) == cTechStatusActive))
   {
      gFinlandArmfeltsAutonomySent = true;
      debugMilitary("Finland: Armfelt's Autonomy activated - Counter Dragoons upgraded to Imperial!");
   }
   
   if ((gFinlandBlockhouseCannonSent == false) && 
       (kbTechGetStatus(cTechDEHCREVBlockhouseCannon) == cTechStatusActive))
   {
      gFinlandBlockhouseCannonSent = true;
      debugMilitary("Finland: Blockhouse Cannon activated - Blockhouses have artillery attack!");
   }
}

//==============================================================================
// finlandCardManager
//==============================================================================
rule finlandCardManager
inactive
minInterval 90
{
   float currentFood = kbResourceGet(cResourceFood);
   float currentWood = kbResourceGet(cResourceWood);
   float currentCoin = kbResourceGet(cResourceGold);
   
   int currentMilitary = aiGetMilitaryPop();
   int gameTime = xsGetTime();
   
   debugMilitary("Finland Card Manager: Evaluating card priorities");
}

//==============================================================================
// finlandNorthernWildernessManager
//==============================================================================
rule finlandNorthernWildernessManager
inactive
minInterval 45
{
   if (gFinlandNorthernWildernessSent == false)
   {
      if (kbTechGetStatus(cTechDEHCREVNothernWilderness) == cTechStatusActive)
      {
         gFinlandNorthernWildernessSent = true;
         debugMilitary("Finland: Northern Wilderness activated!");
      }
      else
      {
         return;
      }
   }
   
   int karelianJaegerCount = kbUnitCount(cMyID, cUnitTypeSkirmisher, cUnitStateAlive);
   
   debugMilitary("Finland Northern Wilderness: " + karelianJaegerCount + " Karelian Jaegers can gather all resources");
   
}

//==============================================================================
// finlandHakkapelitManager
//==============================================================================
rule finlandHakkapelitManager
inactive
minInterval 60
{
   
   int hakkapelitCount = kbUnitCount(cMyID, cUnitTypedeFinnishRider, cUnitStateAlive);
   
   debugMilitary("Finland Hakkapelits: " + hakkapelitCount);
   
}

//==============================================================================
// finlandResourceCardManager
//==============================================================================
rule finlandResourceCardManager
inactive
minInterval 60
{
   
   int elkCount = kbUnitCount(cMyID, cUnitTypeElk, cUnitStateAlive);
   int prospectorWagonCount = kbUnitCount(cMyID, cUnitTypedeProspectorWagon, cUnitStateAlive);
   
   debugMilitary("Finland Resources: Elks=" + elkCount + ", Prospector Wagons=" + prospectorWagonCount);
   
}

//==============================================================================
// finlandAllotmentSystemManager
//==============================================================================
rule finlandAllotmentSystemManager
inactive
minInterval 60
{
   
   int caroleanCount = kbUnitCount(cMyID, cUnitTypedeCarolean, cUnitStateAlive);
   
   if (caroleanCount > 0)
   {
      debugMilitary("Finland Allotment System: Caroleans=" + caroleanCount);
   }
   
}

//==============================================================================
// finlandCounterDragoonManager
//==============================================================================
   
//==============================================================================
// finlandDualPurposeManager
//==============================================================================
rule finlandDualPurposeManager
inactive
minInterval 60
{
   
   int karelianJaegerCount = kbUnitCount(cMyID, cUnitTypeSkirmisher, cUnitStateAlive);
   int hakkapelitCount = kbUnitCount(cMyID, cUnitTypedeFinnishRider, cUnitStateAlive);
   int counterDragoonCount = kbUnitCount(cMyID, cUnitTypedeCounterDragoon, cUnitStateAlive);
   
   int totalMilitary = hakkapelitCount + counterDragoonCount;
   
   float currentFood = kbResourceGet(cResourceFood);
   float currentWood = kbResourceGet(cResourceWood);
   float currentCoin = kbResourceGet(cResourceGold);
   
   bool needGathering = (currentFood < 500) || (currentWood < 500) || (currentCoin < 500);
   bool needCombat = (totalMilitary < 10);
   
   if (needGathering && gFinlandNorthernWildernessSent)
   {
      debugMilitary("Finland Dual Purpose: Resources low - prioritize Karelian Jaeger gathering");
   }
   
   if (needCombat)
   {
      debugMilitary("Finland Dual Purpose: Military low - prioritize Karelian Jaeger combat");
   }
   
   debugMilitary("Finland Dual Purpose: " + karelianJaegerCount + " Karelian Jaegers serving dual role");
}
//==============================================================================
// finlandSlaughterMonitor
//==============================================================================
rule finlandSlaughterMonitor
inactive
minInterval 30
{
   static int slaughterPlanID = -1;
   int numLivestock = -1;
   int gatherersWanted = -1;
   vector mainBaseVec = cInvalidVector;

   if (kbTechGetStatus(cTechDEHCREVNothernWilderness) != cTechStatusActive)
   {
      return;
   }
   
   if (kbBaseGetMainID(cMyID) < 0)
   {
      return;
   }
   mainBaseVec = kbBaseGetLocation(cMyID, kbBaseGetMainID(cMyID));
   numLivestock = getUnitCountByLocation(cUnitTypeHerdable, cPlayerRelationAny, cUnitStateAny, mainBaseVec, 60.0);
   
   if (numLivestock <= 0)
   {
      gatherersWanted = 0;
   }
   else
   {
      gatherersWanted = 2;
   }
   
   if (slaughterPlanID < 0)
   {
      slaughterPlanID = aiPlanCreate("Finland Livestock Slaughter", cPlanGather);
      aiPlanSetBaseID(slaughterPlanID, kbBaseGetMainID(cMyID));
      aiPlanSetVariableInt(slaughterPlanID, cGatherPlanResourceUnitTypeFilter, 0, cUnitTypeHerdable);
      aiPlanSetVariableInt(slaughterPlanID, cGatherPlanResourceType, 0, cAllResources);
      aiPlanAddUnitType(slaughterPlanID, cUnitTypeSkirmisher, gatherersWanted, gatherersWanted, 2 * gatherersWanted);
      aiPlanSetDesiredPriority(slaughterPlanID, 70);
      aiPlanSetActive(slaughterPlanID);
      debugEconomy("Finland: Activated livestock slaughter plan " + slaughterPlanID);
   }
   else
   {
      aiPlanAddUnitType(slaughterPlanID, cUnitTypeSkirmisher, gatherersWanted, gatherersWanted, 2 * gatherersWanted);
   }
   
   if (numLivestock > 7)
   {
      aiPlanSetDesiredPriority(slaughterPlanID, 100);
   }
   else if (numLivestock <= 2)
   {
      aiPlanSetDesiredPriority(slaughterPlanID, 30);
   }
   
   if (aiPlanGetState(slaughterPlanID) == -1)
   {
      debugEconomy("Finland: Livestock gather plan " + slaughterPlanID + " is invalid");
      aiPlanDestroy(slaughterPlanID);
      slaughterPlanID = -1;
   }
}
//==============================================================================
// createSimpleBuildPlanFinland
//==============================================================================
int createSimpleBuildPlanFinland(int buildingType = -1, int numberToBuild = 1, int pri = 50, 
   bool economy = true, int escrowID = -1, int baseID = -1, int numBuilders = 1)
{
   if (buildingType < 0)
   {
      return(-1);
   }
   
   int buildLimit = kbGetBuildLimit(cMyID, buildingType);
   int currentCount = kbUnitCount(cMyID, buildingType, cUnitStateABQ);
   
   if (currentCount >= buildLimit)
   {
      debugBuildings("Finland: Build limit reached for " + kbGetProtoUnitName(buildingType) + 
         " (" + currentCount + "/" + buildLimit + ")");
      return(-1);
   }
   
   int jaegerQuery = createSimpleUnitQuery(cUnitTypeSkirmisher, cMyID, cUnitStateAlive);
   int numberJaegersFound = kbUnitQueryExecute(jaegerQuery);
   aiEcho("Jaegers: "+numberJaegersFound+"");
   
   if (numberJaegersFound < 1)
   {
      debugBuildings("Finland: No Karelian Jaegers available to build " + kbGetProtoUnitName(buildingType));
      return(-1);
   }
   
   int jaegerID = -1;
   int jaegerPlanID = -1;
   int unitID = -1;
   int buildersFound = 0;
   int buildersArray = xsArrayCreateInt(numBuilders, -1, "Finland builders array");
   
   for (i = 0; < numberJaegersFound)
   {
      unitID = kbUnitQueryGetResult(jaegerQuery, i);
      if (unitID < 0)
      {
         continue;
      }
      
      jaegerPlanID = kbUnitGetPlanID(unitID);
      if (jaegerPlanID < 0 || aiPlanGetDesiredPriority(jaegerPlanID) < pri)
      {
         xsArraySetInt(buildersArray, buildersFound, unitID);
         buildersFound++;
         if (buildersFound >= numBuilders)
         {
            break;
         }
      }
   }
   
   if (buildersFound < 1)
   {
      xsArraySetInt(buildersArray, 0, kbUnitQueryGetResult(jaegerQuery, 0));
      buildersFound = 1;
   }
   
   int planID = aiPlanCreate("Finland Build " + kbGetProtoUnitName(buildingType), cPlanBuild);
   
   if (planID < 0)
   {
      debugBuildings("Finland: Failed to create build plan for " + kbGetProtoUnitName(buildingType));
      return(-1);
   }
   
   aiPlanSetVariableInt(planID, cBuildPlanBuildingTypeID, 0, buildingType);
   
   aiPlanSetDesiredPriority(planID, pri);
   aiPlanSetDesiredResourcePriority(planID, pri);
   
   if (economy == true)
   {
      aiPlanSetMilitary(planID, false);
      aiPlanSetEconomy(planID, true);
   }
   else
   {
      aiPlanSetMilitary(planID, true);
      aiPlanSetEconomy(planID, false);
   }
   
   if (escrowID >= 0)
   {
      aiPlanSetEscrowID(planID, escrowID);
   }
   
   if (baseID >= 0)
   {
      aiPlanSetBaseID(planID, baseID);
   }
   
   aiPlanAddUnitType(planID, cUnitTypeSkirmisher, buildersFound, buildersFound, numBuilders);
   
   for (i = 0; < buildersFound)
   {
      int builderID = xsArrayGetInt(buildersArray, i);
      if (builderID >= 0)
      {
         aiPlanAddUnit(planID, builderID);
         debugBuildings("Finland: Adding Karelian Jaeger ID " + builderID + " to build plan");
      }
   }
   
   aiPlanSetActive(planID, true);
   
   debugBuildings("Finland: Created build plan for " + kbGetProtoUnitName(buildingType) + 
      ", plan ID " + planID + ", builders: " + buildersFound);
   
   return(planID);
}
//==============================================================================
// finlandTorpBuildMonitor
//==============================================================================
rule finlandTorpBuildMonitor
inactive
minInterval 20
{
   int mainBaseID = kbBaseGetMainID(cMyID);
   if (mainBaseID < 0)
   {
      return;
   }
   
   int torpCount = kbUnitCount(cMyID, cUnitTypedeTorp, cUnitStateAlive);
   int torpBuilding = kbUnitCount(cMyID, cUnitTypedeTorp, cUnitStateBuilding);
   int torpBuildLimit = kbGetBuildLimit(cMyID, cUnitTypedeTorp);
   
   if (torpCount + torpBuilding >= torpBuildLimit)
   {
      debugEconomy("Finland: Torp limit reached (" + torpCount + "/" + torpBuildLimit + ")");
      return;
   }
   
   float currentWood = kbResourceGet(cResourceWood);
   if (currentWood < 125)
   {
      return;
   }

   int buildPlanID = createSimpleBuildPlanFinland(cUnitTypedeTorp, 1, 100, true, cEconomyEscrowID, mainBaseID, 1);
   
   if (buildPlanID >= 0)
   {
      aiPlanAddUnitType(buildPlanID, cUnitTypeSkirmisher, 1, 1, 2);
      debugEconomy("Finland: Created Torp build plan, current count " + torpCount + "/" + torpBuildLimit);
   }
}

//==============================================================================
// finlandTorpWagonMonitor
//==============================================================================
rule finlandTorpWagonMonitor
inactive
minInterval 30
{
   int mainBaseID = kbBaseGetMainID(cMyID);
   if (mainBaseID < 0)
   {
      return;
   }
   
   int torpWagonCount = kbUnitCount(cMyID, cUnitTypedeTorpWagon, cUnitStateAlive);
   
   if (torpWagonCount <= 0)
   {
      return;
   }
   
   if (aiPlanGetIDByTypeAndVariableType(cPlanBuild, cBuildPlanBuildingTypeID, cUnitTypedeTorp, true) >= 0)
   {
      return;
   }
   
   int buildPlanID = aiPlanCreate("Finland Torp Wagon Build", cPlanBuild);
   if (buildPlanID >= 0)
   {
      aiPlanSetVariableInt(buildPlanID, cBuildPlanBuildingTypeID, 0, cUnitTypedeTorp);
      aiPlanSetBaseID(buildPlanID, mainBaseID);
      aiPlanSetEscrowID(buildPlanID, cEconomyEscrowID);
      aiPlanAddUnitType(buildPlanID, cUnitTypedeTorpWagon, 1, 1, 1);
      aiPlanSetDesiredPriority(buildPlanID, 80);
      aiPlanSetActive(buildPlanID, true);
      debugEconomy("Finland: Created Torp Wagon build plan, wagons available: " + torpWagonCount);
   }
}
//==============================================================================
// selectFinlandBlockhouseBuildPlanPosition
//==============================================================================
void selectFinlandBlockhouseBuildPlanPosition(int buildPlan = -1, int baseID = -1)
{
   int blockhouseBL = kbGetBuildLimit(cMyID, cUnitTypeBlockhouse);
   if (blockhouseBL <= 0)
   {
      blockhouseBL = 10;
   }
   
   int numAttempts = 3 * blockhouseBL / 2;
   vector testVec = cInvalidVector;
   static vector baseVec = cInvalidVector;
   static vector startingVec = cInvalidVector;
   int numTestVecs = 5 * blockhouseBL / 4;
   float blockhouseAngle = (2.0 * PI) / numTestVecs;
   float spacingDistance = 30 * sin((PI - blockhouseAngle) / 2.0) / sin(blockhouseAngle);
   float exclusionRadius = spacingDistance / 2.0;

   static int blockhouseSearch = -1;
   bool success = false;

   if ((startingVec == cInvalidVector) || (baseVec != kbBaseGetLocation(cMyID, baseID)))
   {
      baseVec = kbBaseGetLocation(cMyID, baseID);
      startingVec = baseVec;
      startingVec = xsVectorSetX(startingVec, xsVectorGetX(startingVec) + spacingDistance);
      startingVec = rotateByReferencePoint(baseVec, startingVec - baseVec, aiRandInt(360) / (180.0 / PI));
   }

   for (attempt = 0; < numAttempts)
   {
      testVec = rotateByReferencePoint(baseVec, startingVec - baseVec, blockhouseAngle * aiRandInt(numTestVecs));
      debugBuildings("Finland: Testing Blockhouse location at: " + testVec);
      
      if (blockhouseSearch < 0)
      {
         blockhouseSearch = kbUnitQueryCreate("Blockhouse placement search");
         kbUnitQuerySetPlayerRelation(blockhouseSearch, cPlayerRelationAny);
         kbUnitQuerySetUnitType(blockhouseSearch, cUnitTypeBlockhouse);
         kbUnitQuerySetState(blockhouseSearch, cUnitStateABQ);
      }
      
      kbUnitQuerySetPosition(blockhouseSearch, testVec);
      kbUnitQuerySetMaximumDistance(blockhouseSearch, exclusionRadius);
      kbUnitQueryResetResults(blockhouseSearch);
      
      if (kbUnitQueryExecute(blockhouseSearch) < 1)
      {
         if (kbAreaGroupGetIDByPosition(testVec) == kbAreaGroupGetIDByPosition(kbBaseGetLocation(cMyID, baseID)))
         {
            success = true;
            break;
         }
      }
   }

   if (success == false)
   {
      testVec = kbBaseGetLocation(cMyID, baseID);
   }

   int torpQuery = createSimpleUnitQuery(cUnitTypedeTorp, cMyID, cUnitStateAlive);
   int torpsFound = kbUnitQueryExecute(torpQuery);

   if (torpsFound > 0)
   {
      for (i = 0; < torpsFound)
      {
         vector torpPos = kbUnitGetPosition(kbUnitQueryGetResult(torpQuery, i));
         int nearbyBlockhouseQuery = createSimpleUnitQuery(cUnitTypeBlockhouse, cMyID, cUnitStateABQ);
         kbUnitQuerySetPosition(nearbyBlockhouseQuery, torpPos);
         kbUnitQuerySetMaximumDistance(nearbyBlockhouseQuery, 20.0);
         int nearbyBlockhouses = kbUnitQueryExecute(nearbyBlockhouseQuery);

         if (nearbyBlockhouses <= 0)
         {
            vector direction = torpPos - baseVec;
            float length = xsVectorLength(direction) - 8.0;
            if (length < 0)
            {
               length = 0;
            }
            direction = xsVectorNormalize(direction);
            testVec = baseVec + direction * length;
            exclusionRadius = 12.0;
            success = true;
            break;
         }
      }
   }

   aiPlanSetVariableVector(buildPlan, cBuildPlanCenterPosition, 0, testVec);
   if (success == true)
   {
      aiPlanSetVariableFloat(buildPlan, cBuildPlanCenterPositionDistance, 0, exclusionRadius);
   }
   else
   {
      aiPlanSetVariableFloat(buildPlan, cBuildPlanCenterPositionDistance, 0, 50.0);
   }

   aiPlanSetVariableInt(buildPlan, cBuildPlanInfluenceUnitTypeID, 0, cUnitTypeBlockhouse);
   aiPlanSetVariableFloat(buildPlan, cBuildPlanInfluenceUnitDistance, 0, spacingDistance);
   aiPlanSetVariableFloat(buildPlan, cBuildPlanInfluenceUnitValue, 0, -20.0);
   aiPlanSetVariableInt(buildPlan, cBuildPlanInfluenceUnitFalloff, 0, cBPIFalloffLinear);

   aiPlanSetVariableVector(buildPlan, cBuildPlanInfluencePosition, 0, testVec);
   aiPlanSetVariableFloat(buildPlan, cBuildPlanInfluencePositionDistance, 0, exclusionRadius);
   aiPlanSetVariableFloat(buildPlan, cBuildPlanInfluencePositionValue, 0, 10.0);
   aiPlanSetVariableInt(buildPlan, cBuildPlanInfluencePositionFalloff, 0, cBPIFalloffLinear);

   debugBuildings("Finland: Building a Blockhouse at location: " + testVec);
}

//==============================================================================
// finlandBuildingMonitor
//==============================================================================
rule finlandBuildingMonitor
inactive
minInterval 30
{
   int mainBaseID = kbBaseGetMainID(cMyID);
   if (mainBaseID < 0)
   {
      return;
   }
   
   float currentWood = kbResourceGet(cResourceWood);
   
   int blockhouseCount = kbUnitCount(cMyID, cUnitTypeBlockhouse, cUnitStateAlive);
   int blockhouseBuilding = kbUnitCount(cMyID, cUnitTypeBlockhouse, cUnitStateBuilding);
   int blockhouseBuildLimit = kbGetBuildLimit(cMyID, cUnitTypeBlockhouse);
   int desiredBlockhouses = blockhouseBuildLimit;
   
   if (blockhouseBuildLimit <= 0)
   {
      desiredBlockhouses = 10;
   }
   
   static int blockhouseBuildPlan = -1;
   
   if (blockhouseCount + blockhouseBuilding < desiredBlockhouses && currentWood >= 250)
   {
      if (blockhouseBuildPlan >= 0)
      {
         if (aiPlanGetState(blockhouseBuildPlan) == -1)
         {
            aiPlanDestroy(blockhouseBuildPlan);
            blockhouseBuildPlan = -1;
         }
         else
         {
         }
      }
      
      if (blockhouseBuildPlan < 0)
      {
         int jaegerQuery = createSimpleUnitQuery(cUnitTypeSkirmisher, cMyID, cUnitStateAlive);
         int numberJaegers = kbUnitQueryExecute(jaegerQuery);
         
         if (numberJaegers >= 1)
         {
            int builderID = kbUnitQueryGetResult(jaegerQuery, 0);
            
            blockhouseBuildPlan = aiPlanCreate("Finland Blockhouse Build", cPlanBuild);
            
            if (blockhouseBuildPlan >= 0)
            {
               aiPlanSetVariableInt(blockhouseBuildPlan, cBuildPlanBuildingTypeID, 0, cUnitTypeBlockhouse);
               
               aiPlanSetDesiredPriority(blockhouseBuildPlan, 100);
               aiPlanSetDesiredResourcePriority(blockhouseBuildPlan, 100);
               
               aiPlanSetMilitary(blockhouseBuildPlan, true);
               aiPlanSetEconomy(blockhouseBuildPlan, false);
               
               aiPlanSetEscrowID(blockhouseBuildPlan, cMilitaryEscrowID);
               
               aiPlanSetBaseID(blockhouseBuildPlan, mainBaseID);
               
               aiPlanAddUnitType(blockhouseBuildPlan, cUnitTypeSkirmisher, 1, 1, 1);
               aiPlanAddUnit(blockhouseBuildPlan, builderID);
               aiPlanSetNoMoreUnits(blockhouseBuildPlan, true);
               
               selectFinlandBlockhouseBuildPlanPosition(blockhouseBuildPlan, mainBaseID);
               
               aiPlanSetActive(blockhouseBuildPlan, true);
               
               debugBuildings("Finland: Created Blockhouse build plan (" + blockhouseCount + "/" + desiredBlockhouses + ")");
            }
         }
      }
   }
   else
   {
      if (blockhouseBuildPlan >= 0)
      {
         aiPlanDestroy(blockhouseBuildPlan);
         blockhouseBuildPlan = -1;
      }
   }
   
   int outpostCount = kbUnitCount(cMyID, cUnitTypeOutpost, cUnitStateABQ);
   int outpostBuildLimit = kbGetBuildLimit(cMyID, cUnitTypeOutpost);
   int desiredOutposts = outpostBuildLimit;
   
   if (outpostBuildLimit > 0 && desiredOutposts > outpostBuildLimit)
   {
      desiredOutposts = outpostBuildLimit;
   }
   
   if (outpostCount < desiredOutposts && currentWood >= 250)
   {
      if (aiPlanGetIDByTypeAndVariableType(cPlanBuild, cBuildPlanBuildingTypeID, cUnitTypeOutpost, true) < 0)
      {
         createSimpleBuildPlanFinland(cUnitTypeOutpost, 1, 100, false, cMilitaryEscrowID, mainBaseID, 2);
         debugBuildings("Finland: Building Outpost (" + outpostCount + "/" + desiredOutposts + ")");
      }
   }
   
   int stablesCount = kbUnitCount(cMyID, cUnitTypeStable, cUnitStateABQ);
   int stablesBuildLimit = kbGetBuildLimit(cMyID, cUnitTypeStable);
   int desiredStables = 2;
   
   if (stablesBuildLimit > 0 && desiredStables > stablesBuildLimit)
   {
      desiredStables = stablesBuildLimit;
   }
   
   if (stablesCount < desiredStables && currentWood >= 200)
   {
      if (aiPlanGetIDByTypeAndVariableType(cPlanBuild, cBuildPlanBuildingTypeID, cUnitTypeStable, true) < 0)
      {
         createSimpleBuildPlanFinland(cUnitTypeStable, 1, 100, false, cMilitaryEscrowID, mainBaseID, 2);
         debugBuildings("Finland: Building Stable (" + stablesCount + "/" + desiredStables + ")");
      }
   }
   
   int artilleryCount = kbUnitCount(cMyID, cUnitTypeArtilleryDepot, cUnitStateABQ);
   int artilleryBuildLimit = kbGetBuildLimit(cMyID, cUnitTypeArtilleryDepot);
   int desiredArtillery = 2;
   
   if (artilleryBuildLimit > 0 && desiredArtillery > artilleryBuildLimit)
   {
      desiredArtillery = artilleryBuildLimit;
   }
   
   if (artilleryCount < desiredArtillery && currentWood >= 300)
   {
      if (aiPlanGetIDByTypeAndVariableType(cPlanBuild, cBuildPlanBuildingTypeID, cUnitTypeArtilleryDepot, true) < 0)
      {
         createSimpleBuildPlanFinland(cUnitTypeArtilleryDepot, 1, 100, false, cMilitaryEscrowID, mainBaseID, 2);
         debugBuildings("Finland: Building Artillery Foundry (" + artilleryCount + "/" + desiredArtillery + ")");
      }
   }
   
   debugBuildings("Finland Buildings: Blockhouses=" + blockhouseCount + "/" + desiredBlockhouses +
      ", Outposts=" + outpostCount + "/" + desiredOutposts +
      ", Stables=" + stablesCount + "/" + desiredStables +
      ", Artillery=" + artilleryCount + "/" + desiredArtillery);
}
//==============================================================================
// finlandLivestockPenMonitor
//==============================================================================
rule finlandLivestockPenMonitor
inactive
minInterval 30
{
   if (kbTechGetStatus(cTechDEHCREVNothernWilderness) != cTechStatusActive)
   {
      return;
   }
   
   static int livestockPenBuildPlan = -1;
   
   int mainBaseID = kbBaseGetMainID(cMyID);
   if (mainBaseID < 0)
   {
      return;
   }
   
   int sheepLimit = kbGetBuildLimit(cMyID, cUnitTypeSheep);
   int cowLimit = kbGetBuildLimit(cMyID, cUnitTypeCow);
   
   int herdablePriority = 55;
   
   static int sheepMaintain = -1;
   static int cowMaintain = -1;
   
   int livestockPenCount = kbUnitCount(cMyID, gLivestockPenUnit, cUnitStateAlive);
   int livestockPenBuilding = kbUnitCount(cMyID, gLivestockPenUnit, cUnitStateBuilding);
   int livestockPenBuildLimit = kbGetBuildLimit(cMyID, gLivestockPenUnit);
   int desiredLivestockPens = 2;
   
   if (livestockPenBuildLimit > 0 && desiredLivestockPens > livestockPenBuildLimit)
   {
      desiredLivestockPens = livestockPenBuildLimit;
   }
   
   if (livestockPenCount > 0)
   {
      if (sheepLimit > 0)
      {
         if (sheepMaintain < 0)
         {
            sheepMaintain = createSimpleMaintainPlan(cUnitTypeSheep, sheepLimit, 
               true, mainBaseID, 1);
            aiPlanSetVariableInt(sheepMaintain, cTrainPlanNumberToMaintain, 0, sheepLimit);
            aiPlanSetActive(sheepMaintain);
         }
         aiPlanSetDesiredPriority(sheepMaintain, herdablePriority);
      }
      
      if (cowLimit > 0)
      {
         if (cowMaintain < 0)
         {
            cowMaintain = createSimpleMaintainPlan(cUnitTypeCow, cowLimit, 
               true, mainBaseID, 1);
            aiPlanSetVariableInt(cowMaintain, cTrainPlanNumberToMaintain, 0, cowLimit);
            aiPlanSetActive(cowMaintain);
         }
         aiPlanSetDesiredPriority(cowMaintain, herdablePriority);
      }
   }
   else
   {    
      if (sheepMaintain >= 0)
      {
         aiPlanDestroy(sheepMaintain);
         sheepMaintain = -1;
      }
      if (cowMaintain >= 0)
      {
         aiPlanDestroy(cowMaintain);
         cowMaintain = -1;
      }
   }
   
   if (livestockPenCount + livestockPenBuilding >= desiredLivestockPens)
   {
      if (livestockPenBuildPlan >= 0)
      {
         aiPlanDestroy(livestockPenBuildPlan);
         livestockPenBuildPlan = -1;
      }
      debugBuildings("Finland: Livestock Pen limit reached (" + livestockPenCount + "/" + desiredLivestockPens + ")");
      return;
   }
   
   if (livestockPenBuildPlan >= 0)
   {
      if (aiPlanGetState(livestockPenBuildPlan) == -1)
      {
         aiPlanDestroy(livestockPenBuildPlan);
         livestockPenBuildPlan = -1;
      }
      else
      {
         return;
      }
   }
   
   int jaegerQuery = createSimpleUnitQuery(cUnitTypeSkirmisher, cMyID, cUnitStateAlive);
   int numberJaegers = kbUnitQueryExecute(jaegerQuery);
   
   if (numberJaegers < 1)
   {
      aiEcho("Finland Livestock Pen: No Karelian Jaegers available");
      return;
   }
   
   int builderID = kbUnitQueryGetResult(jaegerQuery, 0);
   
   livestockPenBuildPlan = aiPlanCreate("Finland Livestock Pen Build", cPlanBuild);
   
   if (livestockPenBuildPlan < 0)
   {
      aiEcho("Finland Livestock Pen: Failed to create plan");
      return;
   }
   
   aiPlanSetVariableInt(livestockPenBuildPlan, cBuildPlanBuildingTypeID, 0, gLivestockPenUnit);
   
   aiPlanSetDesiredPriority(livestockPenBuildPlan, 100);
   aiPlanSetDesiredResourcePriority(livestockPenBuildPlan, 100);
   
   aiPlanSetMilitary(livestockPenBuildPlan, false);
   aiPlanSetEconomy(livestockPenBuildPlan, true);
   
   aiPlanSetEscrowID(livestockPenBuildPlan, cEconomyEscrowID);
   
   aiPlanSetBaseID(livestockPenBuildPlan, mainBaseID);
   
   aiPlanAddUnitType(livestockPenBuildPlan, cUnitTypeSkirmisher, 1, 1, 1);
   aiPlanAddUnit(livestockPenBuildPlan, builderID);
   aiPlanSetNoMoreUnits(livestockPenBuildPlan, true);
   
   vector baseLocation = kbBaseGetLocation(cMyID, mainBaseID);
   aiPlanSetVariableVector(livestockPenBuildPlan, cBuildPlanCenterPosition, 0, baseLocation);
   aiPlanSetVariableFloat(livestockPenBuildPlan, cBuildPlanCenterPositionDistance, 0, 50.0);
   
   aiPlanSetVariableFloat(livestockPenBuildPlan, cBuildPlanBuildingBufferSpace, 0, 8.0);
   aiPlanSetVariableInt(livestockPenBuildPlan, cBuildPlanInfluenceUnitTypeID, 0, gLivestockPenUnit);
   aiPlanSetVariableFloat(livestockPenBuildPlan, cBuildPlanInfluenceUnitDistance, 0, 20.0);
   aiPlanSetVariableFloat(livestockPenBuildPlan, cBuildPlanInfluenceUnitValue, 0, -100.0);
   
   aiPlanSetActive(livestockPenBuildPlan, true);
   
   aiEcho("Finland Livestock Pen: Created build plan with Jaeger ID " + builderID);
   debugBuildings("Finland: Created Livestock Pen build plan (" + livestockPenCount + "/" + desiredLivestockPens + ")");
}
//==============================================================================
// finlandMarketMonitor
//==============================================================================
rule finlandMarketMonitor
inactive
minInterval 30
{
   static int marketBuildPlan = -1;
   
   int mainBaseID = kbBaseGetMainID(cMyID);
   if (mainBaseID < 0)
   {
      return;
   }
   
   int marketCount = kbUnitCount(cMyID, gMarketUnit, cUnitStateAlive);
   int marketBuilding = kbUnitCount(cMyID, gMarketUnit, cUnitStateBuilding);
   int marketBuildLimit = kbGetBuildLimit(cMyID, gMarketUnit);
   int desiredMarkets = 1;
   
   if (marketBuildLimit > 0 && desiredMarkets > marketBuildLimit)
   {
      desiredMarkets = marketBuildLimit;
   }
   
   if (marketCount + marketBuilding >= desiredMarkets)
   {
      if (marketBuildPlan >= 0)
      {
         aiPlanDestroy(marketBuildPlan);
         marketBuildPlan = -1;
      }
      return;
   }
   
   if (marketBuildPlan >= 0)
   {
      if (aiPlanGetState(marketBuildPlan) == -1)
      {
         aiPlanDestroy(marketBuildPlan);
         marketBuildPlan = -1;
      }
      else
      {
         return;
      }
   }
   
   int jaegerQuery = createSimpleUnitQuery(cUnitTypeSkirmisher, cMyID, cUnitStateAlive);
   int numberJaegers = kbUnitQueryExecute(jaegerQuery);
   
   if (numberJaegers < 1)
   {
      aiEcho("Finland Market: No Karelian Jaegers available");
      return;
   }
   
   int builderID = kbUnitQueryGetResult(jaegerQuery, 0);
   
   marketBuildPlan = aiPlanCreate("Finland Market Build", cPlanBuild);
   
   if (marketBuildPlan < 0)
   {
      aiEcho("Finland Market: Failed to create plan");
      return;
   }
   
   aiPlanSetVariableInt(marketBuildPlan, cBuildPlanBuildingTypeID, 0, gMarketUnit);
   
   aiPlanSetDesiredPriority(marketBuildPlan, 100);
   aiPlanSetDesiredResourcePriority(marketBuildPlan, 100);
   
   aiPlanSetMilitary(marketBuildPlan, false);
   aiPlanSetEconomy(marketBuildPlan, true);
   
   aiPlanSetEscrowID(marketBuildPlan, cEconomyEscrowID);
   
   aiPlanSetBaseID(marketBuildPlan, mainBaseID);
   
   aiPlanAddUnitType(marketBuildPlan, cUnitTypeSkirmisher, 1, 1, 1);
   aiPlanAddUnit(marketBuildPlan, builderID);
   aiPlanSetNoMoreUnits(marketBuildPlan, true);
   
   vector baseLocation = kbBaseGetLocation(cMyID, mainBaseID);
   aiPlanSetVariableVector(marketBuildPlan, cBuildPlanCenterPosition, 0, baseLocation);
   aiPlanSetVariableFloat(marketBuildPlan, cBuildPlanCenterPositionDistance, 0, 50.0);
   
   aiPlanSetVariableFloat(marketBuildPlan, cBuildPlanBuildingBufferSpace, 0, 8.0);
   aiPlanSetVariableInt(marketBuildPlan, cBuildPlanInfluenceUnitTypeID, 0, gMarketUnit);
   aiPlanSetVariableFloat(marketBuildPlan, cBuildPlanInfluenceUnitDistance, 0, 20.0);
   aiPlanSetVariableFloat(marketBuildPlan, cBuildPlanInfluenceUnitValue, 0, -100.0);
   
   aiPlanSetActive(marketBuildPlan, true);
   
   aiEcho("Finland Market: Created build plan with Jaeger ID " + builderID);
   debugBuildings("Finland: Created Market build plan (" + marketCount + "/" + desiredMarkets + ")");
}
//==============================================================================
// finlandChurchMonitor
//==============================================================================
rule finlandChurchMonitor
inactive
minInterval 30
{
   int mainBaseID = kbBaseGetMainID(cMyID);
   if (mainBaseID < 0)
   {
      return;
   }
   
   int churchCount = kbUnitCount(cMyID, cUnitTypeChurch, cUnitStateAlive);
   int churchBuilding = kbUnitCount(cMyID, cUnitTypeChurch, cUnitStateBuilding);
   int churchBuildLimit = kbGetBuildLimit(cMyID, cUnitTypeChurch);
   
   if (churchCount + churchBuilding >= churchBuildLimit || churchCount >= 1)
   {
      debugBuildings("Finland: Church limit reached (" + churchCount + "/" + churchBuildLimit + ")");
      return;
   }
   
   float currentWood = kbResourceGet(cResourceWood);
   if (currentWood < 100)
   {
      return;
   }
   
   int buildPlanID = createSimpleBuildPlanFinland(cUnitTypeChurch, 1, 100, true, cEconomyEscrowID, mainBaseID, 1);
   
   if (buildPlanID >= 0)
   {
      aiPlanAddUnitType(buildPlanID, cUnitTypeSkirmisher, 1, 1, 2);
      debugBuildings("Finland: Created Church build plan, current count " + churchCount + "/1");
   }
}
//==============================================================================
// finlandFieldHospitalMonitor
//==============================================================================
rule finlandFieldHospitalMonitor
inactive
minInterval 30
{
   if (kbTechGetStatus(cTechDEHCREVTurkuAcademy) != cTechStatusActive)
   {
      return;
   }
   
   int mainBaseID = kbBaseGetMainID(cMyID);
   if (mainBaseID < 0)
   {
      return;
   }
   
   int hospitalCount = kbUnitCount(cMyID, cUnitTypeFieldHospital, cUnitStateAlive);
   int hospitalBuilding = kbUnitCount(cMyID, cUnitTypeFieldHospital, cUnitStateBuilding);
   int hospitalBuildLimit = kbGetBuildLimit(cMyID, cUnitTypeFieldHospital);
   int desiredHospitals = 2;
   
   if (hospitalBuildLimit > 0 && desiredHospitals > hospitalBuildLimit)
   {
      desiredHospitals = hospitalBuildLimit;
   }
   
   if (hospitalCount + hospitalBuilding >= desiredHospitals)
   {
      debugBuildings("Finland: Field Hospital limit reached (" + hospitalCount + "/" + desiredHospitals + ")");
      return;
   }
   
   float currentWood = kbResourceGet(cResourceWood);
   if (currentWood < 200)
   {
      return;
   }
   
   int buildPlanID = createSimpleBuildPlanFinland(cUnitTypeFieldHospital, 1, 100, false, cMilitaryEscrowID, mainBaseID, 1);
   
   if (buildPlanID >= 0)
   {
      aiPlanAddUnitType(buildPlanID, cUnitTypeHero, 1, 1, 2);
      debugBuildings("Finland: Created Field Hospital build plan, current count " + hospitalCount + "/" + desiredHospitals);
   }
}
//==============================================================================
// finlandProspectorWagonMonitor
//==============================================================================
rule finlandProspectorWagonMonitor
inactive
minInterval 30
{
   int mainBaseID = kbBaseGetMainID(cMyID);
   if (mainBaseID < 0)
   {
      return;
   }
   
   int prospectorQuery = createSimpleUnitQuery(cUnitTypedeProspectorWagon, cMyID, cUnitStateAlive);
   int prospectorCount = kbUnitQueryExecute(prospectorQuery);
   
   if (prospectorCount < 1)
   {
      return;
   }
   
   int torpQuery = createSimpleUnitQuery(cUnitTypedeTorp, cMyID, cUnitStateAlive);
   int torpCount = kbUnitQueryExecute(torpQuery);
   
   if (torpCount < 1)
   {
      aiEcho("Finland Prospector: Waiting for Torp before building mine");
      return;
   }
   
   int torpID = kbUnitQueryGetResult(torpQuery, 0);
   vector torpLocation = kbUnitGetPosition(torpID);
   
   static int mineBuildPlan = -1;
   
   if (mineBuildPlan >= 0)
   {
      if (aiPlanGetState(mineBuildPlan) == -1)
      {
         aiPlanDestroy(mineBuildPlan);
         mineBuildPlan = -1;
      }
      else
      {
         return;
      }
   }
   
   int prospectorID = kbUnitQueryGetResult(prospectorQuery, 0);
   
   mineBuildPlan = aiPlanCreate("Finland Copper Mine Build", cPlanBuild);
   
   if (mineBuildPlan < 0)
   {
      aiEcho("Finland Prospector: Failed to create mine build plan");
      return;
   }
   
   aiPlanSetVariableInt(mineBuildPlan, cBuildPlanBuildingTypeID, 0, cUnitTypeMine);
   
   aiPlanSetDesiredPriority(mineBuildPlan, 100);
   aiPlanSetDesiredResourcePriority(mineBuildPlan, 100);
   
   aiPlanSetMilitary(mineBuildPlan, false);
   aiPlanSetEconomy(mineBuildPlan, true);
   
   aiPlanSetEscrowID(mineBuildPlan, cEconomyEscrowID);
   
   aiPlanSetBaseID(mineBuildPlan, mainBaseID);
   
   aiPlanAddUnitType(mineBuildPlan, cUnitTypedeProspectorWagon, 1, 1, 1);
   aiPlanAddUnit(mineBuildPlan, prospectorID);
   aiPlanSetNoMoreUnits(mineBuildPlan, true);
   
   aiPlanSetVariableVector(mineBuildPlan, cBuildPlanCenterPosition, 0, torpLocation);
   aiPlanSetVariableFloat(mineBuildPlan, cBuildPlanCenterPositionDistance, 0, 4.0);
   
   aiPlanSetVariableFloat(mineBuildPlan, cBuildPlanBuildingBufferSpace, 0, 0.0);
   
   aiPlanSetVariableInt(mineBuildPlan, cBuildPlanInfluenceUnitTypeID, 0, cUnitTypedeTorp);
   aiPlanSetVariableFloat(mineBuildPlan, cBuildPlanInfluenceUnitDistance, 0, 8.0);
   aiPlanSetVariableFloat(mineBuildPlan, cBuildPlanInfluenceUnitValue, 0, 500.0);
   aiPlanSetVariableInt(mineBuildPlan, cBuildPlanInfluenceUnitFalloff, 0, cBPIFalloffLinear);
   
   aiPlanSetActive(mineBuildPlan, true);
   
   aiEcho("Finland Prospector: Building Copper Mine right next to Torp at " + torpLocation);
   debugBuildings("Finland: Created Copper Mine build plan next to Torp");
}
//==============================================================================
// finlandJaegerMineGatherMonitor
//==============================================================================
rule finlandJaegerMineGatherMonitor
inactive
minInterval 30
{
   if (gFinlandNorthernWildernessSent == false)
   {
      return;
   }
   
   int mainBaseID = kbBaseGetMainID(cMyID);
   if (mainBaseID < 0)
   {
      return;
   }
   
   vector baseLocation = kbBaseGetLocation(cMyID, mainBaseID);
   
   int mineQuery = createSimpleUnitQuery(cUnitTypeAbstractMine, 0, cUnitStateAlive);
   kbUnitQuerySetPosition(mineQuery, baseLocation);
   kbUnitQuerySetMaximumDistance(mineQuery, 80.0);
   int mineCount = kbUnitQueryExecute(mineQuery);
   
   if (mineCount < 1)
   {
      debugEconomy("Finland: No mines found near base for Jaeger gathering");
      return;
   }
   
   static int jaegerMineGatherPlan = -1;
   int desiredGatherers = 7;
   
   if (jaegerMineGatherPlan >= 0)
   {
      if (aiPlanGetState(jaegerMineGatherPlan) == -1)
      {
         aiPlanDestroy(jaegerMineGatherPlan);
         jaegerMineGatherPlan = -1;
      }
   }
   
   if (jaegerMineGatherPlan < 0)
   {
      jaegerMineGatherPlan = aiPlanCreate("Finland Jaeger Mine Gather", cPlanGather);
      
      if (jaegerMineGatherPlan < 0)
      {
         aiEcho("Finland: Failed to create Jaeger mine gather plan");
         return;
      }
      
      aiPlanSetBaseID(jaegerMineGatherPlan, mainBaseID);
      aiPlanSetVariableInt(jaegerMineGatherPlan, cGatherPlanResourceType, 0, cResourceGold);
      aiPlanSetVariableInt(jaegerMineGatherPlan, cGatherPlanResourceSubType, 0, cAIResourceSubTypeEasy);
      
      aiPlanAddUnitType(jaegerMineGatherPlan, cUnitTypeSkirmisher, desiredGatherers, desiredGatherers, desiredGatherers);
      
      aiPlanSetDesiredPriority(jaegerMineGatherPlan, 40);
      
      aiPlanSetActive(jaegerMineGatherPlan, true);
      
      debugEconomy("Finland: Created Jaeger mine gather plan with " + desiredGatherers + " gatherers");
   }
   else
   {
      aiPlanAddUnitType(jaegerMineGatherPlan, cUnitTypeSkirmisher, desiredGatherers, desiredGatherers, desiredGatherers);
   }
   
   debugEconomy("Finland: Jaeger mine gather plan active, mines found: " + mineCount);
}
//==============================================================================
// finlandJaegerWoodGatherMonitor
//==============================================================================
rule finlandJaegerWoodGatherMonitor
inactive
minInterval 30
{
   if (gFinlandNorthernWildernessSent == false)
   {
      return;
   }
   
   int mainBaseID = kbBaseGetMainID(cMyID);
   if (mainBaseID < 0)
   {
      return;
   }
   
   vector baseLocation = kbBaseGetLocation(cMyID, mainBaseID);
   
   int treeQuery = createSimpleUnitQuery(cUnitTypeTree, 0, cUnitStateAlive);
   kbUnitQuerySetPosition(treeQuery, baseLocation);
   kbUnitQuerySetMaximumDistance(treeQuery, 180.0);
   int treeCount = kbUnitQueryExecute(treeQuery);
   
   if (treeCount < 1)
   {
      debugEconomy("Finland: No trees found near base for Jaeger gathering");
      return;
   }
   
   static int jaegerWoodGatherPlan = -1;
   int desiredGatherers = 7;
   
   if (jaegerWoodGatherPlan >= 0)
   {
      if (aiPlanGetState(jaegerWoodGatherPlan) == -1)
      {
         aiPlanDestroy(jaegerWoodGatherPlan);
         jaegerWoodGatherPlan = -1;
      }
   }
   
   if (jaegerWoodGatherPlan < 0)
   {
      jaegerWoodGatherPlan = aiPlanCreate("Finland Jaeger Wood Gather", cPlanGather);
      
      if (jaegerWoodGatherPlan < 0)
      {
         aiEcho("Finland: Failed to create Jaeger wood gather plan");
         return;
      }
      
      aiPlanSetBaseID(jaegerWoodGatherPlan, mainBaseID);
      aiPlanSetVariableInt(jaegerWoodGatherPlan, cGatherPlanResourceType, 0, cResourceWood);
      aiPlanSetVariableInt(jaegerWoodGatherPlan, cGatherPlanResourceSubType, 0, cAIResourceSubTypeEasy);
      
      aiPlanAddUnitType(jaegerWoodGatherPlan, cUnitTypeSkirmisher, desiredGatherers, desiredGatherers, desiredGatherers);
      
      aiPlanSetDesiredPriority(jaegerWoodGatherPlan, 40);
      
      aiPlanSetActive(jaegerWoodGatherPlan, true);
      
      debugEconomy("Finland: Created Jaeger wood gather plan with " + desiredGatherers + " gatherers");
   }
   else
   {
      aiPlanAddUnitType(jaegerWoodGatherPlan, cUnitTypeSkirmisher, desiredGatherers, desiredGatherers, desiredGatherers);
   }
   
   debugEconomy("Finland: Jaeger wood gather plan active, trees found: " + treeCount);
}
