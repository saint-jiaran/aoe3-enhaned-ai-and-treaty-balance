extern bool gGermanCitizenshipSent = false;
extern bool gGermanMarchRevolutionSent = false;

extern int gGermanLandwehrMaintain = -1;
extern int gGermanChevaulegerMaintain = -1;
extern int gGermanMusketeerMaintain = -1;

//==============================================================================
// germanConfederationRevolutionManager
//==============================================================================
rule germanConfederationRevolutionManager
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

   int totalEnemyUnits = enemyCavalryCount + enemyHeavyInfCount + enemyLightInfCount;
   int militaryPop = aiGetMilitaryPop();
   int wantedLandwehrs = 0;
   int wantedChevaulegers = 0;
   int wantedMusketeers = 0;

   if (totalEnemyUnits > 5)
   {
      if (enemyHeavyInfCount > enemyLightInfCount)
      {
         wantedLandwehrs = militaryPop * 0.45;
         wantedChevaulegers = (militaryPop * 0.25) / 2;
         wantedMusketeers = militaryPop * 0.20;
      }
      else if (enemyCavalryCount > enemyLightInfCount)
      {
         wantedLandwehrs = militaryPop * 0.35;
         wantedChevaulegers = (militaryPop * 0.20) / 2;
         wantedMusketeers = militaryPop * 0.35;
      }
      else
      {
         wantedLandwehrs = militaryPop * 0.30;
         wantedChevaulegers = (militaryPop * 0.40) / 2;
         wantedMusketeers = militaryPop * 0.20;
      }
   }
   else
   {
      wantedLandwehrs = militaryPop * 0.40;
      wantedChevaulegers = (militaryPop * 0.30) / 2;
      wantedMusketeers = militaryPop * 0.25;
   }

   int landwehrBL = kbGetBuildLimit(cMyID, cUnitTypedeLandwehr);
   int chevaulegerBL = kbGetBuildLimit(cMyID, cUnitTypedeChevauleger);
   int musketeerBL = kbGetBuildLimit(cMyID, cUnitTypeMusketeer);

   if ((landwehrBL > 0) && (wantedLandwehrs > landwehrBL))
   {
      wantedLandwehrs = landwehrBL;
   }
   if ((chevaulegerBL > 0) && (wantedChevaulegers > chevaulegerBL))
   {
      wantedChevaulegers = chevaulegerBL;
   }
   if ((musketeerBL > 0) && (wantedMusketeers > musketeerBL))
   {
      wantedMusketeers = musketeerBL;
   }

   if (wantedLandwehrs < 8)
   {
      wantedLandwehrs = 8;
   }
   if (wantedChevaulegers < 3)
   {
      wantedChevaulegers = 3;
   }
   if (wantedMusketeers < 5)
   {
      wantedMusketeers = 5;
   }

   if (kbProtoUnitAvailable(cUnitTypedeLandwehr) == true && gGermanLandwehrMaintain == -1)
   {
      gGermanLandwehrMaintain = createSimpleMaintainPlan(cUnitTypedeLandwehr, wantedLandwehrs, false, mainBaseID, 1);
      aiPlanSetDesiredPriority(gGermanLandwehrMaintain, 72);
      aiPlanSetActive(gGermanLandwehrMaintain, true);
      debugMilitary("German Confederation: Created Landwehr maintain plan");
   }
   else if (gGermanLandwehrMaintain >= 0)
   {
      aiPlanSetVariableInt(gGermanLandwehrMaintain, cTrainPlanNumberToMaintain, 0, wantedLandwehrs);
   }

   if (kbProtoUnitAvailable(cUnitTypedeChevauleger) == true && gGermanChevaulegerMaintain == -1)
   {
      gGermanChevaulegerMaintain =
         createSimpleMaintainPlan(cUnitTypedeChevauleger, wantedChevaulegers, false, mainBaseID, 1);
      aiPlanSetDesiredPriority(gGermanChevaulegerMaintain, 70);
      aiPlanSetActive(gGermanChevaulegerMaintain, true);
      debugMilitary("German Confederation: Created Chevauleger maintain plan");
   }
   else if (gGermanChevaulegerMaintain >= 0)
   {
      aiPlanSetVariableInt(gGermanChevaulegerMaintain, cTrainPlanNumberToMaintain, 0, wantedChevaulegers);
   }

   if (kbProtoUnitAvailable(cUnitTypeMusketeer) == true && gGermanMusketeerMaintain == -1)
   {
      gGermanMusketeerMaintain = createSimpleMaintainPlan(cUnitTypeMusketeer, wantedMusketeers, false, mainBaseID, 1);
      aiPlanSetDesiredPriority(gGermanMusketeerMaintain, 64);
      aiPlanSetActive(gGermanMusketeerMaintain, true);
      debugMilitary("German Confederation: Created Musketeer maintain plan");
   }
   else if (gGermanMusketeerMaintain >= 0)
   {
      aiPlanSetVariableInt(gGermanMusketeerMaintain, cTrainPlanNumberToMaintain, 0, wantedMusketeers);
   }

   debugMilitary("German Confederation army composition: Landwehrs=" + wantedLandwehrs +
                 ", Chevaulegers=" + wantedChevaulegers +
                 ", Musketeers=" + wantedMusketeers);
}

//==============================================================================
// germanConfederationEconomyManager
//==============================================================================
rule germanConfederationEconomyManager
inactive
minInterval 60
{
   if (gGermanCitizenshipSent == false)
   {
      if (kbTechGetStatus(cTechDEHCREVCitizenship) == cTechStatusActive)
      {
         gGermanCitizenshipSent = true;
         debugMilitary("German Confederation: Citizenship active - Settlers enabled and cheaper");
      }
   }

   int currentSettlers = kbUnitCount(cMyID, gEconUnit, cUnitStateAlive);
   int wantedSettlers = 40;

   if (gGermanCitizenshipSent == true)
   {
      wantedSettlers = 60;
   }

   if (gSettlerMaintainPlan >= 0)
   {
      aiPlanSetVariableInt(gSettlerMaintainPlan, cTrainPlanNumberToMaintain, 0, wantedSettlers);
   }

   debugMilitary("German Confederation economy: Settlers=" + currentSettlers + "/" + wantedSettlers +
                 ", Citizenship=" + gGermanCitizenshipSent);
}

//==============================================================================
// germanConfederationCardEffectTracker
//==============================================================================
rule germanConfederationCardEffectTracker
inactive
minInterval 45
{
   if (gGermanMarchRevolutionSent == false)
   {
      if (kbTechGetStatus(cTechDEHCMarchRevolution) == cTechStatusActive)
      {
         gGermanMarchRevolutionSent = true;
         debugMilitary("German Confederation: March Revolution card active");
      }
   }

   if (gGermanCitizenshipSent == false)
   {
      if (kbTechGetStatus(cTechDEHCREVCitizenship) == cTechStatusActive)
      {
         gGermanCitizenshipSent = true;
         debugMilitary("German Confederation: Citizenship card active");
      }
   }
}

//==============================================================================
// germanConfederationCardManager
//==============================================================================
rule germanConfederationCardManager
inactive
minInterval 90
{
   int settlerCount = kbUnitCount(cMyID, gEconUnit, cUnitStateAlive);
   int landwehrCount = kbUnitCount(cMyID, cUnitTypedeLandwehr, cUnitStateAlive);

   debugMilitary("German Confederation Card Manager: Settlers=" + settlerCount +
                 ", Landwehrs=" + landwehrCount +
                 ", Citizenship=" + gGermanCitizenshipSent);
}
