record SuperExampleBuilding_5Orientations_base "SuperExampleBuilding_5Orientations_base"
  extends AixLib.DataBase.Buildings.BuildingBaseRecord(
    numZones = 1,
    zoneSetup = {
		Project.SuperExampleBuilding_5Orientations.SuperExampleBuilding_5Orientations_DataBase.SuperExampleBuilding_5Orientations_LivingRoom()
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
end SuperExampleBuilding_5Orientations_base;


