extern bool gChileGermanSettlementsSent = false;
extern bool gChileLiberationMarchSent = false;
extern bool gChileSalitreraSent = false;

extern int gChileRevolutionaryMaintain = -1;
extern int gChileHussarMaintain = -1;
extern int gChileMapucheBolasRiderMaintain = -1;
extern int gChileGatlingGunMaintain = -1;
extern int gChileIroncladMaintain = -1;

//==============================================================================
// chileRevolutionManager
//==============================================================================
rule chileRevolutionManager
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
   
   int enemyHussarTargets = enemyLightInfCount + enemyArtilleryCount;
   int enemyRevolutionaryTargets = enemyCavalryCount + enemyShockInfCount;
   
   int totalEnemyUnits = enemyHussarTargets + enemyRevolutionaryTargets + enemyHeavyInfCount;
   
   int militaryPop = aiGetMilitaryPop();
   int wantedHussars = 0;
   int wantedRevolutionaries = 0;
   int wantedMapucheBolasRiders = 0;
   
   if (totalEnemyUnits > 5)
   {
      if (enemyLightInfCount + enemyArtilleryCount > enemyHeavyInfCount + enemyCavalryCount)
      {
         wantedHussars = (militaryPop * 0.55) / 2;
         wantedRevolutionaries = militaryPop * 0.25;
         wantedMapucheBolasRiders = (militaryPop * 0.20) / 2;
      }
      else if (enemyCavalryCount > 10)
      {
         wantedHussars = (militaryPop * 0.30) / 2;
         wantedRevolutionaries = militaryPop * 0.40;
         wantedMapucheBolasRiders = (militaryPop * 0.30) / 2;
      }
      else if (enemyHeavyInfCount > enemyLightInfCount)
      {
         wantedHussars = (militaryPop * 0.35) / 2;
         wantedRevolutionaries = militaryPop * 0.40;
         wantedMapucheBolasRiders = (militaryPop * 0.25) / 2;
      }
      else
      {
         wantedHussars = (militaryPop * 0.45) / 2;
         wantedRevolutionaries = militaryPop * 0.30;
         wantedMapucheBolasRiders = (militaryPop * 0.25) / 2;
      }
   }
   else
   {
      wantedHussars = (militaryPop * 0.45) / 2;
      wantedRevolutionaries = militaryPop * 0.30;
      wantedMapucheBolasRiders = (militaryPop * 0.25) / 2;
   }
   
   int hussarBL = kbGetBuildLimit(cMyID, cUnitTypeHussar);
   int revolutionaryBL = kbGetBuildLimit(cMyID, cUnitTypexpColonialMilitia);
   int mapucheBolasRiderBL = kbGetBuildLimit(cMyID, cUnitTypedeNatBolasRider);
   
   if ((hussarBL > 0) && (wantedHussars > hussarBL))
   {
      wantedHussars = hussarBL;
   }
   if ((revolutionaryBL > 0) && (wantedRevolutionaries > revolutionaryBL))
   {
      wantedRevolutionaries = revolutionaryBL;
   }
   if ((mapucheBolasRiderBL > 0) && (wantedMapucheBolasRiders > mapucheBolasRiderBL))
   {
      wantedMapucheBolasRiders = mapucheBolasRiderBL;
   }
   
   if (wantedHussars < 5)
   {
      wantedHussars = 5;
   }
   if (wantedRevolutionaries < 10)
   {
      wantedRevolutionaries = 10;
   }
   if (wantedMapucheBolasRiders < 3)
   {
      wantedMapucheBolasRiders = 3;
   }
   
   if (kbProtoUnitAvailable(cUnitTypeHussar) == true && gChileHussarMaintain == -1)
   {
      gChileHussarMaintain = createSimpleMaintainPlan(cUnitTypeHussar, wantedHussars, false, mainBaseID, 1);
      aiPlanSetDesiredPriority(gChileHussarMaintain, 80);
      aiPlanSetActive(gChileHussarMaintain, true);
      debugMilitary("Chile: Created Hussar of Death maintain plan");
   }
   else if (gChileHussarMaintain >= 0)
   {
      aiPlanSetVariableInt(gChileHussarMaintain, cTrainPlanNumberToMaintain, 0, wantedHussars);
   }
   
   if (kbProtoUnitAvailable(cUnitTypexpColonialMilitia) == true && gChileRevolutionaryMaintain == -1)
   {
      gChileRevolutionaryMaintain = createSimpleMaintainPlan(cUnitTypexpColonialMilitia, wantedRevolutionaries, false, mainBaseID, 1);
      aiPlanSetDesiredPriority(gChileRevolutionaryMaintain, 65);
      aiPlanSetActive(gChileRevolutionaryMaintain, true);
      debugMilitary("Chile: Created Revolutionary maintain plan");
   }
   else if (gChileRevolutionaryMaintain >= 0)
   {
      aiPlanSetVariableInt(gChileRevolutionaryMaintain, cTrainPlanNumberToMaintain, 0, wantedRevolutionaries);
   }
   
   if (kbProtoUnitAvailable(cUnitTypedeNatBolasRider) == true && gChileMapucheBolasRiderMaintain == -1)
   {
      gChileMapucheBolasRiderMaintain = createSimpleMaintainPlan(cUnitTypedeNatBolasRider, wantedMapucheBolasRiders, false, mainBaseID, 1);
      aiPlanSetDesiredPriority(gChileMapucheBolasRiderMaintain, 60);
      aiPlanSetActive(gChileMapucheBolasRiderMaintain, true);
      debugMilitary("Chile: Created Mapuche Bolas Rider maintain plan");
   }
   else if (gChileMapucheBolasRiderMaintain >= 0)
   {
      aiPlanSetVariableInt(gChileMapucheBolasRiderMaintain, cTrainPlanNumberToMaintain, 0, wantedMapucheBolasRiders);
   }
   
   debugMilitary("Chile army composition: Hussars of Death=" + wantedHussars + 
                 ", Revolutionaries=" + wantedRevolutionaries +
                 ", Mapuche Bolas Riders=" + wantedMapucheBolasRiders);
}

//==============================================================================
// chileGermanSettlementsManager
//==============================================================================
rule chileGermanSettlementsManager
inactive
minInterval 45
{
   if (gChileGermanSettlementsSent == false)
   {
      if (kbTechGetStatus(cTechDEHCREVCitizenshipChile) == cTechStatusActive)
      {
         gChileGermanSettlementsSent = true;
         debugMilitary("Chile: German Settlements card detected - economy restored!");
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
      
      int wantedSettlers = 25;
      if ((settlerBL > 0) && (settlerBL < wantedSettlers))
      {
         wantedSettlers = settlerBL;
      }
      
      aiPlanSetVariableInt(gSettlerMaintainPlan, cTrainPlanNumberToMaintain, 0, wantedSettlers);
      aiPlanSetDesiredResourcePriority(gSettlerMaintainPlan, 65);
      
      debugMilitary("Chile German Settlements: Settlers=" + currentSettlers + "/" + wantedSettlers);
   }
}

//==============================================================================
// chileArtilleryManager
//==============================================================================
rule chileArtilleryManager
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
      if (kbProtoUnitAvailable(cUnitTypexpGatlingGun) == true && gChileGatlingGunMaintain == -1)
      {
         gChileGatlingGunMaintain = createSimpleMaintainPlan(cUnitTypexpGatlingGun, wantedGatlingGuns, false, mainBaseID, 1);
         aiPlanSetDesiredPriority(gChileGatlingGunMaintain, 55);
         aiPlanSetActive(gChileGatlingGunMaintain, true);
         debugMilitary("Chile: Created Gatling Gun maintain plan");
      }
      else if (gChileGatlingGunMaintain >= 0)
      {
         aiPlanSetVariableInt(gChileGatlingGunMaintain, cTrainPlanNumberToMaintain, 0, wantedGatlingGuns);
      }
   }
   
   debugMilitary("Chile artillery: Gatling Guns=" + gatlingGunCount + "/" + wantedGatlingGuns);
}

//==============================================================================
// chileNavyManager
//==============================================================================
rule chileNavyManager
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
   
   int enemyPlayer = aiGetMostHatedPlayerID();
   int enemyNavyCount = kbUnitCount(enemyPlayer, cUnitTypeAbstractWarShip, cUnitStateAlive);
   
   int wantedIronclads = 2;
   
   if (enemyNavyCount > 5)
   {
      wantedIronclads = 4;
   }
   
   debugMilitary("Chile Navy: Ironclads=" + ironcladCount + "/" + wantedIronclads +
                 ", Frigates=" + frigateCount);
}

//==============================================================================
// chileCardEffectTracker
//==============================================================================
rule chileCardEffectTracker
inactive
minInterval 30
{
   if ((gChileGermanSettlementsSent == false) && 
       (kbTechGetStatus(cTechDEHCREVCitizenshipChile) == cTechStatusActive))
   {
      gChileGermanSettlementsSent = true;
      xsEnableRule("chileGermanSettlementsManager");
      debugMilitary("Chile: German Settlements activated - economy can be restored!");
   }
   
   if ((gChileLiberationMarchSent == false) && 
       (kbTechGetStatus(cTechDEHCLiberationMarch) == cTechStatusActive))
   {
      gChileLiberationMarchSent = true;
      debugMilitary("Chile: Liberation March activated - +5% speed, -35% train time!");
   }
   
   if ((gChileSalitreraSent == false) && 
       (kbTechGetStatus(cTechDEHCREVGuano) == cTechStatusActive))
   {
      gChileSalitreraSent = true;
      debugMilitary("Chile: Salitrera activated - Estates trickle coin!");
   }
}

//==============================================================================
// chileSalitreraManager
//==============================================================================
rule chileSalitreraManager
inactive
minInterval 60
{
   if (gChileSalitreraSent == false)
   {
      if (kbTechGetStatus(cTechDEHCREVGuano) == cTechStatusActive)
      {
         gChileSalitreraSent = true;
         debugMilitary("Chile: Salitrera activated!");
      }
      else
      {
         return;
      }
   }
   
   int estateCount = kbUnitCount(cMyID, cUnitTypePlantation, cUnitStateAlive);
   
   debugMilitary("Chile Salitrera: Estates=" + estateCount + 
                 " (generating " + (estateCount * 0.5) + " coin/sec)");
   
}

//==============================================================================
// chileEconomyManager
//==============================================================================
rule chileEconomyManager
inactive
minInterval 45
{
   
   float currentFood = kbResourceGet(cResourceFood);
   float currentWood = kbResourceGet(cResourceWood);
   float currentCoin = kbResourceGet(cResourceGold);
   
   int currentSettlers = kbUnitCount(cMyID, gEconUnit, cUnitStateAlive);
   
   bool hasEconomyCards = gChileGermanSettlementsSent;
   
   if (hasEconomyCards == false)
   {
      debugMilitary("Chile Economy: No economy cards sent yet! Resources: F=" + currentFood + 
                    " W=" + currentWood + " C=" + currentCoin);
   }
   else
   {
      debugMilitary("Chile Economy: Settlers=" + currentSettlers + 
                    ", Resources: F=" + currentFood + " W=" + currentWood + " C=" + currentCoin);
   }
   
   if (currentCoin < 500)
   {
      debugMilitary("Chile Economy: LOW COIN - need more for Hussar/Mapuche production");
   }
   if (currentFood < 500)
   {
      debugMilitary("Chile Economy: LOW FOOD - need more for Hussar/Revolutionary production");
   }
}

//==============================================================================
// chileCardManager
//==============================================================================
rule chileCardManager
inactive
minInterval 90
{
   float currentFood = kbResourceGet(cResourceFood);
   float currentWood = kbResourceGet(cResourceWood);
   float currentCoin = kbResourceGet(cResourceGold);
   
   int currentMilitary = aiGetMilitaryPop();
   int gameTime = xsGetTime();
   
   debugMilitary("Chile Card Manager: Evaluating card priorities");
}

//==============================================================================
// chileRaidManager
//==============================================================================
rule chileRaidManager
inactive
minInterval 60
{
   
   int hussarCount = kbUnitCount(cMyID, cUnitTypeHussar, cUnitStateAlive);
   int mapucheBolasCount = kbUnitCount(cMyID, cUnitTypedeNatBolasRider, cUnitStateAlive);
   
   int totalCavalry = hussarCount + mapucheBolasCount;
   
   if (totalCavalry >= 8)
   {
      debugMilitary("Chile Raid: Have " + totalCavalry + " cavalry available for raiding");
   }
   else
   {
      debugMilitary("Chile Raid: Only " + totalCavalry + " cavalry - building up forces");
   }
}

//==============================================================================
// chileMilitaryParadeManager
//==============================================================================
rule chileMilitaryParadeManager
inactive
minInterval 60
{
   
   int prussianNeedleGunnerCount = kbUnitCount(cMyID, cUnitTypeSkirmisher, cUnitStateAlive);
   int prussianUhlanCount = kbUnitCount(cMyID, cUnitTypeUhlan, cUnitStateAlive);
   
   debugMilitary("Chile Military Parade units: Needle Gunners=" + prussianNeedleGunnerCount +
                 ", Uhlans=" + prussianUhlanCount);
   
}
