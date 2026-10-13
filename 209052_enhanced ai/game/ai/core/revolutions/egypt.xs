extern bool gEgyptCitizensSent = false;
extern bool gEgyptFloodOfNileSent = false;
extern bool gEgyptArmyReformSent = false;
extern bool gEgyptSuezCanalSent = false;

extern int gKheviteFusilierMaintain = -1;
extern int gEgyptMamelukeMaintain = -1;
extern int gEgyptStradiotMaintain = -1;
extern int gEgyptHorseArtilleryMaintain = -1;
extern int gEgyptFrigateMaintain = -1;
extern int gEgyptMonitorMaintain = -1;

//==============================================================================
// egyptRevolutionManager
//==============================================================================
rule egyptRevolutionManager
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
   
   int enemyKheviteTargets = enemyCavalryCount + enemyShockInfCount + enemyArtilleryCount;
   int enemyMamelukeTargets = enemyLightInfCount + enemyArtilleryCount;
   
   int totalEnemyUnits = enemyKheviteTargets + enemyHeavyInfCount + enemyLightInfCount;
   
   int militaryPop = aiGetMilitaryPop();
   int wantedKheviteFusiliers = 0;
   int wantedMamelukes = 0;
   int wantedStradiots = 0;
   
   if (totalEnemyUnits > 5)
   {
      float kheviteTargetRatio = 0.0;
      float mamelukeTargetRatio = 0.0;
      
      if (totalEnemyUnits > 0)
      {
         kheviteTargetRatio = (enemyKheviteTargets * 1.0) / totalEnemyUnits;
         mamelukeTargetRatio = (enemyMamelukeTargets * 1.0) / totalEnemyUnits;
      }
      
      if (enemyArtilleryCount > 5)
      {
         wantedKheviteFusiliers = militaryPop * 0.40;
         wantedMamelukes = (militaryPop * 0.40) / 3;
         wantedStradiots = (militaryPop * 0.20) / 2;
      }
      else if (enemyCavalryCount + enemyShockInfCount > enemyHeavyInfCount)
      {
         wantedKheviteFusiliers = militaryPop * 0.50;
         wantedMamelukes = (militaryPop * 0.30) / 3;
         wantedStradiots = (militaryPop * 0.20) / 2;
      }
      else if (enemyLightInfCount > enemyHeavyInfCount)
      {
         wantedKheviteFusiliers = militaryPop * 0.25;
         wantedMamelukes = (militaryPop * 0.50) / 3;
         wantedStradiots = (militaryPop * 0.25) / 2;
      }
      else
      {
         wantedKheviteFusiliers = militaryPop * 0.35;
         wantedMamelukes = (militaryPop * 0.40) / 3;
         wantedStradiots = (militaryPop * 0.25) / 2;
      }
   }
   else
   {
      wantedKheviteFusiliers = militaryPop * 0.35;
      wantedMamelukes = (militaryPop * 0.40) / 3;
      wantedStradiots = (militaryPop * 0.25) / 2;
   }
   
   int kheviteFusilierBL = kbGetBuildLimit(cMyID, cUnitTypedeColonialMilitia);
   int mamelukeBL = kbGetBuildLimit(cMyID, cUnitTypeMercMameluke);
   int stradiotBL = kbGetBuildLimit(cMyID, cUnitTypeMercStradiot);
   
   if ((kheviteFusilierBL > 0) && (wantedKheviteFusiliers > kheviteFusilierBL))
   {
      wantedKheviteFusiliers = kheviteFusilierBL;
   }
   if ((mamelukeBL > 0) && (wantedMamelukes > mamelukeBL))
   {
      wantedMamelukes = mamelukeBL;
   }
   if ((stradiotBL > 0) && (wantedStradiots > stradiotBL))
   {
      wantedStradiots = stradiotBL;
   }
   
   if (wantedKheviteFusiliers < 10)
   {
      wantedKheviteFusiliers = 10;
   }
   if (wantedMamelukes < 3)
   {
      wantedMamelukes = 3;
   }
   if (wantedStradiots < 2)
   {
      wantedStradiots = 2;
   }
   
   if (kbProtoUnitAvailable(cUnitTypexpColonialMilitia) == true && gKheviteFusilierMaintain == -1)
   {
      gKheviteFusilierMaintain = createSimpleMaintainPlan(cUnitTypexpColonialMilitia, wantedKheviteFusiliers, false, mainBaseID, 1);
      aiPlanSetDesiredPriority(gKheviteFusilierMaintain, 70);
      aiPlanSetActive(gKheviteFusilierMaintain, true);
      debugMilitary("Egypt: Created Khevite Fusilier maintain plan");
   }
   else if (gKheviteFusilierMaintain >= 0)
   {
      aiPlanSetVariableInt(gKheviteFusilierMaintain, cTrainPlanNumberToMaintain, 0, wantedKheviteFusiliers);
   }
   
   if (kbProtoUnitAvailable(cUnitTypeMercMameluke) == true && gEgyptMamelukeMaintain == -1)
   {
      gEgyptMamelukeMaintain = createSimpleMaintainPlan(cUnitTypeMercMameluke, wantedMamelukes, false, mainBaseID, 1);
      aiPlanSetDesiredPriority(gEgyptMamelukeMaintain, 75);
      aiPlanSetActive(gEgyptMamelukeMaintain, true);
      debugMilitary("Egypt: Created Mameluke maintain plan");
   }
   else if (gEgyptMamelukeMaintain >= 0)
   {
      aiPlanSetVariableInt(gEgyptMamelukeMaintain, cTrainPlanNumberToMaintain, 0, wantedMamelukes);
   }
   
   if (kbProtoUnitAvailable(cUnitTypeMercStradiot) == true && gEgyptStradiotMaintain == -1)
   {
      gEgyptStradiotMaintain = createSimpleMaintainPlan(cUnitTypeMercStradiot, wantedStradiots, false, mainBaseID, 1);
      aiPlanSetDesiredPriority(gEgyptStradiotMaintain, 65);
      aiPlanSetActive(gEgyptStradiotMaintain, true);
      debugMilitary("Egypt: Created Stradiot maintain plan");
   }
   else if (gEgyptStradiotMaintain >= 0)
   {
      aiPlanSetVariableInt(gEgyptStradiotMaintain, cTrainPlanNumberToMaintain, 0, wantedStradiots);
   }
   
   debugMilitary("Egypt army composition: Khevite Fusiliers=" + wantedKheviteFusiliers + 
                 ", Mamelukes=" + wantedMamelukes +
                 ", Stradiots=" + wantedStradiots);
}

//==============================================================================
// egyptCitizensManager
//==============================================================================
rule egyptCitizensManager
inactive
minInterval 45
{
   
   if (gEgyptCitizensSent == false)
   {
      if (kbTechGetStatus(cTechDEHCREVCitizenship) == cTechStatusActive)
      {
         gEgyptCitizensSent = true;
         debugMilitary("Egypt: Citizens card detected - Settlers re-enabled!");
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
      
      if (gEgyptFloodOfNileSent == true)
      {
         wantedSettlers = wantedSettlers + 4;
         if ((settlerBL > 0) && (wantedSettlers > settlerBL))
         {
            wantedSettlers = settlerBL;
         }
      }
      
      aiPlanSetVariableInt(gSettlerMaintainPlan, cTrainPlanNumberToMaintain, 0, wantedSettlers);
      aiPlanSetDesiredResourcePriority(gSettlerMaintainPlan, 70);
      
      debugMilitary("Egypt Citizens: Settlers=" + currentSettlers + "/" + wantedSettlers);
   }
}

//==============================================================================
// egyptArtilleryManager  
//==============================================================================
rule egyptArtilleryManager
inactive
minInterval 45
{
   int mainBaseID = kbBaseGetMainID(cMyID);
   
   int horseArtilleryCount = kbUnitCount(cMyID, cUnitTypexpHorseArtillery, cUnitStateAlive);
   
   int enemyPlayer = aiGetMostHatedPlayerID();
   int enemyArtilleryCount = kbUnitCount(enemyPlayer, cUnitTypeAbstractArtillery, cUnitStateAlive);
   int enemyInfantryCount = kbUnitCount(enemyPlayer, cUnitTypeAbstractInfantry, cUnitStateAlive);
   int enemyBuildingCount = kbUnitCount(enemyPlayer, cUnitTypeBuilding, cUnitStateAlive);
   
   int wantedHorseArtillery = 0;
   
   if (enemyInfantryCount > 30)
   {
      wantedHorseArtillery = 4;
   }
   else if (enemyBuildingCount > 10)
   {
      wantedHorseArtillery = 3;
   }
   else
   {
      wantedHorseArtillery = 2;
   }
   
   if (wantedHorseArtillery > 6)
   {
      wantedHorseArtillery = 6;
   }
   
   if (wantedHorseArtillery > 0)
   {
      if (kbProtoUnitAvailable(cUnitTypexpHorseArtillery) == true && gEgyptHorseArtilleryMaintain == -1)
      {
         gEgyptHorseArtilleryMaintain = createSimpleMaintainPlan(cUnitTypexpHorseArtillery, wantedHorseArtillery, false, mainBaseID, 1);
         aiPlanSetDesiredPriority(gEgyptHorseArtilleryMaintain, 50);
         aiPlanSetActive(gEgyptHorseArtilleryMaintain, true);
         debugMilitary("Egypt: Created Horse Artillery maintain plan");
      }
      else if (gEgyptHorseArtilleryMaintain >= 0)
      {
         aiPlanSetVariableInt(gEgyptHorseArtilleryMaintain, cTrainPlanNumberToMaintain, 0, wantedHorseArtillery);
      }
   }
   
   debugMilitary("Egypt artillery: Horse Artillery=" + horseArtilleryCount + "/" + wantedHorseArtillery);
}

//==============================================================================
// egyptNavyManager
//==============================================================================
rule egyptNavyManager
inactive
minInterval 45
{
   if (gNavyMap == false)
   {
      xsDisableSelf();
      return;
   }
   
   int mainBaseID = kbBaseGetMainID(cMyID);
   
   int frigateCount = kbUnitCount(cMyID, cUnitTypeFrigate, cUnitStateAlive);
   int monitorCount = kbUnitCount(cMyID, cUnitTypeMonitor, cUnitStateAlive);
   int privateerCount = kbUnitCount(cMyID, cUnitTypePrivateer, cUnitStateAlive);
   int galleonCount = kbUnitCount(cMyID, cUnitTypeGalleon, cUnitStateAlive);
   
   int enemyPlayer = aiGetMostHatedPlayerID();
   int enemyNavyCount = kbUnitCount(enemyPlayer, cUnitTypeAbstractWarShip, cUnitStateAlive);
   
   int wantedFrigates = 2;
   int wantedMonitors = 1;
   int wantedGalleons = 2;
   
   if (enemyNavyCount > 5)
   {
      wantedFrigates = 4;
      wantedMonitors = 2;
      wantedGalleons = 3;
   }
   
   if (kbProtoUnitAvailable(cUnitTypeFrigate) == true && gEgyptFrigateMaintain == -1)
   {
      gEgyptFrigateMaintain = createSimpleMaintainPlan(cUnitTypeFrigate, wantedFrigates, false, mainBaseID, 1);
      aiPlanSetDesiredPriority(gEgyptFrigateMaintain, 55);
      aiPlanSetActive(gEgyptFrigateMaintain, true);
      debugMilitary("Egypt: Created Frigate maintain plan");
   }
   else if (gEgyptFrigateMaintain >= 0)
   {
      aiPlanSetVariableInt(gEgyptFrigateMaintain, cTrainPlanNumberToMaintain, 0, wantedFrigates);
   }
   
   if (kbProtoUnitAvailable(cUnitTypeMonitor) == true && gEgyptMonitorMaintain == -1)
   {
      gEgyptMonitorMaintain = createSimpleMaintainPlan(cUnitTypeMonitor, wantedMonitors, false, mainBaseID, 1);
      aiPlanSetDesiredPriority(gEgyptMonitorMaintain, 50);
      aiPlanSetActive(gEgyptMonitorMaintain, true);
      debugMilitary("Egypt: Created Monitor maintain plan");
   }
   else if (gEgyptMonitorMaintain >= 0)
   {
      aiPlanSetVariableInt(gEgyptMonitorMaintain, cTrainPlanNumberToMaintain, 0, wantedMonitors);
   }
   
   debugMilitary("Egypt Navy: Frigates=" + frigateCount + "/" + wantedFrigates +
                 ", Monitors=" + monitorCount + "/" + wantedMonitors +
                 ", Galleons=" + galleonCount +
                 ", Privateers=" + privateerCount);
}

//==============================================================================
// egyptMercenaryManager
//==============================================================================
rule egyptMercenaryManager
inactive
minInterval 60
{
   
   int gatlingCamelCount = kbUnitCount(cMyID, cUnitTypedeMercGatlingCamel, cUnitStateAlive);
   int askariCount = kbUnitCount(cMyID, cUnitTypedeMercAskari, cUnitStateAlive);
   int sennarHorsemanCount = kbUnitCount(cMyID, cUnitTypedeMercSudaneseRider, cUnitStateAlive);
   int sudaneseDervishCount = kbUnitCount(cMyID, cUnitTypedeNatMercSudaneseDervish, cUnitStateAlive);
   
   debugMilitary("Egypt Mercenaries: Gatling Camels=" + gatlingCamelCount + 
                 ", Askaris=" + askariCount +
                 ", Sennar Horsemen=" + sennarHorsemanCount +
                 ", Sudanese Dervishes=" + sudaneseDervishCount);
   
}

//==============================================================================
// egyptCardManager
//==============================================================================
rule egyptCardManager
inactive
minInterval 90
{
   float currentFood = kbResourceGet(cResourceFood);
   float currentWood = kbResourceGet(cResourceWood);
   float currentCoin = kbResourceGet(cResourceGold);
   
   int currentMilitary = aiGetMilitaryPop();
   int gameTime = xsGetTime();
   
   debugMilitary("Egypt Card Manager: Evaluating card priorities");
   
   if ((gEgyptArmyReformSent == false) && 
       (kbTechGetStatus(cTechDEHCREVRangedCombatEgypt) == cTechStatusActive))
   {
      gEgyptArmyReformSent = true;
      debugMilitary("Egypt: Egyptian Army Reform sent - Khevite Fusilier cost changed to 50f/50c!");
   }
   
   if ((gEgyptSuezCanalSent == false) && 
       (kbTechGetStatus(cTechDEHCREVSuezCanal) == cTechStatusActive))
   {
      gEgyptSuezCanalSent = true;
      debugMilitary("Egypt: Suez Canal sent - free Trade Route upgrades!");
   }
}

//==============================================================================
// egyptCardEffectTracker
//==============================================================================
rule egyptCardEffectTracker
inactive
minInterval 30
{
   if ((gEgyptCitizensSent == false) && 
       (kbTechGetStatus(cTechDEHCREVCitizenship) == cTechStatusActive))
   {
      gEgyptCitizensSent = true;
      xsEnableRule("egyptCitizensManager");
      debugMilitary("Egypt: Citizens activated - Settlers can be trained!");
   }
   
   if ((gEgyptFloodOfNileSent == false) && 
       (kbTechGetStatus(cTechDEHCREVNileFlood) == cTechStatusActive))
   {
      gEgyptFloodOfNileSent = true;
      debugMilitary("Egypt: Flood of the Nile activated - economic boost!");
   }
   
   if ((gEgyptArmyReformSent == false) && 
       (kbTechGetStatus(cTechDEHCREVRangedCombatEgypt) == cTechStatusActive))
   {
      gEgyptArmyReformSent = true;
      debugMilitary("Egypt: Egyptian Army Reform activated - Khevite Fusilier cost efficiency!");
   }
   
   if ((gEgyptSuezCanalSent == false) && 
       (kbTechGetStatus(cTechDEHCREVSuezCanal) == cTechStatusActive))
   {
      gEgyptSuezCanalSent = true;
      debugMilitary("Egypt: Suez Canal activated - Trade Route bonuses!");
   }
}

//==============================================================================
// egyptTradeRouteManager
//==============================================================================
rule egyptTradeRouteManager
inactive
minInterval 60
{
   if (gEgyptSuezCanalSent == false)
   {
      return;
   }
   
   debugMilitary("Egypt: Suez Canal active - Trade Route upgrades are free");
   
}

//==============================================================================
// egyptXPGenerationManager
//==============================================================================
rule egyptXPGenerationManager
inactive
minInterval 60
{
   
   float currentXP = kbResourceGet(cResourceXP);
   
   int mamelukesFromShipments = kbUnitCount(cMyID, cUnitTypeMercMameluke, cUnitStateAlive);
   
   debugMilitary("Egypt XP Management: Current XP=" + currentXP + 
                 ", Mamelukes (includes from shipments)=" + mamelukesFromShipments);
   
}

//==============================================================================
// egyptFloodOfNileManager
//==============================================================================
rule egyptFloodOfNileManager
inactive
minInterval 60
{
   if (gEgyptFloodOfNileSent == false)
   {
      if (kbTechGetStatus(cTechDEHCREVNileFlood) == cTechStatusActive)
      {
         gEgyptFloodOfNileSent = true;
         debugMilitary("Egypt: Flood of the Nile activated!");
      }
      else
      {
         return;
      }
   }
   
   int millCount = kbUnitCount(cMyID, cUnitTypeMill, cUnitStateAlive);
   int estateCount = kbUnitCount(cMyID, cUnitTypePlantation, cUnitStateAlive);
   
   debugMilitary("Egypt Flood of Nile: Mills=" + millCount + 
                 ", Estates=" + estateCount +
                 " (each provides +100 resources and +10% gather rate)");
   
}

//==============================================================================
// egyptEconomyManager
//==============================================================================
rule egyptEconomyManager
inactive
minInterval 45
{
   
   float currentFood = kbResourceGet(cResourceFood);
   float currentWood = kbResourceGet(cResourceWood);
   float currentCoin = kbResourceGet(cResourceGold);
   
   int currentSettlers = kbUnitCount(cMyID, gEconUnit, cUnitStateAlive);
   
   bool hasEconomyCards = gEgyptCitizensSent || gEgyptFloodOfNileSent;
   
   if (hasEconomyCards == false)
   {
      debugMilitary("Egypt Economy: No economy cards sent yet! Resources: F=" + currentFood + 
                    " W=" + currentWood + " C=" + currentCoin);
   }
   else
   {
      debugMilitary("Egypt Economy: Settlers=" + currentSettlers + 
                    ", Resources: F=" + currentFood + " W=" + currentWood + " C=" + currentCoin);
   }
   
   if (currentCoin < 500)
   {
      debugMilitary("Egypt Economy: LOW COIN - need to prioritize coin gathering");
   }
}

//==============================================================================
// egyptCavalryRaidManager
//==============================================================================
rule egyptCavalryRaidManager
inactive
minInterval 60
{
   
   int mamelukesCount = kbUnitCount(cMyID, cUnitTypeMercMameluke, cUnitStateAlive);
   int stradiotsCount = kbUnitCount(cMyID, cUnitTypeMercStradiot, cUnitStateAlive);
   
   int totalCavalry = mamelukesCount + stradiotsCount;
   
   if (totalCavalry >= 5)
   {
      debugMilitary("Egypt Cavalry Raid: Have " + totalCavalry + " cavalry available for raiding");
   }
   else
   {
      debugMilitary("Egypt Cavalry Raid: Only " + totalCavalry + " cavalry - building up forces");
   }
}
