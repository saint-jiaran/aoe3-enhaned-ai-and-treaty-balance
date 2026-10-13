extern const int cCoordAttackRallyLifetime = 45000;

extern const int cCoordAttackMissionTimeout = 300000;

extern const int cCoordAttackJoinCooldown = 150000;

extern const int cCoordAttackBroadcastCooldown = 90000;

extern const float cCoordAttackDupeRadius = 45.0;

extern const float cCoordAttackStageDistance = 55.0;

extern const float cCoordAttackMaxTravel = 260.0;

extern const int cCoordAttackMinJoinPop = 8;

extern const float cCoordAttackArmySpeed = 3.6;

extern const int cCoordAttackMaxStageWait = 60000;

extern const int cCoordAttackNavalJoinCooldown = 120000;
extern const int cCoordAttackNavalBroadcastCooldown = 90000;
extern const int cCoordAttackNavalTimeout = 240000;
extern const int cCoordAttackMinJoinWarships = 3;
extern const int cCoordAttackWarshipBusyPriority = 80;

extern const int cCoordAttackMinExpeditionUnits = 4;
extern const int cCoordAttackExpeditionCooldown = 120000;
extern const int cCoordAttackExpeditionTimeout = 300000;
extern const int cCoordAttackExpeditionBusyPriority = 80;

extern const int cCoordAttackStateIdle = 0;
extern const int cCoordAttackStateStaging = 1;
extern const int cCoordAttackStateCommitted = 2;

extern int gCoordAttackState = 0;
extern int gCoordAttackPlanID = -1;
extern vector gCoordAttackTargetVec = cInvalidVector;
extern vector gCoordAttackStageVec = cInvalidVector;
extern int gCoordAttackTargetPlayer = -1;
extern int gCoordAttackTargetBaseID = -1;
extern int gCoordAttackFromPlayer = -1;
extern int gCoordAttackCommitTime = -1;
extern int gCoordAttackExpireTime = -1;
extern int gCoordAttackLastJoinTime = -1;
extern int gCoordAttackLastBroadcastTime = -1;
extern vector gCoordAttackLastRallyVec = cInvalidVector;
extern int gCoordAttackLastRallyTime = -1;

extern int gCoordAttackNavalPlanID = -1;
extern vector gCoordAttackNavalVec = cInvalidVector;
extern int gCoordAttackNavalFromPlayer = -1;
extern int gCoordAttackNavalExpireTime = -1;
extern int gCoordAttackLastNavalJoinTime = -1;
extern int gCoordAttackLastNavalBroadcastTime = -1;
extern vector gCoordAttackLastNavalRallyVec = cInvalidVector;
extern int gCoordAttackLastNavalRallyTime = -1;

extern vector gCoordAttackExpeditionVec = cInvalidVector;
extern int gCoordAttackExpeditionFromPlayer = -1;
extern int gCoordAttackExpeditionExpireTime = -1;
extern int gCoordAttackLastExpeditionJoinTime = -1;
extern vector gCoordAttackLastExpeditionRallyVec = cInvalidVector;
extern int gCoordAttackLastExpeditionRallyTime = -1;

int coordAttackTravelTime(vector fromVec = cInvalidVector, vector toVec = cInvalidVector)
{
   if ((fromVec == cInvalidVector) || (toVec == cInvalidVector))
   {
      return (0);
   }

   return ((1000.0 * distance(fromVec, toVec)) / cCoordAttackArmySpeed);
}

vector coordAttackTeamCenter(void)
{
   vector total = cInvalidVector;
   float counted = 0.0;

   for (int player = 1; player < cNumberPlayers; player++)
   {
      if (kbIsPlayerAlly(player) == false)
      {
         continue;
      }

      vector startPosition = kbGetPlayerStartingPosition(player);
      if (startPosition == cInvalidVector)
      {
         continue;
      }

      if (counted == 0.0)
      {
         total = startPosition;
      }
      else
      {
         total = total + startPosition;
      }
      counted = counted + 1.0;
   }

   if (counted == 0.0)
   {
      return (kbGetMapCenter());
   }

   return (total * (1.0 / counted));
}

vector coordAttackStagingPoint(vector targetLoc = cInvalidVector)
{
   if (targetLoc == cInvalidVector)
   {
      return (cInvalidVector);
   }

   vector approach = coordAttackTeamCenter() - targetLoc;
   if (xsVectorLength(approach) < 1.0)
   {
      return (targetLoc);
   }

   approach = xsVectorNormalize(approach);

   int targetAreaGroup = kbAreaGroupGetIDByPosition(targetLoc);

   for (int attempt = 0; attempt < 4; attempt++)
   {
      float offset = cCoordAttackStageDistance * (1.0 - (0.25 * attempt));
      vector candidate = targetLoc + (approach * offset);

      if (kbAreaGetType(kbAreaGetIDByPosition(candidate)) == cAreaTypeWater)
      {
         continue;
      }
      if (kbAreaGroupGetIDByPosition(candidate) != targetAreaGroup)
      {
         continue;
      }

      return (candidate);
   }

   return (targetLoc);
}

int coordAttackFreeMilitaryPop(void)
{
   int freePop = 0;
   int reserveUnits = aiPlanGetNumberUnits(gLandReservePlan, cUnitTypeLogicalTypeLandMilitary);

   for (int i = 0; i < reserveUnits; i++)
   {
      int unitID = aiPlanGetUnitByIndex(gLandReservePlan, i);
      if (unitID < 0)
      {
         continue;
      }
      freePop = freePop + kbGetPopSlots(cMyID, kbUnitGetProtoUnitID(unitID));
   }

   return (freePop);
}

bool coordAttackIdentifyTarget(vector loc = cInvalidVector)
{
   gCoordAttackTargetPlayer = -1;
   gCoordAttackTargetBaseID = -1;

   int buildingID = getClosestUnitByLocation(cUnitTypeBuilding, cPlayerRelationEnemyNotGaia,
      cUnitStateAlive, loc, 150.0);

   if (buildingID >= 0)
   {
      gCoordAttackTargetPlayer = kbUnitGetPlayerID(buildingID);
      gCoordAttackTargetBaseID = kbUnitGetBaseID(buildingID);
      return (true);
   }

   int unitID = getClosestUnitByLocation(cUnitTypeLogicalTypeLandMilitary, cPlayerRelationEnemyNotGaia,
      cUnitStateAlive, loc, 100.0);

   if (unitID >= 0)
   {
      gCoordAttackTargetPlayer = kbUnitGetPlayerID(unitID);
      return (true);
   }

   return (false);
}

void coordAttackClear(void)
{
   if (gCoordAttackPlanID >= 0)
   {
      aiPlanDestroy(gCoordAttackPlanID);
   }

   gCoordAttackPlanID = -1;
   gCoordAttackState = cCoordAttackStateIdle;
   gCoordAttackTargetVec = cInvalidVector;
   gCoordAttackStageVec = cInvalidVector;
   gCoordAttackTargetPlayer = -1;
   gCoordAttackTargetBaseID = -1;
   gCoordAttackFromPlayer = -1;
   gCoordAttackCommitTime = -1;
   gCoordAttackExpireTime = -1;
}

bool coordAttackCanRespond(vector loc = cInvalidVector)
{
   if (gSPC == true)
   {
      return (false);
   }
   if (gCoordAttackState != cCoordAttackStateIdle)
   {
      return (false);
   }
   if (aiTreatyActive() == true)
   {
      return (false);
   }
   if (kbGetAge() <= cAge1)
   {
      return (false);
   }
   if (isDefending() == true)
   {
      return (false);
   }
   if (gDefenseReflexBaseID >= 0)
   {
      return (false);
   }
   if (isDefendingOrAttacking() == true)
   {
      return (false);
   }
   if (gActiveIslandInvasion == true)
   {
      debugMilitary("coordAttack: declining rally, island invasion is in progress");
      return (false);
   }

   int currentTime = xsGetTime();
   if ((gCoordAttackLastJoinTime > 0) &&
       ((currentTime - gCoordAttackLastJoinTime) < cCoordAttackJoinCooldown))
   {
      return (false);
   }

   int requiredPop = cCoordAttackMinJoinPop + (6.0 * (1.0 - btOffenseDefense));
   if (coordAttackFreeMilitaryPop() < requiredPop)
   {
      debugMilitary("coordAttack: declining rally, only " + coordAttackFreeMilitaryPop() +
         " free pop, need " + requiredPop);
      return (false);
   }

   int mainBaseID = kbBaseGetMainID(cMyID);
   vector mainBaseLocation = kbBaseGetLocation(cMyID, mainBaseID);
   float maxTravel = cCoordAttackMaxTravel * (0.7 + (0.3 * btOffenseDefense));

   if (distance(loc, mainBaseLocation) > maxTravel)
   {
      debugMilitary("coordAttack: declining rally, target is too far away");
      return (false);
   }

   if (kbAreaGroupGetIDByPosition(loc) != kbAreaGroupGetIDByPosition(mainBaseLocation))
   {
      return (false);
   }

   return (true);
}

bool coordAttackCreateStagingPlan(void)
{
   int mainBaseID = kbBaseGetMainID(cMyID);
   vector gatherPoint = kbBaseGetMilitaryGatherPoint(cMyID, mainBaseID);

   int planID = aiPlanCreate("Coordinated Attack Staging vs Player " + gCoordAttackTargetPlayer, cPlanCombat);
   if (planID < 0)
   {
      return (false);
   }

   aiPlanSetVariableInt(planID, cCombatPlanCombatType, 0, cCombatPlanCombatTypeAttack);
   aiPlanSetVariableInt(planID, cCombatPlanTargetMode, 0, cCombatPlanTargetModePoint);
   aiPlanSetVariableVector(planID, cCombatPlanTargetPoint, 0, gCoordAttackStageVec);
   aiPlanSetVariableVector(planID, cCombatPlanGatherPoint, 0, gatherPoint);
   aiPlanSetVariableFloat(planID, cCombatPlanGatherDistance, 0, 40.0);

   aiPlanSetVariableFloat(planID, cCombatPlanTargetEngageRange, 0, 20.0);
   aiPlanSetVariableInt(planID, cCombatPlanAttackRoutePattern, 0, cCombatPlanAttackRoutePatternBest);
   aiPlanSetVariableBool(planID, cCombatPlanAllowMoreUnitsDuringAttack, 0, true);
   aiPlanSetVariableInt(planID, cCombatPlanRefreshFrequency, 0,
      cDifficultyCurrent >= cDifficultyHard ? 300 : 1000);

   aiPlanSetVariableInt(planID, cCombatPlanDoneMode, 0, cCombatPlanDoneModeNoTarget);
   aiPlanSetVariableInt(planID, cCombatPlanNoTargetTimeout, 0, cCoordAttackMissionTimeout);
   aiPlanSetVariableInt(planID, cCombatPlanRetreatMode, 0, cCombatPlanRetreatModeOutnumbered);

   aiPlanSetBaseID(planID, mainBaseID);
   aiPlanSetInitialPosition(planID, gatherPoint);
   aiPlanSetDesiredPriority(planID, 50);
   aiPlanSetNoMoreUnits(planID, false);
   aiPlanSetRequiresAllNeedUnits(planID, false);

   addUnitsToMilitaryPlan(planID);

   aiPlanSetActive(planID);

   gCoordAttackPlanID = planID;

   return (true);
}

void coordAttackCommitToTarget(void)
{
   if (gCoordAttackPlanID < 0)
   {
      coordAttackClear();
      return;
   }

   if (gCoordAttackTargetBaseID >= 0)
   {
      aiPlanSetVariableInt(gCoordAttackPlanID, cCombatPlanTargetMode, 0, cCombatPlanTargetModeBase);
      aiPlanSetVariableInt(gCoordAttackPlanID, cCombatPlanTargetBaseID, 0, gCoordAttackTargetBaseID);
   }
   else
   {
      aiPlanSetVariableInt(gCoordAttackPlanID, cCombatPlanTargetMode, 0, cCombatPlanTargetModePoint);
   }

   aiPlanSetVariableInt(gCoordAttackPlanID, cCombatPlanTargetPlayerID, 0, gCoordAttackTargetPlayer);
   aiPlanSetVariableVector(gCoordAttackPlanID, cCombatPlanTargetPoint, 0, gCoordAttackTargetVec);
   aiPlanSetVariableFloat(gCoordAttackPlanID, cCombatPlanTargetEngageRange, 0, 60.0);

   if (gCoordAttackTargetBaseID >= 0)
   {
      aiPlanSetVariableInt(gCoordAttackPlanID, cCombatPlanDoneMode, 0,
         cCombatPlanDoneModeBaseGone | cCombatPlanDoneModeRetreat | cCombatPlanDoneModeNoTarget);
   }
   else
   {
      aiPlanSetVariableInt(gCoordAttackPlanID, cCombatPlanDoneMode, 0,
         cCombatPlanDoneModeNoTarget | cCombatPlanDoneModeRetreat);
   }
   aiPlanSetVariableInt(gCoordAttackPlanID, cCombatPlanNoTargetTimeout, 0, 30000);

   addUnitsToMilitaryPlan(gCoordAttackPlanID);

   gCoordAttackState = cCoordAttackStateCommitted;
   gCoordAttackLastJoinTime = xsGetTime();

   sendStatement(gCoordAttackFromPlayer, cAICommPromptToAllyIWillAttackWithYou, gCoordAttackTargetVec);

   debugMilitary("***** COORDINATED ATTACK committing on player " + gCoordAttackTargetPlayer +
      " base " + gCoordAttackTargetBaseID + " alongside player " + gCoordAttackFromPlayer);
}

void coordAttackBroadcast(int targetPlayer = -1, int targetBaseID = -1, vector loc = cInvalidVector)
{
   if ((loc == cInvalidVector) || (gSPC == true))
   {
      return;
   }

   int currentTime = xsGetTime();
   if ((gCoordAttackLastBroadcastTime > 0) &&
       ((currentTime - gCoordAttackLastBroadcastTime) < cCoordAttackBroadcastCooldown))
   {
      return;
   }

   int promptID = cAICommPromptToAllyIWillAttackEnemyBase;
   if (targetPlayer > 0)
   {
      if (targetBaseID == kbBaseGetMainID(targetPlayer))
      {
         promptID = cAICommPromptToAllyIWillAttackEnemyTown;
      }
   }

   bool sentToAnyone = false;

   for (int player = 1; player < cNumberPlayers; player++)
   {
      if (player == cMyID)
      {
         continue;
      }
      if (kbIsPlayerAlly(player) == false)
      {
         continue;
      }

      aiCommsSendStatementWithVector(player, promptID, loc);
      sentToAnyone = true;
   }

   if (sentToAnyone == false)
   {
      return;
   }

   gCoordAttackLastBroadcastTime = currentTime;

   gCoordAttackLastRallyVec = loc;
   gCoordAttackLastRallyTime = currentTime;

   debugMilitary("***** COORDINATED ATTACK rally broadcast, target player " + targetPlayer +
      " base " + targetBaseID + " at " + loc);
}

int coordAttackFreeWarships(void)
{
   int freeShips = 0;
   int shipQueryID = createSimpleUnitQuery(cUnitTypeAbstractWarShip, cMyID, cUnitStateAlive);
   int shipsFound = kbUnitQueryExecute(shipQueryID);

   for (int shipIndex = 0; shipIndex < shipsFound; shipIndex++)
   {
      int shipID = kbUnitQueryGetResult(shipQueryID, shipIndex);

      if (shipIsOnAllyAssist(shipID) == true)
      {
         continue;
      }

      int shipPlanID = kbUnitGetPlanID(shipID);
      if (shipPlanID >= 0)
      {
         if (aiPlanGetType(shipPlanID) == cPlanTransport)
         {
            continue;
         }
         if (aiPlanGetDesiredPriority(shipPlanID) >= cCoordAttackWarshipBusyPriority)
         {
            continue;
         }
      }

      freeShips = freeShips + 1;
   }

   return (freeShips);
}

bool coordAttackUnitCanReach(int unitID = -1, int targetGroupID = -1, vector targetLoc = cInvalidVector,
   int homeGroupID = -1)
{
   vector unitLocation = kbUnitGetPosition(unitID);
   int unitGroupID = kbAreaGroupGetIDByPosition(unitLocation);

   if (kbAreAreaGroupsPassableByLand(targetGroupID, unitGroupID) == true)
   {
      return (true);
   }

   if (homeGroupID >= 0)
   {
      if ((kbAreAreaGroupsPassableByLand(homeGroupID, unitGroupID) == false) &&
          (distance(unitLocation, targetLoc) < cIslandUnitScanRadius))
      {
         return (true);
      }
   }

   return (false);
}

bool coordAttackCanRespondExpeditionary(vector loc = cInvalidVector)
{
   if (gSPC == true)
   {
      return (false);
   }
   if (gCoordAttackExpeditionPlanID >= 0)
   {
      return (false);
   }
   if (aiTreatyActive() == true)
   {
      return (false);
   }
   if (kbGetAge() <= cAge1)
   {
      return (false);
   }

   if (gIslandAssaultPlanID >= 0)
   {
      if (aiPlanGetActive(gIslandAssaultPlanID) == true)
      {
         return (false);
      }
   }
   if (gForgottenMilitaryAssaultPlanID >= 0)
   {
      if (aiPlanGetActive(gForgottenMilitaryAssaultPlanID) == true)
      {
         return (false);
      }
   }

   if (homeIslandUnderAttack() == true)
   {
      debugMilitary("coordAttack: declining expedition, home is under attack and the army is being recalled");
      return (false);
   }
   if (gIslandReturnTransportPlanID >= 0)
   {
      if (aiPlanGetActive(gIslandReturnTransportPlanID) == true)
      {
         return (false);
      }
   }

   int currentTime = xsGetTime();
   if ((gCoordAttackLastExpeditionJoinTime > 0) &&
       ((currentTime - gCoordAttackLastExpeditionJoinTime) < cCoordAttackExpeditionCooldown))
   {
      return (false);
   }

   return (true);
}

void coordAttackExpeditionaryJoin(int fromID = -1, vector loc = cInvalidVector)
{
   int currentTime = xsGetTime();

   if ((gCoordAttackLastExpeditionRallyVec != cInvalidVector) &&
       ((currentTime - gCoordAttackLastExpeditionRallyTime) < cCoordAttackRallyLifetime) &&
       (distance(loc, gCoordAttackLastExpeditionRallyVec) < cCoordAttackDupeRadius))
   {
      return;
   }

   gCoordAttackLastExpeditionRallyVec = loc;
   gCoordAttackLastExpeditionRallyTime = currentTime;

   if (coordAttackCanRespondExpeditionary(loc) == false)
   {
      return;
   }

   int targetGroupID = kbAreaGroupGetIDByPosition(loc);
   int homeGroupID = kbAreaGroupGetIDByPosition(kbBaseGetLocation(cMyID, kbBaseGetMainID(cMyID)));

   int scoutQueryID = createSimpleUnitQuery(cUnitTypeLogicalTypeLandMilitary, cMyID, cUnitStateAlive);
   int scoutFound = kbUnitQueryExecute(scoutQueryID);
   int availableCount = 0;

   for (int scoutIndex = 0; scoutIndex < scoutFound; scoutIndex++)
   {
      int scoutID = kbUnitQueryGetResult(scoutQueryID, scoutIndex);

      if (kbUnitIsType(scoutID, cUnitTypeHero) == true)
      {
         continue;
      }
      if (coordAttackUnitCanReach(scoutID, targetGroupID, loc, homeGroupID) == false)
      {
         continue;
      }

      int scoutPlanID = kbUnitGetPlanID(scoutID);
      if (scoutPlanID >= 0)
      {
         if (aiPlanGetDesiredPriority(scoutPlanID) >= cCoordAttackExpeditionBusyPriority)
         {
            continue;
         }
         if (aiPlanGetType(scoutPlanID) == cPlanTransport)
         {
            continue;
         }
      }

      availableCount = availableCount + 1;
   }

   if (availableCount < cCoordAttackMinExpeditionUnits)
   {
      return;
   }

   int planID = aiPlanCreate("Coordinated Expedition with Player " + fromID, cPlanCombat);
   if (planID < 0)
   {
      return;
   }

   aiPlanAddUnitType(planID, cUnitTypeLogicalTypeLandMilitary, 0, 0, 200);

   int addQueryID = createSimpleUnitQuery(cUnitTypeLogicalTypeLandMilitary, cMyID, cUnitStateAlive);
   int addFound = kbUnitQueryExecute(addQueryID);
   int addedCount = 0;
   float centroidX = 0.0;
   float centroidZ = 0.0;

   for (int addIndex = 0; addIndex < addFound; addIndex++)
   {
      int unitID = kbUnitQueryGetResult(addQueryID, addIndex);

      if (kbUnitIsType(unitID, cUnitTypeHero) == true)
      {
         continue;
      }
      if (coordAttackUnitCanReach(unitID, targetGroupID, loc, homeGroupID) == false)
      {
         continue;
      }

      int unitPlanID = kbUnitGetPlanID(unitID);
      if (unitPlanID >= 0)
      {
         if (aiPlanGetDesiredPriority(unitPlanID) >= cCoordAttackExpeditionBusyPriority)
         {
            continue;
         }
         if (aiPlanGetType(unitPlanID) == cPlanTransport)
         {
            continue;
         }
         if (unitPlanID != planID)
         {
            aiPlanRemoveUnit(unitPlanID, unitID);
         }
      }

      if (aiPlanAddUnit(planID, unitID) == true)
      {
         vector unitLocation = kbUnitGetPosition(unitID);
         centroidX = centroidX + xsVectorGetX(unitLocation);
         centroidZ = centroidZ + xsVectorGetZ(unitLocation);
         addedCount = addedCount + 1;
      }
   }

   if (addedCount < cCoordAttackMinExpeditionUnits)
   {
      aiPlanDestroy(planID);
      return;
   }

   vector gatherPoint = xsVectorSet(centroidX / addedCount, 0.0, centroidZ / addedCount);

   aiPlanSetVariableInt(planID, cCombatPlanCombatType, 0, cCombatPlanCombatTypeAttack);
   aiPlanSetVariableInt(planID, cCombatPlanTargetMode, 0, cCombatPlanTargetModePoint);
   aiPlanSetVariableVector(planID, cCombatPlanTargetPoint, 0, loc);
   aiPlanSetVariableVector(planID, cCombatPlanGatherPoint, 0, gatherPoint);
   aiPlanSetVariableFloat(planID, cCombatPlanGatherDistance, 0, 100.0);
   aiPlanSetVariableFloat(planID, cCombatPlanTargetEngageRange, 0, 60.0);
   aiPlanSetVariableInt(planID, cCombatPlanAttackRoutePattern, 0, cCombatPlanAttackRoutePatternBest);
   aiPlanSetVariableBool(planID, cCombatPlanAllowMoreUnitsDuringAttack, 0, true);
   aiPlanSetVariableInt(planID, cCombatPlanRefreshFrequency, 0,
      cDifficultyCurrent >= cDifficultyHard ? 300 : 1000);
   aiPlanSetVariableInt(planID, cCombatPlanDoneMode, 0,
      cCombatPlanDoneModeNoTarget | cCombatPlanDoneModeRetreat);
   aiPlanSetVariableInt(planID, cCombatPlanNoTargetTimeout, 0, 45000);

   aiPlanSetVariableInt(planID, cCombatPlanRetreatMode, 0, cCombatPlanRetreatModeNone);
   aiPlanSetInitialPosition(planID, gatherPoint);
   aiPlanSetDesiredPriority(planID, 60);
   aiPlanSetNoMoreUnits(planID, false);
   aiPlanSetRequiresAllNeedUnits(planID, false);
   aiPlanSetActive(planID, true);

   gCoordAttackExpeditionPlanID = planID;
   gCoordAttackExpeditionVec = loc;
   gCoordAttackExpeditionFromPlayer = fromID;
   gCoordAttackExpeditionExpireTime = currentTime + cCoordAttackExpeditionTimeout;
   gCoordAttackLastExpeditionJoinTime = currentTime;

   sendStatement(fromID, cAICommPromptToAllyIWillAttackWithYou, loc);

   debugMilitary("***** COORDINATED EXPEDITION joining player " + fromID + " at " + loc +
      " with " + addedCount + " troops already ashore");
}

vector coordAttackWaterPointNear(vector loc = cInvalidVector)
{
   if (loc == cInvalidVector)
   {
      return (cInvalidVector);
   }
   if (kbAreaGetType(kbAreaGetIDByPosition(loc)) == cAreaTypeWater)
   {
      return (loc);
   }

   vector towards = gNavyVec;
   if (towards == cInvalidVector)
   {
      towards = kbGetMapCenter();
   }
   if (distance(towards, loc) < 1.0)
   {
      return (cInvalidVector);
   }

   vector step = xsVectorNormalize(towards - loc);
   vector current = loc;

   for (int i = 0; i < 40; i++)
   {
      current = current + step;
      if (kbAreaGetType(kbAreaGetIDByPosition(current)) == cAreaTypeWater)
      {
         return (current);
      }
   }

   return (cInvalidVector);
}

bool coordAttackCanRespondNaval(vector loc = cInvalidVector)
{
   if (gSPC == true)
   {
      return (false);
   }
   if (gNavyMap == false)
   {
      return (false);
   }
   if (gCoordAttackNavalPlanID >= 0)
   {
      return (false);
   }
   if (aiTreatyActive() == true)
   {
      return (false);
   }
   if (kbGetAge() <= cAge1)
   {
      return (false);
   }
   if (gActiveIslandInvasion == true)
   {
      debugMilitary("coordAttack: declining sea rally, our own invasion is crossing");
      return (false);
   }
   if (gAllyWarshipAttackPlan >= 0)
   {
      if (aiPlanGetActive(gAllyWarshipAttackPlan) == true)
      {
         return (false);
      }
   }

   int currentTime = xsGetTime();
   if ((gCoordAttackLastNavalJoinTime > 0) &&
       ((currentTime - gCoordAttackLastNavalJoinTime) < cCoordAttackNavalJoinCooldown))
   {
      return (false);
   }

   if (coordAttackFreeWarships() < cCoordAttackMinJoinWarships)
   {
      debugMilitary("coordAttack: declining sea rally, only " + coordAttackFreeWarships() +
         " free warships");
      return (false);
   }

   if (gNavyVec != cInvalidVector)
   {
      if (kbAreaGroupGetIDByPosition(loc) != kbAreaGroupGetIDByPosition(gNavyVec))
      {
         debugMilitary("coordAttack: declining sea rally, different body of water");
         return (false);
      }
   }

   return (true);
}

void coordAttackHandleNavalRally(int fromID = -1, vector loc = cInvalidVector)
{
   int currentTime = xsGetTime();

   if ((gCoordAttackLastNavalRallyVec != cInvalidVector) &&
       ((currentTime - gCoordAttackLastNavalRallyTime) < cCoordAttackRallyLifetime) &&
       (distance(loc, gCoordAttackLastNavalRallyVec) < cCoordAttackDupeRadius))
   {
      debugMilitary("coordAttack: ignoring duplicate sea rally from player " + fromID);
      return;
   }

   gCoordAttackLastNavalRallyVec = loc;
   gCoordAttackLastNavalRallyTime = currentTime;

   if (coordAttackCanRespondNaval(loc) == false)
   {
      return;
   }

   vector navyRallyVector = gNavyVec;
   if (navyRallyVector == cInvalidVector)
   {
      navyRallyVector = kbBaseGetLocation(cMyID, kbBaseGetMainID(cMyID));
   }

   int planID = aiPlanCreate("Coordinated Naval Attack with Player " + fromID, cPlanCombat);
   if (planID < 0)
   {
      return;
   }

   aiPlanAddUnitType(planID, cUnitTypeAbstractWarShip, 1, cCoordAttackMinJoinWarships, 200);
   aiPlanSetVariableInt(planID, cCombatPlanCombatType, 0, cCombatPlanCombatTypeAttack);
   aiPlanSetVariableInt(planID, cCombatPlanTargetMode, 0, cCombatPlanTargetModePoint);
   aiPlanSetVariableVector(planID, cCombatPlanTargetPoint, 0, loc);
   aiPlanSetVariableVector(planID, cCombatPlanGatherPoint, 0, navyRallyVector);
   aiPlanSetVariableFloat(planID, cCombatPlanGatherDistance, 0, 950.0);
   aiPlanSetVariableInt(planID, cCombatPlanAttackRoutePattern, 0, cCombatPlanAttackRoutePatternBest);
   aiPlanSetVariableBool(planID, cCombatPlanAllowMoreUnitsDuringAttack, 0, true);
   aiPlanSetVariableInt(planID, cCombatPlanRefreshFrequency, 0, 10);
   aiPlanSetVariableInt(planID, cCombatPlanDoneMode, 0,
      cCombatPlanDoneModeNoTarget | cCombatPlanDoneModeRetreat);
   aiPlanSetVariableInt(planID, cCombatPlanNoTargetTimeout, 0, 60000);
   aiPlanSetVariableInt(planID, cCombatPlanRetreatMode, 0, cCombatPlanRetreatModeOutnumbered);
   aiPlanSetInitialPosition(planID, navyRallyVector);

   aiPlanSetDesiredPriority(planID, 70);
   aiPlanSetNoMoreUnits(planID, false);
   aiPlanSetRequiresAllNeedUnits(planID, false);
   aiPlanSetActive(planID, true);

   gCoordAttackNavalPlanID = planID;
   gCoordAttackNavalVec = loc;
   gCoordAttackNavalFromPlayer = fromID;
   gCoordAttackNavalExpireTime = currentTime + cCoordAttackNavalTimeout;
   gCoordAttackLastNavalJoinTime = currentTime;

   sendStatement(fromID, cAICommPromptToAllyIWillAttackWithYou, loc);

   debugMilitary("***** COORDINATED NAVAL ATTACK joining player " + fromID + " at " + loc);
}

void coordAttackBroadcastNaval(vector loc = cInvalidVector)
{
   if ((loc == cInvalidVector) || (gSPC == true))
   {
      return;
   }

   loc = coordAttackWaterPointNear(loc);
   if (loc == cInvalidVector)
   {
      return;
   }

   int currentTime = xsGetTime();
   if ((gCoordAttackLastNavalBroadcastTime > 0) &&
       ((currentTime - gCoordAttackLastNavalBroadcastTime) < cCoordAttackNavalBroadcastCooldown))
   {
      return;
   }

   bool sentToAnyone = false;

   for (int player = 1; player < cNumberPlayers; player++)
   {
      if (player == cMyID)
      {
         continue;
      }
      if (kbIsPlayerAlly(player) == false)
      {
         continue;
      }

      aiCommsSendStatementWithVector(player, cAICommPromptToAllyIWillAttackEnemyBase, loc);
      sentToAnyone = true;
   }

   if (sentToAnyone == false)
   {
      return;
   }

   gCoordAttackLastNavalBroadcastTime = currentTime;
   gCoordAttackLastNavalRallyVec = loc;
   gCoordAttackLastNavalRallyTime = currentTime;

   debugMilitary("***** COORDINATED NAVAL rally broadcast at " + loc);
}

void coordAttackHandleRally(int fromID = -1, vector loc = cInvalidVector)
{
   if ((fromID < 0) || (fromID == cMyID) || (loc == cInvalidVector))
   {
      return;
   }
   if (kbIsPlayerAlly(fromID) == false)
   {
      return;
   }

   if (kbAreaGetType(kbAreaGetIDByPosition(loc)) == cAreaTypeWater)
   {
      coordAttackHandleNavalRally(fromID, loc);
      return;
   }

   vector homeLocation = kbBaseGetLocation(cMyID, kbBaseGetMainID(cMyID));
   if (kbAreAreaGroupsPassableByLand(kbAreaGroupGetIDByPosition(loc),
      kbAreaGroupGetIDByPosition(homeLocation)) == false)
   {
      coordAttackExpeditionaryJoin(fromID, loc);
      return;
   }

   int currentTime = xsGetTime();

   if ((gCoordAttackLastRallyVec != cInvalidVector) &&
       ((currentTime - gCoordAttackLastRallyTime) < cCoordAttackRallyLifetime) &&
       (distance(loc, gCoordAttackLastRallyVec) < cCoordAttackDupeRadius))
   {
      debugMilitary("coordAttack: ignoring duplicate rally from player " + fromID);
      return;
   }

   gCoordAttackLastRallyVec = loc;
   gCoordAttackLastRallyTime = currentTime;

   if (coordAttackCanRespond(loc) == false)
   {
      return;
   }
   if (coordAttackIdentifyTarget(loc) == false)
   {
      debugMilitary("coordAttack: nothing enemy found near the rally point");
      return;
   }
   if (kbIsPlayerEnemy(gCoordAttackTargetPlayer) == false)
   {
      coordAttackClear();
      return;
   }

   gCoordAttackTargetVec = loc;
   gCoordAttackFromPlayer = fromID;
   gCoordAttackStageVec = coordAttackStagingPoint(loc);

   if (coordAttackCreateStagingPlan() == false)
   {
      coordAttackClear();
      return;
   }

   int allyTravel = coordAttackTravelTime(kbGetPlayerStartingPosition(fromID), loc);
   int allyArrival = currentTime + allyTravel;

   int stageToTarget = coordAttackTravelTime(gCoordAttackStageVec, loc);

   vector gatherPoint = kbBaseGetMilitaryGatherPoint(cMyID, kbBaseGetMainID(cMyID));
   int ourReadyTime = currentTime + coordAttackTravelTime(gatherPoint, gCoordAttackStageVec);

   gCoordAttackCommitTime = allyArrival - stageToTarget;

   if (gCoordAttackCommitTime < ourReadyTime)
   {
      gCoordAttackCommitTime = ourReadyTime;
   }

   if (gCoordAttackCommitTime > (currentTime + cCoordAttackMaxStageWait))
   {
      gCoordAttackCommitTime = currentTime + cCoordAttackMaxStageWait;
   }

   gCoordAttackExpireTime = currentTime + cCoordAttackMissionTimeout;
   gCoordAttackState = cCoordAttackStateStaging;

   debugMilitary("***** COORDINATED ATTACK staging at " + gCoordAttackStageVec +
      " for player " + fromID + "'s attack on player " + gCoordAttackTargetPlayer +
      ", committing in " + ((gCoordAttackCommitTime - currentTime) / 1000) + "s");
}

rule coordinatedAttackManager
inactive
minInterval 10
{
   int currentTime = xsGetTime();

   if (gCoordAttackNavalPlanID >= 0)
   {
      bool dropNaval = false;

      if (currentTime > gCoordAttackNavalExpireTime)
      {
         debugMilitary("coordAttack: naval assist timed out");
         dropNaval = true;
      }
      else if (aiPlanGetActive(gCoordAttackNavalPlanID) == false)
      {
         dropNaval = true;
      }
      else if (gActiveIslandInvasion == true)
      {
         debugMilitary("coordAttack: recalling naval assist, our invasion is starting");
         dropNaval = true;
      }

      if (dropNaval == true)
      {
         aiPlanDestroy(gCoordAttackNavalPlanID);
         gCoordAttackNavalPlanID = -1;
         gCoordAttackNavalVec = cInvalidVector;
         gCoordAttackNavalFromPlayer = -1;
         gCoordAttackNavalExpireTime = -1;
      }
   }

   if (gCoordAttackExpeditionPlanID >= 0)
   {
      bool dropExpedition = false;

      if (currentTime > gCoordAttackExpeditionExpireTime)
      {
         debugMilitary("coordAttack: expedition timed out");
         dropExpedition = true;
      }
      else if (aiPlanGetActive(gCoordAttackExpeditionPlanID) == false)
      {
         dropExpedition = true;
      }
      else if (homeIslandUnderAttack() == true)
      {
         debugMilitary("coordAttack: releasing expedition, home is under attack and the army is recalled");
         dropExpedition = true;
      }
      else if (gIslandReturnTransportPlanID >= 0)
      {
         if (aiPlanGetActive(gIslandReturnTransportPlanID) == true)
         {
            debugMilitary("coordAttack: releasing expedition, evacuation is loading");
            dropExpedition = true;
         }
      }
      else if (gIslandAssaultPlanID >= 0)
      {
         if (aiPlanGetActive(gIslandAssaultPlanID) == true)
         {
            debugMilitary("coordAttack: releasing expedition, our own island assault started");
            dropExpedition = true;
         }
      }

      if (dropExpedition == true)
      {
         aiPlanDestroy(gCoordAttackExpeditionPlanID);
         gCoordAttackExpeditionPlanID = -1;
         gCoordAttackExpeditionVec = cInvalidVector;
         gCoordAttackExpeditionFromPlayer = -1;
         gCoordAttackExpeditionExpireTime = -1;
      }
   }

   if (gCoordAttackState == cCoordAttackStateIdle)
   {
      return;
   }

   if (gActiveIslandInvasion == true)
   {
      debugMilitary("coordAttack: standing down, island invasion has taken priority");
      coordAttackClear();
      return;
   }

   if (currentTime > gCoordAttackExpireTime)
   {
      debugMilitary("coordAttack: mission timed out, standing down");
      coordAttackClear();
      return;
   }

   if ((gCoordAttackPlanID < 0) || (aiPlanGetActive(gCoordAttackPlanID) == false))
   {
      debugMilitary("coordAttack: plan is gone, standing down");
      coordAttackClear();
      return;
   }

   if (gDefenseReflexBaseID >= 0)
   {
      debugMilitary("coordAttack: recalled to defend our own base");
      coordAttackClear();
      return;
   }

   if (gCoordAttackState == cCoordAttackStateStaging)
   {
      if (coordAttackIdentifyTarget(gCoordAttackTargetVec) == false)
      {
         debugMilitary("coordAttack: nothing left at the target, standing down");
         coordAttackClear();
         return;
      }

      if (currentTime >= gCoordAttackCommitTime)
      {
         coordAttackCommitToTarget();
      }
      return;
   }

   if (gCoordAttackState == cCoordAttackStateCommitted)
   {
      addUnitsToMilitaryPlan(gCoordAttackPlanID);
   }
}
