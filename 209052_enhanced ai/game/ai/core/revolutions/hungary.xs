extern bool gHungaryCitizenshipSent = false;
extern bool gHungaryHajduksSent = false;
extern bool gHungaryGrenadiersSent = false;
extern bool gHungaryMagyarHussarsSent = false;
extern bool gHungaryKovatsLegionSent = false;
extern bool gHungaryCrabatsSent = false;
extern bool gHungaryPandoursSent = false;

extern int gHungaryGrenzerMaintain = -1;
extern int gHungaryMagyarHussarMaintain = -1;
extern int gHungaryGrenadierMaintain = -1;
extern int gHungaryHajdukMaintain = -1;
extern int gHungaryCrabatMaintain = -1;
extern int gHungaryPandourMaintain = -1;
extern int gHungarySettlerMaintain = -1;
extern int gHungaryGalleyMaintain = -1;

//==============================================================================
// hungaryRevolutionManager
//==============================================================================
rule hungaryRevolutionManager
inactive
minInterval 30
{
   int mainBaseID = kbBaseGetMainID(cMyID);
   
   int grenzerCount = kbUnitCount(cMyID, cUnitTypedeColonialMilitia, cUnitStateAlive);
   int magyarHussarCount = kbUnitCount(cMyID, cUnitTypedeLegionMagyarHussar, cUnitStateAlive);
   int hungarianGrenadierCount = kbUnitCount(cMyID, cUnitTypedeNatHungarianGrenadier, cUnitStateAlive);
   int hajdukCount = kbUnitCount(cMyID, cUnitTypedeSaloonHajduk, cUnitStateAlive);
   int crabatCount = kbUnitCount(cMyID, cUnitTypedeSaloonCrabat, cUnitStateAlive);
   int pandourCount = kbUnitCount(cMyID, cUnitTypedeMercPandour, cUnitStateAlive);
   
   int outpostCount = kbUnitCount(cMyID, cUnitTypeOutpost, cUnitStateAlive);
   int blockhouseCount = kbUnitCount(cMyID, cUnitTypeBlockhouse, cUnitStateAlive);
   int totalDefenses = outpostCount + blockhouseCount;
   
   debugMilitary("Hungary: Grenzers=" + grenzerCount + 
                 ", Magyar Hussars=" + magyarHussarCount +
                 ", Hungarian Grenadiers=" + hungarianGrenadierCount +
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
   
   int wantedGrenzers = 20;
   
   if (enemyCavalryCount > 15)
   {
      wantedGrenzers = 30;
   }
   
   if (enemyLightInfCount > 20 && enemyCavalryCount < 10)
   {
      wantedGrenzers = 15;
   }
   
   if (kbProtoUnitAvailable(cUnitTypedeColonialMilitia) == true && gHungaryGrenzerMaintain == -1)
   {
      gHungaryGrenzerMaintain = createSimpleMaintainPlan(cUnitTypedeColonialMilitia, wantedGrenzers, false, mainBaseID, 1);
      aiPlanSetDesiredPriority(gHungaryGrenzerMaintain, 65);
      aiPlanSetActive(gHungaryGrenzerMaintain, true);
      debugMilitary("Hungary: Created Grenzer maintain plan");
   }
   else if (gHungaryGrenzerMaintain >= 0)
   {
      aiPlanSetVariableInt(gHungaryGrenzerMaintain, cTrainPlanNumberToMaintain, 0, wantedGrenzers);
   }
   
   if (gHungaryGrenadiersSent == true || cMyCiv == cCivRussians)
   {
      
      int wantedGrenadiers = 10;
      
      if (enemyBuildingCount > 15)
      {
         wantedGrenadiers = 15;
      }
      
      if (enemyHeavyInfCount > 20)
      {
         wantedGrenadiers = 15;
      }
      
      if (kbProtoUnitAvailable(cUnitTypedeNatHungarianGrenadier) == true && gHungaryGrenadierMaintain == -1)
      {
         gHungaryGrenadierMaintain = createSimpleMaintainPlan(cUnitTypedeNatHungarianGrenadier, wantedGrenadiers, false, mainBaseID, 1);
         aiPlanSetDesiredPriority(gHungaryGrenadierMaintain, 60);
         aiPlanSetActive(gHungaryGrenadierMaintain, true);
         debugMilitary("Hungary: Created Hungarian Grenadier maintain plan");
      }
      else if (gHungaryGrenadierMaintain >= 0)
      {
         aiPlanSetVariableInt(gHungaryGrenadierMaintain, cTrainPlanNumberToMaintain, 0, wantedGrenadiers);
      }
   }
   
   if (gHungaryHajduksSent == true || cMyCiv == cCivDEMaltese)
   {
      
      int wantedHajduks = 10;
      
      if (enemyLightInfCount > 15)
      {
         wantedHajduks = 20;
      }
      
      if (kbProtoUnitAvailable(cUnitTypedeSaloonHajduk) == true && gHungaryHajdukMaintain == -1)
      {
         gHungaryHajdukMaintain = createSimpleMaintainPlan(cUnitTypedeSaloonHajduk, wantedHajduks, false, mainBaseID, 1);
         aiPlanSetDesiredPriority(gHungaryHajdukMaintain, 55);
         aiPlanSetActive(gHungaryHajdukMaintain, true);
         debugMilitary("Hungary: Created Hajduk maintain plan");
      }
      else if (gHungaryHajdukMaintain >= 0)
      {
         aiPlanSetVariableInt(gHungaryHajdukMaintain, cTrainPlanNumberToMaintain, 0, wantedHajduks);
      }
   }
   
   if (gHungaryCrabatsSent == true)
   {
      
      int wantedCrabats = 8;
      
      if (enemyLightInfCount > 15 || enemyArtilleryCount > 5)
      {
         wantedCrabats = 12;
      }
      
      if (kbProtoUnitAvailable(cUnitTypedeSaloonCrabat) == true && gHungaryCrabatMaintain == -1)
      {
         gHungaryCrabatMaintain = createSimpleMaintainPlan(cUnitTypedeSaloonCrabat, wantedCrabats, false, mainBaseID, 1);
         aiPlanSetDesiredPriority(gHungaryCrabatMaintain, 50);
         aiPlanSetActive(gHungaryCrabatMaintain, true);
         debugMilitary("Hungary: Created Crabat maintain plan");
      }
      else if (gHungaryCrabatMaintain >= 0)
      {
         aiPlanSetVariableInt(gHungaryCrabatMaintain, cTrainPlanNumberToMaintain, 0, wantedCrabats);
      }
   }
   
   if (gHungaryPandoursSent == true || cMyCiv == cCivGermans)
   {
      
      int wantedPandours = 8;
      
      if (enemyLightInfCount > 15)
      {
         wantedPandours = 12;
      }
      
      if (kbProtoUnitAvailable(cUnitTypedeMercPandour) == true && gHungaryPandourMaintain == -1)
      {
         gHungaryPandourMaintain = createSimpleMaintainPlan(cUnitTypedeMercPandour, wantedPandours, false, mainBaseID, 1);
         aiPlanSetDesiredPriority(gHungaryPandourMaintain, 50);
         aiPlanSetActive(gHungaryPandourMaintain, true);
         debugMilitary("Hungary: Created Pandour maintain plan");
      }
      else if (gHungaryPandourMaintain >= 0)
      {
         aiPlanSetVariableInt(gHungaryPandourMaintain, cTrainPlanNumberToMaintain, 0, wantedPandours);
      }
   }
   
   if (gHungaryKovatsLegionSent == true)
   {
      
      int wantedMagyarHussars = 10;
      
      if (enemyArtilleryCount > 5 || enemyLightInfCount > 15)
      {
         wantedMagyarHussars = 15;
      }
      
      if (kbProtoUnitAvailable(cUnitTypedeLegionMagyarHussar) == true && gHungaryMagyarHussarMaintain == -1)
      {
         gHungaryMagyarHussarMaintain = createSimpleMaintainPlan(cUnitTypedeLegionMagyarHussar, wantedMagyarHussars, false, mainBaseID, 1);
         aiPlanSetDesiredPriority(gHungaryMagyarHussarMaintain, 55);
         aiPlanSetActive(gHungaryMagyarHussarMaintain, true);
         debugMilitary("Hungary: Created Magyar Hussar maintain plan");
      }
      else if (gHungaryMagyarHussarMaintain >= 0)
      {
         aiPlanSetVariableInt(gHungaryMagyarHussarMaintain, cTrainPlanNumberToMaintain, 0, wantedMagyarHussars);
      }
   }
   
   debugMilitary("Hungary targets: Grenzers=" + wantedGrenzers);
}

//==============================================================================
// hungaryOutpostManager
//==============================================================================
rule hungaryOutpostManager
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
   
   debugMilitary("Hungary Outposts: " + totalDefenses + "/" + outpostBuildLimit + 
                 ", Wagons: " + outpostWagonCount);
   
   if ((totalDefenses < outpostBuildLimit) && (outpostWagonCount > 0))
   {
      debugMilitary("Hungary: Should place Outpost Wagon for unit spawning");
   }
   
   if (cMyCiv == cCivGermans)
   {
      debugMilitary("Hungary (Germans): Outposts spawn Pandours");
   }
   else if (cMyCiv == cCivDEMaltese)
   {
      debugMilitary("Hungary (Maltese): Outposts spawn Hajduks");
   }
   else if (cMyCiv == cCivOttomans)
   {
      debugMilitary("Hungary (Ottomans): Outposts spawn Magyar Hussars");
   }
   else if (cMyCiv == cCivRussians)
   {
      debugMilitary("Hungary (Russians): Blockhouses spawn Hungarian Grenadiers");
   }
}

//==============================================================================
// hungaryEconomyManager
//==============================================================================
rule hungaryEconomyManager
inactive
minInterval 60
{
   
   if (gHungaryCitizenshipSent == false)
   {
      if (kbTechGetStatus(cTechDEHCREVCitizenship) == cTechStatusActive)
      {
         gHungaryCitizenshipSent = true;
         debugMilitary("Hungary: Citizenship active - Settlers enabled for 70 coin!");
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
         debugMilitary("Hungary (Germans): Can train Settler Wagons at Mills!");
      }
   }
   
   if (kbProtoUnitAvailable(gEconUnit) == true && gHungarySettlerMaintain == -1)
   {
      gHungarySettlerMaintain = createSimpleMaintainPlan(gEconUnit, wantedSettlers, false, kbBaseGetMainID(cMyID), 1);
      aiPlanSetDesiredPriority(gHungarySettlerMaintain, 70);
      aiPlanSetActive(gHungarySettlerMaintain, true);
      debugMilitary("Hungary: Created Settler maintain plan (post-Citizenship)");
   }
   else if (gHungarySettlerMaintain >= 0)
   {
      aiPlanSetVariableInt(gHungarySettlerMaintain, cTrainPlanNumberToMaintain, 0, wantedSettlers);
   }
   
   debugMilitary("Hungary Economy: Settlers=" + currentSettlers + "/" + wantedSettlers);
}

//==============================================================================
// hungaryNavyManager
//==============================================================================
rule hungaryNavyManager
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
   
   if (kbProtoUnitAvailable(cUnitTypeGalley) == true && gHungaryGalleyMaintain == -1)
   {
      gHungaryGalleyMaintain = createSimpleMaintainPlan(cUnitTypeGalley, wantedGalleys, false, mainBaseID, 1);
      aiPlanSetDesiredPriority(gHungaryGalleyMaintain, 45);
      aiPlanSetActive(gHungaryGalleyMaintain, true);
      debugMilitary("Hungary: Created Galley maintain plan");
   }
   else if (gHungaryGalleyMaintain >= 0)
   {
      aiPlanSetVariableInt(gHungaryGalleyMaintain, cTrainPlanNumberToMaintain, 0, wantedGalleys);
   }
   
   debugMilitary("Hungary Navy: Galleys=" + galleyCount + "/" + wantedGalleys);
}

//==============================================================================
// hungaryTreasureManager
//==============================================================================
rule hungaryTreasureManager
inactive
minInterval 90
{
   
   int grenzerCount = kbUnitCount(cMyID, cUnitTypedeColonialMilitia, cUnitStateAlive);
   
   if (grenzerCount < 1)
   {
      return;
   }
   
   int treasureCount = kbUnitCount(0, cUnitTypeNugget, cUnitStateAlive);
   
   if (treasureCount > 0)
   {
      debugMilitary("Hungary: " + treasureCount + " treasures remain on map");
      debugMilitary("Hungary: Grenzers can collect treasures (3x vs guardians)");
   }
}

//==============================================================================
// hungaryCardManager
//==============================================================================
rule hungaryCardManager
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
   
   debugMilitary("Hungary Card Manager: Evaluating priorities (Outposts: " + 
                 (outpostCount + blockhouseCount) + ")");
}

//==============================================================================
// hungaryCardEffectTracker
//==============================================================================
rule hungaryCardEffectTracker
inactive
minInterval 30
{
   if ((gHungaryCitizenshipSent == false) && 
       (kbTechGetStatus(cTechDEHCREVCitizenship) == cTechStatusActive))
   {
      gHungaryCitizenshipSent = true;
      debugMilitary("Hungary: Citizenship activated - Settlers can be trained!");
   }
   
   if ((gHungaryHajduksSent == false) && 
       (kbTechGetStatus(cTechDEHCREVHajduks) == cTechStatusActive))
   {
      gHungaryHajduksSent = true;
      debugMilitary("Hungary: Hajduks activated - can train Hajduks!");
   }
   
   if ((gHungaryGrenadiersSent == false) && 
       (kbTechGetStatus(cTechDEREVMagyarGrenadier) == cTechStatusActive))
   {
      gHungaryGrenadiersSent = true;
      debugMilitary("Hungary: Hungarian Grenadiers activated - can train Hungarian Grenadiers!");
   }
   
   if ((gHungaryMagyarHussarsSent == false) && 
       (kbTechGetStatus(cTechDEHCREVMagyarHussars) == cTechStatusActive))
   {
      gHungaryMagyarHussarsSent = true;
      debugMilitary("Hungary: Magyar Hussars activated - Outposts spawn Magyar Hussars!");
   }
   
   if ((gHungaryKovatsLegionSent == false) && 
       (kbTechGetStatus(cTechDEHCLegionHungarian) == cTechStatusActive))
   {
      gHungaryKovatsLegionSent = true;
      debugMilitary("Hungary: Kovat's Legion activated - can train Magyar Hussars at Forts!");
   }
   
   if ((gHungaryCrabatsSent == false) && 
       (kbTechGetStatus(cTechDEHCREVCrabats) == cTechStatusActive))
   {
      gHungaryCrabatsSent = true;
      debugMilitary("Hungary: Crabats activated - can train Crabats!");
   }
   
   if ((gHungaryPandoursSent == false) && 
       (kbTechGetStatus(cTechDEHCREVPandours) == cTechStatusActive))
   {
      gHungaryPandoursSent = true;
      debugMilitary("Hungary: Pandours activated - can train Pandours!");
   }
}

//==============================================================================
// hungaryDefenseManager
//==============================================================================
rule hungaryDefenseManager
inactive
minInterval 45
{
   
   int outpostCount = kbUnitCount(cMyID, cUnitTypeOutpost, cUnitStateAlive);
   int blockhouseCount = kbUnitCount(cMyID, cUnitTypeBlockhouse, cUnitStateAlive);
   int totalDefenses = outpostCount + blockhouseCount;
   
   int grenzerCount = kbUnitCount(cMyID, cUnitTypedeColonialMilitia, cUnitStateAlive);
   int magyarHussarCount = kbUnitCount(cMyID, cUnitTypedeLegionMagyarHussar, cUnitStateAlive);
   int hungarianGrenadierCount = kbUnitCount(cMyID, cUnitTypedeNatHungarianGrenadier, cUnitStateAlive);
   
   if (totalDefenses >= 5 && grenzerCount >= 15)
   {
      debugMilitary("Hungary: Strong defensive position (" + totalDefenses + 
                    " Outposts, " + grenzerCount + " Grenzers)");
   }
   else if (totalDefenses >= 3)
   {
      debugMilitary("Hungary: Building defensive network (" + totalDefenses + " Outposts)");
   }
   else
   {
      debugMilitary("Hungary: Need more Outposts for unit spawning (" + totalDefenses + " total)");
   }
   
}

//==============================================================================
// hungaryCivSpecificManager
//==============================================================================
rule hungaryCivSpecificManager
inactive
minInterval 120
{
   
   if (cMyCiv == cCivGermans)
   {
      
      int pandourCount = kbUnitCount(cMyID, cUnitTypedeMercPandour, cUnitStateAlive);
      debugMilitary("Hungary (Germans): " + pandourCount + " Pandours from Outposts");
      
      int uhlanCount = kbUnitCount(cMyID, cUnitTypeUhlan, cUnitStateAlive);
      if (uhlanCount > 0)
      {
         debugMilitary("Hungary (Germans): " + uhlanCount + " Uhlans from pre-revolution");
      }
   }
   else if (cMyCiv == cCivDEMaltese)
   {
      
      int hajdukCount = kbUnitCount(cMyID, cUnitTypedeSaloonHajduk, cUnitStateAlive);
      debugMilitary("Hungary (Maltese): " + hajdukCount + " Hajduks from Outposts");
      
      int sentinelCount = kbUnitCount(cMyID, cUnitTypedeMalteseMusketeer, cUnitStateAlive);
      if (sentinelCount > 0)
      {
         debugMilitary("Hungary (Maltese): " + sentinelCount + " Sentinels can build Outposts");
      }
   }
   else if (cMyCiv == cCivOttomans)
   {
      
      int magyarHussarCount = kbUnitCount(cMyID, cUnitTypedeLegionMagyarHussar, cUnitStateAlive);
      debugMilitary("Hungary (Ottomans): " + magyarHussarCount + " Magyar Hussars from Outposts");
      debugMilitary("Hungary (Ottomans): Magyar Hussars have double HP!");
   }
   else if (cMyCiv == cCivRussians)
   {
      
      int hungarianGrenadierCount = kbUnitCount(cMyID, cUnitTypedeNatHungarianGrenadier, cUnitStateAlive);
      debugMilitary("Hungary (Russians): " + hungarianGrenadierCount + " Hungarian Grenadiers from Blockhouses");
      debugMilitary("Hungary (Russians): Hungarian Grenadiers have +6 range!");
      
      if (kbTechGetStatus(cTechHCBlockhouseCannon) == cTechStatusActive)
      {
         debugMilitary("Hungary (Russians): Blockhouse Cannon active - can train artillery at Blockhouses!");
      }
   }
}
