extern bool gSouthAfricaWagonWarfareSent = false;
extern bool gSouthAfricaHuguenotsSent = false;
extern bool gSouthAfricaRaadsaalSent = false;
extern bool gSouthAfricaDiamondRushSent = false;
extern bool gSouthAfricaRobberBaronsSent = false;
extern int gSouthAfricaWanderlustCount = 0;

extern int gSouthAfricaSettlerMaintain = -1;
extern int gSouthAfricaHuguenotMaintain = -1;
extern int gSouthAfricaTrekWagonMaintain = -1;
extern int gSouthAfricaWarWagonMaintain = -1;
extern int gSouthAfricaSkirmisherMaintain = -1;
extern int gSouthAfricaArtilleryMaintain = -1;

//==============================================================================
// southAfricaRevolutionManager
//==============================================================================
rule southAfricaRevolutionManager
inactive
minInterval 30
{
   int mainBaseID = kbBaseGetMainID(cMyID);
   
   int trekWagonCount = kbUnitCount(cMyID, cUnitTypedeREVStarTrekWagon, cUnitStateAlive);
   int warWagonCount = kbUnitCount(cMyID, cUnitTypeWarWagon, cUnitStateAlive);
   int skirmisherCount = kbUnitCount(cMyID, cUnitTypeSkirmisher, cUnitStateAlive);
   int artilleryCount = kbUnitCount(cMyID, cUnitTypeAbstractArtillery, cUnitStateAlive);
   
   int longbowCount = 0;
   int ruytorCount = 0;
   if (cMyCiv == cCivBritish)
   {
      longbowCount = kbUnitCount(cMyID, cUnitTypeLongbowman, cUnitStateAlive);
   }
   else if (cMyCiv == cCivDutch)
   {
      ruytorCount = kbUnitCount(cMyID, cUnitTypeRuyter, cUnitStateAlive);
   }
   
   debugMilitary("South Africa: Trek Wagons=" + trekWagonCount + 
                 ", War Wagons=" + warWagonCount +
                 ", Skirmishers=" + skirmisherCount);
   
   int enemyPlayer = aiGetMostHatedPlayerID();
   if (enemyPlayer < 1)
   {
      enemyPlayer = 2;
   }
   
   int enemyCavalryCount = kbUnitCount(enemyPlayer, cUnitTypeAbstractCavalry, cUnitStateAlive);
   int enemyHeavyInfCount = kbUnitCount(enemyPlayer, cUnitTypeAbstractHeavyInfantry, cUnitStateAlive);
   int enemyLightInfCount = kbUnitCount(enemyPlayer, cUnitTypeAbstractLightInfantry, cUnitStateAlive);
   int enemyArtilleryCount = kbUnitCount(enemyPlayer, cUnitTypeAbstractArtillery, cUnitStateAlive);
   
   int wantedTrekWagons = 5;
   
   int settlerCount = kbUnitCount(cMyID, gEconUnit, cUnitStateAlive);
   if (settlerCount > 40)
   {
      wantedTrekWagons = 8;
   }
   
   if (wantedTrekWagons > 10)
   {
      wantedTrekWagons = 10;
   }
   
   if (kbProtoUnitAvailable(cUnitTypedeREVStarTrekWagon) == true && gSouthAfricaTrekWagonMaintain == -1)
   {
      gSouthAfricaTrekWagonMaintain = createSimpleMaintainPlan(cUnitTypedeREVStarTrekWagon, wantedTrekWagons, false, mainBaseID, 1);
      aiPlanSetDesiredPriority(gSouthAfricaTrekWagonMaintain, 50);
      aiPlanSetActive(gSouthAfricaTrekWagonMaintain, true);
      debugMilitary("South Africa: Created Trek Wagon maintain plan");
   }
   else if (gSouthAfricaTrekWagonMaintain >= 0)
   {
      aiPlanSetVariableInt(gSouthAfricaTrekWagonMaintain, cTrainPlanNumberToMaintain, 0, wantedTrekWagons);
   }
   
   if (gSouthAfricaWagonWarfareSent == true)
   {
      
      int wantedWarWagons = 15;
      
      if (enemyHeavyInfCount > 20)
      {
         wantedWarWagons = 20;
      }
      
      if (enemyCavalryCount > 20)
      {
         wantedWarWagons = 10;
      }
      
      if (kbProtoUnitAvailable(cUnitTypeWarWagon) == true && gSouthAfricaWarWagonMaintain == -1)
      {
         gSouthAfricaWarWagonMaintain = createSimpleMaintainPlan(cUnitTypeWarWagon, wantedWarWagons, false, mainBaseID, 1);
         aiPlanSetDesiredPriority(gSouthAfricaWarWagonMaintain, 70);
         aiPlanSetActive(gSouthAfricaWarWagonMaintain, true);
         debugMilitary("South Africa: Created War Wagon maintain plan");
      }
      else if (gSouthAfricaWarWagonMaintain >= 0)
      {
         aiPlanSetVariableInt(gSouthAfricaWarWagonMaintain, cTrainPlanNumberToMaintain, 0, wantedWarWagons);
      }
   }
   
   int wantedSkirmishers = 15;
   
   if (enemyCavalryCount > 15)
   {
      wantedSkirmishers = 20;
   }
   
   if (kbProtoUnitAvailable(cUnitTypeSkirmisher) == true && gSouthAfricaSkirmisherMaintain == -1)
   {
      gSouthAfricaSkirmisherMaintain = createSimpleMaintainPlan(cUnitTypeSkirmisher, wantedSkirmishers, false, mainBaseID, 1);
      aiPlanSetDesiredPriority(gSouthAfricaSkirmisherMaintain, 60);
      aiPlanSetActive(gSouthAfricaSkirmisherMaintain, true);
      debugMilitary("South Africa: Created Skirmisher maintain plan");
   }
   else if (gSouthAfricaSkirmisherMaintain >= 0)
   {
      aiPlanSetVariableInt(gSouthAfricaSkirmisherMaintain, cTrainPlanNumberToMaintain, 0, wantedSkirmishers);
   }
   
   debugMilitary("South Africa targets: Trek Wagons=" + wantedTrekWagons + 
                 ", War Wagons=" + (gSouthAfricaWagonWarfareSent ? wantedWarWagons : 0) +
                 ", Skirmishers=" + wantedSkirmishers);
}

//==============================================================================
// southAfricaEconomyManager
//==============================================================================
rule southAfricaEconomyManager
inactive
minInterval 45
{
   
   int currentSettlers = kbUnitCount(cMyID, gEconUnit, cUnitStateAlive);
   int currentHuguenots = kbUnitCount(cMyID, cUnitTypeCoureur, cUnitStateAlive);
   
   int wantedSettlers = 60;
   
   int factoryCount = kbUnitCount(cMyID, cUnitTypeFactory, cUnitStateAlive);
   if (factoryCount > 0)
   {
      debugMilitary("South Africa: Factory active - strong passive income");
   }
   
   int bankCount = kbUnitCount(cMyID, cUnitTypeBank, cUnitStateAlive);
   if (bankCount > 0)
   {
      debugMilitary("South Africa: " + bankCount + " Banks active (gathering 10% faster)");
   }
   
   if (kbProtoUnitAvailable(gEconUnit) == true && gSouthAfricaSettlerMaintain == -1)
   {
      gSouthAfricaSettlerMaintain = createSimpleMaintainPlan(gEconUnit, wantedSettlers, false, kbBaseGetMainID(cMyID), 1);
      aiPlanSetDesiredPriority(gSouthAfricaSettlerMaintain, 80);
      aiPlanSetActive(gSouthAfricaSettlerMaintain, true);
      debugMilitary("South Africa: Created Settler maintain plan (economy preserved!)");
   }
   else if (gSouthAfricaSettlerMaintain >= 0)
   {
      aiPlanSetVariableInt(gSouthAfricaSettlerMaintain, cTrainPlanNumberToMaintain, 0, wantedSettlers);
   }
   
   if (gSouthAfricaHuguenotsSent == true)
   {
      
      int wantedHuguenots = 30;
      
      if (kbProtoUnitAvailable(cUnitTypeCoureur) == true && gSouthAfricaHuguenotMaintain == -1)
      {
         gSouthAfricaHuguenotMaintain = createSimpleMaintainPlan(cUnitTypeCoureur, wantedHuguenots, false, kbBaseGetMainID(cMyID), 1);
         aiPlanSetDesiredPriority(gSouthAfricaHuguenotMaintain, 75);
         aiPlanSetActive(gSouthAfricaHuguenotMaintain, true);
         debugMilitary("South Africa: Created Huguenot maintain plan");
      }
      else if (gSouthAfricaHuguenotMaintain >= 0)
      {
         aiPlanSetVariableInt(gSouthAfricaHuguenotMaintain, cTrainPlanNumberToMaintain, 0, wantedHuguenots);
      }
   }
   
   debugMilitary("South Africa Economy: Settlers=" + currentSettlers + "/" + wantedSettlers +
                 ", Huguenots=" + currentHuguenots +
                 " (gathering 10% faster!)");
}

//==============================================================================
// southAfricaTrekWagonManager
//==============================================================================
rule southAfricaTrekWagonManager
inactive
minInterval 60
{
   
   int trekWagonCount = kbUnitCount(cMyID, cUnitTypedeREVStarTrekWagon, cUnitStateAlive);
   
   if (trekWagonCount < 1)
   {
      return;
   }
   
   debugMilitary("South Africa Trek Wagons: " + trekWagonCount + " active");
   
}

//==============================================================================
// southAfricaWagonWarfareManager
//==============================================================================
rule southAfricaWagonWarfareManager
inactive
minInterval 45
{
   if (gSouthAfricaWagonWarfareSent == false)
   {
      if (kbTechGetStatus(cTechDEHCREVWagonWarfare) == cTechStatusActive)
      {
         gSouthAfricaWagonWarfareSent = true;
         debugMilitary("South Africa: Wagon Warfare activated - War Wagons available!");
      }
      else
      {
         return;
      }
   }
   
   int warWagonCount = kbUnitCount(cMyID, cUnitTypeWarWagon, cUnitStateAlive);
   
   debugMilitary("South Africa Wagon Warfare: " + warWagonCount + " War Wagons");
   
   if (kbTechGetStatus(cTechImperialWarWagons) == cTechStatusObtainable)
   {
      debugMilitary("South Africa: Imperial War Wagons available for research!");
   }
}

//==============================================================================
// southAfricaWanderlustManager
//==============================================================================
rule southAfricaWanderlustManager
inactive
minInterval 90
{
   
   if (kbTechGetStatus(cTechDEHCREVWanderlust) == cTechStatusActive)
   {
      gSouthAfricaWanderlustCount = gSouthAfricaWanderlustCount + 1;
      if (gSouthAfricaWanderlustCount > 3)
      {
         gSouthAfricaWanderlustCount = 3;
      }
   }
   
   if (gSouthAfricaWanderlustCount > 0)
   {
      int hpBonus = gSouthAfricaWanderlustCount * 5;
      debugMilitary("South Africa Wanderlust: +" + hpBonus + "% HP to all units (sent " + 
                    gSouthAfricaWanderlustCount + "/3 times)");
   }
   
}

//==============================================================================
// southAfricaCardEffectTracker
//==============================================================================
rule southAfricaCardEffectTracker
inactive
minInterval 30
{
   if ((gSouthAfricaWagonWarfareSent == false) && 
       (kbTechGetStatus(cTechDEHCREVWagonWarfare) == cTechStatusActive))
   {
      gSouthAfricaWagonWarfareSent = true;
      debugMilitary("South Africa: Wagon Warfare activated - War Wagons enabled!");
   }
   
   if ((gSouthAfricaHuguenotsSent == false) && 
       (kbTechGetStatus(cTechDEHCREVHuguenots) == cTechStatusActive))
   {
      gSouthAfricaHuguenotsSent = true;
      debugMilitary("South Africa: Huguenots activated - Coureurs enabled (train limit 30)!");
   }
   
   if ((gSouthAfricaRaadsaalSent == false) && 
       (kbTechGetStatus(cTechDEHCREVCapitolSouthAfrica) == cTechStatusActive))
   {
      gSouthAfricaRaadsaalSent = true;
      debugMilitary("South Africa: Raadsaal activated - Capitol enabled!");
   }
   
   if ((gSouthAfricaDiamondRushSent == false) && 
       (kbTechGetStatus(cTechDEHCREVDiamondRush) == cTechStatusActive))
   {
      gSouthAfricaDiamondRushSent = true;
      debugMilitary("South Africa: Diamond Rush activated - 100,000 coin mine!");
   }
   
   if ((gSouthAfricaRobberBaronsSent == false) && 
       (kbTechGetStatus(cTechHCRobberBarons) == cTechStatusActive))
   {
      gSouthAfricaRobberBaronsSent = true;
      debugMilitary("South Africa: Robber Barons activated - Factory delivered!");
   }
}

//==============================================================================
// southAfricaCardManager
//==============================================================================
rule southAfricaCardManager
inactive
minInterval 90
{
   float currentFood = kbResourceGet(cResourceFood);
   float currentWood = kbResourceGet(cResourceWood);
   float currentCoin = kbResourceGet(cResourceGold);
   
   int currentMilitary = aiGetMilitaryPop();
   int settlerCount = kbUnitCount(cMyID, gEconUnit, cUnitStateAlive);
   int gameTime = xsGetTime();
   
   debugMilitary("South Africa Card Manager: Settlers=" + settlerCount + 
                 ", Wanderlust sent " + gSouthAfricaWanderlustCount + "/3 times");
}

//==============================================================================
// southAfricaCivSpecificManager
//==============================================================================
rule southAfricaCivSpecificManager
inactive
minInterval 120
{
   
   if (cMyCiv == cCivBritish)
   {
      
      int bankCount = kbUnitCount(cMyID, cUnitTypeBank, cUnitStateAlive);
      int longbowCount = kbUnitCount(cMyID, cUnitTypeLongbowman, cUnitStateAlive);
      
      debugMilitary("South Africa (British): Banks=" + bankCount + "/2" +
                    ", Longbows=" + longbowCount);
      
      if (bankCount < 2)
      {
         debugMilitary("South Africa (British): Can build " + (2 - bankCount) + " more Banks (Explorer only)");
      }
   }
   else if (cMyCiv == cCivDutch)
   {
      
      bankCount = kbUnitCount(cMyID, cUnitTypeBank, cUnitStateAlive);
      
      debugMilitary("South Africa (Dutch): Banks=" + bankCount + " (gathering 10% faster)");
      
      debugMilitary("South Africa (Dutch): Strong Bank economy synergy!");
   }
}

//==============================================================================
// southAfricaDefenseManager
//==============================================================================
rule southAfricaDefenseManager
inactive
minInterval 45
{
   
   int trekWagonCount = kbUnitCount(cMyID, cUnitTypedeREVStarTrekWagon, cUnitStateAlive);
   int outpostCount = kbUnitCount(cMyID, cUnitTypeOutpost, cUnitStateAlive);
   int warWagonCount = kbUnitCount(cMyID, cUnitTypeWarWagon, cUnitStateAlive);
   
   if (trekWagonCount >= 5 && outpostCount >= 4)
   {
      debugMilitary("South Africa: Good defensive coverage (" + trekWagonCount + 
                    " Trek Wagons, " + outpostCount + " Outposts)");
   }
   else
   {
      debugMilitary("South Africa: Building defenses (" + trekWagonCount + 
                    " Trek Wagons, " + outpostCount + " Outposts)");
   }
   
}

//==============================================================================
// southAfricaCapitolManager
//==============================================================================
rule southAfricaCapitolManager
inactive
minInterval 120
{
   if (gSouthAfricaRaadsaalSent == false)
   {
      if (kbTechGetStatus(cTechDEHCREVCapitolSouthAfrica) == cTechStatusActive)
      {
         gSouthAfricaRaadsaalSent = true;
         debugMilitary("South Africa: Raadsaal activated - Capitol available!");
      }
      else
      {
         return;
      }
   }
   
   int capitolCount = kbUnitCount(cMyID, cUnitTypeCapitol, cUnitStateAlive);
   
   if (capitolCount > 0)
   {
      debugMilitary("South Africa: Capitol built - late game techs available!");
      
   }
   else
   {
      debugMilitary("South Africa: Should build Capitol for late game techs");
   }
}

//==============================================================================
// southAfricaDiamondRushManager
//==============================================================================
rule southAfricaDiamondRushManager
inactive
minInterval 120
{
   if (gSouthAfricaDiamondRushSent == false)
   {
      if (kbTechGetStatus(cTechDEHCREVDiamondRush) == cTechStatusActive)
      {
         gSouthAfricaDiamondRushSent = true;
         debugMilitary("South Africa: Diamond Rush activated - 100,000 coin mine delivered!");
      }
      else
      {
         return;
      }
   }
   
   debugMilitary("South Africa: Diamond Mine active - massive coin income!");
}
