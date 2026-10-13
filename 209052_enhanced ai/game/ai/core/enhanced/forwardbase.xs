extern const int cForwardBaseRebuildDelay = 180000;

extern const int cForwardBaseMaxRebuilds = 3;

extern const float cForwardBaseRebuildReserve = 400.0;

int forwardBaseAnchorUnit(vector loc = cInvalidVector, float radius = 100.0)
{
   if (loc == cInvalidVector)
   {
      return (-1);
   }

   int fortUnitID = getUnitByLocation(cUnitTypeFortFrontier, cMyID, cUnitStateAlive, loc, radius);
   if (fortUnitID >= 0)
   {
      return (fortUnitID);
   }

   int buildingQuery = createSimpleUnitQuery(cUnitTypeMilitaryBuilding, cMyID, cUnitStateAlive, loc, radius);
   if (kbUnitQueryExecute(buildingQuery) > 0)
   {
      return (kbUnitQueryGetResult(buildingQuery, 0));
   }

   return (-1);
}

bool canAffordForwardBaseSeed(int puid = -1)
{
   if (kbResourceGet(cResourceFood) < (kbUnitCostPerResource(puid, cResourceFood) + cForwardBaseRebuildReserve))
   {
      return (false);
   }
   if (kbResourceGet(cResourceWood) < (kbUnitCostPerResource(puid, cResourceWood) + cForwardBaseRebuildReserve))
   {
      return (false);
   }
   if (kbResourceGet(cResourceGold) < (kbUnitCostPerResource(puid, cResourceGold) + cForwardBaseRebuildReserve))
   {
      return (false);
   }

   return (true);
}

void noteForwardBaseLost(void)
{
   gForwardBaseLastAbandonedLocation = gForwardBaseLocation;
   gForwardBaseLastAbandonTime = xsGetTime();

   gForwardBaseState = cForwardBaseStateNone;
   gForwardBaseID = -1;
   gForwardBaseLocation = cInvalidVector;
   gForwardBaseShouldDefend = false;

   debugBuildings("");
   debugBuildings("FORWARD BASE LOST AT " + gForwardBaseLastAbandonedLocation +
      ", REBUILD ELIGIBLE IN " + (cForwardBaseRebuildDelay / 1000) + "s");
   debugBuildings("");
}

rule enhancedForwardBaseManager
inactive
minInterval 30
{
   if (aiTreatyActive() == true)
   {
      return;
   }

   int fortUnitID = -1;
   int availableFortWagon = findWagonToBuild(cUnitTypeFortFrontier);
   vector location = cInvalidVector;

   if ((availableFortWagon >= 0) && (gForwardBaseState != cForwardBaseStateNone))
   {
      createSimpleBuildPlan(cUnitTypeFortFrontier, 1, 87, true, cMilitaryEscrowID, kbBaseGetMainID(cMyID), 1);
      return;
   }

   switch (gForwardBaseState)
   {
      case cForwardBaseStateNone:
      {
         if (availableFortWagon >= 0)
         {
            if ((btOffenseDefense >= 0.0) && (cDifficultyCurrent >= cDifficultyModerate))
            {
               location = selectForwardBaseLocation();
            }

            if (location == cInvalidVector)
            {
               createSimpleBuildPlan(cUnitTypeFortFrontier, 1, 87, true, cMilitaryEscrowID, kbBaseGetMainID(cMyID), 1);
               return;
            }

            gForwardBaseLocation = location;
            gForwardBaseBuildPlan = aiPlanCreate("Fort build plan ", cPlanBuild);
            aiPlanSetVariableInt(gForwardBaseBuildPlan, cBuildPlanBuildingTypeID, 0, cUnitTypeFortFrontier);
            aiPlanSetDesiredPriority(gForwardBaseBuildPlan, 87);
            aiPlanAddUnitType(gForwardBaseBuildPlan, cUnitTypeFortWagon, 1, 1, 1);

            aiPlanSetVariableVector(gForwardBaseBuildPlan, cBuildPlanCenterPosition, 0, location);
            aiPlanSetVariableFloat(gForwardBaseBuildPlan, cBuildPlanCenterPositionDistance, 0, 50.0);

            aiPlanSetVariableVector(gForwardBaseBuildPlan, cBuildPlanInfluencePosition, 0, location);
            aiPlanSetVariableFloat(gForwardBaseBuildPlan, cBuildPlanInfluencePositionDistance, 0, 50.0);
            aiPlanSetVariableFloat(gForwardBaseBuildPlan, cBuildPlanInfluencePositionValue, 0, 100.0);
            aiPlanSetVariableInt(gForwardBaseBuildPlan, cBuildPlanInfluencePositionFalloff, 0, cBPIFalloffLinear);

            aiPlanSetVariableInt(gForwardBaseBuildPlan, cBuildPlanInfluenceUnitTypeID, 0, cUnitTypeFortFrontier);
            aiPlanSetVariableFloat(gForwardBaseBuildPlan, cBuildPlanInfluenceUnitDistance, 0, 50.0);
            aiPlanSetVariableFloat(gForwardBaseBuildPlan, cBuildPlanInfluenceUnitValue, 0, -200.0);
            aiPlanSetVariableInt(gForwardBaseBuildPlan, cBuildPlanInfluenceUnitFalloff, 0, cBPIFalloffNone);

            aiPlanSetActive(gForwardBaseBuildPlan);

            sendStatement(cPlayerRelationAllyExcludingSelf, cAICommPromptToAllyIWillBuildMilitaryBase, gForwardBaseLocation);

            gForwardBaseState = cForwardBaseStateBuilding;

            debugBuildings("");
            debugBuildings("BUILDING FORWARD BASE, MOVING DEFEND PLANS TO COVER");
            debugBuildings("PLANNED LOCATION IS " + gForwardBaseLocation);
            debugBuildings("");

            if (gDefenseReflex == false)
            {
               endDefenseReflex();
            }
            break;
         }

         if (gForwardBaseLastAbandonTime < 0)
         {
            break;
         }

         if (gForwardBaseRebuildCount >= cForwardBaseMaxRebuilds)
         {
            break;
         }

         if ((xsGetTime() - gForwardBaseLastAbandonTime) < cForwardBaseRebuildDelay)
         {
            break;
         }

         if (aiPlanGetState(gForwardBaseRebuildPlan) >= 0)
         {
            break;
         }

         if ((btOffenseDefense < 0.0) || (cDifficultyCurrent < cDifficultyModerate))
         {
            break;
         }

         if (canAffordForwardBaseSeed(cUnitTypeBarracks) == false)
         {
            break;
         }

         location = selectForwardBaseLocation();
         if (location == cInvalidVector)
         {
            break;
         }

         gForwardBaseRebuildPlan = createSpacedLocationBuildPlan(
            cUnitTypeBarracks, 1, 87, true, cMilitaryEscrowID, location, 2);

         if (gForwardBaseRebuildPlan < 0)
         {
            break;
         }

         gForwardBaseLocation = location;
         gForwardBaseBuildPlan = gForwardBaseRebuildPlan;
         gForwardBaseRebuildCount++;
         gForwardBaseState = cForwardBaseStateBuilding;

         sendStatement(cPlayerRelationAllyExcludingSelf, cAICommPromptToAllyIWillBuildMilitaryBase, gForwardBaseLocation);

         debugBuildings("");
         debugBuildings("REBUILDING FORWARD BASE WITH A BARRACKS AT " + gForwardBaseLocation +
            " (attempt " + gForwardBaseRebuildCount + " of " + cForwardBaseMaxRebuilds + ")");
         debugBuildings("");

         if (gDefenseReflex == false)
         {
            endDefenseReflex();
         }
         break;
      }
      case cForwardBaseStateBuilding:
      {
         fortUnitID = forwardBaseAnchorUnit(gForwardBaseLocation, 100.0);

         if (fortUnitID >= 0)
         {
            if (kbUnitGetBaseID(fortUnitID) >= 0)
            {
               gForwardBaseState = cForwardBaseStateActive;
               gForwardBaseID = kbUnitGetBaseID(fortUnitID);
               gForwardBaseLocation = kbUnitGetPosition(fortUnitID);
               gForwardBaseUpTime = xsGetTime();
               gForwardBaseShouldDefend = kbUnitIsType(fortUnitID, cUnitTypeFortFrontier);
               gForwardBaseRebuildPlan = -1;
               debugBuildings("Forward base location is " + gForwardBaseLocation + ", Base ID is " +
                  gForwardBaseID + ", Unit ID is " + fortUnitID);
               debugBuildings("");
               debugBuildings("FORWARD BASE COMPLETED, GOING TO STATE ACTIVE");
               debugBuildings("");
            }
            else
            {
               debugBuildings("");
               debugBuildings("FORT COMPLETE, WAITING FOR FORWARD BASE ID");
               debugBuildings("");
            }
         }
         else
         {
            if (aiPlanGetState(gForwardBaseBuildPlan) < 0)
            {
               gForwardBaseState = cForwardBaseStateNone;
               gForwardBaseLocation = cInvalidVector;
               gForwardBaseID = -1;
               gForwardBaseBuildPlan = -1;
               gForwardBaseRebuildPlan = -1;
               gForwardBaseShouldDefend = false;
               debugBuildings("");
               debugBuildings("FORWARD BASE PLAN FAILED, RETURNING TO STATE NONE");
               debugBuildings("");
            }
         }
         break;
      }
      case cForwardBaseStateActive:
      {
         fortUnitID = forwardBaseAnchorUnit(gForwardBaseLocation, 50.0);
         if (fortUnitID < 0)
         {
            fortUnitID = forwardBaseAnchorUnit(gForwardBaseLocation, 100.0);
         }

         if (fortUnitID < 0)
         {
            if (((gDefenseReflexBaseID == gForwardBaseID) && (gDefenseReflexPaused == true)) ||
               (kbBaseGetNumberUnits(cMyID, gForwardBaseID, cPlayerRelationSelf, cUnitTypeBuilding) < 1))
            {
               noteForwardBaseLost();
               endDefenseReflex();
               debugBuildings("");
               debugBuildings("ABANDONING FORWARD BASE, RETREATING TO MAIN BASE");
               debugBuildings("");
            }
         }
         break;
      }
   }
}
