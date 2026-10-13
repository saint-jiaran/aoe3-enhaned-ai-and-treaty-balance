extern bool gMeijiRestorationActive = false;
extern bool gMeijiNavySwapped = false;

bool isJapaneseIsolation(void)
{
   if ((cMyCiv != cCivJapanese) && (cMyCiv != cCivSPCJapanese) && (cMyCiv != cCivSPCJapaneseEnemy))
   {
      return (false);
   }
   if (gConsulateFlagTechID != cTechypBigConsulateJapanese)
   {
      return (false);
   }
   return (true);
}

rule meijiRestorationManager
inactive
minInterval 30
{
   if (isJapaneseIsolation() == false)
   {
      return;
   }

   int consulateID = getUnit(cUnitTypeypConsulate, cMyID, cUnitStateAlive);
   if (consulateID < 0)
   {
      return;
   }

   int age = kbGetAge();

   if (kbTechGetStatus(cTechypConsulateJapaneseKoujou) == cTechStatusObtainable)
   {
      researchSimpleTech(cTechypConsulateJapaneseKoujou, -1, consulateID);
   }

   if (gMeijiRestorationActive == false)
   {
      if (kbTechGetStatus(cTechypConsulateJapaneseMeijiRestoration) == cTechStatusActive)
      {
         gMeijiRestorationActive = true;
         debugTechs("Meiji Restoration is active - Japan has modernised");
         xsEnableRule("meijiNavalTransitionManager");
         xsEnableRule("meijiImperialTechManager");
      }
      else if (kbTechGetStatus(cTechypConsulateJapaneseMeijiRestoration) == cTechStatusObtainable)
      {
         if (age >= cAge4)
         {
            researchSimpleTech(cTechypConsulateJapaneseMeijiRestoration, -1, consulateID);
            debugTechs("Researching the Meiji Restoration at the Consulate");
         }
      }
   }
}

rule meijiNavalTransitionManager
inactive
minInterval 20
{
   if (gMeijiRestorationActive == false)
   {
      return;
   }

   if (gMeijiNavySwapped == true)
   {
      xsDisableSelf();
      return;
   }

   if (kbProtoUnitAvailable(cUnitTypedeSteamer) == false)
   {
      return;
   }

   debugTechs("Meiji: repointing the navy from Atakabune/Tekkousen to Steamer/Ironclad");

   gGalleonUnit = cUnitTypedeSteamer;
   gFrigateUnit = cUnitTypexpIronclad;
   gMonitorUnit = cUnitTypexpIronclad;

   if (gGalleonMaintain >= 0)
   {
      aiPlanDestroy(gGalleonMaintain);
      gGalleonMaintain = -1;
   }
   if (gFrigateMaintain >= 0)
   {
      aiPlanDestroy(gFrigateMaintain);
      gFrigateMaintain = -1;
   }
   if (gMonitorMaintain >= 0)
   {
      aiPlanDestroy(gMonitorMaintain);
      gMonitorMaintain = -1;
   }
   gBattleshipMaintain = -1;

   gMeijiNavySwapped = true;
   debugTechs("Meiji: naval maintain plans cleared, warShipManager will rebuild them");
   xsDisableSelf();
}

rule meijiImperialTechManager
inactive
minInterval 45
{
   if (gMeijiRestorationActive == false)
   {
      return;
   }

   int consulateID = getUnit(cUnitTypeypConsulate, cMyID, cUnitStateAlive);
   if (consulateID < 0)
   {
      return;
   }

   bool allDone = true;

   if (kbTechGetStatus(cTechypConsulateJapaneseMeijiRangedDamage) == cTechStatusObtainable)
   {
      allDone = false;
      researchSimpleTech(cTechypConsulateJapaneseMeijiRangedDamage, -1, consulateID);
   }

   if (cvOkToBuild == true)
   {
      if (kbTechGetStatus(cTechypConsulateJapaneseMeijiFactoryWagon) == cTechStatusObtainable)
      {
         allDone = false;
         researchSimpleTech(cTechypConsulateJapaneseMeijiFactoryWagon, -1, consulateID);
      }

      if ((cvOkToBuildForts == true) &&
          (kbTechGetStatus(cTechypConsulateJapaneseMeijiFortWagon) == cTechStatusObtainable))
      {
         allDone = false;
         researchSimpleTech(cTechypConsulateJapaneseMeijiFortWagon, -1, consulateID);
      }
   }

   if (allDone == true)
   {
      debugTechs("Meiji: all Imperial Consulate techs taken, disabling manager");
      xsDisableSelf();
   }
}
