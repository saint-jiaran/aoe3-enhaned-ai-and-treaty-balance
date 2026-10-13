extern bool gMinasGeraisSent = false;
extern bool gJaguncosSent = false;
extern bool gGuardOfHonorSent = false;
extern bool gRioDeJaneiroSent = false;

extern int gBrazilJaguncoMaintain = -1;
extern int gBrazilDragoonMaintain = -1;
extern int gBrazilGatlingMaintain = -1;
extern int gBrazilSettlerMaintain = -1;
extern int gBrazilIroncladMaintain = -1;

//==============================================================================
// brazilRevolutionManager
//==============================================================================
rule brazilRevolutionManager
inactive
minInterval 30
{
   int mainBaseID = kbBaseGetMainID(cMyID);
   
   int voluntarioCount = kbUnitCount(cMyID, cUnitTypexpColonialMilitia, cUnitStateAlive);
   int jaguncoCount = kbUnitCount(cMyID, cUnitTypedeREVJagunco, cUnitStateAlive);
   int dragoonCount = kbUnitCount(cMyID, cUnitTypeDragoon, cUnitStateAlive);
   int gatlingCount = kbUnitCount(cMyID, cUnitTypexpGatlingGun, cUnitStateAlive);
   
   int tcCount = kbUnitCount(cMyID, cUnitTypeTownCenter, cUnitStateAlive);
   
   float expectedVoluntariosPerMinute = tcCount * (9.0 / 146.0) * 60.0;
   
   debugMilitary("Brazil: Voluntarios=" + voluntarioCount + 
                 ", TCs=" + tcCount + 
                 " (spawn rate: ~" + expectedVoluntariosPerMinute + "/min)");
   
   int enemyPlayer = aiGetMostHatedPlayerID();
   if (enemyPlayer < 1)
   {
      enemyPlayer = 2;
   }
   
   int enemyCavalryCount = kbUnitCount(enemyPlayer, cUnitTypeAbstractCavalry, cUnitStateAlive);
   int enemyHeavyInfCount = kbUnitCount(enemyPlayer, cUnitTypeAbstractHeavyInfantry, cUnitStateAlive);
   int enemyLightInfCount = kbUnitCount(enemyPlayer, cUnitTypeAbstractLightInfantry, cUnitStateAlive);
   int enemyArtilleryCount = kbUnitCount(enemyPlayer, cUnitTypeAbstractArtillery, cUnitStateAlive);
   
   if (gJaguncosSent == true)
   {
      
      int wantedJaguncos = 10;
      
      if (enemyHeavyInfCount > 15)
      {
         wantedJaguncos = 20;
      }
      
      if (enemyLightInfCount < 10)
      {
         wantedJaguncos = wantedJaguncos + 5;
      }
      
      if (kbProtoUnitAvailable(cUnitTypedeREVJagunco) == true && gBrazilJaguncoMaintain == -1)
      {
         gBrazilJaguncoMaintain = createSimpleMaintainPlan(cUnitTypedeREVJagunco, wantedJaguncos, false, mainBaseID, 1);
         aiPlanSetDesiredPriority(gBrazilJaguncoMaintain, 60);
         aiPlanSetActive(gBrazilJaguncoMaintain, true);
         debugMilitary("Brazil: Created Jagunco maintain plan");
      }
      else if (gBrazilJaguncoMaintain >= 0)
      {
         aiPlanSetVariableInt(gBrazilJaguncoMaintain, cTrainPlanNumberToMaintain, 0, wantedJaguncos);
      }
   }
   
   if (gGuardOfHonorSent == true)
   {
      int wantedDragoons = 8;
      
      if (enemyArtilleryCount > 5)
      {
         wantedDragoons = 15;
      }
      
      if (kbProtoUnitAvailable(cUnitTypeDragoon) == true && gBrazilDragoonMaintain == -1)
      {
         gBrazilDragoonMaintain = createSimpleMaintainPlan(cUnitTypeDragoon, wantedDragoons, false, mainBaseID, 1);
         aiPlanSetDesiredPriority(gBrazilDragoonMaintain, 55);
         aiPlanSetActive(gBrazilDragoonMaintain, true);
         debugMilitary("Brazil: Created Independence Dragoon maintain plan");
      }
      else if (gBrazilDragoonMaintain >= 0)
      {
         aiPlanSetVariableInt(gBrazilDragoonMaintain, cTrainPlanNumberToMaintain, 0, wantedDragoons);
      }
   }
   
   int wantedGatlings = 4;
   
   if (enemyHeavyInfCount + enemyLightInfCount > 30)
   {
      wantedGatlings = 6;
   }
   
   if (kbProtoUnitAvailable(cUnitTypexpGatlingGun) == true && gBrazilGatlingMaintain == -1)
   {
      gBrazilGatlingMaintain = createSimpleMaintainPlan(cUnitTypexpGatlingGun, wantedGatlings, false, mainBaseID, 1);
      aiPlanSetDesiredPriority(gBrazilGatlingMaintain, 50);
      aiPlanSetActive(gBrazilGatlingMaintain, true);
      debugMilitary("Brazil: Created Gatling Gun maintain plan");
   }
   else if (gBrazilGatlingMaintain >= 0)
   {
      aiPlanSetVariableInt(gBrazilGatlingMaintain, cTrainPlanNumberToMaintain, 0, wantedGatlings);
   }
   
   debugMilitary("Brazil composition: Jaguncos=" + jaguncoCount + 
                 ", Dragoons=" + dragoonCount +
                 ", Gatlings=" + gatlingCount);
}

//==============================================================================
// brazilTownCenterManager
//==============================================================================
rule brazilTownCenterManager
inactive
minInterval 45
{
   
   int currentTCs = kbUnitCount(cMyID, cUnitTypeTownCenter, cUnitStateAlive);
   int tcBuildLimit = kbGetBuildLimit(cMyID, cUnitTypeTownCenter);
   
   int coveredWagonCount = kbUnitCount(cMyID, cUnitTypeCoveredWagon, cUnitStateAlive);
   
   debugMilitary("Brazil TCs: " + currentTCs + "/" + tcBuildLimit + 
                 ", Covered Wagons: " + coveredWagonCount);
   
   if ((currentTCs < tcBuildLimit) && (coveredWagonCount > 0))
   {
      debugMilitary("Brazil: Should place Covered Wagon for new TC");
   }
   
}

//==============================================================================
// brazilEconomyManager
//==============================================================================
rule brazilEconomyManager
inactive
minInterval 60
{
   
   if (gMinasGeraisSent == false)
   {
      if (kbTechGetStatus(cTechDEHCREVMinasGerais) == cTechStatusActive)
      {
         gMinasGeraisSent = true;
         debugMilitary("Brazil: Minas Gerais active - Settlers enabled for 70 coin!");
      }
      else
      {
         return;
      }
   }
   
   int currentSettlers = kbUnitCount(cMyID, gEconUnit, cUnitStateAlive);
   
   int wantedSettlers = 20;
   
   float currentCoin = kbResourceGet(cResourceGold);
   if (currentCoin < 500)
   {
      wantedSettlers = 10;
   }
   
   if (kbProtoUnitAvailable(gEconUnit) == true && gBrazilSettlerMaintain == -1)
   {
      gBrazilSettlerMaintain = createSimpleMaintainPlan(gEconUnit, wantedSettlers, false, kbBaseGetMainID(cMyID), 1);
      aiPlanSetDesiredPriority(gBrazilSettlerMaintain, 65);
      aiPlanSetActive(gBrazilSettlerMaintain, true);
      debugMilitary("Brazil: Created Settler maintain plan (post-Minas Gerais)");
   }
   else if (gBrazilSettlerMaintain >= 0)
   {
      aiPlanSetVariableInt(gBrazilSettlerMaintain, cTrainPlanNumberToMaintain, 0, wantedSettlers);
   }
   
   debugMilitary("Brazil Economy: Settlers=" + currentSettlers + "/" + wantedSettlers);
}

//==============================================================================
// brazilCapitolManager
//==============================================================================
rule brazilCapitolManager
inactive
minInterval 90
{
   
   if (gRioDeJaneiroSent == false)
   {
      if (kbTechGetStatus(cTechDEHCREVCapitolBrazil) == cTechStatusActive)
      {
         gRioDeJaneiroSent = true;
         debugMilitary("Brazil: Rio de Janeiro active - Capitol enabled!");
      }
      else
      {
         return;
      }
   }
   
   int capitolCount = kbUnitCount(cMyID, cUnitTypeCapitol, cUnitStateAlive);
   
   if (capitolCount < 1)
   {
      debugMilitary("Brazil: Should build Capitol");
      return;
   }
   
   int capitolID = getUnit(cUnitTypeCapitol, cMyID, cUnitStateAlive);
   if (capitolID >= 0)
   {
      if (kbTechGetStatus(cTechImpKnighthood) == cTechStatusObtainable)
      {
         researchSimpleTech(cTechImpKnighthood, -1, capitolID, 50);
      }
      
      if (kbTechGetStatus(cTechImpPeerage) == cTechStatusObtainable)
      {
         researchSimpleTech(cTechImpPeerage, -1, capitolID, 45);
      }
      
      int nativeCount = kbUnitCount(cMyID, cUnitTypeAbstractNativeWarrior, cUnitStateAlive);
      if ((nativeCount > 10) && (kbTechGetStatus(cTechImpLegendaryNatives) == cTechStatusObtainable))
      {
         researchSimpleTech(cTechImpLegendaryNatives, -1, capitolID, 40);
      }
   }
}

//==============================================================================
// brazilNavyManager
//==============================================================================
rule brazilNavyManager
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
   
   if (kbProtoUnitAvailable(cUnitTypexpIronclad) == true && gBrazilIroncladMaintain == -1)
   {
      gBrazilIroncladMaintain = createSimpleMaintainPlan(cUnitTypexpIronclad, wantedIronclads, false, mainBaseID, 1);
      aiPlanSetDesiredPriority(gBrazilIroncladMaintain, 55);
      aiPlanSetActive(gBrazilIroncladMaintain, true);
      debugMilitary("Brazil: Created Ironclad maintain plan");
   }
   else if (gBrazilIroncladMaintain >= 0)
   {
      aiPlanSetVariableInt(gBrazilIroncladMaintain, cTrainPlanNumberToMaintain, 0, wantedIronclads);
   }
   
   debugMilitary("Brazil Navy: Ironclads=" + ironCladCount + "/" + wantedIronclads);
}

//==============================================================================
// brazilLivestockManager
//==============================================================================
rule brazilLivestockManager
inactive
minInterval 60
{
   
   int cowCount = kbUnitCount(cMyID, cUnitTypeCow, cUnitStateAlive);
   int jaguncoCount = kbUnitCount(cMyID, cUnitTypedeREVJagunco, cUnitStateAlive);
   
   if ((cowCount > 0) && (jaguncoCount > 0))
   {
      debugMilitary("Brazil Livestock: " + cowCount + " Cows, " + 
                    jaguncoCount + " Jaguncos can gather");
   }
   
   int livestockPenCount = kbUnitCount(cMyID, cUnitTypeLivestockPen, cUnitStateAlive);
   
   if ((gJaguncosSent == true) && (livestockPenCount < 1) && (jaguncoCount > 0))
   {
      debugMilitary("Brazil: Should build Livestock Pen (Jaguncos can build)");
   }
}

//==============================================================================
// brazilCardManager
//==============================================================================
rule brazilCardManager
inactive
minInterval 90
{
   float currentFood = kbResourceGet(cResourceFood);
   float currentWood = kbResourceGet(cResourceWood);
   float currentCoin = kbResourceGet(cResourceGold);
   
   int currentMilitary = aiGetMilitaryPop();
   int gameTime = xsGetTime();
   int tcCount = kbUnitCount(cMyID, cUnitTypeTownCenter, cUnitStateAlive);
   
   debugMilitary("Brazil Card Manager: Evaluating priorities (TCs: " + tcCount + ")");
}

//==============================================================================
// brazilCardEffectTracker
//==============================================================================
rule brazilCardEffectTracker
inactive
minInterval 30
{
   if ((gMinasGeraisSent == false) && 
       (kbTechGetStatus(cTechDEHCREVMinasGerais) == cTechStatusActive))
   {
      gMinasGeraisSent = true;
      debugMilitary("Brazil: Minas Gerais activated - Settlers can be trained!");
   }
   
   if ((gJaguncosSent == false) && 
       (kbTechGetStatus(cTechDEHCREVJaguncos) == cTechStatusActive))
   {
      gJaguncosSent = true;
      debugMilitary("Brazil: Jaguncos activated - can train Jaguncos!");
   }
   
   if ((gGuardOfHonorSent == false) && 
       (kbTechGetStatus(cTechDEHCREVHonorGuard) == cTechStatusActive))
   {
      gGuardOfHonorSent = true;
      debugMilitary("Brazil: Guard of Honor activated - Independence Dragoons enabled!");
   }
   
   if ((gRioDeJaneiroSent == false) && 
       (kbTechGetStatus(cTechDEHCREVCapitolBrazil) == cTechStatusActive))
   {
      gRioDeJaneiroSent = true;
      xsEnableRule("brazilCapitolManager");
      debugMilitary("Brazil: Rio de Janeiro activated - Capitol enabled!");
   }
}

//==============================================================================
// brazilSwarmManager
//==============================================================================
rule brazilSwarmManager
inactive
minInterval 45
{
   
   int voluntarioCount = kbUnitCount(cMyID, cUnitTypexpColonialMilitia, cUnitStateAlive);
   int tcCount = kbUnitCount(cMyID, cUnitTypeTownCenter, cUnitStateAlive);
   
   float spawnRatePerMinute = tcCount * 3.7;
   
   int totalMilitary = aiGetMilitaryPop() - aiGetAvailableMilitaryPop();
   
   if (voluntarioCount > 50)
   {
      debugMilitary("Brazil Swarm: Strong mass (" + voluntarioCount + 
                    " Voluntarios) - should attack");
   }
   else if (voluntarioCount > 30)
   {
      debugMilitary("Brazil Swarm: Building mass (" + voluntarioCount + 
                    " Voluntarios) - spawn rate: " + spawnRatePerMinute + "/min");
   }
   else
   {
      debugMilitary("Brazil Swarm: Need more Voluntarios (" + voluntarioCount + 
                    ") - consider more TCs");
   }
   
}

//==============================================================================
// brazilCivSpecificManager
//==============================================================================
rule brazilCivSpecificManager
inactive
minInterval 120
{
   
   if (cMyCiv == cCivDutch)
   {
      
      int bankCount = kbUnitCount(cMyID, cUnitTypeBank, cUnitStateAlive);
      debugMilitary("Brazil (Dutch): " + bankCount + " Banks providing coin trickle");
   }
   else if (cMyCiv == cCivDEItalians)
   {
      
      int lombardCount = kbUnitCount(cMyID, cUnitTypedeLombard, cUnitStateAlive);
      debugMilitary("Brazil (Italians): " + lombardCount + " Lombards for resource conversion");
   }
   else if (cMyCiv == cCivPortuguese)
   {
      
      int tcCount = kbUnitCount(cMyID, cUnitTypeTownCenter, cUnitStateAlive);
      debugMilitary("Brazil (Portuguese): " + tcCount + " TCs (best TC synergy)");
   }
}
