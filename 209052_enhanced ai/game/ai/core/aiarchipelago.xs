//==============================================================================
// Archipelago.xs
// Island hopping system!
//==============================================================================

// Starting island dock tracking
extern int gStartingIslandAreaGroup = -1;
extern bool gStartingDockBuilt = false;

//==============================================================================
// isIslandOccupiedByEnemy
// Check if an island (area group) has enemy buildings
//==============================================================================
bool isIslandOccupiedByEnemy(vector location = cInvalidVector)
{
   if (location == cInvalidVector)
      return (false);
   
   int targetAreaGroup = kbAreaGroupGetIDByPosition(location);
   if (targetAreaGroup < 0)
      return (false);
   
   int unitId = getClosestIslandUnitByLocation(cUnitTypeBuilding, cPlayerRelationEnemy, cUnitStateAlive, location, 10.0);

   if (unitId > 0)
      return (true);
   
   return (false);
}

//==============================================================================
// checkStartingIslandDock
// Ensure we have a dock on our starting island
//==============================================================================
void checkStartingIslandDock(void)
{
   if (gStartingDockBuilt == true)
      return;
   
   int mainBaseID = kbBaseGetMainID(cMyID);
   if (mainBaseID < 0)
      return;
   
   vector mainLoc = kbBaseGetLocation(cMyID, mainBaseID);
   
   // Initialize starting island area group if needed
   if (gStartingIslandAreaGroup < 0)
   {
      gStartingIslandAreaGroup = kbAreaGroupGetIDByPosition(mainLoc);
      aiEcho("ARCH: Starting island areaGroup set to "+gStartingIslandAreaGroup);
   }
   
   // Check if we already have a dock on starting island
   int query = kbUnitQueryCreate("StartingDockCheck");
   kbUnitQuerySetPlayerID(query, cMyID);
   kbUnitQuerySetUnitType(query, cUnitTypeDock);
   kbUnitQuerySetState(query, cUnitStateABQ);
   kbUnitQueryResetResults(query);
   
   int total = kbUnitQueryExecute(query);
   
   for (i = 0; < total)
   {
      int dockID = kbUnitQueryGetResult(query, i);
      vector dockPos = kbUnitGetPosition(dockID);
      if (kbAreaGroupGetIDByPosition(dockPos) == gStartingIslandAreaGroup)
      {
         aiEcho("ARCH: Dock already exists on starting island");
         gStartingDockBuilt = true;
         return;
      }
   }
   
   // No dock found, create build plan with high priority
   createSimpleBuildPlan(cUnitTypeDock, 1, 95, true, cEconomyEscrowID, mainBaseID, 1);
   aiEcho("ARCH: Created dock build plan for starting island");
   gStartingDockBuilt = true;
}

//==============================================================================
// tooManyBuildingsCheck
// This function will tell us if we have sufficient space to continue building.
//==============================================================================
bool tooManyBuildingsCheck(vector currentLocation = cInvalidVector)
{
   int currentLocationGroupId = kbAreaGroupGetIDByPosition(currentLocation);
   int currentNumBuildings = getUnitCountByAreaGroups(cUnitTypeBuilding, cPlayerRelationAny, cUnitStateABQ, currentLocation);
   int areaCount = kbAreaGroupGetNumberAreas(currentLocationGroupId);
   if (currentNumBuildings > 3 * areaCount)
   {
      return (true);
   }
   return (false);
}

//==============================================================================
// archipelagoGo
// Check if we need to island hop due to space and other conditions.
//==============================================================================
rule archipelagoGo
inactive
minInterval 40
{
   // Check for dock on starting island first
   checkStartingIslandDock();
   
   vector myBaseLoc = kbBaseGetLocation(cMyID, kbBaseGetMainID(cMyID));
   vector newBase = getRandomIslandToBuildOn();
   int newBaseId = -1;
   int myBaseAreaID = kbAreaGetIDByPosition(myBaseLoc);
   int myBaseAreaGroupID = kbAreaGroupGetIDByPosition(myBaseLoc);
   
   // Check if the main base has too many buildings...
   bool isOvercrowded = tooManyBuildingsCheck(myBaseLoc);
   
   // Move main base if so, so we do not overcrowd it...
   if (isOvercrowded == true && gVillagersTransportPlanID == -1 && newBase != cInvalidVector)
   {
      // Check if target island has enemies
      if (isIslandOccupiedByEnemy(newBase) == true)
      {
         aiEcho("ARCH: Target island has enemies, skipping");
         return;
      }
      
      // Check if we have ships available
      if (kbUnitCount(cMyID, cUnitTypeAbstractWarShip, cUnitStateAlive) < 1)
      {
         aiEcho("ARCH: No ships available, waiting...");
         return;
      }
      
      // Create the transport plan...
      if (gVillagersTransportPlanID == -1)
      {
         gVillagersTransportPlanID = createColonizationTransportPlan(
            kbBaseGetMilitaryGatherPoint(cMyID, kbBaseGetMainID(cMyID)), 
            newBase, 100, false);
      }
      
      // Check transport plan was created
      if (gVillagersTransportPlanID < 0)
      {
         aiEcho("ARCH: Failed to create transport plan");
         return;
      }
      
      addUnitsToTransportPlan(gVillagersTransportPlanID, myBaseLoc);
      aiPlanSetActive(gVillagersTransportPlanID, true);
      
      createSettlementBase(newBase);
      newBaseId = kbBaseGetMainID(cMyID);
      kbBaseSetActive(cMyID, newBaseId, true);
      
      aiEcho("ARCH: New Base Active Status: "+kbBaseGetActive(cMyID, newBaseId)+"!");
      gGatherPlansUpdated = false;
   }
   
   // Check if transport plan exists but seems stuck
   if (gVillagersTransportPlanID >= 0)
   {
      int planState = aiPlanGetState(gVillagersTransportPlanID);
      if (planState == -1)
      {
         aiEcho("ARCH: Transport plan failed, resetting...");
         aiPlanDestroy(gVillagersTransportPlanID);
         gVillagersTransportPlanID = -1;
      }
   }
   
   // It's time to Archipelago-Go!
   int availableUnits = createSimpleUnitQuery(gEconUnit, cMyID, cUnitStateAlive, 
      kbBaseGetLocation(cMyID, kbBaseGetMainID(cMyID)), 150.0);
   
   aiEcho("ARCH: Waiting to add more gather plans... Is Overcrowded: "+isOvercrowded+
      " Available Villagers: "+availableUnits+" Gather Plans Updated: "+gGatherPlansUpdated);
   
   if (availableUnits > 0 && gGatherPlansUpdated == false)
   {
      int numberOfBases = kbBaseGetNumber(cMyID);
      float newBasePercentage = (1 / numberOfBases) * 100.0;
      aiEcho("ARCH: Second check. Is Overcrowded: "+isOvercrowded+" Available Villagers: "+availableUnits);
      
      for (i = 0; < numberOfBases)
      {
         int currentBaseId = kbBaseGetIDByIndex(cMyID, i);
         vector currentBaseLoc = kbBaseGetLocation(cMyID, currentBaseId);
         
         // Create gather plans at the base.
         createGatherPlan(currentBaseLoc, currentBaseId, cResourceFood, 95);
         createGatherPlan(currentBaseLoc, currentBaseId, cResourceWood, 95);
         createGatherPlan(currentBaseLoc, currentBaseId, cResourceGold, 95);
         aiEcho("ARCH: Base Gather Info: "+currentBaseId);
      }
      
      createSimpleBuildPlan(cUnitTypeTownCenter, 1, 99, true, cEconomyEscrowID, kbBaseGetMainID(cMyID), 1);
      gVillagersTransportPlanID = -1;
      gGatherPlansUpdated = true;
   }
}