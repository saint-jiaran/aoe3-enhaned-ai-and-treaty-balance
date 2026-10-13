//==============================================================================
/* enhancedInit()
   This function is called before the loader file's preInit() function is 
   called in order to setup necessary naval logic and other enhancements.
*/
//==============================================================================
void enhancedInit(void)
{
   initEnhancedGlobals();

   // Reference the starting XP values for each player.
   // TODO: Investigate if there is a cleaner way to do this in XS scripting. Such as a keyed dictionary, object array, etc...
   // if (gXpValuePlayer1 == -1) {
   //    for (int player = 1; player < cNumberPlayers; player++) {
   //       int xpValue = kbResourceGetXP(player);
   //       if (player == 1) { gXpValuePlayer1 = xpValue; }
   //       if (player == 2) { gXpValuePlayer2 = xpValue; }
   //       if (player == 3) { gXpValuePlayer3 = xpValue; }
   //       if (player == 4) { gXpValuePlayer4 = xpValue; }
   //       if (player == 5) { gXpValuePlayer5 = xpValue; }
   //       if (player == 6) { gXpValuePlayer6 = xpValue; }
   //       if (player == 7) { gXpValuePlayer7 = xpValue; }
   //       if (player == 8) { gXpValuePlayer8 = xpValue; }
   //    }
   // }

   // Set early rush attempt based on civilization
   int rushRoll = aiRandInt(100);  // 0-99

   if ((cMyCiv == cCivXPAztec) ||
      (cMyCiv == cCivXPIroquois) ||
      (cMyCiv == cCivFrench) ||
      (cMyCiv == cCivRussians) ||
      (cMyCiv == cCivOttomans) ||
      (cMyCiv == cCivIndians) ||
      (cMyCiv == cCivDEMexicans))
   {
      // Top tier rush civs: 75% chance - We don't rush on island maps because we cannot do so anyway.
      if ((rushRoll < 75) && gIslandMap == false)
      {
         gEarlyRushAttempt = true;
         aiEcho("Early rush attempt ENABLED (top tier rush civ, rolled " + rushRoll + " < 75)");
      }
      else
      {
         gEarlyRushAttempt = false;
         aiEcho("Early rush attempt DISABLED (top tier rush civ, rolled " + rushRoll + " >= 75)");
      }
   }
   else
   {
      // Other civs: 40% chance - We don't rush on island maps because we cannot do so anyway.
      if ((rushRoll < 40) && gIslandMap == false)
      {
         gEarlyRushAttempt = true;
         aiEcho("Early rush attempt ENABLED (standard civ, rolled " + rushRoll + " < 40)");
      }
      else
      {
         gEarlyRushAttempt = false;
         aiEcho("Early rush attempt DISABLED (standard civ, rolled " + rushRoll + " >= 40)");
      }
   }

   if (gEarlyRushAttempt == true) {
      btRushBoom = btRushBoom + 0.2;
   }

   if (aiIsKOTHAllowed() == true) {
      xsEnableRule("kothManager");
      xsEnableRule("kothBaseManager");
      //xsEnableRule("checkEnemyNearKOTH");
   }

   xsEnableRule("maxOutVillagers");
   xsEnableRule("unfinishedBuildingMonitor");
   xsEnableRule("maxOutThatMilitaryBaby");
   // Enable new chats...
   xsEnableRule("myWallChat");
   xsEnableRule("enemyWallTaunt");
   //xsEnableRule("giveAdviceAndComments");
   xsEnableRule("boringChatter");
   xsEnableRule("manyPlayersComment");
   // Set the healing unit type.
   setHealingUnitType();
   xsEnableRule("healInjuredUnits");

   if ((cRandomMapName == "amazonia") || (cRandomMapName == "amazonialarge") || (cRandomMapName == "caribbean") || (cRandomMapName == "caribbeanlarge") ||
		(cRandomMapName == "ceylon") || (cRandomMapName == "ceylonlarge") || (cRandomMapName == "borneo") || (cRandomMapName == "borneolarge") ||
		(cRandomMapName == "honshu") || (cRandomMapName == "honshularge") || (cRandomMapName == "euarchipelago") ||
		(cRandomMapName == "euarchipelagolarge") || (cRandomMapName == "eusardiniacorsica")|| 
		(cRandomMapName == "eusardiniacorsicalarge") || (cRandomMapName == "euMediterranean")|| 
		(cRandomMapName == "euMediterraneanlarge") || (cRandomMapName == "eubaltic")|| 
		(cRandomMapName == "eubalticlarge") || (cRandomMapName == "indonesia") ||
		(cRandomMapName == "indonesialarge") || (cRandomMapName == "panama") ||
		(cRandomMapName == "panamalarge") || (cRandomMapName == "afswahilicoast") || (cRandomMapName == "afswahilicoastlarge") ||
      (cRandomMapName == "azores") || (cRandomMapName == "bpVirginIslands") || (cRandomMapName == "bpVirginIslandslarge") ||
      (cRandomMapName == "bpBeringStrait") || (cRandomMapName == "bpBeringStraitlarge") ||
      (cRandomMapName == "bpFaroeIslands") || (cRandomMapName == "bpFaroeIslandslarge") ||
      (cRandomMapName == "bpGoldCoastFort") || (cRandomMapName == "bpGoldCoastFortlarge") ||
      (cRandomMapName == "bpGotland") || (cRandomMapName == "bpGotlandlarge") ||
      (cRandomMapName == "bpGreenland") || (cRandomMapName == "bpGreenlandlarge") ||
      (cRandomMapName == "bpHeligoland") || (cRandomMapName == "bpHeligolandlarge") ||
      (cRandomMapName == "bpIceland") || (cRandomMapName == "bpIcelandlarge") ||
      (cRandomMapName == "bpHudsonBay") || (cRandomMapName == "bpHudsonBaylarge") ||
      (cRandomMapName == "bpNorthSea") || (cRandomMapName == "bpNorthSealarge") ||
      (cRandomMapName == "bpNorthwestPassage") || (cRandomMapName == "bpNorthwestPassagelarge") ||
      (cRandomMapName == "bpNorwegianSea") || (cRandomMapName == "bpNorwegianSealarge") ||
      (cRandomMapName == "bpNovaScotia") || (cRandomMapName == "bpNovaScotialarge") ||
      (cRandomMapName == "bpSouthNorway") || (cRandomMapName == "bpSouthNorwaylarge") ||
      (cRandomMapName == "bpSvalbard") || (cRandomMapName == "bpSvalbardlarge"))
   {
      aiSetWaterMap(true);
      gWaterMap = true;
	   gNavyMap = true;
      gIslandMap = true;
      gGoodFishingMap = true;
      xsEnableRule("dockWagonBuildPlanManager");
      xsEnableRule("newNavyManager");
      xsEnableRule("waterPatrol");
      xsEnableRule("waterWarShipPlans");
      xsEnableRule("warShipManager");
      xsEnableRule("getRandomDockToAttack");
      xsEnableRule("maintainFishingBoats");
      xsEnableRule("islandBaseManager");
      //xsEnableRule("colonyCreationManager");
      //dockWagonHandler();
      if (getUnit(cUnitTypeAbstractNuggetWater, cPlayerRelationAny, cUnitStateAlive) > 0) {
         xsEnableRule("warshipNuggetCollector");
      }
      if ((cRandomMapName == "amazonia") || (cRandomMapName == "amazonialarge") || (cRandomMapName == "caribbean") || (cRandomMapName == "caribbeanlarge") ||
		(cRandomMapName == "ceylon") || (cRandomMapName == "ceylonlarge") ||
		(cRandomMapName == "honshu") || (cRandomMapName == "honshularge") || (cRandomMapName == "euarchipelago") ||
		(cRandomMapName == "euarchipelagolarge") || (cRandomMapName == "eusardiniacorsica")|| 
		(cRandomMapName == "eusardiniacorsicalarge") || (cRandomMapName == "euMediterranean")|| 
		(cRandomMapName == "euMediterraneanlarge") || (cRandomMapName == "azores") ||
      (cRandomMapName == "bpVirginIslands") || (cRandomMapName == "bpVirginIslandslarge") ||
      (cRandomMapName == "bpGotland") || (cRandomMapName == "bpGotlandlarge") ||
      (cRandomMapName == "bpNorthSea") || (cRandomMapName == "bpNorthSealarge") ||
      (cRandomMapName == "bpNorthwestPassage") || (cRandomMapName == "bpNorthwestPassagelarge") ||
      (cRandomMapName == "bpNorwegianSea") || (cRandomMapName == "bpNorwegianSealarge") ||
      (cRandomMapName == "bpSvalbard") || (cRandomMapName == "bpSvalbardlarge")) {
         xsEnableRule("transportMilitaryNaval");
         xsEnableRule("invasionMilitaryManager");
      }
      if ((cRandomMapName == "euarchipelago") || (cRandomMapName == "euarchipelagolarge")) {
         xsEnableRule("archipelagoGo");
      }
      if ((cRandomMapName == "ceylon") || (cRandomMapName == "ceylonlarge") || (cRandomMapName == "afswahilicoast") ||
          (cRandomMapName == "afswahilicoastlarge")) {
         xsEnableRule("smallIslandMigration");
      }
   } else {
      gWaterMap = false;
	   gNavyMap = false;
      gIslandMap = false;
      gGoodFishingMap = false;
   }
   if ((cRandomMapName != "euarchipelago") && (cRandomMapName != "euarchipelagolarge")) {
      xsEnableRule("landPatrol");
   }
}
//==============================================================================
/* Monastery monitor
   Let's make sure we research those monastery techs!
*/
//==============================================================================
rule monasteryMonitor
inactive
minInterval 60
{
   int upgradePlanID = -1;
   int myMonasteryId = getUnit(cUnitTypeypMonastery, cMyID);

   if ((kbTechGetStatus(cTechypMonasteryCompunction) == cTechStatusActive) &&
       (((kbTechGetStatus(cTechypMonasteryJapaneseCombat) == cTechStatusActive) &&
       (kbTechGetStatus(cTechypMonasteryKillingBlowUpgrade) == cTechStatusActive) && 
       (kbTechGetStatus(cTechypMonasteryJapaneseHealing) == cTechStatusActive) &&
       (kbTechGetStatus(cTechypMonasteryRangedSplash) == cTechStatusActive) &&
       cMyCiv == cCivJapanese) ||
       ((kbTechGetStatus(cTechypMonasteryAttackSpeed) == cTechStatusActive) &&
       (kbTechGetStatus(cTechypMonasteryCriticalUpgrade) == cTechStatusActive) && 
       (kbTechGetStatus(cTechypMonasteryShaolinWarrior) == cTechStatusActive) &&
       (kbTechGetStatus(cTechypMonasteryDiscipleAura) == cTechStatusActive) &&
       cMyCiv == cCivChinese) ||
       ((kbTechGetStatus(cTechypMonasteryStompUpgrade) == cTechStatusActive) &&
       (kbTechGetStatus(cTechypMonasteryIndianSpeed) == cTechStatusActive) && 
       (kbTechGetStatus(cTechypMonasteryPetAura) == cTechStatusActive) &&
       (kbTechGetStatus(cTechypMonasteryImprovedHealing) == cTechStatusActive) &&
       cMyCiv == cCivIndians))
   )
   {
      xsDisableSelf();
      return;
   }

   if (civIsAsian() == false)
   {
      xsDisableSelf();
      return;
   }

   // Build a monastery if one does not exist...
   if ( (kbUnitCount(cMyID, cUnitTypeypMonastery, cUnitStateABQ) < 1) && (aiPlanGetIDByTypeAndVariableType(cPlanBuild, cBuildPlanBuildingTypeID, cUnitTypeypMonastery) < 0) ) 
   {
      createSimpleBuildPlan(cUnitTypeypMonastery, 1, 80, true, cEconomyEscrowID, kbBaseGetMainID(cMyID), 1);
      aiEcho("Starting a new monastery build plan.");
   }
   
   // All
   researchSimpleTechByCondition(cTechypMonasteryCompunction, 
   []() -> bool { return (kbTechGetStatus(cTechypMonasteryCompunction) == cTechStatusObtainable); },
   cUnitTypeypMonastery, myMonasteryId, 75);

   // Japanese
   researchSimpleTechByCondition(cTechypMonasteryJapaneseHealing, 
   []() -> bool { return (kbTechGetStatus(cTechypMonasteryJapaneseHealing) == cTechStatusObtainable); },
   cUnitTypeypMonastery, myMonasteryId, 75);
   researchSimpleTechByCondition(cTechypMonasteryJapaneseCombat, 
   []() -> bool { return (kbTechGetStatus(cTechypMonasteryJapaneseCombat) == cTechStatusObtainable); },
   cUnitTypeypMonastery, myMonasteryId, 75);
   researchSimpleTechByCondition(cTechypMonasteryKillingBlowUpgrade, 
   []() -> bool { return (kbTechGetStatus(cTechypMonasteryKillingBlowUpgrade) == cTechStatusObtainable); },
   cUnitTypeypMonastery, myMonasteryId, 75);
   researchSimpleTechByCondition(cTechypMonasteryRangedSplash, 
   []() -> bool { return (kbTechGetStatus(cTechypMonasteryRangedSplash) == cTechStatusObtainable); },
   cUnitTypeypMonastery, myMonasteryId, 75);

   // Chinese
   researchSimpleTechByCondition(cTechypMonasteryAttackSpeed, 
   []() -> bool { return (kbTechGetStatus(cTechypMonasteryAttackSpeed) == cTechStatusObtainable); },
   cUnitTypeypMonastery, myMonasteryId, 75);
   researchSimpleTechByCondition(cTechypMonasteryCriticalUpgrade, 
   []() -> bool { return (kbTechGetStatus(cTechypMonasteryCriticalUpgrade) == cTechStatusObtainable); },
   cUnitTypeypMonastery, myMonasteryId, 75);
   researchSimpleTechByCondition(cTechypMonasteryShaolinWarrior, 
   []() -> bool { return (kbTechGetStatus(cTechypMonasteryShaolinWarrior) == cTechStatusObtainable); },
   cUnitTypeypMonastery, myMonasteryId, 75);
   researchSimpleTechByCondition(cTechypMonasteryDiscipleAura, 
   []() -> bool { return (kbTechGetStatus(cTechypMonasteryDiscipleAura) == cTechStatusObtainable); },
   cUnitTypeypMonastery, myMonasteryId, 75);

   // Indians
   researchSimpleTechByCondition(cTechypMonasteryStompUpgrade, 
   []() -> bool { return (kbTechGetStatus(cTechypMonasteryStompUpgrade) == cTechStatusObtainable); },
   cUnitTypeypMonastery, myMonasteryId, 75);
   researchSimpleTechByCondition(cTechypMonasteryIndianSpeed, 
   []() -> bool { return (kbTechGetStatus(cTechypMonasteryIndianSpeed) == cTechStatusObtainable); },
   cUnitTypeypMonastery, myMonasteryId, 75);
   researchSimpleTechByCondition(cTechypMonasteryPetAura, 
   []() -> bool { return (kbTechGetStatus(cTechypMonasteryPetAura) == cTechStatusObtainable); },
   cUnitTypeypMonastery, myMonasteryId, 75);
   researchSimpleTechByCondition(cTechypMonasteryImprovedHealing, 
   []() -> bool { return (kbTechGetStatus(cTechypMonasteryImprovedHealing) == cTechStatusObtainable); },
   cUnitTypeypMonastery, myMonasteryId, 75);
}
//==============================================================================
/* factoryUpgradeMonitorNew
   Let's make sure we research factory upgrades!
*/
//==============================================================================
rule factoryUpgradeMonitorNew
inactive
minInterval 45
{
   int upgradePlanID = -1;
   int myFactoryId = getUnit(cUnitTypeFactory, cMyID);

   if (kbUnitCount(cMyID, cUnitTypeFactory, cUnitStateABQ) < 1)
   {
      return;
   }

   if ((kbTechGetStatus(cTechFactorySteamPower) == cTechStatusActive) &&
       (kbTechGetStatus(cTechFactoryMassProduction) == cTechStatusActive) &&
       ((kbTechGetStatus(cTechImperialBombard) == cTechStatusActive) ||
        (kbTechGetStatus(cTechImperialCannon) == cTechStatusActive) ||
        (kbTechGetStatus(cTechImperialRocket) == cTechStatusActive)))
   {
      xsDisableSelf();
      return;
   }

   researchSimpleTechByCondition(cTechFactoryMassProduction, 
   []() -> bool { return (kbTechGetStatus(cTechFactoryMassProduction) == cTechStatusObtainable); },
   cUnitTypeFactory, myFactoryId, 55);
   researchSimpleTechByCondition(cTechFactorySteamPower, 
   []() -> bool { return (kbTechGetStatus(cTechFactorySteamPower) == cTechStatusObtainable); },
   cUnitTypeFactory, myFactoryId, 55);
   researchSimpleTechByCondition(cTechImperialBombard, 
   []() -> bool { return (kbTechGetStatus(cTechImperialBombard) == cTechStatusObtainable); },
   cUnitTypeFactory, myFactoryId, 55);
   researchSimpleTechByCondition(cTechFactoryMassProduction, 
   []() -> bool { return (kbTechGetStatus(cTechFactoryMassProduction) == cTechStatusObtainable); },
   cUnitTypeFactory, myFactoryId, 55);
   researchSimpleTechByCondition(cTechImperialCannon, 
   []() -> bool { return (kbTechGetStatus(cTechImperialCannon) == cTechStatusObtainable); },
   cUnitTypeFactory, myFactoryId, 55);
   researchSimpleTechByCondition(cTechImperialRocket, 
   []() -> bool { return (kbTechGetStatus(cTechImperialRocket) == cTechStatusObtainable); },
   cUnitTypeFactory, myFactoryId, 55);
}

//==============================================================================
// fortManager
// Tries to maintain as many gFortUnit as gNumForts says.
//==============================================================================
rule fortManager
inactive
minInterval 20
{
   int numberOfForts = kbUnitCount(cMyID, gFortUnit, cUnitStateABQ);
   int buildLimit = kbGetBuildLimit(cMyID, gFortUnit);

   // Don't make any more Fort build plans if we're already at our calculated limit.
   if (kbUnitCount(cMyID, gFortUnit, cUnitStateABQ) >= buildLimit)
   {
      return;
   }
   aiEcho("Waiting to build a fort! Fort Limit: "+buildLimit+"Forts Constructed: "+numberOfForts+"");
   if ((aiPlanGetIDByTypeAndVariableType(cPlanBuild, cBuildPlanBuildingTypeID, gFortUnit) < 0) 
      && (numberOfForts < buildLimit) && (kbTechGetStatus(cTechHCXPUnlockFort2) == cTechStatusActive))
   {
      int fortBuildPlan = createSimpleBuildPlan(gFortUnit, 1, 100, false, cMilitaryEscrowID, kbBaseGetMainID(cMyID));
      //addBuilderToPlan(fortBuildPlan, cBuildPlanBuildingTypeID, 1);
      aiPlanAddUnitType(fortBuildPlan, cUnitTypeHero, 1, 1, 1);
      //aiTaskUnitWork(cUnitTypeExplorer, gFortUnit);
      aiEcho("Time to build a fort!");
   }
}
//==============================================================================
// dockManager
// Tries to maintain gDockUnits on naval maps.
//==============================================================================
rule dockManager
inactive
minInterval 20
{
   int numberOfDocks = kbUnitCount(cMyID, gDockUnit, cUnitStateABQ);
   int buildLimit = 7;//kbGetBuildLimit(cMyID, gDockUnit); Hard coded for now...

   // Don't make any more Dock build plans if we're already at our calculated limit.
   if (kbUnitCount(cMyID, gDockUnit, cUnitStateABQ) >= buildLimit)
   {
      return;
   }
   aiEcho("Waiting to build a dock! Dock Limit: "+buildLimit+"Docks Constructed: "+numberOfDocks+"");
   if ((aiPlanGetIDByTypeAndVariableType(cPlanBuild, cBuildPlanBuildingTypeID, gDockUnit) < 0) 
      && (numberOfDocks < buildLimit) && (kbGetAge() > cAge3) &&
      (kbResourceGet(cResourceWood) > 1500.0))
   {
      int dockBuildPlan = createSpacedBuildPlan(gDockUnit, 1, 80, false, cMilitaryEscrowID, kbBaseGetMainID(cMyID),
      1, -1, true, 7.0);
      // int dockBuildPlan = createDetailedBuildPlan(gDockUnit, 1, 80, false, cMilitaryEscrowID, kbBaseGetMainID(cMyID)
      // , 1, -1, true, -1, 15.0);
      //addBuilderToPlan(dockBuildPlan, cBuildPlanBuildingTypeID, 1);
      //aiTaskUnitWork(cUnitTypeExplorer, gDockUnit);
      aiEcho("Time to build a dock!");
   }
}
//==============================================================================
// germanVillagerManager
// This rule intends to force Germans to make their unique villagers.
//==============================================================================
rule germanVillagerManager
inactive
minInterval 40
{
   static int settlerWagonPlan = -1;
   int limit = 0;

   limit = kbGetBuildLimit(cMyID, cUnitTypeSettlerWagon);
   if (limit < 1)
      return;

   if (settlerWagonPlan < 0 && (kbTechGetStatus(cTechHCGermantownFarmers) == cTechStatusActive))
   {
      settlerWagonPlan = createSimpleMaintainPlan(cUnitTypeSettlerWagon, limit, true, kbBaseGetMainID(cMyID), 1);
      aiPlanSetDesiredPriority(settlerWagonPlan, 80);
      xsDisableSelf();
   } else if (settlerWagonPlan > 0) {
      aiPlanSetVariableInt(settlerWagonPlan, cTrainPlanNumberToMaintain, 0, limit);
   }

   // Settler wagons gather quicker, so we want them instead.
   if ((kbTechGetStatus(cTechHCGermantownFarmers) == cTechStatusActive) && aiPlanGetActive(settlerWagonPlan)) {
      int villagerQuery = createSimpleUnitQuery(cUnitTypeSettler, cMyID, cUnitStateAlive);
      int wagonQuery = createSimpleUnitQuery(cUnitTypeSettlerWagon, cMyID, cUnitStateAlive);
      int numberFound = kbUnitQueryExecute(wagonQuery);
      int numberVillagersFound = kbUnitQueryExecute(villagerQuery);
      if (numberFound < limit && 
         (kbTechGetStatus(cTechHCGermantownFarmers) == cTechStatusActive)) {
         int numberAdjustment = limit - numberFound;
         for (i = 0; i < (numberAdjustment * 2); i++)
         {
            if (i >= numberVillagersFound) {
               return;
            }
            int unit = kbUnitQueryGetResult(villagerQuery, i);
            if (kbUnitGetProtoUnitID(unit) != cUnitTypeSettlerWagon && 
                kbUnitCount(cMyID, gFarmUnit, cUnitStateABQ) > 0) {
               aiTaskUnitDelete(kbUnitQueryGetResult(villagerQuery, i));
            }
         }
      }
   }
}
//==============================================================================
// dutchBankManager
// Manages Dutch Banks, making sure we always sit at our Bank build limit.
// The limit grows with our age and with Home City cards, and Banks do get
// destroyed, so we keep checking and replace whatever we're missing.
//==============================================================================
rule dutchBankManager
inactive
minInterval 20
{
   int bankBuildLimit = kbGetBuildLimit(cMyID, cUnitTypeBank);
   if (bankBuildLimit < 1)
   {
      return;
   }

   // Everything we have or are about to have: standing/under construction Banks
   // plus the active Build Plans and the ones still waiting in the build queue.
   int bankCount = kbUnitCount(cMyID, cUnitTypeBank, cUnitStateABQ) +
                   aiPlanGetNumberByTypeAndVariableType(cPlanBuild, cBuildPlanBuildingTypeID, cUnitTypeBank, true) +
                   aiPlanGetNumberByTypeAndVariableType(cPlanBuild, cBuildPlanBuildingTypeID, cUnitTypeBank, false);
   int banksToBuild = bankBuildLimit - bankCount;
   int planID = -1;

   if (banksToBuild > 0)
   {
      // The extra plans are queued by createSimpleBuildPlan, so they don't grab
      // all of our Villagers at once.
      planID = createSimpleBuildPlan(cUnitTypeBank, banksToBuild, 93, true, cEconomyEscrowID, kbBaseGetMainID(cMyID), 1);
      if (bankCount < 1) // Our first Bank is worth going out of our way for.
      {
         aiPlanSetDesiredResourcePriority(planID, 85);
      }
      else
      {
         aiPlanSetDesiredResourcePriority(planID, 75);
      }
      debugEconomy("Dutch: Building " + banksToBuild + " more Bank(s), we have " + bankCount +
         " of " + bankBuildLimit);
   }
}
//==============================================================================
// chineseDiscipleManager
// This rule intends to force the Chinese to maintain disciples.
//==============================================================================
rule chineseDiscipleManager
inactive
minInterval 40
{
   static int disciplePlan = -1;
   int villagerPlan = -1;
   int limit = 0;

   limit = kbGetBuildLimit(cMyID, cUnitTypeypMonkDisciple);
   if (limit < 1)
      return;

   if (disciplePlan < 0)
   {
      disciplePlan = createSimpleMaintainPlan(cUnitTypeypMonkDisciple, limit, true, -1, 1);
      aiPlanSetDesiredPriority(disciplePlan, 85);
      aiPlanSetVariableInt(disciplePlan, cTrainPlanBuildFromType, 0, cUnitTypeHero);
      aiEcho("Disciples training!");
   }
   else
   {
      aiPlanSetVariableInt(disciplePlan, cTrainPlanNumberToMaintain, 0, limit);
   }
}
//==============================================================================
// japaneseShinobiManager
// This rule intends to force the Chinese to maintain disciples.
//==============================================================================
rule japaneseShinobiManager
inactive
minInterval 40
{
   static int shinobiPlan = -1;
   int villagerPlan = -1;
   int limit = 0;

   limit = kbGetBuildLimit(cMyID, cUnitTypeypShinobiHorse);
   if (limit < 1)
      return;

   if (shinobiPlan < 0)
   {
      shinobiPlan = createSimpleMaintainPlan(cUnitTypeypShinobiHorse, 10, true, -1, 1);
      aiPlanSetDesiredPriority(shinobiPlan, 85);
      aiPlanSetVariableInt(shinobiPlan, cTrainPlanBuildFromType, 0, cUnitTypeypShogunTokugawa);
      aiEcho("Shinobi training!");
   }
   else
   {
      aiPlanSetVariableInt(shinobiPlan, cTrainPlanNumberToMaintain, 0, 10);
   }
}
//==============================================================================
// eagleScoutManager
// This rule intends to force the Aztecs to maintain eagle scouts.
//==============================================================================
rule eagleScoutManager
inactive
minInterval 40
{
   static int eagleScoutPlan = -1;
   int villagerPlan = -1;
   int limit = 0;

   limit = kbGetBuildLimit(cMyID, cUnitTypedeEagleScout);
   if (limit < 1)
      return;

   if (eagleScoutPlan < 0)
   {
      eagleScoutPlan = createSimpleMaintainPlan(cUnitTypedeEagleScout, limit, true, -1, 1);
      aiPlanSetDesiredPriority(eagleScoutPlan, 85);
      aiPlanSetVariableInt(eagleScoutPlan, cTrainPlanBuildFromType, 0, cUnitTypeHero);
      aiEcho("Eagle Scout training!");
   }
   else
   {
      aiPlanSetVariableInt(eagleScoutPlan, cTrainPlanNumberToMaintain, 0, limit);
   }
}
//==============================================================================
// missionaryManager
// This rule intends to force the Spanish to maintain missionaries.
//==============================================================================
rule missionaryManager
inactive
minInterval 40
{
   static int missionaryPlan = -1;
   int limit = 0;

   limit = kbGetBuildLimit(cMyID, cUnitTypeMissionary);
   if (limit < 1)
      return;

   if (missionaryPlan < 0)
   {
      missionaryPlan = createSimpleMaintainPlan(cUnitTypeMissionary, limit, true, -1, 1);
      aiPlanSetDesiredPriority(missionaryPlan, 85);
      aiPlanSetVariableInt(missionaryPlan, cTrainPlanBuildFromType, 0, cUnitTypeChurch);
      aiEcho("Missionary training!");
   }
   else
   {
      aiPlanSetVariableInt(missionaryPlan, cTrainPlanNumberToMaintain, 0, limit);
   }
}
//==============================================================================
// addMissionariesToAttackPlan
// Finds idle or available Missionaries and assigns them to the active
// attack plan so they follow the army and heal during combat.
//==============================================================================
rule addMissionariesToAttackPlan
inactive
minInterval 20
maxInterval 30
{
   if (cMyCiv != cCivSpanish)
   {
      xsDisableSelf();
      return;
   }

   int targetPlanID = -1;
   int maxToAdd = 3;
   int i = 0;

   if (gIslandAssaultTransportPlanID >= 0 && aiPlanGetActive(gIslandAssaultTransportPlanID) == true)
   {
      targetPlanID = gIslandAssaultTransportPlanID;
   }
   else
   {
      int numberPlans = aiPlanGetActiveCount();
      int planID = -1;
      int bestLandUnits = 0;
      int landUnits = 0;

      for (i = 0; i < numberPlans; i++)
      {
         planID = aiPlanGetIDByActiveIndex(i);
         if (aiPlanGetType(planID) != cPlanCombat)
         {
            continue;
         }

         landUnits = aiPlanGetNumberUnits(planID, cUnitTypeLogicalTypeLandMilitary);
         if (landUnits > bestLandUnits)
         {
            bestLandUnits = landUnits;
            targetPlanID = planID;
         }
      }

      if (targetPlanID < 0 || bestLandUnits < 3)
      {
         gMissionariesWithArmy = 0;
         return;
      }

      if (bestLandUnits >= 20)
      {
         maxToAdd = 5;
      }
   }

   aiPlanAddUnitType(targetPlanID, cUnitTypeMissionary, 0, maxToAdd, maxToAdd);

   if (gMissionaryQuery == -1)
   {
      gMissionaryQuery = kbUnitQueryCreate("MissionaryAttackQuery");
      kbUnitQuerySetPlayerID(gMissionaryQuery, cMyID);
      kbUnitQuerySetUnitType(gMissionaryQuery, cUnitTypeMissionary);
      kbUnitQuerySetState(gMissionaryQuery, cUnitStateAlive);
   }

   kbUnitQueryResetResults(gMissionaryQuery);
   int numFound = kbUnitQueryExecute(gMissionaryQuery);

   int alreadyIn = aiPlanGetNumberUnits(targetPlanID, cUnitTypeMissionary);
   int added = 0;

   for (i = 0; i < numFound; i++)
   {
      if ((alreadyIn + added) >= maxToAdd)
      {
         break;
      }

      int unitID = kbUnitQueryGetResult(gMissionaryQuery, i);
      if (unitID < 0)
      {
         continue;
      }

      int currentPlanID = kbUnitGetPlanID(unitID);
      if (currentPlanID == targetPlanID)
      {
         continue;
      }
      if (currentPlanID >= 0)
      {
         aiPlanRemoveUnit(currentPlanID, unitID);
      }

      if (aiPlanAddUnit(targetPlanID, unitID) == true)
      {
         added++;
      }
   }

   gMissionariesWithArmy = aiPlanGetNumberUnits(targetPlanID, cUnitTypeMissionary);

   if (added > 0)
   {
      aiEcho("Sent " + added + " Missionaries to plan " + targetPlanID);
   }
}
//==============================================================================
// priestMonkManager
// This rule allows the AI to maintain a couple of healers.
//==============================================================================
rule priestMonkManager
inactive
minInterval 40
{
   static int priestMonkPlan = -1;
   int limit = 2;
   int priestMonkPriority = 70;
   int age = kbGetAge();

   int priestBuildLimit = kbGetBuildLimit(cMyID, cUnitTypePriest);
   if (priestBuildLimit < 1)
      return;

   if (priestMonkPlan < 0)
   {
      priestMonkPlan = createSimpleMaintainPlan(cUnitTypePriest, limit, true, -1, 1);
      aiPlanSetDesiredPriority(priestMonkPlan, priestMonkPriority);
      aiPlanSetVariableInt(priestMonkPlan, cTrainPlanBuildFromType, 0, cUnitTypeChurch);
      aiEcho("Priest and Monk training!");
   }
   else
   {
      aiPlanSetDesiredPriority(priestMonkPlan, priestMonkPriority);
      aiPlanSetVariableInt(priestMonkPlan, cTrainPlanNumberToMaintain, 0, limit);
   }
}
//==============================================================================
// healInjuredUnits
// Find injured land military units and assign priests/monks to heal them.
//==============================================================================
rule healInjuredUnits
inactive
minInterval 20
{
   int unitQuery = createSimpleUnitQuery(cUnitTypeLogicalTypeLandMilitary, cMyID, cUnitStateAlive);
   int numberUnits = kbUnitQueryExecute(unitQuery);

   int priestQuery = createSimpleUnitQuery(gHealingUnitType, cMyID, cUnitStateAlive);
   kbUnitQuerySetActionType(priestQuery, cActionTypeIdle);
   int numberPriests = kbUnitQueryExecute(priestQuery);

   int nextPriest = numberPriests - 1;
   int priestID = -1;
   int priestPlanID = -1;

   for (int healIndex = 0; healIndex < numberUnits; healIndex++)
   {
      if (nextPriest < 0)
      {
         break;
      }

      int unitID = kbUnitQueryGetResult(unitQuery, healIndex);
      if (kbUnitGetHealth(unitID) >= 1.0)
      {
         continue;
      }

      while (nextPriest >= 0)
      {
         priestID = kbUnitQueryGetResult(priestQuery, nextPriest);
         nextPriest--;

         priestPlanID = kbUnitGetPlanID(priestID);
         if (priestPlanID >= 0 && priestPlanID != gHealerPlan)
         {
            continue;
         }

         aiTaskUnitSpecialPower(priestID, cProtoPowerPowerHeal, unitID);
         break;
      }
   }
}
//==============================================================================
// feitoriaTCMonitor
// Portuguese should build maximum Town Centers when Feitoria is active.
//==============================================================================
rule feitoriaTCMonitor
inactive
minInterval 20
maxInterval 60
{
   // Only for Portuguese.
   if (cMyCiv != cCivPortuguese)
   {
      xsDisableSelf();
      return;
   }

   // Check if Feitoria tech is active.
   if (kbTechGetStatus(cTechDEHCFeitorias) != cTechStatusActive)
   {
      return;
   }
   
   int limit = kbGetBuildLimit(cMyID, cUnitTypeTownCenter);
   int unitQuery = createSimpleUnitQuery(cUnitTypeTownCenter, cMyID, cUnitStateABQ);
   int numberFound = kbUnitQueryExecute(unitQuery);
   int age = kbGetAge();

   //aiEcho("Feitorias Activity: "+kbTechGetStatus(cTechDEHCFeitorias)+" Limit, numberFound:"+limit+""+numberFound+"");

   if ((numberFound < limit) && (age >= cAge4))
   {
      //aiEcho("Feitorias Creation: "+kbTechGetStatus(cTechDEHCFeitorias)+"");
      createSimpleBuildPlan(cUnitTypeTownCenter, 1, 100, false, cEconomyEscrowID, kbBaseGetMainID(cMyID), 1);
   }
}
//==============================================================================
// warDogManager
// This rule intends to force European civs to maintain war dogs.
//==============================================================================
rule warDogManager
inactive
minInterval 40
{
   static int warDogPlan = -1;
   int limit = 0;

   limit = kbGetBuildLimit(cMyID, cUnitTypeWarDog);
   if (limit < 1)
      return;

   if (warDogPlan < 0)
   {
      warDogPlan = createSimpleMaintainPlan(cUnitTypeWarDog, limit, true, -1, 1);
      aiPlanSetDesiredPriority(warDogPlan, 85);
      aiPlanSetVariableInt(warDogPlan, cTrainPlanBuildFromType, 0, cUnitTypeHero);
      aiEcho("War Dog training!");
   }
   else
   {
      aiPlanSetVariableInt(warDogPlan, cTrainPlanNumberToMaintain, 0, limit);
   }
}
//==============================================================================
// architectManager
// This rule intends to force the Italians to maintain architects.
//==============================================================================
rule architectManager
inactive
minInterval 40
{
   static int architectPlan = -1;
   int limit = 0;

   limit = kbGetBuildLimit(cMyID, cUnitTypedeArchitect);
   if (limit < 1)
      return;

   if (architectPlan < 0)
   {
      architectPlan = createSimpleMaintainPlan(cUnitTypedeArchitect, limit, true, -1, 1);
      aiPlanSetDesiredPriority(architectPlan, 85);
      aiPlanSetVariableInt(architectPlan, cTrainPlanBuildFromType, 0, cUnitTypeTownCenter);
      aiEcho("Architect training!");
   }
   else
   {
      aiPlanSetVariableInt(architectPlan, cTrainPlanNumberToMaintain, 0, limit);
   }
}
//==============================================================================
// royalDecreeMonitor
// This rule makes the AI research their unique church technologies and use
// their unique church units.
//==============================================================================
rule royalDecreeMonitor
inactive
minInterval 20
{
   int decreePlanID = -1;
   int myChurchId = getUnit(cUnitTypeAbstractChurch, cMyID);
   bool canDisableSelf = false;

   if ((civIsNative() == true) || (civIsAsian() == true))
   {
      xsDisableSelf();
      return;
   }

   switch(kbGetCiv())
   {
      case cCivBritish:
      {
         if ((kbTechGetStatus(cTechChurchThinRedLine) == cTechStatusActive) &&
             (kbTechGetStatus(cTechChurchBlackWatch) == cTechStatusActive) &&
             (kbTechGetStatus(cTechChurchRogersRangers) == cTechStatusActive) &&
             (kbTechGetStatus(cTechDEChurchRogersRangers) == cTechStatusActive))
         {
            xsDisableSelf();
            return;
         }

         researchSimpleTechByCondition(cTechChurchThinRedLine, 
         []() -> bool { return (kbTechGetStatus(cTechChurchThinRedLine) == cTechStatusObtainable); },
         cUnitTypeChurch, myChurchId, 75);

         researchSimpleTechByCondition(cTechChurchBlackWatch, 
         []() -> bool { return (kbTechGetStatus(cTechChurchBlackWatch) == cTechStatusObtainable); },
         cUnitTypeChurch, myChurchId, 75);

         researchSimpleTechByCondition(cTechChurchRogersRangers, 
         []() -> bool { return (kbTechGetStatus(cTechChurchRogersRangers) == cTechStatusObtainable); },
         cUnitTypeChurch, myChurchId, 75);

         researchSimpleTechByCondition(cTechDEChurchRogersRangers, 
         []() -> bool { return (kbTechGetStatus(cTechDEChurchRogersRangers) == cTechStatusObtainable); },
         cUnitTypeChurch, myChurchId, 75);
         break;
      }
      case cCivDutch:
      {
         if ((kbTechGetStatus(cTechChurchCoffeeTrade) == cTechStatusActive) &&
             (kbTechGetStatus(cTechChurchWaardgelders) == cTechStatusActive) &&
             (kbTechGetStatus(cTechChurchStadholders) == cTechStatusActive) &&
             (kbTechGetStatus(cTechDEHCBlueGuards) == cTechStatusActive))
         {
            xsDisableSelf();
            return;
         }

         researchSimpleTechByCondition(cTechChurchCoffeeTrade, 
         []() -> bool { return (kbTechGetStatus(cTechChurchCoffeeTrade) == cTechStatusObtainable); },
         cUnitTypeChurch, myChurchId, 75);

         researchSimpleTechByCondition(cTechChurchWaardgelders, 
         []() -> bool { return (kbTechGetStatus(cTechChurchWaardgelders) == cTechStatusObtainable); },
         cUnitTypeChurch, myChurchId, 75);

         researchSimpleTechByCondition(cTechChurchStadholders, 
         []() -> bool { return (kbTechGetStatus(cTechChurchStadholders) == cTechStatusObtainable); },
         cUnitTypeChurch, myChurchId, 75);

         researchSimpleTechByCondition(cTechDEHCBlueGuards, 
         []() -> bool { return (kbTechGetStatus(cTechDEHCBlueGuards) == cTechStatusObtainable); },
         cUnitTypeChurch, myChurchId, 75);
         break;
      }
      case cCivFrench:
      {
         if ((kbTechGetStatus(cTechChurchCodeNapoleon) == cTechStatusActive) &&
             (kbTechGetStatus(cTechChurchGardeImperial1) == cTechStatusActive) &&
             (kbTechGetStatus(cTechChurchGardeImperial2) == cTechStatusActive) &&
             (kbTechGetStatus(cTechChurchGardeImperial3) == cTechStatusActive))
         {
            xsDisableSelf();
            return;
         }

         researchSimpleTechByCondition(cTechChurchCodeNapoleon, 
         []() -> bool { return (kbTechGetStatus(cTechChurchCodeNapoleon) == cTechStatusObtainable); },
         cUnitTypeChurch, myChurchId, 75);

         researchSimpleTechByCondition(cTechChurchGardeImperial1, 
         []() -> bool { return (kbTechGetStatus(cTechChurchGardeImperial1) == cTechStatusObtainable); },
         cUnitTypeChurch, myChurchId, 75);

         researchSimpleTechByCondition(cTechChurchGardeImperial2, 
         []() -> bool { return (kbTechGetStatus(cTechChurchGardeImperial2) == cTechStatusObtainable); },
         cUnitTypeChurch, myChurchId, 75);

         researchSimpleTechByCondition(cTechChurchGardeImperial3, 
         []() -> bool { return (kbTechGetStatus(cTechChurchGardeImperial3) == cTechStatusObtainable); },
         cUnitTypeChurch, myChurchId, 75);
         break;
      }
      case cCivGermans:
      {
         if ((kbTechGetStatus(cTechChurchTillysDiscipline) == cTechStatusActive) &&
             (kbTechGetStatus(cTechChurchZweihander) == cTechStatusActive) &&
             (kbTechGetStatus(cTechChurchWallensteinsContracts) == cTechStatusActive))
         {
            xsDisableSelf();
            return;
         }

         researchSimpleTechByCondition(cTechChurchTillysDiscipline, 
         []() -> bool { return (kbTechGetStatus(cTechChurchTillysDiscipline) == cTechStatusObtainable); },
         cUnitTypeChurch, myChurchId, 75);

         researchSimpleTechByCondition(cTechChurchWallensteinsContracts, 
         []() -> bool { return (kbTechGetStatus(cTechChurchWallensteinsContracts) == cTechStatusObtainable); },
         cUnitTypeChurch, myChurchId, 75);

         researchSimpleTechByCondition(cTechChurchZweihander, 
         []() -> bool { return (kbTechGetStatus(cTechChurchZweihander) == cTechStatusObtainable); },
         cUnitTypeChurch, myChurchId, 75);
         break;
      }
      case cCivOttomans:
      {
         if ((kbTechGetStatus(cTechChurchTufanciCorps) == cTechStatusActive) &&
             (kbTechGetStatus(cTechChurchTopcuCorps) == cTechStatusActive) &&
             (kbTechGetStatus(cTechChurchKapikuluCorps) == cTechStatusActive))
         {
            xsDisableSelf();
            return;
         }

         researchSimpleTechByCondition(cTechChurchTufanciCorps, 
         []() -> bool { return (kbTechGetStatus(cTechChurchTufanciCorps) == cTechStatusObtainable); },
         cUnitTypeChurch, myChurchId, 75);

         researchSimpleTechByCondition(cTechChurchKapikuluCorps, 
         []() -> bool { return (kbTechGetStatus(cTechChurchKapikuluCorps) == cTechStatusObtainable); },
         cUnitTypeChurch, myChurchId, 75);

         researchSimpleTechByCondition(cTechChurchTopcuCorps, 
         []() -> bool { return (kbTechGetStatus(cTechChurchTopcuCorps) == cTechStatusObtainable); },
         cUnitTypeChurch, myChurchId, 75);
         break;
      }
      case cCivPortuguese:
      {
         if ((kbTechGetStatus(cTechChurchBestieros) == cTechStatusActive) &&
             (kbTechGetStatus(cTechChurchTowerAndSword) == cTechStatusActive) &&
             (kbTechGetStatus(cTechChurchEconmediaManor) == cTechStatusActive))
         {
            xsDisableSelf();
            return;
         }

         researchSimpleTechByCondition(cTechChurchBestieros, 
         []() -> bool { return (kbTechGetStatus(cTechChurchBestieros) == cTechStatusObtainable); },
         cUnitTypeChurch, myChurchId, 75);

         researchSimpleTechByCondition(cTechChurchEconmediaManor, 
         []() -> bool { return (kbTechGetStatus(cTechChurchEconmediaManor) == cTechStatusObtainable); },
         cUnitTypeChurch, myChurchId, 75);

         researchSimpleTechByCondition(cTechChurchTowerAndSword, 
         []() -> bool { return (kbTechGetStatus(cTechChurchTowerAndSword) == cTechStatusObtainable); },
         cUnitTypeChurch, myChurchId, 75);
         break;
      }
      case cCivRussians:
      {
         if ((kbTechGetStatus(cTechChurchWesternization) == cTechStatusActive) &&
             (kbTechGetStatus(cTechChurchPetrineReforms) == cTechStatusActive) &&
             (kbTechGetStatus(cTechChurchKalmucks) == cTechStatusActive) &&
             (kbTechGetStatus(cTechChurchBashkirPonies) == cTechStatusActive))
         {
            xsDisableSelf();
            return;
         }

         researchSimpleTechByCondition(cTechChurchWesternization, 
         []() -> bool { return (kbTechGetStatus(cTechChurchWesternization) == cTechStatusObtainable); },
         cUnitTypeChurch, myChurchId, 75);

         researchSimpleTechByCondition(cTechChurchPetrineReforms, 
         []() -> bool { return (kbTechGetStatus(cTechChurchPetrineReforms) == cTechStatusObtainable); },
         cUnitTypeChurch, myChurchId, 75);

         researchSimpleTechByCondition(cTechChurchKalmucks, 
         []() -> bool { return (kbTechGetStatus(cTechChurchKalmucks) == cTechStatusObtainable); },
         cUnitTypeChurch, myChurchId, 75);

         researchSimpleTechByCondition(cTechChurchBashkirPonies, 
         []() -> bool { return (kbTechGetStatus(cTechChurchBashkirPonies) == cTechStatusObtainable); },
         cUnitTypeChurch, myChurchId, 75);
         break;
      }
      case cCivSpanish:
      {
         if ((kbTechGetStatus(cTechChurchCorsolet) == cTechStatusActive) &&
             (kbTechGetStatus(cTechChurchQuatrefage) == cTechStatusActive) &&
             (kbTechGetStatus(cTechChurchWildGeeseSpanish) == cTechStatusActive) &&
             (kbTechGetStatus(cTechChurchWalloonGuards) == cTechStatusActive))
         {
            xsDisableSelf();
            return;
         }

         researchSimpleTechByCondition(cTechChurchCorsolet, 
         []() -> bool { return (kbTechGetStatus(cTechChurchCorsolet) == cTechStatusObtainable); },
         cUnitTypeChurch, myChurchId, 75);

         researchSimpleTechByCondition(cTechChurchQuatrefage, 
         []() -> bool { return (kbTechGetStatus(cTechChurchQuatrefage) == cTechStatusObtainable); },
         cUnitTypeChurch, myChurchId, 75);

         researchSimpleTechByCondition(cTechChurchWildGeeseSpanish, 
         []() -> bool { return (kbTechGetStatus(cTechChurchWildGeeseSpanish) == cTechStatusObtainable); },
         cUnitTypeChurch, myChurchId, 75);

         researchSimpleTechByCondition(cTechChurchWalloonGuards, 
         []() -> bool { return (kbTechGetStatus(cTechChurchWalloonGuards) == cTechStatusObtainable); },
         cUnitTypeChurch, myChurchId, 75);
         break;
      }
      case cCivDESwedish:
      {
         if ((kbTechGetStatus(cTechDEChurchGustavianGuards) == cTechStatusActive) &&
             (kbTechGetStatus(cTechDEChurchPikePush) == cTechStatusActive) &&
             (kbTechGetStatus(cTechDEChurchSavolaxJaegers) == cTechStatusActive))
         {
            xsDisableSelf();
            return;
         }

         researchSimpleTechByCondition(cTechDEChurchGustavianGuards, 
         []() -> bool { return (kbTechGetStatus(cTechDEChurchGustavianGuards) == cTechStatusObtainable); },
         cUnitTypeChurch, myChurchId, 75);

         researchSimpleTechByCondition(cTechDEChurchPikePush, 
         []() -> bool { return (kbTechGetStatus(cTechDEChurchPikePush) == cTechStatusObtainable); },
         cUnitTypeChurch, myChurchId, 75);

         researchSimpleTechByCondition(cTechDEChurchSavolaxJaegers, 
         []() -> bool { return (kbTechGetStatus(cTechDEChurchSavolaxJaegers) == cTechStatusObtainable); },
         cUnitTypeChurch, myChurchId, 75);
         break;
      }
      case cCivDEItalians:
      {
         if ((kbTechGetStatus(cTechDEChurchCarabinieri) == cTechStatusActive) &&
             (kbTechGetStatus(cTechDEChurchRisorgimento) == cTechStatusActive) &&
             (kbTechGetStatus(cTechDEChurchPapacy) == cTechStatusActive))
         {
            xsDisableSelf();
            return;
         }

         researchSimpleTechByCondition(cTechDEChurchCarabinieri, 
         []() -> bool { return (kbTechGetStatus(cTechDEChurchCarabinieri) == cTechStatusObtainable); },
         cUnitTypeAbstractChurch, myChurchId, 75);

         researchSimpleTechByCondition(cTechDEChurchRisorgimento, 
         []() -> bool { return (kbTechGetStatus(cTechDEChurchRisorgimento) == cTechStatusObtainable); },
         cUnitTypeAbstractChurch, myChurchId, 75);

         researchSimpleTechByCondition(cTechDEChurchPapacy, 
         []() -> bool { return (kbTechGetStatus(cTechDEChurchPapacy) == cTechStatusObtainable); },
         cUnitTypeAbstractChurch, myChurchId, 75);
         break;
      }
      case cCivDEMaltese:
      {
         if ((kbTechGetStatus(cTechDEChurchTeutonicKnights) == cTechStatusActive) &&
             (kbTechGetStatus(cTechDEChurchRisorgimento) == cTechStatusActive) &&
             (kbTechGetStatus(cTechDEChurchPapacy) == cTechStatusActive))
         {
            xsDisableSelf();
            return;
         }

         researchSimpleTechByCondition(cTechDEChurchTeutonicKnights, 
         []() -> bool { return (kbTechGetStatus(cTechDEChurchTeutonicKnights) == cTechStatusObtainable); },
         cUnitTypeChurch, myChurchId, 75);

         researchSimpleTechByCondition(cTechDEChurchKnightsHospital, 
         []() -> bool { return (kbTechGetStatus(cTechDEChurchKnightsHospital) == cTechStatusObtainable); },
         cUnitTypeChurch, myChurchId, 75);

         researchSimpleTechByCondition(cTechDEChurchCrusaderKnights, 
         []() -> bool { return (kbTechGetStatus(cTechDEChurchCrusaderKnights) == cTechStatusObtainable); },
         cUnitTypeChurch, myChurchId, 75);
         break;
      }
      case cCivDEDanish:
      {
         if ((kbTechGetStatus(cTechDEChurchStruenseeReforms) == cTechStatusActive) &&
             (kbTechGetStatus(cTechDEChurchZealandBosniaks) == cTechStatusActive) &&
             (kbTechGetStatus(cTechDEChurchEspingolen) == cTechStatusActive))
         {
            xsDisableSelf();
            return;
         }

         researchSimpleTechByCondition(cTechDEChurchStruenseeReforms, 
         []() -> bool { return (kbTechGetStatus(cTechDEChurchStruenseeReforms) == cTechStatusObtainable); },
         cUnitTypeAbstractChurch, myChurchId, 75);

         researchSimpleTechByCondition(cTechDEChurchZealandBosniaks, 
         []() -> bool { return (kbTechGetStatus(cTechDEChurchZealandBosniaks) == cTechStatusObtainable); },
         cUnitTypeAbstractChurch, myChurchId, 75);

         researchSimpleTechByCondition(cTechDEChurchEspingolen, 
         []() -> bool { return (kbTechGetStatus(cTechDEChurchEspingolen) == cTechStatusObtainable); },
         cUnitTypeAbstractChurch, myChurchId, 75);
         break;
      }
      case cCivDEPolish:
      {
         if ((kbTechGetStatus(cTechDEChurchLiberumVeto) == cTechStatusActive) &&
             (kbTechGetStatus(cTechDEChurchCrownJanissaries) == cTechStatusActive) &&
             (kbTechGetStatus(cTechDEChurchCrownGrenadiers) == cTechStatusActive) &&
             (kbTechGetStatus(cTechDEChurchBarConfederation) == cTechStatusActive))
         {
            xsDisableSelf();
            return;
         }

         researchSimpleTechByCondition(cTechDEChurchLiberumVeto, 
         []() -> bool { return (kbTechGetStatus(cTechDEChurchLiberumVeto) == cTechStatusObtainable); },
         cUnitTypeAbstractChurch, myChurchId, 75);

         researchSimpleTechByCondition(cTechDEChurchCrownJanissaries, 
         []() -> bool { return (kbTechGetStatus(cTechDEChurchCrownJanissaries) == cTechStatusObtainable); },
         cUnitTypeAbstractChurch, myChurchId, 75);

         researchSimpleTechByCondition(cTechDEChurchCrownGrenadiers, 
         []() -> bool { return (kbTechGetStatus(cTechDEChurchCrownGrenadiers) == cTechStatusObtainable); },
         cUnitTypeAbstractChurch, myChurchId, 75);

         researchSimpleTechByCondition(cTechDEChurchBarConfederation, 
         []() -> bool { return (kbTechGetStatus(cTechDEChurchBarConfederation) == cTechStatusObtainable); },
         cUnitTypeAbstractChurch, myChurchId, 75);
         break;
      }
   }
}
//==============================================================================
// florenceNightingaleMonitor
// We want our military to heal by a manor while idle if we have this technology,
// so we need to set the military gather point near a manor.
//==============================================================================
rule florenceNightingaleMonitor
inactive
minInterval 30 
{
   if (cMyCiv != cCivBritish)
   {
       xsDisableSelf();
       return;
   }

   if (kbTechGetStatus(cTechHCXPFlorenceNightingale) != cTechStatusActive)
   {
      return;
   }

   if ((gFlorenceNightingaleHouseId >= 0) &&
      (kbUnitGetCurrentHitpoints(gFlorenceNightingaleHouseId) > 0.0))
   {
      return;
   }

   vector mainBaseLoc = kbBaseGetLocation(cMyID, kbBaseGetMainID(cMyID));
   int unitQueryID = createSimpleUnitQuery(cUnitTypeManor, cMyID, cUnitStateAlive, mainBaseLoc, 100.0);
   int numberFound = kbUnitQueryExecute(unitQueryID);
   if (numberFound <= 0)
   {
      gFlorenceNightingaleHouseId = -1;
      return;
   }

   int unitID = kbUnitQueryGetResult(unitQueryID, 0);
   if (unitID < 0)
   {
      gFlorenceNightingaleHouseId = -1;
      return;
   }

   gFlorenceNightingaleHouseId = unitID;
   kbBaseSetMilitaryGatherPoint(cMyID, kbBaseGetMainID(cMyID), kbUnitGetPosition(unitID));
}
//==============================================================================
// capitolUpgradeMonitor
// Make sure we research technologies at this building.
//==============================================================================
rule capitolUpgradeMonitor
inactive
minInterval 30 
{
   int upgradePlanID = -1;
   int myCapitolId = getUnit(cUnitTypeCapitol, cMyID);

   // Spanish use their own Imperial Knighthood/Peerage variants.
   int knighthoodTech = cTechImpKnighthood;
   int peerageTech = cTechImpPeerage;
   if (cMyCiv == cCivSpanish)
   {
      knighthoodTech = cTechImpKnighthoodSpain;
      peerageTech = cTechImpPeerageSpain;
   }

   if ((kbTechGetStatus(cTechImpExcessiveTaxation) == cTechStatusActive) &&
       (kbTechGetStatus(cTechImpDeforestation) == cTechStatusActive) &&       
       (kbTechGetStatus(cTechImpLargeScaleAgriculture) == cTechStatusActive) &&
       (kbTechGetStatus(knighthoodTech) == cTechStatusActive) &&
       (kbTechGetStatus(cTechImpImmigrants) == cTechStatusActive) &&
       (kbTechGetStatus(peerageTech) == cTechStatusActive) &&
       (kbTechGetStatus(cTechImpLegendaryNatives) == cTechStatusActive))
   {
       xsDisableSelf();
       return;
   }
  
   researchSimpleTechByCondition(cTechImpExcessiveTaxation, 
   []() -> bool { return (kbTechGetStatus(cTechImpExcessiveTaxation) == cTechStatusObtainable); },
   cUnitTypeCapitol, myCapitolId, 55);
   researchSimpleTechByCondition(cTechImpDeforestation, 
   []() -> bool { return (kbTechGetStatus(cTechImpDeforestation) == cTechStatusObtainable); },
   cUnitTypeCapitol, myCapitolId, 55);
   researchSimpleTechByCondition(cTechImpLargeScaleAgriculture, 
   []() -> bool { return (kbTechGetStatus(cTechImpLargeScaleAgriculture) == cTechStatusObtainable); },
   cUnitTypeCapitol, myCapitolId, 55);
   researchSimpleTech(knighthoodTech, cUnitTypeCapitol, myCapitolId, 25);
   researchSimpleTechByCondition(cTechImpImmigrants, 
   []() -> bool { return (kbTechGetStatus(cTechImpImmigrants) == cTechStatusObtainable); },
   cUnitTypeCapitol, myCapitolId, 25);
   researchSimpleTech(peerageTech, cUnitTypeCapitol, myCapitolId, 25);
   researchSimpleTechByCondition(cTechImpLegendaryNatives,
   []() -> bool { return (kbTechGetStatus(cTechImpLegendaryNatives) == cTechStatusObtainable); },
   cUnitTypeCapitol, myCapitolId, 40);

}
//==============================================================================
// livestockUpgradeMonitor
// Research the user-added Livestock Pen tech (DEFullingMills) when obtainable.
//==============================================================================
rule livestockUpgradeMonitor
inactive
minInterval 60
{
   if (kbUnitCount(cMyID, gLivestockPenUnit, cUnitStateABQ) < 1)
   {
      return;
   }

   researchSimpleTech(cTechDEFullingMills, gLivestockPenUnit, -1, 40);

   if ((kbTechGetStatus(cTechDEFullingMills) == cTechStatusActive) ||
       (kbTechGetStatus(cTechDEFullingMills) == cTechStatusUnobtainable))
   {
      xsDisableSelf();
   }
}
//==============================================================================
// nativeCapitolUpgradeMonitor
// Make sure we research technologies at this building.
//==============================================================================
rule nativeCapitolUpgradeMonitor
inactive
minInterval 30 
{
   int upgradePlanID = -1;
   int myEstateId = getUnit(cUnitTypePlantation, cMyID);
   int myMarketId = getUnit(cUnitTypeMarket, cMyID);
   int myFarmId = getUnit(cUnitTypeFarm, cMyID);
   int myTownCenterId = getUnit(cUnitTypeTownCenter, cMyID);

   if ((kbTechGetStatus(cTechImpExcessiveTributeNative) == cTechStatusActive) &&
       (kbTechGetStatus(cTechImpDeforestationNative) == cTechStatusActive) &&       
       (kbTechGetStatus(cTechImpLargeScaleGathering) == cTechStatusActive) &&
       (kbTechGetStatus(cTechImpImmigrantsNative) == cTechStatusActive) &&
       (kbTechGetStatus(cTechImpLegendaryNativesNatives) == cTechStatusActive))
   {
       xsDisableSelf();
       return;
   }
  
   researchSimpleTechByCondition(cTechImpExcessiveTributeNative, 
   []() -> bool { return (kbTechGetStatus(cTechImpExcessiveTributeNative) == cTechStatusObtainable); },
   cUnitTypePlantation, myEstateId, 55);
   researchSimpleTechByCondition(cTechImpDeforestationNative, 
   []() -> bool { return (kbTechGetStatus(cTechImpDeforestation) == cTechStatusObtainable); },
   cUnitTypeMarket, myMarketId, 55);
   researchSimpleTechByCondition(cTechImpLargeScaleGathering,
   []() -> bool { return (kbTechGetStatus(cTechImpLargeScaleGathering) == cTechStatusObtainable); },
   cUnitTypeFarm, myFarmId, 55);
   researchSimpleTechByCondition(cTechImpImmigrantsNative,
   []() -> bool { return (kbTechGetStatus(cTechImpImmigrantsNative) == cTechStatusObtainable); },
   cUnitTypeTownCenter, myTownCenterId, 25);
   researchSimpleTechByCondition(cTechImpLegendaryNativesNatives,
   []() -> bool { return (kbTechGetStatus(cTechImpLegendaryNativesNatives) == cTechStatusObtainable); },
   cUnitTypeTownCenter, myTownCenterId, 40);
}
//==============================================================================
// asianCapitolUpgradeMonitor
// Make sure we research technologies at this building.
//==============================================================================
rule asianCapitolUpgradeMonitor
inactive
minInterval 30 
{
   int upgradePlanID = -1;
   int myEstateId = getUnit(cUnitTypeypRicePaddy, cMyID);
   int myMarketId = getUnit(cUnitTypeypTradeMarketAsian, cMyID);
   int myFarmId = getUnit(cUnitTypeFarm, cMyID);
   int myTownCenterId = getUnit(cUnitTypeTownCenter, cMyID);

   if ((kbTechGetStatus(cTechypImpExcessiveTributeAsian) == cTechStatusActive) &&
       (kbTechGetStatus(cTechImpDeforestationNative) == cTechStatusActive) &&       
       (kbTechGetStatus(cTechypImpLargeScaleAgricultureAsian) == cTechStatusActive) &&
       (kbTechGetStatus(cTechImpImmigrantsNative) == cTechStatusActive) &&
       (kbTechGetStatus(cTechypImpLegendaryNatives2) == cTechStatusActive) &&
       (kbTechGetStatus(cTechDEHCTeaExport2) == cTechStatusActive))
   {
       xsDisableSelf();
       return;
   }

   researchSimpleTechByCondition(cTechypImpExcessiveTributeAsian, 
   []() -> bool { return (kbTechGetStatus(cTechypImpExcessiveTributeAsian) == cTechStatusObtainable); },
   cUnitTypeypRicePaddy, myEstateId, 55);
   researchSimpleTechByCondition(cTechypImpDeforestationAsian, 
   []() -> bool { return (kbTechGetStatus(cTechypImpDeforestationAsian) == cTechStatusObtainable); },
   cUnitTypeypTradeMarketAsian, myMarketId, 55);
   researchSimpleTechByCondition(cTechypImpLargeScaleAgricultureAsian,
   []() -> bool { return (kbTechGetStatus(cTechypImpLargeScaleAgricultureAsian) == cTechStatusObtainable); },
   cUnitTypeypRicePaddy, myEstateId, 55);
   researchSimpleTechByCondition(cTechImpImmigrantsNative,
   []() -> bool { return (kbTechGetStatus(cTechImpImmigrantsNative) == cTechStatusObtainable); },
   cUnitTypeTownCenter, myTownCenterId, 25);
   researchSimpleTechByCondition(cTechypImpLegendaryNatives2,
   []() -> bool { return (kbTechGetStatus(cTechypImpLegendaryNatives2) == cTechStatusObtainable); },
   cUnitTypeTownCenter, myTownCenterId, 40);
   researchSimpleTechByCondition(cTechDEHCTeaExport2,
   []() -> bool { return (kbTechGetStatus(cTechDEHCTeaExport2) == cTechStatusObtainable); },
   cUnitTypeTownCenter, myTownCenterId, 40);
}
//==============================================================================
/* sejmUpgradeMonitor

   Poland's Sejm policies.

   The Sejm offers three economic ladders and a spread of military policies. Each
   economic ladder is three steps, and a later step only becomes obtainable once the one
   below it is in, so we can simply offer every tech every pass and let the engine's
   obtainable status decide what is actually available - the same approach
   capitolUpgradeMonitor takes.

     Food1/2/3   boost Folwark food gathering
     Wood1/2/3   boost wood from trees
     Coin1/2/3   boost coin from plantations, mines and mountain monasteries

   The economic ladder matching whatever we are shortest of gets the high resource
   priority; the other two stay low so they are picked up out of surplus rather than
   competing with what we actually need.

   The military policies are shipment-style: General Levy and General Defense hand over
   free cavalry cheaply, Piechota and Army give free infantry and Winged Hussars, and the
   Hetman line is a straight unit upgrade. Congress is expensive but permanently improves
   what the Sejm trickles, so it is worth taking once the economy can carry it.

   Deliberately no xsDisableSelf(): several of these only become obtainable in later ages
   or after earlier steps land, and some may never be obtainable at all, so there is no
   safe "we are finished" condition. The rule is a handful of kbTechGetStatus() calls
   every 30 seconds, which is cheap enough to leave running.
*/
//==============================================================================
rule sejmUpgradeMonitor
inactive
minInterval 30
{
   int sejmID = getUnit(cUnitTypedeSejm, cMyID);
   if (sejmID < 0)
   {
      return; // sejmConstructionMonitor is still getting it up.
   }

   int foodPri = 50;
   int woodPri = 50;
   int coinPri = 50;

   switch (getMostNeededResource())
   {
      case cResourceWood:
      {
         woodPri = 80;
         break;
      }
      case cResourceGold:
      {
         coinPri = 80;
         break;
      }
      default: // Food.
      {
         foodPri = 80;
         break;
      }
   }

   // Economic ladders. Only the first unresearched step of each will be obtainable.
   researchSimpleTechByCondition(cTechDESejmFood1,
   []() -> bool { return (kbTechGetStatus(cTechDESejmFood1) == cTechStatusObtainable); },
   cUnitTypedeSejm, sejmID, foodPri);
   researchSimpleTechByCondition(cTechDESejmFood2,
   []() -> bool { return (kbTechGetStatus(cTechDESejmFood2) == cTechStatusObtainable); },
   cUnitTypedeSejm, sejmID, foodPri);
   researchSimpleTechByCondition(cTechDESejmFood3,
   []() -> bool { return (kbTechGetStatus(cTechDESejmFood3) == cTechStatusObtainable); },
   cUnitTypedeSejm, sejmID, foodPri);

   researchSimpleTechByCondition(cTechDESejmWood1,
   []() -> bool { return (kbTechGetStatus(cTechDESejmWood1) == cTechStatusObtainable); },
   cUnitTypedeSejm, sejmID, woodPri);
   researchSimpleTechByCondition(cTechDESejmWood2,
   []() -> bool { return (kbTechGetStatus(cTechDESejmWood2) == cTechStatusObtainable); },
   cUnitTypedeSejm, sejmID, woodPri);
   researchSimpleTechByCondition(cTechDESejmWood3,
   []() -> bool { return (kbTechGetStatus(cTechDESejmWood3) == cTechStatusObtainable); },
   cUnitTypedeSejm, sejmID, woodPri);

   researchSimpleTechByCondition(cTechDESejmCoin1,
   []() -> bool { return (kbTechGetStatus(cTechDESejmCoin1) == cTechStatusObtainable); },
   cUnitTypedeSejm, sejmID, coinPri);
   researchSimpleTechByCondition(cTechDESejmCoin2,
   []() -> bool { return (kbTechGetStatus(cTechDESejmCoin2) == cTechStatusObtainable); },
   cUnitTypedeSejm, sejmID, coinPri);
   researchSimpleTechByCondition(cTechDESejmCoin3,
   []() -> bool { return (kbTechGetStatus(cTechDESejmCoin3) == cTechStatusObtainable); },
   cUnitTypedeSejm, sejmID, coinPri);

   // Cheap free cavalry - best value on the board, so these go first.
   researchSimpleTechByCondition(cTechdeSejmGeneralLevy,
   []() -> bool { return (kbTechGetStatus(cTechdeSejmGeneralLevy) == cTechStatusObtainable); },
   cUnitTypedeSejm, sejmID, 70);
   researchSimpleTechByCondition(cTechdeSejmGeneralDefense,
   []() -> bool { return (kbTechGetStatus(cTechdeSejmGeneralDefense) == cTechStatusObtainable); },
   cUnitTypedeSejm, sejmID, 65);

   // Hetman upgrades - a straight buff to a unit we already field.
   researchSimpleTechByCondition(cTechDESejmHetman1,
   []() -> bool { return (kbTechGetStatus(cTechDESejmHetman1) == cTechStatusObtainable); },
   cUnitTypedeSejm, sejmID, 60);
   researchSimpleTechByCondition(cTechDESejmHetman2,
   []() -> bool { return (kbTechGetStatus(cTechDESejmHetman2) == cTechStatusObtainable); },
   cUnitTypedeSejm, sejmID, 60);
   researchSimpleTechByCondition(cTechDESejmHetman3,
   []() -> bool { return (kbTechGetStatus(cTechDESejmHetman3) == cTechStatusObtainable); },
   cUnitTypedeSejm, sejmID, 60);

   // Free Piechur infantry.
   researchSimpleTechByCondition(cTechdeSejmPiechota1,
   []() -> bool { return (kbTechGetStatus(cTechdeSejmPiechota1) == cTechStatusObtainable); },
   cUnitTypedeSejm, sejmID, 60);
   researchSimpleTechByCondition(cTechdeSejmPiechota2,
   []() -> bool { return (kbTechGetStatus(cTechdeSejmPiechota2) == cTechStatusObtainable); },
   cUnitTypedeSejm, sejmID, 60);
   researchSimpleTechByCondition(cTechdeSejmPiechota3,
   []() -> bool { return (kbTechGetStatus(cTechdeSejmPiechota3) == cTechStatusObtainable); },
   cUnitTypedeSejm, sejmID, 60);

   // Free Winged Hussars.
   researchSimpleTechByCondition(cTechdeSejmArmy1,
   []() -> bool { return (kbTechGetStatus(cTechdeSejmArmy1) == cTechStatusObtainable); },
   cUnitTypedeSejm, sejmID, 60);
   researchSimpleTechByCondition(cTechdeSejmArmy2,
   []() -> bool { return (kbTechGetStatus(cTechdeSejmArmy2) == cTechStatusObtainable); },
   cUnitTypedeSejm, sejmID, 60);
   researchSimpleTechByCondition(cTechdeSejmArmy3,
   []() -> bool { return (kbTechGetStatus(cTechdeSejmArmy3) == cTechStatusObtainable); },
   cUnitTypedeSejm, sejmID, 60);

   /* Congress permanently improves what the Sejm trickles, but at 1000 wood and 1000
      coin it should never come before the resource we are actually short of. */
   researchSimpleTechByCondition(cTechDESejmCongress,
   []() -> bool { return (kbTechGetStatus(cTechDESejmCongress) == cTechStatusObtainable); },
   cUnitTypedeSejm, sejmID, 45);

   // Native policies are only worth anything when we actually hold trading posts.
   researchSimpleTechByCondition(cTechDESejmNatives1,
   []() -> bool { return ((kbTechGetStatus(cTechDESejmNatives1) == cTechStatusObtainable) &&
                          (kbUnitCount(cMyID, cUnitTypeAbstractNativeWarrior, cUnitStateAlive) > 0)); },
   cUnitTypedeSejm, sejmID, 40);
   researchSimpleTechByCondition(cTechDESejmNatives2,
   []() -> bool { return ((kbTechGetStatus(cTechDESejmNatives2) == cTechStatusObtainable) &&
                          (kbUnitCount(cMyID, cUnitTypeAbstractNativeWarrior, cUnitStateAlive) > 0)); },
   cUnitTypedeSejm, sejmID, 40);
}
//==============================================================================
// millUpgradeMonitor
// Make sure we research technologies at this building.
//==============================================================================
rule millUpgradeMonitor
inactive
minInterval 30 
{
   int upgradePlanID = -1;
   int myMillId = getUnit(cUnitTypeMill, cMyID);

   if ((kbTechGetStatus(cTechSeedDrill) == cTechStatusActive) && 
       (kbTechGetStatus(cTechArtificialFertilizer) == cTechStatusActive))    
   {
       xsDisableSelf();
       return;
   }

   researchSimpleTechByCondition(cTechSeedDrill, 
   []() -> bool { return (kbTechGetStatus(cTechSeedDrill) == cTechStatusObtainable); },
   cUnitTypeMill, myMillId, 55);
   researchSimpleTechByCondition(cTechArtificialFertilizer, 
   []() -> bool { return (kbTechGetStatus(cTechArtificialFertilizer) == cTechStatusObtainable); },
   cUnitTypeMill, myMillId, 55);
}
//==============================================================================
// nativeFarmUpgradeMonitor
// Make sure we research technologies at this building.
//==============================================================================
rule nativeFarmUpgradeMonitor
inactive
minInterval 30
{
   int upgradePlanID = -1;
   int myFarmId = getUnit(cUnitTypeFarm, cMyID);
    
   if ((kbTechGetStatus(cTechGreatFeast) == cTechStatusActive) && 
       (kbTechGetStatus(cTechHarvestCeremony) == cTechStatusActive) &&
       (kbTechGetStatus(cTechGreenCornCeremony) == cTechStatusActive)) 
   {
       xsDisableSelf();
       return;
   }

   researchSimpleTechByCondition(cTechGreatFeast, 
   []() -> bool { return (kbTechGetStatus(cTechGreatFeast) == cTechStatusObtainable); },
   cUnitTypeFarm, myFarmId, 55);
   researchSimpleTechByCondition(cTechHarvestCeremony, 
   []() -> bool { return (kbTechGetStatus(cTechHarvestCeremony) == cTechStatusObtainable); },
   cUnitTypeFarm, myFarmId, 55);
   researchSimpleTechByCondition(cTechGreenCornCeremony, 
   []() -> bool { return (kbTechGetStatus(cTechGreenCornCeremony) == cTechStatusObtainable); },
   cUnitTypeFarm, myFarmId, 55);
}
//==============================================================================
// ricePaddyUpgradeMonitor
// Make sure we research technologies at this building.
//==============================================================================
rule ricePaddyUpgradeMonitor
inactive
minInterval 30
{
   int upgradePlanID = -1;
   int myRicePaddyId = getUnit(cUnitTypeypRicePaddy, cMyID);

   if ((kbTechGetStatus(cTechypCropMarket) == cTechStatusActive) &&
       (kbTechGetStatus(cTechypCultivateWasteland) == cTechStatusActive) &&       
       (kbTechGetStatus(cTechypWaterConservancy) == cTechStatusActive) &&       
       (kbTechGetStatus(cTechypIrrigationSystems) == cTechStatusActive) &&       
       (kbTechGetStatus(cTechypSharecropping) == cTechStatusActive) &&       
       (kbTechGetStatus(cTechypLandRedistribution) == cTechStatusActive) &&       
       (kbTechGetStatus(cTechypCooperative) == cTechStatusActive))
   {
       xsDisableSelf();
       return;
   }
  
   researchSimpleTechByCondition(cTechypCropMarket, 
   []() -> bool { return (kbTechGetStatus(cTechypCropMarket) == cTechStatusObtainable); },
   cUnitTypeypRicePaddy, myRicePaddyId, 55);
   researchSimpleTechByCondition(cTechypCultivateWasteland, 
   []() -> bool { return (kbTechGetStatus(cTechypCultivateWasteland) == cTechStatusObtainable); },
   cUnitTypeypRicePaddy, myRicePaddyId, 55);
   researchSimpleTechByCondition(cTechypWaterConservancy, 
   []() -> bool { return (kbTechGetStatus(cTechypWaterConservancy) == cTechStatusObtainable); },
   cUnitTypeypRicePaddy, myRicePaddyId, 55);
   researchSimpleTechByCondition(cTechypIrrigationSystems, 
   []() -> bool { return (kbTechGetStatus(cTechypIrrigationSystems) == cTechStatusObtainable); },
   cUnitTypeypRicePaddy, myRicePaddyId, 55);
   researchSimpleTechByCondition(cTechypSharecropping, 
   []() -> bool { return (kbTechGetStatus(cTechypSharecropping) == cTechStatusObtainable); },
   cUnitTypeypRicePaddy, myRicePaddyId, 55);
   researchSimpleTechByCondition(cTechypLandRedistribution, 
   []() -> bool { return (kbTechGetStatus(cTechypLandRedistribution) == cTechStatusObtainable); },
   cUnitTypeypRicePaddy, myRicePaddyId, 55);
   researchSimpleTechByCondition(cTechypCooperative, 
   []() -> bool { return (kbTechGetStatus(cTechypCooperative) == cTechStatusObtainable); },
   cUnitTypeypRicePaddy, myRicePaddyId, 55);
}
//==============================================================================
// estateUpgradeMonitor
// Make sure we research technologies at this building.
//==============================================================================
rule estateUpgradeMonitor
inactive
minInterval 30
{
   int upgradePlanID = -1;
   int myEstateId = getUnit(cUnitTypePlantation, cMyID);

   if ((kbTechGetStatus(cTechBookkeeping) == cTechStatusActive) && 
       (kbTechGetStatus(cTechHomesteading) == cTechStatusActive) &&       
       (kbTechGetStatus(cTechOreRefining) == cTechStatusActive))    
   {
       xsDisableSelf();
       return;
   }

   researchSimpleTechByCondition(cTechBookkeeping, 
   []() -> bool { return (kbTechGetStatus(cTechBookkeeping) == cTechStatusObtainable); },
   cUnitTypePlantation, myEstateId, 55);
   researchSimpleTechByCondition(cTechHomesteading, 
   []() -> bool { return (kbTechGetStatus(cTechHomesteading) == cTechStatusObtainable); },
   cUnitTypePlantation, myEstateId, 55);
   researchSimpleTechByCondition(cTechOreRefining, 
   []() -> bool { return (kbTechGetStatus(cTechOreRefining) == cTechStatusObtainable); },
   cUnitTypePlantation, myEstateId, 55);
}
//==============================================================================
// nativeEstateUpgradeMonitor
// Make sure we research technologies at this building.
//==============================================================================
rule nativeEstateUpgradeMonitor
inactive
minInterval 30 
{
   int upgradePlanID = -1;
   int myEstateId = getUnit(cUnitTypePlantation, cMyID);

   if ((kbTechGetStatus(cTechEarthCeremony) == cTechStatusActive) && 
       (kbTechGetStatus(cTechEarthGiftCeremony) == cTechStatusActive))    
   {
       xsDisableSelf();
       return;
   }

   researchSimpleTechByCondition(cTechEarthCeremony, 
   []() -> bool { return (kbTechGetStatus(cTechEarthCeremony) == cTechStatusObtainable); },
   cUnitTypePlantation, myEstateId, 55);
   researchSimpleTechByCondition(cTechEarthGiftCeremony, 
   []() -> bool { return (kbTechGetStatus(cTechEarthGiftCeremony) == cTechStatusObtainable); },
   cUnitTypePlantation, myEstateId, 55);
}
//==============================================================================
/*
   landPatrol
   This makes military units explore land areas and attack enemies if they encounter them.
*/
//==============================================================================
rule landPatrol
inactive
minInterval 20
{
   if(kbGetAge() > cAge3)
   {  
      vector mainBaseLoc = kbBaseGetLocation(cMyID, kbBaseGetMainID(cMyID));
      int militaryUnit =-1;
      if(kbUnitCount(cMyID, cUnitTypeLogicalTypeLandMilitary, cUnitStateAlive) >= 1)
      { militaryUnit = cUnitTypeLogicalTypeLandMilitary; }

      if (gDefenseReflexBaseID == kbBaseGetMainID(cMyID) || isDefendingOrAttacking() == true ||
         gIslandAssaultPlanID > 0 || gIslandAssaultTransportPlanID > 0 || 
         gIslandAssaultTransportPlan2ID > 0) {
         aiPlanDestroy(gLandPatrolPlan);
         return;
      }

      if(kbUnitCount(cMyID, militaryUnit, cUnitStateAlive) >= 5 && aiPlanGetActive(gLandPatrolPlan) == false)
      {
         if (gLandPatrolPlan != -1) {
            aiPlanDestroy(gLandPatrolPlan);
            gLandPatrolPlan = -1;
         }
         vector centerOffset = kbGetMapCenter() - kbBaseGetLocation(cMyID, kbBaseGetMainID(cMyID));
         vector targetLocation = cInvalidVector;
         if (gIslandMap == false) {
            targetLocation = getRandomLandPoint();
         } else {
            targetLocation = getRandomPatrolPoint();
         }
         gLandPatrolPlan = aiPlanCreate("Patrol the Lands", cPlanCombat);

         // Add units
         int militaryQueryID = createIdleUnitQuery(cUnitTypeLogicalTypeLandMilitary, cMyID, cUnitStateAlive);
         int numberFound = kbUnitQueryExecute(militaryQueryID);

         if (numberFound > 30) {
            if (gIslandMap == false) {
               aiPlanAddUnitType(gLandPatrolPlan, cUnitTypeLogicalTypeLandMilitary, 10, 15, 20);
            } else {
               aiPlanAddUnitType(gLandPatrolPlan, cUnitTypeLogicalTypeLandMilitary, 8, 10, 12);
            }
            aiPlanSetVariableInt(gLandPatrolPlan, cCombatPlanCombatType, 0, cCombatPlanCombatTypeAttack);
            aiPlanSetVariableInt(gLandPatrolPlan, cCombatPlanTargetMode, 0, cCombatPlanTargetModePoint);
            aiPlanSetVariableVector(gLandPatrolPlan, cCombatPlanTargetPoint, 0, targetLocation);
            aiPlanSetVariableVector(gLandPatrolPlan, cCombatPlanGatherPoint, 0, mainBaseLoc);
            aiPlanSetVariableFloat(gLandPatrolPlan, cCombatPlanGatherDistance, 0, 100.0);
            aiPlanSetVariableInt(gLandPatrolPlan, cCombatPlanAttackRoutePattern, 0, cCombatPlanAttackRoutePatternRandom);
            aiPlanSetVariableBool(gLandPatrolPlan, cCombatPlanAllowMoreUnitsDuringAttack, 0, true);
            aiPlanSetVariableInt(gLandPatrolPlan, cCombatPlanRefreshFrequency, 0, cDifficultyCurrent >= cDifficultyHard ? 300 : 1000);

            aiPlanSetVariableInt(gLandPatrolPlan, cCombatPlanDoneMode, 0, cCombatPlanDoneModeRetreat | cCombatPlanDoneModeNoTarget);
            aiPlanSetVariableInt(gLandPatrolPlan, cCombatPlanRetreatMode, 0, cCombatPlanRetreatModeOutnumbered);
            aiPlanSetVariableInt(gLandPatrolPlan, cCombatPlanNoTargetTimeout, 0, 30000);
            aiPlanSetBaseID(gLandPatrolPlan, kbBaseGetMainID(cMyID));
            aiPlanSetInitialPosition(gLandPatrolPlan, mainBaseLoc);

            aiPlanSetDesiredPriority(gLandPatrolPlan, 45);
            aiPlanSetActive(gLandPatrolPlan);
            aiEcho("Patrolling the lands, looking for enemies and settlements to destroy!");
         }
      }
   }
}
//==============================================================================
// getBackToWork
// An attempt to take care of idle villagers.
//==============================================================================
rule getBackToWork
active
//group tcComplete
minInterval 20
maxInterval 40
{
   int age = kbGetAge();
   // Enhanced Wood Fix
   static int villagerQueryID = -1;
   if (villagerQueryID < 0)
   {
      villagerQueryID = kbUnitQueryCreate("enhancedIdleVillagers");
      kbUnitQuerySetPlayerID(villagerQueryID, cMyID);
      kbUnitQuerySetUnitType(villagerQueryID, gEconUnit);
      kbUnitQuerySetState(villagerQueryID, cUnitStateAlive);
      kbUnitQuerySetActionType(villagerQueryID, cActionTypeIdle);
   }
   kbUnitQueryResetResults(villagerQueryID);
   int numberFound = kbUnitQueryExecute(villagerQueryID);
   int numPlans = aiPlanGetActiveCount();
   // float goldPercentage = aiGetResourcePercentage(cResourceGold);
   // float woodPercentage = aiGetResourcePercentage(cResourceWood);
   // float foodPercentage = aiGetResourcePercentage(cResourceFood);
   float goldAmount = kbResourceGet(cResourceGold);
   float woodAmount = kbResourceGet(cResourceWood);
   float foodAmount = kbResourceGet(cResourceFood);
   int resource = getMostNeededResource();

   // Gather the resource with the least amount.
   // if (foodAmount < woodAmount && foodAmount < goldAmount) {
   //    resource = cResourceFood;
   // } else if (woodAmount < foodAmount && woodAmount < goldAmount) {
   //    resource = cResourceWood;
   // } else if (goldAmount < foodAmount && goldAmount < woodAmount) {
   //    resource = cResourceGold;
   // }

   //aiEcho("Chosen Resource: "+resource+"");
   // Enhanced Wood Fix
   static int idleLastPass = -1;
   static int idleLastStreak = -1;
   static int idleNextPass = -1;
   static int idleNextStreak = -1;
   static int idleLastCount = 0;
   if (idleLastPass < 0)
   {
      idleLastPass = xsArrayCreateInt(cMaxTrackedIdleVillagers, -1, "Idle villagers last pass");
      idleLastStreak = xsArrayCreateInt(cMaxTrackedIdleVillagers, 0, "Idle villager streak last pass");
      idleNextPass = xsArrayCreateInt(cMaxTrackedIdleVillagers, -1, "Idle villagers this pass");
      idleNextStreak = xsArrayCreateInt(cMaxTrackedIdleVillagers, 0, "Idle villager streak this pass");
   }

   int retasked = 0;
   for (int i = 0; i < numberFound; i++)
   {
      int unitID = kbUnitQueryGetResult(villagerQueryID, i);

      if (kbUnitGetNumberActions(unitID) > 0)
      {
         continue;
      }

      // Enhanced Wood Fix
      int streakIndex = -1;
      int streak = 1;
      for (int idleIndex = 0; idleIndex < idleLastCount; idleIndex++)
      {
         if (xsArrayGetInt(idleLastPass, idleIndex) == unitID)
         {
            streakIndex = idleIndex;
            streak = xsArrayGetInt(idleLastStreak, idleIndex) + 1;
            break;
         }
      }
      if (streak < 2)
      {
         continue;
      }

      // Enhanced Wood Fix
      int currentPlan = kbUnitGetPlanID(unitID);
      if ((currentPlan >= 0) && (aiPlanGetActive(currentPlan) == true))
      {
         if (aiPlanGetType(currentPlan) != cPlanGather)
         {
            continue;
         }
      }

      // Enhanced Wood Fix
      bool placed = false;
      int previousPlan = currentPlan;
      for (int pass = 0; pass < 2; pass++)
      {
         for (int j = 0; j < numPlans; j++)
         {
            int planID = aiPlanGetIDByActiveIndex(j);
            if (planID == previousPlan)
            {
               continue;
            }
            if (aiPlanGetType(planID) != cPlanGather)
            {
               continue;
            }
            if ((pass == 0) && (aiPlanGetVariableInt(planID, cGatherPlanResourceType, 0) != resource))
            {
               continue;
            }

            if (currentPlan >= 0)
            {
               aiPlanRemoveUnit(currentPlan, unitID);
               currentPlan = -1;
            }
            if (aiPlanAddUnit(planID, unitID) == true)
            {
               retasked++;
               placed = true;
               break;
            }
         }
         if (placed == true)
         {
            break;
         }
      }

      if ((placed == false) && (previousPlan >= 0) && (currentPlan < 0))
      {
         aiPlanAddUnit(previousPlan, unitID);
      }

      // Enhanced Wood Fix
      if ((placed == true) && (streakIndex >= 0))
      {
         xsArraySetInt(idleLastStreak, streakIndex, 0);
      }
   }

   // Enhanced Wood Fix
   int nextCount = 0;
   for (int recordIndex = 0; recordIndex < numberFound; recordIndex++)
   {
      if (nextCount >= cMaxTrackedIdleVillagers)
      {
         break;
      }
      int recordUnitID = kbUnitQueryGetResult(villagerQueryID, recordIndex);
      if (kbUnitGetNumberActions(recordUnitID) > 0)
      {
         continue;
      }
      int recordStreak = 1;
      for (int lookupIndex = 0; lookupIndex < idleLastCount; lookupIndex++)
      {
         if (xsArrayGetInt(idleLastPass, lookupIndex) == recordUnitID)
         {
            recordStreak = xsArrayGetInt(idleLastStreak, lookupIndex) + 1;
            break;
         }
      }
      xsArraySetInt(idleNextPass, nextCount, recordUnitID);
      xsArraySetInt(idleNextStreak, nextCount, recordStreak);
      nextCount++;
   }

   int swapArray = idleLastPass;
   idleLastPass = idleNextPass;
   idleNextPass = swapArray;
   swapArray = idleLastStreak;
   idleLastStreak = idleNextStreak;
   idleNextStreak = swapArray;
   idleLastCount = nextCount;
}
//==============================================================================
/* maxOutThatMilitaryBaby
*/
//==============================================================================
rule maxOutThatMilitaryBaby
active
maxInterval 20
{
   int limit = aiGetMilitaryPop();
   int age = kbGetAge();
   int militaryCount = kbUnitCount(cMyID, cUnitTypeLogicalTypeLandMilitary, cUnitStateAlive);
   int ecoCount = kbUnitCount(cMyID, cUnitTypeAbstractVillager, cUnitStateAlive);
   if (age < cAge2) {
      return;
   }
   if (limit < 1) {
      return;
   }

   int militaryPriority = 70;
   
   // Early rush attempt maxes out priority
   if (gEarlyRushAttempt == true && (age == cAge2 || age == cAge3))
   {
      militaryPriority = 80;
   } else if (gEarlyRushAttempt == false && age == cAge2) {
      militaryPriority = 70;
   } else if (gEarlyRushAttempt == false && age == cAge3) {
      militaryPriority = 76;
   } else if (age == cAge4) {
      militaryPriority = 82;
   } else if (age == cAge5) {
      militaryPriority = 85;
   }

   int militaryResourcePriority = 60;
   if (age > cAge3)
   {
      militaryResourcePriority = 65;
   }

   if (gMaxLandMilitaryMaintain < 0)
   {
      gMaxLandMilitaryMaintain = createSimpleMaintainPlan(cUnitTypeLogicalTypeLandMilitary, limit, true, -1, 1);
      aiPlanSetDesiredPriority(gMaxLandMilitaryMaintain, militaryPriority);
      aiPlanSetDesiredResourcePriority(gMaxLandMilitaryMaintain, militaryResourcePriority);
      aiPlanSetVariableInt(gMaxLandMilitaryMaintain, cTrainPlanBuildFromType, 0, gMilitaryBuildings);
      aiEcho("Land military maintain plan created, limit: " + limit);
   }
   else
   {
      if (aiPlanGetActive(gMaxLandMilitaryMaintain) == false)
         aiPlanSetActive(gMaxLandMilitaryMaintain, true);
      aiPlanSetDesiredPriority(gMaxLandMilitaryMaintain, militaryPriority);
      aiPlanSetDesiredResourcePriority(gMaxLandMilitaryMaintain, militaryResourcePriority);
      aiPlanSetVariableInt(gMaxLandMilitaryMaintain, cTrainPlanNumberToMaintain, 0, limit);
   }
   
   if (gArmyUnitMaintainPlans >= 0)
   {
      int numberPickerPlans = xsArrayGetSize(gArmyUnitMaintainPlans);
      int pickerPlanID = -1;
      for (i = 0; < numberPickerPlans)
      {
         pickerPlanID = xsArrayGetInt(gArmyUnitMaintainPlans, i);
         if (pickerPlanID < 0)
         {
            continue;
         }
         aiPlanSetDesiredResourcePriority(pickerPlanID, militaryResourcePriority);
         aiPlanSetDesiredPriority(pickerPlanID, militaryPriority + 5); // Enhanced attack fix
      }
   }

   // Info tests!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! Why are you looking at this?
   // int popCap = kbGetPopCap();
   // int popUsed = kbGetPop();

   // int militaryPopLimit = aiGetMilitaryPop();
   // int militaryPopUsed = militaryPopLimit - aiGetAvailableMilitaryPop();
   // int econPopUsed = aiGetCurrentEconomyPop();
   // int otherPopUsed = popUsed - militaryPopUsed - econPopUsed;

   // aiEcho("Military limit: " + limit + " | Current Military Units: " + militaryCount +
   //    " | Military Priority: " + militaryPriority + " | Current Economy Units: " + ecoCount);
   // aiEcho("Population - Used: " + popUsed + " / Cap: " + popCap);
   // aiChat(1, "POP BREAKDOWN - Econ: " + econPopUsed + " (target " + aiGetEconomyPop() + ")" +
   //    " | Military: " + militaryPopUsed + " / " + militaryPopLimit +
   //    " (free " + aiGetAvailableMilitaryPop() + ")" +
   //    " | Other: " + otherPopUsed +
   //    " | Headroom: " + (popCap - popUsed));
   if (gEarlyRushAttempt == true)
      aiEcho("EARLY RUSH ACTIVE - Military priority raised to " + militaryPriority);
}
//==============================================================================
// maxOutVillagers
// Tries to maintain as many villagers as possible while leaving room for military units.
//==============================================================================
rule maxOutVillagers
active
minInterval 20
{
   // Set build limit...
   int limit = 85;
   int age = kbGetAge();

   int villagerCount = kbUnitCount(cMyID, gEconUnit, cUnitStateABQ);

   // Determine base priority for current age.
   int basePriority = 80;
   if (age < cAge2) {
      limit = 14;
   } else if (age == cAge2) {
      limit = 28;
   } else if (age == cAge3) {
      limit = 34;
   } else if (age == cAge5) {
      basePriority = 80;
   }

   // Adjust priority
   if (villagerCount >= limit) {
      basePriority = 40;
   }
   
   // Create/update maintain plan
   if (limit < 1)
      return;
      
   if (gMaxVillagersMaintain < 0)
   {
      gMaxVillagersMaintain = createSimpleMaintainPlan(gEconUnit, limit, true, -1, 1);
      aiPlanSetDesiredPriority(gMaxVillagersMaintain, basePriority);
      aiPlanSetVariableInt(gMaxVillagersMaintain, cTrainPlanBuildFromType, 0, cUnitTypeAgeUpBuilding);
      aiEcho("Maxed out villagers!");
   }
   else
   {
      if (aiPlanGetActive(gMaxVillagersMaintain) == false) {
         aiPlanSetActive(gMaxVillagersMaintain, true);
      }
      aiPlanSetDesiredPriority(gMaxVillagersMaintain, basePriority);
      aiPlanSetVariableInt(gMaxVillagersMaintain, cTrainPlanNumberToMaintain, 0, limit);
   }
}
//==============================================================================
// maintainFishingBoats
// Maintains a number of fishing boats...
//==============================================================================
rule maintainFishingBoats
inactive
minInterval 20
{
   // Set build limit...
   int limit = 16;
   int age = kbGetAge();

   if (age == cAge1) {
      limit = 2;
   } else if (age == cAge2) {
      limit = 5;
   } else if (age == cAge3) {
      limit = 7;
   }

   /* If we can build Outlaw Whaling Ships, spend 3 of our fishing slots on them instead. */
   int whalingShipsWanted = 0;
   if ((kbProtoUnitAvailable(cUnitTypedeOutlawWhalingShip) == true) && (limit > 3))
   {
      whalingShipsWanted = 3;
      int whalingBuildLimit = kbGetBuildLimit(cMyID, cUnitTypedeOutlawWhalingShip);
      if ((whalingBuildLimit >= 0) && (whalingBuildLimit < whalingShipsWanted))
      {
         whalingShipsWanted = whalingBuildLimit;
      }
      limit = limit - whalingShipsWanted;
   }

   // Same priority curve the Fishing Boat plan uses below, so the two don't fight each other.
   int boatPriority = 55;
   if (age == cAge4)
   {
      boatPriority = 60;
   }
   else if (age == cAge5)
   {
      boatPriority = 64;
   }

   if (gWhalingShipMaintain < 0)
   {
      if (whalingShipsWanted > 0)
      {
         gWhalingShipMaintain = createSimpleMaintainPlan(cUnitTypedeOutlawWhalingShip, whalingShipsWanted, true, -1, 1);
         aiPlanSetDesiredPriority(gWhalingShipMaintain, boatPriority);
         aiPlanSetActive(gWhalingShipMaintain, true);
         aiEcho("Outlaw Whaling Ships! Maintaining " + whalingShipsWanted + ", Fishing Boats reduced to " + limit);
      }
   }
   else
   {
      if (aiPlanGetActive(gWhalingShipMaintain) == false)
      {
         aiPlanSetActive(gWhalingShipMaintain, true);
      }
      aiPlanSetDesiredPriority(gWhalingShipMaintain, boatPriority);
      aiPlanSetVariableInt(gWhalingShipMaintain, cTrainPlanNumberToMaintain, 0, whalingShipsWanted);
   }

   // Create/update maintain plan
   if (limit < 1)
      return;

   if (gFishingBoatMaintainPlan < 0)
   {
      gFishingBoatMaintainPlan = createSimpleMaintainPlan(gFishingUnit, limit, true, -1, 1);
      if (age < cAge2) {
         aiPlanSetDesiredPriority(gFishingBoatMaintainPlan, 25);
      } else if (age == cAge2 || age == cAge3) {
         aiPlanSetDesiredPriority(gFishingBoatMaintainPlan, 45);
      } else if (age == cAge4) {
         aiPlanSetDesiredPriority(gFishingBoatMaintainPlan, 60);
      } else if (age == cAge5) {
         aiPlanSetDesiredPriority(gFishingBoatMaintainPlan, 64);
      }
      aiPlanSetVariableInt(gFishingBoatMaintainPlan, cTrainPlanBuildFromType, 0, gDockUnit);
      aiEcho("Fishing boats!");
   }
   else
   {
      if (aiPlanGetActive(gFishingBoatMaintainPlan) == false) {
         aiPlanSetActive(gFishingBoatMaintainPlan, true);
      }
      if (age <= cAge2) {
         aiPlanSetDesiredPriority(gFishingBoatMaintainPlan, 55);
      } else if (age == cAge3) {
         aiPlanSetDesiredPriority(gFishingBoatMaintainPlan, 55);
      } else if (age == cAge4) {
         aiPlanSetDesiredPriority(gFishingBoatMaintainPlan, 60);
      } else if (age == cAge5) {
         aiPlanSetDesiredPriority(gFishingBoatMaintainPlan, 64);
      }
      aiPlanSetVariableInt(gFishingBoatMaintainPlan, cTrainPlanNumberToMaintain, 0, limit);
   }
}
//==============================================================================
// customsHouseShipmentMonitor
// Denmark's Customs House. Spend shipment points on the crate we are
// shortest on, and buy more shipment points when we can spare 500 of each.
//==============================================================================
rule customsHouseShipmentMonitor
inactive
minInterval 20
{
   int customsHouseID = getUnit(cUnitTypedeCustomsHouse, cMyID);
   if (customsHouseID < 0)
   {
      return;
   }

   float food = kbResourceGet(cResourceFood);
   float wood = kbResourceGet(cResourceWood);
   float gold = kbResourceGet(cResourceGold);

   int crateTech = cTechDECustomsHouseMixedCrates;
   if ((food < wood) && (food < gold) && (food < 500.0))
   {
      crateTech = cTechDECustomsHouseFoodCrates;
   }
   else if ((wood < food) && (wood < gold) && (wood < 500.0))
   {
      crateTech = cTechDECustomsHouseWoodCrates;
   }
   else if ((gold < food) && (gold < wood) && (gold < 500.0))
   {
      crateTech = cTechDECustomsHouseCoinCrates;
   }

   if (kbTechGetStatus(crateTech) == cTechStatusObtainable)
   {
      researchSimpleTech(crateTech, cUnitTypedeCustomsHouse, customsHouseID, 80);
      return;
   }
   if ((crateTech != cTechDECustomsHouseMixedCrates) &&
      (kbTechGetStatus(cTechDECustomsHouseMixedCrates) == cTechStatusObtainable))
   {
      researchSimpleTech(cTechDECustomsHouseMixedCrates, cUnitTypedeCustomsHouse, customsHouseID, 70);
      return;
   }

   if (gDefenseReflex == true)
   {
      return;
   }

   if ((food > 1000.0) && (wood > 1000.0) && (gold > 1000.0) &&
      (kbTechGetStatus(cTechDECustomsHouseShipment) == cTechStatusObtainable))
   {
      researchSimpleTech(cTechDECustomsHouseShipment, cUnitTypedeCustomsHouse, customsHouseID, 40);
   }
}