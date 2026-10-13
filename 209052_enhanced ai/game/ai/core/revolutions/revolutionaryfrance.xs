extern bool gNapoleonicEraActive = false;
extern bool gGrandeArmeeActive = false;
extern bool gGenieTroopsActive = false;

extern int gRevFranceSansculotteMaintain = -1;
extern int gRevFranceRevolutionaryMaintain = -1;
extern int gRevFranceGrenadierMaintain = -1;
extern int gRevFranceNapoleonGunMaintain = -1;
extern int gRevFranceFalconetMaintain = -1;
extern int gRevFranceHorseArtilleryMaintain = -1;
extern int gRevFranceMortarMaintain = -1;
extern int gRevFranceHussarMaintain = -1;
extern int gRevFranceDragoonMaintain = -1;
extern int gRevFranceGendarmeMaintain = -1;
extern int gRevFranceRoyalMusketeerMaintain = -1;
extern int gRevFranceRoyalDragoonMaintain = -1;

extern bool gHorseHuntersActive = false;

//==============================================================================
// revolutionaryFranceRevolutionManager
//==============================================================================
rule revolutionaryFranceRevolutionManager
inactive
minInterval 30
{
   int mainBaseID = kbBaseGetMainID(cMyID);
   
   int currentSansculottes = kbUnitCount(cMyID, gEconUnit, cUnitStateAlive);
   int currentRoyalMusketeers = kbUnitCount(cMyID, cUnitTypedeNatRoyalMusketeer, cUnitStateAlive);
   int currentRoyalDragoons = kbUnitCount(cMyID, cUnitTypedeNatRoyalDragoon, cUnitStateAlive);
   int currentGrenadiers = kbUnitCount(cMyID, cUnitTypeGrenadier, cUnitStateAlive);
   
   int popCap = kbGetPopCap();
   int militaryPop = aiGetMilitaryPop();
   
   int wantedSansculottes = 50;
   
   float currentFood = kbResourceGet(cResourceFood);
   float currentWood = kbResourceGet(cResourceWood);
   float currentCoin = kbResourceGet(cResourceGold);
   
   if ((currentFood < 500) || (currentWood < 300) || (currentCoin < 300))
   {
      wantedSansculottes = 60;
   }
   
   int sansculotteBL = kbGetBuildLimit(cMyID, gEconUnit);
   if ((sansculotteBL > 0) && (wantedSansculottes > sansculotteBL))
   {
      wantedSansculottes = sansculotteBL;
   }
   
   int enemyPlayer = aiGetMostHatedPlayerID();
   if (enemyPlayer < 1)
   {
      enemyPlayer = 2;
   }
   
   int enemyCavalryCount = kbUnitCount(enemyPlayer, cUnitTypeAbstractCavalry, cUnitStateAlive);
   int enemyHeavyInfCount = kbUnitCount(enemyPlayer, cUnitTypeAbstractHeavyInfantry, cUnitStateAlive);
   int enemyLightInfCount = kbUnitCount(enemyPlayer, cUnitTypeAbstractLightInfantry, cUnitStateAlive);
   int enemyArtilleryCount = kbUnitCount(enemyPlayer, cUnitTypeAbstractArtillery, cUnitStateAlive);
   
   if (kbProtoUnitAvailable(gEconUnit) == true && gRevFranceSansculotteMaintain == -1)
   {
      gRevFranceSansculotteMaintain = createSimpleMaintainPlan(gEconUnit, wantedSansculottes, false, mainBaseID, 1);
      aiPlanSetDesiredPriority(gRevFranceSansculotteMaintain, 80);
      aiPlanSetActive(gRevFranceSansculotteMaintain, true);
      debugMilitary("Revolutionary France: Created Sansculotte maintain plan");
   }
   else if (gRevFranceSansculotteMaintain >= 0)
   {
      aiPlanSetVariableInt(gRevFranceSansculotteMaintain, cTrainPlanNumberToMaintain, 0, wantedSansculottes);
   }
   
   int wantedRoyalMusketeers = 15;
   
   if (enemyCavalryCount > 15)
   {
      wantedRoyalMusketeers = 25;
   }
   if (enemyCavalryCount > 25)
   {
      wantedRoyalMusketeers = 35;
   }
   
   if (enemyLightInfCount > 30 && enemyCavalryCount < 10)
   {
      wantedRoyalMusketeers = 10;
   }
   
   if (gNapoleonicEraActive == true)
   {
      wantedRoyalMusketeers = wantedRoyalMusketeers + 10;
   }
   
   if (kbProtoUnitAvailable(cUnitTypedeNatRoyalMusketeer) == true && gRevFranceRoyalMusketeerMaintain == -1)
   {
      gRevFranceRoyalMusketeerMaintain = createSimpleMaintainPlan(cUnitTypedeNatRoyalMusketeer, wantedRoyalMusketeers, false, mainBaseID, 1);
      aiPlanSetDesiredPriority(gRevFranceRoyalMusketeerMaintain, 65);
      aiPlanSetActive(gRevFranceRoyalMusketeerMaintain, true);
      debugMilitary("Revolutionary France: Created Royal Musketeer maintain plan");
   }
   else if (gRevFranceRoyalMusketeerMaintain >= 0)
   {
      aiPlanSetVariableInt(gRevFranceRoyalMusketeerMaintain, cTrainPlanNumberToMaintain, 0, wantedRoyalMusketeers);
   }
   
   int wantedRoyalDragoons = 10;
   
   if (enemyCavalryCount > 15)
   {
      wantedRoyalDragoons = 18;
   }
   if (enemyCavalryCount > 25)
   {
      wantedRoyalDragoons = 25;
   }
   
   if (enemyLightInfCount > 20)
   {
      wantedRoyalDragoons = wantedRoyalDragoons + 5;
   }
   
   if (enemyHeavyInfCount > 30 && enemyCavalryCount < 10)
   {
      wantedRoyalDragoons = 6;
   }
   
   if (gNapoleonicEraActive == true)
   {
      wantedRoyalDragoons = wantedRoyalDragoons + 8;
   }
   
   if (gHorseHuntersActive == true)
   {
      if (enemyCavalryCount > 10)
      {
         wantedRoyalDragoons = wantedRoyalDragoons + 10;
      }
   }
   
   if (kbProtoUnitAvailable(cUnitTypedeNatRoyalDragoon) == true && gRevFranceRoyalDragoonMaintain == -1)
   {
      gRevFranceRoyalDragoonMaintain = createSimpleMaintainPlan(cUnitTypedeNatRoyalDragoon, wantedRoyalDragoons, false, mainBaseID, 1);
      aiPlanSetDesiredPriority(gRevFranceRoyalDragoonMaintain, 60);
      aiPlanSetActive(gRevFranceRoyalDragoonMaintain, true);
      debugMilitary("Revolutionary France: Created Royal Dragoon maintain plan");
   }
   else if (gRevFranceRoyalDragoonMaintain >= 0)
   {
      aiPlanSetVariableInt(gRevFranceRoyalDragoonMaintain, cTrainPlanNumberToMaintain, 0, wantedRoyalDragoons);
   }
   
   int wantedGrenadiers = 10;
   
   if (enemyArtilleryCount > 5)
   {
      wantedGrenadiers = 20;
   }
   
   if (enemyHeavyInfCount > 20)
   {
      wantedGrenadiers = 15;
   }
   
   if (gGenieTroopsActive == true)
   {
      wantedGrenadiers = wantedGrenadiers + 10;
   }
   
   if (gNapoleonicEraActive == true)
   {
      wantedGrenadiers = wantedGrenadiers + 5;
   }
   
   if (kbTechGetStatus(cTechDEHCREVImperialOldGuard) == cTechStatusActive)
   {
      wantedGrenadiers = wantedGrenadiers + 10;
   }
   
   if (kbProtoUnitAvailable(cUnitTypeGrenadier) == true && gRevFranceGrenadierMaintain == -1)
   {
      gRevFranceGrenadierMaintain = createSimpleMaintainPlan(cUnitTypeGrenadier, wantedGrenadiers, false, mainBaseID, 1);
      aiPlanSetDesiredPriority(gRevFranceGrenadierMaintain, 55);
      aiPlanSetActive(gRevFranceGrenadierMaintain, true);
      debugMilitary("Revolutionary France: Created Grenadier maintain plan");
   }
   else if (gRevFranceGrenadierMaintain >= 0)
   {
      aiPlanSetVariableInt(gRevFranceGrenadierMaintain, cTrainPlanNumberToMaintain, 0, wantedGrenadiers);
   }
   
   debugMilitary("Revolutionary France composition: Sansculottes=" + currentSansculottes + "/" + wantedSansculottes + 
                 ", Royal Musketeers=" + currentRoyalMusketeers + "/" + wantedRoyalMusketeers +
                 ", Royal Dragoons=" + currentRoyalDragoons + "/" + wantedRoyalDragoons +
                 ", Grenadiers=" + currentGrenadiers + "/" + wantedGrenadiers);
}

//==============================================================================
// revolutionaryFranceImperialUpgradeManager
//==============================================================================
rule revolutionaryFranceImperialUpgradeManager
inactive
minInterval 20
{
   if (gGrandeArmeeActive == false)
   {
      return;
   }
   
   int buildingID = -1;
   
   int barracksID = getUnit(cUnitTypeBarracks, cMyID, cUnitStateAlive);
   if (barracksID >= 0)
   {
      
      if (kbTechGetStatus(cTechImperialGrenadiers) == cTechStatusObtainable)
      {
         if (aiPlanGetIDByTypeAndVariableType(cPlanResearch, cResearchPlanTechID, cTechImperialGrenadiers) < 0)
         {
            createSimpleResearchPlan(cTechImperialGrenadiers, barracksID, cMilitaryEscrowID, 75);
            debugMilitary("Revolutionary France: Researching Imperial Grenadiers (50% off)");
            return;
         }
      }

      if (kbTechGetStatus(cTechRGVoltigeur) == cTechStatusObtainable)
      {
         if (aiPlanGetIDByTypeAndVariableType(cPlanResearch, cResearchPlanTechID, cTechRGVoltigeur) < 0)
         {
            createSimpleResearchPlan(cTechRGVoltigeur, barracksID, cMilitaryEscrowID, 65);
            debugMilitary("Revolutionary France: Researching Imperial Mortars (50% off)");
            return;
         }
      }
      
      if (kbTechGetStatus(cTechImperialVoltigeur) == cTechStatusObtainable)
      {
         if (aiPlanGetIDByTypeAndVariableType(cPlanResearch, cResearchPlanTechID, cTechImperialVoltigeur) < 0)
         {
            createSimpleResearchPlan(cTechImperialVoltigeur, barracksID, cMilitaryEscrowID, 70);
            debugMilitary("Revolutionary France: Researching Imperial Voltigeurs (50% off)");
            return;
         }
      }
      
      if (kbTechGetStatus(cTechImperialHalberdiers) == cTechStatusObtainable)
      {
         if (aiPlanGetIDByTypeAndVariableType(cPlanResearch, cResearchPlanTechID, cTechImperialHalberdiers) < 0)
         {
            createSimpleResearchPlan(cTechImperialHalberdiers, barracksID, cMilitaryEscrowID, 65);
            debugMilitary("Revolutionary France: Researching Imperial Halberdiers (50% off)");
            return;
         }
      }
   }
   
   int stableID = getUnit(cUnitTypeStable, cMyID, cUnitStateAlive);
   if (stableID >= 0)
   {
      
      if (kbTechGetStatus(cTechImperialHussars) == cTechStatusObtainable)
      {
         if (aiPlanGetIDByTypeAndVariableType(cPlanResearch, cResearchPlanTechID, cTechImperialHussars) < 0)
         {
            createSimpleResearchPlan(cTechImperialHussars, stableID, cMilitaryEscrowID, 75);
            debugMilitary("Revolutionary France: Researching Imperial Hussars (50% off)");
            return;
         }
      }
      
      if (kbTechGetStatus(cTechImperialGendarme) == cTechStatusObtainable)
      {
         if (aiPlanGetIDByTypeAndVariableType(cPlanResearch, cResearchPlanTechID, cTechImperialGendarme) < 0)
         {
            createSimpleResearchPlan(cTechImperialGendarme, stableID, cMilitaryEscrowID, 70);
            debugMilitary("Revolutionary France: Researching Imperial Cuirassiers (50% off)");
            return;
         }
      }
      
      if (kbTechGetStatus(cTechImperialDragoons) == cTechStatusObtainable)
      {
         if (aiPlanGetIDByTypeAndVariableType(cPlanResearch, cResearchPlanTechID, cTechImperialDragoons) < 0)
         {
            createSimpleResearchPlan(cTechImperialDragoons, stableID, cMilitaryEscrowID, 65);
            debugMilitary("Revolutionary France: Researching Imperial Dragoons (50% off)");
            return;
         }
      }
   }
   
   int artilleryDepotID = getUnit(cUnitTypeArtilleryDepot, cMyID, cUnitStateAlive);
   if (artilleryDepotID >= 0)
   {
      if (kbTechGetStatus(cTechImperialFieldGun) == cTechStatusObtainable)
      {
         if (aiPlanGetIDByTypeAndVariableType(cPlanResearch, cResearchPlanTechID, cTechImperialFieldGun) < 0)
         {
            createSimpleResearchPlan(cTechImperialFieldGun, artilleryDepotID, cMilitaryEscrowID, 75);
            debugMilitary("Revolutionary France: Researching Imperial Falconets (50% off)");
            return;
         }
      }
      
      if (kbTechGetStatus(cTechImperialCulverin) == cTechStatusObtainable)
      {
         if (aiPlanGetIDByTypeAndVariableType(cPlanResearch, cResearchPlanTechID, cTechImperialCulverin) < 0)
         {
            createSimpleResearchPlan(cTechImperialCulverin, artilleryDepotID, cMilitaryEscrowID, 70);
            debugMilitary("Revolutionary France: Researching Imperial Culverins (50% off)");
            return;
         }
      }
      
      if (kbTechGetStatus(cTechImperialHowitzer) == cTechStatusObtainable)
      {
         if (aiPlanGetIDByTypeAndVariableType(cPlanResearch, cResearchPlanTechID, cTechImperialHowitzer) < 0)
         {
            createSimpleResearchPlan(cTechImperialHowitzer, artilleryDepotID, cMilitaryEscrowID, 65);
            debugMilitary("Revolutionary France: Researching Imperial Mortars (50% off)");
            return;
         }
      }
      
      if (kbTechGetStatus(cTechImperialHorseArtillery) == cTechStatusObtainable)
      {
         if (aiPlanGetIDByTypeAndVariableType(cPlanResearch, cResearchPlanTechID, cTechImperialHorseArtillery) < 0)
         {
            createSimpleResearchPlan(cTechImperialHorseArtillery, artilleryDepotID, cMilitaryEscrowID, 70);
            debugMilitary("Revolutionary France: Researching Imperial Horse Artillery (50% off)");
            return;
         }
      }
      
      if (kbTechGetStatus(cTechImperialCannon) == cTechStatusObtainable)
      {
         if (aiPlanGetIDByTypeAndVariableType(cPlanResearch, cResearchPlanTechID, cTechImperialCannon) < 0)
         {
            createSimpleResearchPlan(cTechImperialCannon, artilleryDepotID, cMilitaryEscrowID, 65);
            debugMilitary("Revolutionary France: Researching Imperial Heavy Cannons (50% off)");
            return;
         }
      }
   }
   
   debugMilitary("Revolutionary France: All available Imperial upgrades researched or in progress");
}

//==============================================================================
// revolutionaryFranceEconomyManager
//==============================================================================
rule revolutionaryFranceEconomyManager
inactive
minInterval 45
{
   
   int currentSansculottes = kbUnitCount(cMyID, gEconUnit, cUnitStateAlive);
   
   if (currentSansculottes < 10)
   {
      debugMilitary("Revolutionary France: Low Sansculotte count, prioritizing training");
      return;
   }
   
   int fieldHospitalCount = kbUnitCount(cMyID, cUnitTypeFieldHospital, cUnitStateAlive);
   int fieldHospitalBL = kbGetBuildLimit(cMyID, cUnitTypeFieldHospital);
   
   if ((fieldHospitalCount < 2) && (fieldHospitalBL >= 2))
   {
      debugMilitary("Revolutionary France: Should build more Field Hospitals (" + 
                    fieldHospitalCount + "/" + fieldHospitalBL + ")");
   }
   
   int factoryCount = kbUnitCount(cMyID, cUnitTypeFactory, cUnitStateAlive);
   int factoryBL = kbGetBuildLimit(cMyID, cUnitTypeFactory);
   
   if (gNapoleonicEraActive == true)
   {
      if ((factoryCount < 2) && (factoryBL >= 2))
      {
         debugMilitary("Revolutionary France: Should build second Factory");
      }
   }
   
   if (gGenieTroopsActive == true)
   {
      int grenadierCount = kbUnitCount(cMyID, cUnitTypeGrenadier, cUnitStateAlive);
      debugMilitary("Revolutionary France: Genie Troops active, " + grenadierCount + 
                    " Grenadiers can gather");
   }
}

//==============================================================================
// revolutionaryFranceChurchManager
//==============================================================================
rule revolutionaryFranceChurchManager
inactive
minInterval 60
{
   static bool codeNapoleonResearched = false;
   static bool youngGuardResearched = false;
   static bool middleGuardResearched = false;
   static bool oldGuardResearched = false;
   
   int churchID = getUnit(cUnitTypeChurch, cMyID, cUnitStateAlive);
   if (churchID < 0)
   {
      debugMilitary("Revolutionary France: No Church found - should build one");
      return;
   }
   
   if (codeNapoleonResearched == false)
   {
      if (kbTechGetStatus(cTechChurchCodeNapoleon) == cTechStatusObtainable)
      {
         if (aiPlanGetIDByTypeAndVariableType(cPlanResearch, cResearchPlanTechID, cTechChurchCodeNapoleon) < 0)
         {
            createSimpleResearchPlan(cTechChurchCodeNapoleon, churchID, cMilitaryEscrowID, 70);
            debugMilitary("Revolutionary France: Researching Code Napoleon");
         }
      }
      else if (kbTechGetStatus(cTechChurchCodeNapoleon) == cTechStatusActive)
      {
         codeNapoleonResearched = true;
         debugMilitary("Revolutionary France: Code Napoleon researched");
      }
   }
   
   if (codeNapoleonResearched == true)
   {
      if ((youngGuardResearched == false) && 
          (kbTechGetStatus(cTechChurchGardeImperial1) == cTechStatusObtainable))
      {
         if (aiPlanGetIDByTypeAndVariableType(cPlanResearch, cResearchPlanTechID, cTechChurchGardeImperial1) < 0)
         {
            createSimpleResearchPlan(cTechChurchGardeImperial1, churchID, cMilitaryEscrowID, 65);
            debugMilitary("Revolutionary France: Researching Young Guard");
         }
      }
      else if (kbTechGetStatus(cTechChurchGardeImperial1) == cTechStatusActive)
      {
         youngGuardResearched = true;
      }
      
      if ((youngGuardResearched == true) && (middleGuardResearched == false) &&
          (kbTechGetStatus(cTechChurchGardeImperial2) == cTechStatusObtainable))
      {
         if (aiPlanGetIDByTypeAndVariableType(cPlanResearch, cResearchPlanTechID, cTechChurchGardeImperial2) < 0)
         {
            createSimpleResearchPlan(cTechChurchGardeImperial2, churchID, cMilitaryEscrowID, 60);
            debugMilitary("Revolutionary France: Researching Middle Guard");
         }
      }
      else if (kbTechGetStatus(cTechChurchGardeImperial2) == cTechStatusActive)
      {
         middleGuardResearched = true;
      }
      
      if ((middleGuardResearched == true) && (oldGuardResearched == false) &&
          (kbTechGetStatus(cTechChurchGardeImperial3) == cTechStatusObtainable))
      {
         if (aiPlanGetIDByTypeAndVariableType(cPlanResearch, cResearchPlanTechID, cTechChurchGardeImperial3) < 0)
         {
            createSimpleResearchPlan(cTechChurchGardeImperial3, churchID, cMilitaryEscrowID, 55);
            debugMilitary("Revolutionary France: Researching Old Guard");
         }
      }
      else if (kbTechGetStatus(cTechChurchGardeImperial3) == cTechStatusActive)
      {
         oldGuardResearched = true;
      }
   }
   
   if (youngGuardResearched && middleGuardResearched && oldGuardResearched)
   {
      debugMilitary("Revolutionary France: All Church guard techs researched");
   }
}

//==============================================================================
// revolutionaryFranceCardManager
//==============================================================================
rule revolutionaryFranceCardManager
inactive
minInterval 90
{
   float currentFood = kbResourceGet(cResourceFood);
   float currentWood = kbResourceGet(cResourceWood);
   float currentCoin = kbResourceGet(cResourceGold);
   
   int currentMilitary = aiGetMilitaryPop();
   int enemyPlayer = aiGetMostHatedPlayerID();
   int enemyMilitary = kbUnitCount(enemyPlayer, cUnitTypeLogicalTypeLandMilitary, cUnitStateAlive);
   
   int gameTime = xsGetTime();
   
   if ((gNapoleonicEraActive == false) && (currentMilitary > 50) && 
       (currentFood > 2000) && (currentCoin > 2000))
   {
      debugMilitary("Revolutionary France: Consider sending Napoleonic Era card");
   }
}

//==============================================================================
// revolutionaryFranceNapoleonicEraManager
//==============================================================================
rule revolutionaryFranceNapoleonicEraManager
inactive
minInterval 45
{
   static bool imperialUpgradesPrioritized = false;
   
   int mainBaseID = kbBaseGetMainID(cMyID);
   
   int napoleonGunCount = kbUnitCount(cMyID, cUnitTypedeMercNapoleonGun, cUnitStateAlive);
   
   int wantedNapoleonGuns = 4;
   
   if (kbProtoUnitAvailable(cUnitTypedeMercNapoleonGun) == true && gRevFranceNapoleonGunMaintain == -1)
   {
      gRevFranceNapoleonGunMaintain = createSimpleMaintainPlan(cUnitTypedeMercNapoleonGun, wantedNapoleonGuns, false, mainBaseID, 1);
      aiPlanSetDesiredPriority(gRevFranceNapoleonGunMaintain, 55);
      aiPlanSetActive(gRevFranceNapoleonGunMaintain, true);
      debugMilitary("Napoleonic Era: Created Napoleon Gun maintain plan");
   }
   else if (gRevFranceNapoleonGunMaintain >= 0)
   {
      aiPlanSetVariableInt(gRevFranceNapoleonGunMaintain, cTrainPlanNumberToMaintain, 0, wantedNapoleonGuns);
   }
   
   if ((gGrandeArmeeActive == true) && (imperialUpgradesPrioritized == false))
   {
      imperialUpgradesPrioritized = true;
      
      debugMilitary("Napoleonic Era: Grande Armee active - prioritizing Imperial upgrades");
      
   }
   
   debugMilitary("Napoleonic Era: Napoleon Guns=" + napoleonGunCount);
}

//==============================================================================
// revolutionaryFranceArtilleryManager
//==============================================================================
rule revolutionaryFranceArtilleryManager
inactive
minInterval 45
{
   int mainBaseID = kbBaseGetMainID(cMyID);
   
   int falconetCount = kbUnitCount(cMyID, cUnitTypeFalconet, cUnitStateAlive);
   int horseArtilleryCount = kbUnitCount(cMyID, cUnitTypexpHorseArtillery, cUnitStateAlive);
   int mortarCount = kbUnitCount(cMyID, cUnitTypeMortar, cUnitStateAlive);
   
   int enemyPlayer = aiGetMostHatedPlayerID();
   int enemyBuildingCount = kbUnitCount(enemyPlayer, cUnitTypeBuilding, cUnitStateAlive);
   int enemyArtilleryCount = kbUnitCount(enemyPlayer, cUnitTypeAbstractArtillery, cUnitStateAlive);
   int enemyInfantryCount = kbUnitCount(enemyPlayer, cUnitTypeAbstractInfantry, cUnitStateAlive);
   
   int wantedFalconets = 4;
   int wantedHorseArtillery = 2;
   int wantedMortars = 2;
   
   if (enemyInfantryCount > 40)
   {
      wantedFalconets = 6;
   }
   
   if (enemyBuildingCount > 15)
   {
      wantedMortars = 4;
   }
   
   if (enemyArtilleryCount > 5)
   {
      wantedHorseArtillery = 4;
   }
   
   if (kbProtoUnitAvailable(cUnitTypeFalconet) == true && gRevFranceFalconetMaintain == -1)
   {
      gRevFranceFalconetMaintain = createSimpleMaintainPlan(cUnitTypeFalconet, wantedFalconets, false, mainBaseID, 1);
      aiPlanSetDesiredPriority(gRevFranceFalconetMaintain, 50);
      aiPlanSetActive(gRevFranceFalconetMaintain, true);
      debugMilitary("Revolutionary France: Created Falconet maintain plan");
   }
   else if (gRevFranceFalconetMaintain >= 0)
   {
      aiPlanSetVariableInt(gRevFranceFalconetMaintain, cTrainPlanNumberToMaintain, 0, wantedFalconets);
   }
   
   if (kbProtoUnitAvailable(cUnitTypexpHorseArtillery) == true && gRevFranceHorseArtilleryMaintain == -1)
   {
      gRevFranceHorseArtilleryMaintain = createSimpleMaintainPlan(cUnitTypexpHorseArtillery, wantedHorseArtillery, false, mainBaseID, 1);
      aiPlanSetDesiredPriority(gRevFranceHorseArtilleryMaintain, 45);
      aiPlanSetActive(gRevFranceHorseArtilleryMaintain, true);
      debugMilitary("Revolutionary France: Created Horse Artillery maintain plan");
   }
   else if (gRevFranceHorseArtilleryMaintain >= 0)
   {
      aiPlanSetVariableInt(gRevFranceHorseArtilleryMaintain, cTrainPlanNumberToMaintain, 0, wantedHorseArtillery);
   }
   
   if (kbProtoUnitAvailable(cUnitTypeMortar) == true && gRevFranceMortarMaintain == -1)
   {
      gRevFranceMortarMaintain = createSimpleMaintainPlan(cUnitTypeMortar, wantedMortars, false, mainBaseID, 1);
      aiPlanSetDesiredPriority(gRevFranceMortarMaintain, 40);
      aiPlanSetActive(gRevFranceMortarMaintain, true);
      debugMilitary("Revolutionary France: Created Mortar maintain plan");
   }
   else if (gRevFranceMortarMaintain >= 0)
   {
      aiPlanSetVariableInt(gRevFranceMortarMaintain, cTrainPlanNumberToMaintain, 0, wantedMortars);
   }
   
   debugMilitary("Revolutionary France Artillery: Falconets=" + falconetCount + "/" + wantedFalconets +
                 ", Horse Artillery=" + horseArtilleryCount + "/" + wantedHorseArtillery +
                 ", Mortars=" + mortarCount + "/" + wantedMortars);
}

//==============================================================================
// revolutionaryFranceCavalryManager
//==============================================================================
rule revolutionaryFranceCavalryManager
inactive
minInterval 45
{
   int mainBaseID = kbBaseGetMainID(cMyID);
   
   int hussarCount = kbUnitCount(cMyID, cUnitTypeHussar, cUnitStateAlive);
   int dragoonCount = kbUnitCount(cMyID, cUnitTypeDragoon, cUnitStateAlive);
   int gendarmeCount = kbUnitCount(cMyID, cUnitTypeCuirassier, cUnitStateAlive);
   
   int eclaireurCount = kbUnitCount(cMyID, cUnitTypedeRevolutionaryScout, cUnitStateAlive);
   
   int enemyPlayer = aiGetMostHatedPlayerID();
   int enemyCavalryCount = kbUnitCount(enemyPlayer, cUnitTypeAbstractCavalry, cUnitStateAlive);
   int enemyLightInfCount = kbUnitCount(enemyPlayer, cUnitTypeAbstractLightInfantry, cUnitStateAlive);
   int enemyArtilleryCount = kbUnitCount(enemyPlayer, cUnitTypeAbstractArtillery, cUnitStateAlive);
   
   int wantedHussars = 5;
   int wantedDragoons = 8;
   int wantedGendarmes = 5;
   
   if (enemyLightInfCount > 20)
   {
      wantedHussars = 10;
      wantedGendarmes = 8;
   }
   
   if (enemyArtilleryCount > 5)
   {
      wantedHussars = 12;
      wantedDragoons = 10;
   }
   
   if (enemyCavalryCount > 15)
   {
      wantedDragoons = 15;
   }
   
   if (kbProtoUnitAvailable(cUnitTypeHussar) == true && gRevFranceHussarMaintain == -1)
   {
      gRevFranceHussarMaintain = createSimpleMaintainPlan(cUnitTypeHussar, wantedHussars, false, mainBaseID, 1);
      aiPlanSetDesiredPriority(gRevFranceHussarMaintain, 55);
      aiPlanSetActive(gRevFranceHussarMaintain, true);
      debugMilitary("Revolutionary France: Created Hussar maintain plan");
   }
   else if (gRevFranceHussarMaintain >= 0)
   {
      aiPlanSetVariableInt(gRevFranceHussarMaintain, cTrainPlanNumberToMaintain, 0, wantedHussars);
   }
   
   if (kbProtoUnitAvailable(cUnitTypeDragoon) == true && gRevFranceDragoonMaintain == -1)
   {
      gRevFranceDragoonMaintain = createSimpleMaintainPlan(cUnitTypeDragoon, wantedDragoons, false, mainBaseID, 1);
      aiPlanSetDesiredPriority(gRevFranceDragoonMaintain, 50);
      aiPlanSetActive(gRevFranceDragoonMaintain, true);
      debugMilitary("Revolutionary France: Created Dragoon maintain plan");
   }
   else if (gRevFranceDragoonMaintain >= 0)
   {
      aiPlanSetVariableInt(gRevFranceDragoonMaintain, cTrainPlanNumberToMaintain, 0, wantedDragoons);
   }
   
   if (kbProtoUnitAvailable(cUnitTypeCuirassier) == true && gRevFranceGendarmeMaintain == -1)
   {
      gRevFranceGendarmeMaintain = createSimpleMaintainPlan(cUnitTypeCuirassier, wantedGendarmes, false, mainBaseID, 1);
      aiPlanSetDesiredPriority(gRevFranceGendarmeMaintain, 45);
      aiPlanSetActive(gRevFranceGendarmeMaintain, true);
      debugMilitary("Revolutionary France: Created Gendarme maintain plan");
   }
   else if (gRevFranceGendarmeMaintain >= 0)
   {
      aiPlanSetVariableInt(gRevFranceGendarmeMaintain, cTrainPlanNumberToMaintain, 0, wantedGendarmes);
   }
   
   debugMilitary("Revolutionary France Cavalry: Hussars=" + hussarCount + "/" + wantedHussars +
                 ", Dragoons=" + dragoonCount + "/" + wantedDragoons +
                 ", Gendarmes=" + gendarmeCount + "/" + wantedGendarmes +
                 ", Eclaireurs=" + eclaireurCount);
}

//==============================================================================
// Helper function to check if a specific card has been sent
//==============================================================================
bool revolutionaryFranceCardSent(int techID = -1)
{
   if (techID < 0)
   {
      return(false);
   }
   return(kbTechGetStatus(techID) == cTechStatusActive);
}

//==============================================================================
// revolutionaryFranceCardEffectTracker
//==============================================================================
rule revolutionaryFranceCardEffectTracker
inactive
minInterval 30
{
   if ((gNapoleonicEraActive == false) && 
       (kbTechGetStatus(cTechDERevolutionFranceNE) == cTechStatusActive))
   {
      gNapoleonicEraActive = true;
      xsEnableRule("revolutionaryFranceNapoleonicEraManager");
      debugMilitary("Revolutionary France: Napoleonic Era activated!");
   }
   
   if ((gGrandeArmeeActive == false) && 
       (kbTechGetStatus(cTechDEHCREVGrandeArmee) == cTechStatusActive))
   {
      gGrandeArmeeActive = true;
      debugMilitary("Revolutionary France: Grande Armee sent - Imperial upgrades at 50% cost!");
   }
   
   if ((gGenieTroopsActive == false) && 
       (kbTechGetStatus(cTechDEHCREVGenieTroops) == cTechStatusActive))
   {
      gGenieTroopsActive = true;
      debugMilitary("Revolutionary France: Genie Troops sent - Grenadiers can gather!");
   }
}
//==============================================================================
// revolutionaryFranceSansculotteManager
//==============================================================================
rule revolutionaryFranceSansculotteManager
inactive
minInterval 10
maxInterval 15
{
   static int sansculotteQuery = -1;
   
   if (sansculotteQuery < 0)
   {
      sansculotteQuery = kbUnitQueryCreate("Sansculotte Query");
      kbUnitQuerySetPlayerID(sansculotteQuery, cMyID);
      kbUnitQuerySetUnitType(sansculotteQuery, gEconUnit);
      kbUnitQuerySetState(sansculotteQuery, cUnitStateAlive);
   }
   
   kbUnitQueryResetResults(sansculotteQuery);
   int numSansculottes = kbUnitQueryExecute(sansculotteQuery);
   aiEcho("Number of Sansculottes: "+numSansculottes+"");
   if (numSansculottes < 1)
   {
      return;
   }
   
   int unitID = -1;
   int currentPlan = -1;
   int planType = -1;
   
   for (i = 0; < numSansculottes)
   {
      unitID = kbUnitQueryGetResult(sansculotteQuery, i);
      if (unitID < 0)
      {
         continue;
      }
      
      currentPlan = kbUnitGetPlanID(unitID);
      if (currentPlan < 0)
      {
         continue;
      }
      
      planType = aiPlanGetType(currentPlan);
      
      if ((planType == cPlanAttack) ||
          (planType == cPlanDefend) ||
          (planType == cPlanCombat) ||
          (planType == cPlanReserve) ||
          (planType == cPlanMission) ||
          (planType == cPlanTransport))
      {
         aiPlanRemoveUnit(currentPlan, unitID);
      }
   }
}
//==============================================================================
// revolutionaryFranceSansculotteGatherManager
//==============================================================================
rule revolutionaryFranceSansculotteGatherManager
inactive
minInterval 10
maxInterval 20
{
   static int idleQuery = -1;
   
   if (idleQuery < 0)
   {
      idleQuery = kbUnitQueryCreate("Idle Sansculotte Query");
      kbUnitQuerySetPlayerID(idleQuery, cMyID);
      kbUnitQuerySetUnitType(idleQuery, gEconUnit);
      kbUnitQuerySetState(idleQuery, cUnitStateAlive);
      kbUnitQuerySetActionType(idleQuery, cActionTypeIdle);
   }
   
   kbUnitQueryResetResults(idleQuery);
   int numIdle = kbUnitQueryExecute(idleQuery);
   
   if (numIdle < 1)
   {
      return;
   }
   
   debugEconomy("Revolutionary France: Found " + numIdle + " idle Sansculottes");
   
   float foodNeeded = xsArrayGetFloat(gResourceNeeds, cResourceFood);
   float woodNeeded = xsArrayGetFloat(gResourceNeeds, cResourceWood);
   float coinNeeded = xsArrayGetFloat(gResourceNeeds, cResourceGold);
   
   int foodGatherers = aiGetNumberGatherers(gEconUnit, cResourceFood, cAIResourceSubTypeHunt) +
                       aiGetNumberGatherers(gEconUnit, cResourceFood, cAIResourceSubTypeEasy) +
                       aiGetNumberGatherers(gEconUnit, cResourceFood, cAIResourceSubTypeFarm);
   int woodGatherers = aiGetNumberGatherers(gEconUnit, cResourceWood, cAIResourceSubTypeEasy);
   int coinGatherers = aiGetNumberGatherers(gEconUnit, cResourceGold, cAIResourceSubTypeEasy) +
                       aiGetNumberGatherers(gEconUnit, cResourceGold, cAIResourceSubTypeFarm);
   
   int totalGatherers = kbUnitCount(cMyID, gEconUnit, cUnitStateAlive);
   
   float foodRatio = 0.50;
   float woodRatio = 0.25;
   float coinRatio = 0.25;
   
   float totalNeeded = 0.0;
   if (foodNeeded > 0.0)
   {
      totalNeeded = totalNeeded + foodNeeded;
   }
   if (woodNeeded > 0.0)
   {
      totalNeeded = totalNeeded + woodNeeded;
   }
   if (coinNeeded > 0.0)
   {
      totalNeeded = totalNeeded + coinNeeded;
   }
   
   if (totalNeeded > 0.0)
   {
      if (foodNeeded > 0.0)
      {
         foodRatio = foodNeeded / totalNeeded;
      }
      else
      {
         foodRatio = 0.0;
      }
      if (woodNeeded > 0.0)
      {
         woodRatio = woodNeeded / totalNeeded;
      }
      else
      {
         woodRatio = 0.0;
      }
      if (coinNeeded > 0.0)
      {
         coinRatio = coinNeeded / totalNeeded;
      }
      else
      {
         coinRatio = 0.0;
      }
   }
   
   int wantedFoodGatherers = totalGatherers * foodRatio;
   int wantedWoodGatherers = totalGatherers * woodRatio;
   int wantedCoinGatherers = totalGatherers * coinRatio;
   
   int resourceToGather = cResourceFood;
   int biggestDeficit = 0;
   
   int foodDeficit = wantedFoodGatherers - foodGatherers;
   int woodDeficit = wantedWoodGatherers - woodGatherers;
   int coinDeficit = wantedCoinGatherers - coinGatherers;
   
   if (foodDeficit > biggestDeficit)
   {
      biggestDeficit = foodDeficit;
      resourceToGather = cResourceFood;
   }
   if (woodDeficit > biggestDeficit)
   {
      biggestDeficit = woodDeficit;
      resourceToGather = cResourceWood;
   }
   if (coinDeficit > biggestDeficit)
   {
      biggestDeficit = coinDeficit;
      resourceToGather = cResourceGold;
   }
   
   if (biggestDeficit <= 0)
   {
      resourceToGather = getMostNeededResource();
   }
   
   int mainBaseID = kbBaseGetMainID(cMyID);
   vector mainBaseLoc = kbBaseGetLocation(cMyID, mainBaseID);
   float maxDistance = kbBaseGetMaximumResourceDistance(cMyID, mainBaseID);
   
   static int resourceQuery = -1;
   
   if (resourceQuery < 0)
   {
      resourceQuery = kbUnitQueryCreate("Sansculotte Resource Query");
      kbUnitQuerySetState(resourceQuery, cUnitStateAlive);
      kbUnitQuerySetAscendingSort(resourceQuery, true);
   }
   
   int resourceUnitID = -1;
   
   if (resourceToGather == cResourceFood)
   {
      kbUnitQuerySetPlayerRelation(resourceQuery, cPlayerRelationAny);
      kbUnitQuerySetPlayerID(resourceQuery, -1);
      kbUnitQuerySetUnitType(resourceQuery, cUnitTypeHuntable);
      kbUnitQuerySetPosition(resourceQuery, mainBaseLoc);
      kbUnitQuerySetMaximumDistance(resourceQuery, maxDistance);
      kbUnitQueryResetResults(resourceQuery);
      
      if (kbUnitQueryExecute(resourceQuery) > 0)
      {
         resourceUnitID = kbUnitQueryGetResult(resourceQuery, 0);
      }
      
      if (resourceUnitID < 0)
      {
         kbUnitQuerySetUnitType(resourceQuery, cUnitTypeBerryBush);
         kbUnitQueryResetResults(resourceQuery);
         if (kbUnitQueryExecute(resourceQuery) > 0)
         {
            resourceUnitID = kbUnitQueryGetResult(resourceQuery, 0);
         }
      }
      
      if (resourceUnitID < 0)
      {
         kbUnitQuerySetPlayerID(resourceQuery, cMyID);
         kbUnitQuerySetPlayerRelation(resourceQuery, -1);
         kbUnitQuerySetUnitType(resourceQuery, gFarmUnit);
         kbUnitQueryResetResults(resourceQuery);
         if (kbUnitQueryExecute(resourceQuery) > 0)
         {
            resourceUnitID = kbUnitQueryGetResult(resourceQuery, 0);
         }
      }
   }
   else if (resourceToGather == cResourceWood)
   {
      kbUnitQuerySetPlayerRelation(resourceQuery, cPlayerRelationAny);
      kbUnitQuerySetPlayerID(resourceQuery, -1);
      kbUnitQuerySetUnitType(resourceQuery, cUnitTypeTree);
      kbUnitQuerySetPosition(resourceQuery, mainBaseLoc);
      kbUnitQuerySetMaximumDistance(resourceQuery, maxDistance);
      kbUnitQueryResetResults(resourceQuery);
      
      if (kbUnitQueryExecute(resourceQuery) > 0)
      {
         resourceUnitID = kbUnitQueryGetResult(resourceQuery, 0);
      }
   }
   else if (resourceToGather == cResourceGold)
   {
      kbUnitQuerySetPlayerRelation(resourceQuery, cPlayerRelationAny);
      kbUnitQuerySetPlayerID(resourceQuery, -1);
      kbUnitQuerySetUnitType(resourceQuery, cUnitTypeAbstractMine);
      kbUnitQuerySetPosition(resourceQuery, mainBaseLoc);
      kbUnitQuerySetMaximumDistance(resourceQuery, maxDistance);
      kbUnitQueryResetResults(resourceQuery);
      
      if (kbUnitQueryExecute(resourceQuery) > 0)
      {
         resourceUnitID = kbUnitQueryGetResult(resourceQuery, 0);
      }
      
      if (resourceUnitID < 0)
      {
         kbUnitQuerySetPlayerID(resourceQuery, cMyID);
         kbUnitQuerySetPlayerRelation(resourceQuery, -1);
         kbUnitQuerySetUnitType(resourceQuery, gPlantationUnit);
         kbUnitQueryResetResults(resourceQuery);
         if (kbUnitQueryExecute(resourceQuery) > 0)
         {
            resourceUnitID = kbUnitQueryGetResult(resourceQuery, 0);
         }
      }
   }
   
   if (resourceUnitID >= 0)
   {
      int unitID = -1;
      
      int maxToAssign = 5;
      if (numIdle < maxToAssign)
      {
         maxToAssign = numIdle;
      }
      
      for (i = 0; < maxToAssign)
      {
         unitID = kbUnitQueryGetResult(idleQuery, i);
         if (unitID >= 0)
         {
            aiTaskUnitWork(unitID, resourceUnitID);
         }
      }
      
      string resourceName = "food";
      if (resourceToGather == cResourceWood)
      {
         resourceName = "wood";
      }
      else if (resourceToGather == cResourceGold)
      {
         resourceName = "coin";
      }
      
      debugEconomy("Revolutionary France: Assigned " + maxToAssign + 
                   " Sansculottes to gather " + resourceName);
   }
   else
   {
      debugEconomy("Revolutionary France: No suitable resource location found");
   }
   
   debugEconomy("Revolutionary France Gatherers: Food=" + foodGatherers + "/" + wantedFoodGatherers +
                ", Wood=" + woodGatherers + "/" + wantedWoodGatherers +
                ", Coin=" + coinGatherers + "/" + wantedCoinGatherers);
}
