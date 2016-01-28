model SuperExampleBuilding_4Orientations
  "This is the simulation model of SuperExampleBuilding_4Orientations"

	AixLib.Building.LowOrder.Multizone.MultizoneEquipped multizoneEquipped(
      buildingParam=Project.SuperExampleBuilding_4Orientations.SuperExampleBuilding_4Orientations_DataBase.SuperExampleBuilding_4Orientations_base()


  ,redeclare AixLib.Building.LowOrder.ThermalZone.ThermalZoneEquipped zone

	(redeclare 
        AixLib.Building.LowOrder.BaseClasses.BuildingPhysics.BuildingPhysicsVDI
        buildingPhysics

	 (redeclare 
          AixLib.Building.Components.WindowsDoors.BaseClasses.CorrectionSolarGain.NoCorG
          corG)
))
    annotation (Placement(transformation(extent={{-26,-14},{28,36}})));

  AixLib.Building.Components.Weather.Weather weather(
    Outopt=1,
    Air_temp=true,
    Mass_frac=true,
    Sky_rad=true,
    Ter_rad=true,
    fileName=Modelica.Utilities.Files.loadResource(
        "modelica://AixLib/Resources/WeatherData/TRY2010_12_Jahr_Modelica-Library.txt"),
      Latitude=49.5,
      Longitude=8.5,
    SOD=AixLib.DataBase.Weather.SurfaceOrientation.SurfaceOrientationBaseDataDefinition(
        nSurfaces=4,
        name={"O", "S", "W", "Hor"},
        Azimut={-90.0,0.0,90.0,0.0},
        Tilt={90.0,90.0,90.0,0.0}))
    annotation (Placement(transformation(extent={{-24,68},{6,88}})));

  Modelica.Blocks.Sources.CombiTimeTable tableTSet(
    tableOnFile=true,
    tableName="Tset",
    extrapolation=Modelica.Blocks.Types.Extrapolation.HoldLastPoint,
    columns=2:2,
    fileName=Modelica.Utilities.Files.loadResource(
        "modelica://Project/SuperExampleBuilding_4Orientations/\TSetSuperExampleBuilding_4Orientations.mat"))
    annotation (Placement(transformation(extent={{-92,8},{-72,28}})));

  Modelica.Blocks.Sources.CombiTimeTable tableAHU(
    tableOnFile=true,
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
    tableName="AHU",
    columns=2:5,
    fileName=Modelica.Utilities.Files.loadResource(
        "modelica://Project/SuperExampleBuilding_4Orientations/\AHU_SuperExampleBuilding_4Orientations.mat"))
    annotation (Placement(transformation(extent={{66,-50},{46,-30}})));

  Modelica.Blocks.Sources.CombiTimeTable tableInternalGains(
    tableOnFile=true,
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
    tableName="Internals",
    columns=2:4,
    fileName=Modelica.Utilities.Files.loadResource(
        "modelica://Project/SuperExampleBuilding_4Orientations/\InternalGains_SuperExampleBuilding_4Orientations.mat"))
    annotation (Placement(transformation(extent={{84,18},{64,38}})));

  Modelica.Blocks.Sources.Constant const[1](each k=0)
    annotation (Placement(transformation(extent={{-92,-22},{-72,-2}})));

equation 
  connect(weather.SolarRadiation_OrientedSurfaces, multizoneEquipped.radIn)
    annotation (Line(points={{-16.8,67},{-16.8,50.5},{-15.74,50.5},{-15.74,33.5}},
        color={255,128,0}));

  connect(weather.WeatherDataVector, multizoneEquipped.weather) annotation (
     Line(points={{-9.1,67},{-9.1,52},{-3.32,52},{-3.32,34.5}}, color={0,0,127}));

  connect(tableTSet.y, multizoneEquipped.TSetHeater) annotation (Line(
        points={{-71,18},{-48,18},{-48,12.5},{-24.38,12.5}}, color={0,0,127}));

  connect(tableAHU.y, multizoneEquipped.AHU) annotation (Line(points={{45,-40},
          {12.61,-40},{12.61,-12.25}}, color={0,0,127}));

  connect(tableInternalGains.y, multizoneEquipped.internalGains)
    annotation (Line(points={{63,28},{46,28},{46,27.25},{26.11,27.25}},
        color={0,0,127}));

  connect(const.y, multizoneEquipped.TSetCooler) annotation (Line(points={{-71,
          -12},{-66,-12},{-66,-14},{-48,-14},{-48,5.5},{-24.38,5.5}}, color=
         {0,0,127}));

  annotation (experiment(
      StopTime=31536000,
      Interval=3600,
      __Dymola_Algorithm="Dassl"), __Dymola_experimentSetupOutput(events=false),
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
        graphics={
        Line(points={{80,-82}}, color={28,108,200}),
        Rectangle(
          extent={{-80,20},{80,-80}},
          lineColor={0,0,0},
          lineThickness=0.5),
        Line(
          points={{-80,20},{0,100},{80,20}},
          color={0,0,0},
          thickness=0.5),
        Text(
          extent={{-52,-10},{62,-48}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid,
          textString="TB")}));
end SuperExampleBuilding_4Orientations;








