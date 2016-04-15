within AixLib.DataBase.HeatPump;
record HeatPumpBaseDataDefinition "Basic heat pump data"
    extends Modelica.Icons.Record;
  import SI = Modelica.SIunits;
  import SIconv = Modelica.SIunits.Conversions.NonSIunits;
  parameter Real table_Qdot_Co[:,:] "Heating power lookup table";
  parameter Real table_Pel[:,:] "Electrical power lookup table";
  parameter SI.MassFlowRate mFlow_Co_nom "nominal mass flow rate in condenser";
  parameter SI.MassFlowRate mFlow_Ev_nom "nominal mass flow rate in evaporator";
  /*parameter String name "Name of Compressor";
  parameter SI.Temp_C to_range[2] "Evaporation temperature range";
  parameter SI.Temp_C tc_range[2] "Condensation temperature range";
  parameter SI.Power Pe_max "Maximum electrical Power usage of compressor";
  parameter SI.Power Pe_nom 
    "Nominal electrical Power usage of compressor (B0/W35)";
  parameter Real n_nom "Nominal Speed of compressor (needed for power control)";
  parameter Real n_range[2] "Continuously variable speed range of compressor";
  //parameter SIconv.AngularVelocity_rpm n_1 "nominal speed at 50Hz (rpm)";
  //parameter SIconv.AngularVelocity_rpm n_2 "nominal speed at 60Hz (rpm)";
  parameter SI.Time TimeStartStop[3] 
    "Time to complete startup and shutdown of compressor and compressor pause";
  parameter SI.Pressure dp_max[2] 
    "Maximum pressure losses in hydraulic circles (1=E,2=C)";
  parameter SI.Volume VE "external volume in evaporator";
  parameter SI.Volume VC "external volume in condenser";
  parameter SI.MassFlowRate mE_min "Minimum mass flow rate in Evaporator";
  parameter SI.MassFlowRate mC_min "Minimum mass flow rate in Condenser";
  parameter SI.Pressure p_max "Maximum pressure of unit";
  parameter Real QoTable[:,:] "Cooling power lookup table";
  //parameter Boolean useQc=false
   // "Are there data for heating power available in HeatPumpTable?";
  parameter Real QcTable[:,:] "Heating power lookup table";
  parameter Real PTable[:,:] "Electrical power lookup table";
  parameter SI.Diameter diameter_C "Hydraulic Diameter of Condenser";
  parameter SI.Diameter diameter_E "Hydraulic Diameter of Evaporator";
  parameter Boolean deltaTco_5 
    "temp. diff. at test conditions is 5 K, otherwise 10 K";
  parameter SI.Power P_aux "in P_Table included auxilary Power";
  //parameter SI.Length cyl_d "Diameter of cylinder";
  //parameter SI.Length cyl_h "Piston stroke";
  //parameter Integer cyl_no "Number of cylinders";*/
/*
      Note: the Pe_nom (at B0/W35 or W10/W35 [groundwater supply, see DIN EN 255]) 
      value must _exactly_ match the respective table value in PTable. This is necessary
      for the PI-controler to work. I.e., the Pe_nom value must be found in the table, or
      the calulation in Combi2DTable must provide that exact value.
*/
  annotation (Documentation(info="<html>
<p><h4><font color=\"#008000\">Overview</font></h4></p>
<p>
Base data definition used in the HeatPump model. It defines the table table_Qdot_Co which gives the condenser heat flow rate and table_Pel which gives the electric power consumption of the heat pump. Both tables define the power values depending on the evaporator inlet temperature (columns) and the evaporator outlet temperature (rows) in W. The nominal heat flow rate in the condenser and evaporator are also defined as parameters. 
</p>
<p><h4><font color=\"#008000\">Level of Development</font></h4></p>
<p><img src=\"modelica://HVAC/Images/stars3.png\"/></p>
</html>",
        revisions="<html>
<p><ul>
<li><i>December 10, 2013&nbsp;</i> by Ole Odendahl:<br/>Formatted documentation appropriately</li>
</ul></p>
</html>
"),Icon,     preferedView="info");
end HeatPumpBaseDataDefinition;
