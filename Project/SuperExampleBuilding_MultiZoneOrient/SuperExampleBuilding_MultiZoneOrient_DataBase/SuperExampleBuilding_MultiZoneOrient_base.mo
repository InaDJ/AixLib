record SuperExampleBuilding_MultiZoneOrient_base "SuperExampleBuilding_MultiZoneOrient_base"
  extends AixLib.DataBase.Buildings.BuildingBaseRecord(
    numZones = 2,
    zoneSetup = {
		Project.SuperExampleBuilding_MultiZoneOrient.SuperExampleBuilding_MultiZoneOrient_DataBase.SuperExampleBuilding_MultiZoneOrient_LivingRoom(),
		Project.SuperExampleBuilding_MultiZoneOrient.SuperExampleBuilding_MultiZoneOrient_DataBase.SuperExampleBuilding_MultiZoneOrient_LivingRoom2()
		},
    Vair = 980.0 ,
    BuildingArea = 280.0
	,	
	heating = false,
	cooling = false,
	dehumidification = false,
	humidification = false,
	BPF_DeHu = 0.2,
	HRS = false,
	efficiencyHRS_enabled = 0.8,
	efficiencyHRS_disabled = 0.2
    );
end SuperExampleBuilding_MultiZoneOrient_base;


