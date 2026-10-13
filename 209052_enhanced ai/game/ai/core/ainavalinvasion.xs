vector findIslandBuildings(vector originPoint = cInvalidVector) {

   int buildingQueryId = createSimpleUnitQuery(cUnitTypeBuilding, cPlayerRelationEnemyNotGaia, cUnitStateAlive);
   int numberFound = kbUnitQueryExecute(buildingQueryId);
   int originPointGroupId = kbAreaGroupGetIDByPosition(originPoint);
   vector unitLocation = cInvalidVector;
   int unitLocationId = -1;
   int unitLocationGroupId = -1;
   int unitID = -1;

   for (i = 0; < numberFound) {
      unitID = kbUnitQueryGetResult(buildingQueryId, i);
      unitLocation = kbUnitGetPosition(unitID);
      unitLocationId = kbAreaGetIDByPosition(unitLocation);
      unitLocationGroupId = kbAreaGroupGetIDByPosition(unitLocation);
      if (kbAreAreaGroupsPassableByLand(originPointGroupId, unitLocationGroupId) == true) {
         return unitLocation;
      }
   }
   
   return cInvalidVector;
}
//==============================================================================
// assignCoastalUnitsToAssault
//==============================================================================
void assignCoastalUnitsToAssault()
{
   if (gNavalInvasionCoastalPoint == cInvalidVector) {
      return;
   }
   
   int targetPlan = -1;
   if (gIslandAssaultPlanID >= 0 && aiPlanGetActive(gIslandAssaultPlanID)) {
      targetPlan = gIslandAssaultPlanID;
   } else if (gIslandSearchPlanID >= 0 && aiPlanGetActive(gIslandSearchPlanID)) {
      targetPlan = gIslandSearchPlanID;
   }
   
   if (targetPlan < 0) {
      return;
   }
   
   int unitQueryID = createSimpleUnitQuery(cUnitTypeLogicalTypeLandMilitary, cMyID, cUnitStateAlive, 
      gNavalInvasionCoastalPoint, 50.0);
   int numberFound = kbUnitQueryExecute(unitQueryID);
   
   int unitsAssigned = 0;
   
   for (i = 0; < numberFound)
   {
      int unitID = kbUnitQueryGetResult(unitQueryID, i);
      
      if (kbUnitIsType(unitID, cUnitTypeHero) == true) {
         continue;
      }
      
      int currentPlan = kbUnitGetPlanID(unitID);
      
      if (currentPlan == targetPlan) {
         continue;
      }
      
      bool shouldAssign = false;
      if (currentPlan < 0) {
         shouldAssign = true;
      } else if (aiPlanGetActive(currentPlan) == false) {
         shouldAssign = true;
      } else if (aiPlanGetDesiredPriority(currentPlan) < 80) {
         shouldAssign = true;
      }
      
      if (shouldAssign) {
         if (currentPlan >= 0) {
            aiPlanRemoveUnit(currentPlan, unitID);
         }
         if (aiPlanAddUnit(targetPlan, unitID) == true) {
            unitsAssigned++;
         }
      }
   }
   
   if (unitsAssigned > 0) {
      aiEcho("Assigned " + unitsAssigned + " coastal units to invasion plan");
   }
}
//==============================================================================
// createInvasionTransportPlan
//==============================================================================
int createInvasionTransportPlan(vector gatherPoint = cInvalidVector, vector targetPoint = cInvalidVector,
                        int pri = 100, bool returnWhenDone = false)
{
   int shipQueryID = createSimpleUnitQuery(cUnitTypeAbstractWarShip, cMyID, cUnitStateAlive);
   int unitQueryID = -1;
   vector unitLocation = cInvalidVector;
   int unitLocationId = -1;
   int unitLocationGroupId = -1;
   int unitID = -1;
   int numberFound = kbUnitQueryExecute(shipQueryID);
   int gatherPointId = kbAreaGetIDByPosition(gatherPoint);
   int gatherPointGroupId = kbAreaGroupGetIDByPosition(gatherPoint);
   int shipID = -1;
   float shipHitpoints = 0.0;
   int unitPlanID = -1;
   int transportID = -1;
   float transportHitpoints = 0.0;

   for (i = 0; < numberFound)
   {
      shipID = kbUnitQueryGetResult(shipQueryID, i);
      if (shipIsOnAllyAssist(shipID) == true) {
         continue;
      }
      unitPlanID = kbUnitGetPlanID(shipID);
      if ((unitPlanID >= 0) && ((aiPlanGetDesiredPriority(unitPlanID) > pri) || (aiPlanGetType(unitPlanID) == cPlanTransport)) ||
         kbUnitGetProtoUnitID(shipID) == cUnitTypedeMercBattleship)
      {
         continue;
      }
      shipHitpoints = kbUnitGetCurrentHitpoints(shipID);
      if (shipHitpoints > transportHitpoints)
      {
         transportID = shipID;
         transportHitpoints = shipHitpoints;
      }
   }

   if (transportID < 0)
   {
      return (-1);
   }

   vector adjustedGatherPoint = gatherPoint;
   vector baseLocation = kbBaseGetLocation(cMyID, kbBaseGetMainID(cMyID));
   float minDockDistance = 25.0;
   
   int dockQueryID = createSimpleUnitQuery(cUnitTypeAbstractDock, cPlayerRelationAny, cUnitStateABQ, gatherPoint, minDockDistance);
   int numDocks = kbUnitQueryExecute(dockQueryID);
   
   if (numDocks > 0) {
      aiEcho("Gather point too close to dock, searching for alternative...");
      
      bool foundValidPoint = false;
      vector directionToTarget = cInvalidVector;
      vector perpendicular = cInvalidVector;
      float offsetDistance = 0.0;
      vector offsetBase = cInvalidVector;
      vector testCoastalPoint = cInvalidVector;
      vector offsetTarget = cInvalidVector;
      int testDockQuery = -1;
      int testNumDocks = 0;
      int testGroupId = -1;
      
      for (j = 1; <= 20)
      {
         directionToTarget = xsVectorNormalize(targetPoint - baseLocation);
         perpendicular = xsVectorSet(xsVectorGetZ(directionToTarget), 0.0, 0.0 - xsVectorGetX(directionToTarget));
         
         offsetDistance = ((j + 1) / 2) * 15.0;
         if (j % 2 == 0) {
            offsetDistance = 0.0 - offsetDistance;
         }
         
         offsetBase = baseLocation + (perpendicular * offsetDistance);
         testCoastalPoint = coastalEdgeVector(offsetBase, targetPoint);
         
         if (testCoastalPoint == cInvalidVector) {
            continue;
         }
         
         testDockQuery = createSimpleUnitQuery(cUnitTypeAbstractDock, cPlayerRelationAny, cUnitStateABQ, testCoastalPoint, minDockDistance);
         testNumDocks = kbUnitQueryExecute(testDockQuery);
         
         if (testNumDocks == 0) {
            testGroupId = kbAreaGroupGetIDByPosition(testCoastalPoint);
            if (kbAreAreaGroupsPassableByLand(gatherPointGroupId, testGroupId) == true) {
               adjustedGatherPoint = testCoastalPoint;
               foundValidPoint = true;
               aiEcho("Found dock-free gather point at offset " + offsetDistance);
               break;
            }
         }
      }
      
      if (foundValidPoint == false) {
         for (j = 1; <= 10)
         {
            directionToTarget = xsVectorNormalize(targetPoint - baseLocation);
            perpendicular = xsVectorSet(xsVectorGetZ(directionToTarget), 0.0, 0.0 - xsVectorGetX(directionToTarget));
            
            offsetDistance = j * 20.0;
            
            offsetTarget = targetPoint + (perpendicular * offsetDistance);
            testCoastalPoint = coastalEdgeVector(baseLocation, offsetTarget);
            
            if (testCoastalPoint != cInvalidVector) {
               testDockQuery = createSimpleUnitQuery(cUnitTypeAbstractDock, cPlayerRelationAny, cUnitStateABQ, testCoastalPoint, minDockDistance);
               testNumDocks = kbUnitQueryExecute(testDockQuery);
               
               if (testNumDocks == 0) {
                  testGroupId = kbAreaGroupGetIDByPosition(testCoastalPoint);
                  if (kbAreAreaGroupsPassableByLand(gatherPointGroupId, testGroupId) == true) {
                     adjustedGatherPoint = testCoastalPoint;
                     foundValidPoint = true;
                     aiEcho("Found dock-free gather point along coast (positive)");
                     break;
                  }
               }
            }
            
            offsetTarget = targetPoint + (perpendicular * (0.0 - offsetDistance));
            testCoastalPoint = coastalEdgeVector(baseLocation, offsetTarget);
            
            if (testCoastalPoint != cInvalidVector) {
               testDockQuery = createSimpleUnitQuery(cUnitTypeAbstractDock, cPlayerRelationAny, cUnitStateABQ, testCoastalPoint, minDockDistance);
               testNumDocks = kbUnitQueryExecute(testDockQuery);
               
               if (testNumDocks == 0) {
                  testGroupId = kbAreaGroupGetIDByPosition(testCoastalPoint);
                  if (kbAreAreaGroupsPassableByLand(gatherPointGroupId, testGroupId) == true) {
                     adjustedGatherPoint = testCoastalPoint;
                     foundValidPoint = true;
                     aiEcho("Found dock-free gather point along coast (negative)");
                     break;
                  }
               }
            }
         }
      }
      
      if (foundValidPoint == false) {
         aiEcho("Warning: Could not find dock-free gather point, using original");
      }
   }

   int planID = aiPlanCreate(kbGetUnitTypeName(kbUnitGetProtoUnitID(transportID)) + " Invasion Transport Plan", cPlanTransport);

   if (planID < 0)
   {
      return (-1);
   }

   aiPlanSetVariableInt(planID, cTransportPlanTransportID, 0, transportID);
   aiPlanSetVariableInt(planID, cTransportPlanTransportTypeID, 0, kbUnitGetProtoUnitID(transportID));
   aiPlanAddUnitType(planID, kbUnitGetProtoUnitID(transportID), 1, 1, 1);
   if (aiPlanAddUnit(planID, transportID) == false)
   {
      aiPlanDestroy(planID);
      return (-1);
   }

   aiPlanSetVariableVector(planID, cTransportPlanGatherPoint, 0, adjustedGatherPoint);
   aiPlanSetVariableVector(planID, cTransportPlanTargetPoint, 0, targetPoint);
   aiPlanSetVariableBool(planID, cTransportPlanReturnWhenDone, 0, returnWhenDone);
   aiPlanSetVariableBool(planID, cTransportPlanPersistent, 0, false);
   aiPlanSetVariableBool(planID, cTransportPlanMaximizeXportMovement, 0, true);
   aiPlanSetVariableBool(planID, cTransportPlanTakeMoreUnits, 0, true);
   aiPlanSetAttack(planID, true);
   aiPlanSetRequiresAllNeedUnits(planID, true);
   aiPlanSetVariableInt(planID, cTransportPlanPathType, 0, cTransportPathTypePoints);
   aiPlanSetDesiredPriority(planID, pri);

   return (planID);
}
//==============================================================================
// createIslandAssaultPlan
//==============================================================================
void createIslandAssaultPlan(vector gatherPoint = cInvalidVector, vector targetPoint = cInvalidVector)
{
   if (gIslandAssaultPlanID >= 0) {
      aiPlanDestroy(gIslandAssaultPlanID);
      gIslandAssaultPlanID = -1;
   }
   
   if (gatherPoint == cInvalidVector) {
      gatherPoint = gNavalInvasionCoastalPoint;
   }
   if (targetPoint == cInvalidVector) {
      targetPoint = gIslandCenterPoint;
   }
   if (targetPoint == cInvalidVector) {
      aiEcho("createIslandAssaultPlan: No valid target point!");
      return;
   }
   
   vector islandAnchor = gIslandCenterPoint;
   if (islandAnchor == cInvalidVector) {
      islandAnchor = gProbableEnemyIsland;
   }
   if (islandAnchor == cInvalidVector) {
      islandAnchor = targetPoint;
   }
   int islandGroupId = kbAreaGroupGetIDByPosition(islandAnchor);
   int homeGroupId = kbAreaGroupGetIDByPosition(kbBaseGetLocation(cMyID, kbBaseGetMainID(cMyID)));
   
   gIslandAssaultPlanID = aiPlanCreate("Island Assault Plan", cPlanCombat);
   
   if (gIslandAssaultPlanID < 0) {
      aiEcho("Failed to create assault plan!");
      return;
   }

   aiPlanAddUnitType(gIslandAssaultPlanID, cUnitTypeLogicalTypeLandMilitary, 1, 200, 200);
   
   int unitQueryID = createSimpleUnitQuery(cUnitTypeLogicalTypeLandMilitary, cMyID, cUnitStateAlive);
   int numberFound = kbUnitQueryExecute(unitQueryID);
   int numberInPlan = 0;
   float landedX = 0.0;
   float landedZ = 0.0;
   
   for (i = 0; < numberFound)
   {
      int unitID = kbUnitQueryGetResult(unitQueryID, i);
      vector unitLocation = kbUnitGetPosition(unitID);
      int unitLocationGroupId = kbAreaGroupGetIDByPosition(unitLocation);
      
      if (kbUnitIsType(unitID, cUnitTypeHero) == true) {
         continue;
      }
      
      bool onIsland = kbAreAreaGroupsPassableByLand(islandGroupId, unitLocationGroupId);
      if (onIsland == false && homeGroupId >= 0) {
         if (kbAreAreaGroupsPassableByLand(homeGroupId, unitLocationGroupId) == false &&
            distance(unitLocation, islandAnchor) < cIslandUnitScanRadius) {
            onIsland = true;
         }
      }
      
      if (onIsland == true) {
         int existingPlan = kbUnitGetPlanID(unitID);
         if (existingPlan >= 0 && existingPlan != gIslandAssaultPlanID) {
            aiPlanRemoveUnit(existingPlan, unitID);
         }
         if (aiPlanAddUnit(gIslandAssaultPlanID, unitID) == true) {
            landedX = landedX + xsVectorGetX(unitLocation);
            landedZ = landedZ + xsVectorGetZ(unitLocation);
            numberInPlan = numberInPlan + 1;
         }
      }
   }
   
   if (numberInPlan > 0) {
      gatherPoint = xsVectorSet(landedX / numberInPlan, 0.0, landedZ / numberInPlan);
   } else {
      gatherPoint = targetPoint;
   }

   aiPlanSetVariableInt(gIslandAssaultPlanID, cCombatPlanCombatType, 0, cCombatPlanCombatTypeAttack);
   aiPlanSetVariableInt(gIslandAssaultPlanID, cCombatPlanTargetMode, 0, cCombatPlanTargetModePoint);
   aiPlanSetVariableVector(gIslandAssaultPlanID, cCombatPlanTargetPoint, 0, targetPoint);
   aiPlanSetVariableVector(gIslandAssaultPlanID, cCombatPlanGatherPoint, 0, gatherPoint);
   aiPlanSetVariableFloat(gIslandAssaultPlanID, cCombatPlanGatherDistance, 0, 800.0);
   aiPlanSetVariableInt(gIslandAssaultPlanID, cCombatPlanAttackRoutePattern, 0, cCombatPlanAttackRoutePatternBest);
   aiPlanSetVariableBool(gIslandAssaultPlanID, cCombatPlanAllowMoreUnitsDuringAttack, 0, true);
   aiPlanSetVariableInt(gIslandAssaultPlanID, cCombatPlanRefreshFrequency, 0, 5);
   aiPlanSetVariableInt(gIslandAssaultPlanID, cCombatPlanDoneMode, 0, cCombatPlanDoneModeNoTarget);
   aiPlanSetVariableInt(gIslandAssaultPlanID, cCombatPlanRetreatMode, 0, cCombatPlanRetreatModeNone);
   aiPlanSetVariableInt(gIslandAssaultPlanID, cCombatPlanNoTargetTimeout, 0, 60000);
   aiPlanSetInitialPosition(gIslandAssaultPlanID, gatherPoint);
   aiPlanSetDesiredPriority(gIslandAssaultPlanID, 100);
   aiPlanSetNoMoreUnits(gIslandAssaultPlanID, false);
   aiPlanSetRequiresAllNeedUnits(gIslandAssaultPlanID, false);
   aiPlanSetActive(gIslandAssaultPlanID, true);
   
   gAssaultPlanTime = xsGetTime();
   aiEcho("Assault plan created with " + numberInPlan + " units, target: " + targetPoint);

   // Enhanced - Coordinated attacks
   coordAttackBroadcast(-1, -1, targetPoint);
}

//==============================================================================
// createIslandSearchPlan - NEW SIMPLIFIED FUNCTION
//==============================================================================
void createIslandSearchPlan(vector gatherPoint = cInvalidVector, vector targetPoint = cInvalidVector)
{
   if (gIslandSearchPlanID >= 0) {
      aiPlanDestroy(gIslandSearchPlanID);
      gIslandSearchPlanID = -1;
   }
   
   if (gatherPoint == cInvalidVector) {
      gatherPoint = gNavalInvasionCoastalPoint;
   }
   if (targetPoint == cInvalidVector) {
      targetPoint = gIslandCenterPoint;
   }
   if (targetPoint == cInvalidVector) {
      targetPoint = gProbableEnemyIsland;
   }
   if (targetPoint == cInvalidVector) {
      aiEcho("createIslandSearchPlan: No valid target point!");
      return;
   }
   
   vector islandAnchor = gIslandCenterPoint;
   if (islandAnchor == cInvalidVector) {
      islandAnchor = gProbableEnemyIsland;
   }
   if (islandAnchor == cInvalidVector) {
      islandAnchor = targetPoint;
   }
   int islandGroupId = kbAreaGroupGetIDByPosition(islandAnchor);
   int homeGroupId = kbAreaGroupGetIDByPosition(kbBaseGetLocation(cMyID, kbBaseGetMainID(cMyID)));
   int gatherPointGroupId = kbAreaGroupGetIDByPosition(gatherPoint);
   
   gIslandSearchPlanID = aiPlanCreate("Island Search Plan", cPlanCombat);
   
   if (gIslandSearchPlanID < 0) {
      aiEcho("Failed to create search plan!");
      return;
   }

   aiPlanAddUnitType(gIslandSearchPlanID, cUnitTypeLogicalTypeLandMilitary, 1, 200, 200);
   
   int unitQueryID = createSimpleUnitQuery(cUnitTypeLogicalTypeLandMilitary, cMyID, cUnitStateAlive);
   int numberFound = kbUnitQueryExecute(unitQueryID);
   int numberInPlan = 0;
   float searchX = 0.0;
   float searchZ = 0.0;
   
   for (i = 0; < numberFound)
   {
      int unitID = kbUnitQueryGetResult(unitQueryID, i);
      vector unitLocation = kbUnitGetPosition(unitID);
      int unitLocationGroupId = kbAreaGroupGetIDByPosition(unitLocation);
      
      if (kbUnitIsType(unitID, cUnitTypeHero) == true) {
         continue;
      }
      
      bool onIsland = kbAreAreaGroupsPassableByLand(islandGroupId, unitLocationGroupId);
      if (onIsland == false && homeGroupId >= 0) {
         if (kbAreAreaGroupsPassableByLand(homeGroupId, unitLocationGroupId) == false &&
            distance(unitLocation, islandAnchor) < cIslandUnitScanRadius) {
            onIsland = true;
         }
      }
      
      if (onIsland == true) {
         int existingPlan = kbUnitGetPlanID(unitID);
         if (existingPlan >= 0 && existingPlan != gIslandSearchPlanID) {
            aiPlanRemoveUnit(existingPlan, unitID);
         }
         if (aiPlanAddUnit(gIslandSearchPlanID, unitID) == true) {
            searchX = searchX + xsVectorGetX(unitLocation);
            searchZ = searchZ + xsVectorGetZ(unitLocation);
            numberInPlan = numberInPlan + 1;
         }
      }
   }

   aiPlanSetVariableInt(gIslandSearchPlanID, cCombatPlanCombatType, 0, cCombatPlanCombatTypeAttack);
   aiPlanSetVariableInt(gIslandSearchPlanID, cCombatPlanTargetMode, 0, cCombatPlanTargetModePoint);
   aiPlanSetVariableVector(gIslandSearchPlanID, cCombatPlanTargetPoint, 0, targetPoint);
   if (numberInPlan > 0) {
      gatherPoint = xsVectorSet(searchX / numberInPlan, 0.0, searchZ / numberInPlan);
   } else {
      gatherPoint = targetPoint;
   }
   aiPlanSetVariableVector(gIslandSearchPlanID, cCombatPlanGatherPoint, 0, gatherPoint);
   aiPlanSetVariableFloat(gIslandSearchPlanID, cCombatPlanGatherDistance, 0, 800.0);
   aiPlanSetVariableInt(gIslandSearchPlanID, cCombatPlanAttackRoutePattern, 0, cCombatPlanAttackRoutePatternRandom);
   aiPlanSetVariableBool(gIslandSearchPlanID, cCombatPlanAllowMoreUnitsDuringAttack, 0, true);
   aiPlanSetVariableInt(gIslandSearchPlanID, cCombatPlanRefreshFrequency, 0, 5);
   aiPlanSetVariableInt(gIslandSearchPlanID, cCombatPlanDoneMode, 0, cCombatPlanDoneModeNoTarget);
   aiPlanSetVariableInt(gIslandSearchPlanID, cCombatPlanRetreatMode, 0, cCombatPlanRetreatModeNone);
   aiPlanSetVariableInt(gIslandSearchPlanID, cCombatPlanNoTargetTimeout, 0, 180000);
   aiPlanSetInitialPosition(gIslandSearchPlanID, gatherPoint);
   aiPlanSetDesiredPriority(gIslandSearchPlanID, 100);
   aiPlanSetNoMoreUnits(gIslandSearchPlanID, false);
   aiPlanSetRequiresAllNeedUnits(gIslandSearchPlanID, false);
   aiPlanSetActive(gIslandSearchPlanID, true);
   
   gSearchPlanTime = xsGetTime();
   aiEcho("Search plan created with " + numberInPlan + " units, targeting island center");
}

//==============================================================================
// createIslandCornerSweepPlan
// Creates a plan to systematically check the four corners of an island
// Call this when assault/search plans complete without finding enemies
//==============================================================================
void createIslandCornerSweepPlan(vector islandCenter = cInvalidVector)
{
   // Destroy any existing sweep plan
   if (gIslandCornerSweepPlanID >= 0) {
      aiPlanDestroy(gIslandCornerSweepPlanID);
      gIslandCornerSweepPlanID = -1;
   }
   
   if (islandCenter == cInvalidVector) {
      islandCenter = gIslandCenterPoint;
   }
   if (islandCenter == cInvalidVector) {
      islandCenter = gProbableEnemyIsland;
   }
   if (islandCenter == cInvalidVector) {
      aiEcho("createIslandCornerSweepPlan: No valid island center!");
      return;
   }
   
   int islandGroupId = kbAreaGroupGetIDByPosition(islandCenter);
   if (islandGroupId < 0) {
      return;
   }
   
   // Calculate the bounding box of the island by sampling points
   // Start with the center and expand outward!
   float minX = xsVectorGetX(islandCenter);
   float maxX = xsVectorGetX(islandCenter);
   float minZ = xsVectorGetZ(islandCenter);
   float maxZ = xsVectorGetZ(islandCenter);
   
   // Sample points in a grid pattern to find island boundaries
   float sampleDistance = 20.0;
   float maxSearchDist = 300.0;
   vector testPoint = cInvalidVector;
   int testGroupId = -1;
   
   // Search in each cardinal direction to find boundaries
   // Search positive X!
   for (i = 1; <= 30)
   {
      testPoint = xsVectorSet(xsVectorGetX(islandCenter) + (i * sampleDistance), 0.0, xsVectorGetZ(islandCenter));
      testGroupId = kbAreaGroupGetIDByPosition(testPoint);
      if (kbAreAreaGroupsPassableByLand(islandGroupId, testGroupId) == true) {
         maxX = xsVectorGetX(testPoint);
      } else {
         break;
      }
   }
   
   // Search negative X
   for (i = 1; <= 30)
   {
      testPoint = xsVectorSet(xsVectorGetX(islandCenter) - (i * sampleDistance), 0.0, xsVectorGetZ(islandCenter));
      testGroupId = kbAreaGroupGetIDByPosition(testPoint);
      if (kbAreAreaGroupsPassableByLand(islandGroupId, testGroupId) == true) {
         minX = xsVectorGetX(testPoint);
      } else {
         break;
      }
   }
   
   // Search positive Z
   for (i = 1; <= 30)
   {
      testPoint = xsVectorSet(xsVectorGetX(islandCenter), 0.0, xsVectorGetZ(islandCenter) + (i * sampleDistance));
      testGroupId = kbAreaGroupGetIDByPosition(testPoint);
      if (kbAreAreaGroupsPassableByLand(islandGroupId, testGroupId) == true) {
         maxZ = xsVectorGetZ(testPoint);
      } else {
         break;
      }
   }
   
   // Search negative Z
   for (i = 1; <= 30)
   {
      testPoint = xsVectorSet(xsVectorGetX(islandCenter), 0.0, xsVectorGetZ(islandCenter) - (i * sampleDistance));
      testGroupId = kbAreaGroupGetIDByPosition(testPoint);
      if (kbAreAreaGroupsPassableByLand(islandGroupId, testGroupId) == true) {
         minZ = xsVectorGetZ(testPoint);
      } else {
         break;
      }
   }
   
   // Add some padding inward so corners are actually on land
   float padding = 30.0;
   minX = minX + padding;
   maxX = maxX - padding;
   minZ = minZ + padding;
   maxZ = maxZ - padding;
   
   // Define the four corners
   vector corner1 = xsVectorSet(minX, 0.0, minZ);  // SW
   vector corner2 = xsVectorSet(maxX, 0.0, minZ);  // SE
   vector corner3 = xsVectorSet(maxX, 0.0, maxZ);  // NE
   vector corner4 = xsVectorSet(minX, 0.0, maxZ);  // NW
   
   if (gIslandSweepPoints < 0) {
      gIslandSweepPoints = xsArrayCreateVector(cMaxIslandSweepPoints, cInvalidVector, "Island Sweep Points");
   }
   gIslandSweepPointCount = 0;

   for (int cornerIndex = 0; cornerIndex < 4; cornerIndex++)
   {
      vector candidate = corner1;
      if (cornerIndex == 1) { candidate = corner2; }
      if (cornerIndex == 2) { candidate = corner3; }
      if (cornerIndex == 3) { candidate = corner4; }

      testGroupId = kbAreaGroupGetIDByPosition(candidate);
      if (kbAreAreaGroupsPassableByLand(islandGroupId, testGroupId) == true) {
         xsArraySetVector(gIslandSweepPoints, gIslandSweepPointCount, candidate);
         gIslandSweepPointCount++;
      }
   }

   testGroupId = kbAreaGroupGetIDByPosition(islandCenter);
   if (kbAreAreaGroupsPassableByLand(islandGroupId, testGroupId) == true &&
      gIslandSweepPointCount < cMaxIslandSweepPoints) {
      xsArraySetVector(gIslandSweepPoints, gIslandSweepPointCount, islandCenter);
      gIslandSweepPointCount++;
   }

   int randomPlaced = 0;
   for (int tryIndex = 0; tryIndex < 20; tryIndex++)
   {
      if (randomPlaced >= cIslandSweepRandomPoints ||
         gIslandSweepPointCount >= cMaxIslandSweepPoints) {
         break;
      }

      vector randomPoint = xsVectorSet(aiRandFloat(minX, maxX), 0.0, aiRandFloat(minZ, maxZ));
      testGroupId = kbAreaGroupGetIDByPosition(randomPoint);
      if (kbAreAreaGroupsPassableByLand(islandGroupId, testGroupId) == true) {
         xsArraySetVector(gIslandSweepPoints, gIslandSweepPointCount, randomPoint);
         gIslandSweepPointCount++;
         randomPlaced++;
      }
   }

   if (gIslandSweepPointCount < 1) {
      aiEcho("createIslandCornerSweepPlan: No valid sweep points found on island!");
      return;
   }
   
   gCurrentSweepCorner = 0;
   
   // Create combat plan targeting first corner
   gIslandCornerSweepPlanID = aiPlanCreate("Island Corner Sweep Plan", cPlanCombat);
   
   if (gIslandCornerSweepPlanID < 0) {
      aiEcho("Failed to create corner sweep plan!");
      return;
   }

   aiPlanAddUnitType(gIslandCornerSweepPlanID, cUnitTypeLogicalTypeLandMilitary, 1, 200, 200);
   
   // Find and add units on the island
   int unitQueryID = createSimpleUnitQuery(cUnitTypeLogicalTypeLandMilitary, cMyID, cUnitStateAlive);
   int numberFound = kbUnitQueryExecute(unitQueryID);
   int numberInPlan = 0;
   
   for (i = 0; < numberFound)
   {
      int unitID = kbUnitQueryGetResult(unitQueryID, i);
      vector unitLocation = kbUnitGetPosition(unitID);
      int unitLocationGroupId = kbAreaGroupGetIDByPosition(unitLocation);
      
      if (kbUnitIsType(unitID, cUnitTypeHero) == true) {
         continue;
      }
      
      if (kbAreAreaGroupsPassableByLand(islandGroupId, unitLocationGroupId) == true) {
         // Remove from existing plan first
         int existingPlan = kbUnitGetPlanID(unitID);
         if (existingPlan >= 0 && existingPlan != gIslandCornerSweepPlanID) {
            aiPlanRemoveUnit(existingPlan, unitID);
         }
         if (aiPlanAddUnit(gIslandCornerSweepPlanID, unitID) == true) {
            numberInPlan++;
         }
      }
   }
   
   if (numberInPlan < 2) {
      aiEcho("Not enough units for corner sweep, aborting");
      aiPlanDestroy(gIslandCornerSweepPlanID);
      gIslandCornerSweepPlanID = -1;
      return;
   }
   
   // Configure to move to first corner
   aiPlanSetVariableInt(gIslandCornerSweepPlanID, cCombatPlanCombatType, 0, cCombatPlanCombatTypeAttack);
   aiPlanSetVariableInt(gIslandCornerSweepPlanID, cCombatPlanTargetMode, 0, cCombatPlanTargetModePoint);
   aiPlanSetVariableVector(gIslandCornerSweepPlanID, cCombatPlanTargetPoint, 0, xsArrayGetVector(gIslandSweepPoints, 0));
   aiPlanSetVariableVector(gIslandCornerSweepPlanID, cCombatPlanGatherPoint, 0, islandCenter);
   aiPlanSetVariableFloat(gIslandCornerSweepPlanID, cCombatPlanGatherDistance, 0, 800.0);
   aiPlanSetVariableInt(gIslandCornerSweepPlanID, cCombatPlanAttackRoutePattern, 0, cCombatPlanAttackRoutePatternBest);
   aiPlanSetVariableBool(gIslandCornerSweepPlanID, cCombatPlanAllowMoreUnitsDuringAttack, 0, true);
   aiPlanSetVariableInt(gIslandCornerSweepPlanID, cCombatPlanRefreshFrequency, 0, 5);
   aiPlanSetVariableInt(gIslandCornerSweepPlanID, cCombatPlanDoneMode, 0, cCombatPlanDoneModeNoTarget);
   aiPlanSetVariableInt(gIslandCornerSweepPlanID, cCombatPlanRetreatMode, 0, cCombatPlanRetreatModeNone);
   aiPlanSetVariableInt(gIslandCornerSweepPlanID, cCombatPlanNoTargetTimeout, 0, 30000);  // 30 sec per corner
   aiPlanSetInitialPosition(gIslandCornerSweepPlanID, islandCenter);
   aiPlanSetDesiredPriority(gIslandCornerSweepPlanID, 100);
   aiPlanSetNoMoreUnits(gIslandCornerSweepPlanID, false);
   aiPlanSetRequiresAllNeedUnits(gIslandCornerSweepPlanID, false);
   aiPlanSetActive(gIslandCornerSweepPlanID, true);
   
   aiEcho("Island sweep plan created with " + numberInPlan + " units, checking " + gIslandSweepPointCount + " points");
   aiEcho("Corners: SW=" + corner1 + " SE=" + corner2 + " NE=" + corner3 + " NW=" + corner4);
}

//==============================================================================
// updateIslandCornerSweep
// Called periodically to advance the sweep to the next corner
// Returns true if sweep is complete, false if still in progress
//==============================================================================
bool updateIslandCornerSweep()
{
   if (gIslandCornerSweepPlanID < 0) {
      return true;  // No sweep in progress
   }
   
   // Check if plan is still active
   if (aiPlanGetActive(gIslandCornerSweepPlanID) == false) {
      // Plan completed or timed out at current corner, move to next
      gCurrentSweepCorner++;
      
      if (gCurrentSweepCorner >= gIslandSweepPointCount) {
         aiEcho("Island sweep complete - all " + gIslandSweepPointCount + " points checked");
         aiPlanDestroy(gIslandCornerSweepPlanID);
         gIslandCornerSweepPlanID = -1;
         return true;
      }
      
      vector nextCorner = xsArrayGetVector(gIslandSweepPoints, gCurrentSweepCorner);
      int islandGroupId = kbAreaGroupGetIDByPosition(gIslandCenterPoint);
      
      // Recreate plan for next corner
      gIslandCornerSweepPlanID = aiPlanCreate("Island Corner Sweep Plan", cPlanCombat);
      
      if (gIslandCornerSweepPlanID < 0) {
         return true;
      }

   aiPlanAddUnitType(gIslandCornerSweepPlanID, cUnitTypeLogicalTypeLandMilitary, 1, 200, 200);
      
      // Re-add units on the island
      int unitQueryID = createSimpleUnitQuery(cUnitTypeLogicalTypeLandMilitary, cMyID, cUnitStateAlive);
      int numberFound = kbUnitQueryExecute(unitQueryID);
      int numberInPlan = 0;
      
      for (i = 0; < numberFound)
      {
         int unitID = kbUnitQueryGetResult(unitQueryID, i);
         vector unitLocation = kbUnitGetPosition(unitID);
         int unitLocationGroupId = kbAreaGroupGetIDByPosition(unitLocation);
         
         if (kbUnitIsType(unitID, cUnitTypeHero) == true) {
            continue;
         }
         
         if (kbAreAreaGroupsPassableByLand(islandGroupId, unitLocationGroupId) == true) {
            int existingPlan = kbUnitGetPlanID(unitID);
            if (existingPlan >= 0) {
               aiPlanRemoveUnit(existingPlan, unitID);
            }
            if (aiPlanAddUnit(gIslandCornerSweepPlanID, unitID) == true) {
               numberInPlan++;
            }
         }
      }
      aiPlanSetVariableInt(gIslandCornerSweepPlanID, cCombatPlanCombatType, 0, cCombatPlanCombatTypeAttack);
      aiPlanSetVariableInt(gIslandCornerSweepPlanID, cCombatPlanTargetMode, 0, cCombatPlanTargetModePoint);
      aiPlanSetVariableVector(gIslandCornerSweepPlanID, cCombatPlanTargetPoint, 0, nextCorner);
      aiPlanSetVariableVector(gIslandCornerSweepPlanID, cCombatPlanGatherPoint, 0, gIslandCenterPoint);
      aiPlanSetVariableFloat(gIslandCornerSweepPlanID, cCombatPlanGatherDistance, 0, 800.0);
      aiPlanSetVariableInt(gIslandCornerSweepPlanID, cCombatPlanAttackRoutePattern, 0, cCombatPlanAttackRoutePatternBest);
      aiPlanSetVariableBool(gIslandCornerSweepPlanID, cCombatPlanAllowMoreUnitsDuringAttack, 0, true);
      aiPlanSetVariableInt(gIslandCornerSweepPlanID, cCombatPlanRefreshFrequency, 0, 5);
      aiPlanSetVariableInt(gIslandCornerSweepPlanID, cCombatPlanDoneMode, 0, cCombatPlanDoneModeNoTarget);
      aiPlanSetVariableInt(gIslandCornerSweepPlanID, cCombatPlanRetreatMode, 0, cCombatPlanRetreatModeNone);
      aiPlanSetVariableInt(gIslandCornerSweepPlanID, cCombatPlanNoTargetTimeout, 0, 30000);
      aiPlanSetInitialPosition(gIslandCornerSweepPlanID, gIslandCenterPoint);
      aiPlanSetDesiredPriority(gIslandCornerSweepPlanID, 100);
      aiPlanSetNoMoreUnits(gIslandCornerSweepPlanID, false);
      aiPlanSetRequiresAllNeedUnits(gIslandCornerSweepPlanID, false);
      aiPlanSetActive(gIslandCornerSweepPlanID, true);
      
      aiEcho("Advancing to corner " + gCurrentSweepCorner + " at " + nextCorner);
   }
   
   // Check if enemy found during sweep
   int enemyBuildingId = getClosestIslandUnitByLocation(cUnitTypeBuilding, cPlayerRelationEnemyNotGaia, 
      cUnitStateABQ, gIslandCenterPoint, 5000);
   
   if (enemyBuildingId > 0) {
      aiEcho("Enemy found during corner sweep! Switching to assault.");
      aiPlanDestroy(gIslandCornerSweepPlanID);
      gIslandCornerSweepPlanID = -1;
      return true;  // Signal that sweep found something
   }
   
   return false;  // Sweep still in progress
}

//==============================================================================
// shouldStartCornerSweep
// Determines if we should start a corner sweep based on current state
//==============================================================================
bool shouldStartCornerSweep()
{
   // Already doing a sweep
   if (gIslandCornerSweepPlanID >= 0) {
      return false;
   }
   
   // Need to be in an active invasion
   if (gActiveIslandInvasion == false) {
      return false;
   }
   
   // Need valid island location
   if (gIslandCenterPoint == cInvalidVector && gProbableEnemyIsland == cInvalidVector) {
      return false;
   }
   
   // Check if assault and search plans are both inactive/complete
   bool assaultDone = (gIslandAssaultPlanID < 0) || (aiPlanGetActive(gIslandAssaultPlanID) == false);
   bool searchDone = (gIslandSearchPlanID < 0) || (aiPlanGetActive(gIslandSearchPlanID) == false);
   
   if (assaultDone == false || searchDone == false) {
      return false;  // Still have active plans
   }
   
   // Check if we have units on the island
   int islandGroupId = kbAreaGroupGetIDByPosition(gIslandCenterPoint);
   if (islandGroupId < 0) {
      islandGroupId = kbAreaGroupGetIDByPosition(gProbableEnemyIsland);
   }
   
   int unitQueryID = createSimpleUnitQuery(cUnitTypeLogicalTypeLandMilitary, cMyID, cUnitStateAlive);
   int numberFound = kbUnitQueryExecute(unitQueryID);
   int unitsOnIsland = 0;
   
   for (i = 0; < numberFound)
   {
      int unitID = kbUnitQueryGetResult(unitQueryID, i);
      if (kbUnitIsType(unitID, cUnitTypeHero) == true) {
         continue;
      }
      vector unitLocation = kbUnitGetPosition(unitID);
      int unitLocationGroupId = kbAreaGroupGetIDByPosition(unitLocation);
      if (kbAreAreaGroupsPassableByLand(islandGroupId, unitLocationGroupId) == true) {
         unitsOnIsland++;
      }
   }
   
   // Need at least some units to do a sweep
   if (unitsOnIsland < 3) {
      return false;
   }
   
   // No enemy buildings visible - time to sweep
   int enemyBuildingId = getClosestIslandUnitByLocation(cUnitTypeBuilding, cPlayerRelationEnemyNotGaia, 
      cUnitStateABQ, gIslandCenterPoint, 5000);
   
   return (enemyBuildingId < 0);
}

//==============================================================================
// getStrandedUnitsLocation
//==============================================================================
vector getStrandedUnitsLocation()
{
   if (gIslandCenterPoint == cInvalidVector && gProbableEnemyIsland == cInvalidVector) {
      return (cInvalidVector);
   }
   
   int islandGroupId = kbAreaGroupGetIDByPosition(gIslandCenterPoint);
   if (islandGroupId < 0) {
      islandGroupId = kbAreaGroupGetIDByPosition(gProbableEnemyIsland);
   }
   if (islandGroupId < 0) {
      return (cInvalidVector);
   }
   
   int unitQueryID = createSimpleUnitQuery(cUnitTypeLogicalTypeLandMilitary, cMyID, cUnitStateAlive);
   int numberFound = kbUnitQueryExecute(unitQueryID);
   
   float totalX = 0.0;
   float totalZ = 0.0;
   int unitsOnIsland = 0;
   
   for (i = 0; < numberFound)
   {
      int unitID = kbUnitQueryGetResult(unitQueryID, i);
      
      if (kbUnitIsType(unitID, cUnitTypeHero) == true) {
         continue;
      }
      
      vector unitLocation = kbUnitGetPosition(unitID);
      int unitLocationGroupId = kbAreaGroupGetIDByPosition(unitLocation);
      
      if (kbAreAreaGroupsPassableByLand(islandGroupId, unitLocationGroupId) == true) {
         totalX = totalX + xsVectorGetX(unitLocation);
         totalZ = totalZ + xsVectorGetZ(unitLocation);
         unitsOnIsland++;
      }
   }
   
   if (unitsOnIsland < 1) {
      return (cInvalidVector);
   }
   
   float avgX = totalX / unitsOnIsland;
   float avgZ = totalZ / unitsOnIsland;
   
   return (xsVectorSet(avgX, 0.0, avgZ));
}

//==============================================================================
// checkAndRecreateStrandedUnitPlans
//==============================================================================
void checkAndRecreateStrandedUnitPlans(int currentMode = -1, bool hasTarget = false)
{
   int islandGroupId = kbAreaGroupGetIDByPosition(gIslandCenterPoint);
   if (islandGroupId < 0) {
      islandGroupId = kbAreaGroupGetIDByPosition(gProbableEnemyIsland);
   }
   if (islandGroupId < 0) {
      return;
   }
   
   int unitQueryID = createSimpleUnitQuery(cUnitTypeLogicalTypeLandMilitary, cMyID, cUnitStateAlive);
   int numberFound = kbUnitQueryExecute(unitQueryID);
   int numberOnIsland = 0;
   
   for (i = 0; < numberFound)
   {
      int unitID = kbUnitQueryGetResult(unitQueryID, i);
      if (kbUnitIsType(unitID, cUnitTypeHero) == true) {
         continue;
      }
      vector unitLocation = kbUnitGetPosition(unitID);
      int unitLocationGroupId = kbAreaGroupGetIDByPosition(unitLocation);
      if (kbAreAreaGroupsPassableByLand(islandGroupId, unitLocationGroupId) == true) {
         numberOnIsland++;
      }
   }
   
   if (numberOnIsland < 2) {
      return;
   }
   
   bool assaultPlanDead = (gIslandAssaultPlanID < 0);
   bool searchPlanDead = (gIslandSearchPlanID < 0);
   
   if ((assaultPlanDead == true && currentMode == 1) || (searchPlanDead == true && currentMode == 2)) {
      vector strandedLocation = getStrandedUnitsLocation();
      
      if (strandedLocation == cInvalidVector) {
         strandedLocation = gNavalInvasionCoastalPoint;
      }
      
      aiEcho("Plans died but " + numberOnIsland + " units still on island, recreating at " + strandedLocation);
      
      if (hasTarget == true || currentMode == 1) {
         int enemyBuildingId = getClosestIslandUnitByLocation(cUnitTypeBuilding, cPlayerRelationEnemyNotGaia, 
            cUnitStateABQ, strandedLocation, 5000);
         
         if (enemyBuildingId > 0) {
            vector enemyLocation = kbUnitGetPosition(enemyBuildingId);
            aiEcho("Recreating assault plan targeting enemy at " + enemyLocation);
            createIslandAssaultPlan(strandedLocation, enemyLocation);
         } else {
            aiEcho("No enemy found, recreating search plan");
            createIslandSearchPlan(strandedLocation, gIslandCenterPoint);
         }
      } else {
         aiEcho("Recreating search plan");
         createIslandSearchPlan(strandedLocation, gIslandCenterPoint);
      }
   }
}
//==============================================================================
// addUnitsToInvasionPlan
//==============================================================================
void addUnitsToInvasionPlan(int planId = -1) {
   if (planId < 0 || aiPlanGetActive(planId) == false) {
      return;
   }
   
   int unitID = -1;
   vector unitLocation = cInvalidVector;
   int unitLocationId = -1;
   int unitLocationGroupId = -1;
   int islandGroupId = kbAreaGroupGetIDByPosition(gIslandCenterPoint);
   int unitsAdded = 0;
   
   int unitQueryID = createSimpleUnitQuery(cUnitTypeLogicalTypeLandMilitary, cMyID, cUnitStateAlive);
   int numberFound = kbUnitQueryExecute(unitQueryID);
   
   for (i = 0; < numberFound)
   {
      unitID = kbUnitQueryGetResult(unitQueryID, i);
      unitLocation = kbUnitGetPosition(unitID);
      unitLocationId = kbAreaGetIDByPosition(unitLocation);
      unitLocationGroupId = kbAreaGroupGetIDByPosition(unitLocation);
      
      // Skip heroes
      if (kbUnitIsType(unitID, cUnitTypeHero) == true) {
         continue;
      }
      
      if (kbAreAreaGroupsPassableByLand(islandGroupId, unitLocationGroupId) == false) {
         continue;
      }
      
      int currentPlan = kbUnitGetPlanID(unitID);
      if (currentPlan == planId) {
         continue;
      }
      
      bool shouldAdd = false;
      if (currentPlan < 0) {
         shouldAdd = true;
      } else if (aiPlanGetActive(currentPlan) == false) {
         shouldAdd = true;
      } else if (aiPlanGetType(currentPlan) == cPlanTransport) {
         shouldAdd = true;  // It has already carried them here
      } else if (aiPlanGetDesiredPriority(currentPlan) <= aiPlanGetDesiredPriority(planId)) {
         shouldAdd = true;  // Lower or equal priority plan
      } else if (aiPlanGetType(currentPlan) == cPlanDefend && aiPlanGetDesiredPriority(currentPlan) < 60) {
         shouldAdd = true;
      }
      
      if (shouldAdd) {
         if (currentPlan >= 0) {
            aiPlanRemoveUnit(currentPlan, unitID);
         }
         if (aiPlanAddUnit(planId, unitID) == true) {
            unitsAdded++;
         }
      }
   }
   
   if (unitsAdded > 0) {
      int currentInPlan = aiPlanGetNumberUnits(planId, cUnitTypeLogicalTypeLandMilitary);
      aiPlanAddUnitType(planId, cUnitTypeLogicalTypeLandMilitary, 1, 200, 200);
      aiEcho("Added " + unitsAdded + " units to invasion plan, total: " + currentInPlan);
   }
}

//==============================================================================
// warshipTraining
//==============================================================================
void warshipTraining()
{
   static int trainingShipQuery = -1;
   if (trainingShipQuery < 0)
   {
      trainingShipQuery = kbUnitQueryCreate("Training Ship Query");
   }
   kbUnitQuerySetPlayerRelation(trainingShipQuery, cPlayerRelationSelf);
   kbUnitQuerySetUnitType(trainingShipQuery, gGalleonUnit);
   kbUnitQuerySetState(trainingShipQuery, cUnitStateAlive);
   kbUnitQueryResetResults(trainingShipQuery);
   int numberOfTrainingShips = kbUnitQueryExecute(trainingShipQuery);
   int limit = aiGetMilitaryPop();
   if (limit < cMinMilitaryMaintain)
   {
      limit = cMinMilitaryMaintain;
   }
   int unitID = -1;
   int unitPlanID = -1;
   vector galleonPosition = cInvalidVector;
   vector coastalTargetPoint = cInvalidVector;
   
   if (numberOfTrainingShips <= 0) {
      return;
   }

   if ((gGalleonTrainingPlan >= 0) && (aiPlanGetState(gGalleonTrainingPlan) == -1))
   {
      aiPlanDestroy(gGalleonTrainingPlan);
      gGalleonTrainingPlan = -1;
   }
   if ((gGalleonArtilleryTrainingPlan >= 0) && (aiPlanGetState(gGalleonArtilleryTrainingPlan) == -1))
   {
      aiPlanDestroy(gGalleonArtilleryTrainingPlan);
      gGalleonArtilleryTrainingPlan = -1;
   }

   if (gGalleonTrainingPlan < 0)
   {
      gGalleonLandUnit = -1;
      gGalleonArtilleryUnit = -1;
      for (int pickIndex = 0; pickIndex < gNumArmyUnitTypes; pickIndex++)
      {
         int pickedUnit = kbUnitPickGetResult(gLandUnitPicker, pickIndex);
         if (pickedUnit < 0)
         {
            continue;
         }
         if (kbProtoUnitCanTrain(gGalleonUnit, pickedUnit) == false)
         {
            continue;
         }
         if (kbProtoUnitIsType(pickedUnit, cUnitTypeAbstractArtillery) == true)
         {
            if (gGalleonArtilleryUnit == -1)
            {
               gGalleonArtilleryUnit = pickedUnit;
            }
         }
         else if (gGalleonLandUnit == -1)
         {
            gGalleonLandUnit = pickedUnit;
         }
      }

      if (gGalleonLandUnit == -1) {
         aiEcho("warshipTraining: No land unit found to train");
         return;
      }
      
      gGalleonTrainingPlan = createSimpleMaintainPlan(gGalleonLandUnit, limit, false, -1, 5);
      aiPlanSetDesiredResourcePriority(gGalleonTrainingPlan, 100);
      aiPlanSetDesiredPriority(gGalleonTrainingPlan, 99);
      aiPlanSetVariableInt(gGalleonTrainingPlan, cTrainPlanBuildFromType, 0, gGalleonUnit);
      aiPlanSetVariableInt(gGalleonTrainingPlan, cTrainPlanBatchSize, 0, 5);
      aiPlanSetVariableInt(gGalleonTrainingPlan, cTrainPlanNumberToMaintain, 0, limit);
      aiPlanSetActive(gGalleonTrainingPlan);
      
      if (gGalleonArtilleryUnit != -1) {
         gGalleonArtilleryTrainingPlan = createSimpleMaintainPlan(gGalleonArtilleryUnit, limit, false, -1, 5);
         aiPlanSetDesiredResourcePriority(gGalleonArtilleryTrainingPlan, 99);
         aiPlanSetDesiredPriority(gGalleonArtilleryTrainingPlan, 98);
         aiPlanSetVariableInt(gGalleonArtilleryTrainingPlan, cTrainPlanBuildFromType, 0, gGalleonUnit);
         aiPlanSetVariableInt(gGalleonArtilleryTrainingPlan, cTrainPlanBatchSize, 0, 5);
         aiPlanSetVariableInt(gGalleonArtilleryTrainingPlan, cTrainPlanNumberToMaintain, 0, limit);
         aiPlanSetActive(gGalleonArtilleryTrainingPlan);
      }
      
      aiEcho("Galleon Maintain Plans Created!");
   }

   if (gNavalInvasionCoastalPoint != cInvalidVector)
   {
      aiPlanSetVariableVector(gGalleonTrainingPlan, cTrainPlanGatherPoint, 0, gNavalInvasionCoastalPoint);
      if (gGalleonArtilleryTrainingPlan >= 0)
      {
         aiPlanSetVariableVector(gGalleonArtilleryTrainingPlan, cTrainPlanGatherPoint, 0,
            gNavalInvasionCoastalPoint);
      }
   }
   
   if (gActiveIslandInvasion == true && gMilitaryTransportMode < 3)
   {
      for (int shipIndex = 0; shipIndex < numberOfTrainingShips; shipIndex++)
      {
         unitID = kbUnitQueryGetResult(trainingShipQuery, shipIndex);
         
         if (shipIsOnAllyAssist(unitID) == true) {
            continue;
         }
         
         unitPlanID = kbUnitGetPlanID(unitID);
         if (unitPlanID >= 0 && aiPlanGetType(unitPlanID) == cPlanTransport) {
            continue;
         }
         
         if (unitPlanID >= 0 && aiPlanGetDesiredPriority(unitPlanID) >= 80) {
            continue;
         }
         
         if (unitPlanID >= 0) {
            aiPlanRemoveUnit(unitPlanID, unitID);
         }
         
         galleonPosition = kbUnitGetPosition(unitID);
         
         vector landCoast = gNavalInvasionCoastalPoint;
         if (landCoast == cInvalidVector) {
            landCoast = coastalEdgeVector(galleonPosition, gProbableEnemyIsland);
         }
         
         vector myBase = kbBaseGetLocation(cMyID, kbBaseGetMainID(cMyID));
         vector directionToWater = xsVectorNormalize(myBase - landCoast);
         coastalTargetPoint = landCoast + (directionToWater * 20.0);
         
         if (kbAreaGetType(kbAreaGetIDByPosition(coastalTargetPoint)) != cAreaTypeWater) {
            coastalTargetPoint = landCoast + (directionToWater * 30.0);
         }
         
         float distToCoast = distance(galleonPosition, coastalTargetPoint);
         
         if (distToCoast > 40.0)
         {
            aiTaskUnitMove(unitID, coastalTargetPoint);
            continue;
         }
         
         int unitsOnboard = getUnitCountByLocation(cUnitTypeLogicalTypeLandMilitary, cPlayerRelationSelf,
               cUnitStateAlive, galleonPosition, 3.0);
         
         if (unitsOnboard > 0)
         {
            aiEcho("Galleon " + unitID + " ejecting " + unitsOnboard + " units");
            aiTaskUnitEject(unitID);
         }
         
         int actionType = kbUnitGetActionType(unitID);
         if (actionType == cActionTypeIdle)
         {
            bool trainArtillery = ((shipIndex % 2) == 1) && (gGalleonArtilleryUnit != -1);
            int unitToTrain = trainArtillery ? gGalleonArtilleryUnit : gGalleonLandUnit;
            aiEcho("Galleon " + unitID + " training: " + kbGetUnitTypeName(unitToTrain));
            aiTaskUnitTrain(unitID, unitToTrain);
         }
      }
      
      assignCoastalUnitsToAssault();
   }
}

//==============================================================================
// homeIslandUnderAttack - Send troops home if we are under attack...
//==============================================================================
bool homeIslandUnderAttack() {
   vector startingLoc = kbGetPlayerStartingPosition(cMyID);
   int enemyUnitQueryID = createSimpleUnitQuery(cUnitTypeLogicalTypeLandMilitary, cPlayerRelationEnemyNotGaia, cUnitStateAlive, startingLoc, 125);
   int enemyNumberFound = kbUnitQueryExecute(enemyUnitQueryID);
   if (enemyNumberFound > 15) {
      return true;
   }

   return false;
}
//==============================================================================
// resetInvasionSequence - Necessarily resets the invasion sequence...
//==============================================================================
void resetInvasionSequence() {
   aiEcho("Could not do something that was necessary, resetting!");
   aiPlanDestroy(gIslandAssaultTransportPlanID);
   aiPlanDestroy(gIslandAssaultTransportPlan2ID);
   aiPlanDestroy(gIslandAssaultPlanID);
   aiPlanDestroy(gIslandSearchPlanID);
   aiPlanDestroy(gIslandReturnTransportPlanID);
   aiPlanDestroy(gGalleonTrainingPlan);
   aiPlanDestroy(gGalleonArtilleryTrainingPlan);
   aiPlanDestroy(gIslandCornerSweepPlanID);
   gActiveIslandInvasion = false;
   gActiveVillagersTransport = false;
   gProbableEnemyIsland = cInvalidVector;
   gNavalInvasionCoastalPoint = cInvalidVector;
   gProbableEnemyIslandAreaId = -1;
   gProbableEnemyIslandGroupId = -1;
   gNumberTransported = 0;
   gIslandCenterPoint = cInvalidVector;
   gProbableEnemyIslandX = 0.0;
   gProbableEnemyIslandZ = 0.0;
   gDistanceToCoast = 0.0;
   gInvasionPlan = "";
   gMilitaryTransportMode = 0;
   gIslandFound = false;
   gIslandAssaultTransportPlanID = -1;
   gIslandAssaultTransportPlan2ID = -1;
   gIslandAssaultPlanID = -1;
   gAssaultExploreDone = false;
   gAssaultingIsland = false;
   gIslandSearchPlanID = -1;
   gAssaultTargetStale = false;
   gAssaultPlanTime = 0;
   gSearchPlanTime = 0;
   gIslandReturnTransportPlanID = -1;
   gGalleonTrainingPlan = -1;
   gGalleonArtilleryTrainingPlan = -1;
   gIslandCornerSweepPlanID = -1;
   gIslandCorner1 = cInvalidVector;
   gIslandCorner2 = cInvalidVector;
   gIslandCorner3 = cInvalidVector;
   gIslandCorner4 = cInvalidVector;
   gCurrentSweepCorner = 0;
   return;
}