//==============================================================================
// militaryBuildingsManager
// Make sure we build extra military buildings if we have the money.
//==============================================================================
rule militaryBuildingsManager
inactive
minInterval 30
{
    if ((kbUnitCount(cMyID, cUnitTypeBarracks, cUnitStateABQ) < 5) && (kbGetAge() > cAge3) &&
    (kbResourceGet(cResourceWood) > 500.0) &&
    (aiPlanGetIDByTypeAndVariableType(cPlanBuild, cBuildPlanBuildingTypeID, cUnitTypeBarracks, true) < 0) &&
    (queuedBuildPlanBlocks(cUnitTypeBarracks) == false))
    {
        createSimpleBuildPlan(cUnitTypeBarracks, 1, 85, true, cMilitaryEscrowID, kbBaseGetMainID(cMyID), 1);
    }

    if ((kbUnitCount(cMyID, gStablesUnit, cUnitStateABQ) < 5) && (kbGetAge() > cAge3) &&
    (kbResourceGet(cResourceWood) > 500.0) &&
    (aiPlanGetIDByTypeAndVariableType(cPlanBuild, cBuildPlanBuildingTypeID, gStablesUnit, true) < 0) &&
    (queuedBuildPlanBlocks(gStablesUnit) == false))
    {
        createSimpleBuildPlan(gStablesUnit, 1, 85, true, cMilitaryEscrowID, kbBaseGetMainID(cMyID), 1);
    }

    if ((kbUnitCount(cMyID, cUnitTypeArtilleryDepot, cUnitStateABQ) < 3) && (kbGetAge() > cAge4) &&
    (kbResourceGet(cResourceWood) > 1500.0) &&
    (aiPlanGetIDByTypeAndVariableType(cPlanBuild, cBuildPlanBuildingTypeID, cUnitTypeArtilleryDepot, true) < 0) &&
    (queuedBuildPlanBlocks(cUnitTypeArtilleryDepot) == false))
    {
        createSimpleBuildPlan(cUnitTypeArtilleryDepot, 1, 75, true, cMilitaryEscrowID, kbBaseGetMainID(cMyID), 1);
    }
    //updateMilitaryTrainPlanBuildings(kbBaseGetMainID(cMyID));
}
//==============================================================================
// setUnitPickerRoyalGuardPreference
// Sets higher preference for civilization-specific Royal Guard units.
// Call this in setUnitPickerPreference() after the base preferences are set.
//==============================================================================
void setUnitPickerRoyalGuardPreference(int upID = -1)
{
   if (upID < 0)
   {
      return;
   }

   // Only boost Royal Guard preferences from Age 3 onwards when upgrades become available
   if (kbGetAge() < cAge3)
   {
      return;
   }

   // High preference value for Royal Guard units
   float royalGuardPref = 0.9;
   // Lower preference for units that are outclassed by Royal Guard equivalents
   float outclassedPref = 0.2;

   switch (cMyCiv)
   {
      // European civilizations
      case cCivBritish:
      {
         // Redcoats (Musketeers)
         kbUnitPickSetPreferenceFactor(upID, cUnitTypeMusketeer, royalGuardPref);
         kbUnitPickSetPreferenceFactor(upID, cUnitTypedeRanger, royalGuardPref);
         kbUnitPickSetPreferenceFactor(upID, cUnitTypeHussar, royalGuardPref);
         break;
      }
      case cCivDutch:
      {
         // Nassau Halberdiers (Halberdiers) and Carabiniers (Ruyters)
         kbUnitPickSetPreferenceFactor(upID, cUnitTypeHalberdier, royalGuardPref);
         kbUnitPickSetPreferenceFactor(upID, cUnitTypeRuyter, royalGuardPref);
         // Reduce preference for regular Pikemen since Halberdiers are better
         kbUnitPickSetPreferenceFactor(upID, cUnitTypePikeman, outclassedPref);
         break;
      }
      case cCivFrench:
      {
         // Voltigeurs (Skirmishers) and Gendarmes (Cuirassiers)
         kbUnitPickSetPreferenceFactor(upID, cUnitTypeSkirmisher, royalGuardPref);
         kbUnitPickSetPreferenceFactor(upID, cUnitTypeCuirassier, royalGuardPref);
         break;
      }
      case cCivGermans:
      {
         // Needle Gunners (Skirmishers) and Czapka Uhlans (Uhlans)
         royalGuardPref = 0.74;
         kbUnitPickSetPreferenceFactor(upID, cUnitTypeSkirmisher, royalGuardPref);
         kbUnitPickSetPreferenceFactor(upID, cUnitTypeUhlan, royalGuardPref);
         //kbUnitPickSetPreferenceFactor(upID, cUnitTypeMercenary, royalGuardPref);
         break;
      }
      case cCivOttomans:
      {
         // Baratcu (Grenadiers) and Gardener Hussars (Hussars)
         kbUnitPickSetPreferenceFactor(upID, cUnitTypeGrenadier, royalGuardPref);
         kbUnitPickSetPreferenceFactor(upID, cUnitTypeHussar, royalGuardPref);
         break;
      }
      case cCivPortuguese:
      {
         // Guerreiros (Musketeers) and Jinetes (Dragoons)
         kbUnitPickSetPreferenceFactor(upID, cUnitTypeMusketeer, royalGuardPref);
         kbUnitPickSetPreferenceFactor(upID, cUnitTypeDragoon, royalGuardPref);
         break;
      }
      case cCivRussians:
      {
         // Pavlov Grenadiers (Grenadiers) and Tartar Loyalists (Cavalry Archers)
         kbUnitPickSetPreferenceFactor(upID, cUnitTypeGrenadier, royalGuardPref);
         kbUnitPickSetPreferenceFactor(upID, cUnitTypeCavalryArcher, royalGuardPref);
         break;
      }
      case cCivSpanish:
      {
         // Tercio Pikemen (Rodeleros) and Garrochistas (Lancers)
         kbUnitPickSetPreferenceFactor(upID, cUnitTypeRodelero, royalGuardPref);
         kbUnitPickSetPreferenceFactor(upID, cUnitTypeLancer, royalGuardPref);
         // Soldiers if available
         kbUnitPickSetPreferenceFactor(upID, cUnitTypedeMXSpanishMusketeer, royalGuardPref);
         break;
      }
      case cCivDESwedish:
      {
         // Dalkarls (Pikemen) and Hakkapelits
         kbUnitPickSetPreferenceFactor(upID, cUnitTypePikeman, royalGuardPref);
         kbUnitPickSetPreferenceFactor(upID, cUnitTypedeFinnishRider, royalGuardPref);
         break;
      }
      // Native American civilizations
      case cCivXPAztec:
      {
         // Skull Knights (Jaguar Prowl Knights) and Arrow Knights
         kbUnitPickSetPreferenceFactor(upID, cUnitTypexpJaguarKnight, royalGuardPref);
         kbUnitPickSetPreferenceFactor(upID, cUnitTypexpArrowKnight, royalGuardPref);
         break;
      }
      case cCivXPIroquois:
      {
         // Champion Tomahawks and Elite Forest Prowlers
         kbUnitPickSetPreferenceFactor(upID, cUnitTypexpTomahawk, royalGuardPref);
         kbUnitPickSetPreferenceFactor(upID, cUnitTypexpWarRifle, royalGuardPref);
         break;
      }
      case cCivXPSioux:
      {
         // Champion Axe Riders and Elite Rifle Riders
         kbUnitPickSetPreferenceFactor(upID, cUnitTypexpAxeRider, royalGuardPref);
         kbUnitPickSetPreferenceFactor(upID, cUnitTypexpRifleRider, royalGuardPref);
         break;
      }
      // Asian civilizations
      case cCivChinese:
      case cCivSPCChinese:
      {
         // Arquebusiers and Meteor Hammers
         kbUnitPickSetPreferenceFactor(upID, cUnitTypeypArquebusier, royalGuardPref);
         kbUnitPickSetPreferenceFactor(upID, cUnitTypeypMeteorHammer, royalGuardPref);
         break;
      }
      case cCivIndians:
      case cCivSPCIndians:
      {
         // Sepoys and Sowars
         kbUnitPickSetPreferenceFactor(upID, cUnitTypeypSepoy, royalGuardPref);
         kbUnitPickSetPreferenceFactor(upID, cUnitTypeypSowar, royalGuardPref);
         break;
      }
      case cCivJapanese:
      case cCivSPCJapanese:
      case cCivSPCJapaneseEnemy:
      {
         // Samurai and Ashigaru
         kbUnitPickSetPreferenceFactor(upID, cUnitTypeypKensei, royalGuardPref);
         kbUnitPickSetPreferenceFactor(upID, cUnitTypeypAshigaru, royalGuardPref);
         break;
      }
      // African civilizations
      case cCivDEEthiopians:
      {
         // Oromo Warriors and Shotel Warriors
         kbUnitPickSetPreferenceFactor(upID, cUnitTypedeOromoWarrior, royalGuardPref);
         kbUnitPickSetPreferenceFactor(upID, cUnitTypedeShotelWarrior, royalGuardPref);
         break;
      }
      case cCivDEHausa:
      {
         // Fulani Archers and Raiders
         kbUnitPickSetPreferenceFactor(upID, cUnitTypedeFulaWarrior, royalGuardPref);
         kbUnitPickSetPreferenceFactor(upID, cUnitTypedeRaider, royalGuardPref);
         break;
      }
      // Inca
      case cCivDEInca:
      {
         // Bolas Warriors and Jungle Bowmen
         kbUnitPickSetPreferenceFactor(upID, cUnitTypedeBolasWarrior, royalGuardPref);
         kbUnitPickSetPreferenceFactor(upID, cUnitTypedeJungleBowman, royalGuardPref);
         break;
      }
      // American civilizations (DE)
      case cCivDEAmericans:
      {
         // Sharpshooters and Carbine Cavalry
         kbUnitPickSetPreferenceFactor(upID, cUnitTypedeRifleman, royalGuardPref);
         kbUnitPickSetPreferenceFactor(upID, cUnitTypedeUSCavalry, royalGuardPref);
         break;
      }
      case cCivDEMexicans:
      {
         // Soldados and Chinacos
         kbUnitPickSetPreferenceFactor(upID, cUnitTypedeSoldado, royalGuardPref);
         kbUnitPickSetPreferenceFactor(upID, cUnitTypedeChinaco, royalGuardPref);
         break;
      }
      case cCivDEItalians:
      {
         // Bersaglieri and Pavisiers
         kbUnitPickSetPreferenceFactor(upID, cUnitTypedeBersagliere, royalGuardPref);
         kbUnitPickSetPreferenceFactor(upID, cUnitTypedePavisier, royalGuardPref);
         break;
      }
      case cCivDEMaltese:
      {
         // Hospitaller Knights and Fire Throwers
         kbUnitPickSetPreferenceFactor(upID, cUnitTypedeHospitaller, royalGuardPref);
         kbUnitPickSetPreferenceFactor(upID, cUnitTypedeHoopThrower, royalGuardPref);
         break;
      }
      case cCivDEPolish:
      {
         // Piechurs, Winged Hussars, and Retainers
         kbUnitPickSetPreferenceFactor(upID, cUnitTypedePiechur, royalGuardPref);
         kbUnitPickSetPreferenceFactor(upID, cUnitTypedeWingedHussar, royalGuardPref);
         kbUnitPickSetPreferenceFactor(upID, cUnitTypedeLithuanianRider, royalGuardPref);
         break;
      }
      case cCivDEDanish:
      {
         // Mounted Friskytter and Ski Troopers
         kbUnitPickSetPreferenceFactor(upID, cUnitTypedeFriskytteRider, royalGuardPref);
         kbUnitPickSetPreferenceFactor(upID, cUnitTypeSkirmisher, royalGuardPref);
         break;
      }
   }
}
//==============================================================================
// setUnitPickerSpecialUnitPreference
// Sets higher preference for civilization-specific special units that are
// unlocked through cards or other means.
// Call this in setUnitPickerPreference() after the base preferences are set.
//==============================================================================
void setUnitPickerSpecialUnitPreference(int upID = -1)
{
   if (upID < 0)
   {
      return;
   }

   // High preference value for special unlocked units
   float specialUnitPref = 0.8;

   // Base preferences for tavern units, scaling with age
   float outlawPref = -1.0;
   float mercenaryPref = 0.1;

   // Tavern unit preferences - applies to all civs with a Tavern/Saloon
   int tavernCount = kbUnitCount(cMyID, cUnitTypeSaloon, cUnitStateAlive);
   if (tavernCount < 1)
   {
      tavernCount = kbUnitCount(cMyID, cUnitTypedeTavern, cUnitStateAlive);
   }

   if (tavernCount > 0 || tavernCount < 1)
   {
      int age = kbGetAge();

    //   if (age >= cAge3)
    //   {
    //      outlawPref = 0.5;
    //      mercenaryPref = 0.6;
    //   }

    //   if (age >= cAge4)
    //   {
    //      outlawPref = 0.6;
    //      mercenaryPref = 0.7;
    //   }

      // Set base preferences for outlaws and mercenaries
      kbUnitPickSetPreferenceFactor(upID, cUnitTypeAbstractOutlaw, outlawPref);
      kbUnitPickSetPreferenceFactor(upID, cUnitTypeMercenary, mercenaryPref);

      // Civilization-specific bonuses for tavern units
      if (cMyCiv == cCivGermans)
      {
         // Germans get cheaper mercenaries and should use them more
         kbUnitPickSetPreferenceFactor(upID, cUnitTypeMercenary, mercenaryPref + 0.15);
         //kbUnitPickSetPreferenceFactor(upID, cUnitTypeAbstractOutlaw, outlawPref + 0.1);
      }
      else if (cMyCiv == cCivDEAmericans)
      {
         // Americans have strong outlaw synergy
         kbUnitPickSetPreferenceFactor(upID, cUnitTypeAbstractOutlaw, outlawPref + 0.15);
      }
      else if (cMyCiv == cCivDEMexicans)
      {
         // Mexicans have outlaw bonuses
         kbUnitPickSetPreferenceFactor(upID, cUnitTypeAbstractOutlaw, outlawPref + 0.2);
      }
   }

   // Civilization-specific special units
   switch (cMyCiv)
   {
      case cCivBritish:
      {
         // Black Watch (Highland Infantry) - unlocked via "Black Watch" card
         if (kbGetBuildLimit(cMyID, cUnitTypeMercHighlander) != 0)
         {
            kbUnitPickSetPreferenceFactor(upID, cUnitTypeMercHighlander, specialUnitPref);
         }
         break;
      }
      case cCivDutch:
      {
         // Swiss Pikemen - unlocked via "Swiss Pikemen" card
         if (kbGetBuildLimit(cMyID, cUnitTypeMercSwissPikeman) != 0)
         {
            kbUnitPickSetPreferenceFactor(upID, cUnitTypeMercSwissPikeman, specialUnitPref);
         }
         // Blue Guards (Stadhouder Guard) - unlocked via "Blue Guards" card
         if (kbGetBuildLimit(cMyID, cUnitTypeMusketeer) != 0)
         {
            kbUnitPickSetPreferenceFactor(upID, cUnitTypeMusketeer, specialUnitPref);
         }
         break;
      }
      case cCivFrench:
      {
         // French should avoid Native Scouts
         kbUnitPickSetPreferenceFactor(upID, cUnitTypeNativeScout, -1.0);
         break;
      }
      case cCivGermans:
      {
         // German mercenaries unlocked via "Mercenary Camp" card (or similar)
         // Landsknecht
         if (kbGetBuildLimit(cMyID, cUnitTypeMercLandsknecht) != 0)
         {
            kbUnitPickSetPreferenceFactor(upID, cUnitTypeMercLandsknecht, specialUnitPref);
         }
         // Black Rider
         if (kbGetBuildLimit(cMyID, cUnitTypeMercBlackRider) != 0)
         {
            kbUnitPickSetPreferenceFactor(upID, cUnitTypeMercBlackRider, mercenaryPref + 0.85);
         }
         // Jaeger (Needle Gunner mercenary version)
         if (kbGetBuildLimit(cMyID, cUnitTypeMercJaeger) != 0)
         {
            kbUnitPickSetPreferenceFactor(upID, cUnitTypeMercJaeger, mercenaryPref + 0.85);
         }
         // War Wagon
         if (kbGetBuildLimit(cMyID, cUnitTypeWarWagon) != 0)
         {
            kbUnitPickSetPreferenceFactor(upID, cUnitTypeWarWagon, specialUnitPref + 0.1);
         }
         // Giant Grenadier
         if (kbGetBuildLimit(cMyID, cUnitTypedeMercGrenadier) != 0)
         {
            kbUnitPickSetPreferenceFactor(upID, cUnitTypedeMercGrenadier, mercenaryPref + 0.85);
         }
         break;
      }
      case cCivSpanish: 
      {
         // Wild Geese
         if (kbGetBuildLimit(cMyID, cUnitTypedeMercBrigadier) != 0)
         {
            kbUnitPickSetPreferenceFactor(upID, cUnitTypedeMercBrigadier, mercenaryPref + 0.85);
         }
         // Walloon Guards
         if (kbGetBuildLimit(cMyID, cUnitTypeMercFusilier) != 0)
         {
            kbUnitPickSetPreferenceFactor(upID, cUnitTypeMercFusilier, mercenaryPref + 0.85);
         }
         break;
      }
   }
}
//==============================================================================
// setUnitPickerArchaicUnitFilter
// Reduces preference for archaic/outdated units in later ages when the
// civilization has access to superior alternatives.
// Call this in setUnitPickerPreference() after the base preferences are set.
//==============================================================================
void setUnitPickerArchaicUnitFilter(int upID = -1)
{
   if (upID < 0)
   {
      return;
   }

   // Only apply filtering from Age 4 onwards
   if (kbGetAge() < cAge4)
   {
      return;
   }

   // Very low preference to effectively disable these units
   float archaicUnitPref = 0.05;

   switch (cMyCiv)
   {
      case cCivBritish:
      {
         // British should avoid Pikemen and Halberdiers in Age 4+
         // They have Redcoat Musketeers and Hussars as better options
         kbUnitPickSetPreferenceFactor(upID, cUnitTypePikeman, archaicUnitPref);
         kbUnitPickSetPreferenceFactor(upID, cUnitTypeHalberdier, archaicUnitPref);
         break;
      }
      case cCivFrench:
      {
         // French should avoid Pikemen and Halberdiers in Age 4+
         // They have Gendarmes (Cuirassiers) and Voltigeurs (Skirmishers) as Royal Guard
         kbUnitPickSetPreferenceFactor(upID, cUnitTypePikeman, archaicUnitPref);
         kbUnitPickSetPreferenceFactor(upID, cUnitTypeHalberdier, archaicUnitPref);
         break;
      }
   }
}
//==============================================================================
/* Secondary base train plan tracking  */
//==============================================================================
void initSecondaryBaseTrainPlanArrays(void)
{
   if (gSecondaryBaseTrainPlans >= 0)
   {
      return;
   }

   gSecondaryBaseTrainPlans = xsArrayCreateInt(20, -1, "Secondary base train plans");
   gSecondaryBaseTrainPlanUnitTypes = xsArrayCreateInt(20, -1, "Secondary base train plan unit types");
   gSecondaryBaseTrainPlanBaseIDs = xsArrayCreateInt(20, -1, "Secondary base train plan base IDs");
   gSecondaryBaseTrainPlanCount = 0;
}

//==============================================================================
// releaseSecondaryBaseTrainPlanSlot
// Frees a tracker slot for reuse. Does not touch the plan itself.
//==============================================================================
void releaseSecondaryBaseTrainPlanSlot(int slot = -1)
{
   xsArraySetInt(gSecondaryBaseTrainPlans, slot, -1);
   xsArraySetInt(gSecondaryBaseTrainPlanUnitTypes, slot, -1);
   xsArraySetInt(gSecondaryBaseTrainPlanBaseIDs, slot, -1);
}

//==============================================================================
// findSecondaryBaseTrainPlan
// Returns the live maintain plan for this unit type at this base, or -1.
//==============================================================================
int findSecondaryBaseTrainPlan(int puid = -1, int baseID = -1)
{
   initSecondaryBaseTrainPlanArrays();

   int planID = -1;
   for (i = 0; < gSecondaryBaseTrainPlanCount)
   {
      planID = xsArrayGetInt(gSecondaryBaseTrainPlans, i);
      if (planID < 0)
      {
         continue;
      }

      if (aiPlanGetState(planID) < 0)
      {
         releaseSecondaryBaseTrainPlanSlot(i);
         continue;
      }

      if ((xsArrayGetInt(gSecondaryBaseTrainPlanUnitTypes, i) == puid) &&
          (xsArrayGetInt(gSecondaryBaseTrainPlanBaseIDs, i) == baseID))
      {
         return(planID);
      }
   }

   return(-1);
}

//==============================================================================
// trackSecondaryBaseTrainPlan
// Records a newly created maintain plan against its unit type and base.
//==============================================================================
void trackSecondaryBaseTrainPlan(int planID = -1, int puid = -1, int baseID = -1)
{
   initSecondaryBaseTrainPlanArrays();

   // Reuse a released slot before growing the tracker.
   for (i = 0; < gSecondaryBaseTrainPlanCount)
   {
      if (xsArrayGetInt(gSecondaryBaseTrainPlans, i) < 0)
      {
         xsArraySetInt(gSecondaryBaseTrainPlans, i, planID);
         xsArraySetInt(gSecondaryBaseTrainPlanUnitTypes, i, puid);
         xsArraySetInt(gSecondaryBaseTrainPlanBaseIDs, i, baseID);
         return;
      }
   }

   if (gSecondaryBaseTrainPlanCount >= 20)
   {
      debugMilitary("*** Secondary base train plan tracker is full, not tracking " + kbGetUnitTypeName(puid));
      return;
   }

   xsArraySetInt(gSecondaryBaseTrainPlans, gSecondaryBaseTrainPlanCount, planID);
   xsArraySetInt(gSecondaryBaseTrainPlanUnitTypes, gSecondaryBaseTrainPlanCount, puid);
   xsArraySetInt(gSecondaryBaseTrainPlanBaseIDs, gSecondaryBaseTrainPlanCount, baseID);
   gSecondaryBaseTrainPlanCount++;
}

//==============================================================================
// destroySecondaryBaseTrainPlans
// Tears down maintain plans this system created.
//==============================================================================
void destroySecondaryBaseTrainPlans(int baseID = -1)
{
   initSecondaryBaseTrainPlanArrays();

   int planID = -1;
   int slotBaseID = -1;
   bool destroyIt = false;

   for (i = 0; < gSecondaryBaseTrainPlanCount)
   {
      planID = xsArrayGetInt(gSecondaryBaseTrainPlans, i);
      if (planID < 0)
      {
         continue;
      }

      slotBaseID = xsArrayGetInt(gSecondaryBaseTrainPlanBaseIDs, i);

      destroyIt = false;
      if (baseID >= 0)
      {
         if (slotBaseID == baseID)
         {
            destroyIt = true;
         }
      }
      else if ((slotBaseID != gIslandBaseID) && (slotBaseID != gForwardBaseID))
      {
         destroyIt = true;
      }

      if (destroyIt == false)
      {
         continue;
      }

      debugMilitary("*** Destroying secondary base maintain plan for " +
         kbGetUnitTypeName(xsArrayGetInt(gSecondaryBaseTrainPlanUnitTypes, i)) + " at base " + slotBaseID);
      aiPlanDestroy(planID);
      releaseSecondaryBaseTrainPlanSlot(i);
   }
}
//==============================================================================
// updateSecondaryBaseMilitaryTrainPlans
// Creates or updates maintain plans for military buildings at forward/island bases.
// Existing plans are updated in place; new plans are created only when needed.
// Plans for unit types that can no longer be trained at this base are destroyed.
//==============================================================================
void updateSecondaryBaseMilitaryTrainPlans(int baseID = -1)
{
   int planID = -1;
   int numberPlans = 0;

   if (gSecondaryBaseMaintainPlans < 0)
   {
      gSecondaryBaseMaintainPlans = xsArrayCreateInt(gNumArmyUnitTypes, -1, "Secondary Base Maintain Plans");
   }
   numberPlans = xsArrayGetSize(gSecondaryBaseMaintainPlans);

   if (baseID != gSecondaryBaseMaintainBaseID)
   {
      for (i = 0; < numberPlans)
      {
         planID = xsArrayGetInt(gSecondaryBaseMaintainPlans, i);
         if (planID >= 0)
         {
            aiPlanDestroy(planID);
            xsArraySetInt(gSecondaryBaseMaintainPlans, i, -1);
         }
      }
      gSecondaryBaseMaintainBaseID = -1;
   }

   if (baseID < 0)
   {
      destroySecondaryBaseTrainPlans(-1);
      return;
   }

   // Query for military buildings at this base
   vector baseLoc = kbBaseGetLocation(cMyID, baseID);
   float baseDist = kbBaseGetDistance(cMyID, baseID);

   int buildingQuery = createSimpleUnitQuery(cUnitTypeLogicalTypeBuildingsNotWalls, cMyID, cUnitStateAlive, baseLoc, baseDist);
   int numberFound = kbUnitQueryExecute(buildingQuery);

   if (numberFound == 0)
   {
      destroySecondaryBaseTrainPlans(baseID);
      return;
   }

   static int trainBuildingIDs = -1;
   if (trainBuildingIDs < 0)
   {
      trainBuildingIDs = xsArrayCreateInt(8, -1, "Secondary base train buildings");
   }

   int buildingID = -1;
   int buildingPUID = -1;
   int puid = -1;
   int popCount = 0;
   int numberToMaintain = 0;
   int numTrainBuildings = 0;
   float totalFactor = 0.0;

   // Calculate total factor from unit picker.
   for (i = 0; < gNumArmyUnitTypes)
   {
      totalFactor = totalFactor + kbUnitPickGetResultFactor(gLandUnitPicker, i);
   }

   if (totalFactor <= 0.0)
   {
      return;
   }

   // Track which unit types are still valid this cycle so we can prune stale plans.
   static int validUnitTypes = -1;
   if (validUnitTypes < 0)
   {
      validUnitTypes = xsArrayCreateInt(20, -1, "Valid secondary train unit types");
   }
   int numValidTypes = 0;

   // For each unit type in the picker, check if we can train it at this base.
   for (i = 0; < gNumArmyUnitTypes)
   {
      if (i >= numberPlans)
      {
         break;
      }

      puid = kbUnitPickGetResult(gLandUnitPicker, i);
      planID = xsArrayGetInt(gSecondaryBaseMaintainPlans, i);

      if (puid < 0)
      {
         if (planID >= 0)
         {
            aiPlanDestroy(planID);
            xsArraySetInt(gSecondaryBaseMaintainPlans, i, -1);
         }
         continue;
      }

      // Find ALL buildings at this base that can train this unit.
      numTrainBuildings = 0;
      for (j = 0; < numberFound)
      {
         if (numTrainBuildings >= 8)
         {
            break;
         }
         buildingID = kbUnitQueryGetResult(buildingQuery, j);
         buildingPUID = kbUnitGetProtoUnitID(buildingID);
         if ((kbProtoUnitCanTrain(buildingPUID, puid) == true) && (numTrainBuildings < 8))
         {
            xsArraySetInt(trainBuildingIDs, numTrainBuildings, buildingID);
            numTrainBuildings++;
         }
      }

      if (numTrainBuildings == 0)
      {
         continue; // Can't train this unit type at this base.
      }

      // Mark this unit type as valid for this cycle.
      if (numValidTypes < 20)
      {
         xsArraySetInt(validUnitTypes, numValidTypes, puid);
         numValidTypes++;
      }

      // Calculate number to maintain.
      popCount = kbGetProtoUnitPopCount(puid);
      if (popCount > 0)
      {
         numberToMaintain = (kbUnitPickGetResultFactor(gLandUnitPicker, i) / totalFactor) * aiGetMilitaryPop() * 0.3 / popCount;
      }
      else
      {
         numberToMaintain = (kbUnitPickGetResultFactor(gLandUnitPicker, i) / totalFactor) * aiGetMilitaryPop() * 0.3 /
                            (kbUnitCostPerResource(puid, cResourceFood) + kbUnitCostPerResource(puid, cResourceWood) +
                             kbUnitCostPerResource(puid, cResourceGold));
      }

      if (numberToMaintain < 1)
      {
         numberToMaintain = 1;
      }

      // Check if we already have a plan for this unit type.
      planID = findSecondaryBaseTrainPlan(puid, baseID);

      if (planID >= 0)
      {
         // Plan exists, update it.
         aiPlanSetVariableInt(planID, cTrainPlanNumberToMaintain, 0, numberToMaintain);
         aiPlanSetVariableVector(planID, cTrainPlanGatherPoint, 0, baseLoc);

         // Update building assignments in case buildings were destroyed or rebuilt.
         aiPlanSetNumberVariableValues(planID, cTrainPlanBuildingID, numTrainBuildings, true);
         for (j = 0; < numTrainBuildings)
         {
            aiPlanSetVariableInt(planID, cTrainPlanBuildingID, j, xsArrayGetInt(trainBuildingIDs, j));
         }

         debugMilitary("*** Updated forward base maintain plan for " + kbGetUnitTypeName(puid) +
            " at base " + baseID + ", maintain " + numberToMaintain);
      }
      else
      {
         // No existing plan, create a new one.
         planID = aiPlanCreate("Forward base " + baseID + " " + kbGetUnitTypeName(puid) + " maintain", cPlanTrain);
         aiPlanSetVariableInt(planID, cTrainPlanUnitType, 0, puid);
         aiPlanSetVariableInt(planID, cTrainPlanNumberToMaintain, 0, numberToMaintain);
         aiPlanSetBaseID(planID, baseID);
         aiPlanSetVariableVector(planID, cTrainPlanGatherPoint, 0, baseLoc);
         aiPlanSetEscrowID(planID, cMilitaryEscrowID);

         aiPlanSetNumberVariableValues(planID, cTrainPlanBuildingID, numTrainBuildings, true);
         for (j = 0; < numTrainBuildings)
         {
            aiPlanSetVariableInt(planID, cTrainPlanBuildingID, j, xsArrayGetInt(trainBuildingIDs, j));
         }

         aiPlanSetActive(planID);
         trackSecondaryBaseTrainPlan(planID, puid, baseID);

         debugMilitary("*** Created forward base maintain plan for " + kbGetUnitTypeName(puid) +
            " at base " + baseID + " with " + numTrainBuildings + " buildings, maintain " + numberToMaintain);
      }
   }

   // Prune plans for unit types that are no longer valid at this base
   for (i = 0; < gSecondaryBaseTrainPlanCount)
   {
      planID = xsArrayGetInt(gSecondaryBaseTrainPlans, i);
      if (planID < 0)
      {
         continue;
      }
      if (xsArrayGetInt(gSecondaryBaseTrainPlanBaseIDs, i) != baseID)
      {
         continue; // This belongs to the other secondary base!
      }
      int trackedPUID = xsArrayGetInt(gSecondaryBaseTrainPlanUnitTypes, i);
      bool stillValid = false;
      for (j = 0; < numValidTypes)
      {
         if (xsArrayGetInt(validUnitTypes, j) == trackedPUID)
         {
            stillValid = true;
            break;
         }
      }
      if (stillValid == false)
      {
         debugMilitary("*** Removing stale forward base plan for " + kbGetUnitTypeName(trackedPUID));
         aiPlanDestroy(planID);
         releaseSecondaryBaseTrainPlanSlot(i);
      }
   }
}