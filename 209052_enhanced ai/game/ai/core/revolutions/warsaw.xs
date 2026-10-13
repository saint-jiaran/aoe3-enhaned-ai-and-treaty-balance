extern bool gWarsawCitizenshipSent = false;
extern bool gWarsawArmySent = false;
extern bool gWarsawScythemenSent = false;
extern bool gWarsawCombatSent = false;

extern int gWarsawLancerMaintain = -1;
extern int gWarsawHussarMaintain = -1;
extern int gWarsawPikemanMaintain = -1;
extern int gWarsawSkirmisherMaintain = -1;
extern int gWarsawDragoonMaintain = -1;
extern int gWarsawSettlerMaintain = -1;

//==============================================================================
// warsawRevolutionManager
//==============================================================================
rule warsawRevolutionManager
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
   int enemyHeavyInfCount = kbUnitCount(enemyPlayer, cUnitTypeAbstractHeavyInfantry, cUnitStateAlive);
   int enemyLightInfCount = kbUnitCount(enemyPlayer, cUnitTypeAbstractLightInfantry, cUnitStateAlive);
   int enemyArtilleryCount = kbUnitCount(enemyPlayer, cUnitTypeAbstractArtillery, cUnitStateAlive);

   int totalEnemyUnits = enemyCavalryCount + enemyHeavyInfCount + enemyLightInfCount;

   int militaryPop = aiGetMilitaryPop();
   int wantedLancers = 0;
   int wantedHussars = 0;
   int wantedPikemen = 0;
   int wantedSkirmishers = 0;
   int wantedDragoons = 0;

   if (totalEnemyUnits > 5)
   {
      if (enemyCavalryCount > enemyHeavyInfCount + enemyLightInfCount)
      {
         wantedLancers = (militaryPop * 0.20) / 2;
         wantedHussars = (militaryPop * 0.15) / 2;
         wantedPikemen = militaryPop * 0.30;
         wantedSkirmishers = militaryPop * 0.10;
         wantedDragoons = (militaryPop * 0.25) / 2;
      }
      else if (enemyHeavyInfCount > enemyLightInfCount)
      {
         wantedLancers = (militaryPop * 0.25) / 2;
         wantedHussars = (militaryPop * 0.20) / 2;
         wantedPikemen = militaryPop * 0.10;
         wantedSkirmishers = militaryPop * 0.35;
         wantedDragoons = (militaryPop * 0.10) / 2;
      }
      else
      {
         wantedLancers = (militaryPop * 0.35) / 2;
         wantedHussars = (militaryPop * 0.30) / 2;
         wantedPikemen = militaryPop * 0.10;
         wantedSkirmishers = militaryPop * 0.15;
         wantedDragoons = (militaryPop * 0.10) / 2;
      }
   }
   else
   {
      wantedLancers = (militaryPop * 0.30) / 2;
      wantedHussars = (militaryPop * 0.25) / 2;
      wantedPikemen = militaryPop * 0.15;
      wantedSkirmishers = militaryPop * 0.20;
      wantedDragoons = (militaryPop * 0.10) / 2;
   }

   if (enemyArtilleryCount > 3)
   {
      wantedLancers = wantedLancers + 4;
   }

   int lancerBL = kbGetBuildLimit(cMyID, cUnitTypedeREVPolishLancer);
   int hussarBL = kbGetBuildLimit(cMyID, cUnitTypedeWingedHussar);
   int pikemanBL = kbGetBuildLimit(cMyID, cUnitTypePikeman);
   int skirmisherBL = kbGetBuildLimit(cMyID, cUnitTypeSkirmisher);
   int dragoonBL = kbGetBuildLimit(cMyID, cUnitTypeDragoon);

   if ((lancerBL > 0) && (wantedLancers > lancerBL))
   {
      wantedLancers = lancerBL;
   }
   if ((hussarBL > 0) && (wantedHussars > hussarBL))
   {
      wantedHussars = hussarBL;
   }
   if ((pikemanBL > 0) && (wantedPikemen > pikemanBL))
   {
      wantedPikemen = pikemanBL;
   }
   if ((skirmisherBL > 0) && (wantedSkirmishers > skirmisherBL))
   {
      wantedSkirmishers = skirmisherBL;
   }
   if ((dragoonBL > 0) && (wantedDragoons > dragoonBL))
   {
      wantedDragoons = dragoonBL;
   }

   if (wantedLancers < 5)
   {
      wantedLancers = 5;
   }
   if (wantedHussars < 4)
   {
      wantedHussars = 4;
   }
   if (wantedPikemen < 6)
   {
      wantedPikemen = 6;
   }
   if (wantedSkirmishers < 6)
   {
      wantedSkirmishers = 6;
   }
   if (wantedDragoons < 3)
   {
      wantedDragoons = 3;
   }

   if (kbProtoUnitAvailable(cUnitTypedeREVPolishLancer) == true && gWarsawLancerMaintain == -1)
   {
      gWarsawLancerMaintain = createSimpleMaintainPlan(cUnitTypedeREVPolishLancer, wantedLancers, false, mainBaseID, 1);
      aiPlanSetDesiredPriority(gWarsawLancerMaintain, 78);
      aiPlanSetActive(gWarsawLancerMaintain, true);
      debugMilitary("Warsaw: Created Polish Lancer maintain plan");
   }
   else if (gWarsawLancerMaintain >= 0)
   {
      aiPlanSetVariableInt(gWarsawLancerMaintain, cTrainPlanNumberToMaintain, 0, wantedLancers);
   }

   if (kbProtoUnitAvailable(cUnitTypedeWingedHussar) == true && gWarsawHussarMaintain == -1)
   {
      gWarsawHussarMaintain = createSimpleMaintainPlan(cUnitTypedeWingedHussar, wantedHussars, false, mainBaseID, 1);
      aiPlanSetDesiredPriority(gWarsawHussarMaintain, 76);
      aiPlanSetActive(gWarsawHussarMaintain, true);
      debugMilitary("Warsaw: Created Winged Hussar maintain plan");
   }
   else if (gWarsawHussarMaintain >= 0)
   {
      aiPlanSetVariableInt(gWarsawHussarMaintain, cTrainPlanNumberToMaintain, 0, wantedHussars);
   }

   if (kbProtoUnitAvailable(cUnitTypePikeman) == true && gWarsawPikemanMaintain == -1)
   {
      gWarsawPikemanMaintain = createSimpleMaintainPlan(cUnitTypePikeman, wantedPikemen, false, mainBaseID, 1);
      aiPlanSetDesiredPriority(gWarsawPikemanMaintain, 68);
      aiPlanSetActive(gWarsawPikemanMaintain, true);
      debugMilitary("Warsaw: Created Pikeman maintain plan");
   }
   else if (gWarsawPikemanMaintain >= 0)
   {
      aiPlanSetVariableInt(gWarsawPikemanMaintain, cTrainPlanNumberToMaintain, 0, wantedPikemen);
   }

   if (kbProtoUnitAvailable(cUnitTypeSkirmisher) == true && gWarsawSkirmisherMaintain == -1)
   {
      gWarsawSkirmisherMaintain = createSimpleMaintainPlan(cUnitTypeSkirmisher, wantedSkirmishers, false, mainBaseID, 1);
      aiPlanSetDesiredPriority(gWarsawSkirmisherMaintain, 70);
      aiPlanSetActive(gWarsawSkirmisherMaintain, true);
      debugMilitary("Warsaw: Created Skirmisher maintain plan");
   }
   else if (gWarsawSkirmisherMaintain >= 0)
   {
      aiPlanSetVariableInt(gWarsawSkirmisherMaintain, cTrainPlanNumberToMaintain, 0, wantedSkirmishers);
   }

   if (kbProtoUnitAvailable(cUnitTypeDragoon) == true && gWarsawDragoonMaintain == -1)
   {
      gWarsawDragoonMaintain = createSimpleMaintainPlan(cUnitTypeDragoon, wantedDragoons, false, mainBaseID, 1);
      aiPlanSetDesiredPriority(gWarsawDragoonMaintain, 66);
      aiPlanSetActive(gWarsawDragoonMaintain, true);
      debugMilitary("Warsaw: Created Dragoon maintain plan");
   }
   else if (gWarsawDragoonMaintain >= 0)
   {
      aiPlanSetVariableInt(gWarsawDragoonMaintain, cTrainPlanNumberToMaintain, 0, wantedDragoons);
   }

   debugMilitary("Warsaw army composition: Lancers=" + wantedLancers +
                 ", Hussars=" + wantedHussars +
                 ", Pikemen=" + wantedPikemen +
                 ", Skirmishers=" + wantedSkirmishers +
                 ", Dragoons=" + wantedDragoons);
}

//==============================================================================
// warsawEconomyManager
//==============================================================================
rule warsawEconomyManager
inactive
minInterval 60
{
   if (gWarsawCitizenshipSent == false)
   {
      if (kbTechGetStatus(cTechDEHCREVCitizenship) == cTechStatusActive)
      {
         gWarsawCitizenshipSent = true;
         debugMilitary("Warsaw: Citizenship active - Settlers enabled again!");
      }
      else
      {
         int tradingPosts = kbUnitCount(cMyID, cUnitTypeTradingPost, cUnitStateAlive);
         int factories = kbUnitCount(cMyID, cUnitTypeFactory, cUnitStateAlive);
         debugMilitary("Warsaw economy (pre-Citizenship): TradingPosts=" + tradingPosts +
                       " Factories=" + factories +
                       " Food=" + kbResourceGet(cResourceFood) +
                       " Gold=" + kbResourceGet(cResourceGold));
         return;
      }
   }

   int currentSettlers = kbUnitCount(cMyID, gEconUnit, cUnitStateAlive);
   int wantedSettlers = 25;

   float currentCoin = kbResourceGet(cResourceGold);
   if (currentCoin < 500)
   {
      wantedSettlers = 15;
   }

   if (kbProtoUnitAvailable(gEconUnit) == true && gWarsawSettlerMaintain == -1)
   {
      gWarsawSettlerMaintain = createSimpleMaintainPlan(gEconUnit, wantedSettlers, false, kbBaseGetMainID(cMyID), 1);
      aiPlanSetDesiredPriority(gWarsawSettlerMaintain, 70);
      aiPlanSetActive(gWarsawSettlerMaintain, true);
      debugMilitary("Warsaw: Created Settler maintain plan (post-Citizenship)");
   }
   else if (gWarsawSettlerMaintain >= 0)
   {
      aiPlanSetVariableInt(gWarsawSettlerMaintain, cTrainPlanNumberToMaintain, 0, wantedSettlers);
   }

   debugMilitary("Warsaw economy: Settlers=" + currentSettlers + "/" + wantedSettlers);
}

//==============================================================================
// warsawCardEffectTracker
//==============================================================================
rule warsawCardEffectTracker
inactive
minInterval 45
{
   if (gWarsawCitizenshipSent == false)
   {
      if (kbTechGetStatus(cTechDEHCREVCitizenship) == cTechStatusActive)
      {
         gWarsawCitizenshipSent = true;
         debugMilitary("Warsaw: Citizenship card active");
      }
   }

   if (gWarsawArmySent == false)
   {
      if (kbTechGetStatus(cTechDEHCREVShipWarsawArmy) == cTechStatusActive)
      {
         gWarsawArmySent = true;
         debugMilitary("Warsaw: Warsaw Army card active");
      }
   }

   if (gWarsawScythemenSent == false)
   {
      if (kbTechGetStatus(cTechDEHCREVShipScythemen) == cTechStatusActive)
      {
         gWarsawScythemenSent = true;
         debugMilitary("Warsaw: Scythemen card active");
      }
   }

   if (gWarsawCombatSent == false)
   {
      if (kbTechGetStatus(cTechDEHCREVWarsawCombat) == cTechStatusActive)
      {
         gWarsawCombatSent = true;
         debugMilitary("Warsaw: Warsaw Combat card active");
      }
   }
}

//==============================================================================
// warsawCardManager
//==============================================================================
rule warsawCardManager
inactive
minInterval 90
{
   int lancerCount = kbUnitCount(cMyID, cUnitTypedeREVPolishLancer, cUnitStateAlive);
   int hussarCount = kbUnitCount(cMyID, cUnitTypedeWingedHussar, cUnitStateAlive);
   int settlerCount = kbUnitCount(cMyID, gEconUnit, cUnitStateAlive);

   debugMilitary("Warsaw Card Manager: Lancers=" + lancerCount +
                 ", Hussars=" + hussarCount +
                 ", Settlers=" + settlerCount +
                 ", Citizenship=" + gWarsawCitizenshipSent +
                 ", ArmyCard=" + gWarsawArmySent +
                 ", Combat=" + gWarsawCombatSent);
}
