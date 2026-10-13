//==============================================================================
// livestockMonitor
// Build a Livestock Pen if we don't have one, then maintain sheep!
//==============================================================================
rule livestockMonitor
inactive
minInterval 30
{
   int sheepLimit = kbGetBuildLimit(cMyID, cUnitTypeSheep);
   int cowLimit = kbGetBuildLimit(cMyID, cUnitTypeCow);
   int llamaLimit = kbGetBuildLimit(cMyID, cUnitTypeLlama);
   int goatLimit = kbGetBuildLimit(cMyID, cUnitTypeypGoat);
   int sangaCattleLimit = kbGetBuildLimit(cMyID, cUnitTypedeSangaCattle);
   int zebuCattleLimit = kbGetBuildLimit(cMyID, cUnitTypedeZebuCattle);
   int waterBuffaloLimit = kbGetBuildLimit(cMyID, cUnitTypeypWaterBuffalo);
   int time = xsGetTime();
   int age = kbGetAge();

   // African civs unlock goats through the Fulani (Hausa) / Oromo (Ethiopian)
   // allegiance techs, which Enable ypGoat but set no build limit of their own.
   // The goat shares the Sheep/AbstractCaprine limit (base 30); before the
   // allegiance is picked that shared limit can read as 0, so force it up to the
   // base caprine limit to keep the goat maintain plan alive from the start.
   if (civIsAfrican() == true)
   {
      if (goatLimit < 30)
         goatLimit = 30;
   }

   if (kbUnitCount(cMyID, gFarmUnit, cUnitStateABQ) < 2) {
      return;
   }
   
   int herdablePriority = 40;
   if (kbGetAge() < cAge3)
   {
      herdablePriority = 25;
   }

   static int sheepMaintain = -1;
   static int cowMaintain = -1;
   static int llamaMaintain = -1;
   static int goatMaintain = -1;
   static int sangaCattleMaintain = -1;
   static int zebuCattleMaintain = -1;
   static int waterBuffaloMaintain = -1;
   
   // Livestock Pen for Europeans, Village for Chinese, Shrine for Japanese, and Sacred Field for Indians...
   if (civIsNative() == false)
   {
      if (kbUnitCount(cMyID, gLivestockPenUnit, cUnitStateABQ) > 0)
      {
         // Sheep maintain plan
         if (sheepLimit > 0)
         {
            if (sheepMaintain < 0)
            {
               sheepMaintain = createSimpleMaintainPlan(cUnitTypeSheep, sheepLimit, 
                  true, kbBaseGetMainID(cMyID), 1);
               aiPlanSetVariableInt(sheepMaintain, cTrainPlanNumberToMaintain, 0, sheepLimit);
               aiPlanSetActive(sheepMaintain);
            }
            aiPlanSetDesiredPriority(sheepMaintain, herdablePriority);
         }
         
         // Cow maintain plan
         if (cowLimit > 0)
         {
            if (cowMaintain < 0)
            {
               cowMaintain = createSimpleMaintainPlan(cUnitTypeCow, cowLimit, 
                  true, kbBaseGetMainID(cMyID), 1);
               aiPlanSetVariableInt(cowMaintain, cTrainPlanNumberToMaintain, 0, cowLimit);
               aiPlanSetActive(cowMaintain);
            }
            aiPlanSetDesiredPriority(cowMaintain, herdablePriority);
         }
         
         // Llama maintain plan
         if (llamaLimit > 0)
         {
            if (llamaMaintain < 0)
            {
               llamaMaintain = createSimpleMaintainPlan(cUnitTypeLlama, llamaLimit,
                  true, kbBaseGetMainID(cMyID), 1);
               aiPlanSetVariableInt(llamaMaintain, cTrainPlanNumberToMaintain, 0, llamaLimit);
               aiPlanSetActive(llamaMaintain);
            }
            aiPlanSetDesiredPriority(llamaMaintain, herdablePriority);
         }

         // Goat maintain plan (Asian: Chinese, Indian; African: Hausa/Ethiopian via allegiance)
         if (goatLimit > 0)
         {
            if (goatMaintain < 0)
            {
               goatMaintain = createSimpleMaintainPlan(cUnitTypeypGoat, goatLimit,
                  true, kbBaseGetMainID(cMyID), 1);
               aiPlanSetVariableInt(goatMaintain, cTrainPlanNumberToMaintain, 0, goatLimit);
               aiPlanSetActive(goatMaintain);
            }
            aiPlanSetDesiredPriority(goatMaintain, herdablePriority);
         }

         // African cattle maintain plans (Hausa: Sanga, Ethiopian: Zebu)
         if (sangaCattleLimit > 0)
         {
            if (sangaCattleMaintain < 0)
            {
               sangaCattleMaintain = createSimpleMaintainPlan(cUnitTypedeSangaCattle, sangaCattleLimit,
                  true, kbBaseGetMainID(cMyID), 1);
               aiPlanSetVariableInt(sangaCattleMaintain, cTrainPlanNumberToMaintain, 0, sangaCattleLimit);
               aiPlanSetActive(sangaCattleMaintain);
            }
            aiPlanSetDesiredPriority(sangaCattleMaintain, herdablePriority);
         }

         if (zebuCattleLimit > 0)
         {
            if (zebuCattleMaintain < 0)
            {
               zebuCattleMaintain = createSimpleMaintainPlan(cUnitTypedeZebuCattle, zebuCattleLimit,
                  true, kbBaseGetMainID(cMyID), 1);
               aiPlanSetVariableInt(zebuCattleMaintain, cTrainPlanNumberToMaintain, 0, zebuCattleLimit);
               aiPlanSetActive(zebuCattleMaintain);
            }
            aiPlanSetDesiredPriority(zebuCattleMaintain, herdablePriority);
         }

         // Water buffalo maintain plan (Japan, via the livestock pen card)
         if (waterBuffaloLimit > 0)
         {
            if (waterBuffaloMaintain < 0)
            {
               waterBuffaloMaintain = createSimpleMaintainPlan(cUnitTypeypWaterBuffalo, waterBuffaloLimit,
                  true, kbBaseGetMainID(cMyID), 1);
               aiPlanSetVariableInt(waterBuffaloMaintain, cTrainPlanNumberToMaintain, 0, waterBuffaloLimit);
               aiPlanSetActive(waterBuffaloMaintain);
            }
            aiPlanSetDesiredPriority(waterBuffaloMaintain, herdablePriority);
         }
      }
      else if (kbUnitCount(cMyID, gLivestockPenUnit, cUnitStateABQ) < 1)
      {
         if ((aiPlanGetIDByTypeAndVariableType(cPlanBuild, cBuildPlanBuildingTypeID, gLivestockPenUnit) < 0) && 
             (kbUnitCount(cMyID, gLivestockPenUnit, cUnitStateABQ) < 1))
         {
            createSimpleBuildPlan(gLivestockPenUnit, 1, 45, true, cEconomyEscrowID, kbBaseGetMainID(cMyID), 1);
         }
         
         if (sheepMaintain >= 0)
         {
            aiPlanDestroy(sheepMaintain);
            sheepMaintain = -1;
         }
         if (cowMaintain >= 0)
         {
            aiPlanDestroy(cowMaintain);
            cowMaintain = -1;
         }
         if (llamaMaintain >= 0)
         {
            aiPlanDestroy(llamaMaintain);
            llamaMaintain = -1;
         }
         if (goatMaintain >= 0)
         {
            aiPlanDestroy(goatMaintain);
            goatMaintain = -1;
         }
         if (sangaCattleMaintain >= 0)
         {
            aiPlanDestroy(sangaCattleMaintain);
            sangaCattleMaintain = -1;
         }
         if (zebuCattleMaintain >= 0)
         {
            aiPlanDestroy(zebuCattleMaintain);
            zebuCattleMaintain = -1;
         }
         if (waterBuffaloMaintain >= 0)
         {
            aiPlanDestroy(waterBuffaloMaintain);
            waterBuffaloMaintain = -1;
         }
      }
   }
   else
   {
      if (kbUnitCount(cMyID, gLivestockPenUnit, cUnitStateABQ) > 0)
      {
         // Herdable maintain plan
         if (gMaxHerdablesMaintain < 0)
         {
            int herdableLimit = kbGetBuildLimit(cMyID, cUnitTypeHerdable);
            
            gMaxHerdablesMaintain = createSimpleMaintainPlan(cUnitTypeHerdable, herdableLimit, 
               true, kbBaseGetMainID(cMyID), 1);
            aiPlanSetVariableInt(gMaxHerdablesMaintain, cTrainPlanNumberToMaintain, 0, herdableLimit);
            aiPlanSetActive(gMaxHerdablesMaintain);
         }
         aiPlanSetDesiredPriority(gMaxHerdablesMaintain, herdablePriority);
      }
      else if (kbUnitCount(cMyID, gLivestockPenUnit, cUnitStateABQ) < 1)
      {
         if ((aiPlanGetIDByTypeAndVariableType(cPlanBuild, cBuildPlanBuildingTypeID, gLivestockPenUnit) < 0) &&
             (kbUnitCount(cMyID, gFarmUnit, cUnitStateABQ) >= 2))
         {
            createSimpleBuildPlan(gLivestockPenUnit, 1, 45, true, cEconomyEscrowID, kbBaseGetMainID(cMyID), 1);
         }
         
         if (gMaxHerdablesMaintain >= 0)
         {
            aiPlanDestroy(gMaxHerdablesMaintain);
            gMaxHerdablesMaintain = -1;
         }
      }
   }
}
//==============================================================================
// millManager
// Make sure we have at least one mill at all times.
//==============================================================================
rule millManager
inactive
minInterval 20
maxInterval 40
{
    if (aiPlanGetIDByTypeAndVariableType(cPlanBuild, cBuildPlanBuildingTypeID, gFarmUnit, true) >= 0)
    {
        return; // Already have an active Mill build plan.
    }

    if (queuedBuildPlanBlocks(gFarmUnit) == true)
    {
        return; // Already have one queued.
    }

    int cWantedMills = 5;
    if (civIsAfrican() == true)
    {
       // African civs use deField for both farms and plantations, so build up to
       // the deField build limit (protoy says 50) to cover the whole field economy.
       cWantedMills = kbGetBuildLimit(cMyID, cUnitTypedeField);
       if (cWantedMills < 50)
          cWantedMills = 50;
    }
    int age = kbGetAge();

    int millCount = kbUnitCount(cMyID, gFarmUnit, cUnitStateABQ);
    if ((millCount >= cWantedMills) || (age < cAge3))
    {
        return;
    }

    if ((age == cAge3) && (gTimeToFarm == false) && (xsGetTime() < 15 * 60 * 1000))
    {
        return;
    }

    int millPriority = 100;
    if (millCount >= 3)
    {
        millPriority = 70;
    }

    createSimpleBuildPlan(gFarmUnit, 1, millPriority, true, cEconomyEscrowID, kbBaseGetMainID(cMyID), 1);
}
//==============================================================================
// plantationManager
// Make sure we have at least one plantation at all times.
//==============================================================================
rule plantationManager
inactive
minInterval 20
maxInterval 40
{
    if (aiPlanGetIDByTypeAndVariableType(cPlanBuild, cBuildPlanBuildingTypeID, gPlantationUnit, true) >= 0)
    {
        return; // Already have an active Plantation build plan.
    }
    if (aiPlanGetIDByTypeAndVariableType(cPlanBuild, cBuildPlanBuildingTypeID, gPlantationUnit, false) >= 0)
    {
        return; // Already have one queued.
    }

    int cWantedPlantations = 3;
    if (civIsAfrican() == true)
    {
       // African deFields already cover plantations and are built by millManager
       // up to the full deField limit, so don't maintain a separate plantation target.
       cWantedPlantations = 0;
    }
    else if (cMyCiv == cCivDEInca)
    {
       // Inca's Plantation has no hard build limit in the game data, so "full" is
       // governed by the AI itself. Build a generous set (20) so plantations are
       // never the bottleneck for the Inca coin economy (10 gatherers each).
       cWantedPlantations = 20;
    }
    int age = kbGetAge();

    int plantationCount = kbUnitCount(cMyID, gPlantationUnit, cUnitStateABQ);
    if ((plantationCount >= cWantedPlantations) || (age < cAge3))
    {
        return;
    }

    if ((age == cAge3) && (xsGetTime() < 16 * 60 * 1000) && (gTimeForPlantations == false))
    {
        return;
    }

    int plantationPriority = 100;
    if (plantationCount >= 2)
    {
        plantationPriority = 70;
    }

    createSimpleBuildPlan(gPlantationUnit, 1, plantationPriority, true, cEconomyEscrowID,
        kbBaseGetMainID(cMyID), 1);
}
//==============================================================================
// unfinishedBuildingMonitor
//==============================================================================
rule unfinishedBuildingMonitor
active
minInterval 30
{
   const int cMaxTrackedFoundations = 20;
   const int cStallsBeforeHelping = 2;
   const int cUnfinishedBuilders = 2;

   static int queryID = -1;
   static int lastIDs = -1;
   static int lastHealth = -1;
   static int lastStalls = -1;
   static int lastCount = 0;
   static int nextIDs = -1;
   static int nextHealth = -1;
   static int nextStalls = -1;
   static int reservePlanID = -1;

   if (lastIDs < 0)
   {
      lastIDs = xsArrayCreateInt(cMaxTrackedFoundations, -1, "Unfinished buildings last pass");
      lastHealth = xsArrayCreateFloat(cMaxTrackedFoundations, 0.0, "Unfinished building health last pass");
      lastStalls = xsArrayCreateInt(cMaxTrackedFoundations, 0, "Unfinished building stalls last pass");
      nextIDs = xsArrayCreateInt(cMaxTrackedFoundations, -1, "Unfinished buildings this pass");
      nextHealth = xsArrayCreateFloat(cMaxTrackedFoundations, 0.0, "Unfinished building health this pass");
      nextStalls = xsArrayCreateInt(cMaxTrackedFoundations, 0, "Unfinished building stalls this pass");
   }

   if (queryID < 0)
   {
      queryID = kbUnitQueryCreate("unfinishedEconBuildings");
      kbUnitQuerySetPlayerID(queryID, cMyID);
      kbUnitQuerySetUnitType(queryID, cUnitTypeLogicalTypeBuildingsNotWalls);
      kbUnitQuerySetState(queryID, cUnitStateBuilding);
   }

   kbUnitQueryResetResults(queryID);
   int count = kbUnitQueryExecute(queryID);

   int nextCount = 0;
   int targetID = -1;
   int targetStalls = 0;

   for (int i = 0; i < count; i++)
   {
      if (nextCount >= cMaxTrackedFoundations)
      {
         break;
      }

      int buildingID = kbUnitQueryGetResult(queryID, i);
      float health = kbUnitGetHealth(buildingID);
      int stalls = 0;

      for (int j = 0; j < lastCount; j++)
      {
         if (xsArrayGetInt(lastIDs, j) == buildingID)
         {
            if (health <= xsArrayGetFloat(lastHealth, j))
            {
               stalls = xsArrayGetInt(lastStalls, j) + 1;
            }
            break;
         }
      }

      xsArraySetInt(nextIDs, nextCount, buildingID);
      xsArraySetFloat(nextHealth, nextCount, health);
      xsArraySetInt(nextStalls, nextCount, stalls);
      nextCount++;

      if ((stalls >= cStallsBeforeHelping) && (stalls > targetStalls))
      {
         targetStalls = stalls;
         targetID = buildingID;
      }
   }

   int swapArray = lastIDs;
   lastIDs = nextIDs;
   nextIDs = swapArray;
   swapArray = lastHealth;
   lastHealth = nextHealth;
   nextHealth = swapArray;
   swapArray = lastStalls;
   lastStalls = nextStalls;
   nextStalls = swapArray;
   lastCount = nextCount;

   if (targetID < 0)
   {
      if (reservePlanID >= 0)
      {
         aiPlanAddUnitType(reservePlanID, gEconUnit, 0, 0, 0, true, true);
      }
      return;
   }

   if (reservePlanID < 0)
   {
      reservePlanID = aiPlanCreate("Finish unfinished buildings", cPlanReserve);
      if (reservePlanID < 0)
      {
         return;
      }
      aiPlanSetDesiredPriority(reservePlanID, 95);
      aiPlanSetActive(reservePlanID);
   }

   aiPlanAddUnitType(reservePlanID, gEconUnit, cUnfinishedBuilders, cUnfinishedBuilders, cUnfinishedBuilders);

   for (int k = 0; k < cUnfinishedBuilders; k++)
   {
      int workerUnitID = aiPlanGetUnitByIndex(reservePlanID, k);
      if (workerUnitID < 0)
      {
         continue;
      }
      aiTaskUnitWork(workerUnitID, targetID);
   }

   debugEconomy("Assigning builders to finish " + kbGetProtoUnitName(kbUnitGetProtoUnitID(targetID)) +
      " (ID: " + targetID + ", stalled passes: " + targetStalls + ")");
}
//==============================================================================
// folwarkLivestockMonitor
// Poland has no Livestock Pen, its livestock come out of a Folwark switched into
// livestock mode. slaughterMonitor turns them into food once they fatten.
//==============================================================================
rule folwarkLivestockMonitor
inactive
minInterval 30
{
   if (cMyCiv != cCivDEPolish)
   {
      xsDisableSelf();
      return;
   }

   static int folwarkCowMaintain = -1;
   static int folwarkPigMaintain = -1;

   if (kbUnitCount(cMyID, cUnitTypedeFolwarkLivestock, cUnitStateABQ) >= 1)
   {
      int cowLimit = kbGetBuildLimit(cMyID, cUnitTypeCow);
      if ((cowLimit > 0) && (folwarkCowMaintain < 0))
      {
         folwarkCowMaintain = createSimpleMaintainPlan(cUnitTypeCow, cowLimit, true, kbBaseGetMainID(cMyID), 1);
         aiPlanSetVariableInt(folwarkCowMaintain, cTrainPlanNumberToMaintain, 0, cowLimit);
         aiPlanSetActive(folwarkCowMaintain);
      }

      int pigLimit = kbGetBuildLimit(cMyID, cUnitTypePig);
      if ((pigLimit > 0) && (folwarkPigMaintain < 0))
      {
         folwarkPigMaintain = createSimpleMaintainPlan(cUnitTypePig, pigLimit, true, kbBaseGetMainID(cMyID), 1);
         aiPlanSetVariableInt(folwarkPigMaintain, cTrainPlanNumberToMaintain, 0, pigLimit);
         aiPlanSetActive(folwarkPigMaintain);
      }
      return;
   }

   if (kbUnitCount(cMyID, cUnitTypedeFolwarkFarm, cUnitStateABQ) < 1)
   {
      return;
   }
   if (gDefenseReflex == true)
   {
      return;
   }
   if (aiPlanGetIDByTypeAndVariableType(cPlanResearch, cResearchPlanProtoUnitCommandID,
      cProtoUnitCommanddeFolwarkUpgradeLivestock) >= 0)
   {
      return;
   }

   int folwarkID = getUnit(cUnitTypedeFolwark, cMyID, cUnitStateAlive);
   if (folwarkID < 0)
   {
      return;
   }

   debugEconomy("Switching Folwark " + folwarkID + " into livestock mode.");
   int planID = createProtoUnitCommandResearchPlan(cProtoUnitCommanddeFolwarkUpgradeLivestock, folwarkID);
   if (planID >= 0)
   {
      aiPlanSetVariableInt(planID, cResearchPlanTransformToPUID, 0, cUnitTypedeFolwarkLivestock);
   }
}