record SuperExampleBuilding_6Orientations_base "SuperExampleBuilding_6Orientations_base"
  extends AixLib.DataBase.Buildings.BuildingBaseRecord(
    numZones = 1,
    zoneSetup = {
		Project.SuperExampleBuilding_6Orientations.SuperExampleBuilding_6Orientations_DataBase.SuperExampleBuilding_6Orientations_LivingRoom()
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
end SuperExampleBuilding_6Orientations_base;


