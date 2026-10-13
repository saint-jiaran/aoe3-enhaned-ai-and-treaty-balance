extern bool gCossackCitizenshipSent = false;
extern bool gCossackRegisterSent = false;
extern bool gCossackRoyalDecreeSent = false;
extern bool gCossackUprisingSent = false;

extern int gCossackRiderMaintain = -1;
extern int gCossackHaidamakaMaintain = -1;
extern int gCossackOutlawRiderMaintain = -1;
extern int gCossackSettlerMaintain = -1;

//==============================================================================
// cossackHetmanateRevolutionManager
//==============================================================================
rule cossackHetmanateRevolutionManager
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
   int wantedRiders = 0;
   int wantedHaidamaka = 0;
   int wantedOutlawRiders = 0;

   if (totalEnemyUnits > 5)
   {
      if (enemyHeavyInfCount > enemyLightInfCount)
      {
         wantedRiders = (militaryPop * 0.30) / 2;
         wantedHaidamaka = militaryPop * 0.45;
         wantedOutlawRiders = (militaryPop * 0.25) / 2;
      }
      else if (enemyCavalryCount > enemyLightInfCount)
      {
         wantedRiders = (militaryPop * 0.40) / 2;
         wantedHaidamaka = militaryPop * 0.35;
         wantedOutlawRiders = (militaryPop * 0.25) / 2;
      }
      else
      {
         wantedRiders = (militaryPop * 0.45) / 2;
         wantedHaidamaka = militaryPop * 0.25;
         wantedOutlawRiders = (militaryPop * 0.30) / 2;
      }
   }
   else
   {
      wantedRiders = (militaryPop * 0.35) / 2;
      wantedHaidamaka = militaryPop * 0.40;
      wantedOutlawRiders = (militaryPop * 0.25) / 2;
   }

   if (enemyArtilleryCount > 3)
   {
      wantedRiders = wantedRiders + 4;
   }

   int riderBL = kbGetBuildLimit(cMyID, cUnitTypedeREVHaidamakaRider);
   int haidamakaBL = kbGetBuildLimit(cMyID, cUnitTypedeREVHaidamaka);
   int outlawRiderBL = kbGetBuildLimit(cMyID, cUnitTypedeSaloonOutlawCossackRider);

   if ((riderBL > 0) && (wantedRiders > riderBL))
   {
      wantedRiders = riderBL;
   }
   if ((haidamakaBL > 0) && (wantedHaidamaka > haidamakaBL))
   {
      wantedHaidamaka = haidamakaBL;
   }
   if ((outlawRiderBL > 0) && (wantedOutlawRiders > outlawRiderBL))
   {
      wantedOutlawRiders = outlawRiderBL;
   }

   if (wantedRiders < 5)
   {
      wantedRiders = 5;
   }
   if (wantedHaidamaka < 8)
   {
      wantedHaidamaka = 8;
   }
   if (wantedOutlawRiders < 3)
   {
      wantedOutlawRiders = 3;
   }

   if (kbProtoUnitAvailable(cUnitTypedeREVHaidamakaRider) == true && gCossackRiderMaintain == -1)
   {
      gCossackRiderMaintain =
         createSimpleMaintainPlan(cUnitTypedeREVHaidamakaRider, wantedRiders, false, mainBaseID, 1);
      aiPlanSetDesiredPriority(gCossackRiderMaintain, 78);
      aiPlanSetActive(gCossackRiderMaintain, true);
      debugMilitary("Cossack Hetmanate: Created Haidamaka Rider maintain plan");
   }
   else if (gCossackRiderMaintain >= 0)
   {
      aiPlanSetVariableInt(gCossackRiderMaintain, cTrainPlanNumberToMaintain, 0, wantedRiders);
   }

   if (kbProtoUnitAvailable(cUnitTypedeREVHaidamaka) == true && gCossackHaidamakaMaintain == -1)
   {
      gCossackHaidamakaMaintain =
         createSimpleMaintainPlan(cUnitTypedeREVHaidamaka, wantedHaidamaka, false, mainBaseID, 1);
      aiPlanSetDesiredPriority(gCossackHaidamakaMaintain, 74);
      aiPlanSetActive(gCossackHaidamakaMaintain, true);
      debugMilitary("Cossack Hetmanate: Created Haidamaka maintain plan");
   }
   else if (gCossackHaidamakaMaintain >= 0)
   {
      aiPlanSetVariableInt(gCossackHaidamakaMaintain, cTrainPlanNumberToMaintain, 0, wantedHaidamaka);
   }

   if (kbProtoUnitAvailable(cUnitTypedeSaloonOutlawCossackRider) == true && gCossackOutlawRiderMaintain == -1)
   {
      gCossackOutlawRiderMaintain =
         createSimpleMaintainPlan(cUnitTypedeSaloonOutlawCossackRider, wantedOutlawRiders, false, mainBaseID, 1);
      aiPlanSetDesiredPriority(gCossackOutlawRiderMaintain, 70);
      aiPlanSetActive(gCossackOutlawRiderMaintain, true);
      debugMilitary("Cossack Hetmanate: Created Cossack Rider maintain plan");
   }
   else if (gCossackOutlawRiderMaintain >= 0)
   {
      aiPlanSetVariableInt(gCossackOutlawRiderMaintain, cTrainPlanNumberToMaintain, 0, wantedOutlawRiders);
   }

   debugMilitary("Cossack Hetmanate army composition: Riders=" + wantedRiders +
                 ", Haidamaka=" + wantedHaidamaka +
                 ", CossackRiders=" + wantedOutlawRiders);
}

//==============================================================================
// cossackHetmanateEconomyManager
//==============================================================================
rule cossackHetmanateEconomyManager
inactive
minInterval 60
{
   if (gCossackCitizenshipSent == false)
   {
      if (kbTechGetStatus(cTechDEHCREVCitizenshipCossacks) == cTechStatusActive)
      {
         gCossackCitizenshipSent = true;
         debugMilitary("Cossack Hetmanate: Citizenship active - Settlers enabled, 6 shipped!");
      }
      else
      {
         int tradingPosts = kbUnitCount(cMyID, cUnitTypeTradingPost, cUnitStateAlive);
         debugMilitary("Cossack Hetmanate economy (pre-Citizenship): TradingPosts=" + tradingPosts +
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

   if (kbProtoUnitAvailable(gEconUnit) == true && gCossackSettlerMaintain == -1)
   {
      gCossackSettlerMaintain = createSimpleMaintainPlan(gEconUnit, wantedSettlers, false, kbBaseGetMainID(cMyID), 1);
      aiPlanSetDesiredPriority(gCossackSettlerMaintain, 70);
      aiPlanSetActive(gCossackSettlerMaintain, true);
      debugMilitary("Cossack Hetmanate: Created Settler maintain plan (post-Citizenship)");
   }
   else if (gCossackSettlerMaintain >= 0)
   {
      aiPlanSetVariableInt(gCossackSettlerMaintain, cTrainPlanNumberToMaintain, 0, wantedSettlers);
   }

   debugMilitary("Cossack Hetmanate economy: Settlers=" + currentSettlers + "/" + wantedSettlers);
}

//==============================================================================
// cossackHetmanateCardEffectTracker
//==============================================================================
rule cossackHetmanateCardEffectTracker
inactive
minInterval 45
{
   if (gCossackRegisterSent == false)
   {
      if ((kbTechGetStatus(cTechDEHCREVRegisterCossacks) == cTechStatusActive) ||
          (kbTechGetStatus(cTechDEHCRegisterCossacks) == cTechStatusActive))
      {
         gCossackRegisterSent = true;
         debugMilitary("Cossack Hetmanate: Register Cossacks card active");
      }
   }

   if (gCossackRoyalDecreeSent == false)
   {
      if (kbTechGetStatus(cTechDEHCREVRoyalDecreeCossacks) == cTechStatusActive)
      {
         gCossackRoyalDecreeSent = true;
         debugMilitary("Cossack Hetmanate: Royal Decree card active");
      }
   }

   if (gCossackUprisingSent == false)
   {
      if (kbTechGetStatus(cTechDEHCREVUprisingHaidamaka) == cTechStatusActive)
      {
         gCossackUprisingSent = true;
         debugMilitary("Cossack Hetmanate: Uprising (Haidamaka) card active");
      }
   }
}

//==============================================================================
// cossackHetmanateCardManager
//==============================================================================
rule cossackHetmanateCardManager
inactive
minInterval 90
{
   int riderCount = kbUnitCount(cMyID, cUnitTypedeREVHaidamakaRider, cUnitStateAlive);
   int haidamakaCount = kbUnitCount(cMyID, cUnitTypedeREVHaidamaka, cUnitStateAlive);
   int settlerCount = kbUnitCount(cMyID, gEconUnit, cUnitStateAlive);

   debugMilitary("Cossack Hetmanate Card Manager: Riders=" + riderCount +
                 ", Haidamaka=" + haidamakaCount +
                 ", Settlers=" + settlerCount +
                 ", Citizenship=" + gCossackCitizenshipSent);
}
