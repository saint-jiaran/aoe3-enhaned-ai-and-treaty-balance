//==============================================================================
/* aiTownLayout.xs

   This file contains logic for organized town layouts, including grid-based
   placement of buildings like houses around the town center.

   To use this file, include it in your main AI file and call the appropriate
   functions from your building monitors.

*/
//==============================================================================

// Grid configuration constants
extern const float cGridSpacingX = 8.0;        // Horizontal spacing between grid cells
extern const float cGridSpacingZ = 8.0;        // Vertical spacing between grid cells
extern const int cMaxGridRadius = 5;           // Maximum rings of grid cells from center
extern const float cGridStartOffset = 15.0;    // Distance from TC to start the grid

// House grid state tracking
extern bool gHouseGridInitialized = false;
extern int gHouseGridPositions = -1;           // Array of grid position vectors
extern int gHouseGridOccupied = -1;            // Array tracking which positions are taken
extern int gHouseGridCount = 0;                // Total number of grid positions
extern int gNextHouseGridIndex = 0;            // Next position to try placing

// Military building grid configuration
extern const float cMilitaryGridSpacingX = 12.0;      // Larger spacing for military buildings
extern const float cMilitaryGridSpacingZ = 12.0;
extern const int cMilitaryGridRadius = 4;             // Rings of military grid positions
extern const float cMilitaryGridStartOffset = 35.0;   // Start further out than houses

// Military grid state tracking
extern bool gMilitaryGridInitialized = false;
extern int gMilitaryGridPositions = -1;
extern int gMilitaryGridOccupied = -1;
extern int gMilitaryGridCount = 0;
extern int gNextMilitaryGridIndex = 0;

//==============================================================================
// initHouseGrid
// Initialize the grid positions around the town center for house placement.
// Creates a square grid pattern with the TC at the center.
//==============================================================================
void initHouseGrid(int baseID = -1)
{
   if (gHouseGridInitialized == true)
   {
      return;
   }

   vector baseLocation = kbBaseGetLocation(cMyID, baseID);
   if (baseLocation == cInvalidVector)
   {
      return;
   }

   // Calculate total grid positions (square grid minus center area)
   int gridSize = (2 * cMaxGridRadius + 1);
   int maxPositions = gridSize * gridSize;
   
   gHouseGridPositions = xsArrayCreateVector(maxPositions, cInvalidVector, "House Grid Positions");
   gHouseGridOccupied = xsArrayCreateBool(maxPositions, false, "House Grid Occupied");
   
   int posIndex = 0;
   float minDistFromTC = cGridStartOffset;
   float posX = 0.0;
   float posZ = 0.0;
   vector gridPos = cInvalidVector;
   
   // Generate grid positions in a spiral-like order (closer positions first)
   for (ring = 1; <= cMaxGridRadius)
   {
      // Top row of ring (left to right)
      for (x = 0 - ring; <= ring)
      {
         posX = xsVectorGetX(baseLocation) + (x * cGridSpacingX);
         posZ = xsVectorGetZ(baseLocation) + (ring * cGridSpacingZ);
         gridPos = xsVectorSet(posX, 0.0, posZ);
         
         if (distance(gridPos, baseLocation) >= minDistFromTC)
         {
            xsArraySetVector(gHouseGridPositions, posIndex, gridPos);
            posIndex = posIndex + 1;
         }
      }
      
      // Right column of ring (top to bottom, excluding corners)
      for (z = ring - 1; >= 0 - ring + 1)
      {
         posX = xsVectorGetX(baseLocation) + (ring * cGridSpacingX);
         posZ = xsVectorGetZ(baseLocation) + (z * cGridSpacingZ);
         gridPos = xsVectorSet(posX, 0.0, posZ);
         
         if (distance(gridPos, baseLocation) >= minDistFromTC)
         {
            xsArraySetVector(gHouseGridPositions, posIndex, gridPos);
            posIndex = posIndex + 1;
         }
      }
      
      // Bottom row of ring (right to left)
      for (x = ring; >= 0 - ring)
      {
         posX = xsVectorGetX(baseLocation) + (x * cGridSpacingX);
         posZ = xsVectorGetZ(baseLocation) - (ring * cGridSpacingZ);
         gridPos = xsVectorSet(posX, 0.0, posZ);
         
         if (distance(gridPos, baseLocation) >= minDistFromTC)
         {
            xsArraySetVector(gHouseGridPositions, posIndex, gridPos);
            posIndex = posIndex + 1;
         }
      }
      
      // Left column of ring (bottom to top, excluding corners)
      for (z = 0 - ring + 1; <= ring - 1)
      {
         posX = xsVectorGetX(baseLocation) - (ring * cGridSpacingX);
         posZ = xsVectorGetZ(baseLocation) + (z * cGridSpacingZ);
         gridPos = xsVectorSet(posX, 0.0, posZ);
         
         if (distance(gridPos, baseLocation) >= minDistFromTC)
         {
            xsArraySetVector(gHouseGridPositions, posIndex, gridPos);
            posIndex = posIndex + 1;
         }
      }
   }
   
   gHouseGridCount = posIndex;
   gHouseGridInitialized = true;
   
   debugBuildings("Initialized house grid with " + gHouseGridCount + " positions around base " + baseID);
}

//==============================================================================
// resetHouseGrid
// Reset the grid state (call when main base changes).
//==============================================================================
void resetHouseGrid()
{
   gHouseGridInitialized = false;
   gNextHouseGridIndex = 0;
   
   if (gHouseGridPositions >= 0)
   {
      // Reset occupied flags
      for (i = 0; < gHouseGridCount)
      {
         xsArraySetBool(gHouseGridOccupied, i, false);
      }
   }
}

//==============================================================================
// initMilitaryGrid
// Initialize the grid positions for military building placement.
// Creates a square grid pattern further out from the TC than houses.
//==============================================================================
void initMilitaryGrid(int baseID = -1)
{
   if (gMilitaryGridInitialized == true)
   {
      return;
   }

   vector baseLocation = kbBaseGetLocation(cMyID, baseID);
   if (baseLocation == cInvalidVector)
   {
      return;
   }

   int gridSize = (2 * cMilitaryGridRadius + 1);
   int maxPositions = gridSize * gridSize;
   
   gMilitaryGridPositions = xsArrayCreateVector(maxPositions, cInvalidVector, "Military Grid Positions");
   gMilitaryGridOccupied = xsArrayCreateBool(maxPositions, false, "Military Grid Occupied");
   
   int posIndex = 0;
   float minDistFromTC = cMilitaryGridStartOffset;
   float posX = 0.0;
   float posZ = 0.0;
   vector gridPos = cInvalidVector;
   
   // Generate grid positions in rings, starting from the outside
   // Military buildings go on the perimeter for defense
   for (ring = cMilitaryGridRadius; >= 1)
   {
      // Top row of ring (left to right)
      for (x = 0 - ring; <= ring)
      {
         posX = xsVectorGetX(baseLocation) + (x * cMilitaryGridSpacingX);
         posZ = xsVectorGetZ(baseLocation) + (ring * cMilitaryGridSpacingZ) + cMilitaryGridStartOffset;
         gridPos = xsVectorSet(posX, 0.0, posZ);
         
         xsArraySetVector(gMilitaryGridPositions, posIndex, gridPos);
         posIndex = posIndex + 1;
      }
      
      // Right column of ring (top to bottom, excluding corners)
      for (z = ring - 1; >= 0 - ring + 1)
      {
         posX = xsVectorGetX(baseLocation) + (ring * cMilitaryGridSpacingX) + cMilitaryGridStartOffset;
         posZ = xsVectorGetZ(baseLocation) + (z * cMilitaryGridSpacingZ);
         gridPos = xsVectorSet(posX, 0.0, posZ);
         
         xsArraySetVector(gMilitaryGridPositions, posIndex, gridPos);
         posIndex = posIndex + 1;
      }
      
      // Bottom row of ring (right to left)
      for (x = ring; >= 0 - ring)
      {
         posX = xsVectorGetX(baseLocation) + (x * cMilitaryGridSpacingX);
         posZ = xsVectorGetZ(baseLocation) - (ring * cMilitaryGridSpacingZ) - cMilitaryGridStartOffset;
         gridPos = xsVectorSet(posX, 0.0, posZ);
         
         xsArraySetVector(gMilitaryGridPositions, posIndex, gridPos);
         posIndex = posIndex + 1;
      }
      
      // Left column of ring (bottom to top, excluding corners)
      for (z = 0 - ring + 1; <= ring - 1)
      {
         posX = xsVectorGetX(baseLocation) - (ring * cMilitaryGridSpacingX) - cMilitaryGridStartOffset;
         posZ = xsVectorGetZ(baseLocation) + (z * cMilitaryGridSpacingZ);
         gridPos = xsVectorSet(posX, 0.0, posZ);
         
         xsArraySetVector(gMilitaryGridPositions, posIndex, gridPos);
         posIndex = posIndex + 1;
      }
   }
   
   gMilitaryGridCount = posIndex;
   gMilitaryGridInitialized = true;
   
   debugBuildings("Initialized military grid with " + gMilitaryGridCount + " positions around base " + baseID);
}

//==============================================================================
// resetMilitaryGrid
// Reset the military grid state.
//==============================================================================
void resetMilitaryGrid()
{
   gMilitaryGridInitialized = false;
   gNextMilitaryGridIndex = 0;
   
   if (gMilitaryGridPositions >= 0)
   {
      for (i = 0; < gMilitaryGridCount)
      {
         xsArraySetBool(gMilitaryGridOccupied, i, false);
      }
   }
}

//==============================================================================
// resetAllGrids
// Reset both house and military grids (call when main base changes).
//==============================================================================
void resetAllGrids()
{
   resetHouseGrid();
   resetMilitaryGrid();
}

//==============================================================================
// isGridPositionValid
// Check if a grid position is valid for building.
//==============================================================================
bool isGridPositionValid(vector position = cInvalidVector, int baseID = -1)
{
   if (position == cInvalidVector)
   {
      return (false);
   }
   
   // Check if position is in the same area group as the base
   vector baseLocation = kbBaseGetLocation(cMyID, baseID);
   int baseAreaGroup = kbAreaGroupGetIDByPosition(baseLocation);
   int posAreaGroup = kbAreaGroupGetIDByPosition(position);
   
   if (baseAreaGroup != posAreaGroup)
   {
      return (false);
   }
   
   // Check if there's already a building nearby
   if (getUnitByLocation(cUnitTypeBuilding, cPlayerRelationAny, cUnitStateABQ, position, 5.0) >= 0)
   {
      return (false);
   }
   
   // Check if there's a resource blocking the position
   if (getUnitByLocation(cUnitTypeResource, 0, cUnitStateAlive, position, 4.0) >= 0)
   {
      return (false);
   }
   
   return (true);
}

//==============================================================================
// markGridPositionOccupied
// Mark a grid position as occupied after a house is built there.
//==============================================================================
void markGridPositionOccupied(vector position = cInvalidVector)
{
   if (gHouseGridInitialized == false)
   {
      return;
   }
   
   // Find the closest grid position to this location and mark it occupied
   float closestDist = 999.0;
   int closestIndex = -1;
   vector gridPos = cInvalidVector;
   float dist = 0.0;
   
   for (i = 0; < gHouseGridCount)
   {
      gridPos = xsArrayGetVector(gHouseGridPositions, i);
      dist = distance(position, gridPos);
      
      if (dist < closestDist)
      {
         closestDist = dist;
         closestIndex = i;
      }
   }
   
   if ((closestIndex >= 0) && (closestDist < cGridSpacingX))
   {
      xsArraySetBool(gHouseGridOccupied, closestIndex, true);
   }
}

//==============================================================================
// updateGridOccupancy
// Scan existing houses and mark their grid positions as occupied.
//==============================================================================
void updateGridOccupancy(int houseType = -1)
{
   if (gHouseGridInitialized == false)
   {
      return;
   }
   
   int houseQuery = createSimpleUnitQuery(houseType, cMyID, cUnitStateABQ);
   int numHouses = kbUnitQueryExecute(houseQuery);
   int houseID = -1;
   vector housePos = cInvalidVector;
   
   for (i = 0; < numHouses)
   {
      houseID = kbUnitQueryGetResult(houseQuery, i);
      housePos = kbUnitGetPosition(houseID);
      markGridPositionOccupied(housePos);
   }
}

//==============================================================================
// isMilitaryGridPositionValid
// Check if a military grid position is valid for building.
//==============================================================================
bool isMilitaryGridPositionValid(vector position = cInvalidVector, int baseID = -1)
{
   if (position == cInvalidVector)
   {
      return (false);
   }
   
   // Check if position is in the same area group as the base
   vector baseLocation = kbBaseGetLocation(cMyID, baseID);
   int baseAreaGroup = kbAreaGroupGetIDByPosition(baseLocation);
   int posAreaGroup = kbAreaGroupGetIDByPosition(position);
   
   if (baseAreaGroup != posAreaGroup)
   {
      return (false);
   }
   
   // Check if there's already a building nearby (larger radius for military)
   if (getUnitByLocation(cUnitTypeBuilding, cPlayerRelationAny, cUnitStateABQ, position, 8.0) >= 0)
   {
      return (false);
   }
   
   // Check if there's a resource blocking the position
   if (getUnitByLocation(cUnitTypeResource, 0, cUnitStateAlive, position, 6.0) >= 0)
   {
      return (false);
   }
   
   return (true);
}

//==============================================================================
// markMilitaryGridPositionOccupied
// Mark a military grid position as occupied.
//==============================================================================
void markMilitaryGridPositionOccupied(vector position = cInvalidVector)
{
   if (gMilitaryGridInitialized == false)
   {
      return;
   }
   
   float closestDist = 999.0;
   int closestIndex = -1;
   vector gridPos = cInvalidVector;
   float dist = 0.0;
   
   for (i = 0; < gMilitaryGridCount)
   {
      gridPos = xsArrayGetVector(gMilitaryGridPositions, i);
      dist = distance(position, gridPos);
      
      if (dist < closestDist)
      {
         closestDist = dist;
         closestIndex = i;
      }
   }
   
   if ((closestIndex >= 0) && (closestDist < cMilitaryGridSpacingX))
   {
      xsArraySetBool(gMilitaryGridOccupied, closestIndex, true);
   }
}

//==============================================================================
// updateMilitaryGridOccupancy
// Scan existing military buildings and mark their grid positions as occupied.
//==============================================================================
void updateMilitaryGridOccupancy()
{
   if (gMilitaryGridInitialized == false)
   {
      return;
   }
   
   // Query all military buildings
   int milQuery = createSimpleUnitQuery(cUnitTypeMilitaryBuilding, cMyID, cUnitStateABQ);
   int numBuildings = kbUnitQueryExecute(milQuery);
   int buildingID = -1;
   vector buildingPos = cInvalidVector;
   
   for (i = 0; < numBuildings)
   {
      buildingID = kbUnitQueryGetResult(milQuery, i);
      buildingPos = kbUnitGetPosition(buildingID);
      markMilitaryGridPositionOccupied(buildingPos);
   }
}

//==============================================================================
// getNextMilitaryGridPosition
// Get the next available military grid position for building placement.
// Returns cInvalidVector if no valid position is found.
//==============================================================================
vector getNextMilitaryGridPosition(int baseID = -1)
{
   if (gMilitaryGridInitialized == false)
   {
      initMilitaryGrid(baseID);
   }
   
   // Update occupancy based on existing military buildings
   updateMilitaryGridOccupancy();
   
   int attempts = 0;
   int maxAttempts = gMilitaryGridCount;
   int index = 0;
   vector position = cInvalidVector;
   
   while (attempts < maxAttempts)
   {
      index = (gNextMilitaryGridIndex + attempts) % gMilitaryGridCount;
      
      if (xsArrayGetBool(gMilitaryGridOccupied, index) == false)
      {
         position = xsArrayGetVector(gMilitaryGridPositions, index);
         
         if (isMilitaryGridPositionValid(position, baseID) == true)
         {
            gNextMilitaryGridIndex = (index + 1) % gMilitaryGridCount;
            return (position);
         }
         else
         {
            xsArraySetBool(gMilitaryGridOccupied, index, true);
         }
      }
      
      attempts = attempts + 1;
   }
   
   return (cInvalidVector);
}

//==============================================================================
// getNextGridPosition
// Get the next available grid position for house placement.
// Returns cInvalidVector if no valid position is found.
//==============================================================================
vector getNextGridPosition(int baseID = -1)
{
   if (gHouseGridInitialized == false)
   {
      initHouseGrid(baseID);
   }
   
   // Update occupancy based on existing houses
   updateGridOccupancy(gHouseUnit);
   
   // Search for the next available position
   int attempts = 0;
   int maxAttempts = gHouseGridCount;
   int index = 0;
   vector position = cInvalidVector;
   
   while (attempts < maxAttempts)
   {
      index = (gNextHouseGridIndex + attempts) % gHouseGridCount;
      
      if (xsArrayGetBool(gHouseGridOccupied, index) == false)
      {
         position = xsArrayGetVector(gHouseGridPositions, index);
         
         if (isGridPositionValid(position, baseID) == true)
         {
            gNextHouseGridIndex = (index + 1) % gHouseGridCount;
            return (position);
         }
         else
         {
            // Mark as occupied since it's not usable
            xsArraySetBool(gHouseGridOccupied, index, true);
         }
      }
      
      attempts = attempts + 1;
   }
   
   // No valid position found
   return (cInvalidVector);
}

//==============================================================================
// selectGridHouseBuildPlanPosition
// Configure a build plan to use grid-based house placement.
//==============================================================================
bool selectGridHouseBuildPlanPosition(int planID = -1, int baseID = -1)
{
   vector gridPosition = getNextGridPosition(baseID);
   
   if (gridPosition == cInvalidVector)
   {
      // Fall back to default placement if no grid position available
      debugBuildings("No grid position available, using default house placement");
      return (false);
   }
   
   debugBuildings("Using grid position for house: " + gridPosition);
   
   // Set the build plan to use this specific position
   aiPlanSetVariableVector(planID, cBuildPlanCenterPosition, 0, gridPosition);
   aiPlanSetVariableFloat(planID, cBuildPlanCenterPositionDistance, 0, 4.0);
   
   // Strong influence toward the grid position
   aiPlanSetVariableVector(planID, cBuildPlanInfluencePosition, 0, gridPosition);
   aiPlanSetVariableFloat(planID, cBuildPlanInfluencePositionDistance, 0, 20.0);
   aiPlanSetVariableFloat(planID, cBuildPlanInfluencePositionValue, 0, 200.0);
   aiPlanSetVariableInt(planID, cBuildPlanInfluencePositionFalloff, 0, cBPIFalloffLinear);
   
   // Negative influence for nearby houses to maintain spacing
   aiPlanSetVariableInt(planID, cBuildPlanInfluenceUnitTypeID, 0, gHouseUnit);
   aiPlanSetVariableFloat(planID, cBuildPlanInfluenceUnitDistance, 0, cGridSpacingX - 1.0);
   aiPlanSetVariableFloat(planID, cBuildPlanInfluenceUnitValue, 0, -100.0);
   aiPlanSetVariableInt(planID, cBuildPlanInfluenceUnitFalloff, 0, cBPIFalloffNone);
   
   return (true);
}

//==============================================================================
// createGridHouseBuildPlan
// Create a house build plan using grid placement.
//==============================================================================
int createGridHouseBuildPlan(int houseType = -1, int baseID = -1, int builderCount = 1)
{
   if (houseType < 0)
   {
      houseType = gHouseUnit;
   }
   
   if (baseID < 0)
   {
      baseID = kbBaseGetMainID(cMyID);
   }
   
   int planID = aiPlanCreate("Grid House Build Plan", cPlanBuild);
   
   if (planID < 0)
   {
      return (-1);
   }
   
   // What to build
   aiPlanSetVariableInt(planID, cBuildPlanBuildingTypeID, 0, houseType);
   
   // Buffer space
   aiPlanSetVariableFloat(planID, cBuildPlanBuildingBufferSpace, 0, 2.0);
   
   // Priority
   aiPlanSetDesiredPriority(planID, 95);
   aiPlanSetDesiredResourcePriority(planID, 65);
   
   // Escrow
   aiPlanSetEscrowID(planID, cEconomyEscrowID);
   
   // Try to use grid placement
   if (selectGridHouseBuildPlanPosition(planID, baseID) == false)
   {
      // Fall back to base placement
      aiPlanSetBaseID(planID, baseID);
   }
   
   // Add builder
   if (addBuilderToPlan(planID, houseType, builderCount) == false)
   {
      aiPlanDestroy(planID);
      return (-1);
   }
   
   aiPlanSetActive(planID);
   
   debugBuildings("Created grid house build plan: " + planID);
   
   return (planID);
}

//==============================================================================
// selectGridMilitaryBuildPlanPosition
// Configure a build plan to use grid-based military building placement.
//==============================================================================
bool selectGridMilitaryBuildPlanPosition(int planID = -1, int baseID = -1)
{
   vector gridPosition = getNextMilitaryGridPosition(baseID);
   
   if (gridPosition == cInvalidVector)
   {
      debugBuildings("No military grid position available, using default placement");
      return (false);
   }
   
   debugBuildings("Using military grid position: " + gridPosition);
   
   // Set the build plan to use this specific position
   aiPlanSetVariableVector(planID, cBuildPlanCenterPosition, 0, gridPosition);
   aiPlanSetVariableFloat(planID, cBuildPlanCenterPositionDistance, 0, 6.0);
   
   // Strong influence toward the grid position
   aiPlanSetVariableVector(planID, cBuildPlanInfluencePosition, 0, gridPosition);
   aiPlanSetVariableFloat(planID, cBuildPlanInfluencePositionDistance, 0, 30.0);
   aiPlanSetVariableFloat(planID, cBuildPlanInfluencePositionValue, 0, 200.0);
   aiPlanSetVariableInt(planID, cBuildPlanInfluencePositionFalloff, 0, cBPIFalloffLinear);
   
   // Negative influence for nearby military buildings to maintain spacing
   aiPlanSetVariableInt(planID, cBuildPlanInfluenceUnitTypeID, 0, cUnitTypeMilitaryBuilding);
   aiPlanSetVariableFloat(planID, cBuildPlanInfluenceUnitDistance, 0, cMilitaryGridSpacingX - 2.0);
   aiPlanSetVariableFloat(planID, cBuildPlanInfluenceUnitValue, 0, -100.0);
   aiPlanSetVariableInt(planID, cBuildPlanInfluenceUnitFalloff, 0, cBPIFalloffNone);
   
   return (true);
}

//==============================================================================
// createGridMilitaryBuildPlan
// Create a military building build plan using grid placement.
//==============================================================================
int createGridMilitaryBuildPlan(int buildingType = -1, int baseID = -1, int builderCount = 1, int escrowID = -1)
{
   if (buildingType < 0)
   {
      return (-1);
   }
   
   if (baseID < 0)
   {
      baseID = kbBaseGetMainID(cMyID);
   }
   
   if (escrowID < 0)
   {
      escrowID = cMilitaryEscrowID;
   }
   
   int planID = aiPlanCreate("Grid Military Build Plan", cPlanBuild);
   
   if (planID < 0)
   {
      return (-1);
   }
   
   // What to build
   aiPlanSetVariableInt(planID, cBuildPlanBuildingTypeID, 0, buildingType);
   
   // Buffer space (larger for military buildings)
   aiPlanSetVariableFloat(planID, cBuildPlanBuildingBufferSpace, 0, 4.0);
   
   // Priority
   aiPlanSetDesiredPriority(planID, 70);
   aiPlanSetDesiredResourcePriority(planID, 55);
   
   // Escrow
   aiPlanSetEscrowID(planID, escrowID);
   
   // Try to use grid placement
   if (selectGridMilitaryBuildPlanPosition(planID, baseID) == false)
   {
      // Fall back to base placement
      aiPlanSetBaseID(planID, baseID);
   }
   
   // Add builder
   if (addBuilderToPlan(planID, buildingType, builderCount) == false)
   {
      aiPlanDestroy(planID);
      return (-1);
   }
   
   aiPlanSetActive(planID);
   
   debugBuildings("Created grid military build plan for " + kbGetProtoUnitName(buildingType) + ": " + planID);
   
   return (planID);
}

//==============================================================================
// isMilitaryBuildingType
// Check if a building type is a military production building.
//==============================================================================
bool isMilitaryBuildingType(int buildingType = -1)
{
   if (buildingType < 0)
   {
      return (false);
   }
   
   // Check against common military building types
   if (buildingType == cUnitTypeBarracks)
   {
      return (true);
   }
   if (buildingType == cUnitTypeStable)
   {
      return (true);
   }
   if (buildingType == cUnitTypeArtilleryDepot)
   {
      return (true);
   }
   if (buildingType == cUnitTypeWarHut)
   {
      return (true);
   }
   if (buildingType == cUnitTypeNoblesHut)
   {
      return (true);
   }
   if (buildingType == cUnitTypeCorral)
   {
      return (true);
   }
   if (buildingType == cUnitTypeypBarracksJapanese)
   {
      return (true);
   }
   if (buildingType == cUnitTypeypStableJapanese)
   {
      return (true);
   }
   if (buildingType == cUnitTypeypWarAcademy)
   {
      return (true);
   }
   if (buildingType == cUnitTypeypCastle)
   {
      return (true);
   }
   if (buildingType == cUnitTypeBlockhouse)
   {
      return (true);
   }
   if (buildingType == cUnitTypedeWarCamp)
   {
      return (true);
   }
   if (buildingType == cUnitTypedeKallanka)
   {
      return (true);
   }
   if (buildingType == cUnitTypedePalace)
   {
      return (true);
   }
   if (buildingType == cUnitTypedeHospital)
   {
      return (true);
   }
   if (buildingType == cUnitTypedeCommandery)
   {
      return (true);
   }
   
   return (false);
}

//==============================================================================
// gridHouseMonitor
// Alternative house monitor that uses grid-based placement.
//==============================================================================
rule gridHouseMonitor
inactive
minInterval 15
{
   if (needMoreHouses() == false)
   {
      return;
   }
   
   int mainBaseID = kbBaseGetMainID(cMyID);
   
   // Initialize grid if needed
   if (gHouseGridInitialized == false)
   {
      initHouseGrid(mainBaseID);
   }
   
   // Check build limit
   if (kbGetBuildLimit(cMyID, gHouseUnit) <= kbUnitCount(cMyID, gHouseUnit, cUnitStateABQ) + 
       aiPlanGetNumberByTypeAndVariableType(cPlanBuild, cBuildPlanBuildingTypeID, gHouseUnit, true))
   {
      return;
   }
   
   // Check if we already have a house build plan
   int existingPlan = aiPlanGetIDByTypeAndVariableType(cPlanBuild, cBuildPlanBuildingTypeID, gHouseUnit);
   if (existingPlan >= 0)
   {
      return;
   }
   
   int villageCount = 0;
   
   // Special handling for Chinese (they use village pop upgrades)
   if ((cMyCiv == cCivChinese) || (cMyCiv == cCivSPCChinese))
   {
      villageCount = kbUnitCount(cMyID, cUnitTypeypVillage, cUnitStateAlive);
      
      if (villageCount >= 4)
      {
         // Try to research pop upgrades first
         if (((researchSimpleTech(cTechypVillagePopCapIncrease, cUnitTypeypVillage, -1, 65) == true) &&
              (researchSimpleTech(cTechypVillagePopCapIncrease2, cUnitTypeypVillage, -1, 65) == true) &&
              (researchSimpleTech(cTechypVillagePopCapIncrease3, cUnitTypeypVillage, -1, 65) == true) &&
              (researchSimpleTech(cTechypVillagePopCapIncrease4, cUnitTypeypVillage, -1, 65) == true)) == false)
         {
            return;
         }
      }
   }
   
   // Create grid-based house build plan
   createGridHouseBuildPlan(gHouseUnit, mainBaseID, 1);
}

//==============================================================================
// debugDrawGrid
// Debug function to output grid state information.
//==============================================================================
void debugDrawGrid()
{
   int occupiedCount = 0;
   
   debugBuildings("=== House Grid Debug ===");
   if (gHouseGridInitialized == false)
   {
      debugBuildings("House grid not initialized");
   }
   else
   {
      debugBuildings("Total positions: " + gHouseGridCount);
      
      occupiedCount = 0;
      for (i = 0; < gHouseGridCount)
      {
         if (xsArrayGetBool(gHouseGridOccupied, i) == true)
         {
            occupiedCount = occupiedCount + 1;
         }
      }
      
      debugBuildings("Occupied positions: " + occupiedCount);
      debugBuildings("Available positions: " + (gHouseGridCount - occupiedCount));
      debugBuildings("Next index: " + gNextHouseGridIndex);
   }
   
   debugBuildings("=== Military Grid Debug ===");
   if (gMilitaryGridInitialized == false)
   {
      debugBuildings("Military grid not initialized");
   }
   else
   {
      debugBuildings("Total positions: " + gMilitaryGridCount);
      
      occupiedCount = 0;
      for (j = 0; < gMilitaryGridCount)
      {
         if (xsArrayGetBool(gMilitaryGridOccupied, j) == true)
         {
            occupiedCount = occupiedCount + 1;
         }
      }
      
      debugBuildings("Occupied positions: " + occupiedCount);
      debugBuildings("Available positions: " + (gMilitaryGridCount - occupiedCount));
      debugBuildings("Next index: " + gNextMilitaryGridIndex);
   }
}
