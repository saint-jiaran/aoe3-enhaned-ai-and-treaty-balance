extern bool gCanadaNativeAlliesSent = false;
extern bool gCanadaFenciblesSent = false;
extern bool gCanadaWildernessWarfareSent = false;

extern int gCanadaMusketeerMaintain = -1;
extern int gCanadaDragoonMaintain = -1;
extern int gCanadaSkirmisherMaintain = -1;
extern int gCanadaWarCanoeMaintain = -1;

//==============================================================================
// canadaRevolutionManager
//==============================================================================
rule canadaRevolutionManager
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
   int wantedMusketeers = 0;
   int wantedDragoons = 0;
   int wantedSkirmishers = 0;
   
   if (totalEnemyUnits > 5)
   {
      if (enemyCavalryCount + enemyShockInfCount > enemyHeavyInfCount + enemyLightInfCount)
      {
         wantedMusketeers = militaryPop * 0.45;
         wantedDragoons = (militaryPop * 0.35) / 2;
         wantedSkirmishers = militaryPop * 0.20;
      }
      else if (enemyHeavyInfCount > enemyLightInfCount)
      {
         wantedMusketeers = militaryPop * 0.30;
         wantedDragoons = (militaryPop * 0.25) / 2;
         wantedSkirmishers = militaryPop * 0.45;
      }
      else if (enemyArtilleryCount > 5)
      {
         wantedMusketeers = militaryPop * 0.35;
         wantedDragoons = (militaryPop * 0.40) / 2;
         wantedSkirmishers = militaryPop * 0.25;
      }
      else
      {
         wantedMusketeers = militaryPop * 0.40;
         wantedDragoons = (militaryPop * 0.30) / 2;
         wantedSkirmishers = militaryPop * 0.30;
      }
   }
   else
   {
      wantedMusketeers = militaryPop * 0.40;
      wantedDragoons = (militaryPop * 0.30) / 2;
      wantedSkirmishers = militaryPop * 0.30;
   }
   
   int musketeerBL = kbGetBuildLimit(cMyID, cUnitTypeMusketeer);
   int dragoonBL = kbGetBuildLimit(cMyID, cUnitTypeDragoon);
   int skirmisherBL = kbGetBuildLimit(cMyID, cUnitTypeSkirmisher);
   
   if ((musketeerBL > 0) && (wantedMusketeers > musketeerBL))
   {
      wantedMusketeers = musketeerBL;
   }
   if ((dragoonBL > 0) && (wantedDragoons > dragoonBL))
   {
      wantedDragoons = dragoonBL;
   }
   if ((skirmisherBL > 0) && (wantedSkirmishers > skirmisherBL))
   {
      wantedSkirmishers = skirmisherBL;
   }
   
   if (wantedMusketeers < 10)
   {
      wantedMusketeers = 10;
   }
   if (wantedDragoons < 5)
   {
      wantedDragoons = 5;
   }
   if (wantedSkirmishers < 8)
   {
      wantedSkirmishers = 8;
   }
   
   if (kbProtoUnitAvailable(cUnitTypeMusketeer) == true && gCanadaMusketeerMaintain == -1)
   {
      gCanadaMusketeerMaintain = createSimpleMaintainPlan(cUnitTypeMusketeer, wantedMusketeers, false, mainBaseID, 1);
      aiPlanSetDesiredPriority(gCanadaMusketeerMaintain, 75);
      aiPlanSetActive(gCanadaMusketeerMaintain, true);
      debugMilitary("Canada: Created Musketeer maintain plan");
   }
   else if (gCanadaMusketeerMaintain >= 0)
   {
      aiPlanSetVariableInt(gCanadaMusketeerMaintain, cTrainPlanNumberToMaintain, 0, wantedMusketeers);
   }
   
   if (kbProtoUnitAvailable(cUnitTypeDragoon) == true && gCanadaDragoonMaintain == -1)
   {
      gCanadaDragoonMaintain = createSimpleMaintainPlan(cUnitTypeDragoon, wantedDragoons, false, mainBaseID, 1);
      aiPlanSetDesiredPriority(gCanadaDragoonMaintain, 70);
      aiPlanSetActive(gCanadaDragoonMaintain, true);
      debugMilitary("Canada: Created Dragoon maintain plan");
   }
   else if (gCanadaDragoonMaintain >= 0)
   {
      aiPlanSetVariableInt(gCanadaDragoonMaintain, cTrainPlanNumberToMaintain, 0, wantedDragoons);
   }
   
   if (kbProtoUnitAvailable(cUnitTypeSkirmisher) == true && gCanadaSkirmisherMaintain == -1)
   {
      gCanadaSkirmisherMaintain = createSimpleMaintainPlan(cUnitTypeSkirmisher, wantedSkirmishers, false, mainBaseID, 1);
      aiPlanSetDesiredPriority(gCanadaSkirmisherMaintain, 65);
      aiPlanSetActive(gCanadaSkirmisherMaintain, true);
      debugMilitary("Canada: Created Skirmisher maintain plan");
   }
   else if (gCanadaSkirmisherMaintain >= 0)
   {
      aiPlanSetVariableInt(gCanadaSkirmisherMaintain, cTrainPlanNumberToMaintain, 0, wantedSkirmishers);
   }
   
   debugMilitary("Canada army composition: Musketeers=" + wantedMusketeers + 
                 ", Dragoons=" + wantedDragoons +
                 ", Skirmishers=" + wantedSkirmishers);
}

//==============================================================================
// canadaEconomyManager
//==============================================================================
rule canadaEconomyManager
inactive
minInterval 45
{
   
   float currentFood = kbResourceGet(cResourceFood);
   float currentWood = kbResourceGet(cResourceWood);
   float currentCoin = kbResourceGet(cResourceGold);
   
   int currentSettlers = kbUnitCount(cMyID, gEconUnit, cUnitStateAlive);
   int settlerBL = kbGetBuildLimit(cMyID, gEconUnit);
   
   int wantedSettlers = 60;
   if ((settlerBL > 0) && (settlerBL < wantedSettlers))
   {
      wantedSettlers = settlerBL;
   }
   
   if (gSettlerMaintainPlan >= 0)
   {
      aiPlanSetVariableInt(gSettlerMaintainPlan, cTrainPlanNumberToMaintain, 0, wantedSettlers);
      aiPlanSetDesiredResourcePriority(gSettlerMaintainPlan, 80);
   }
   
   debugMilitary("Canada Economy: Settlers=" + currentSettlers + "/" + wantedSettlers +
                 ", Resources: F=" + currentFood + " W=" + currentWood + " C=" + currentCoin);
   
}

//==============================================================================
// canadaNativeAlliesManager
//==============================================================================
rule canadaNativeAlliesManager
inactive
minInterval 60
{
   if (gCanadaNativeAlliesSent == false)
   {
      if (kbTechGetStatus(cTechDEHCREVNativeAlliesCanada) == cTechStatusActive)
      {
         gCanadaNativeAlliesSent = true;
         debugMilitary("Canada: Native American Allies activated!");
      }
      else
      {
         return;
      }
   }
   
   int nativeEmbassyCount = kbUnitCount(cMyID, cUnitTypeNativeEmbassy, cUnitStateAlive);
   
   debugMilitary("Canada Native Allies: Native Embassies=" + nativeEmbassyCount);
   
}

//==============================================================================
// canadaNavyManager
//==============================================================================
rule canadaNavyManager
inactive
minInterval 45
{
   if (gNavyMap == false)
   {
      xsDisableSelf();
      return;
   }
   
   int mainBaseID = kbBaseGetMainID(cMyID);
   
   int warCanoeCount = kbUnitCount(cMyID, cUnitTypeCanoe, cUnitStateAlive);
   int frigateCount = kbUnitCount(cMyID, cUnitTypeFrigate, cUnitStateAlive);
   
   int enemyPlayer = aiGetMostHatedPlayerID();
   int enemyNavyCount = kbUnitCount(enemyPlayer, cUnitTypeAbstractWarShip, cUnitStateAlive);
   
   int wantedWarCanoes = 4;
   
   if (enemyNavyCount > 5)
   {
      wantedWarCanoes = 8;
   }
   
   debugMilitary("Canada Navy: War Canoes=" + warCanoeCount + "/" + wantedWarCanoes +
                 ", Frigates=" + frigateCount);
}

//==============================================================================
// canadaCardEffectTracker
//==============================================================================
rule canadaCardEffectTracker
inactive
minInterval 30
{
   if ((gCanadaNativeAlliesSent == false) && 
       (kbTechGetStatus(cTechDEHCREVNativeAlliesCanada) == cTechStatusActive))
   {
      gCanadaNativeAlliesSent = true;
      xsEnableRule("canadaNativeAlliesManager");
      debugMilitary("Canada: Native American Allies activated!");
   }
   
   if ((gCanadaFenciblesSent == false) && 
       (kbTechGetStatus(cTechDEHCREVFencibles) == cTechStatusActive))
   {
      gCanadaFenciblesSent = true;
      debugMilitary("Canada: Fencibles activated - Musketeers upgraded to Redcoats!");
   }
   
   if ((gCanadaWildernessWarfareSent == false) && 
       (kbTechGetStatus(cTechHCWildernessWarfare) == cTechStatusActive))
   {
      gCanadaWildernessWarfareSent = true;
      debugMilitary("Canada: Wilderness Warfare activated - Skirmishers buffed!");
   }
}

//==============================================================================
// canadaCardManager
//==============================================================================
rule canadaCardManager
inactive
minInterval 90
{
   float currentFood = kbResourceGet(cResourceFood);
   float currentWood = kbResourceGet(cResourceWood);
   float currentCoin = kbResourceGet(cResourceGold);
   
   int currentMilitary = aiGetMilitaryPop();
   int gameTime = xsGetTime();
   
   debugMilitary("Canada Card Manager: Evaluating card priorities");
}

//==============================================================================
// canadaSettlerDefenseManager
//==============================================================================
rule canadaSettlerDefenseManager
inactive
minInterval 60
{
   
   int settlerCount = kbUnitCount(cMyID, gEconUnit, cUnitStateAlive);
   
   debugMilitary("Canada Settler Defense: " + settlerCount + " armed settlers");
   
}

//==============================================================================
// canadaHuntManager
//==============================================================================
rule canadaHuntManager
inactive
minInterval 60
{
   
   int bisonCount = kbUnitCount(cMyID, cUnitTypeBison, cUnitStateAlive);
   int elkCount = kbUnitCount(cMyID, cUnitTypeElk, cUnitStateAlive);
   
   debugMilitary("Canada Hunts: Bison=" + bisonCount + ", Elks=" + elkCount);
   
}

//==============================================================================
// canadaTotenkopfHussarManager
//==============================================================================
rule canadaTotenkopfHussarManager
inactive
minInterval 60
{
   
   int totenkopfHussarCount = kbUnitCount(cMyID, cUnitTypedeNatTotenkopf, cUnitStateAlive);
   
   debugMilitary("Canada Totenkopf Hussars: " + totenkopfHussarCount);
   
}
