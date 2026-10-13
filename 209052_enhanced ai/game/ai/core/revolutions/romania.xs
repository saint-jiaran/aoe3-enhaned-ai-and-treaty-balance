extern bool gRomaniaCitizenshipSent = false;
extern bool gRomaniaHajduksSent = false;
extern bool gRomaniaWallachianHorseArchersSent = false;
extern bool gRomaniaRosiorDragoonsSent = false;
extern bool gRomaniaCrabatsSent = false;
extern bool gRomaniaPandoursSent = false;
extern bool gRomaniaMilitaryFrontierSent = false;

extern int gRomaniaDorobantMaintain = -1;
extern int gRomaniaRosiorDragoonMaintain = -1;
extern int gRomaniaWallachianHorseArcherMaintain = -1;
extern int gRomaniaHajdukMaintain = -1;
extern int gRomaniaCrabatMaintain = -1;
extern int gRomaniaPandourMaintain = -1;
extern int gRomaniaSettlerMaintain = -1;
extern int gRomaniaHorseArtilleryMaintain = -1;
extern int gRomaniaGalleyMaintain = -1;

//==============================================================================
// romaniaRevolutionManager
//==============================================================================
rule romaniaRevolutionManager
inactive
minInterval 30
{
   int mainBaseID = kbBaseGetMainID(cMyID);
   
   int dorobantCount = kbUnitCount(cMyID, cUnitTypexpColonialMilitia, cUnitStateAlive);
   int rosiorDragoonCount = kbUnitCount(cMyID, cUnitTypeDragoon, cUnitStateAlive);
   int wallachianHorseArcherCount = kbUnitCount(cMyID, cUnitTypeCavalryArcher, cUnitStateAlive);
   int hajdukCount = kbUnitCount(cMyID, cUnitTypedeSaloonHajduk, cUnitStateAlive);
   int crabatCount = kbUnitCount(cMyID, cUnitTypedeSaloonCrabat, cUnitStateAlive);
   int pandourCount = kbUnitCount(cMyID, cUnitTypedeMercPandour, cUnitStateAlive);
   
   int outpostCount = kbUnitCount(cMyID, cUnitTypeOutpost, cUnitStateAlive);
   int blockhouseCount = kbUnitCount(cMyID, cUnitTypeBlockhouse, cUnitStateAlive);
   int totalDefenses = outpostCount + blockhouseCount;
   
   debugMilitary("Romania: Dorobants=" + dorobantCount + 
                 ", Rosior Dragoons=" + rosiorDragoonCount +
                 ", Wallachian Horse Archers=" + wallachianHorseArcherCount +
                 ", Outposts/Blockhouses=" + totalDefenses);
   
   int enemyPlayer = aiGetMostHatedPlayerID();
   if (enemyPlayer < 1)
   {
      enemyPlayer = 2;
   }
   
   int enemyCavalryCount = kbUnitCount(enemyPlayer, cUnitTypeAbstractCavalry, cUnitStateAlive);
   int enemyHeavyInfCount = kbUnitCount(enemyPlayer, cUnitTypeAbstractHeavyInfantry, cUnitStateAlive);
   int enemyLightInfCount = kbUnitCount(enemyPlayer, cUnitTypeAbstractLightInfantry, cUnitStateAlive);
   int enemyArtilleryCount = kbUnitCount(enemyPlayer, cUnitTypeAbstractArtillery, cUnitStateAlive);
   int enemyBuildingCount = kbUnitCount(enemyPlayer, cUnitTypeBuilding, cUnitStateAlive);
   
   int wantedDorobants = 20;
   
   if (enemyCavalryCount > 15)
   {
      wantedDorobants = 30;
   }
   
   if (enemyLightInfCount > 20 && enemyCavalryCount < 10)
   {
      wantedDorobants = 15;
   }
   
   if (kbProtoUnitAvailable(cUnitTypexpColonialMilitia) == true && gRomaniaDorobantMaintain == -1)
   {
      gRomaniaDorobantMaintain = createSimpleMaintainPlan(cUnitTypexpColonialMilitia, wantedDorobants, false, mainBaseID, 1);
      aiPlanSetDesiredPriority(gRomaniaDorobantMaintain, 65);
      aiPlanSetActive(gRomaniaDorobantMaintain, true);
      debugMilitary("Romania: Created Dorobant maintain plan");
   }
   else if (gRomaniaDorobantMaintain >= 0)
   {
      aiPlanSetVariableInt(gRomaniaDorobantMaintain, cTrainPlanNumberToMaintain, 0, wantedDorobants);
   }
   
   int wantedRosiorDragoons = 15;
   
   if (enemyLightInfCount > 15 || enemyArtilleryCount > 5)
   {
      wantedRosiorDragoons = 20;
   }
   
   if (enemyCavalryCount > 20)
   {
      wantedRosiorDragoons = 10;
   }
   
   if (kbProtoUnitAvailable(cUnitTypeDragoon) == true && gRomaniaRosiorDragoonMaintain == -1)
   {
      gRomaniaRosiorDragoonMaintain = createSimpleMaintainPlan(cUnitTypeDragoon, wantedRosiorDragoons, false, mainBaseID, 1);
      aiPlanSetDesiredPriority(gRomaniaRosiorDragoonMaintain, 70);
      aiPlanSetActive(gRomaniaRosiorDragoonMaintain, true);
      debugMilitary("Romania: Created Rosior Dragoon maintain plan");
   }
   else if (gRomaniaRosiorDragoonMaintain >= 0)
   {
      aiPlanSetVariableInt(gRomaniaRosiorDragoonMaintain, cTrainPlanNumberToMaintain, 0, wantedRosiorDragoons);
   }
   
   if (gRomaniaWallachianHorseArchersSent == true)
   {
      
      int wantedWallachianHorseArchers = 10;
      
      if (enemyCavalryCount > 15)
      {
         wantedWallachianHorseArchers = 15;
      }
      
      if (kbProtoUnitAvailable(cUnitTypeCavalryArcher) == true && gRomaniaWallachianHorseArcherMaintain == -1)
      {
         gRomaniaWallachianHorseArcherMaintain = createSimpleMaintainPlan(cUnitTypeCavalryArcher, wantedWallachianHorseArchers, false, mainBaseID, 1);
         aiPlanSetDesiredPriority(gRomaniaWallachianHorseArcherMaintain, 60);
         aiPlanSetActive(gRomaniaWallachianHorseArcherMaintain, true);
         debugMilitary("Romania: Created Wallachian Horse Archer maintain plan");
      }
      else if (gRomaniaWallachianHorseArcherMaintain >= 0)
      {
         aiPlanSetVariableInt(gRomaniaWallachianHorseArcherMaintain, cTrainPlanNumberToMaintain, 0, wantedWallachianHorseArchers);
      }
   }
   
   if (gRomaniaHajduksSent == true)
   {
      
      int wantedHajduks = 10;
      
      if (enemyLightInfCount > 15)
      {
         wantedHajduks = 20;
      }
      
      if (kbProtoUnitAvailable(cUnitTypedeSaloonHajduk) == true && gRomaniaHajdukMaintain == -1)
      {
         gRomaniaHajdukMaintain = createSimpleMaintainPlan(cUnitTypedeSaloonHajduk, wantedHajduks, false, mainBaseID, 1);
         aiPlanSetDesiredPriority(gRomaniaHajdukMaintain, 55);
         aiPlanSetActive(gRomaniaHajdukMaintain, true);
         debugMilitary("Romania: Created Hajduk maintain plan");
      }
      else if (gRomaniaHajdukMaintain >= 0)
      {
         aiPlanSetVariableInt(gRomaniaHajdukMaintain, cTrainPlanNumberToMaintain, 0, wantedHajduks);
      }
   }
   
   if (gRomaniaCrabatsSent == true)
   {
      
      int wantedCrabats = 8;
      
      if (enemyLightInfCount > 15 || enemyArtilleryCount > 5)
      {
         wantedCrabats = 12;
      }
      
      if (kbProtoUnitAvailable(cUnitTypedeSaloonCrabat) == true && gRomaniaCrabatMaintain == -1)
      {
         gRomaniaCrabatMaintain = createSimpleMaintainPlan(cUnitTypedeSaloonCrabat, wantedCrabats, false, mainBaseID, 1);
         aiPlanSetDesiredPriority(gRomaniaCrabatMaintain, 50);
         aiPlanSetActive(gRomaniaCrabatMaintain, true);
         debugMilitary("Romania: Created Crabat maintain plan");
      }
      else if (gRomaniaCrabatMaintain >= 0)
      {
         aiPlanSetVariableInt(gRomaniaCrabatMaintain, cTrainPlanNumberToMaintain, 0, wantedCrabats);
      }
   }
   
   if (gRomaniaPandoursSent == true)
   {
      
      int wantedPandours = 8;
      
      if (enemyHeavyInfCount > 15)
      {
         wantedPandours = 12;
      }
      
      if (kbProtoUnitAvailable(cUnitTypedeMercPandour) == true && gRomaniaPandourMaintain == -1)
      {
         gRomaniaPandourMaintain = createSimpleMaintainPlan(cUnitTypedeMercPandour, wantedPandours, false, mainBaseID, 1);
         aiPlanSetDesiredPriority(gRomaniaPandourMaintain, 50);
         aiPlanSetActive(gRomaniaPandourMaintain, true);
         debugMilitary("Romania: Created Pandour maintain plan");
      }
      else if (gRomaniaPandourMaintain >= 0)
      {
         aiPlanSetVariableInt(gRomaniaPandourMaintain, cTrainPlanNumberToMaintain, 0, wantedPandours);
      }
   }
   
   debugMilitary("Romania targets: Dorobants=" + wantedDorobants + 
                 ", Rosior Dragoons=" + wantedRosiorDragoons);
}

//==============================================================================
// romaniaOutpostManager
//==============================================================================
rule romaniaOutpostManager
inactive
minInterval 45
{
   
   int outpostCount = kbUnitCount(cMyID, cUnitTypeOutpost, cUnitStateAlive);
   int blockhouseCount = kbUnitCount(cMyID, cUnitTypeBlockhouse, cUnitStateAlive);
   int totalDefenses = outpostCount + blockhouseCount;
   
   int outpostWagonCount = kbUnitCount(cMyID, cUnitTypeOutpostWagon, cUnitStateAlive);
   
   int outpostBuildLimit = kbGetBuildLimit(cMyID, cUnitTypeOutpost);
   if (cMyCiv == cCivRussians)
   {
      outpostBuildLimit = kbGetBuildLimit(cMyID, cUnitTypeBlockhouse);
   }
   
   debugMilitary("Romania Outposts: " + totalDefenses + "/" + outpostBuildLimit + 
                 ", Wagons: " + outpostWagonCount);
   
   if ((totalDefenses < outpostBuildLimit) && (outpostWagonCount > 0))
   {
      debugMilitary("Romania: Should place Outpost Wagon for cavalry spawning");
   }
   
   if (cMyCiv == cCivOttomans)
   {
      debugMilitary("Romania (Ottomans): Outposts spawn Rosior Dragoons");
   }
   else if (cMyCiv == cCivRussians)
   {
      debugMilitary("Romania (Russians): Blockhouses spawn Rosior Dragoons");
      debugMilitary("Romania (Russians): Consider Strelet Horde for Streltsy spawning!");
   }
}

//==============================================================================
// romaniaEconomyManager
//==============================================================================
rule romaniaEconomyManager
inactive
minInterval 60
{
   
   if (gRomaniaCitizenshipSent == false)
   {
      if (kbTechGetStatus(cTechDEHCREVCitizenship) == cTechStatusActive)
      {
         gRomaniaCitizenshipSent = true;
         debugMilitary("Romania: Citizenship active - Settlers enabled for 70 coin!");
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
   
   if (kbProtoUnitAvailable(gEconUnit) == true && gRomaniaSettlerMaintain == -1)
   {
      gRomaniaSettlerMaintain = createSimpleMaintainPlan(gEconUnit, wantedSettlers, false, kbBaseGetMainID(cMyID), 1);
      aiPlanSetDesiredPriority(gRomaniaSettlerMaintain, 70);
      aiPlanSetActive(gRomaniaSettlerMaintain, true);
      debugMilitary("Romania: Created Settler maintain plan (post-Citizenship)");
   }
   else if (gRomaniaSettlerMaintain >= 0)
   {
      aiPlanSetVariableInt(gRomaniaSettlerMaintain, cTrainPlanNumberToMaintain, 0, wantedSettlers);
   }
   
   debugMilitary("Romania Economy: Settlers=" + currentSettlers + "/" + wantedSettlers);
}

//==============================================================================
// romaniaArtilleryManager
//==============================================================================
rule romaniaArtilleryManager
inactive
minInterval 45
{
   int mainBaseID = kbBaseGetMainID(cMyID);
   
   int horseArtilleryCount = kbUnitCount(cMyID, cUnitTypexpHorseArtillery, cUnitStateAlive);
   
   int enemyPlayer = aiGetMostHatedPlayerID();
   int enemyInfantryCount = kbUnitCount(enemyPlayer, cUnitTypeAbstractInfantry, cUnitStateAlive);
   int enemyBuildingCount = kbUnitCount(enemyPlayer, cUnitTypeBuilding, cUnitStateAlive);
   
   int wantedHorseArtillery = 4;
   
   if (enemyInfantryCount > 30 || enemyBuildingCount > 15)
   {
      wantedHorseArtillery = 6;
   }
   
   if (wantedHorseArtillery > 8)
   {
      wantedHorseArtillery = 8;
   }
   
   if (kbProtoUnitAvailable(cUnitTypexpHorseArtillery) == true && gRomaniaHorseArtilleryMaintain == -1)
   {
      gRomaniaHorseArtilleryMaintain = createSimpleMaintainPlan(cUnitTypexpHorseArtillery, wantedHorseArtillery, false, mainBaseID, 1);
      aiPlanSetDesiredPriority(gRomaniaHorseArtilleryMaintain, 55);
      aiPlanSetActive(gRomaniaHorseArtilleryMaintain, true);
      debugMilitary("Romania: Created Horse Artillery maintain plan");
   }
   else if (gRomaniaHorseArtilleryMaintain >= 0)
   {
      aiPlanSetVariableInt(gRomaniaHorseArtilleryMaintain, cTrainPlanNumberToMaintain, 0, wantedHorseArtillery);
   }
   
   debugMilitary("Romania Artillery: Horse Artillery=" + horseArtilleryCount + "/" + wantedHorseArtillery);
}

//==============================================================================
// romaniaNavyManager
//==============================================================================
rule romaniaNavyManager
inactive
minInterval 60
{
   if (gNavyMap == false)
   {
      xsDisableSelf();
      return;
   }
   
   int mainBaseID = kbBaseGetMainID(cMyID);
   
   int galleyCount = kbUnitCount(cMyID, cUnitTypeGalley, cUnitStateAlive);
   
   int enemyPlayer = aiGetMostHatedPlayerID();
   int enemyNavyCount = kbUnitCount(enemyPlayer, cUnitTypeAbstractWarShip, cUnitStateAlive);
   
   int wantedGalleys = 3;
   if (enemyNavyCount > 5)
   {
      wantedGalleys = 5;
   }
   
   if (kbProtoUnitAvailable(cUnitTypeGalley) == true && gRomaniaGalleyMaintain == -1)
   {
      gRomaniaGalleyMaintain = createSimpleMaintainPlan(cUnitTypeGalley, wantedGalleys, false, mainBaseID, 1);
      aiPlanSetDesiredPriority(gRomaniaGalleyMaintain, 45);
      aiPlanSetActive(gRomaniaGalleyMaintain, true);
      debugMilitary("Romania: Created Galley maintain plan");
   }
   else if (gRomaniaGalleyMaintain >= 0)
   {
      aiPlanSetVariableInt(gRomaniaGalleyMaintain, cTrainPlanNumberToMaintain, 0, wantedGalleys);
   }
   
   debugMilitary("Romania Navy: Galleys=" + galleyCount + "/" + wantedGalleys);
}

//==============================================================================
// romaniaCardManager
//==============================================================================
rule romaniaCardManager
inactive
minInterval 90
{
   float currentFood = kbResourceGet(cResourceFood);
   float currentWood = kbResourceGet(cResourceWood);
   float currentCoin = kbResourceGet(cResourceGold);
   
   int currentMilitary = aiGetMilitaryPop();
   int gameTime = xsGetTime();
   
   int outpostCount = kbUnitCount(cMyID, cUnitTypeOutpost, cUnitStateAlive);
   int blockhouseCount = kbUnitCount(cMyID, cUnitTypeBlockhouse, cUnitStateAlive);
   
   debugMilitary("Romania Card Manager: Evaluating priorities (Outposts: " + 
                 (outpostCount + blockhouseCount) + ")");
}

//==============================================================================
// romaniaCardEffectTracker
//==============================================================================
rule romaniaCardEffectTracker
inactive
minInterval 30
{
   if ((gRomaniaCitizenshipSent == false) && 
       (kbTechGetStatus(cTechDEHCREVCitizenship) == cTechStatusActive))
   {
      gRomaniaCitizenshipSent = true;
      debugMilitary("Romania: Citizenship activated - Settlers can be trained!");
   }
   
   if ((gRomaniaHajduksSent == false) && 
       (kbTechGetStatus(cTechDEHCREVHajduks) == cTechStatusActive))
   {
      gRomaniaHajduksSent = true;
      debugMilitary("Romania: Hajduks activated - can train Hajduks!");
   }
   
   if ((gRomaniaWallachianHorseArchersSent == false) && 
       (kbTechGetStatus(cTechDEHCREVWallachianArchers) == cTechStatusActive))
   {
      gRomaniaWallachianHorseArchersSent = true;
      debugMilitary("Romania: Wallachian Horse Archers activated!");
   }
   
   if ((gRomaniaRosiorDragoonsSent == false) && 
       (kbTechGetStatus(cTechDEHCREVRoshiorDragoons) == cTechStatusActive))
   {
      gRomaniaRosiorDragoonsSent = true;
      debugMilitary("Romania: Rosior Dragoons card activated - spawns more dragoons!");
   }
   
   if ((gRomaniaCrabatsSent == false) && 
       (kbTechGetStatus(cTechDEHCREVCrabats) == cTechStatusActive))
   {
      gRomaniaCrabatsSent = true;
      debugMilitary("Romania: Crabats activated - can train Crabats!");
   }
   
   if ((gRomaniaPandoursSent == false) && 
       (kbTechGetStatus(cTechDEHCREVPandours) == cTechStatusActive))
   {
      gRomaniaPandoursSent = true;
      debugMilitary("Romania: Pandours activated - can train Pandours!");
   }
   
   if ((gRomaniaMilitaryFrontierSent == false) && 
       (kbTechGetStatus(cTechDEHCREVMilitaryFrontier) == cTechStatusActive))
   {
      gRomaniaMilitaryFrontierSent = true;
      debugMilitary("Romania: Military Frontier activated - Dorobants can build Outposts!");
   }
}

//==============================================================================
// romaniaCavalryManager
//==============================================================================
rule romaniaCavalryManager
inactive
minInterval 45
{
   
   int rosiorDragoonCount = kbUnitCount(cMyID, cUnitTypeDragoon, cUnitStateAlive);
   int wallachianHorseArcherCount = kbUnitCount(cMyID, cUnitTypeCavalryArcher, cUnitStateAlive);
   int crabatCount = kbUnitCount(cMyID, cUnitTypedeSaloonCrabat, cUnitStateAlive);
   int horseArtilleryCount = kbUnitCount(cMyID, cUnitTypexpHorseArtillery, cUnitStateAlive);
   
   int totalCavalry = rosiorDragoonCount + wallachianHorseArcherCount + crabatCount;
   
   if (totalCavalry >= 20)
   {
      debugMilitary("Romania: Strong cavalry force (" + totalCavalry + " cavalry units)");
   }
   else if (totalCavalry >= 10)
   {
      debugMilitary("Romania: Building cavalry force (" + totalCavalry + " cavalry units)");
   }
   else
   {
      debugMilitary("Romania: Need more cavalry (" + totalCavalry + " total)");
   }
   
}

//==============================================================================
// romaniaDefenseManager
//==============================================================================
rule romaniaDefenseManager
inactive
minInterval 45
{
   
   int outpostCount = kbUnitCount(cMyID, cUnitTypeOutpost, cUnitStateAlive);
   int blockhouseCount = kbUnitCount(cMyID, cUnitTypeBlockhouse, cUnitStateAlive);
   int totalDefenses = outpostCount + blockhouseCount;
   
   int dorobantCount = kbUnitCount(cMyID, cUnitTypexpColonialMilitia, cUnitStateAlive);
   int rosiorDragoonCount = kbUnitCount(cMyID, cUnitTypeDragoon, cUnitStateAlive);
   
   if (totalDefenses >= 5 && dorobantCount >= 15)
   {
      debugMilitary("Romania: Strong defensive position (" + totalDefenses + 
                    " Outposts, " + dorobantCount + " Dorobants)");
   }
   else if (totalDefenses >= 3)
   {
      debugMilitary("Romania: Building defensive network (" + totalDefenses + " Outposts)");
   }
   else
   {
      debugMilitary("Romania: Need more Outposts for cavalry spawning (" + totalDefenses + " total)");
   }
   
}

//==============================================================================
// romaniaCivSpecificManager
//==============================================================================
rule romaniaCivSpecificManager
inactive
minInterval 120
{
   
   if (cMyCiv == cCivOttomans)
   {
      
      int rosiorDragoonCount = kbUnitCount(cMyID, cUnitTypeDragoon, cUnitStateAlive);
      int wallachianHorseArcherCount = kbUnitCount(cMyID, cUnitTypeCavalryArcher, cUnitStateAlive);
      
      debugMilitary("Romania (Ottomans): Rosior Dragoons=" + rosiorDragoonCount +
                    ", Wallachian Horse Archers=" + wallachianHorseArcherCount);
      
   }
   else if (cMyCiv == cCivRussians)
   {
      
      rosiorDragoonCount = kbUnitCount(cMyID, cUnitTypeDragoon, cUnitStateAlive);
      int blockhouseCount = kbUnitCount(cMyID, cUnitTypeBlockhouse, cUnitStateAlive);
      
      debugMilitary("Romania (Russians): Rosior Dragoons=" + rosiorDragoonCount +
                    ", Blockhouses=" + blockhouseCount);
      
      if (kbTechGetStatus(cTechHCSpawnStrelet) == cTechStatusActive)
      {
         debugMilitary("Romania (Russians): Strelet Horde active - Blockhouses spawn Streltsy!");
      }
      
      debugMilitary("Romania (Russians): Consider Heavy Fortifications for free defensive upgrades!");
   }
}

//==============================================================================
// romaniaMilitaryFrontierManager
//==============================================================================
rule romaniaMilitaryFrontierManager
inactive
minInterval 60
{
   if (gRomaniaMilitaryFrontierSent == false)
   {
      if (kbTechGetStatus(cTechDEHCREVMilitaryFrontier) == cTechStatusActive)
      {
         gRomaniaMilitaryFrontierSent = true;
         debugMilitary("Romania: Military Frontier activated!");
      }
      else
      {
         return;
      }
   }
   
   int dorobantCount = kbUnitCount(cMyID, cUnitTypexpColonialMilitia, cUnitStateAlive);
   
   debugMilitary("Romania Military Frontier: " + dorobantCount + " Dorobants can build Outposts!");
   
}
