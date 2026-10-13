extern bool gArgentinaCitizenshipSent = false;
extern bool gArgentinaGranaderosSent = false;
extern bool gArgentinaSanMartinSent = false;
extern bool gArgentineMortarsSent = false;
extern bool gArgentinaBuenosAiresSent = false;
extern bool gArgentinaCriollosSent = false;
extern bool gArgentinaFlyingBatterySent = false;

extern int gArgentinaGauchoMaintain = -1;
extern int gArgentinaGranaderoMaintain = -1;
extern int gArgentinaLancerMaintain = -1;
extern int gArgentinaRevolutionaryMaintain = -1;
extern int gArgentinaMortarMaintain = -1;
extern int gArgentinaGatlingMaintain = -1;
extern int gArgentinaSettlerMaintain = -1;
extern int gArgentinaMusketeerMaintain = -1;

//==============================================================================
// argentinaRevolutionManager
//==============================================================================
rule argentinaRevolutionManager
inactive
minInterval 30
{
   int mainBaseID = kbBaseGetMainID(cMyID);
   
   int gauchoCount = kbUnitCount(cMyID, cUnitTypedeREVGaucho, cUnitStateAlive);
   int granaderoCount = kbUnitCount(cMyID, cUnitTypedeREVGranadero, cUnitStateAlive);
   int lancerCount = kbUnitCount(cMyID, cUnitTypeLancer, cUnitStateAlive);
   int revolutionaryCount = kbUnitCount(cMyID, cUnitTypexpColonialMilitia, cUnitStateAlive);
   int mortarCount = kbUnitCount(cMyID, cUnitTypeMortar, cUnitStateAlive);
   int gatlingCount = kbUnitCount(cMyID, cUnitTypexpGatlingGun, cUnitStateAlive);
   
   int sanMartinCount = kbUnitCount(cMyID, cUnitTypedeREVSanMartin, cUnitStateAlive);
   
   debugMilitary("Argentina: Gauchos=" + gauchoCount + 
                 ", Granaderos=" + granaderoCount +
                 ", Lancers=" + lancerCount +
                 ", Revolutionaries=" + revolutionaryCount);
   
   int enemyPlayer = aiGetMostHatedPlayerID();
   if (enemyPlayer < 1)
   {
      enemyPlayer = 2;
   }
   
   int enemyCavalryCount = kbUnitCount(enemyPlayer, cUnitTypeAbstractCavalry, cUnitStateAlive);
   int enemyHeavyCavCount = kbUnitCount(enemyPlayer, cUnitTypeAbstractHeavyCavalry, cUnitStateAlive);
   int enemyHeavyInfCount = kbUnitCount(enemyPlayer, cUnitTypeAbstractHeavyInfantry, cUnitStateAlive);
   int enemyLightInfCount = kbUnitCount(enemyPlayer, cUnitTypeAbstractLightInfantry, cUnitStateAlive);
   int enemyArtilleryCount = kbUnitCount(enemyPlayer, cUnitTypeAbstractArtillery, cUnitStateAlive);
   int enemyBuildingCount = kbUnitCount(enemyPlayer, cUnitTypeBuilding, cUnitStateAlive);
   
   int wantedGauchos = 10;
   
   if (enemyHeavyCavCount > 10)
   {
      wantedGauchos = 15;
   }
   if (enemyArtilleryCount > 5)
   {
      wantedGauchos = wantedGauchos + 5;
   }
   
   float currentFood = kbResourceGet(cResourceFood);
   if (currentFood < 500)
   {
      wantedGauchos = 5;
   }
   
   if (kbProtoUnitAvailable(cUnitTypedeREVGaucho) == true && gArgentinaGauchoMaintain == -1)
   {
      gArgentinaGauchoMaintain = createSimpleMaintainPlan(cUnitTypedeREVGaucho, wantedGauchos, false, mainBaseID, 1);
      aiPlanSetDesiredPriority(gArgentinaGauchoMaintain, 65);
      aiPlanSetActive(gArgentinaGauchoMaintain, true);
      debugMilitary("Argentina: Created Gaucho maintain plan");
   }
   else if (gArgentinaGauchoMaintain >= 0)
   {
      aiPlanSetVariableInt(gArgentinaGauchoMaintain, cTrainPlanNumberToMaintain, 0, wantedGauchos);
   }
   
   int wantedRevolutionaries = 20;
   
   int gameTime = xsGetTime();
   if (gameTime < 15 * 60 * 1000)
   {
      wantedRevolutionaries = 30;
   }
   else
   {
      wantedRevolutionaries = 15;
   }
   
   if (kbProtoUnitAvailable(cUnitTypexpColonialMilitia) == true && gArgentinaRevolutionaryMaintain == -1)
   {
      gArgentinaRevolutionaryMaintain = createSimpleMaintainPlan(cUnitTypexpColonialMilitia, wantedRevolutionaries, false, mainBaseID, 1);
      aiPlanSetDesiredPriority(gArgentinaRevolutionaryMaintain, 55);
      aiPlanSetActive(gArgentinaRevolutionaryMaintain, true);
      debugMilitary("Argentina: Created Revolutionary maintain plan");
   }
   else if (gArgentinaRevolutionaryMaintain >= 0)
   {
      aiPlanSetVariableInt(gArgentinaRevolutionaryMaintain, cTrainPlanNumberToMaintain, 0, wantedRevolutionaries);
   }
   
   if (gArgentinaGranaderosSent == true)
   {
      
      int wantedGranaderos = 15;
      
      if (enemyBuildingCount > 20)
      {
         wantedGranaderos = 20;
      }
      
      if (enemyArtilleryCount > 5)
      {
         wantedGranaderos = wantedGranaderos + 5;
      }
      
      if (kbProtoUnitAvailable(cUnitTypedeREVGranadero) == true && gArgentinaGranaderoMaintain == -1)
      {
         gArgentinaGranaderoMaintain = createSimpleMaintainPlan(cUnitTypedeREVGranadero, wantedGranaderos, false, mainBaseID, 1);
         aiPlanSetDesiredPriority(gArgentinaGranaderoMaintain, 70);
         aiPlanSetActive(gArgentinaGranaderoMaintain, true);
         debugMilitary("Argentina: Created Mounted Granadero maintain plan");
      }
      else if (gArgentinaGranaderoMaintain >= 0)
      {
         aiPlanSetVariableInt(gArgentinaGranaderoMaintain, cTrainPlanNumberToMaintain, 0, wantedGranaderos);
      }
   }
   
}

//==============================================================================
// argentinaArtilleryManager
//==============================================================================
rule argentinaArtilleryManager
inactive
minInterval 45
{
   int mainBaseID = kbBaseGetMainID(cMyID);
   
   int mortarCount = kbUnitCount(cMyID, cUnitTypeMortar, cUnitStateAlive);
   int gatlingCount = kbUnitCount(cMyID, cUnitTypexpGatlingGun, cUnitStateAlive);
   
   int wantedMortars = 4;
   
   if (gArgentineMortarsSent == true)
   {
      wantedMortars = 6;
   }
   
   if (gArgentinaFlyingBatterySent == true)
   {
      wantedMortars = wantedMortars + 2;
   }
   
   if (kbProtoUnitAvailable(cUnitTypeMortar) == true && gArgentinaMortarMaintain == -1)
   {
      gArgentinaMortarMaintain = createSimpleMaintainPlan(cUnitTypeMortar, wantedMortars, false, mainBaseID, 1);
      aiPlanSetDesiredPriority(gArgentinaMortarMaintain, 60);
      aiPlanSetActive(gArgentinaMortarMaintain, true);
      debugMilitary("Argentina: Created Mortar maintain plan");
   }
   else if (gArgentinaMortarMaintain >= 0)
   {
      aiPlanSetVariableInt(gArgentinaMortarMaintain, cTrainPlanNumberToMaintain, 0, wantedMortars);
   }
   
   int wantedGatlings = 4;
   
   int enemyPlayer = aiGetMostHatedPlayerID();
   int enemyInfCount = kbUnitCount(enemyPlayer, cUnitTypeAbstractInfantry, cUnitStateAlive);
   if (enemyInfCount > 30)
   {
      wantedGatlings = 6;
   }
   
   if (kbProtoUnitAvailable(cUnitTypexpGatlingGun) == true && gArgentinaGatlingMaintain == -1)
   {
      gArgentinaGatlingMaintain = createSimpleMaintainPlan(cUnitTypexpGatlingGun, wantedGatlings, false, mainBaseID, 1);
      aiPlanSetDesiredPriority(gArgentinaGatlingMaintain, 55);
      aiPlanSetActive(gArgentinaGatlingMaintain, true);
      debugMilitary("Argentina: Created Gatling Gun maintain plan");
   }
   else if (gArgentinaGatlingMaintain >= 0)
   {
      aiPlanSetVariableInt(gArgentinaGatlingMaintain, cTrainPlanNumberToMaintain, 0, wantedGatlings);
   }
   
   debugMilitary("Argentina Artillery: Mortars=" + mortarCount + "/" + wantedMortars +
                 ", Gatlings=" + gatlingCount + "/" + wantedGatlings);
}

//==============================================================================
// argentinaEconomyManager
//==============================================================================
rule argentinaEconomyManager
inactive
minInterval 60
{
   
   if (gArgentinaCitizenshipSent == false)
   {
      if (kbTechGetStatus(cTechDEHCREVCitizenship) == cTechStatusActive)
      {
         gArgentinaCitizenshipSent = true;
         debugMilitary("Argentina: Citizenship active - Settlers enabled for 70 coin!");
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
   
   if (cMyCiv == cCivGermans)
   {
      if (kbTechGetStatus(cTechHCGermantownFarmers) == cTechStatusActive)
      {
         debugMilitary("Argentina (Germans): Can train Settler Wagons at Mills!");
      }
   }
   
   if (kbProtoUnitAvailable(gEconUnit) == true && gArgentinaSettlerMaintain == -1)
   {
      gArgentinaSettlerMaintain = createSimpleMaintainPlan(gEconUnit, wantedSettlers, false, kbBaseGetMainID(cMyID), 1);
      aiPlanSetDesiredPriority(gArgentinaSettlerMaintain, 70);
      aiPlanSetActive(gArgentinaSettlerMaintain, true);
      debugMilitary("Argentina: Created Settler maintain plan (post-Citizenship)");
   }
   else if (gArgentinaSettlerMaintain >= 0)
   {
      aiPlanSetVariableInt(gArgentinaSettlerMaintain, cTrainPlanNumberToMaintain, 0, wantedSettlers);
   }
   
   debugMilitary("Argentina Economy: Settlers=" + currentSettlers + "/" + wantedSettlers);
}

//==============================================================================
// argentinaLivestockManager
//==============================================================================
rule argentinaLivestockManager
inactive
minInterval 60
{
   
   int cowCount = kbUnitCount(cMyID, cUnitTypeCow, cUnitStateAlive);
   int gauchoCount = kbUnitCount(cMyID, cUnitTypedeREVGaucho, cUnitStateAlive);
   int livestockPenCount = kbUnitCount(cMyID, cUnitTypeLivestockPen, cUnitStateAlive);
   
   debugMilitary("Argentina Livestock: " + cowCount + " Cows, " + 
                 gauchoCount + " Gauchos, " +
                 livestockPenCount + " Livestock Pens");
   
   if ((gauchoCount > 0) && (livestockPenCount < 2))
   {
      debugMilitary("Argentina: Should build Livestock Pen (Gauchos can build)");
   }
   
}

//==============================================================================
// argentinaLombardManager
//==============================================================================
rule argentinaLombardManager
inactive
minInterval 90
{
   
   if (gArgentinaBuenosAiresSent == false)
   {
      if (kbTechGetStatus(cTechDEHCREVBuenosAires) == cTechStatusActive)
      {
         gArgentinaBuenosAiresSent = true;
         debugMilitary("Argentina: Buenos Aires active - Lombards enabled!");
      }
      else if (cMyCiv != cCivDEItalians)
      {
         return;
      }
   }
   
   int lombardCount = kbUnitCount(cMyID, cUnitTypedeLombard, cUnitStateAlive);
   
   if (lombardCount < 1)
   {
      debugMilitary("Argentina: Should build Lombard for resource conversion");
      return;
   }
   
   float currentFood = kbResourceGet(cResourceFood);
   float currentWood = kbResourceGet(cResourceWood);
   float currentCoin = kbResourceGet(cResourceGold);
   
   if ((currentFood < 500) && ((currentWood > 1500) || (currentCoin > 1500)))
   {
      debugMilitary("Argentina: Consider using Lombard to convert to food");
   }
}

//==============================================================================
// argentinaCriollosManager
//==============================================================================
rule argentinaCriollosManager
inactive
minInterval 90
{
   
   if (gArgentinaCriollosSent == false)
   {
      if (kbTechGetStatus(cTechDEHCREVCriollos) == cTechStatusActive)
      {
         gArgentinaCriollosSent = true;
         debugMilitary("Argentina: Criollos active - Spanish Musketeers at Forts!");
      }
      else
      {
         return;
      }
   }
   
   int musketeerCount = kbUnitCount(cMyID, cUnitTypeMusketeer, cUnitStateAlive);
   int fortCount = kbUnitCount(cMyID, cUnitTypeFortFrontier, cUnitStateAlive);
   
   if (fortCount < 1)
   {
      debugMilitary("Argentina: Need Fort to train Spanish Musketeers");
      return;
   }
   
   int wantedMusketeers = 15;
   
   if (cMyCiv == cCivGermans)
   {
      wantedMusketeers = 25;
   }
   
   int enemyPlayer = aiGetMostHatedPlayerID();
   int enemyCavCount = kbUnitCount(enemyPlayer, cUnitTypeAbstractCavalry, cUnitStateAlive);
   
   if (enemyCavCount > 20)
   {
      wantedMusketeers = wantedMusketeers + 10;
   }
   
   if (kbProtoUnitAvailable(cUnitTypeMusketeer) == true && gArgentinaMusketeerMaintain == -1)
   {
      gArgentinaMusketeerMaintain = createSimpleMaintainPlan(cUnitTypeMusketeer, wantedMusketeers, false, kbBaseGetMainID(cMyID), 1);
      aiPlanSetDesiredPriority(gArgentinaMusketeerMaintain, 60);
      aiPlanSetActive(gArgentinaMusketeerMaintain, true);
      debugMilitary("Argentina: Created Spanish Musketeer maintain plan");
   }
   else if (gArgentinaMusketeerMaintain >= 0)
   {
      aiPlanSetVariableInt(gArgentinaMusketeerMaintain, cTrainPlanNumberToMaintain, 0, wantedMusketeers);
   }
   
   debugMilitary("Argentina: Spanish Musketeers=" + musketeerCount + "/" + wantedMusketeers);
}

//==============================================================================
// argentinaNavyManager
//==============================================================================
rule argentinaNavyManager
inactive
minInterval 60
{
   if (gNavyMap == false)
   {
      xsDisableSelf();
      return;
   }
   
   int mainBaseID = kbBaseGetMainID(cMyID);
   
   int ironCladCount = kbUnitCount(cMyID, cUnitTypexpIronclad, cUnitStateAlive);
   
   int enemyPlayer = aiGetMostHatedPlayerID();
   int enemyNavyCount = kbUnitCount(enemyPlayer, cUnitTypeAbstractWarShip, cUnitStateAlive);
   
   int wantedIronclads = 2;
   if (enemyNavyCount > 5)
   {
      wantedIronclads = 4;
   }
   
   debugMilitary("Argentina Navy: Ironclads=" + ironCladCount + "/" + wantedIronclads);
}

//==============================================================================
// argentinaCardManager
//==============================================================================
rule argentinaCardManager
inactive
minInterval 90
{

   if (xsIsRuleEnabled("revolutionSettlerCardPriority") == true)
   {
      return;
   }
   
   float currentFood = kbResourceGet(cResourceFood);
   float currentWood = kbResourceGet(cResourceWood);
   float currentCoin = kbResourceGet(cResourceGold);
   
   int currentMilitary = aiGetMilitaryPop();
   int gameTime = xsGetTime();
   
   debugMilitary("Argentina Card Manager: Evaluating priorities");
}

//==============================================================================
// argentinaCardEffectTracker
//==============================================================================
rule argentinaCardEffectTracker
inactive
minInterval 30
{
   if ((gArgentinaCitizenshipSent == false) && 
       (kbTechGetStatus(cTechDEHCREVCitizenship) == cTechStatusActive))
   {
      gArgentinaCitizenshipSent = true;
      debugMilitary("Argentina: Citizenship activated - Settlers can be trained!");
   }
   
   if ((gArgentinaGranaderosSent == false) && 
       (kbTechGetStatus(cTechDEHCREVGranaderos) == cTechStatusActive))
   {
      gArgentinaGranaderosSent = true;
      debugMilitary("Argentina: Granaderos activated - can train Mounted Granaderos!");
   }
   
   if ((gArgentinaSanMartinSent == false) && 
       (kbTechGetStatus(cTechDEHCREVSanMartin) == cTechStatusActive))
   {
      gArgentinaSanMartinSent = true;
      debugMilitary("Argentina: San Martin activated - Hero deployed!");
   }
   
   if ((gArgentineMortarsSent == false) && 
       (kbTechGetStatus(cTechDEHCREVArgentineMortars) == cTechStatusActive))
   {
      gArgentineMortarsSent = true;
      debugMilitary("Argentina: Argentine Mortars activated - Imperial Howitzers available!");
   }
   
   if ((gArgentinaBuenosAiresSent == false) && 
       (kbTechGetStatus(cTechDEHCREVBuenosAires) == cTechStatusActive))
   {
      gArgentinaBuenosAiresSent = true;
      xsEnableRule("argentinaLombardManager");
      debugMilitary("Argentina: Buenos Aires activated - Lombards enabled!");
   }
   
   if ((gArgentinaCriollosSent == false) && 
       (kbTechGetStatus(cTechDEHCREVCriollos) == cTechStatusActive))
   {
      gArgentinaCriollosSent = true;
      xsEnableRule("argentinaCriollosManager");
      debugMilitary("Argentina: Criollos activated - Spanish Musketeers at Forts!");
   }
   
   if ((gArgentinaFlyingBatterySent == false) && 
       (kbTechGetStatus(cTechDEHCREVFlyingBattery) == cTechStatusActive))
   {
      gArgentinaFlyingBatterySent = true;
      debugMilitary("Argentina: Flying Battery activated - Artillery improved!");
   }
}

//==============================================================================
// argentinaCavalryRaidManager
//==============================================================================
rule argentinaCavalryRaidManager
inactive
minInterval 45
{
   
   int gauchoCount = kbUnitCount(cMyID, cUnitTypedeREVGaucho, cUnitStateAlive);
   int granaderoCount = kbUnitCount(cMyID, cUnitTypedeREVGranadero, cUnitStateAlive);
   int lancerCount = kbUnitCount(cMyID, cUnitTypeLancer, cUnitStateAlive);
   int sanMartinCount = kbUnitCount(cMyID, cUnitTypedeREVSanMartin, cUnitStateAlive);
   
   int totalCavalry = gauchoCount + granaderoCount + lancerCount;
   
   if (totalCavalry > 25)
   {
      debugMilitary("Argentina Cavalry Raid: Strong force (" + totalCavalry + 
                    " cavalry) - good for raid");
      
      if (sanMartinCount > 0)
      {
         debugMilitary("Argentina: San Martin can lead raid with trample mode");
      }
   }
   else if (totalCavalry > 15)
   {
      debugMilitary("Argentina Cavalry: Building raid force (" + totalCavalry + " cavalry)");
   }
   else
   {
      debugMilitary("Argentina Cavalry: Need more cavalry (" + totalCavalry + " total)");
   }
   
}

//==============================================================================
// argentinaCivSpecificManager
//==============================================================================
rule argentinaCivSpecificManager
inactive
minInterval 120
{
   
   if (cMyCiv == cCivGermans)
   {
      
      debugMilitary("Argentina (Germans): Criollos essential for musket infantry");
      
      int uhlanCount = kbUnitCount(cMyID, cUnitTypeUhlan, cUnitStateAlive);
      if (uhlanCount > 0)
      {
         debugMilitary("Argentina (Germans): " + uhlanCount + " Uhlans supporting cavalry");
      }
   }
   else if (cMyCiv == cCivDEItalians)
   {
      
      int lombardCount = kbUnitCount(cMyID, cUnitTypedeLombard, cUnitStateAlive);
      debugMilitary("Argentina (Italians): " + lombardCount + " Lombards for resource conversion");
      debugMilitary("Argentina (Italians): Galilean Mortars are stronger than regular Howitzers!");
   }
   else if (cMyCiv == cCivSpanish)
   {
      
      int haciendaCount = kbUnitCount(cMyID, cUnitTypedeHacienda, cUnitStateAlive);
      if (haciendaCount > 0)
      {
         debugMilitary("Argentina (Spanish): " + haciendaCount + " Haciendas for villager training");
      }
      
      debugMilitary("Argentina (Spanish): Liberation March excellent for cavalry spam");
   }
}

//==============================================================================
// argentinaTavernManager
//==============================================================================
rule argentinaTavernManager
inactive
minInterval 90
{
   
   int tavernCount = kbUnitCount(cMyID, cUnitTypeSaloon, cUnitStateAlive);
   
   if (tavernCount > 0)
   {
      float tavernCoinTrickle = tavernCount * 0.6;
      debugMilitary("Argentina: " + tavernCount + " Taverns providing " + 
                    tavernCoinTrickle + " coin/sec");
   }
   
}
