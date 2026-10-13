extern bool gIndonesiaCitizenshipSent = false;
extern bool gIndonesiaCetbangsSent = false;
extern bool gIndonesiaWokouSent = false;
extern bool gIndonesiaSpiceTradeSent = false;
extern bool gIndonesiaSurabayaSent = false;

extern int gIndonesiaWarElephantMaintain = -1;
extern int gIndonesiaCetbangMaintain = -1;
extern int gIndonesiaSpearmanMaintain = -1;
extern int gIndonesiaHeavyCannonMaintain = -1;
extern int gIndonesiaSettlerMaintain = -1;
extern int gIndonesiaWokouMaintain = -1;
extern int gIndonesiaFluytMaintain = -1;

//==============================================================================
// indonesiaRevolutionManager
//==============================================================================
rule indonesiaRevolutionManager
inactive
minInterval 30
{
   int mainBaseID = kbBaseGetMainID(cMyID);
   
   int cetbangCount = kbUnitCount(cMyID, cUnitTypedeREVCetbang, cUnitStateAlive);
   int spearmanCount = kbUnitCount(cMyID, cUnitTypedeREVJavaSpearman, cUnitStateAlive);
   int heavyCannonCount = kbUnitCount(cMyID, cUnitTypeCannon, cUnitStateAlive);
   
   debugMilitary("Indonesia: Cetbangs=" + cetbangCount + 
                 ", Javanese Spearmen=" + spearmanCount +
                 ", Heavy Cannons=" + heavyCannonCount);
   
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
   
   int wantedSpearmen = 15;
   
   if (enemyCavalryCount > 10)
   {
      wantedSpearmen = 25;
   }
   if (enemyCavalryCount > 20)
   {
      wantedSpearmen = 35;
   }
   
   if ((enemyHeavyInfCount + enemyLightInfCount) > 30 && enemyCavalryCount < 10)
   {
      wantedSpearmen = 10;
   }
   
   if (kbProtoUnitAvailable(cUnitTypedeREVJavaSpearman) == true && gIndonesiaSpearmanMaintain == -1)
   {
      gIndonesiaSpearmanMaintain = createSimpleMaintainPlan(cUnitTypedeREVJavaSpearman, wantedSpearmen, false, mainBaseID, 1);
      aiPlanSetDesiredPriority(gIndonesiaSpearmanMaintain, 65);
      aiPlanSetActive(gIndonesiaSpearmanMaintain, true);
      debugMilitary("Indonesia: Created Javanese Spearman maintain plan");
   }
   else if (gIndonesiaSpearmanMaintain >= 0)
   {
      aiPlanSetVariableInt(gIndonesiaSpearmanMaintain, cTrainPlanNumberToMaintain, 0, wantedSpearmen);
   }

   if (kbProtoUnitAvailable(cUnitTypeypNatMercWarElephant) == true && gIndonesiaWarElephantMaintain == -1)
   {
      gIndonesiaWarElephantMaintain = createSimpleMaintainPlan(cUnitTypeypNatMercWarElephant, 40, false, -1, 1);
      aiPlanSetDesiredPriority(gIndonesiaWarElephantMaintain, 75);
      aiPlanSetActive(gIndonesiaWarElephantMaintain, true);
   }
   
   if (gIndonesiaCetbangsSent == true)
   {
      
      int wantedCetbangs = 3;
      
      if ((enemyHeavyInfCount + enemyLightInfCount) > 20)
      {
         wantedCetbangs = 5;
      }
      if ((enemyHeavyInfCount + enemyLightInfCount) > 40)
      {
         wantedCetbangs = 7;
      }
      
      int availablePop = kbGetPopCap() - kbGetPop();
      int maxCetbangs = availablePop / 3;
      if (wantedCetbangs > maxCetbangs && maxCetbangs > 0)
      {
         wantedCetbangs = maxCetbangs;
      }
      
      if (kbProtoUnitAvailable(cUnitTypedeREVCetbang) == true && gIndonesiaCetbangMaintain == -1)
      {
         gIndonesiaCetbangMaintain = createSimpleMaintainPlan(cUnitTypedeREVCetbang, wantedCetbangs, false, mainBaseID, 1);
         aiPlanSetDesiredPriority(gIndonesiaCetbangMaintain, 70);
         aiPlanSetActive(gIndonesiaCetbangMaintain, true);
         debugMilitary("Indonesia: Created Cetbang Cannon maintain plan");
      }
      else if (gIndonesiaCetbangMaintain >= 0)
      {
         aiPlanSetVariableInt(gIndonesiaCetbangMaintain, cTrainPlanNumberToMaintain, 0, wantedCetbangs);
      }
   }
   
   if (gIndonesiaSurabayaSent == true)
   {
      
      int wantedHeavyCannons = 2;
      
      if (enemyBuildingCount > 20)
      {
         wantedHeavyCannons = 3;
      }
      
      if (kbProtoUnitAvailable(cUnitTypeCannon) == true && gIndonesiaHeavyCannonMaintain == -1)
      {
         gIndonesiaHeavyCannonMaintain = createSimpleMaintainPlan(cUnitTypeCannon, wantedHeavyCannons, false, mainBaseID, 1);
         aiPlanSetDesiredPriority(gIndonesiaHeavyCannonMaintain, 55);
         aiPlanSetActive(gIndonesiaHeavyCannonMaintain, true);
         debugMilitary("Indonesia: Created Heavy Cannon maintain plan");
      }
      else if (gIndonesiaHeavyCannonMaintain >= 0)
      {
         aiPlanSetVariableInt(gIndonesiaHeavyCannonMaintain, cTrainPlanNumberToMaintain, 0, wantedHeavyCannons);
      }
   }
   
   debugMilitary("Indonesia targets: Spearmen=" + wantedSpearmen +
                 ", Cetbangs=" + (gIndonesiaCetbangsSent ? wantedCetbangs : 0));
}

//==============================================================================
// indonesiaEconomyManager
//==============================================================================
rule indonesiaEconomyManager
inactive
minInterval 60
{
   
   if (gIndonesiaCitizenshipSent == false)
   {
      if (kbTechGetStatus(cTechDEHCREVAcehExports) == cTechStatusActive)
      {
         gIndonesiaCitizenshipSent = true;
         debugMilitary("Indonesia: Citizenship active - Settlers enabled for 70 coin!");
      }
      else
      {
         
         int bankCount = kbUnitCount(cMyID, cUnitTypeBank, cUnitStateAlive);
         if (bankCount > 0)
         {
            debugEconomy("Indonesia: " + bankCount + " Banks providing coin trickle");
         }
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
   
   if (kbProtoUnitAvailable(gEconUnit) == true && gIndonesiaSettlerMaintain == -1)
   {
      gIndonesiaSettlerMaintain = createSimpleMaintainPlan(gEconUnit, wantedSettlers, false, kbBaseGetMainID(cMyID), 1);
      aiPlanSetDesiredPriority(gIndonesiaSettlerMaintain, 70);
      aiPlanSetActive(gIndonesiaSettlerMaintain, true);
      debugMilitary("Indonesia: Created Settler maintain plan (post-Citizenship)");
   }
   else if (gIndonesiaSettlerMaintain >= 0)
   {
      aiPlanSetVariableInt(gIndonesiaSettlerMaintain, cTrainPlanNumberToMaintain, 0, wantedSettlers);
   }
   
   debugEconomy("Indonesia Economy: Settlers=" + currentSettlers + "/" + wantedSettlers);
}

//==============================================================================
// indonesiaNavyManager
//==============================================================================
rule indonesiaNavyManager
inactive
minInterval 60
{
   if (gNavyMap == false)
   {
      xsDisableSelf();
      return;
   }
   
   int mainBaseID = kbBaseGetMainID(cMyID);
   
   int wokouCount = kbUnitCount(cMyID, cUnitTypeypWokouJunk, cUnitStateAlive);
   int fluytCount = kbUnitCount(cMyID, cUnitTypeFluyt, cUnitStateAlive);
   
   int enemyPlayer = aiGetMostHatedPlayerID();
   int enemyNavyCount = kbUnitCount(enemyPlayer, cUnitTypeAbstractWarShip, cUnitStateAlive);
   
   if (gIndonesiaWokouSent == true)
   {
      int wantedWokous = kbGetBuildLimit(cMyID, cUnitTypeypWokouJunk);
      
      if (kbProtoUnitAvailable(cUnitTypeypWokouJunk) == true && gIndonesiaWokouMaintain == -1)
      {
         gIndonesiaWokouMaintain = createSimpleMaintainPlan(cUnitTypeypWokouJunk, wantedWokous, false, -1, 1);
         aiPlanSetDesiredPriority(gIndonesiaWokouMaintain, 65);
         aiPlanSetActive(gIndonesiaWokouMaintain, true);
         debugMilitary("Indonesia: Created Wokou Junk maintain plan");
      }
      else if (gIndonesiaWokouMaintain >= 0)
      {
         aiPlanSetVariableInt(gIndonesiaWokouMaintain, cTrainPlanNumberToMaintain, 0, wantedWokous);
      }
   }
   
   if (gIndonesiaSpiceTradeSent == true)
   {
      int wantedFluyts = kbGetBuildLimit(cMyID, cUnitTypeFluyt);
      
      if (kbProtoUnitAvailable(cUnitTypeFluyt) == true && gIndonesiaFluytMaintain == -1)
      {
         gIndonesiaFluytMaintain = createSimpleMaintainPlan(cUnitTypeFluyt, wantedFluyts, false, -1, 1);
         aiPlanSetDesiredPriority(gIndonesiaFluytMaintain, 45);
         aiPlanSetActive(gIndonesiaFluytMaintain, true);
         debugMilitary("Indonesia: Created Fluyt maintain plan");
      }
      else if (gIndonesiaFluytMaintain >= 0)
      {
         aiPlanSetVariableInt(gIndonesiaFluytMaintain, cTrainPlanNumberToMaintain, 0, wantedFluyts);
      }
   }
   
   debugMilitary("Indonesia Navy: Wokou Junks=" + wokouCount + 
                 ", Fluyts=" + fluytCount);
}

//==============================================================================
// indonesiaBankManager
//==============================================================================
rule indonesiaBankManager
inactive
minInterval 90
{
   
   int bankCount = kbUnitCount(cMyID, cUnitTypeBank, cUnitStateAlive);
   int bankBuildLimit = kbGetBuildLimit(cMyID, cUnitTypeBank);
   
   float bankCoinTrickle = bankCount * 2.75;
   
   debugEconomy("Indonesia (Dutch): " + bankCount + "/" + bankBuildLimit + 
                " Banks providing ~" + bankCoinTrickle + " coin/sec");
   
   if (bankCount < bankBuildLimit)
   {
      debugEconomy("Indonesia: Should build more Banks if possible");
   }
   
   int bankID = getUnit(cUnitTypeBank, cMyID, cUnitStateAlive);
   if (bankID >= 0)
   {
      if (kbTechGetStatus(cTechCoffeeTrade) == cTechStatusObtainable)
      {
         createSimpleResearchPlan(cTechCoffeeTrade, bankID, cEconomyEscrowID, 50);
      }
   }
}

//==============================================================================
// indonesiaCardManager
//==============================================================================
rule indonesiaCardManager
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
   
   debugMilitary("Indonesia Card Manager: Evaluating priorities");
}

//==============================================================================
// indonesiaCardEffectTracker
//==============================================================================
rule indonesiaCardEffectTracker
inactive
minInterval 30
{
   if ((gIndonesiaCitizenshipSent == false) && 
       (kbTechGetStatus(cTechDEHCREVAcehExports) == cTechStatusActive))
   {
      gIndonesiaCitizenshipSent = true;
      debugMilitary("Indonesia: Citizenship activated - Settlers can be trained!");
   }
   
   if ((gIndonesiaCetbangsSent == false) && 
       (kbTechGetStatus(cTechDEHCREVCetbangCannons) == cTechStatusActive))
   {
      gIndonesiaCetbangsSent = true;
      debugMilitary("Indonesia: Cetbang Cannons activated - can train Cetbangs!");
   }
   
   if ((gIndonesiaWokouSent == false) && 
       (kbTechGetStatus(cTechDEHCREVWokouPirates) == cTechStatusActive))
   {
      gIndonesiaWokouSent = true;
      if (gNavyMap == true)
      {
         debugMilitary("Indonesia: Wokou Pirates activated - can train Wokou Junks!");
      }
   }
   
   if ((gIndonesiaSpiceTradeSent == false) && 
       (kbTechGetStatus(cTechDEHCREVSpiceTrade) == cTechStatusActive))
   {
      gIndonesiaSpiceTradeSent = true;
      debugMilitary("Indonesia: Spice Trade activated - Docks generate coin!");
   }
   
   if ((gIndonesiaSurabayaSent == false) && 
       (kbTechGetStatus(cTechDEHCREVSurabaya) == cTechStatusActive))
   {
      gIndonesiaSurabayaSent = true;
      debugMilitary("Indonesia: Surabaya activated - Heavy Cannons and artillery HP buff!");
   }
}

//==============================================================================
// indonesiaArtilleryTacticsManager
//==============================================================================
rule indonesiaArtilleryTacticsManager
inactive
minInterval 45
{
   
   int cetbangCount = kbUnitCount(cMyID, cUnitTypedeREVCetbang, cUnitStateAlive);
   int spearmanCount = kbUnitCount(cMyID, cUnitTypedeREVJavaSpearman, cUnitStateAlive);
   int heavyCannonCount = kbUnitCount(cMyID, cUnitTypeHeavyCannon, cUnitStateAlive);
   
   int totalArtillery = cetbangCount + heavyCannonCount;
   
   int idealSpearmen = totalArtillery * 2;
   
   if (spearmanCount < idealSpearmen)
   {
      debugMilitary("Indonesia: Need more Spearmen to protect artillery (" + 
                    spearmanCount + "/" + idealSpearmen + ")");
   }
   
   if (totalArtillery >= 6 && spearmanCount >= 10)
   {
      debugMilitary("Indonesia: Strong artillery force (" + totalArtillery + 
                    " artillery + " + spearmanCount + " spearmen) - ready to attack");
   }
   else if (totalArtillery >= 4)
   {
      debugMilitary("Indonesia: Building artillery force (" + totalArtillery + " artillery)");
   }
   else
   {
      debugMilitary("Indonesia: Need more artillery (" + totalArtillery + " total)");
   }
}

//==============================================================================
// indonesiaCivSpecificManager
//==============================================================================
rule indonesiaCivSpecificManager
inactive
minInterval 120
{
   
   if (cMyCiv == cCivDutch)
   {
      
      int bankCount = kbUnitCount(cMyID, cUnitTypeBank, cUnitStateAlive);
      int ruyterCount = kbUnitCount(cMyID, cUnitTypeRuyter, cUnitStateAlive);
      
      debugMilitary("Indonesia (Dutch): " + bankCount + " Banks for economy");
      
      if (ruyterCount > 0)
      {
         debugMilitary("Indonesia (Dutch): " + ruyterCount + " Ruyters from pre-revolution");
      }
      
   }
   else if (cMyCiv == cCivPortuguese)
   {
      
      int tcCount = kbUnitCount(cMyID, cUnitTypeTownCenter, cUnitStateAlive);
      debugMilitary("Indonesia (Portuguese): " + tcCount + " Town Centers");
   }
}
