int determineStablesUnit(void)
{
   if (civIsNative() == true)
   {
      if (cMyCiv == cCivXPAztec)
      {
         return (cUnitTypeNoblesHut);
      }
      if (cMyCiv == cCivDEInca)
      {
         return (cUnitTypedeKallanka);
      }
      return (cUnitTypeCorral);
   }

   if (civIsAsian() == true)
   {
      if ((cMyCiv == cCivJapanese) || (cMyCiv == cCivSPCJapanese) || (cMyCiv == cCivSPCJapaneseEnemy))
      {
         return (cUnitTypeypStableJapanese);
      }
      if ((cMyCiv == cCivIndians) || (cMyCiv == cCivSPCIndians))
      {
         return (cUnitTypeypCaravanserai);
      }
      return (cUnitTypeypWarAcademy);
   }

   if (civIsAfrican() == true)
   {
      return (cUnitTypedeWarCamp);
   }

   if (cMyCiv == cCivDEMaltese)
   {
      return (cUnitTypedeCommandery);
   }

   return (cUnitTypeStable);
}

void initEnhancedGlobals(void)
{
   gStablesUnit = determineStablesUnit();

   debugSetup("***Enhanced globals: gStablesUnit = " + kbGetProtoUnitName(gStablesUnit) + "***");
}
