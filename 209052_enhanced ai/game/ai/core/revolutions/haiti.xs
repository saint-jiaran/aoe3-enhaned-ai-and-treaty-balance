extern bool gHaitiLouvertureLibSent = false;
extern bool gHaitiLetterOfMarqueSent = false;
extern bool gHaitiPicketsSent = false;
extern bool gHaitiAfricanRootsSent = false;
extern bool gHaitiBrethrenCoastSent = false;
extern bool gHaitiCaribBlowgunnersSent = false;

extern int gHaitiMaroonMaintain = -1;
extern int gHaitiPirateMaintain = -1;
extern int gHaitiPicketMaintain = -1;
extern int gHaitiSkirmisherMaintain = -1;
extern int gHaitiFalconetMaintain = -1;
extern int gHaitiPrivateerMaintain = -1;
extern int gHaitiSettlerMaintain = -1;
extern int gHaitiCaribBlowgunnerMaintain = -1;

//==============================================================================
// haitiRevolutionManager
//==============================================================================
rule haitiRevolutionManager
inactive
minInterval 30
{
   int mainBaseID = kbBaseGetMainID(cMyID);
   
   int maroonCount = kbUnitCount(cMyID, cUnitTypexpColonialMilitia, cUnitStateAlive);
   int pirateCount = kbUnitCount(cMyID, cUnitTypePirate, cUnitStateAlive);
   int pikemanCount = kbUnitCount(cMyID, cUnitTypePikeman, cUnitStateAlive);
   int skirmisherCount = kbUnitCount(cMyID, cUnitTypeSkirmisher, cUnitStateAlive);
   int falconetCount = kbUnitCount(cMyID, cUnitTypeFalconet, cUnitStateAlive);
   
   int tcCount = kbUnitCount(cMyID, cUnitTypeTownCenter, cUnitStateAlive);
   int tavernCount = kbUnitCount(cMyID, cUnitTypeSaloon, cUnitStateAlive);
   int pirateSpawners = tcCount + tavernCount;
   
   debugMilitary("Haiti: Maroons=" + maroonCount + 
                 ", Pirates=" + pirateCount +
                 ", Pirate Spawners (TC+Tavern)=" + pirateSpawners);
   
   int enemyPlayer = aiGetMostHatedPlayerID();
   if (enemyPlayer < 1)
   {
      enemyPlayer = 2;
   }
   
   int enemyCavalryCount = kbUnitCount(enemyPlayer, cUnitTypeAbstractCavalry, cUnitStateAlive);
   int enemyHeavyInfCount = kbUnitCount(enemyPlayer, cUnitTypeAbstractHeavyInfantry, cUnitStateAlive);
   int enemyLightInfCount = kbUnitCount(enemyPlayer, cUnitTypeAbstractLightInfantry, cUnitStateAlive);
   int enemyArtilleryCount = kbUnitCount(enemyPlayer, cUnitTypeAbstractArtillery, cUnitStateAlive);
   
   int wantedMaroons = 20;
   
   if (enemyCavalryCount > 15)
   {
      wantedMaroons = 30;
   }
   
   if (enemyLightInfCount > 20 && enemyCavalryCount < 10)
   {
      wantedMaroons = 15;
   }
   
   if (kbProtoUnitAvailable(cUnitTypexpColonialMilitia) == true && gHaitiMaroonMaintain == -1)
   {
      gHaitiMaroonMaintain = createSimpleMaintainPlan(cUnitTypexpColonialMilitia, wantedMaroons, false, mainBaseID, 1);
      aiPlanSetDesiredPriority(gHaitiMaroonMaintain, 65);
      aiPlanSetActive(gHaitiMaroonMaintain, true);
      debugMilitary("Haiti: Created Maroon maintain plan");
   }
   else if (gHaitiMaroonMaintain >= 0)
   {
      aiPlanSetVariableInt(gHaitiMaroonMaintain, cTrainPlanNumberToMaintain, 0, wantedMaroons);
   }
   
   int wantedPirates = 15;
   
   if (enemyHeavyInfCount > 20)
   {
      wantedPirates = 25;
   }
   
   if (kbProtoUnitAvailable(cUnitTypePirate) == true && gHaitiPirateMaintain == -1)
   {
      gHaitiPirateMaintain = createSimpleMaintainPlan(cUnitTypePirate, wantedPirates, false, mainBaseID, 1);
      aiPlanSetDesiredPriority(gHaitiPirateMaintain, 60);
      aiPlanSetActive(gHaitiPirateMaintain, true);
      debugMilitary("Haiti: Created Pirate maintain plan");
   }
   else if (gHaitiPirateMaintain >= 0)
   {
      aiPlanSetVariableInt(gHaitiPirateMaintain, cTrainPlanNumberToMaintain, 0, wantedPirates);
   }
   
   if (gHaitiPicketsSent == true)
   {
      
      int wantedPickets = 15;
      
      if (enemyCavalryCount > 15)
      {
         wantedPickets = 25;
      }
      
      if (kbProtoUnitAvailable(cUnitTypePikeman) == true && gHaitiPicketMaintain == -1)
      {
         gHaitiPicketMaintain = createSimpleMaintainPlan(cUnitTypePikeman, wantedPickets, false, mainBaseID, 1);
         aiPlanSetDesiredPriority(gHaitiPicketMaintain, 55);
         aiPlanSetActive(gHaitiPicketMaintain, true);
         debugMilitary("Haiti: Created Picket maintain plan");
      }
      else if (gHaitiPicketMaintain >= 0)
      {
         aiPlanSetVariableInt(gHaitiPicketMaintain, cTrainPlanNumberToMaintain, 0, wantedPickets);
      }
   }
   
   int wantedSkirmishers = 15;
   
   if (enemyHeavyInfCount > 15)
   {
      wantedSkirmishers = 20;
   }
   
   int unitType = cUnitTypeSkirmisher;
   if (cMyCiv == cCivBritish)
   {
      if (kbProtoUnitAvailable(cUnitTypeLongbowman) == true)
      {
         unitType = cUnitTypeLongbowman;
      }
   }
   
   if (kbProtoUnitAvailable(unitType) == true && gHaitiSkirmisherMaintain == -1)
   {
      gHaitiSkirmisherMaintain = createSimpleMaintainPlan(unitType, wantedSkirmishers, false, mainBaseID, 1);
      aiPlanSetDesiredPriority(gHaitiSkirmisherMaintain, 55);
      aiPlanSetActive(gHaitiSkirmisherMaintain, true);
      debugMilitary("Haiti: Created light infantry maintain plan");
   }
   else if (gHaitiSkirmisherMaintain >= 0)
   {
      aiPlanSetVariableInt(gHaitiSkirmisherMaintain, cTrainPlanNumberToMaintain, 0, wantedSkirmishers);
   }
   
   if (gHaitiCaribBlowgunnersSent == true)
   {
      
      int wantedCaribBlowgunners = 15;
      
      if (kbProtoUnitAvailable(cUnitTypeNatBlowgunWarrior) == true && gHaitiCaribBlowgunnerMaintain == -1)
      {
         gHaitiCaribBlowgunnerMaintain = createSimpleMaintainPlan(cUnitTypeNatBlowgunWarrior, wantedCaribBlowgunners, false, mainBaseID, 1);
         aiPlanSetDesiredPriority(gHaitiCaribBlowgunnerMaintain, 50);
         aiPlanSetActive(gHaitiCaribBlowgunnerMaintain, true);
         debugMilitary("Haiti: Created Carib Blowgunner maintain plan");
      }
      else if (gHaitiCaribBlowgunnerMaintain >= 0)
      {
         aiPlanSetVariableInt(gHaitiCaribBlowgunnerMaintain, cTrainPlanNumberToMaintain, 0, wantedCaribBlowgunners);
      }
   }
   
   debugMilitary("Haiti targets: Maroons=" + wantedMaroons + 
                 ", Pirates=" + wantedPirates +
                 ", Skirmishers=" + wantedSkirmishers);
}

//==============================================================================
// haitiPirateSpawnManager
//==============================================================================
rule haitiPirateSpawnManager
inactive
minInterval 60
{
   
   int tcCount = kbUnitCount(cMyID, cUnitTypeTownCenter, cUnitStateAlive);
   int tavernCount = kbUnitCount(cMyID, cUnitTypeSaloon, cUnitStateAlive);
   int totalSpawners = tcCount + tavernCount;
   
   float piratesPerMinute = totalSpawners * 1.25;
   
   debugMilitary("Haiti Pirate Spawning: " + totalSpawners + " spawners = ~" + 
                 piratesPerMinute + " Pirates/min");
   
   int tcBuildLimit = kbGetBuildLimit(cMyID, cUnitTypeTownCenter);
   if (tcCount < tcBuildLimit)
   {
      debugMilitary("Haiti: Can build " + (tcBuildLimit - tcCount) + " more Town Centers for Pirate spawning");
   }
}

//==============================================================================
// haitiNavyManager
//==============================================================================
rule haitiNavyManager
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
   int galleonCount = kbUnitCount(cMyID, cUnitTypeGalleon, cUnitStateAlive);
   
   int enemyPlayer = aiGetMostHatedPlayerID();
   int enemyNavyCount = kbUnitCount(enemyPlayer, cUnitTypeAbstractWarShip, cUnitStateAlive);
   
   int wantedPrivateers = 5;
   
   if (kbProtoUnitAvailable(cUnitTypePrivateer) == true && gHaitiPrivateerMaintain == -1)
   {
      gHaitiPrivateerMaintain = createSimpleMaintainPlan(cUnitTypePrivateer, wantedPrivateers, false, mainBaseID, 1);
      aiPlanSetDesiredPriority(gHaitiPrivateerMaintain, 50);
      aiPlanSetActive(gHaitiPrivateerMaintain, true);
      debugMilitary("Haiti: Created Privateer maintain plan");
   }
   else if (gHaitiPrivateerMaintain >= 0)
   {
      aiPlanSetVariableInt(gHaitiPrivateerMaintain, cTrainPlanNumberToMaintain, 0, wantedPrivateers);
   }
   
   debugMilitary("Haiti Navy: Privateers=" + privateerCount + "/" + wantedPrivateers);
   
   if (gHaitiLetterOfMarqueSent == true)
   {
      float coinPerSec = privateerCount * 0.5;
      debugMilitary("Haiti: Privateers generating ~" + coinPerSec + " coin/sec");
   }
}

//==============================================================================
// haitiEconomyManager
//==============================================================================
rule haitiEconomyManager
inactive
minInterval 60
{
   
   if (gHaitiLouvertureLibSent == false)
   {
      if (kbTechGetStatus(cTechDEHCREVCitizenshipHaiti) == cTechStatusActive)
      {
         gHaitiLouvertureLibSent = true;
         debugMilitary("Haiti: Louverture Liberation active - Settlers enabled for 70 coin!");
      }
      else
      {
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
   
   if (kbProtoUnitAvailable(gEconUnit) == true && gHaitiSettlerMaintain == -1)
   {
      gHaitiSettlerMaintain = createSimpleMaintainPlan(gEconUnit, wantedSettlers, false, kbBaseGetMainID(cMyID), 1);
      aiPlanSetDesiredPriority(gHaitiSettlerMaintain, 70);
      aiPlanSetActive(gHaitiSettlerMaintain, true);
      debugMilitary("Haiti: Created Settler maintain plan (post-Louverture Liberation)");
   }
   else if (gHaitiSettlerMaintain >= 0)
   {
      aiPlanSetVariableInt(gHaitiSettlerMaintain, cTrainPlanNumberToMaintain, 0, wantedSettlers);
   }
   
   debugMilitary("Haiti Economy: Settlers=" + currentSettlers + "/" + wantedSettlers);
}

//==============================================================================
// haitiArtilleryManager
//==============================================================================
rule haitiArtilleryManager
inactive
minInterval 45
{
   int mainBaseID = kbBaseGetMainID(cMyID);
   
   int falconetCount = kbUnitCount(cMyID, cUnitTypeFalconet, cUnitStateAlive);
   
   int enemyPlayer = aiGetMostHatedPlayerID();
   int enemyInfantryCount = kbUnitCount(enemyPlayer, cUnitTypeAbstractInfantry, cUnitStateAlive);
   
   int wantedFalconets = 5;
   
   if (enemyInfantryCount > 30)
   {
      wantedFalconets = 8;
   }
   
   if (kbProtoUnitAvailable(cUnitTypeFalconet) == true && gHaitiFalconetMaintain == -1)
   {
      gHaitiFalconetMaintain = createSimpleMaintainPlan(cUnitTypeFalconet, wantedFalconets, false, mainBaseID, 1);
      aiPlanSetDesiredPriority(gHaitiFalconetMaintain, 55);
      aiPlanSetActive(gHaitiFalconetMaintain, true);
      debugMilitary("Haiti: Created Falconet maintain plan");
   }
   else if (gHaitiFalconetMaintain >= 0)
   {
      aiPlanSetVariableInt(gHaitiFalconetMaintain, cTrainPlanNumberToMaintain, 0, wantedFalconets);
   }
   
   debugMilitary("Haiti Artillery: Falconets=" + falconetCount + "/" + wantedFalconets);
}

//==============================================================================
// haitiCardEffectTracker
//==============================================================================
rule haitiCardEffectTracker
inactive
minInterval 30
{
   if ((gHaitiLouvertureLibSent == false) && 
       (kbTechGetStatus(cTechDEHCREVCitizenshipHaiti) == cTechStatusActive))
   {
      gHaitiLouvertureLibSent = true;
      debugMilitary("Haiti: Louverture Liberation activated - Settlers can be trained!");
   }
   
   if ((gHaitiLetterOfMarqueSent == false) && 
       (kbTechGetStatus(cTechDEHCREVLetterOfMarque) == cTechStatusActive))
   {
      gHaitiLetterOfMarqueSent = true;
      debugMilitary("Haiti: Letter of Marque activated - Pirates upgraded to Buccaneers!");
   }
   
   if ((gHaitiPicketsSent == false) && 
       (kbTechGetStatus(cTechDEHCREVPickets) == cTechStatusActive))
   {
      gHaitiPicketsSent = true;
      debugMilitary("Haiti: Pickets activated - Pikemen upgraded!");
   }
   
   if ((gHaitiAfricanRootsSent == false) && 
       (kbTechGetStatus(cTechDEHCREVAfricanAllies) == cTechStatusActive))
   {
      gHaitiAfricanRootsSent = true;
      debugMilitary("Haiti: African Roots activated - Akan/Yoruba allies, stealth for Maroons!");
   }
   
   if ((gHaitiBrethrenCoastSent == false) && 
       (kbTechGetStatus(cTechDEMaroonAlliesAkan) == cTechStatusActive))
   {
      gHaitiBrethrenCoastSent = true;
      debugMilitary("Haiti: Brethren of the Coast activated - Battleship delivered!");
   }
   
   if ((gHaitiCaribBlowgunnersSent == false) && 
       (kbTechGetStatus(cTechDEHCREVShipCaribBlowgunner) == cTechStatusActive))
   {
      gHaitiCaribBlowgunnersSent = true;
      debugMilitary("Haiti: Carib Blowgunners activated - can train at Barracks/Forts!");
   }
}

//==============================================================================
// haitiCardManager
//==============================================================================
rule haitiCardManager
inactive
minInterval 90
{
   float currentFood = kbResourceGet(cResourceFood);
   float currentWood = kbResourceGet(cResourceWood);
   float currentCoin = kbResourceGet(cResourceGold);
   
   int currentMilitary = aiGetMilitaryPop();
   int tcCount = kbUnitCount(cMyID, cUnitTypeTownCenter, cUnitStateAlive);
   int pirateCount = kbUnitCount(cMyID, cUnitTypePirate, cUnitStateAlive);
   
   debugMilitary("Haiti Card Manager: TCs=" + tcCount + 
                 ", Pirates=" + pirateCount);
}

//==============================================================================
// haitiCivSpecificManager
//==============================================================================
rule haitiCivSpecificManager
inactive
minInterval 120
{
   
   if (cMyCiv == cCivBritish)
   {
      
      int longbowCount = kbUnitCount(cMyID, cUnitTypeLongbowman, cUnitStateAlive);
      
      debugMilitary("Haiti (British): Longbows=" + longbowCount);
      
      debugMilitary("Haiti (British): Maroons can be trained at Manor Houses!");
   }
   else if (cMyCiv == cCivFrench)
   {
      
      debugMilitary("Haiti (French): Strong native warrior synergies!");
      
      if (kbTechGetStatus(cTechHCXPGribeauvalSystem) == cTechStatusActive)
      {
         debugMilitary("Haiti (French): Gribeauval System active - Falconets buffed!");
      }
   }
}

//==============================================================================
// haitiLetterOfMarqueManager
//==============================================================================
rule haitiLetterOfMarqueManager
inactive
minInterval 60
{
   if (gHaitiLetterOfMarqueSent == false)
   {
      if (kbTechGetStatus(cTechDEHCREVLetterOfMarque) == cTechStatusActive)
      {
         gHaitiLetterOfMarqueSent = true;
         debugMilitary("Haiti: Letter of Marque activated!");
      }
      else
      {
         return;
      }
   }
   
   int pirateCount = kbUnitCount(cMyID, cUnitTypePirate, cUnitStateAlive);
   int privateerCount = kbUnitCount(cMyID, cUnitTypePrivateer, cUnitStateAlive);
   
   float coinPerSec = privateerCount * 0.5;
   
   debugMilitary("Haiti Letter of Marque: " + pirateCount + " Buccaneers, " +
                 privateerCount + " Privateers generating " + coinPerSec + " coin/sec");
   
   int treasureCount = kbUnitCount(0, cUnitTypeNugget, cUnitStateAlive);
   if (treasureCount > 0)
   {
      debugMilitary("Haiti: " + treasureCount + " treasures remain - Buccaneers can collect!");
   }
}

//==============================================================================
// haitiTownCenterManager
//==============================================================================
rule haitiTownCenterManager
inactive
minInterval 90
{
   
   int tcCount = kbUnitCount(cMyID, cUnitTypeTownCenter, cUnitStateAlive);
   int tcBuildLimit = kbGetBuildLimit(cMyID, cUnitTypeTownCenter);
   
   int coveredWagonCount = kbUnitCount(cMyID, cUnitTypeCoveredWagon, cUnitStateAlive);
   
   debugMilitary("Haiti Town Centers: " + tcCount + "/" + tcBuildLimit + 
                 ", Covered Wagons: " + coveredWagonCount);
   
   if (tcCount < tcBuildLimit)
   {
      debugMilitary("Haiti: Should build more Town Centers for Pirate spawning!");
      debugMilitary("Haiti: 2 Covered Wagons (INFINITE) card is critical!");
   }
   
   float piratesPerMin = tcCount * 1.25;
   debugMilitary("Haiti: " + tcCount + " TCs spawning ~" + piratesPerMin + " Pirates/min");
}

//==============================================================================
// haitiAfricanRootsManager
//==============================================================================
rule haitiAfricanRootsManager
inactive
minInterval 120
{
   if (gHaitiAfricanRootsSent == false)
   {
      if (kbTechGetStatus(cTechDEHCREVAfricanAllies) == cTechStatusActive)
      {
         gHaitiAfricanRootsSent = true;
         debugMilitary("Haiti: African Roots activated!");
      }
      else
      {
         return;
      }
   }
   
   debugMilitary("Haiti African Roots: Maroons can use Stealth!");
   debugMilitary("Haiti African Roots: Can ally with Akan/Yoruba at Native Embassy!");
}
