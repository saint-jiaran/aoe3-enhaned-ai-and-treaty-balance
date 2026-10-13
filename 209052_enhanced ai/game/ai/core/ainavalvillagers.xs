//==============================================================================
//==============================================================================
vector getRandomIslandToBuildOn()
{
   vector startingLoc = kbGetPlayerStartingPosition(cMyID);
   int startingAreaID = kbAreaGetIDByPosition(startingLoc);
   int startingAreaGroupID = kbAreaGroupGetIDByPosition(startingLoc);
   vector islandLoc = cInvalidVector;
   vector islandAreaCentralPoint = cInvalidVector;
   int islandAreaID = -1;
   int islandAreaGroupID = -1;
   float xFloat = 0.0;
   float zFloat = 0.0;
   int numEnemyBuildings = -1;

   int closestBaseID = kbFindClosestBase(cPlayerRelationEnemy, startingLoc);
   vector closestBaseLocation = kbBaseGetLocation(kbBaseGetOwner(closestBaseID), closestBaseID);
   int closestBaseAreaGroupID = kbAreaGroupGetIDByPosition(closestBaseLocation);
   int enemyUnitQueryID = createSimpleUnitQuery(cUnitTypeBuilding, cPlayerRelationEnemyNotGaia, cUnitStateABQ);
   int enemyNumberFound = kbUnitQueryExecute(enemyUnitQueryID);
   int enemyAreaGroupID = -1;
   int areaGroupID = -1;
   int unitID = -1;
   for (i = 0; < enemyNumberFound)
   {
      unitID = kbUnitQueryGetResult(enemyUnitQueryID, i);
      if (kbHasPlayerLost(kbUnitGetPlayerID(unitID)) == true)
      {
         continue;
      }
      areaGroupID = kbAreaGroupGetIDByPosition(kbUnitGetPosition(unitID));
      if (areaGroupID == startingAreaGroupID)
      {
         continue;
      }
      enemyAreaGroupID = areaGroupID;
      break;
   }

   float mapWidth = kbGetMapXSize();
   float mapHeight = kbGetMapZSize();

   for (i = 0; < 90)
   {
      xFloat = aiRandFloat(150.0, kbGetMapXSize());
      zFloat = aiRandFloat(150.0, kbGetMapZSize());
      islandLoc = xsVectorSet(xFloat, 0.0, zFloat);
      
      islandAreaID = kbAreaGetIDByPosition(islandLoc);
      islandAreaGroupID = kbAreaGroupGetIDByPosition(islandLoc);
      islandAreaCentralPoint = kbAreaGroupGetCenter(islandAreaGroupID);
      if (kbAreaGroupGetType(islandAreaGroupID) == cAreaGroupTypeLand &&
          kbAreAreaGroupsPassableByLand(islandAreaGroupID, startingAreaGroupID) == false)
      {
         gVillagersIslandX = xFloat;
         gVillagersIslandZ = zFloat;
         gVillagersIslandAreaId = kbAreaGetIDByPosition(islandLoc);
         gVillagersIslandGroupId = kbAreaGroupGetIDByPosition(islandLoc);
         gVillagersIslandFound = true;
         return islandLoc;
      }
   }
   return cInvalidVector;
}