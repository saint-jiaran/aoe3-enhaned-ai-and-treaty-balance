extern bool gPrussiaCitizenshipSent = false;
extern bool gPrussiaFactorySent = false;
extern bool gPrussiaLandwehrSent = false;
extern bool gPrussiaChevaulegerSent = false;
extern bool gPrussiaGeneralSent = false;

extern int gPrussiaLandwehrMaintain = -1;
extern int gPrussiaChevaulegerMaintain = -1;
extern int gPrussiaGrenadierMaintain = -1;
extern int gPrussiaMusketeerMaintain = -1;
extern int gPrussiaSettlerMaintain = -1;

extern int gPrussiaMarchRevolutionPlan = -1;

//==============================================================================
// prussiaRevolutionManager
//==============================================================================
rule prussiaRevolutionManager
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
   int wantedLandwehrs = 0;
   int wantedChevaulegers = 0;
   int wantedGrenadiers = 0;
   int wantedMusketeers = 0;

   if (totalEnemyUnits > 5)
   {
      if (enemyHeavyInfCount > enemyLightInfCount)
      {
         wantedLandwehrs = militaryPop * 0.40;
         wantedChevaulegers = (militaryPop * 0.20) / 2;
         wantedGrenadiers = militaryPop * 0.25;
         wantedMusketeers = militaryPop * 0.15;
      }
      else if (enemyCavalryCount > enemyLightInfCount)
      {
         wantedLandwehrs = militaryPop * 0.35;
         wantedChevaulegers = (militaryPop * 0.20) / 2;
         wantedGrenadiers = militaryPop * 0.10;
         wantedMusketeers = militaryPop * 0.35;
      }
      else
      {
         wantedLandwehrs = militaryPop * 0.30;
         wantedChevaulegers = (militaryPop * 0.35) / 2;
         wantedGrenadiers = militaryPop * 0.15;
         wantedMusketeers = militaryPop * 0.20;
      }
   }
   else
   {
      wantedLandwehrs = militaryPop * 0.35;
      wantedChevaulegers = (militaryPop * 0.25) / 2;
      wantedGrenadiers = militaryPop * 0.15;
      wantedMusketeers = militaryPop * 0.25;
   }

   if (enemyArtilleryCount > 3)
   {
      wantedChevaulegers = wantedChevaulegers + 4;
   }

   int landwehrBL = kbGetBuildLimit(cMyID, cUnitTypedeLandwehr);
   int chevaulegerBL = kbGetBuildLimit(cMyID, cUnitTypedeChevauleger);
   int grenadierBL = kbGetBuildLimit(cMyID, cUnitTypedeMercGrenadier);
   int musketeerBL = kbGetBuildLimit(cMyID, cUnitTypeMusketeer);

   if ((landwehrBL > 0) && (wantedLandwehrs > landwehrBL))
   {
      wantedLandwehrs = landwehrBL;
   }
   if ((chevaulegerBL > 0) && (wantedChevaulegers > chevaulegerBL))
   {
      wantedChevaulegers = chevaulegerBL;
   }
   if ((grenadierBL > 0) && (wantedGrenadiers > grenadierBL))
   {
      wantedGrenadiers = grenadierBL;
   }
   if ((musketeerBL > 0) && (wantedMusketeers > musketeerBL))
   {
      wantedMusketeers = musketeerBL;
   }

   if (wantedLandwehrs < 10)
   {
      wantedLandwehrs = 10;
   }
   if (wantedChevaulegers < 4)
   {
      wantedChevaulegers = 4;
   }
   if (wantedGrenadiers < 4)
   {
      wantedGrenadiers = 4;
   }
   if (wantedMusketeers < 6)
   {
      wantedMusketeers = 6;
   }

   if (kbProtoUnitAvailable(cUnitTypedeLandwehr) == true && gPrussiaLandwehrMaintain == -1)
   {
      gPrussiaLandwehrMaintain = createSimpleMaintainPlan(cUnitTypedeLandwehr, wantedLandwehrs, false, mainBaseID, 1);
      aiPlanSetDesiredPriority(gPrussiaLandwehrMaintain, 75);
      aiPlanSetActive(gPrussiaLandwehrMaintain, true);
      debugMilitary("Prussia: Created Landwehr maintain plan");
   }
   else if (gPrussiaLandwehrMaintain >= 0)
   {
      aiPlanSetVariableInt(gPrussiaLandwehrMaintain, cTrainPlanNumberToMaintain, 0, wantedLandwehrs);
   }

   if (kbProtoUnitAvailable(cUnitTypedeChevauleger) == true && gPrussiaChevaulegerMaintain == -1)
   {
      gPrussiaChevaulegerMaintain =
         createSimpleMaintainPlan(cUnitTypedeChevauleger, wantedChevaulegers, false, mainBaseID, 1);
      aiPlanSetDesiredPriority(gPrussiaChevaulegerMaintain, 72);
      aiPlanSetActive(gPrussiaChevaulegerMaintain, true);
      debugMilitary("Prussia: Created Chevauleger maintain plan");
   }
   else if (gPrussiaChevaulegerMaintain >= 0)
   {
      aiPlanSetVariableInt(gPrussiaChevaulegerMaintain, cTrainPlanNumberToMaintain, 0, wantedChevaulegers);
   }

   if (kbProtoUnitAvailable(cUnitTypedeMercGrenadier) == true && gPrussiaGrenadierMaintain == -1)
   {
      gPrussiaGrenadierMaintain =
         createSimpleMaintainPlan(cUnitTypedeMercGrenadier, wantedGrenadiers, false, mainBaseID, 1);
      aiPlanSetDesiredPriority(gPrussiaGrenadierMaintain, 68);
      aiPlanSetActive(gPrussiaGrenadierMaintain, true);
      debugMilitary("Prussia: Created Giant Grenadier maintain plan");
   }
   else if (gPrussiaGrenadierMaintain >= 0)
   {
      aiPlanSetVariableInt(gPrussiaGrenadierMaintain, cTrainPlanNumberToMaintain, 0, wantedGrenadiers);
   }

   if (kbProtoUnitAvailable(cUnitTypeMusketeer) == true && gPrussiaMusketeerMaintain == -1)
   {
      gPrussiaMusketeerMaintain = createSimpleMaintainPlan(cUnitTypeMusketeer, wantedMusketeers, false, mainBaseID, 1);
      aiPlanSetDesiredPriority(gPrussiaMusketeerMaintain, 65);
      aiPlanSetActive(gPrussiaMusketeerMaintain, true);
      debugMilitary("Prussia: Created Musketeer maintain plan");
   }
   else if (gPrussiaMusketeerMaintain >= 0)
   {
      aiPlanSetVariableInt(gPrussiaMusketeerMaintain, cTrainPlanNumberToMaintain, 0, wantedMusketeers);
   }

   debugMilitary("Prussia army composition: Landwehrs=" + wantedLandwehrs +
                 ", Chevaulegers=" + wantedChevaulegers +
                 ", Grenadiers=" + wantedGrenadiers +
                 ", Musketeers=" + wantedMusketeers);
}

//==============================================================================
// prussiaEconomyManager
//==============================================================================
rule prussiaEconomyManager
inactive
minInterval 60
{
   if (gPrussiaFactorySent == false)
   {
      if (kbTechGetStatus(cTechDEHCREVFactoryPrussia) == cTechStatusActive)
      {
         gPrussiaFactorySent = true;
         debugMilitary("Prussia: Factory card active - major income source");
      }
   }

   if (gPrussiaCitizenshipSent == false)
   {
      if (kbTechGetStatus(cTechDEHCREVCitizenship) == cTechStatusActive)
      {
         gPrussiaCitizenshipSent = true;
         debugMilitary("Prussia: Citizenship active - Settlers enabled again!");
      }
      else
      {
         int tradingPosts = kbUnitCount(cMyID, cUnitTypeTradingPost, cUnitStateAlive);
         debugMilitary("Prussia economy (pre-Citizenship): TradingPosts=" + tradingPosts +
                       " Factory=" + gPrussiaFactorySent +
                       " Food=" + kbResourceGet(cResourceFood) +
                       " Wood=" + kbResourceGet(cResourceWood) +
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

   if (kbProtoUnitAvailable(gEconUnit) == true && gPrussiaSettlerMaintain == -1)
   {
      gPrussiaSettlerMaintain = createSimpleMaintainPlan(gEconUnit, wantedSettlers, false, kbBaseGetMainID(cMyID), 1);
      aiPlanSetDesiredPriority(gPrussiaSettlerMaintain, 70);
      aiPlanSetActive(gPrussiaSettlerMaintain, true);
      debugMilitary("Prussia: Created Settler maintain plan (post-Citizenship)");
   }
   else if (gPrussiaSettlerMaintain >= 0)
   {
      aiPlanSetVariableInt(gPrussiaSettlerMaintain, cTrainPlanNumberToMaintain, 0, wantedSettlers);
   }

   debugMilitary("Prussia economy: Settlers=" + currentSettlers + "/" + wantedSettlers);
}

//==============================================================================
// prussiaCardEffectTracker
//==============================================================================
rule prussiaCardEffectTracker
inactive
minInterval 45
{
   if (gPrussiaCitizenshipSent == false)
   {
      if (kbTechGetStatus(cTechDEHCREVCitizenship) == cTechStatusActive)
      {
         gPrussiaCitizenshipSent = true;
         debugMilitary("Prussia: Citizenship card active");
      }
   }

   if (gPrussiaLandwehrSent == false)
   {
      if ((kbTechGetStatus(cTechDEHCLandwehr) == cTechStatusActive) ||
          (kbTechGetStatus(cTechDEHCShipLandwehrIcon) == cTechStatusActive))
      {
         gPrussiaLandwehrSent = true;
         debugMilitary("Prussia: Landwehr card active");
      }
   }

   if (gPrussiaChevaulegerSent == false)
   {
      if ((kbTechGetStatus(cTechDEHCGermanChevaulegers) == cTechStatusActive) ||
          (kbTechGetStatus(cTechDEHCShipChevaulegerIcon) == cTechStatusActive))
      {
         gPrussiaChevaulegerSent = true;
         debugMilitary("Prussia: Chevauleger card active");
      }
   }

   if (gPrussiaGeneralSent == false)
   {
      if (kbTechGetStatus(cTechDEHCREVPrussianGeneral) == cTechStatusActive)
      {
         gPrussiaGeneralSent = true;
         debugMilitary("Prussia: Prussian General card active");
      }
   }
}

//==============================================================================
// prussiaCardManager
//==============================================================================
rule prussiaCardManager
inactive
minInterval 90
{
   int currentMilitary = aiGetMilitaryPop();
   int landwehrCount = kbUnitCount(cMyID, cUnitTypedeLandwehr, cUnitStateAlive);
   int chevaulegerCount = kbUnitCount(cMyID, cUnitTypedeChevauleger, cUnitStateAlive);
   int settlerCount = kbUnitCount(cMyID, gEconUnit, cUnitStateAlive);

   debugMilitary("Prussia Card Manager: Landwehrs=" + landwehrCount +
                 ", Chevaulegers=" + chevaulegerCount +
                 ", Settlers=" + settlerCount +
                 ", Citizenship=" + gPrussiaCitizenshipSent +
                 ", Factory=" + gPrussiaFactorySent);
}

rule prussiaMarchRevolutionManager
inactive
minInterval 60
{
   if (kbTechGetStatus(cTechDERevolutionGermany) == cTechStatusActive)
   {
      debugMilitary("Prussia: German Confederation is active, disabling march revolution manager");
      xsDisableSelf();
      return;
   }

   if (gPrussiaMarchRevolutionPlan >= 0)
   {
      if (aiPlanGetState(gPrussiaMarchRevolutionPlan) >= 0)
      {
         return;
      }
      aiPlanDestroy(gPrussiaMarchRevolutionPlan);
      gPrussiaMarchRevolutionPlan = -1;
   }

   if (kbTechGetStatus(cTechDERevolutionGermany) != cTechStatusObtainable)
   {
      return;
   }

   if (gDefenseReflex == true)
   {
      debugMilitary("Prussia: holding off on the German Confederation, we're defending");
      return;
   }

   if (kbTechGetStatus(cTechDEHCREVCitizenship) == cTechStatusObtainable)
   {
      debugTechs("Prussia: waiting on Citizenship before revolting into the German Confederation");
      return;
   }

   int mainBaseID = kbBaseGetMainID(cMyID);
   if (mainBaseID < 0)
   {
      return;
   }

   gPrussiaMarchRevolutionPlan =
      createSimpleResearchPlan(cTechDERevolutionGermany, cUnitTypeAgeUpBuilding, cEmergencyEscrowID, 99, 95);

   if (gPrussiaMarchRevolutionPlan >= 0)
   {
      debugTechs("Prussia: Citizenship resolved - revolting into the German Confederation!");
   }
   else
   {
      debugTechs("Prussia: WARNING failed to create the German Confederation research plan");
   }
}
