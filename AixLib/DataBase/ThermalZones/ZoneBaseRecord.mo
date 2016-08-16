within AixLib.DataBase.ThermalZones;
record ZoneBaseRecord "Base record definition for zone records"
  extends Modelica.Icons.Record;

  parameter Modelica.SIunits.Temperature T_start "Initial temperature";
  parameter Modelica.SIunits.Volume VAir "Air volume of the zone";
  parameter Modelica.SIunits.Area AZone "Net floor area of zone";
  parameter Modelica.SIunits.CoefficientOfHeatTransfer alphaRad
    "Coefficient of heat transfer for linearized radiation exchange between walls";
  parameter Modelica.SIunits.Angle lat "Latitude of zone location";
  parameter Integer nOrientations(min=1) "Number of orientations";

  parameter Modelica.SIunits.Area AWin[nOrientations]
    "Areas of windows by orientations";
  parameter Modelica.SIunits.Area ATransparent[nOrientations]
    "Areas of transparent (solar radiation transmittend) elements by orientations";
  parameter Modelica.SIunits.CoefficientOfHeatTransfer alphaWin
    "Convective coefficient of heat transfer of windows (indoor)";
  parameter Modelica.SIunits.ThermalResistance RWin "Resistor for windows";
  parameter Modelica.SIunits.TransmissionCoefficient gWin
    "Total energy transmittance of windows";
  parameter Modelica.SIunits.CoefficientOfHeatTransfer UWin
    "Thermal transmission coefficient of windows";
  parameter Real ratioWinConRad
    "Ratio for windows between convective and radiative heat emission";
  parameter Modelica.SIunits.Area AExt[nOrientations] "Areas of exterior walls by orientations";
  parameter Modelica.SIunits.CoefficientOfHeatTransfer alphaExt
    "Convective coefficient of heat transfer for exterior walls (indoor)";
  parameter Integer nExt(min=1) "Number of RC-elements of exterior walls";
  parameter Modelica.SIunits.ThermalResistance RExt[nExt] "Resistances of exterior walls, from inside to outside";
  parameter Modelica.SIunits.ThermalResistance RExtRem "Resistance of remaining resistor RExtRem between capacity n and outside";
  parameter Modelica.SIunits.HeatCapacity CExt[nExt] "Heat capacities of exterior walls, from inside to outside";
  parameter Modelica.SIunits.Area AInt "Area of interior walls";
  parameter Modelica.SIunits.CoefficientOfHeatTransfer alphaInt
    "Convective coefficient of heat transfer of interior walls (indoor)";
  parameter Integer nInt(min=1) "Number of RC-elements of interior walls";
  parameter Modelica.SIunits.ThermalResistance RInt[nInt] "Resistances of interior wall, from port to center";
  parameter Modelica.SIunits.HeatCapacity CInt[nInt] "Heat capacities of interior walls, from port to center";
  parameter Modelica.SIunits.Area AFloor "Area of floor plate";
  parameter Modelica.SIunits.CoefficientOfHeatTransfer alphaFloor
    "Convective coefficient of heat transfer of floor plate (indoor)";
  parameter Integer nFloor(min=1) "Number of RC-elements of floor plate";
  parameter Modelica.SIunits.ThermalResistance RFloor[nFloor] "Resistances of floor plate, from inside to outside";
  parameter Modelica.SIunits.ThermalResistance RFloorRem "Resistance of remaining resistor RFloorRem between capacity n and outside";
  parameter Modelica.SIunits.HeatCapacity CFloor[nFloor] "Heat capacities of floor plate, from inside to outside";
  parameter Modelica.SIunits.Area ARoof "Area of roof";
  parameter Modelica.SIunits.CoefficientOfHeatTransfer alphaRoof
    "Convective coefficient of heat transfer of roof (indoor)";
  parameter Integer nRoof(min=1) "Number of RC-elements of roof";
  parameter Modelica.SIunits.ThermalResistance RRoof[nRoof] "Resistances of roof, from inside to outside";
  parameter Modelica.SIunits.ThermalResistance RRoofRem "Resistance of remaining resistor RRoofRem between capacity n and outside";
  parameter Modelica.SIunits.HeatCapacity CRoof[nRoof] "Heat capacities of roof, from inside to outside";
  parameter Integer nOrientationsRoof(min=1) "Number of orientations for roof";
  parameter Modelica.SIunits.Angle tiltRoof[nOrientationsRoof] "Tilts of roof";
  parameter Modelica.SIunits.Angle aziRoof[nOrientationsRoof] "Azimuths of roof";
  parameter Real wfRoof[nOrientationsRoof]
    "Weight factors of the roof";
  parameter Modelica.SIunits.Emissivity aRoof "Coefficient of absorption of roof (outdoor)";

  parameter Modelica.SIunits.Emissivity aExt "Coefficient of absorption of exterior walls (outdoor)";
  parameter Modelica.SIunits.Temperature Tsoil "Temperature of soil";
  parameter Modelica.SIunits.CoefficientOfHeatTransfer alphaWallOut
    "Exterior walls convective coefficient of heat transfer (outdoor)";
  parameter Modelica.SIunits.CoefficientOfHeatTransfer alphaRadWall
    "Coefficient of heat transfer for linearized radiation for exterior walls";
  parameter Modelica.SIunits.CoefficientOfHeatTransfer alphaWinOut
    "Windows' convective coefficient of heat transfer (outdoor)";
  parameter Modelica.SIunits.CoefficientOfHeatTransfer alphaRadWin
    "Coefficient of heat transfer for linearized radiation for windows";
  parameter Modelica.SIunits.CoefficientOfHeatTransfer alphaRoofOut
    "Roof's convective coefficient of heat transfer (outdoor)";
  parameter Modelica.SIunits.CoefficientOfHeatTransfer alphaRadRoof
    "Coefficient of heat transfer for linearized radiation for roof";
  parameter Modelica.SIunits.Angle tiltExtWalls[nOrientations] "Tilts of exterior walls";
  parameter Modelica.SIunits.Angle aziExtWalls[nOrientations] "Azimuths of exterior walls";
  parameter Real wfWall[nOrientations]
    "Weight factors of the walls";
  parameter Real wfWin[nOrientations]
    "Weight factors of the windows";
  parameter Real wfGro
    "Weight factor of the ground";

  parameter Real nrPeople "Number of people in the room";
  parameter Real ratioConvectiveHeatPeople
    "Ratio of convective heat from overall heat output for people";
  parameter Real nrPeopleMachines "Number of people with machines";
  parameter Real ratioConvectiveHeatMachines
    "Ratio of convective heat from overall heat output for machines";
  parameter Modelica.SIunits.HeatFlux lightingPower "Heat flux of lighting";
  parameter Real ratioConvectiveHeatLighting
    "Ratio of convective heat from overall heat output for lights";
  parameter Boolean useConstantACHrate
    "Choose if a constant infiltration rate is used";
  parameter Real baseACH "Base ACH rate for ventilation controller";
  parameter Real maxUserACH "Additional ACH value for max. user activity";
  parameter Real maxOverheatingACH[2]
    "Additional ACH value when overheating appears, transition range";
  parameter Real maxSummerACH[3]
    "Additional ACH in summer, Tmin, Tmax";
  parameter Real winterReduction[3]
    "Reduction factor of userACH for cold weather";

  parameter Boolean withAHU
    "Zone is connected to central air handling unit";
  parameter Real minAHU(unit = "m3/(h.m2)")
    "Minimum specific air flow supplied by the AHU";
  parameter Real maxAHU(unit = "m3/(h.m2)")
    "Maximum specific air flow supplied by the AHU";

  parameter Real hHeat "Upper limit controller output";
  parameter Real lHeat "Lower limit controller output";
  parameter Real KRHeat "Gain of the controller";
  parameter Modelica.SIunits.Time TNHeat "Time constant of the controller";
  parameter Boolean HeaterOn "Use heater component";
  parameter Real hCool "Upper limit controller output";
  parameter Real lCool "Lower limit controller output";
  parameter Real KRCool "Gain of the controller, abs(l_cooler/80)";
  parameter Modelica.SIunits.Time TNCool
    "Time constant of the controller";
  parameter Boolean CoolerOn "Use chiller component";

  annotation(Documentation(info="<html>
<p>This is the base definition of zone records used in <a href=\"AixLib.Building.LowOrder.ThermalZone\">AixLib.Building.LowOrder.ThermalZone</a>. All necessary parameters are defined here. Most values should be overwritten for a specific building, some are default values that might be appropriate in most cases. However, fell free to overwrite them in your own records. </p>
</html>",  revisions="<html>
<ul>
<li><i>January 4, 2016 </i>by Moritz Lauster:
<br/>Clean up.</li>
<li><i>June, 2015 </i>by Moritz Lauster:
<br/>Added new parameters to use further calculation cores.</li>
<li><i>February 4, 2014&nbsp;</i>by Ole Odendahl:<br/>Added new parameters for the setup of the ACH. It is now possible to assign different values to the ACH for each zone based on this record. </li>
<li><i>January 27, 2014&nbsp;</i>by Ole Odendahl:<br/>Added new parameter withAHU to choose whether the zone is connected to a central air handling unit. Default false </li>
<li><i>March, 2012&nbsp;</i> by Peter Matthes:<br/>Implemented </li>
<li><i>November, 2012&nbsp;</i> by Moritz Lauster:<br/>Restored links </li>
</ul>
</html>"));
end ZoneBaseRecord;