within AixLib.ThermalZones.ReducedOrder.Multizone.BaseClasses;
block AirFlowRateSplit
  "Splits a given air flow rate into parts and converts unit from m3/s to 1/h"
  extends Modelica.Blocks.Icons.Block;

  parameter Integer dimension "Number of Zones";
  parameter Boolean withProfile = false
    "Choose which input should be considered" annotation(choices(choice =  false
        "Relative Occupation",choice = true "Profile",radioButtons = true));
  parameter AixLib.DataBase.ThermalZones.ZoneBaseRecord zoneParam[dimension] "Records of zones";

protected
  Real airFlowShare[dimension] "Share of zones at air flow";
  Real airFlowVector[dimension]
    "Sum of air flow in the zones";
  Real airFlowRateOutput "Sum of air flow rates";
public
  Modelica.Blocks.Interfaces.RealInput profile
    "Input profile for AHU operation"
    annotation (Placement(transformation(extent={{-120,40},{-80,80}}),
        iconTransformation(extent={{-120,40},{-80,80}})));
  Modelica.Blocks.Interfaces.RealInput relOccupation[dimension]
    "Input for relative occupation"                             annotation (
      Placement(transformation(extent={{-120,-74},{-80,-34}}),
        iconTransformation(extent={{-120,-74},{-80,-34}})));
  Modelica.Blocks.Interfaces.RealOutput airFlowSplit[dimension](
  final quantity="VolumeFlowRate",
  final unit="1/h")
    "Output for calculated air flow rateOutput for calculated air flow shares"
    annotation (Placement(transformation(extent={{80,-12},{120,28}}),
        iconTransformation(extent={{80,-12},{120,28}})));
  Modelica.Blocks.Interfaces.RealInput airFlow(
  final quantity="VolumeFlowRate",
  final unit="m3/s")
    "Output for calculated air flow rateInput for air flow rate"
    annotation (Placement(transformation(extent={{-120,-20},{-80,20}}),
        iconTransformation(extent={{-120,-20},{-80,20}})));
equation
  if withProfile then
    airFlowVector * 3600 = ((zoneParam.minAHU + (zoneParam.maxAHU - zoneParam.minAHU) * profile) .* zoneParam.AZone);
  else
    airFlowVector * 3600 = ((zoneParam.minAHU + (zoneParam.maxAHU - zoneParam.minAHU) .* relOccupation) .* zoneParam.AZone);
  end if;
  (airFlowRateOutput,airFlowShare) =
    AixLib.ThermalZones.ReducedOrder.Multizone.BaseClasses.SumCondition(
      airFlowVector,
      zoneParam.withAHU,
      dimension);
  airFlowSplit.*zoneParam.VAir=airFlowShare*airFlow*3600;
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})),           Icon(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={Text(
          extent={{-72,38},{58,-10}},
          lineColor={0,0,0},
          textString="m3/s
 -> 
1/h")}),
    Documentation(info="<html>
<p>This model calculates the volume flow (e.g. for an Air Handling Unit) dependent on:</p>
<ul>
<li>A minimal volume flow (minAHU) in m3/(m2*h)</li>
<li>A maxmial volume flow (maxAHU = deltaAHU + minAHU) <span style=\"font-family: MS Shell Dlg 2;\">in m3/(m2*h)</span></li>
<li>A given profile or relative occupation</li>
</ul>
<p><br/>As AHUs typically work with m3/s, the model calculates the output air flow rate Vdot_air in m3/s.</p>
<p><br/>airFlowRateOutput = [minAHU + deltaAHU * (profile OR relative Occupation)] * Azone * 3600^-1 </p>
</html>", revisions="<html>
<ul>
<li><i>October 30, 2015&nbsp;</i> by Moritz Lauster:<br/>Moved and adapted to AixLib. Some renaming and adding units</li>
</ul>
<ul>
<li><i>March 3, 2014&nbsp;</i> by Ole Odendahl:<br/>Added documentation and formatted appropriately</li>
</ul>
</html>"));
end AirFlowRateSplit;