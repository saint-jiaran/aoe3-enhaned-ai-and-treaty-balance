//==============================================================================
// setUnitPickerRevolutionPreference
//==============================================================================
void setUnitPickerRevolutionPreference(int upID = -1, int revolutionTechID = -1)
{
   if (upID < 0)
   {
      return;
   }
   
   if (revolutionTechID < 0)
   {
      return;
   }
   
   float primaryUnitPref = 0.9;
   float secondaryUnitPref = 0.75;
   float outclassedPref = 0.3;
   float avoidPref = 0.1;

   if (revolutionTechID == cTechDERevolutionIndonesia)
   {
      kbUnitPickSetPreferenceFactor(upID, cUnitTypedeREVCetbang, primaryUnitPref);
      
      kbUnitPickSetPreferenceFactor(upID, cUnitTypedeREVJavaSpearman, primaryUnitPref);

      kbUnitPickSetPreferenceFactor(upID, cUnitTypeypNatMercWarElephant, primaryUnitPref + 0.1);
      
      kbUnitPickSetPreferenceFactor(upID, cUnitTypeCannon, secondaryUnitPref);
      
      kbUnitPickSetPreferenceFactor(upID, cUnitTypeypWokouJunk, primaryUnitPref);
      
      kbUnitPickSetPreferenceFactor(upID, cUnitTypeFluyt, secondaryUnitPref);
      
      if (cMyCiv == cCivDutch)
      {
         kbUnitPickSetPreferenceFactor(upID, cUnitTypeRuyter, secondaryUnitPref);
      }
      
      debugMilitary("Revolution Unit Picker: Set preferences for Indonesia");
      return;
   }
   
   if (revolutionTechID == cTechDERevolutionFrance)
   {
      
      kbUnitPickSetPreferenceFactor(upID, cUnitTypedeRevolutionaryScout, secondaryUnitPref);
      
      kbUnitPickSetPreferenceFactor(upID, cUnitTypedeMercNapoleonGun, primaryUnitPref);
      
      kbUnitPickSetPreferenceFactor(upID, cUnitTypeGrenadier, primaryUnitPref);
      
      kbUnitPickSetPreferenceFactor(upID, cUnitTypexpColonialMilitia, avoidPref);
      
      kbUnitPickSetPreferenceFactor(upID, cUnitTypeCuirassier, primaryUnitPref);
      kbUnitPickSetPreferenceFactor(upID, cUnitTypeDragoon, secondaryUnitPref);
      
      kbUnitPickSetPreferenceFactor(upID, cUnitTypeHussar, secondaryUnitPref);
      
      kbUnitPickSetPreferenceFactor(upID, cUnitTypexpHorseArtillery, secondaryUnitPref);
      
      kbUnitPickSetPreferenceFactor(upID, cUnitTypeSkirmisher, primaryUnitPref);

      kbUnitPickSetPreferenceFactor(upID, cUnitTypedeNatRoyalMusketeer, primaryUnitPref);
      kbUnitPickSetPreferenceFactor(upID, cUnitTypedeNatRoyalDragoon, primaryUnitPref);
      
      debugMilitary("Revolution Unit Picker: Set preferences for Revolutionary France");
      return;
   }
   
   if (revolutionTechID == cTechDERevolutionBarbaryStates)
   {
      kbUnitPickSetPreferenceFactor(upID, cUnitTypeMercBarbaryCorsair, primaryUnitPref);
      
      kbUnitPickSetPreferenceFactor(upID, cUnitTypedeAllegianceBarbaryMarksman, primaryUnitPref);
      
      kbUnitPickSetPreferenceFactor(upID, cUnitTypedeNatCamelRider, secondaryUnitPref);
      
      kbUnitPickSetPreferenceFactor(upID, cUnitTypedeNatNomad, secondaryUnitPref);
      
      kbUnitPickSetPreferenceFactor(upID, cUnitTypePrivateer, primaryUnitPref);
      kbUnitPickSetPreferenceFactor(upID, cUnitTypedeMercXebec, primaryUnitPref);
      kbUnitPickSetPreferenceFactor(upID, cUnitTypeGalleon, secondaryUnitPref);
      
      kbUnitPickSetPreferenceFactor(upID, cUnitTypeMusketeer, outclassedPref);
      kbUnitPickSetPreferenceFactor(upID, cUnitTypeSkirmisher, outclassedPref);
      
      kbUnitPickSetPreferenceFactor(upID, cUnitTypeFishingBoat, primaryUnitPref);
      
      kbUnitPickSetPreferenceFactor(upID, cUnitTypeFalconet, secondaryUnitPref);
      kbUnitPickSetPreferenceFactor(upID, cUnitTypeCulverin, secondaryUnitPref);
      
      debugMilitary("Revolution Unit Picker: Set preferences for Barbary States");
      return;
   }
   
   if (revolutionTechID == cTechDERevolutionBrazil)
   {
      kbUnitPickSetPreferenceFactor(upID, cUnitTypexpColonialMilitia, secondaryUnitPref);
      
      kbUnitPickSetPreferenceFactor(upID, cUnitTypedeREVJagunco, primaryUnitPref);
      
      kbUnitPickSetPreferenceFactor(upID, cUnitTypeDragoon, primaryUnitPref);
      
      kbUnitPickSetPreferenceFactor(upID, cUnitTypexpGatlingGun, secondaryUnitPref);
      
      kbUnitPickSetPreferenceFactor(upID, cUnitTypexpIronclad, primaryUnitPref);
      
      kbUnitPickSetPreferenceFactor(upID, cUnitTypeCow, secondaryUnitPref);
      
      kbUnitPickSetPreferenceFactor(upID, cUnitTypeNatMercBlowgunWarrior, secondaryUnitPref);
      kbUnitPickSetPreferenceFactor(upID, cUnitTypeNatMercBlackwoodArcher, secondaryUnitPref);
      
      if (cMyCiv == cCivDutch)
      {
         kbUnitPickSetPreferenceFactor(upID, cUnitTypeRuyter, primaryUnitPref);
      }
      
      debugMilitary("Revolution Unit Picker: Set preferences for Brazil");
      return;
   }
   
   if (revolutionTechID == cTechDERevolutionArgentina)
   {
      kbUnitPickSetPreferenceFactor(upID, cUnitTypedeREVGaucho, primaryUnitPref);
      
      kbUnitPickSetPreferenceFactor(upID, cUnitTypedeREVGranadero, primaryUnitPref);
      
      kbUnitPickSetPreferenceFactor(upID, cUnitTypedeREVSanMartin, primaryUnitPref);
      
      kbUnitPickSetPreferenceFactor(upID, cUnitTypeLancer, avoidPref);
      
      kbUnitPickSetPreferenceFactor(upID, cUnitTypexpColonialMilitia, outclassedPref);
      
      kbUnitPickSetPreferenceFactor(upID, cUnitTypeMortar, primaryUnitPref);
      
      kbUnitPickSetPreferenceFactor(upID, cUnitTypexpGatlingGun, secondaryUnitPref);
      
      kbUnitPickSetPreferenceFactor(upID, cUnitTypeMusketeer, primaryUnitPref);
      
      kbUnitPickSetPreferenceFactor(upID, cUnitTypexpIronclad, primaryUnitPref);
      
      kbUnitPickSetPreferenceFactor(upID, cUnitTypeCow, secondaryUnitPref);
      
      kbUnitPickSetPreferenceFactor(upID, cUnitTypedeNMPapalElmetto, secondaryUnitPref);
      
      if (cMyCiv == cCivGermans)
      {
         kbUnitPickSetPreferenceFactor(upID, cUnitTypeUhlan, secondaryUnitPref);
         kbUnitPickSetPreferenceFactor(upID, cUnitTypeMusketeer, primaryUnitPref);
      }
      
      if (cMyCiv == cCivSpanish)
      {
         kbUnitPickSetPreferenceFactor(upID, cUnitTypeLancer, avoidPref);
         kbUnitPickSetPreferenceFactor(upID, cUnitTypeHussar, secondaryUnitPref);
      }
      
      debugMilitary("Revolution Unit Picker: Set preferences for Argentina");
      return;
   }
   
   if (revolutionTechID == cTechDERevolutionCanadaBritish || revolutionTechID == cTechDERevolutionCanadaFrench)
   {
      kbUnitPickSetPreferenceFactor(upID, cUnitTypeMusketeer, primaryUnitPref);
      
      kbUnitPickSetPreferenceFactor(upID, cUnitTypeDragoon, primaryUnitPref);
      
      kbUnitPickSetPreferenceFactor(upID, cUnitTypeSkirmisher, secondaryUnitPref);
      
      kbUnitPickSetPreferenceFactor(upID, cUnitTypedeNatTotenkopf, secondaryUnitPref);
      
      kbUnitPickSetPreferenceFactor(upID, cUnitTypeCanoe, secondaryUnitPref);
      
      kbUnitPickSetPreferenceFactor(upID, cUnitTypeLogicalTypeLandEconomy, primaryUnitPref);
      
      if (cMyCiv == cCivBritish)
      {
         kbUnitPickSetPreferenceFactor(upID, cUnitTypeLongbowman, primaryUnitPref);
      }
      
      debugMilitary("Revolution Unit Picker: Set preferences for Canada");
      return;
   }
   
   if (revolutionTechID == cTechDERevolutionChile)
   {
      kbUnitPickSetPreferenceFactor(upID, cUnitTypeHussar, primaryUnitPref + 0.3);
      
      kbUnitPickSetPreferenceFactor(upID, cUnitTypexpColonialMilitia, secondaryUnitPref);
      
      kbUnitPickSetPreferenceFactor(upID, cUnitTypedeNatBolasRider, primaryUnitPref);
      
      kbUnitPickSetPreferenceFactor(upID, cUnitTypexpGatlingGun, secondaryUnitPref);
      
      kbUnitPickSetPreferenceFactor(upID, cUnitTypexpIronclad, primaryUnitPref);
      
      kbUnitPickSetPreferenceFactor(upID, cUnitTypeSkirmisher, secondaryUnitPref);
      kbUnitPickSetPreferenceFactor(upID, cUnitTypeUhlan, secondaryUnitPref);
      
      debugMilitary("Revolution Unit Picker: Set preferences for Chile");
      return;
   }
   
   if (revolutionTechID == cTechDERevolutionEgypt)
   {
      kbUnitPickSetPreferenceFactor(upID, cUnitTypexpColonialMilitia, primaryUnitPref);
      
      kbUnitPickSetPreferenceFactor(upID, cUnitTypeMercMameluke, primaryUnitPref + 0.1);
      
      kbUnitPickSetPreferenceFactor(upID, cUnitTypeMercStradiot, primaryUnitPref);
      
      kbUnitPickSetPreferenceFactor(upID, cUnitTypexpHorseArtillery, secondaryUnitPref);
      
      kbUnitPickSetPreferenceFactor(upID, cUnitTypedeMercGatlingCamel, primaryUnitPref);
      
      kbUnitPickSetPreferenceFactor(upID, cUnitTypedeMercAskari, secondaryUnitPref);
      
      kbUnitPickSetPreferenceFactor(upID, cUnitTypedeMercSudaneseRider, secondaryUnitPref);
      
      kbUnitPickSetPreferenceFactor(upID, cUnitTypedeNatMercSudaneseDervish, secondaryUnitPref);
      
      kbUnitPickSetPreferenceFactor(upID, cUnitTypeFrigate, secondaryUnitPref);
      kbUnitPickSetPreferenceFactor(upID, cUnitTypeMonitor, secondaryUnitPref);
      
      debugMilitary("Revolution Unit Picker: Set preferences for Egypt");
      return;
   }
   
   if (revolutionTechID == cTechDERevolutionFinland)
   {
      kbUnitPickSetPreferenceFactor(upID, cUnitTypeSkirmisher, primaryUnitPref + 0.1);

      kbUnitPickSetPreferenceFactor(upID, cUnitTypeSettler, primaryUnitPref + 0.1);
      
      kbUnitPickSetPreferenceFactor(upID, cUnitTypedeFinnishRider, primaryUnitPref);
      
      kbUnitPickSetPreferenceFactor(upID, cUnitTypedeCounterDragoon, primaryUnitPref);
      
      kbUnitPickSetPreferenceFactor(upID, cUnitTypedeCarolean, secondaryUnitPref);
      
      kbUnitPickSetPreferenceFactor(upID, cUnitTypedeTorp, secondaryUnitPref);
      
      kbUnitPickSetPreferenceFactor(upID, cUnitTypeBlockhouse, secondaryUnitPref);
      
      debugMilitary("Revolution Unit Picker: Set preferences for Finland");
      return;
   }
   
   if (revolutionTechID == cTechDERevolutionColombia || revolutionTechID == cTechDERevolutionColombiaPortuguese)
   {
      kbUnitPickSetPreferenceFactor(upID, cUnitTypeMusketeer, primaryUnitPref);
      
      kbUnitPickSetPreferenceFactor(upID, cUnitTypedeREVLlanero, primaryUnitPref);
      
      kbUnitPickSetPreferenceFactor(upID, cUnitTypedeREVBolivar, primaryUnitPref);
      
      kbUnitPickSetPreferenceFactor(upID, cUnitTypeSkirmisher, secondaryUnitPref);
      
      kbUnitPickSetPreferenceFactor(upID, cUnitTypexpGatlingGun, secondaryUnitPref);
      
      kbUnitPickSetPreferenceFactor(upID, cUnitTypexpIronclad, primaryUnitPref);
      
      kbUnitPickSetPreferenceFactor(upID, cUnitTypeMercHighlander, secondaryUnitPref);
      kbUnitPickSetPreferenceFactor(upID, cUnitTypeMercJaeger, secondaryUnitPref);
      kbUnitPickSetPreferenceFactor(upID, cUnitTypedeMercHarquebusier, secondaryUnitPref);
      
      kbUnitPickSetPreferenceFactor(upID, cUnitTypeCow, secondaryUnitPref);
      
      debugMilitary("Revolution Unit Picker: Set preferences for Gran Colombia");
      return;
   }
   
   if (revolutionTechID == cTechDERevolutionHaiti)
   {
      kbUnitPickSetPreferenceFactor(upID, cUnitTypexpColonialMilitia, secondaryUnitPref);
      
      kbUnitPickSetPreferenceFactor(upID, cUnitTypePirate, primaryUnitPref);
      
      kbUnitPickSetPreferenceFactor(upID, cUnitTypePikeman, secondaryUnitPref);
      
      kbUnitPickSetPreferenceFactor(upID, cUnitTypePrivateer, primaryUnitPref);
      
      kbUnitPickSetPreferenceFactor(upID, cUnitTypeNatBlowgunWarrior, secondaryUnitPref);
      
      kbUnitPickSetPreferenceFactor(upID, cUnitTypeFalconet, secondaryUnitPref);
      
      if (cMyCiv == cCivBritish)
      {
         kbUnitPickSetPreferenceFactor(upID, cUnitTypeLongbowman, secondaryUnitPref);
      }
      
      debugMilitary("Revolution Unit Picker: Set preferences for Haiti");
      return;
   }
   
   if (revolutionTechID == cTechDERevolutionHungaryGerman || revolutionTechID == cTechDERevolutionHungaryOttoman ||
       revolutionTechID == cTechDERevolutionHungaryRussian)
   {
      kbUnitPickSetPreferenceFactor(upID, cUnitTypedeColonialMilitia, primaryUnitPref);
      
      kbUnitPickSetPreferenceFactor(upID, cUnitTypedeLegionMagyarHussar, primaryUnitPref);
      
      kbUnitPickSetPreferenceFactor(upID, cUnitTypedeNatHungarianGrenadier, primaryUnitPref);
      
      kbUnitPickSetPreferenceFactor(upID, cUnitTypedeSaloonHajduk, secondaryUnitPref);
      
      kbUnitPickSetPreferenceFactor(upID, cUnitTypedeSaloonCrabat, secondaryUnitPref);
      
      kbUnitPickSetPreferenceFactor(upID, cUnitTypedeMercPandour, secondaryUnitPref);
      
      kbUnitPickSetPreferenceFactor(upID, cUnitTypeGalley, secondaryUnitPref);
      
      if (cMyCiv == cCivGermans)
      {
         kbUnitPickSetPreferenceFactor(upID, cUnitTypedeMercPandour, primaryUnitPref);
      }
      else if (cMyCiv == cCivDEMaltese)
      {
         kbUnitPickSetPreferenceFactor(upID, cUnitTypedeSaloonHajduk, primaryUnitPref);
      }
      else if (cMyCiv == cCivOttomans)
      {
         kbUnitPickSetPreferenceFactor(upID, cUnitTypedeLegionMagyarHussar, primaryUnitPref + 0.1);
      }
      else if (cMyCiv == cCivRussians)
      {
         kbUnitPickSetPreferenceFactor(upID, cUnitTypedeNatHungarianGrenadier, primaryUnitPref + 0.1);
      }
      
      debugMilitary("Revolution Unit Picker: Set preferences for Hungary");
      return;
   }
   
   if (revolutionTechID == cTechDERevolutionPeru)
   {
      kbUnitPickSetPreferenceFactor(upID, cUnitTypexpColonialMilitia, primaryUnitPref);
      
      kbUnitPickSetPreferenceFactor(upID, cUnitTypeSaloonOutlawRider, primaryUnitPref);
      
      kbUnitPickSetPreferenceFactor(upID, cUnitTypedeSlinger, primaryUnitPref);
      
      kbUnitPickSetPreferenceFactor(upID, cUnitTypedeREVBolivar, primaryUnitPref);
      
      kbUnitPickSetPreferenceFactor(upID, cUnitTypexpGatlingGun, secondaryUnitPref);
      
      kbUnitPickSetPreferenceFactor(upID, cUnitTypexpIronclad, secondaryUnitPref);
      
      kbUnitPickSetPreferenceFactor(upID, cUnitTypedeIncaStronghold, secondaryUnitPref);
      
      kbUnitPickSetPreferenceFactor(upID, cUnitTypeCow, secondaryUnitPref);
      
      debugMilitary("Revolution Unit Picker: Set preferences for Peru");
      return;
   }
   
   if (revolutionTechID == cTechDERevolutionRomania)
   {
      kbUnitPickSetPreferenceFactor(upID, cUnitTypexpColonialMilitia, primaryUnitPref);
      
      kbUnitPickSetPreferenceFactor(upID, cUnitTypeDragoon, primaryUnitPref + 0.1);
      
      kbUnitPickSetPreferenceFactor(upID, cUnitTypeCavalryArcher, primaryUnitPref);
      
      kbUnitPickSetPreferenceFactor(upID, cUnitTypedeSaloonHajduk, secondaryUnitPref);
      
      kbUnitPickSetPreferenceFactor(upID, cUnitTypedeSaloonCrabat, secondaryUnitPref);
      
      kbUnitPickSetPreferenceFactor(upID, cUnitTypedeMercPandour, secondaryUnitPref);
      
      kbUnitPickSetPreferenceFactor(upID, cUnitTypexpHorseArtillery, secondaryUnitPref);
      
      kbUnitPickSetPreferenceFactor(upID, cUnitTypeGalley, secondaryUnitPref);
      
      debugMilitary("Revolution Unit Picker: Set preferences for Romania");
      return;
   }
   
   if (revolutionTechID == cTechDERevolutionSouthAfrica)
   {
      kbUnitPickSetPreferenceFactor(upID, cUnitTypeLogicalTypeLandEconomy, primaryUnitPref + 0.1);
      
      kbUnitPickSetPreferenceFactor(upID, cUnitTypedeREVStarTrekWagon, primaryUnitPref);
      
      kbUnitPickSetPreferenceFactor(upID, cUnitTypeWarWagon, primaryUnitPref);
      
      kbUnitPickSetPreferenceFactor(upID, cUnitTypeCoureur, primaryUnitPref);
      
      kbUnitPickSetPreferenceFactor(upID, cUnitTypeSkirmisher, secondaryUnitPref);
      
      kbUnitPickSetPreferenceFactor(upID, cUnitTypeBank, primaryUnitPref);
      
      if (cMyCiv == cCivBritish)
      {
         kbUnitPickSetPreferenceFactor(upID, cUnitTypeLongbowman, secondaryUnitPref);
      }
      else if (cMyCiv == cCivDutch)
      {
         kbUnitPickSetPreferenceFactor(upID, cUnitTypeBank, primaryUnitPref + 0.1);
         kbUnitPickSetPreferenceFactor(upID, cUnitTypeRuyter, outclassedPref);
      }
      
      debugMilitary("Revolution Unit Picker: Set preferences for South Africa");
      return;
   }

   //////////////////////////////////////////////////////////////////////////////
   // PRUSSIA
   //////////////////////////////////////////////////////////////////////////////
   if (revolutionTechID == cTechDERevolutionPrussia)
   {
      kbUnitPickSetPreferenceFactor(upID, cUnitTypedeLandwehr, primaryUnitPref);
      kbUnitPickSetPreferenceFactor(upID, cUnitTypedeChevauleger, primaryUnitPref);
      kbUnitPickSetPreferenceFactor(upID, cUnitTypedeMercGrenadier, secondaryUnitPref);
      kbUnitPickSetPreferenceFactor(upID, cUnitTypeMusketeer, secondaryUnitPref);
      kbUnitPickSetPreferenceFactor(upID, cUnitTypeCrossbowman, outclassedPref);
      kbUnitPickSetPreferenceFactor(upID, cUnitTypePikeman, outclassedPref);
      kbUnitPickSetPreferenceFactor(upID, cUnitTypeDopplesoldner, outclassedPref);
      kbUnitPickSetPreferenceFactor(upID, cUnitTypeWarWagon, outclassedPref);
      debugMilitary("Revolution Unit Picker: Set preferences for Prussia");
      return;
   }

   //////////////////////////////////////////////////////////////////////////////
   // GERMAN CONFEDERATION - PRUSSIA STEP 2!?
   //////////////////////////////////////////////////////////////////////////////
   if (revolutionTechID == cTechDERevolutionGermany)
   {
      kbUnitPickSetPreferenceFactor(upID, cUnitTypedeLandwehr, primaryUnitPref);
      kbUnitPickSetPreferenceFactor(upID, cUnitTypedeChevauleger, primaryUnitPref);
      kbUnitPickSetPreferenceFactor(upID, cUnitTypeMusketeer, secondaryUnitPref);
      debugMilitary("Revolution Unit Picker: Set preferences for German Confederation");
      return;
   }

   //////////////////////////////////////////////////////////////////////////////
   // DUCHY OF WARSAW
   //////////////////////////////////////////////////////////////////////////////
   if (revolutionTechID == cTechDERevolutionWarsaw)
   {
      kbUnitPickSetPreferenceFactor(upID, cUnitTypedeREVPolishLancer, primaryUnitPref);
      kbUnitPickSetPreferenceFactor(upID, cUnitTypedeWingedHussar, primaryUnitPref);
      kbUnitPickSetPreferenceFactor(upID, cUnitTypePikeman, secondaryUnitPref);
      kbUnitPickSetPreferenceFactor(upID, cUnitTypeSkirmisher, secondaryUnitPref);
      kbUnitPickSetPreferenceFactor(upID, cUnitTypeDragoon, secondaryUnitPref);
      kbUnitPickSetPreferenceFactor(upID, cUnitTypeCrossbowman, outclassedPref);
      kbUnitPickSetPreferenceFactor(upID, cUnitTypedePiechur, outclassedPref);
      kbUnitPickSetPreferenceFactor(upID, cUnitTypeCavalryArcher, outclassedPref);
      kbUnitPickSetPreferenceFactor(upID, cUnitTypedeLithuanianRider, outclassedPref);
      debugMilitary("Revolution Unit Picker: Set preferences for Duchy of Warsaw");
      return;
   }

   //////////////////////////////////////////////////////////////////////////////
   // COSSACK HETMANATE
   //////////////////////////////////////////////////////////////////////////////
   if (revolutionTechID == cTechDERevolutionCossackHetmanate)
   {
      kbUnitPickSetPreferenceFactor(upID, cUnitTypedeREVHaidamakaRider, primaryUnitPref);
      kbUnitPickSetPreferenceFactor(upID, cUnitTypedeREVHaidamaka, primaryUnitPref);
      kbUnitPickSetPreferenceFactor(upID, cUnitTypedeSaloonOutlawCossackRider, secondaryUnitPref);
      kbUnitPickSetPreferenceFactor(upID, cUnitTypeCrossbowman, outclassedPref);
      kbUnitPickSetPreferenceFactor(upID, cUnitTypedeLithuanianRider, outclassedPref);
      kbUnitPickSetPreferenceFactor(upID, gEconUnit, -1.0);
      debugMilitary("Revolution Unit Picker: Set preferences for Cossack Hetmanate");
      return;
   }

   debugMilitary("Revolution Unit Picker: Unknown revolution tech ID " + revolutionTechID);
}

//==============================================================================
// getRevolutionUnitPickerPreference
//==============================================================================
float getRevolutionUnitPickerPreference(int unitTypeID = -1, int revolutionTechID = -1)
{
   if (unitTypeID < 0 || revolutionTechID < 0)
   {
      return(0.5);
   }
   
   if (revolutionTechID == cTechDERevolutionFrance)
   {
      if (unitTypeID == cUnitTypeLogicalTypeLandEconomy) return(0.9);
      if (unitTypeID == cUnitTypedeMercNapoleonGun) return(0.9);
      if (unitTypeID == cUnitTypeGrenadier) return(0.9);
      if (unitTypeID == cUnitTypexpColonialMilitia) return(0.75);
      if (unitTypeID == cUnitTypedeRevolutionaryScout) return(0.75);
      if (unitTypeID == cUnitTypeCuirassier) return(0.75);
      if (unitTypeID == cUnitTypeDragoon) return(0.75);
      if (unitTypeID == cUnitTypeHussar) return(0.75);
      if (unitTypeID == cUnitTypexpHorseArtillery) return(0.75);
   }
   
   if (revolutionTechID == cTechDERevolutionBarbaryStates)
   {
      if (unitTypeID == cUnitTypeMercBarbaryCorsair) return(0.9);
      if (unitTypeID == cUnitTypedeAllegianceBarbaryMarksman) return(0.9);
      if (unitTypeID == cUnitTypePrivateer) return(0.9);
      if (unitTypeID == cUnitTypedeMercXebec) return(0.9);
      if (unitTypeID == cUnitTypedeNatCamelRider) return(0.75);
      if (unitTypeID == cUnitTypedeNatNomad) return(0.75);
      if (unitTypeID == cUnitTypeFishingBoat) return(0.9);
      if (unitTypeID == cUnitTypeGalleon) return(0.75);
   }
   
   if (revolutionTechID == cTechDERevolutionBrazil)
   {
      if (unitTypeID == cUnitTypedeREVJagunco) return(0.9);
      if (unitTypeID == cUnitTypeDragoon) return(0.9);
      if (unitTypeID == cUnitTypexpIronclad) return(0.9);
      if (unitTypeID == cUnitTypexpColonialMilitia) return(0.75);
      if (unitTypeID == cUnitTypexpGatlingGun) return(0.75);
   }
   
   if (revolutionTechID == cTechDERevolutionArgentina)
   {
      if (unitTypeID == cUnitTypedeREVGaucho) return(0.9);
      if (unitTypeID == cUnitTypedeREVGranadero) return(0.9);
      if (unitTypeID == cUnitTypedeREVSanMartin) return(0.9);
      if (unitTypeID == cUnitTypeLancer) return(0.9);
      if (unitTypeID == cUnitTypeMortar) return(0.9);
      if (unitTypeID == cUnitTypexpColonialMilitia) return(0.75);
      if (unitTypeID == cUnitTypexpGatlingGun) return(0.75);
      if (unitTypeID == cUnitTypeMusketeer) return(0.75);
      if (unitTypeID == cUnitTypexpIronclad) return(0.9);
   }
   
   if (revolutionTechID == cTechDERevolutionCanadaBritish || revolutionTechID == cTechDERevolutionCanadaFrench)
   {
      if (unitTypeID == cUnitTypeMusketeer) return(0.9);
      if (unitTypeID == cUnitTypeDragoon) return(0.9);
      if (unitTypeID == cUnitTypeSkirmisher) return(0.75);
      if (unitTypeID == cUnitTypeLogicalTypeLandEconomy) return(0.9);
      if (unitTypeID == cUnitTypedeNatTotenkopf) return(0.75);
      if (unitTypeID == cUnitTypeCanoe) return(0.75);
   }
   
   if (revolutionTechID == cTechDERevolutionChile)
   {
      if (unitTypeID == cUnitTypeHussar) return(1.0);
      if (unitTypeID == cUnitTypexpColonialMilitia) return(0.75);
      if (unitTypeID == cUnitTypedeNatBolasRider) return(0.9);
      if (unitTypeID == cUnitTypexpGatlingGun) return(0.75);
      if (unitTypeID == cUnitTypexpIronclad) return(0.9);
   }
   
   if (revolutionTechID == cTechDERevolutionEgypt)
   {
      if (unitTypeID == cUnitTypexpColonialMilitia) return(0.9);
      if (unitTypeID == cUnitTypeMercMameluke) return(1.0);
      if (unitTypeID == cUnitTypeMercStradiot) return(0.9);
      if (unitTypeID == cUnitTypexpHorseArtillery) return(0.75);
      if (unitTypeID == cUnitTypedeMercGatlingCamel) return(0.9);
      if (unitTypeID == cUnitTypedeMercAskari) return(0.75);
   }
   
   if (revolutionTechID == cTechDERevolutionFinland)
   {
      if (unitTypeID == cUnitTypeSkirmisher) return(1.0);
      if (unitTypeID == cUnitTypedeFinnishRider) return(0.9);
      if (unitTypeID == cUnitTypedeCounterDragoon) return(0.9);
      if (unitTypeID == cUnitTypedeCarolean) return(0.75);
   }
   
   if (revolutionTechID == cTechDERevolutionColombia || revolutionTechID == cTechDERevolutionColombiaPortuguese)
   {
      if (unitTypeID == cUnitTypeMusketeer) return(0.9);
      if (unitTypeID == cUnitTypedeREVLlanero) return(0.9);
      if (unitTypeID == cUnitTypedeREVBolivar) return(0.9);
      if (unitTypeID == cUnitTypeSkirmisher) return(0.75);
      if (unitTypeID == cUnitTypexpIronclad) return(0.9);
      if (unitTypeID == cUnitTypexpGatlingGun) return(0.75);
   }
   
   if (revolutionTechID == cTechDERevolutionHaiti)
   {
      if (unitTypeID == cUnitTypePirate) return(0.9);
      if (unitTypeID == cUnitTypexpColonialMilitia) return(0.75);
      if (unitTypeID == cUnitTypePikeman) return(0.75);
      if (unitTypeID == cUnitTypePrivateer) return(0.9);
      if (unitTypeID == cUnitTypeFalconet) return(0.75);
   }
   
   if (revolutionTechID == cTechDERevolutionHungaryGerman || revolutionTechID == cTechDERevolutionHungaryOttoman ||
       revolutionTechID == cTechDERevolutionHungaryRussian)
   {
      if (unitTypeID == cUnitTypedeColonialMilitia) return(0.9);
      if (unitTypeID == cUnitTypedeLegionMagyarHussar) return(0.9);
      if (unitTypeID == cUnitTypedeNatHungarianGrenadier) return(0.9);
      if (unitTypeID == cUnitTypedeSaloonHajduk) return(0.75);
      if (unitTypeID == cUnitTypedeSaloonCrabat) return(0.75);
      if (unitTypeID == cUnitTypedeMercPandour) return(0.75);
   }
   
   if (revolutionTechID == cTechDERevolutionPeru)
   {
      if (unitTypeID == cUnitTypexpColonialMilitia) return(0.9);
      if (unitTypeID == cUnitTypeSaloonOutlawRider) return(0.9);
      if (unitTypeID == cUnitTypedeSlinger) return(0.9);
      if (unitTypeID == cUnitTypedeREVBolivar) return(0.9);
      if (unitTypeID == cUnitTypexpGatlingGun) return(0.75);
   }
   
   if (revolutionTechID == cTechDERevolutionRomania)
   {
      if (unitTypeID == cUnitTypexpColonialMilitia) return(0.9);
      if (unitTypeID == cUnitTypeDragoon) return(1.0);
      if (unitTypeID == cUnitTypeCavalryArcher) return(0.9);
      if (unitTypeID == cUnitTypexpHorseArtillery) return(0.75);
      if (unitTypeID == cUnitTypedeSaloonHajduk) return(0.75);
      if (unitTypeID == cUnitTypedeSaloonCrabat) return(0.75);
   }
   
   if (revolutionTechID == cTechDERevolutionSouthAfrica)
   {
      if (unitTypeID == cUnitTypeLogicalTypeLandEconomy) return(1.0);
      if (unitTypeID == cUnitTypedeREVStarTrekWagon) return(0.9);
      if (unitTypeID == cUnitTypeWarWagon) return(0.9);
      if (unitTypeID == cUnitTypeCoureur) return(0.9);
      if (unitTypeID == cUnitTypeSkirmisher) return(0.75);
      if (unitTypeID == cUnitTypeBank) return(0.9);
   }
   
   return(0.5);
}

//==============================================================================
// isRevolutionCavalryFocused
//==============================================================================
bool isRevolutionCavalryFocused(int revolutionTechID = -1)
{
   if (revolutionTechID < 0)
   {
      return(false);
   }
   
   if (revolutionTechID == cTechDERevolutionArgentina)
   {
      return(true);
   }
   
   if (revolutionTechID == cTechDERevolutionBrazil)
   {
      return(true);
   }
   
   if (revolutionTechID == cTechDERevolutionFrance)
   {
      return(true);
   }
   
   if (revolutionTechID == cTechDERevolutionBarbaryStates)
   {
      return(false);
   }
   
   if (revolutionTechID == cTechDERevolutionChile)
   {
      return(true);
   }
   
   if (revolutionTechID == cTechDERevolutionEgypt)
   {
      return(true);
   }
   
   if (revolutionTechID == cTechDERevolutionRomania)
   {
      return(true);
   }
   
   if (revolutionTechID == cTechDERevolutionSouthAfrica)
   {
      return(true);
   }
   
   if (revolutionTechID == cTechDERevolutionCanadaBritish || revolutionTechID == cTechDERevolutionCanadaFrench)
   {
      return(false);
   }
   
   if (revolutionTechID == cTechDERevolutionFinland)
   {
      return(false);
   }
   
   if (revolutionTechID == cTechDERevolutionColombia || revolutionTechID == cTechDERevolutionColombiaPortuguese)
   {
      return(false);
   }
   
   if (revolutionTechID == cTechDERevolutionHaiti)
   {
      return(false);
   }
   
   if (revolutionTechID == cTechDERevolutionHungaryGerman || revolutionTechID == cTechDERevolutionHungaryOttoman ||
       revolutionTechID == cTechDERevolutionHungaryRussian)
   {
      return(false);
   }
   
   if (revolutionTechID == cTechDERevolutionPeru)
   {
      return(false);
   }

   // Duchy of Warsaw - Polish Lancers plus the Winged Hussar upgrades it unlocks.
   if (revolutionTechID == cTechDERevolutionWarsaw)
   {
      return(true);
   }

   // Cossack Hetmanate - Haidamaka Riders, and it adds Cossack Riders to the Stable and Fort.
   if (revolutionTechID == cTechDERevolutionCossackHetmanate)
   {
      return(true);
   }

   return(false);
}

//==============================================================================
// isRevolutionArtilleryFocused
//==============================================================================
bool isRevolutionArtilleryFocused(int revolutionTechID = -1)
{
   if (revolutionTechID < 0)
   {
      return(false);
   }
   
   if (revolutionTechID == cTechDERevolutionArgentina)
   {
      return(true);
   }
   
   if (revolutionTechID == cTechDERevolutionFrance)
   {
      return(true);
   }
   
   if (revolutionTechID == cTechDERevolutionBarbaryStates)
   {
      return(false);
   }
   
   if (revolutionTechID == cTechDERevolutionBrazil)
   {
      return(false);
   }
   
   if (revolutionTechID == cTechDERevolutionIndonesia)
   {
      return(true);
   }
   
   if (revolutionTechID == cTechDERevolutionHungaryGerman || revolutionTechID == cTechDERevolutionHungaryOttoman ||
       revolutionTechID == cTechDERevolutionHungaryRussian)
   {
      return(true);
   }
   
   if (revolutionTechID == cTechDERevolutionPeru)
   {
      return(true);
   }
   
   return(false);
}

//==============================================================================
// isRevolutionNavalFocused
//==============================================================================
bool isRevolutionNavalFocused(int revolutionTechID = -1)
{
   if (revolutionTechID < 0)
   {
      return(false);
   }
   
   if (revolutionTechID == cTechDERevolutionBarbaryStates)
   {
      return(true);
   }
   
   if (revolutionTechID == cTechDERevolutionHaiti)
   {
      return(true);
   }
   
   if (revolutionTechID == cTechDERevolutionColombia || revolutionTechID == cTechDERevolutionColombiaPortuguese)
   {
      return(true);
   }
   
   return(false);
}

//==============================================================================
// isRevolutionSwarmFocused
//==============================================================================
bool isRevolutionSwarmFocused(int revolutionTechID = -1)
{
   if (revolutionTechID < 0)
   {
      return(false);
   }
   
   if (revolutionTechID == cTechDERevolutionBrazil)
   {
      return(true);
   }
   
   if (revolutionTechID == cTechDERevolutionBarbaryStates)
   {
      return(true);
   }
   
   if (revolutionTechID == cTechDERevolutionFrance)
   {
      return(false);
   }
   
   if (revolutionTechID == cTechDERevolutionArgentina)
   {
      return(false);
   }
   
   if (revolutionTechID == cTechDERevolutionHaiti)
   {
      return(true);
   }
   
   if (revolutionTechID == cTechDERevolutionHungaryGerman || revolutionTechID == cTechDERevolutionHungaryOttoman ||
       revolutionTechID == cTechDERevolutionHungaryRussian)
   {
      return(true);
   }
   
   return(false);
}

//==============================================================================
// canRevolutionGatherWithMilitary
//==============================================================================
bool canRevolutionGatherWithMilitary(int revolutionTechID = -1)
{
   if (revolutionTechID < 0)
   {
      return(false);
   }
   
   if (revolutionTechID == cTechDERevolutionFrance)
   {
      return(true);
   }
   
   if (revolutionTechID == cTechDERevolutionBrazil)
   {
      return(true);
   }
   
   if (revolutionTechID == cTechDERevolutionArgentina)
   {
      return(true);
   }
   
   if (revolutionTechID == cTechDERevolutionBarbaryStates)
   {
      return(true);
   }
   
   if (revolutionTechID == cTechDERevolutionFinland)
   {
      return(true);
   }
   
   if (revolutionTechID == cTechDERevolutionColombia || revolutionTechID == cTechDERevolutionColombiaPortuguese)
   {
      return(true);
   }
   
   if (revolutionTechID == cTechDERevolutionPeru)
   {
      return(true);
   }
   
   return(false);
}

//==============================================================================
// doesRevolutionKeepFishing
//==============================================================================
bool doesRevolutionKeepFishing(int revolutionTechID = -1)
{
   if (revolutionTechID < 0)
   {
      return(false);
   }
   
   if (revolutionTechID == cTechDERevolutionBarbaryStates)
   {
      return(true);
   }
   
   if (revolutionTechID == cTechDERevolutionCanadaBritish || revolutionTechID == cTechDERevolutionCanadaFrench)
   {
      return(true);
   }
   
   if (revolutionTechID == cTechDERevolutionSouthAfrica)
   {
      return(true);
   }
   
   return(false);
}

//==============================================================================
// doesRevolutionKeepSettlers
//==============================================================================
bool doesRevolutionKeepSettlers(int revolutionTechID = -1)
{
   if (revolutionTechID < 0)
   {
      return(false);
   }
   
   if (revolutionTechID == cTechDERevolutionCanadaBritish || revolutionTechID == cTechDERevolutionCanadaFrench)
   {
      return(true);
   }
   
   if (revolutionTechID == cTechDERevolutionFinland)
   {
      return(true);
   }
   
   if (revolutionTechID == cTechDERevolutionSouthAfrica)
   {
      return(true);
   }

   // German Confederation - Prussian Musketeers into Settlers and Giant Grenadiers into Settler Wagons.
   if (revolutionTechID == cTechDERevolutionGermany)
   {
      return(true);
   }

   
   return(false);
}

//==============================================================================
// doesRevolutionNeedHouses
//==============================================================================
bool doesRevolutionNeedHouses(int revolutionTechID = -1)
{
   if (revolutionTechID < 0)
   {
      return(false);
   }
   
   if (revolutionTechID == cTechDERevolutionCanadaBritish || revolutionTechID == cTechDERevolutionCanadaFrench)
   {
      return(true);
   }
   
   if (revolutionTechID == cTechDERevolutionFinland)
   {
      return(true);
   }
   
   if (revolutionTechID == cTechDERevolutionSouthAfrica)
   {
      return(false);
   }
   
   return(false);
}

//==============================================================================
// getRevolutionPrimaryResourceFocus
//==============================================================================
int getRevolutionPrimaryResourceFocus(int revolutionTechID = -1)
{
   if (revolutionTechID < 0)
   {
      return(cResourceFood);
   }
   
   if (revolutionTechID == cTechDERevolutionArgentina)
   {
      return(cResourceFood);
   }
   
   if (revolutionTechID == cTechDERevolutionBrazil)
   {
      return(cResourceFood);
   }
   
   if (revolutionTechID == cTechDERevolutionFrance)
   {
      return(cResourceFood);
   }
   
   if (revolutionTechID == cTechDERevolutionBarbaryStates)
   {
      return(cResourceFood);
   }
   
   if (revolutionTechID == cTechDERevolutionChile)
   {
      return(cResourceFood);
   }
   
   if (revolutionTechID == cTechDERevolutionEgypt)
   {
      return(cResourceGold);
   }
   
   if (revolutionTechID == cTechDERevolutionFinland)
   {
      return(cResourceWood);
   }
   
   if (revolutionTechID == cTechDERevolutionColombia || revolutionTechID == cTechDERevolutionColombiaPortuguese)
   {
      return(cResourceFood);
   }
   
   if (revolutionTechID == cTechDERevolutionHaiti)
   {
      return(cResourceFood);
   }
   
   if (revolutionTechID == cTechDERevolutionHungaryGerman || revolutionTechID == cTechDERevolutionHungaryOttoman ||
       revolutionTechID == cTechDERevolutionHungaryRussian)
   {
      return(cResourceFood);
   }
   
   if (revolutionTechID == cTechDERevolutionPeru)
   {
      return(cResourceFood);
   }
   
   if (revolutionTechID == cTechDERevolutionRomania)
   {
      return(cResourceFood);
   }
   
   if (revolutionTechID == cTechDERevolutionSouthAfrica)
   {
      return(cResourceFood);
   }
   
   return(cResourceFood);
}

//==============================================================================
// getRevolutionEconomyCardTech
//==============================================================================
int getRevolutionEconomyCardTech(int revolutionTechID = -1)
{
   if (revolutionTechID < 0)
   {
      return(-1);
   }
   
   if (revolutionTechID == cTechDERevolutionArgentina)
   {
      return(cTechDEHCREVCitizenship);
   }
   
   if (revolutionTechID == cTechDERevolutionBrazil)
   {
      return(cTechDEHCREVMinasGerais);
   }
   
   if (revolutionTechID == cTechDERevolutionFrance)
   {
      return(-1);
   }
   
   if (revolutionTechID == cTechDERevolutionBarbaryStates)
   {
      return(cTechDEHCREVDhimma);
   }
   
   if (revolutionTechID == cTechDERevolutionCanadaBritish || revolutionTechID == cTechDERevolutionCanadaFrench)
   {
      return(-1);
   }
   
   if (revolutionTechID == cTechDERevolutionChile)
   {
      return(cTechDEHCREVCitizenshipChile);
   }
   
   if (revolutionTechID == cTechDERevolutionEgypt)
   {
      return(cTechDEHCREVCitizenship);
   }
   
   if (revolutionTechID == cTechDERevolutionFinland)
   {
      return(cTechDEHCREVNothernWilderness);
   }
   
   if (revolutionTechID == cTechDERevolutionColombia || revolutionTechID == cTechDERevolutionColombiaPortuguese)
   {
      return(cTechDEHCREVCitizenship);
   }
   
   if (revolutionTechID == cTechDERevolutionHaiti)
   {
      return(cTechDEHCREVCitizenshipHaiti);
   }
   
   if (revolutionTechID == cTechDERevolutionHungaryGerman || revolutionTechID == cTechDERevolutionHungaryOttoman ||
       revolutionTechID == cTechDERevolutionHungaryRussian)
   {
      return(cTechDEHCREVCitizenship);
   }
   
   if (revolutionTechID == cTechDERevolutionPeru)
   {
      return(cTechDEHCREVCitizenship);
   }
   
   if (revolutionTechID == cTechDERevolutionRomania)
   {
      return(cTechDEHCREVCitizenship);
   }
   
   if (revolutionTechID == cTechDERevolutionSouthAfrica)
   {
      return(-1);
   }
   
   return(-1);
}

//==============================================================================
// getRevolutionCoreInfantryType
//==============================================================================
int getRevolutionCoreInfantryType(int revolutionTechID = -1)
{
   if (revolutionTechID < 0)
   {
      return(cUnitTypexpColonialMilitia);
   }
   
   if (revolutionTechID == cTechDERevolutionFrance)
   {
      return(cUnitTypeLogicalTypeLandEconomy);
   }
   
   if (revolutionTechID == cTechDERevolutionBarbaryStates)
   {
      return(cUnitTypeMercBarbaryCorsair);
   }
   
   if (revolutionTechID == cTechDERevolutionBrazil)
   {
      return(cUnitTypexpColonialMilitia);
   }
   
   if (revolutionTechID == cTechDERevolutionArgentina)
   {
      return(cUnitTypexpColonialMilitia);
   }
   
   if (revolutionTechID == cTechDERevolutionCanadaBritish || revolutionTechID == cTechDERevolutionCanadaFrench)
   {
      return(cUnitTypeMusketeer);
   }
   
   if (revolutionTechID == cTechDERevolutionChile)
   {
      return(cUnitTypexpColonialMilitia);
   }
   
   if (revolutionTechID == cTechDERevolutionEgypt)
   {
      return(cUnitTypexpColonialMilitia);
   }
   
   if (revolutionTechID == cTechDERevolutionFinland)
   {
      return(cUnitTypeSkirmisher);
   }
   
   if (revolutionTechID == cTechDERevolutionColombia || revolutionTechID == cTechDERevolutionColombiaPortuguese)
   {
      return(cUnitTypeMusketeer);
   }
   
   if (revolutionTechID == cTechDERevolutionHaiti)
   {
      return(cUnitTypePirate);
   }
   
   if (revolutionTechID == cTechDERevolutionHungaryGerman || revolutionTechID == cTechDERevolutionHungaryOttoman ||
       revolutionTechID == cTechDERevolutionHungaryRussian)
   {
      return(cUnitTypedeColonialMilitia);
   }
   
   if (revolutionTechID == cTechDERevolutionPeru)
   {
      return(cUnitTypexpColonialMilitia);
   }
   
   if (revolutionTechID == cTechDERevolutionRomania)
   {
      return(cUnitTypexpColonialMilitia);
   }
   
   if (revolutionTechID == cTechDERevolutionSouthAfrica)
   {
      return(cUnitTypeSkirmisher);
   }

   // Prussia - Musketeers
   if (revolutionTechID == cTechDERevolutionPrussia)
   {
      return(cUnitTypeMusketeer);
   }

   // Duchy of Warsaw - Pikemen
   if (revolutionTechID == cTechDERevolutionWarsaw)
   {
      return(cUnitTypePikeman);
   }

   // Cossack Hetmanate - Haidamaka
   if (revolutionTechID == cTechDERevolutionCossackHetmanate)
   {
      return(cUnitTypedeREVHaidamaka);
   }

   // German Confederation - Musketeers
   if (revolutionTechID == cTechDERevolutionGermany)
   {
      return(cUnitTypeMusketeer);
   }

   return(cUnitTypexpColonialMilitia);
}

//==============================================================================
// getRevolutionCoreCavalryType
//==============================================================================
int getRevolutionCoreCavalryType(int revolutionTechID = -1)
{
   if (revolutionTechID < 0)
   {
      return(-1);
   }
   
   if (revolutionTechID == cTechDERevolutionFrance)
   {
      return(cUnitTypeCuirassier);
   }
   
   if (revolutionTechID == cTechDERevolutionBarbaryStates)
   {
      return(cUnitTypedeNatCamelRider);
   }
   
   if (revolutionTechID == cTechDERevolutionBrazil)
   {
      return(cUnitTypedeREVJagunco);
   }
   
   if (revolutionTechID == cTechDERevolutionArgentina)
   {
      return(cUnitTypedeREVGaucho);
   }
   
   if (revolutionTechID == cTechDERevolutionCanadaBritish || revolutionTechID == cTechDERevolutionCanadaFrench)
   {
      return(cUnitTypeDragoon);
   }
   
   if (revolutionTechID == cTechDERevolutionChile)
   {
      return(cUnitTypeHussar);
   }
   
   if (revolutionTechID == cTechDERevolutionEgypt)
   {
      return(cUnitTypeMercMameluke);
   }
   
   if (revolutionTechID == cTechDERevolutionFinland)
   {
      return(cUnitTypedeFinnishRider);
   }
   
   if (revolutionTechID == cTechDERevolutionColombia || revolutionTechID == cTechDERevolutionColombiaPortuguese)
   {
      return(cUnitTypedeREVLlanero);
   }
   
   if (revolutionTechID == cTechDERevolutionHaiti)
   {
      return(-1);
   }
   
   if (revolutionTechID == cTechDERevolutionHungaryGerman || revolutionTechID == cTechDERevolutionHungaryOttoman ||
       revolutionTechID == cTechDERevolutionHungaryRussian)
   {
      return(cUnitTypedeLegionMagyarHussar);
   }
   
   if (revolutionTechID == cTechDERevolutionPeru)
   {
      return(cUnitTypeSaloonOutlawRider);
   }
   
   if (revolutionTechID == cTechDERevolutionRomania)
   {
      return(cUnitTypeDragoon);
   }
   
   if (revolutionTechID == cTechDERevolutionSouthAfrica)
   {
      return(cUnitTypeWarWagon);
   }

   // Prussia - Chevauleger
   if (revolutionTechID == cTechDERevolutionPrussia)
   {
      return(cUnitTypedeChevauleger);
   }

   // Duchy of Warsaw - Polish Lancer
   if (revolutionTechID == cTechDERevolutionWarsaw)
   {
      return(cUnitTypedeREVPolishLancer);
   }

   // Cossack Hetmanate - Haidamaka Rider
   if (revolutionTechID == cTechDERevolutionCossackHetmanate)
   {
      return(cUnitTypedeREVHaidamakaRider);
   }

   // German Confederation - Chevaulegers.
   if (revolutionTechID == cTechDERevolutionGermany)
   {
      return(cUnitTypedeChevauleger);
   }

   return(-1);
}

//==============================================================================
// getRevolutionCoreRangedType
//==============================================================================
int getRevolutionCoreRangedType(int revolutionTechID = -1)
{
   if (revolutionTechID < 0)
   {
      return(-1);
   }
   
   if (revolutionTechID == cTechDERevolutionFrance)
   {
      return(cUnitTypeGrenadier);
   }
   
   if (revolutionTechID == cTechDERevolutionBarbaryStates)
   {
      return(cUnitTypedeAllegianceBarbaryMarksman);
   }
   
   if (revolutionTechID == cTechDERevolutionBrazil)
   {
      return(cUnitTypexpGatlingGun);
   }
   
   if (revolutionTechID == cTechDERevolutionArgentina)
   {
      return(cUnitTypexpGatlingGun);
   }
   
   if (revolutionTechID == cTechDERevolutionCanadaBritish || revolutionTechID == cTechDERevolutionCanadaFrench)
   {
      return(cUnitTypeSkirmisher);
   }
   
   if (revolutionTechID == cTechDERevolutionChile)
   {
      return(cUnitTypexpGatlingGun);
   }
   
   if (revolutionTechID == cTechDERevolutionEgypt)
   {
      return(cUnitTypexpHorseArtillery);
   }
   
   if (revolutionTechID == cTechDERevolutionFinland)
   {
      return(cUnitTypeSkirmisher);
   }
   
   if (revolutionTechID == cTechDERevolutionColombia || revolutionTechID == cTechDERevolutionColombiaPortuguese)
   {
      return(cUnitTypeSkirmisher);
   }
   
   if (revolutionTechID == cTechDERevolutionHaiti)
   {
      return(cUnitTypeFalconet);
   }
   
   if (revolutionTechID == cTechDERevolutionHungaryGerman || revolutionTechID == cTechDERevolutionHungaryOttoman ||
       revolutionTechID == cTechDERevolutionHungaryRussian)
   {
      return(cUnitTypedeNatHungarianGrenadier);
   }
   
   if (revolutionTechID == cTechDERevolutionPeru)
   {
      return(cUnitTypedeSlinger);
   }
   
   if (revolutionTechID == cTechDERevolutionRomania)
   {
      return(cUnitTypexpHorseArtillery);
   }
   
   if (revolutionTechID == cTechDERevolutionSouthAfrica)
   {
      return(cUnitTypeSkirmisher);
   }

   // Prussia - Landwehr
   if (revolutionTechID == cTechDERevolutionPrussia)
   {
      return(cUnitTypedeLandwehr);
   }

   // Duchy of Warsaw - Skirmisher
   if (revolutionTechID == cTechDERevolutionWarsaw)
   {
      return(cUnitTypeSkirmisher);
   }

   // Cossack Hetmanate - Haidamaka
   if (revolutionTechID == cTechDERevolutionCossackHetmanate)
   {
      return(cUnitTypedeREVHaidamaka);
   }

   // German Confederation - Landwehrs.
   if (revolutionTechID == cTechDERevolutionGermany)
   {
      return(cUnitTypedeLandwehr);
   }

   return(-1);
}

//==============================================================================
// hasRevolutionSubRevolution
//==============================================================================
bool hasRevolutionSubRevolution(int revolutionTechID = -1)
{
   if (revolutionTechID < 0)
   {
      return(false);
   }
   
   if (revolutionTechID == cTechDERevolutionFrance)
   {
      return(true);
   }

   // Prussia can revolt on into the German Confederation.
   if (revolutionTechID == cTechDERevolutionPrussia)
   {
      return(true);
   }

   return(false);
}

//==============================================================================
// getRevolutionSubRevolutionTech
//==============================================================================
int getRevolutionSubRevolutionTech(int revolutionTechID = -1)
{
   if (revolutionTechID < 0)
   {
      return(-1);
   }
   
   if (revolutionTechID == cTechDERevolutionFrance)
   {
      return(cTechDERevolutionFranceNE);
   }

   // Prussia - German Confederation
   if (revolutionTechID == cTechDERevolutionPrussia)
   {
      return(cTechDERevolutionGermany);
   }

   return(-1);
}

//==============================================================================
// doesRevolutionSpawnUnitsFromBuildings
//==============================================================================
bool doesRevolutionSpawnUnitsFromBuildings(int revolutionTechID = -1)
{
   if (revolutionTechID < 0)
   {
      return(false);
   }
   
   if (revolutionTechID == cTechDERevolutionBrazil)
   {
      return(true);
   }
   
   if (revolutionTechID == cTechDERevolutionHaiti)
   {
      return(true);
   }
   
   if (revolutionTechID == cTechDERevolutionHungaryGerman || revolutionTechID == cTechDERevolutionHungaryOttoman ||
       revolutionTechID == cTechDERevolutionHungaryRussian)
   {
      return(true);
   }
   
   if (revolutionTechID == cTechDERevolutionRomania)
   {
      return(true);
   }
   
   return(false);
}

//==============================================================================
// doesRevolutionHaveHero
//==============================================================================
bool doesRevolutionHaveHero(int revolutionTechID = -1)
{
   if (revolutionTechID < 0)
   {
      return(false);
   }
   
   if (revolutionTechID == cTechDERevolutionArgentina)
   {
      return(true);
   }
   
   if (revolutionTechID == cTechDERevolutionColombia || revolutionTechID == cTechDERevolutionColombiaPortuguese)
   {
      return(true);
   }
   
   if (revolutionTechID == cTechDERevolutionPeru)
   {
      return(true);
   }
   
   return(false);
}

//==============================================================================
// getRevolutionHeroType
//==============================================================================
int getRevolutionHeroType(int revolutionTechID = -1)
{
   if (revolutionTechID < 0)
   {
      return(-1);
   }
   
   if (revolutionTechID == cTechDERevolutionArgentina)
   {
      return(cUnitTypedeREVSanMartin);
   }
   
   if (revolutionTechID == cTechDERevolutionColombia || revolutionTechID == cTechDERevolutionColombiaPortuguese)
   {
      return(cUnitTypedeREVBolivar);
   }
   
   if (revolutionTechID == cTechDERevolutionPeru)
   {
      return(cUnitTypedeREVBolivar);
   }
   
   return(-1);
}

//==============================================================================
// doesRevolutionUseOutpostMechanic
//==============================================================================
bool doesRevolutionUseOutpostMechanic(int revolutionTechID = -1)
{
   if (revolutionTechID < 0)
   {
      return(false);
   }
   
   if (revolutionTechID == cTechDERevolutionHungaryGerman || revolutionTechID == cTechDERevolutionHungaryOttoman ||
       revolutionTechID == cTechDERevolutionHungaryRussian)
   {
      return(true);
   }
   
   if (revolutionTechID == cTechDERevolutionRomania)
   {
      return(true);
   }
   
   if (revolutionTechID == cTechDERevolutionFinland)
   {
      return(true);
   }
   
   return(false);
}

//==============================================================================
// doesRevolutionUseLivestockMechanic
//==============================================================================
bool doesRevolutionUseLivestockMechanic(int revolutionTechID = -1)
{
   if (revolutionTechID < 0)
   {
      return(false);
   }
   
   if (revolutionTechID == cTechDERevolutionArgentina)
   {
      return(true);
   }
   
   if (revolutionTechID == cTechDERevolutionBrazil)
   {
      return(true);
   }
   
   if (revolutionTechID == cTechDERevolutionColombia || revolutionTechID == cTechDERevolutionColombiaPortuguese)
   {
      return(true);
   }
   
   if (revolutionTechID == cTechDERevolutionPeru)
   {
      return(true);
   }
   
   return(false);
}

//==============================================================================
// getSettlerEnablingCard
//==============================================================================
int getSettlerEnablingCard(int revolutionTechID = -1)
{
   switch (revolutionTechID)
   {
      case cTechDERevolutionBarbaryStates:
         return (cTechDEHCREVDhimma);
      case cTechDERevolutionBrazil:
         return (cTechDEHCREVMinasGerais);
      case cTechDERevolutionChile:
         return (cTechDEHCREVSalitrera);
      case cTechDERevolutionIndonesia:
         return (cTechDEHCREVAcehExports);
      case cTechDERevolutionHungaryGerman:
      case cTechDERevolutionHungaryOttoman:
      case cTechDERevolutionHungaryRussian:
      case cTechDERevolutionRomania:
         return (cTechDEHCREVCitizenship);
      case cTechDERevolutionCossackHetmanate:
         return (cTechDEHCREVCitizenshipCossacks);
      case cTechDERevolutionPrussia:
      case cTechDERevolutionWarsaw:
      case cTechDERevolutionGermany:
         return (cTechDEHCREVCitizenship);
   }
   return (-1);
}

//==============================================================================
// revolutionSettlerCardPriority
//==============================================================================
rule revolutionSettlerCardPriority
inactive
minInterval 10
maxInterval 20
{
   if ((gRevolutionType & cRevolutionMilitary) == 0 || (gRevolutionType & cRevolutionEconomic) != 0)
   {
      xsDisableSelf();
      return;
   }
   
   int cardTech = getSettlerEnablingCard(gRevolutionTechID);
   if (cardTech < 0 || kbTechGetStatus(cardTech) != cTechStatusObtainable)
   {
      xsDisableSelf();
      return;
   }
   
   if (aiHCCardsGetCardCount() < 1)
   {
      return;
   }
   
   aiHCCardsBuyCard(cardTech);
   debugCore("Revolution: Sending settler-enabling card " + kbGetTechName(cardTech));
   xsDisableSelf();
}
//==============================================================================
// clearStrandedBuildPlans
// Revolting turns villagers into soldiers mid-build. Anything left in a build
// plan that can no longer build gets released, and the plan goes with it.
//==============================================================================
void clearStrandedBuildPlans(void)
{
   int numberPlans = aiPlanGetNumber(cPlanBuild, -1, true);
   for (int planIndex = numberPlans - 1; planIndex >= 0; planIndex--)
   {
      int planID = aiPlanGetIDByIndex(cPlanBuild, -1, true, planIndex);
      if (planID < 0)
      {
         continue;
      }

      int buildingType = aiPlanGetVariableInt(planID, cBuildPlanBuildingTypeID, 0);
      if (buildingType < 0)
      {
         continue;
      }

      int keptUnits = 0;
      int strandedUnits = 0;
      int numberUnits = aiPlanGetNumberUnits(planID);
      for (int unitIndex = numberUnits - 1; unitIndex >= 0; unitIndex--)
      {
         int unitID = aiPlanGetUnitByIndex(planID, unitIndex);
         if (unitID < 0)
         {
            continue;
         }
         if (kbProtoUnitCanTrain(kbUnitGetProtoUnitID(unitID), buildingType) == true)
         {
            keptUnits++;
            continue;
         }
         aiPlanRemoveUnit(planID, unitID);
         strandedUnits++;
      }

      if ((strandedUnits > 0) && (keptUnits <= 0))
      {
         debugCore("Revolution: dropping build plan " + planID + " for " +
            kbGetProtoUnitName(buildingType) + ", nobody left who can build it.");
         aiPlanDestroy(planID);
      }
   }
}
