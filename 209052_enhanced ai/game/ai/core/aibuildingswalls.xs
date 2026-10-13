void findWallBuilders() {
   int unitQueryID = createSimpleUnitQuery(gEconUnit, cMyID, cUnitStateAlive);
   int numberFound = kbUnitQueryExecute(unitQueryID);
   int unitID = -1;

   gWallBuilderIds = xsArrayCreateInt(3, -1, "Wall Builders Array");

   if (numberFound > 5) {
      for (int i = 0; i < 3; i++) {
         unitID = kbUnitQueryGetResult(unitQueryID, i);
         xsArraySetInt(gWallBuilderIds, i, unitID);
      }
   }
   return;
}

int wallSegmentSlot(int perimeter = 0, int section = 0)
{
   return ((perimeter * cMaxWallSegments) + section);
}

void initWallPerimeterArrays(void)
{
   if (gWallSegmentStarts >= 0)
   {
      return;
   }

   int total = cMaxWallPerimeters * cMaxWallSegments;
   gWallSegmentStarts = xsArrayCreateVector(total, cInvalidVector, "Wall segment starts");
   gWallSegmentEnds = xsArrayCreateVector(total, cInvalidVector, "Wall segment ends");
   gWallSegmentGates = xsArrayCreateInt(total, 0, "Wall segment gates");
   gWallSegmentNeeded = xsArrayCreateInt(total, 0, "Wall segments needing work");
   gWallSegmentWallCount = xsArrayCreateInt(total, 0, "Wall pieces per segment when built");
   gWallSegmentRepairFails = xsArrayCreateInt(total, 0, "Failed repairs per segment");

   gWallPerimeterSegCount = xsArrayCreateInt(cMaxWallPerimeters, 0, "Wall perimeter section count");
   gWallPerimeterBaseID = xsArrayCreateInt(cMaxWallPerimeters, -1, "Wall perimeter base");
   gWallPerimeterPriority = xsArrayCreateInt(cMaxWallPerimeters, 100, "Wall perimeter priority");
   gWallPerimeterCenter = xsArrayCreateVector(cMaxWallPerimeters, cInvalidVector, "Wall perimeter centre");
   gWallPerimeterBuildIndex = xsArrayCreateInt(cMaxWallPerimeters, 0, "Wall perimeter build index");
   gWallPerimeterActivePlan = xsArrayCreateInt(cMaxWallPerimeters, -1, "Wall perimeter active plan");
   gWallPerimeterBuilderID = xsArrayCreateInt(cMaxWallPerimeters, -1, "Wall perimeter builder");
   gWallPerimeterBuildStart = xsArrayCreateInt(cMaxWallPerimeters, 0, "Wall perimeter section start");
   gWallPerimeterRetries = xsArrayCreateInt(cMaxWallPerimeters, 0, "Wall perimeter retries");
   gWallPerimeterRepairCursor = xsArrayCreateInt(cMaxWallPerimeters, 0, "Wall perimeter repair cursor");
   gWallPerimeterRepairPlan = xsArrayCreateInt(cMaxWallPerimeters, -1, "Wall perimeter repair plan");
   gWallPerimeterRepairIndex = xsArrayCreateInt(cMaxWallPerimeters, -1, "Wall perimeter repair section");
   gWallPerimeterRepairStart = xsArrayCreateInt(cMaxWallPerimeters, 0, "Wall perimeter repair start");
   gWallPerimeterBuilt = xsArrayCreateInt(cMaxWallPerimeters, 0, "Wall perimeter finished");
   gWallPerimeterDiag = xsArrayCreateInt(cMaxWallPerimeters, -1, "Wall perimeter diag reason");
   gWallPerimeterBlockedBuilder = xsArrayCreateInt(cMaxWallPerimeters, -1, "Wall perimeter blocked builder");
   gWallPerimeterRepairBuilder = xsArrayCreateInt(cMaxWallPerimeters, -1, "Wall perimeter repair builder");
   gWallPerimeterRepairIdle = xsArrayCreateInt(cMaxWallPerimeters, 0, "Wall perimeter repair idle sweeps");

   gWallSquareDirections = xsArrayCreateVector(4, cInvalidVector, "Square Wall Directions");
   xsArraySetVector(gWallSquareDirections, 0, xsVectorSet(1, 0, 0));
   xsArraySetVector(gWallSquareDirections, 1, xsVectorSet(0, 0, 1));
   xsArraySetVector(gWallSquareDirections, 2, xsVectorSet(-1, 0, 0));
   xsArraySetVector(gWallSquareDirections, 3, xsVectorSet(0, 0, -1));

   gWallPentagonDirections = xsArrayCreateVector(5, cInvalidVector, "Pentagon Wall Directions");
   xsArraySetVector(gWallPentagonDirections, 0, xsVectorSet(1, 0, 0));
   xsArraySetVector(gWallPentagonDirections, 1, xsVectorSet(1, 0, 1));
   xsArraySetVector(gWallPentagonDirections, 2, xsVectorSet(0, 0, 1));
   xsArraySetVector(gWallPentagonDirections, 3, xsVectorSet(-1, 0, 1));
   xsArraySetVector(gWallPentagonDirections, 4, xsVectorSet(-1, 0, 0));

   aiEcho("WALL ARRAYS starts=" + gWallSegmentStarts + " ends=" + gWallSegmentEnds +
          " needed=" + gWallSegmentNeeded + " segCount=" + gWallPerimeterSegCount +
          " buildIdx=" + gWallPerimeterBuildIndex + " diag=" + gWallPerimeterDiag);
}

bool wallBuilderIsTaken(int unitID = -1, int exceptPerimeter = -1)
{
   if ((exceptPerimeter >= 0) &&
       (xsArrayGetInt(gWallPerimeterBlockedBuilder, exceptPerimeter) == unitID))
   {
      return (true);
   }

   for (int takenSlot = 0; takenSlot < cMaxWallPerimeters; takenSlot++)
   {
      if (xsArrayGetInt(gWallPerimeterRepairBuilder, takenSlot) == unitID)
      {
         return (true);
      }
      if (takenSlot == exceptPerimeter)
      {
         continue;
      }
      if (xsArrayGetInt(gWallPerimeterBuilderID, takenSlot) == unitID)
      {
         return (true);
      }
   }

   return (false);
}
int getWallBuilder(int perimeter = 0, vector nearLoc = cInvalidVector)
{
   initWallPerimeterArrays();

   int current = xsArrayGetInt(gWallPerimeterBuilderID, perimeter);
   if (current >= 0)
   {
      if ((kbUnitGetPlayerID(current) == cMyID) && (kbUnitGetHealth(current) > 0.0))
      {
         return (current);
      }
      aiEcho("Wall builder " + current + " is gone, finding a replacement");
      xsArraySetInt(gWallPerimeterBuilderID, perimeter, -1);
   }

   int allQuery = createSimpleUnitQuery(gEconUnit, cMyID, cUnitStateAlive);
   if (kbUnitQueryExecute(allQuery) < 6)
   {
      return (-1);
   }

   int builderID = -1;
   int candidate = -1;
   int found = 0;

   if (nearLoc != cInvalidVector)
   {
      int nearQuery = createSimpleUnitQuery(gEconUnit, cMyID, cUnitStateAlive, nearLoc, 80.0);
      found = kbUnitQueryExecute(nearQuery);
      for (int nearIndex = 0; nearIndex < found; nearIndex++)
      {
         candidate = kbUnitQueryGetResult(nearQuery, nearIndex);
         if (wallBuilderIsTaken(candidate, perimeter) == false)
         {
            builderID = candidate;
            break;
         }
      }
   }

   if (builderID < 0)
   {
      int anyQuery = createSimpleUnitQuery(gEconUnit, cMyID, cUnitStateAlive);
      found = kbUnitQueryExecute(anyQuery);
      for (int anyIndex = 0; anyIndex < found; anyIndex++)
      {
         candidate = kbUnitQueryGetResult(anyQuery, anyIndex);
         if (wallBuilderIsTaken(candidate, perimeter) == false)
         {
            builderID = candidate;
            break;
         }
      }
   }

   if (builderID < 0)
   {
      return (-1);
   }

   xsArraySetInt(gWallPerimeterBuilderID, perimeter, builderID);
   aiEcho("Wall builder for perimeter " + perimeter + " is now unit " + builderID);
   return (builderID);
}
vector rotateBy90Degrees(vector origin = cInvalidVector, vector point = cInvalidVector, 
bool toRight = false) {
    vector translatedPoint = point - origin;

    float x = xsVectorGetX(translatedPoint);
    float z = xsVectorGetZ(translatedPoint);
    float rotatedX = 0.0;
    float rotatedZ = 0.0;

    if (toRight) {
        rotatedX = z;
        rotatedZ = 0.0 - x;
    } else {
        rotatedX = 0.0 - z;
        rotatedZ = x;
    }

    vector rotatedTranslatedPoint = xsVectorSet(rotatedX, xsVectorGetY(translatedPoint), rotatedZ);

    vector rotatedPoint = rotatedTranslatedPoint + origin;

    return rotatedPoint;
}
bool wallTester(vector originLocation = cInvalidVector, float avoidanceSetting = 5.0) {
   int treeQuery = createSimpleUnitQuery(cUnitTypeTree, cPlayerRelationAny, cUnitStateAny, 
   originLocation, avoidanceSetting);
   int treesFound = kbUnitQueryExecute(treeQuery);
   int buildingQuery = createSimpleUnitQuery(cUnitTypeBuilding, cPlayerRelationAny, cUnitStateAny, 
   originLocation, avoidanceSetting);
   int buildingsFound = kbUnitQueryExecute(buildingQuery);
   int resourceQuery = createSimpleUnitQuery(cUnitTypeResource, cPlayerRelationAny, cUnitStateAny, 
   originLocation, avoidanceSetting);
   int resourcesFound = kbUnitQueryExecute(resourceQuery);
   int settlementQuery = createSimpleUnitQuery(cUnitTypeAbstractSettlement, cPlayerRelationAny, cUnitStateAny, 
   originLocation, avoidanceSetting);
   int settlementsFound = kbUnitQueryExecute(settlementQuery);
   int socketQuery = createSimpleUnitQuery(cUnitTypeSocket, cPlayerRelationAny, cUnitStateAny, 
   originLocation, avoidanceSetting);
   int socketsFound = kbUnitQueryExecute(socketQuery);
   if (treesFound == 0 && buildingsFound == 0 && resourcesFound == 0 && settlementsFound == 0 &&
      socketsFound == 0) {
      return true;
   }
   return false;
}
vector wallBuilder(vector originLocation = cInvalidVector, vector centerLocation = cInvalidVector, 
int numberOfGates = -1, int baseId = -1, float wallDistance = -1.0, string direction = "", 
bool largeMap = false, bool avoidanceAdjustment = false, int iterationNumber = -1, int wallPriority = 65) {
   float x = xsVectorGetX(originLocation);
   float y = xsVectorGetY(originLocation);
   float z = xsVectorGetZ(originLocation);
   float avoidanceValue = 0.0;
   
   if (avoidanceAdjustment) {
      aiEcho("AVOID SOMETHING! Iteration: "+iterationNumber+"");
      avoidanceValue = -90;
      if (direction == "E") {
         avoidanceValue = 90;
      }
   }

   float arctan = atan((xsVectorGetZ(centerLocation) - z) / (xsVectorGetX(centerLocation) - x));
   aiEcho("Arctan: "+arctan+" Avoidance Angle: "+avoidanceValue+"");
   if ((xsVectorGetX(centerLocation) - x) < 0)
   {
      arctan = arctan + PI;
   }

   vector baseFront = kbBaseGetFrontVector(cMyID, baseId);

   vector startLocation = xsVectorSet(x - wallDistance, y, z);
   vector endLocation = xsVectorSet(x - wallDistance, y, z + 11);
   if (direction == "E") {
      startLocation = xsVectorSet(x + wallDistance, y, z);
      endLocation = xsVectorSet(x + wallDistance, y, z + 11);
   }

   startLocation = rotateByReferencePoint(originLocation, startLocation - originLocation, arctan);
   if (avoidanceAdjustment) {
      endLocation = rotateByReferencePoint(originLocation, endLocation - originLocation, avoidanceValue);
      for (int i = 0; i < 10; i++) {
         if (wallTester(endLocation) != true) {
            endLocation = rotateBy90Degrees(originLocation, endLocation, false);
            if (direction == "E") {
            endLocation = rotateBy90Degrees(originLocation, endLocation, true);
            }
         } else {
            break;
         }
      }
   } else {
      endLocation = rotateByReferencePoint(originLocation, endLocation - originLocation, arctan);
   }
   
   int straightWallPlan = aiPlanCreate("Straight Wall Plan", cPlanBuildWall);
   aiPlanSetVariableInt(straightWallPlan, cBuildWallPlanWallType, 0, cBuildWallPlanWallTypeStraight);
   aiPlanAddUnitType(straightWallPlan, gEconUnit, 1, 1, 1);
   aiPlanSetVariableVector(straightWallPlan, cBuildWallPlanWallStart, 0, startLocation);
   aiPlanSetVariableVector(straightWallPlan, cBuildWallPlanWallEnd, 0, endLocation);
   aiPlanSetVariableInt(straightWallPlan, cBuildWallPlanNumberOfGates, 0, numberOfGates);
   aiPlanSetBaseID(straightWallPlan, baseId);
   aiPlanSetEscrowID(straightWallPlan, cEconomyEscrowID);
   aiPlanSetVariableBool(straightWallPlan, cBuildWallPlanEnRoute, 0, true);
   aiPlanSetVariableFloat(straightWallPlan, cBuildWallPlanEdgeOfMapBuffer, 0, 1.0);
   aiPlanSetDesiredPriority(straightWallPlan, wallPriority);
   aiPlanSetActive(straightWallPlan, true);

   return endLocation;
}
vector rotateVector(vector v = cInvalidVector, float angle = 30.0) {

   float rad = angle * 3.14159 / 180.0;
   float x = xsVectorGetX(v);
   float z = xsVectorGetZ(v);
   return xsVectorSet(x * cos(rad) - z * sin(rad), 0.0, x * sin(rad) + z * cos(rad));
}

int buildWall(vector start = cInvalidVector, vector end = cInvalidVector, int baseId = -1, int wallPriority = -1,
bool hasGate = false, int wallPlanParent = -1) {
   int wallPlan = aiPlanCreate("Enhanced Wall Plan", cPlanBuildWall, wallPlanParent);
   int numberOfGates = 0;
   if (hasGate == true) {
      numberOfGates = 1;
   }
   int unitQueryID = createSimpleUnitQuery(gEconUnit, cMyID, cUnitStateAny);
   int numberFound = kbUnitQueryExecute(unitQueryID);
   int unitID = -1;
   int arrayUnitId = -1;

   aiPlanSetVariableInt(wallPlan, cBuildWallPlanWallType, 0, cBuildWallPlanWallTypeStraight);
   aiPlanAddUnitType(wallPlan, gEconUnit, 1, 1, 1);
   aiPlanSetVariableVector(wallPlan, cBuildWallPlanWallStart, 0, start);
   aiPlanSetVariableVector(wallPlan, cBuildWallPlanWallEnd, 0, end);
   aiPlanSetBaseID(wallPlan, baseId);
   aiPlanSetEscrowID(wallPlan, cEconomyEscrowID);
   aiPlanSetVariableBool(wallPlan, cBuildWallPlanEnRoute, 0, true);
   aiPlanSetVariableFloat(wallPlan, cBuildWallPlanEdgeOfMapBuffer, 0, 1.0);
   aiPlanSetVariableInt(wallPlan, cBuildWallPlanNumberOfGates, 0, numberOfGates);
   aiPlanSetDesiredPriority(wallPlan, wallPriority);
   aiPlanSetDesiredResourcePriority(wallPlan, wallPriority);
   return wallPlan;
}
void queueWallSegment(int perimeter = 0, vector segStart = cInvalidVector,
                      vector segEnd = cInvalidVector, bool hasGate = false)
{
   int count = xsArrayGetInt(gWallPerimeterSegCount, perimeter);
   if (count >= cMaxWallSegments)
   {
      gWallQueueAttempts++;
      gWallDroppedFull++;
      aiEcho("Wall queue for perimeter " + perimeter + " is full, dropping section");
      return;
   }

   if ((segStart == cInvalidVector) || (segEnd == cInvalidVector))
   {
      gWallQueueAttempts++;
      gWallDroppedInvalid++;
      return;
   }

   if (distance(segStart, segEnd) < cMinWallSegmentLength)
   {
      gWallQueueAttempts++;
      gWallDroppedShort++;
      return;
   }

   gWallQueueAttempts++;

   int gateFlag = 0;
   if (hasGate == true)
   {
      gateFlag = 1;
   }

   int slot = wallSegmentSlot(perimeter, count);
   xsArraySetVector(gWallSegmentStarts, slot, segStart);
   xsArraySetVector(gWallSegmentEnds, slot, segEnd);
   xsArraySetInt(gWallSegmentGates, slot, gateFlag);
   xsArraySetInt(gWallSegmentNeeded, slot, 1);
   xsArraySetInt(gWallSegmentWallCount, slot, 0);
   xsArraySetInt(gWallSegmentRepairFails, slot, 0);
   xsArraySetInt(gWallPerimeterSegCount, perimeter, count + 1);
}

bool wallAreaIsHostile(vector loc = cInvalidVector, float radius = 40.0)
{
   if (loc == cInvalidVector)
   {
      return (true);
   }

   int enemyQuery = createSimpleUnitQuery(cUnitTypeLogicalTypeLandMilitary, cPlayerRelationEnemyNotGaia,
                                          cUnitStateAlive, loc, radius);
   if (kbUnitQueryExecute(enemyQuery) > 0)
   {
      return (true);
   }

   return (false);
}

int countWallsAlongSegment(int perimeter = 0, int section = -1)
{
   if ((section < 0) || (section >= xsArrayGetInt(gWallPerimeterSegCount, perimeter)))
   {
      return (0);
   }

   int slot = wallSegmentSlot(perimeter, section);
   vector segStart = xsArrayGetVector(gWallSegmentStarts, slot);
   vector segEnd = xsArrayGetVector(gWallSegmentEnds, slot);
   if ((segStart == cInvalidVector) || (segEnd == cInvalidVector))
   {
      return (0);
   }

   vector midPoint = (segStart + segEnd) * 0.5;
   float halfLength = distance(segStart, segEnd) * 0.5;

   int wallQuery = createSimpleUnitQuery(cUnitTypeAbstractWall, cMyID, cUnitStateAlive,
                                         midPoint, halfLength + 2.0);
   return (kbUnitQueryExecute(wallQuery));
}

bool wallSegmentIsBreached(int perimeter = 0, int section = -1)
{
   if ((section < 0) || (section >= xsArrayGetInt(gWallPerimeterSegCount, perimeter)))
   {
      return (false);
   }

   int expected = xsArrayGetInt(gWallSegmentWallCount, wallSegmentSlot(perimeter, section));
   if (expected <= 0)
   {
      return (false);
   }

   int standing = countWallsAlongSegment(perimeter, section);
   if ((standing * 100) < (expected * cWallBreachTolerance))
   {
      return (true);
   }

   return (false);
}

void advanceWallPerimeter(int perimeter = 0)
{
   int segCount = xsArrayGetInt(gWallPerimeterSegCount, perimeter);
   int index = xsArrayGetInt(gWallPerimeterBuildIndex, perimeter);
   int activePlan = xsArrayGetInt(gWallPerimeterActivePlan, perimeter);
   int wallPriority = xsArrayGetInt(gWallPerimeterPriority, perimeter);

   if (activePlan >= 0)
   {
      if (aiPlanGetState(activePlan) < 0)
      {
         int doneSlot = wallSegmentSlot(perimeter, index);
         int builtPieces = countWallsAlongSegment(perimeter, index);
         xsArraySetInt(gWallSegmentNeeded, doneSlot, 0);
         xsArraySetInt(gWallSegmentWallCount, doneSlot, builtPieces);
         xsArraySetInt(gWallSegmentRepairFails, doneSlot, 0);

         if (builtPieces <= 0)
         {
            aiEcho("Perimeter " + perimeter + " section " + (index + 1) +
                   " finished with NO wall pieces");
         }

         xsArraySetInt(gWallPerimeterActivePlan, perimeter, -1);
         index = index + 1;
         xsArraySetInt(gWallPerimeterBuildIndex, perimeter, index);
         xsArraySetInt(gWallPerimeterRetries, perimeter, 0);
         xsArraySetInt(gWallPerimeterBlockedBuilder, perimeter, -1);

      }
      else
      {
         bool sectionFailed = false;
         int elapsed = xsGetTime() - xsArrayGetInt(gWallPerimeterBuildStart, perimeter);

         if (elapsed > cWallSectionGrace)
         {
            if (aiPlanGetNumberUnits(activePlan, gEconUnit) == 0)
            {
               aiEcho("Wall section " + (index + 1) + " on perimeter " + perimeter +
                      " lost its builder, retrying");
               sectionFailed = true;
            }
         }

         if ((sectionFailed == false) && (elapsed > cWallSectionTimeout))
         {
            aiEcho("Wall section " + (index + 1) + " on perimeter " + perimeter +
                   " stalled for " + (elapsed / 1000) + "s, retrying");
            sectionFailed = true;
         }

         if (sectionFailed == false)
         {
            xsArraySetInt(gWallPerimeterDiag, perimeter, 1);
            return;
         }

         aiPlanDestroy(activePlan);
         xsArraySetInt(gWallPerimeterActivePlan, perimeter, -1);
         xsArraySetInt(gWallPerimeterBlockedBuilder, perimeter,
                       xsArrayGetInt(gWallPerimeterBuilderID, perimeter));
         xsArraySetInt(gWallPerimeterBuilderID, perimeter, -1);

         int retries = xsArrayGetInt(gWallPerimeterRetries, perimeter) + 1;
         xsArraySetInt(gWallPerimeterRetries, perimeter, retries);

         if (retries > cWallSectionMaxRetries)
         {
            aiEcho("Wall section " + (index + 1) + " on perimeter " + perimeter +
                   " failed " + retries + " times, skipping it");
            xsArraySetInt(gWallSegmentNeeded, wallSegmentSlot(perimeter, index), 0);
            xsArraySetInt(gWallPerimeterBuildIndex, perimeter, index + 1);
            xsArraySetInt(gWallPerimeterRetries, perimeter, 0);
         }
         return;
      }
   }

   int wrapped = 0;
   int hostileChecks = 0;

   for (int step = 0; step < ((segCount * 2) + 4); step++)
   {
      index = xsArrayGetInt(gWallPerimeterBuildIndex, perimeter);

      if (index >= segCount)
      {
         int stillNeeded = 0;
         for (int needIndex = 0; needIndex < segCount; needIndex++)
         {
            if (xsArrayGetInt(gWallSegmentNeeded, wallSegmentSlot(perimeter, needIndex)) == 1)
            {
               stillNeeded++;
            }
         }

         if ((stillNeeded > 0) && (wrapped == 0))
         {
            aiEcho("Wall pass done on perimeter " + perimeter + ", " + stillNeeded +
                   " section(s) still to build, going round again");
            wrapped = 1;
            xsArraySetInt(gWallPerimeterBuildIndex, perimeter, 0);
            xsArraySetInt(gWallPerimeterRetries, perimeter, 0);
            continue;
         }

         if (stillNeeded > 0)
         {
            xsArraySetInt(gWallPerimeterDiag, perimeter, 5);
            return;
         }

         aiEcho("Wall complete on perimeter " + perimeter + " - " + segCount +
                " sections, watching for breaches");
         xsArraySetInt(gWallPerimeterBuildIndex, perimeter, 0);
         xsArraySetInt(gWallPerimeterRetries, perimeter, 0);
         xsArraySetInt(gWallPerimeterBuilt, perimeter, 1);
         xsArraySetInt(gWallPerimeterDiag, perimeter, 6);
         return;
      }

      int slot = wallSegmentSlot(perimeter, index);

      if (xsArrayGetInt(gWallSegmentNeeded, slot) == 0)
      {
         xsArraySetInt(gWallPerimeterBuildIndex, perimeter, index + 1);
         xsArraySetInt(gWallPerimeterRetries, perimeter, 0);
         xsArraySetInt(gWallPerimeterDiag, perimeter, 2);
         continue;
      }

      if (hostileChecks >= cWallHostileChecksPerPass)
      {
         xsArraySetInt(gWallPerimeterDiag, perimeter, 3);
         return;
      }
      hostileChecks++;

      vector segStart = xsArrayGetVector(gWallSegmentStarts, slot);

      if (wallAreaIsHostile(segStart, 40.0) == true)
      {
         xsArraySetInt(gWallPerimeterBuildIndex, perimeter, index + 1);
         xsArraySetInt(gWallPerimeterRetries, perimeter, 0);
         xsArraySetInt(gWallPerimeterDiag, perimeter, 3);
         continue;
      }

      int builderID = getWallBuilder(perimeter, xsArrayGetVector(gWallPerimeterCenter, perimeter));
      if (builderID < 0)
      {
         xsArraySetInt(gWallPerimeterDiag, perimeter, 4);
         return;
      }

      bool hasGate = false;
      if (xsArrayGetInt(gWallSegmentGates, slot) == 1)
      {
         hasGate = true;
      }

      int planID = buildWall(segStart, xsArrayGetVector(gWallSegmentEnds, slot),
                             xsArrayGetInt(gWallPerimeterBaseID, perimeter), wallPriority,
                             hasGate, gWallPlanParentId);
      if (planID < 0)
      {
         aiEcho("Wall section " + (index + 1) + " on perimeter " + perimeter +
                " could not be created, skipping");
         xsArraySetInt(gWallSegmentNeeded, slot, 0);
         xsArraySetInt(gWallPerimeterBuildIndex, perimeter, index + 1);
         xsArraySetInt(gWallPerimeterRetries, perimeter, 0);
         xsArraySetInt(gWallPerimeterDiag, perimeter, 7);
         continue;
      }

      if (aiPlanAddUnit(planID, builderID) == true)
      {
         aiPlanSetNoMoreUnits(planID, true);
      }
      else
      {
         aiEcho("Builder " + builderID + " would not attach to wall section " + (index + 1) +
                " on perimeter " + perimeter + ", letting the plan find its own");
      }

      aiPlanSetActive(planID, true);
      aiPlanSetDesiredPriority(planID, wallPriority);

      xsArraySetInt(gWallPerimeterDiag, perimeter, 0);
      xsArraySetInt(gWallPerimeterActivePlan, perimeter, planID);
      xsArraySetInt(gWallPerimeterBuildStart, perimeter, xsGetTime());
      aiEcho("Wall section " + (index + 1) + "/" + segCount + " on perimeter " + perimeter +
             " started by builder " + builderID);
      return;
   }
}

void repairWallPerimeter(int perimeter = 0)
{
   int segCount = xsArrayGetInt(gWallPerimeterSegCount, perimeter);
   int repairPlan = xsArrayGetInt(gWallPerimeterRepairPlan, perimeter);
   int repairIndex = xsArrayGetInt(gWallPerimeterRepairIndex, perimeter);

   if (repairPlan >= 0)
   {
      if (xsArrayGetInt(gWallPerimeterRepairBuilder, perimeter) < 0)
      {
         if (aiPlanGetNumberUnits(repairPlan, gEconUnit) > 0)
         {
            int recruited = aiPlanGetUnitByIndex(repairPlan, 0);
            if (recruited >= 0)
            {
               xsArraySetInt(gWallPerimeterRepairBuilder, perimeter, recruited);
               aiEcho("Perimeter " + perimeter + " repairs are unit " + recruited + "'s job now");
            }
         }
      }

      if (aiPlanGetState(repairPlan) < 0)
      {
         int repairSlot = wallSegmentSlot(perimeter, repairIndex);
         int restored = countWallsAlongSegment(perimeter, repairIndex);
         int reference = xsArrayGetInt(gWallSegmentWallCount, repairSlot);

         if ((restored * 100) >= (reference * cWallBreachTolerance))
         {
            xsArraySetInt(gWallSegmentRepairFails, repairSlot, 0);
            aiEcho("Wall section " + (repairIndex + 1) + " on perimeter " + perimeter + " repaired");
         }
         else
         {
            int fails = xsArrayGetInt(gWallSegmentRepairFails, repairSlot) + 1;
            xsArraySetInt(gWallSegmentRepairFails, repairSlot, fails);

            if (fails >= cWallRepairMaxFails)
            {
               xsArraySetInt(gWallSegmentWallCount, repairSlot, restored);
               aiEcho("Wall section " + (repairIndex + 1) + " on perimeter " + perimeter +
                      " cannot be fully rebuilt, accepting it as is");
            }
            else
            {
               aiEcho("Wall section " + (repairIndex + 1) + " on perimeter " + perimeter +
                      " only partly rebuilt, will try again");
            }
         }

         xsArraySetInt(gWallPerimeterRepairPlan, perimeter, -1);
         xsArraySetInt(gWallPerimeterRepairIndex, perimeter, -1);
      }
      else if ((xsGetTime() - xsArrayGetInt(gWallPerimeterRepairStart, perimeter)) > cWallSectionTimeout)
      {
         aiEcho("Wall repair on perimeter " + perimeter +
                " stalled, abandoning it - the next sweep will find it again");
         aiPlanDestroy(repairPlan);
         xsArraySetInt(gWallPerimeterRepairPlan, perimeter, -1);
         xsArraySetInt(gWallPerimeterRepairIndex, perimeter, -1);
      }
      else
      {
         return;
      }
   }

   int checks = cWallRepairChecksPerPass;
   if (checks > segCount)
   {
      checks = segCount;
   }

   int cursor = xsArrayGetInt(gWallPerimeterRepairCursor, perimeter);
   int index = -1;
   int slot = -1;

   for (int sweepIndex = 0; sweepIndex < checks; sweepIndex++)
   {
      if (cursor >= segCount)
      {
         cursor = 0;
      }
      index = cursor;
      cursor++;
      slot = wallSegmentSlot(perimeter, index);

      if (xsArrayGetInt(gWallSegmentNeeded, slot) == 1)
      {
         continue;
      }

      if (wallSegmentIsBreached(perimeter, index) == false)
      {
         continue;
      }

      if (xsArrayGetInt(gWallSegmentRepairFails, slot) >= cWallRepairMaxFails)
      {
         continue;
      }

      vector segStart = xsArrayGetVector(gWallSegmentStarts, slot);

      if (wallAreaIsHostile(segStart, 40.0) == true)
      {
         aiEcho("Wall section " + (index + 1) + " on perimeter " + perimeter +
                " is breached but the enemy is on it, waiting");
         continue;
      }

      bool hasGate = false;
      if (xsArrayGetInt(gWallSegmentGates, slot) == 1)
      {
         hasGate = true;
      }

      int newPlan = buildWall(segStart, xsArrayGetVector(gWallSegmentEnds, slot),
                              xsArrayGetInt(gWallPerimeterBaseID, perimeter),
                              xsArrayGetInt(gWallPerimeterPriority, perimeter),
                              hasGate, gWallPlanParentId);
      if (newPlan < 0)
      {
         continue;
      }

      int repairBuilder = xsArrayGetInt(gWallPerimeterRepairBuilder, perimeter);
      if (repairBuilder >= 0)
      {
         if ((kbUnitGetPlayerID(repairBuilder) != cMyID) || (kbUnitGetHealth(repairBuilder) <= 0.0))
         {
            repairBuilder = -1;
            xsArraySetInt(gWallPerimeterRepairBuilder, perimeter, -1);
         }
      }

      if (repairBuilder >= 0)
      {
         if (aiPlanAddUnit(newPlan, repairBuilder) == true)
         {
            aiPlanSetNoMoreUnits(newPlan, true);
         }
      }

      aiPlanSetActive(newPlan, true);

      xsArraySetInt(gWallPerimeterRepairPlan, perimeter, newPlan);
      xsArraySetInt(gWallPerimeterRepairIndex, perimeter, index);
      xsArraySetInt(gWallPerimeterRepairStart, perimeter, xsGetTime());
      xsArraySetInt(gWallPerimeterRepairCursor, perimeter, cursor);
      xsArraySetInt(gWallPerimeterRepairIdle, perimeter, 0);
      aiEcho("Wall section " + (index + 1) + " on perimeter " + perimeter +
             " destroyed, repairing it");
      return;
   }

   xsArraySetInt(gWallPerimeterRepairCursor, perimeter, cursor);

   int idleSweeps = xsArrayGetInt(gWallPerimeterRepairIdle, perimeter) + 1;
   xsArraySetInt(gWallPerimeterRepairIdle, perimeter, idleSweeps);

   if ((idleSweeps * cWallRepairChecksPerPass) >= segCount)
   {
      if (xsArrayGetInt(gWallPerimeterRepairBuilder, perimeter) >= 0)
      {
         aiEcho("Perimeter " + perimeter + " is intact, releasing the repair builder");
         xsArraySetInt(gWallPerimeterRepairBuilder, perimeter, -1);
      }
      xsArraySetInt(gWallPerimeterRepairIdle, perimeter, 0);
   }
}

void buildSquareWall(vector center = cInvalidVector, int baseId = -1, 
int wallPriority = 65, int numSections = 4, int perimeter = 0) {

   initWallPerimeterArrays();

   if (center == cInvalidVector)
   {
      aiEcho("Wall: refusing to plan perimeter " + perimeter + " around an invalid centre");
      return;
   }

   gWallQueueAttempts = 0;
   gWallDroppedInvalid = 0;
   gWallDroppedShort = 0;
   gWallDroppedFull = 0;

   int directions = gWallSquareDirections;

   if (directions < 0)
   {
      aiEcho("Wall: direction table missing, cannot plan perimeter " + perimeter);
      return;
   }

   vector lastSectionEnd = cInvalidVector;
   int sectionLength = 11;
   int maxIterations = 10;
   int wallDistance = numSections * sectionLength;
   xsArraySetInt(gWallPerimeterSegCount, perimeter, 0);
   xsArraySetInt(gWallPerimeterBuilt, perimeter, 0);
   xsArraySetInt(gWallPerimeterRepairCursor, perimeter, 0);
   xsArraySetInt(gWallPerimeterBaseID, perimeter, baseId);
   xsArraySetInt(gWallPerimeterPriority, perimeter, wallPriority);
   xsArraySetVector(gWallPerimeterCenter, perimeter, center);
   xsArraySetInt(gWallPerimeterRetries, perimeter, 0);

   for (int i = 0; i < 4; i++) {
      vector startLocation = center + xsArrayGetVector(directions, i) * wallDistance;
      vector endLocation = center + xsArrayGetVector(directions, (i + 1) % 4) * wallDistance;
      vector sectionVector = (endLocation - startLocation) / numSections;

      for (int j = 0; j < numSections; j++) {
         vector sectionStart = startLocation + sectionVector * j;
         vector sectionEnd = sectionStart + sectionVector;
         bool hasGate = false;

         if ((j % 3 == 0) || (j % 4 == 0)) {
            hasGate = true;
         }

         if (lastSectionEnd != cInvalidVector && sectionStart != lastSectionEnd) {
            vector gapStart = lastSectionEnd;
            vector gapEnd = sectionStart;
            queueWallSegment(perimeter, gapStart, gapEnd, hasGate);
         }

         lastSectionEnd = sectionEnd;

         if (wallTester(sectionStart) == false || wallTester(sectionEnd) == false) {

            float angle = 30.0;
            vector detourVector = rotateVector(sectionVector, angle);
            vector detourPoint = sectionStart + detourVector;
            int iterations = 0;

            while (wallTester(detourPoint) == false && iterations < maxIterations) {
               angle += 30.0;
               detourVector = rotateVector(sectionVector, angle);
               detourPoint = sectionStart + detourVector;
               iterations++;
            }

            queueWallSegment(perimeter, sectionStart, detourPoint, hasGate);
            queueWallSegment(perimeter, detourPoint, sectionEnd, false);
            lastSectionEnd = sectionEnd;
         } else {
            queueWallSegment(perimeter, sectionStart, sectionEnd, hasGate);
         }
      }
   }

   xsArraySetInt(gWallPerimeterBuildIndex, perimeter, 0);
   xsArraySetInt(gWallPerimeterActivePlan, perimeter, -1);
   xsArraySetInt(gWallPerimeterRepairPlan, perimeter, -1);
   xsArraySetInt(gWallPerimeterRepairIndex, perimeter, -1);

   int queued = xsArrayGetInt(gWallPerimeterSegCount, perimeter);
   if (queued <= 0)
   {
      aiEcho("Square wall perimeter " + perimeter + ": NONE queued, attempted=" +
             gWallQueueAttempts + " dropInvalid=" + gWallDroppedInvalid + " dropShort=" +
             gWallDroppedShort + " dropFull=" + gWallDroppedFull);
      return;
   }

   gWallBuildingSuccess = true;
   xsEnableRule("wallPlanSequencer");
   xsEnableRule("wallRepairMonitor");
   aiEcho("Square wall perimeter " + perimeter + ": queued=" + queued + " attempted=" +
          gWallQueueAttempts + " dropInvalid=" + gWallDroppedInvalid + " dropShort=" +
          gWallDroppedShort + " dropFull=" + gWallDroppedFull);
}

void buildPentagonWall(vector center = cInvalidVector, int baseId = -1, 
int wallPriority = 65, int numSections = 4, int perimeter = 0) {

   initWallPerimeterArrays();

   if (center == cInvalidVector)
   {
      aiEcho("Wall: refusing to plan perimeter " + perimeter + " around an invalid centre");
      return;
   }

   gWallQueueAttempts = 0;
   gWallDroppedInvalid = 0;
   gWallDroppedShort = 0;
   gWallDroppedFull = 0;

   int directions = gWallPentagonDirections;

   if (directions < 0)
   {
      aiEcho("Wall: direction table missing, cannot plan perimeter " + perimeter);
      return;
   }

   vector lastSectionEnd = cInvalidVector;
   int sectionLength = 11;
   int maxIterations = 10;
   int wallDistance = numSections * sectionLength;

   xsArraySetInt(gWallPerimeterSegCount, perimeter, 0);
   xsArraySetInt(gWallPerimeterBuilt, perimeter, 0);
   xsArraySetInt(gWallPerimeterRepairCursor, perimeter, 0);
   xsArraySetInt(gWallPerimeterBaseID, perimeter, baseId);
   xsArraySetInt(gWallPerimeterPriority, perimeter, wallPriority);
   xsArraySetVector(gWallPerimeterCenter, perimeter, center);
   xsArraySetInt(gWallPerimeterRetries, perimeter, 0);

   for (int i = 0; i < 5; i++) {
      vector startLocation = center + xsArrayGetVector(directions, i) * wallDistance;
      vector endLocation = center + xsArrayGetVector(directions, (i + 1) % 5) * wallDistance;
      vector sectionVector = (endLocation - startLocation) / numSections;

      for (int j = 0; j < numSections; j++) {
         vector sectionStart = startLocation + sectionVector * j;
         vector sectionEnd = sectionStart + sectionVector;
         bool hasGate = false;

         if (j == 3 || j == 7) {
            hasGate = true;
         }

         if (lastSectionEnd != cInvalidVector && sectionStart != lastSectionEnd) {
            vector gapStart = lastSectionEnd;
            vector gapEnd = sectionStart;
            queueWallSegment(perimeter, gapStart, gapEnd, hasGate);
         }

         lastSectionEnd = sectionEnd;

         if (wallTester(sectionStart) == false || wallTester(sectionEnd) == false) {

            float angle = 30.0;
            vector detourVector = rotateVector(sectionVector, angle);
            vector detourPoint = sectionStart + detourVector;
            int iterations = 0;

            while (wallTester(detourPoint) == false && iterations < maxIterations) {
               angle += 30.0;
               detourVector = rotateVector(sectionVector, angle);
               detourPoint = sectionStart + detourVector;
               iterations++;
            }

            queueWallSegment(perimeter, sectionStart, detourPoint, hasGate);
            queueWallSegment(perimeter, detourPoint, sectionEnd, false);
            lastSectionEnd = sectionEnd;
         } else {
            queueWallSegment(perimeter, sectionStart, sectionEnd, hasGate);
         }
      }
   }

   xsArraySetInt(gWallPerimeterBuildIndex, perimeter, 0);
   xsArraySetInt(gWallPerimeterActivePlan, perimeter, -1);
   xsArraySetInt(gWallPerimeterRepairPlan, perimeter, -1);
   xsArraySetInt(gWallPerimeterRepairIndex, perimeter, -1);

   int queued = xsArrayGetInt(gWallPerimeterSegCount, perimeter);
   if (queued <= 0)
   {
      aiEcho("Pentagon wall: no buildable sections found for perimeter " + perimeter);
      return;
   }

   gWallBuildingSuccess = true;
   xsEnableRule("wallPlanSequencer");
   xsEnableRule("wallRepairMonitor");
   aiEcho("Pentagon wall perimeter " + perimeter + ": queued=" + queued + " attempted=" +
          gWallQueueAttempts);
}

rule enhancedWalls
inactive
minInterval 20
{
   initWallPerimeterArrays();

   if (xsArrayGetInt(gWallPerimeterSegCount, cWallPerimeterMain) > 0)
   {
      xsDisableSelf();
      return;
   }

   static int lastMainGate = -1;
   int mainGate = 0;
   if (kbGetAge() < cAge4)
   {
      mainGate = 1;
   }
   else if (gExcessResources == false)
   {
      mainGate = 2;
   }
   else if (kbResourceGet(cResourceWood) < 1200)
   {
      mainGate = 3;
   }

   if (mainGate != 0)
   {
      if (mainGate != lastMainGate)
      {
         lastMainGate = mainGate;
         aiEcho("MAIN WALL blocked, gate " + mainGate +
                " (1=age 2=excessResources 3=wood) wood=" + kbResourceGet(cResourceWood));
      }
      return;
   }

   if (lastMainGate != 0)
   {
      lastMainGate = 0;
      aiEcho("MAIN WALL gates clear, queueing now");
   }

   vector myBaseLoc = kbBaseGetLocation(cMyID, kbBaseGetMainID(cMyID));

   int mainAreaID = kbAreaGetIDByPosition(myBaseLoc);
   vector mainBaseCenter = myBaseLoc;
   if (mainAreaID >= 0)
   {
      vector areaCenter = kbAreaGetCenter(mainAreaID);
      if (areaCenter != cInvalidVector)
      {
         mainBaseCenter = areaCenter;
      }
   }

   aiEcho("MAIN WALL centre=" + mainBaseCenter + " areaID=" + mainAreaID +
          " baseLoc=" + myBaseLoc);

   buildSquareWall(mainBaseCenter, kbBaseGetMainID(cMyID), 100, 9, cWallPerimeterMain);

   int mainQueued = xsArrayGetInt(gWallPerimeterSegCount, cWallPerimeterMain);
   aiEcho("MAIN WALL buildSquareWall returned, perimeter " + cWallPerimeterMain +
          " now has " + mainQueued + " sections");

   if (mainQueued > 0) {
      sendStatement(cPlayerRelationAllyExcludingSelf, cAICommPromptToAllyWhenIWallIn);
      xsDisableSelf();
   }
}
rule buildWalls
inactive
minInterval 30
{
   float wallRadius = 75.0;
   if (gIslandMap == true) {
      wallRadius = 95.0;
   }

   if (kbGetAge() < cAge4 || gExcessResources == false || kbResourceGet(cResourceWood) < 1200) {
      return;
   }

   if (kbResourceGet(cResourceWood) <= 2000.0) {
      return;
   }

   int wallPlanID=aiPlanCreate("WallInBase", cPlanBuildWall);
   if (wallPlanID != -1)
   {
      aiPlanSetVariableInt(wallPlanID, cBuildWallPlanWallType, 0, cBuildWallPlanWallTypeRing);
      aiPlanAddUnitType(wallPlanID, gEconUnit, 0, 1, 1);
      aiPlanSetVariableVector(wallPlanID, cBuildWallPlanWallRingCenterPoint, 0, kbBaseGetLocation(cMyID, kbBaseGetMainID(cMyID)));
      aiPlanSetVariableFloat(wallPlanID, cBuildWallPlanWallRingRadius, 0.0, wallRadius);
      aiPlanSetVariableInt(wallPlanID, cBuildWallPlanNumberOfGates, 0, 15);
      aiPlanSetBaseID(wallPlanID, kbBaseGetMainID(cMyID));
      aiPlanSetEscrowID(wallPlanID, cEconomyEscrowID);
      aiPlanSetDesiredPriority(wallPlanID, 100);
      aiPlanSetActive(wallPlanID, true);
      xsEnableRule("fillInWallGaps");
      aiEcho("Enabling Wall Plan for Base ID: "+kbBaseGetMainID(cMyID));
      sendStatement(cPlayerRelationAllyExcludingSelf, cAICommPromptToAllyWhenIWallIn);
   } 
   xsDisableSelf();
}
rule fillInWallGaps
  minInterval 51
  inactive
{
   float wallRadius = 75.0;
   if (gIslandMap == true) {
      wallRadius = 95.0;
   }

  if(aiPlanGetIDByTypeAndVariableType(cPlanBuildWall, cBuildWallPlanWallType, cBuildWallPlanWallTypeRing, true) >= 1)
      return;

   if (kbResourceGet(cResourceWood) <= 2000.0) {
      return;
   }

   int wallPlanID=aiPlanCreate("fillInWallGaps", cPlanBuildWall);
   if (wallPlanID != -1)
   {
         aiPlanSetVariableInt(wallPlanID, cBuildWallPlanWallType, 0, cBuildWallPlanWallTypeRing);
         aiPlanAddUnitType(wallPlanID, gEconUnit, 0, 1, 2);
         aiPlanSetVariableVector(wallPlanID, cBuildWallPlanWallRingCenterPoint, 0, kbBaseGetLocation(cMyID, kbBaseGetMainID(cMyID)));
         aiPlanSetVariableFloat(wallPlanID, cBuildWallPlanWallRingRadius, 0.0, wallRadius);
         aiPlanSetVariableInt(wallPlanID, cBuildWallPlanNumberOfGates, 0, 15);
         aiPlanSetBaseID(wallPlanID, kbBaseGetMainID(cMyID));
         aiPlanSetEscrowID(wallPlanID, cEconomyEscrowID);
         aiPlanSetDesiredPriority(wallPlanID, 65);
         aiPlanSetActive(wallPlanID, true);
   }
}
rule bastionUpgradeMonitor
inactive
minInterval 90
{
   int upgradePlanID = -1;
   int myWallId = getUnit(cUnitTypeAbstractWall, cMyID);

   if ((kbTechGetStatus(cTechBastion) == cTechStatusActive))
   {
      xsDisableSelf();
      return;
   }

   researchSimpleTechByCondition(cTechBastion, 
   []() -> bool { return (kbTechGetStatus(cTechBastion) == cTechStatusObtainable); },
   cUnitTypeAbstractWall, myWallId, 55);
}
rule factoryWall
inactive
minInterval 30
{
   int factoriesQuery = createSimpleUnitQuery(cUnitTypeFactory, cMyID, cUnitStateABQ);
   int factoriesFound = kbUnitQueryExecute(factoriesQuery);

   if (factoriesFound > 0) {
      vector factoryPos = kbUnitGetPosition(kbUnitQueryGetResult(factoriesQuery, 0));
      kbUnitQueryDestroy(factoriesQuery);

      int wallPlanID = aiPlanCreate("Factory Wall", cPlanBuildWall);
      int numberOfGates = 4;
      float baseWallRadius = 12.0;
      vector baseWallCenter = factoryPos;

      if (wallPlanID != -1)
      {
         aiPlanSetVariableInt(wallPlanID, cBuildWallPlanWallType, 0, cBuildWallPlanWallTypeRing);
         aiPlanAddUnitType(wallPlanID, cUnitTypeAbstractVillager, 1, 1, 1);
         aiPlanSetVariableVector(wallPlanID, cBuildWallPlanWallRingCenterPoint, 0, baseWallCenter);
         aiPlanSetVariableInt(wallPlanID, cBuildPlanLocationPreference, 0, cBuildingPlacementPreferenceFront);
         aiPlanSetVariableFloat(wallPlanID, cBuildWallPlanWallRingRadius, 0, baseWallRadius);
         aiPlanSetVariableInt(wallPlanID, cBuildWallPlanNumberOfGates, 0, numberOfGates);
         aiPlanSetBaseID(wallPlanID, kbBaseGetMainID(cMyID));
         aiPlanSetEscrowID(wallPlanID, cEconomyEscrowID);
         aiPlanSetDesiredPriority(wallPlanID, 55);
         aiPlanSetActive(wallPlanID, true);
         debugBuildings("Enabling Factory Wall Plan for Base ID: " + kbBaseGetMainID(cMyID));
         xsDisableSelf();
      }
   }
}
rule fortUpgradeMonitor
inactive
minInterval 90
{
   int upgradePlanID = -1;
   int myFortId = getUnit(cUnitTypeFortFrontier, cMyID);

   if ((kbTechGetStatus(cTechRevetment) == cTechStatusActive) && (kbTechGetStatus(cTechStarFort) == cTechStatusActive))
   {
      xsDisableSelf();
      return;
   }

   researchSimpleTechByCondition(cTechRevetment, 
   []() -> bool { return (kbTechGetStatus(cTechRevetment) == cTechStatusObtainable); },
   cUnitTypeFortFrontier, myFortId, 55);
   researchSimpleTechByCondition(cTechStarFort, 
   []() -> bool { return (kbTechGetStatus(cTechStarFort) == cTechStatusObtainable); },
   cUnitTypeFortFrontier, myFortId, 55);
}
rule forwardBaseWall
inactive
minInterval 30
{
   if (kbGetAge() < cAge5)
   {
      return;
   }

   if (gForwardBaseState == cForwardBaseStateNone || gForwardBaseID == -1)
   {
      return;
   } else if (distance(kbBaseGetLocation(cMyID, kbBaseGetMainID(cMyID)), 
               kbBaseGetLocation(cMyID, gForwardBaseID)) < 20.0) {
      xsDisableSelf();
      return;
   }

   if (gForwardBaseState == cForwardBaseStateNone || gExcessResources == false || kbResourceGet(cResourceWood) < 1200)
   {
      return;
   }

   initWallPerimeterArrays();

   if (xsArrayGetInt(gWallPerimeterSegCount, cWallPerimeterForward) <= 0)
   {
      buildSquareWall(gForwardBaseLocation, gForwardBaseID, 100, 3, cWallPerimeterForward);
      if (xsArrayGetInt(gWallPerimeterSegCount, cWallPerimeterForward) > 0)
      {
         sendStatement(cPlayerRelationAllyExcludingSelf, cAICommPromptToAllyWhenIWallIn);
         debugBuildings("Enabling forward base wall for Base ID: " + gForwardBaseID);
      }
   }

   xsEnableRule("forwardBaseStables");
   xsEnableRule("forwardBaseTowers");
   updateSecondaryBaseMilitaryTrainPlans(gForwardBaseID);

   if (xsArrayGetInt(gWallPerimeterSegCount, cWallPerimeterForward) > 0)
   {
      xsDisableSelf();
   }
}
rule forwardBaseStables
inactive
minInterval 30
{
   if (kbGetAge() < cAge5)
   {
      return;
   }

   if (gForwardBaseState == cForwardBaseStateNone || gExcessResources == false || kbResourceGet(cResourceWood) < 1800)
   {
      return;
   }

   int forwardBaseStablesVal = kbUnitQueryExecute(createSimpleUnitQuery(gStablesUnit, cMyID, 
   cUnitStateABQ, gForwardBaseLocation, 120.0));
   int forwardBaseBarracksVal = kbUnitQueryExecute(createSimpleUnitQuery(cUnitTypeBarracks, cMyID, 
   cUnitStateABQ, gForwardBaseLocation, 120.0));
   aiEcho("Stables: "+forwardBaseStablesVal+" Base State: "+gForwardBaseState+"");
   
   if (gForwardBaseState == cForwardBaseStateActive && forwardBaseStablesVal < 1
      && aiPlanGetActive(gForwardBaseStablesPlan) == false) {
      aiPlanDestroy(gForwardBaseStablesPlan);
      gForwardBaseStablesPlan = createSpacedLocationBuildPlan(gStablesUnit, 1, 45, true, cMilitaryEscrowID, gForwardBaseLocation, 1);
      aiEcho("Stables Plan created!");
   } else if (gForwardBaseState == cForwardBaseStateActive && forwardBaseStablesVal > 0) {
      if (kbBaseGetActive(cMyID, gIslandBaseID) == true) {
         updateSecondaryBaseMilitaryTrainPlans(gIslandBaseID);
      } else {
         updateSecondaryBaseMilitaryTrainPlans(gForwardBaseID);
      }
   }
   if (gForwardBaseState == cForwardBaseStateActive && forwardBaseBarracksVal < 1
      && aiPlanGetActive(gForwardBaseBarracksPlan) == false) {
      aiPlanDestroy(gForwardBaseBarracksPlan);
      gForwardBaseBarracksPlan = createSpacedLocationBuildPlan(cUnitTypeBarracks, 1, 75, true, cMilitaryEscrowID, gForwardBaseLocation, 1);
      aiEcho("Barracks Plan created!");
   } else if (gForwardBaseState == cForwardBaseStateActive && forwardBaseBarracksVal > 0) {
      if (kbBaseGetActive(cMyID, gIslandBaseID) == true) {
         updateSecondaryBaseMilitaryTrainPlans(gIslandBaseID);
      } else {
         updateSecondaryBaseMilitaryTrainPlans(gForwardBaseID);
      }
   }
}
rule forwardBaseTowers
inactive
minInterval 30
{
   if (kbGetAge() < cAge5)
   {
      return;
   }

   int forwardBaseTowersVal = kbUnitQueryExecute(createSimpleUnitQuery(gTowerUnit, cMyID, cUnitStateABQ, 
   gForwardBaseLocation, 90.0));
   int additionalTowersAvailable = kbGetBuildLimit(cMyID, gTowerUnit) - kbUnitQueryExecute(createSimpleUnitQuery(gTowerUnit, cMyID, cUnitStateABQ));
   if (gForwardBaseState == cForwardBaseStateNone || gExcessResources == false || kbResourceGet(cResourceWood) < 1600)
   {
      return;
   }

   if (additionalTowersAvailable > 3) {
      additionalTowersAvailable = 3;
   }

   if (gForwardBaseState == cForwardBaseStateActive && forwardBaseTowersVal < 1 &&
      (aiPlanGetIDByTypeAndVariableType(cPlanBuild, cBuildPlanBuildingTypeID, gTowerUnit, true) < 0) &&
      (aiPlanGetIDByTypeAndVariableType(cPlanBuild, cBuildPlanBuildingTypeID, gTowerUnit, false) < 0)) {
      createSpacedLocationBuildPlan(gTowerUnit, 2, 50, true, cMilitaryEscrowID, gForwardBaseLocation, 1);
   }
}
rule maxTowerManager
inactive
minInterval 20
{
   int limit = kbGetBuildLimit(cMyID, gTowerUnit);
   int unitQuery = createSimpleUnitQuery(gTowerUnit, cMyID, cUnitStateABQ);
   int numberFound = kbUnitQueryExecute(unitQuery);
   int age = kbGetAge();
   if ((numberFound < limit) && (age >= cAge4) &&
      (aiPlanGetIDByTypeAndVariableType(cPlanBuild, cBuildPlanBuildingTypeID, gTowerUnit, true) < 0) &&
      (aiPlanGetIDByTypeAndVariableType(cPlanBuild, cBuildPlanBuildingTypeID, gTowerUnit, false) < 0))
   {
      createSimpleBuildPlan(gTowerUnit, 1, 55, false, cMilitaryEscrowID, kbBaseGetMainID(cMyID), 1);
   }
   updateWantedTowers();
}
rule establishTradePostsWithNatives
inactive
minInterval 30
{
   int unitQuery = createSimpleUnitQuery(cUnitTypeSocket, cPlayerRelationAny, cUnitStateAny);
   int numberFound = kbUnitQueryExecute(unitQuery);
   vector mainBaseVec = kbBaseGetLocation(cMyID, kbBaseGetMainID(cMyID));
   int mainBaseGroupId = kbAreaGroupGetIDByPosition(mainBaseVec);
   vector unitLocation = cInvalidVector;
   int unitLocationId = -1;
   int unitLocationGroupId = -1;
   int unitID = -1;

   for (i = 0; < numberFound) {
      unitID = kbUnitQueryGetResult(unitQuery, i);
      unitLocation = kbUnitGetPosition(unitID);
      unitLocationId = kbAreaGetIDByPosition(unitLocation);
      unitLocationGroupId = kbAreaGroupGetIDByPosition(unitLocation);
      if (getUnitByLocation(cUnitTypeTradingPost, cPlayerRelationAny, cUnitStateABQ, unitLocation, 10.0) > 0)
      {
         continue;
      } else if (kbAreAreaGroupsPassableByLand(mainBaseGroupId, unitLocationGroupId) == true) {
         unitLocation = kbUnitGetPosition(unitID);
      }
   }
   
   if (unitLocation != cInvalidVector && aiPlanGetActive(gTradePostBuildingPlan) == false) {
      aiPlanDestroy(gTradePostBuildingPlan);
      gTradePostBuildingPlan = aiPlanCreate("Trading Post Build Plan", cPlanBuild);
      aiPlanSetVariableInt(gTradePostBuildingPlan, cBuildPlanBuildingTypeID, 0, cUnitTypeTradingPost);
      aiPlanSetVariableInt(gTradePostBuildingPlan, cBuildPlanSocketID, 0, unitID);

      int villagerQuery = createSimpleUnitQuery(cUnitTypeAbstractVillager, cMyID, cUnitStateAlive);
      aiPlanAddUnitType(gTradePostBuildingPlan, cUnitTypeAbstractVillager, 1, 1, 1);
      aiPlanAddUnit(gTradePostBuildingPlan, kbUnitQueryGetResult(villagerQuery, 0));
      aiPlanSetDesiredPriority(gTradePostBuildingPlan, 55);
      aiPlanSetActive(gTradePostBuildingPlan);
   }
}
rule lakotaTeePeeManager
active
minInterval 20
{
   if (cMyCiv != cCivXPSioux)
   {
      xsDisableSelf();
      return;
   }
   int limit = kbGetBuildLimit(cMyID, cUnitTypeTeepee);
   int unitQuery = createSimpleUnitQuery(cUnitTypeTeepee, cMyID, cUnitStateABQ);
   int numberFound = kbUnitQueryExecute(unitQuery);
   int age = kbGetAge();

   if (age == cAge1) {
      limit = 1;
   } else if (age == cAge2) {
      limit = 3;
   } else if (age == cAge3) {
      limit = 7;
   }

   if (numberFound < limit && aiPlanGetIDByTypeAndVariableType(cPlanBuild, cBuildPlanBuildingTypeID, cUnitTypeTeepee) < 0)
   {
      createSimpleBuildPlan(cUnitTypeTeepee, 1, 55, false, cEconomyEscrowID, kbBaseGetMainID(cMyID), 1);
   }
}

rule wallPlanSequencer
inactive
minInterval 5
{
   int working = 0;

   for (int buildPerimeter = 0; buildPerimeter < cMaxWallPerimeters; buildPerimeter++)
   {
      if (xsArrayGetInt(gWallPerimeterSegCount, buildPerimeter) <= 0)
      {
         continue;
      }
      if (xsArrayGetInt(gWallPerimeterBuilt, buildPerimeter) == 1)
      {
         continue;
      }

      working++;
      advanceWallPerimeter(buildPerimeter);
   }

   static int lastWallReport = 0;
   if ((xsGetTime() - lastWallReport) > 30000)
   {
      lastWallReport = xsGetTime();
      aiEcho("WALLS p0 seg=" + xsArrayGetInt(gWallPerimeterSegCount, 0) +
             " idx=" + xsArrayGetInt(gWallPerimeterBuildIndex, 0) +
             " plan=" + xsArrayGetInt(gWallPerimeterActivePlan, 0) +
             " built=" + xsArrayGetInt(gWallPerimeterBuilt, 0) +
             " bldr=" + xsArrayGetInt(gWallPerimeterBuilderID, 0) +
             " why=" + xsArrayGetInt(gWallPerimeterDiag, 0) +
             " | p1 seg=" + xsArrayGetInt(gWallPerimeterSegCount, 1) +
             " idx=" + xsArrayGetInt(gWallPerimeterBuildIndex, 1) +
             " plan=" + xsArrayGetInt(gWallPerimeterActivePlan, 1) +
             " built=" + xsArrayGetInt(gWallPerimeterBuilt, 1) +
             " bldr=" + xsArrayGetInt(gWallPerimeterBuilderID, 1) +
             " why=" + xsArrayGetInt(gWallPerimeterDiag, 1));
   }

   if (working == 0)
   {
      xsDisableSelf();
   }
}

rule wallRepairMonitor
inactive
minInterval 30
{
   int watching = 0;

   for (int repairPerimeter = 0; repairPerimeter < cMaxWallPerimeters; repairPerimeter++)
   {
      if (xsArrayGetInt(gWallPerimeterSegCount, repairPerimeter) <= 0)
      {
         continue;
      }

      watching++;
      repairWallPerimeter(repairPerimeter);
   }

   if (watching == 0)
   {
      xsDisableSelf();
   }
}

int wagonBuildDesiredCount(int puid = -1)
{
   if ((puid == cUnitTypeArsenal) || (puid == cUnitTypeypArsenalAsian))
   {
      return (1);
   }

   if ((puid == gFarmUnit) || (puid == gPlantationUnit) || (puid == cUnitTypeMill) ||
       (puid == cUnitTypeypRicePaddy))
   {
      int wanted = kbUnitCount(cMyID, gEconUnit, cUnitStateABQ) / cMaxSettlersPerFarm;
      if (wanted < 1)
      {
         wanted = 1;
      }
      return (wanted);
   }

   return (0);
}

rule idleWagonMonitor
inactive
minInterval 90
{
   if (cvOkToBuild == false)
   {
      return;
   }

   int mainBaseID = kbBaseGetMainID(cMyID);
   if (mainBaseID < 0)
   {
      return;
   }

   if (gWagonBuildOptions < 0)
   {
      gWagonBuildOptions = xsArrayCreateInt(60, -1, "Wagon build options");
      xsArraySetInt(gWagonBuildOptions, 0, cUnitTypeFactory);
      xsArraySetInt(gWagonBuildOptions, 1, cUnitTypeFortFrontier);
      xsArraySetInt(gWagonBuildOptions, 2, cUnitTypeCapitol);
      xsArraySetInt(gWagonBuildOptions, 3, cUnitTypedeStateCapitol);
      xsArraySetInt(gWagonBuildOptions, 4, cUnitTypeBank);
      xsArraySetInt(gWagonBuildOptions, 5, cUnitTypeypBankAsian);
      xsArraySetInt(gWagonBuildOptions, 6, cUnitTypedeLombard);
      xsArraySetInt(gWagonBuildOptions, 7, cUnitTypeTownCenter);
      xsArraySetInt(gWagonBuildOptions, 8, cUnitTypedeCustomsHouse);
      xsArraySetInt(gWagonBuildOptions, 9, cUnitTypedeSejm);
      xsArraySetInt(gWagonBuildOptions, 10, cUnitTypedeFolwark);
      xsArraySetInt(gWagonBuildOptions, 11, cUnitTypeypCastle);
      xsArraySetInt(gWagonBuildOptions, 12, cUnitTypedeUniversity);
      xsArraySetInt(gWagonBuildOptions, 13, cUnitTypeArsenal);
      xsArraySetInt(gWagonBuildOptions, 14, cUnitTypeypArsenalAsian);
      xsArraySetInt(gWagonBuildOptions, 15, cUnitTypeTradingPost);
      xsArraySetInt(gWagonBuildOptions, 16, cUnitTypeNativeEmbassy);
      xsArraySetInt(gWagonBuildOptions, 17, cUnitTypeChurch);
      xsArraySetInt(gWagonBuildOptions, 18, cUnitTypedeChurchDanish);
      xsArraySetInt(gWagonBuildOptions, 19, cUnitTypedeChurchPolish);
      xsArraySetInt(gWagonBuildOptions, 20, cUnitTypeypMonastery);
      xsArraySetInt(gWagonBuildOptions, 21, cUnitTypedeCathedral);
      xsArraySetInt(gWagonBuildOptions, 22, cUnitTypedeMountainMonastery);
      xsArraySetInt(gWagonBuildOptions, 23, gMarketUnit);
      xsArraySetInt(gWagonBuildOptions, 24, cUnitTypeypTradeMarketAsian);
      xsArraySetInt(gWagonBuildOptions, 25, gDockUnit);
      xsArraySetInt(gWagonBuildOptions, 26, cUnitTypeYPDockAsian);
      xsArraySetInt(gWagonBuildOptions, 27, gPlantationUnit);
      xsArraySetInt(gWagonBuildOptions, 28, gFarmUnit);
      xsArraySetInt(gWagonBuildOptions, 29, cUnitTypeypRicePaddy);
      xsArraySetInt(gWagonBuildOptions, 30, cUnitTypeMill);
      xsArraySetInt(gWagonBuildOptions, 31, gLivestockPenUnit);
      xsArraySetInt(gWagonBuildOptions, 32, cUnitTypeCorral);
      xsArraySetInt(gWagonBuildOptions, 33, cUnitTypeSaloon);
      xsArraySetInt(gWagonBuildOptions, 34, cUnitTypedeTavern);
      xsArraySetInt(gWagonBuildOptions, 35, cUnitTypeArtilleryDepot);
      xsArraySetInt(gWagonBuildOptions, 36, cUnitTypeBarracks);
      xsArraySetInt(gWagonBuildOptions, 37, cUnitTypeStable);
      xsArraySetInt(gWagonBuildOptions, 38, cUnitTypeypWarAcademy);
      xsArraySetInt(gWagonBuildOptions, 39, cUnitTypeypBarracksJapanese);
      xsArraySetInt(gWagonBuildOptions, 40, cUnitTypeypStableJapanese);
      xsArraySetInt(gWagonBuildOptions, 41, cUnitTypeYPBarracksIndian);
      xsArraySetInt(gWagonBuildOptions, 42, cUnitTypeWarHut);
      xsArraySetInt(gWagonBuildOptions, 43, cUnitTypeBlockhouse);
      xsArraySetInt(gWagonBuildOptions, 44, cUnitTypedeWarCamp);
      xsArraySetInt(gWagonBuildOptions, 45, cUnitTypeNoblesHut);
      xsArraySetInt(gWagonBuildOptions, 46, cUnitTypeCommunityPlaza);
      xsArraySetInt(gWagonBuildOptions, 47, gTowerUnit);
      xsArraySetInt(gWagonBuildOptions, 48, cUnitTypeOutpost);
      xsArraySetInt(gWagonBuildOptions, 49, cUnitTypeYPOutpostAsian);
      xsArraySetInt(gWagonBuildOptions, 50, gHouseUnit);
      xsArraySetInt(gWagonBuildOptions, 51, cUnitTypedeHospital);
      xsArraySetInt(gWagonBuildOptions, 52, cUnitTypedeCommandery);
      xsArraySetInt(gWagonBuildOptions, 53, cUnitTypedePalace);
      xsArraySetInt(gWagonBuildOptions, 54, cUnitTypedeKallanka);
      xsArraySetInt(gWagonBuildOptions, 55, cUnitTypeypCaravanserai);
      xsArraySetInt(gWagonBuildOptions, 56, cUnitTypedeDepot);
      xsArraySetInt(gWagonBuildOptions, 57, cUnitTypedeMineSaltBuildable);
      xsArraySetInt(gWagonBuildOptions, 58, cUnitTypedeGranary);
      xsArraySetInt(gWagonBuildOptions, 59, cUnitTypedeFurTrade);
      gWagonBuildOptionCount = 60;
   }

   static int wagonStuckIDs = -1;
   static int wagonStuckPlans = -1;
   static int wagonStuckCount = 0;
   if (wagonStuckIDs < 0)
   {
      wagonStuckIDs = xsArrayCreateInt(cMaxTrackedWagons, -1, "Stalled wagon IDs");
      wagonStuckPlans = xsArrayCreateInt(cMaxTrackedWagons, -1, "Stalled wagon plans");
   }

   int wagonQuery = createSimpleUnitQuery(cUnitTypeAbstractWagon, cMyID, cUnitStateAlive);
   int numberFound = kbUnitQueryExecute(wagonQuery);

   for (int wagonIndex = 0; wagonIndex < numberFound; wagonIndex++)
   {
      int wagonID = kbUnitQueryGetResult(wagonQuery, wagonIndex);
      int wagonPlanID = kbUnitGetPlanID(wagonID);
      if (wagonPlanID >= 0)
      {
         if (aiPlanGetType(wagonPlanID) != cPlanBuild)
         {
            continue;
         }

         bool stalledLastPass = false;
         for (int stuckIndex = 0; stuckIndex < wagonStuckCount; stuckIndex++)
         {
            if ((xsArrayGetInt(wagonStuckIDs, stuckIndex) == wagonID) &&
               (xsArrayGetInt(wagonStuckPlans, stuckIndex) == wagonPlanID))
            {
               stalledLastPass = true;
               break;
            }
         }
         if (stalledLastPass == false)
         {
            continue;
         }
         aiEcho("Wagon " + wagonID + " stalled in build plan " + wagonPlanID + ", releasing it.");
         aiPlanDestroy(wagonPlanID);
      }

      int wagonProto = kbUnitGetProtoUnitID(wagonID);
      int buildPUID = -1;

      for (int optionIndex = 0; optionIndex < gWagonBuildOptionCount; optionIndex++)
      {
         int candidate = xsArrayGetInt(gWagonBuildOptions, optionIndex);
         if (candidate < 0)
         {
            continue;
         }
         if (kbProtoUnitAvailable(candidate) == false)
         {
            continue;
         }
         int candidateLimit = kbGetBuildLimit(cMyID, candidate);

         int desiredCount = wagonBuildDesiredCount(candidate);
         if (desiredCount > 0)
         {
            if ((candidateLimit < 1) || (desiredCount < candidateLimit))
            {
               candidateLimit = desiredCount;
            }
         }

         if (candidateLimit >= 1)
         {
            if ((kbUnitCount(cMyID, candidate, cUnitStateABQ) +
               aiPlanGetNumberByTypeAndVariableType(cPlanBuild, cBuildPlanBuildingTypeID, candidate, true)) >= candidateLimit)
            {
               continue;
            }
         }
         if (kbProtoUnitCanTrain(wagonProto, candidate) == false)
         {
            continue;
         }
         buildPUID = candidate;
         break;
      }

      if (buildPUID < 0)
      {
         continue;
      }

      if ((buildPUID == cUnitTypeFortFrontier) && (gForwardBaseState != cForwardBaseStateActive))
      {
         continue;
      }

      int planID = aiPlanCreate("Idle Wagon Build " + kbGetProtoUnitName(buildPUID), cPlanBuild);
      if (planID < 0)
      {
         continue;
      }

      aiPlanSetVariableInt(planID, cBuildPlanBuildingTypeID, 0, buildPUID);
      aiPlanAddUnitType(planID, wagonProto, 1, 1, 1);
      aiPlanSetBaseID(planID, mainBaseID);
      aiPlanSetEscrowID(planID, cEconomyEscrowID);
      aiPlanSetDesiredPriority(planID, 100);
      static int wagonPlacementTries = 0;
      float placementRange = 70.0 + (wagonPlacementTries * 40.0);
      if (placementRange > 190.0)
      {
         placementRange = 190.0;
      }
      wagonPlacementTries++;
      aiPlanSetVariableVector(planID, cBuildPlanCenterPosition, 0, kbBaseGetLocation(cMyID, mainBaseID));
      aiPlanSetVariableFloat(planID, cBuildPlanCenterPositionDistance, 0, placementRange);

      if ((buildPUID == cUnitTypeFortFrontier) || (buildPUID == gTowerUnit))
      {
         aiPlanSetVariableInt(planID, cBuildPlanLocationPreference, 0, cBuildingPlacementPreferenceFront);
      }

      if (aiPlanAddUnit(planID, wagonID) == false)
      {
         aiPlanDestroy(planID);
         continue;
      }

      aiPlanSetActive(planID, true);
      aiEcho("Idle " + kbGetProtoUnitName(wagonProto) + " sent to build " + kbGetProtoUnitName(buildPUID));
   }

   wagonStuckCount = 0;
   for (int recordIndex = 0; recordIndex < numberFound; recordIndex++)
   {
      if (wagonStuckCount >= cMaxTrackedWagons)
      {
         break;
      }
      int recordWagonID = kbUnitQueryGetResult(wagonQuery, recordIndex);
      int recordPlanID = kbUnitGetPlanID(recordWagonID);
      if ((recordPlanID < 0) || (aiPlanGetType(recordPlanID) != cPlanBuild))
      {
         continue;
      }
      xsArraySetInt(wagonStuckIDs, wagonStuckCount, recordWagonID);
      xsArraySetInt(wagonStuckPlans, wagonStuckCount, recordPlanID);
      wagonStuckCount++;
   }
}
