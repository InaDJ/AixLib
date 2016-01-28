record SuperExampleBuilding_4Orientations_base "SuperExampleBuilding_4Orientations_base"
  extends AixLib.DataBase.Buildings.BuildingBaseRecord(
    numZones = 1,
    zoneSetup = {
		Project.SuperExampleBuilding_4Orientations.SuperExampleBuilding_4Orientations_DataBase.SuperExampleBuilding_4Orientations_LivingRoom()
		},
    Vair = 490.0 ,
    BuildingArea = 140.0
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
end SuperExampleBuilding_4Orientations_base;


