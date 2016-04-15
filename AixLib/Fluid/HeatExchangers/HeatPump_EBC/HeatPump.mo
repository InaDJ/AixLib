within AixLib.Fluid.HeatExchangers.HeatPump_EBC;
model HeatPump
  import SI = Modelica.SIunits;
  import HVAC;
  import DataBase;
  parameter Boolean HP_ctrl_type =  true "Capacity control type"
    annotation(Dialog(group = "Heat Pump cycle", compact = true, descriptionLabel = true), choices(choice=true
        "On/off heat pump",choice = false "Speed controlled heat pump",
                              radioButtons = true));
  parameter Integer Cap_calc_type = 1 "Type of capacity calculation"
    annotation(Dialog(group = "Heat Pump cycle", compact = true, descriptionLabel = true, enable=HP_ctrl_type), choices(choice=1
        "Polynomial", choice = 2 "Table (only on/off heat pump)",   radioButtons = true));
  replaceable package Medium_Co =
      Modelica.Media.Interfaces.PartialMedium
    "Medium outside the refrigerant cycle (Condenser)"
                            annotation (Evaluate=true, Dialog(tab="Evaporator, Condenser",group="Condenser"),choicesAllMatching=true);
    parameter Real quaPresLoss_Co=0
    "Pressure loss: Coefficient for quadratic term"   annotation ( Dialog(tab="Evaporator, Condenser",group="Condenser"));
  parameter Real linPresLoss_Co=0 "Pressure loss: Coefficient for linear term" annotation ( Dialog(tab="Evaporator, Condenser",group="Condenser"));

  replaceable package Medium_Ev =
      Modelica.Media.Interfaces.PartialMedium
    "Medium outside the refrigerant cycle (Evaporator)"
                            annotation (Evaluate=true, Dialog(tab="Evaporator, Condenser",group="Evaporator"),choicesAllMatching=true);

  parameter Real quaPresLoss_Ev=0
    "Pressure loss: Coefficient for quadratic term" annotation ( Dialog(tab="Evaporator, Condenser",group="Evaporator"));
  parameter Real linPresLoss_Ev=0 "Pressure loss: Coefficient for linear term" annotation ( Dialog(tab="Evaporator, Condenser",group="Evaporator"));

  parameter SI.Volume volume_Ev=0.004
    "External medium volume in heat exchanger"                                   annotation ( Dialog(tab="Evaporator, Condenser",group="Evaporator"));
 // parameter Integer n_Ev=3 "External discretisation of heat exchanger" annotation ( Dialog(tab="Evaporator, Condenser",group="Evaporator"));
 parameter SI.Volume volume_Co=0.004 "External medium volume in heat exchanger"
                                                                                annotation ( Dialog(tab="Evaporator, Condenser",group="Condenser"));
 // parameter Integer n_Co=3 "External discretisation of heat exchanger" annotation ( Dialog(tab="Evaporator, Condenser",group="Condenser"));
  parameter DataBase.HeatPump.HeatPumpBaseDataDefinition data_table=
      DataBase.HeatPump.EN255.Vitocal350BWH110()
    "Look-up table data for on/off heat pump according to EN255" annotation (
      choicesAllMatching=true, Dialog(enable=HP_ctrl_type and (Cap_calc_type
           == 2), group="Capacity data"));
/*  parameter HeatPumpSystem.HeatPump.TableData.HeatPumpBaseDataDefinition        data_table_EN14511=
       HeatPumpSystem.HeatPump.TableData.EN14511.StiebelEltron_WPL18() 
    "Look-up table data for on/off heat pump according to EN14511"  annotation(choicesAllMatching=true,Dialog(enable=HP_ctrl_type and (Cap_calc_type==2),group="Capacity data"));*/
protected
  final parameter Real table_Qdot_Co[:,:]=data_table.table_Qdot_Co;
  final parameter Real table_Pel[:,:]= data_table.table_Pel;
public
  replaceable function data_poly =
  HVAC.Components.HeatGenerators.HeatPump.Characteristics.Danfoss_HRH029U2_hpc
    constrainedby
    HVAC.Components.HeatGenerators.HeatPump.Characteristics.baseFct
    "Polynomial heat pump characteristics for inverter heat pump"
   annotation(choicesAllMatching = true,Dialog(enable=(Cap_calc_type==1),group="Capacity data"));

  parameter SI.Temperature T_start_Ev=273.15 "initial evaporator temperature"
   annotation (Evaluate=true, Dialog(tab="Evaporator, Condenser", group="Initialization", enable=initEvaporatorVol));
  parameter SI.Temperature T_start_Co=308.15 "initial condenser temperature"
  annotation (Evaluate=true, Dialog(tab="Evaporator, Condenser", group="Initialization", enable=initCondenserVol));
  replaceable function Corr_icing =
  HVAC.Components.HeatGenerators.HeatPump.Corrections.Defrost.noModel
    constrainedby
    HVAC.Components.HeatGenerators.HeatPump.Corrections.Defrost.baseFct
    "Frost/Defrost model (only air-to-water heat pumps)"
   annotation(choicesAllMatching = true,Dialog(enable=(Cap_calc_type==1),group="Defrosting/Icing correction",tab="Advanced"));

 /* replaceable function Corr_spreadCo =
  HeatPumpSystem.HeatPump.Corrections.CondenserTempSpread.noModel
    constrainedby 
    HeatPumpSystem.HeatPump.Corrections.CondenserTempSpread.baseFct 
    "Correction for external temperature spread at condenser"
   annotation(choicesAllMatching = true,Dialog(group="Correction models",tab="Advanced"));*/
  parameter Real N_max=4200 "Maximum speed of compressor in 1/min"  annotation(Dialog(enable=not
                                                                                              (HP_ctrl_type),group="Capacity data"));
  parameter Real N_min=1500 "Minimum speed of compressor in 1/min"  annotation(Dialog(enable=not
                                                                                              (HP_ctrl_type),group="Capacity data"));
  parameter Real N_nom=3600 "Nominal speed of compressor in 1/min"  annotation(Dialog(enable=HP_ctrl_type and (Cap_calc_type == 1),group="Capacity data"));
  parameter Boolean Pel_ouput=false "Electric power consumption"
  annotation (Dialog(group="Optional outputs",tab="Advanced", descriptionLabel = true), choices(checkBox=true));
  parameter Boolean CoP_output=false "CoP"
  annotation (Dialog(group="Optional outputs",tab="Advanced", descriptionLabel = true), choices(checkBox=true));
  parameter Boolean PT1_cycle=false "First Order model for capacity" annotation(Dialog(group = "Start/stop behavior",tab="Advanced"), choices(checkBox=true));
  parameter SI.Time T_hp_cycle=1 "Time constant for first order model" annotation(Dialog(group = "Start/stop behavior",tab="Advanced", enable=PT1_cycle));
  /*parameter Boolean Pel_trapezoid=false "rising and falling of elctric power" annotation(Dialog(group = "Start/stop behavior",tab="Advanced"), choices(checkBox=true));
  parameter SI.Time rising=0 "start-up of electric power"   annotation(Dialog(group = "Start/stop behavior",tab="Advanced", enable=Pel_trapezoid));
  parameter SI.Time falling=0 "shut-off of electric power"   annotation(Dialog(group = "Start/stop behavior",tab="Advanced", enable=Pel_trapezoid));*/
  parameter Real eta_el=1
    "assumption of P_tech/P_el (for calculation of Evaporator load)"                         annotation(Dialog(group="Assumptions",tab="Advanced"));
  parameter Real factor_scale=1
    "scaling factor (Attention: not physically correct)"
     annotation(Dialog(group="Assumptions",tab="Advanced"));
  parameter SI.Power Pel_add=0
    "additional electric power when heat pump is on (not influenced through scaling factor)"
     annotation(Dialog(group="Assumptions",tab="Advanced"));

  parameter Boolean CorrFlowCo=false
    "Correction of mass flow different from nominal flow in condenser"
    annotation(Dialog(group="Mass flow correction",tab="Advanced"), choices(checkBox=true));
  parameter SI.MassFlowRate mFlow_Co_nominal=0.5
    "Nominal mass flow rate in condenser, only for polynomials, as already included in data tables"
                                                                                                    annotation(Dialog(group="Mass flow correction",tab="Advanced",enable=(CorrFlowCo and Cap_calc_type==1)));

  parameter Boolean CorrFlowEv=false
    "Correction of mass flow different from nominal flow in evaporator"
    annotation(Dialog(group="Mass flow correction",tab="Advanced"), choices(checkBox=true));
  parameter SI.MassFlowRate mFlow_Ev_nominal=0.5
    "Nominal mass flow rate in evaporator, only for polynomials, as already included in data tables"
                                                                                                     annotation(Dialog(group="Mass flow correction",tab="Advanced",enable=(CorrFlowEv and Cap_calc_type==1)));

  Partial.HeatExchangerHP  Condenser(  redeclare package Medium =
        Medium_Co,
    a=quaPresLoss_Co,
    b=linPresLoss_Ev,
    volume=volume_Co,
    T_start=T_start_Co)      annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={130,0})));
  Partial.HeatExchangerHP  Evaporator( redeclare package Medium =
        Medium_Ev,
    b=linPresLoss_Ev,
    volume=volume_Ev,
    a=quaPresLoss_Ev,
    T_start=T_start_Ev)  annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-130,0})));
  Modelica.Fluid.Interfaces.FluidPort_b port_Ev_out(redeclare package Medium =
        Medium_Ev) "Evaporator fluid output port"
    annotation (Placement(transformation(extent={{-140,-80},{-120,-60}},
          rotation=0)));
  Modelica.Fluid.Interfaces.FluidPort_a port_Ev_in(redeclare package Medium =
        Medium_Ev) "Evaporator fluid input port"
    annotation (Placement(transformation(extent={{-140,60},{-120,80}},
          rotation=0)));
  Modelica.Fluid.Sensors.TemperatureTwoPort T_Ev_in(
                                              redeclare package Medium =
        Medium_Ev) annotation (Placement(transformation(
        origin={-130,26},
        extent={{-10,-10},{10,10}},
        rotation=270)));
  Modelica.Fluid.Sensors.TemperatureTwoPort T_Co_in(
                                             redeclare package Medium =
        Medium_Co) annotation (Placement(transformation(
        origin={130,-26},
        extent={{-10,-10},{10,10}},
        rotation=90)));
  Modelica.Fluid.Interfaces.FluidPort_a port_Co_in(redeclare package Medium =
        Medium_Co) "Condenser fluid input port"
    annotation (Placement(transformation(extent={{120,-80},{140,-60}},
          rotation=0)));
  Modelica.Fluid.Interfaces.FluidPort_b port_Co_out(redeclare package Medium =
        Medium_Co) "Condenser fluid ouput port"
    annotation (Placement(transformation(extent={{120,60},{140,80}},
          rotation=0)));
  Modelica.Fluid.Sensors.TemperatureTwoPort T_Co_out(
                                             redeclare package Medium =
        Medium_Co) annotation (Placement(transformation(
        origin={130,30},
        extent={{-10,-10},{10,10}},
        rotation=90)));
  Modelica.Fluid.Sensors.TemperatureTwoPort T_Ev_out(
                                              redeclare package Medium =
        Medium_Ev) annotation (Placement(transformation(
        origin={-130,-30},
        extent={{-10,-10},{10,10}},
        rotation=270)));
  Modelica.Fluid.Sensors.MassFlowRate m_flow_Co(redeclare package Medium =
        Medium_Co) annotation (Placement(transformation(
        origin={130,-50},
        extent={{-10,-10},{10,10}},
        rotation=90)));
  Modelica.Blocks.Interfaces.RealOutput Pel_out if Pel_ouput annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-50,-90})));
  Modelica.Blocks.Interfaces.RealOutput CoP_out if CoP_output annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-10,-90})));

  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow HeatFlow_Qdot_Co
    annotation (Placement(transformation(
        origin={95,1},
        extent={{9,-9},{-9,9}},
        rotation=180)));

public
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow HeatFlow_Qdot_Ev
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
          rotation=180,
        origin={-100,2})));

  parameter Modelica.Blocks.Types.Smoothness smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments
    "smoothness of table interpolation" annotation(Dialog(group = "Assumptions",tab="Advanced", enable=not
                                                                                              (Cap_calc_type==1)));

  parameter Boolean delay_Qdot_Co=false "Delay model for capacity" annotation(Dialog(group = "Start/stop behavior",tab="Advanced"), choices(checkBox=true));
  parameter SI.Time delayTime=0 "Delay time of capacity to electric power" annotation(Dialog(group = "Start/stop behavior",tab="Advanced", enable=delay_Qdot_Co));
  Modelica.Fluid.Sensors.MassFlowRate m_flow_Ev(redeclare package Medium =
        Medium_Ev) annotation (Placement(transformation(
        origin={-130,52},
        extent={{-10,-10},{10,10}},
        rotation=270)));
  Partial.Cycle cycle(HP_ctrl_type=HP_ctrl_type,Cap_calc_type=Cap_calc_type,
    data_table=data_table,
    redeclare function data_poly=data_poly,
    N_max=N_max,
    N_min=N_min,
    N_nom=N_nom,
    Corr_icing=Corr_icing,
    eta_el=eta_el,
    factor_scale=factor_scale,
    Pel_add=Pel_add,
    CorrFlowCo=CorrFlowCo,
    CorrFlowEv=CorrFlowEv,
    T_hp_cycle=T_hp_cycle,
    delay_Qdot_Co=delay_Qdot_Co,
    delayTime=delayTime,
    smoothness=smoothness,
    PT1_cycle=true,
    mFlow_Co_nominal=mFlow_Co_nominal,
    mFlow_Ev_nominal=mFlow_Ev_nominal,
    T_Co_max=T_Co_max)
    annotation (Placement(transformation(extent={{-48,-20},{42,40}})));
  Modelica.Blocks.Interfaces.BooleanInput OnOff_in annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-50,90})));
  Modelica.Blocks.Interfaces.RealInput N_in if not HP_ctrl_type annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-10,90})));

parameter Boolean HeatLossesCo=false
    "Consider heat losses of condenser to ambient"  annotation(Dialog(group="Heat losses of condenser",tab="Advanced"), choices(checkBox=true));
parameter SI.ThermalConductance R_loss=1
    "Thermal conductance of heat loss to ambient"                                      annotation(Dialog(group = "Heat losses of condenser",tab="Advanced", enable=HeatLossesCo));
protected
  Modelica.Blocks.Interfaces.RealInput N_in_internal
    "Needed to connect to conditional connector";
  Modelica.Blocks.Interfaces.RealInput T_amb_internal
    "Needed to connect to conditional connector";
public
  Modelica.Blocks.Sources.RealExpression dummy_zero(y=0)            annotation (Placement(transformation(extent={{0,60},{
            20,80}},
          rotation=0)));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor
                                heatConv(G=R_loss)
    annotation (Placement(transformation(extent={{80,40},{100,60}})));
  Modelica.Blocks.Interfaces.RealInput T_amb if
                                               HeatLossesCo annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={50,90})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature varTemp
    annotation (Placement(transformation(extent={{80,76},{100,96}})));
  parameter SI.Temperature T_Co_max=338.15
    "Maximum condenser outlet temperature";
  Modelica.Blocks.Math.Gain negative(k=-1) annotation (Placement(
        transformation(
        extent={{-5,-5},{5,5}},
        rotation=180,
        origin={-73,5})));
equation

  if HP_ctrl_type then
    connect(N_in_internal,dummy_zero.y);
  else
    connect(N_in,N_in_internal);
  end if;
  connect(N_in_internal,cycle.N_in);

  if HeatLossesCo then
    connect(T_amb_internal, T_amb);
    connect(Condenser.thermalPort, heatConv.port_b);
  else
    connect(varTemp.T, dummy_zero.y);
  end if;
  connect(varTemp.T, T_amb_internal);
  connect(varTemp.port, heatConv.port_a);

  //fluid connections evaporator
  connect(Evaporator.port_a1, T_Ev_in.port_b) annotation (Line(
      points={{-130,10},{-130,16}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(Evaporator.port_b1, T_Ev_out.port_a) annotation (Line(
      points={{-130,-10},{-130,-20}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(T_Ev_out.port_b, port_Ev_out) annotation (Line(
      points={{-130,-40},{-130,-70}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(port_Ev_in, m_flow_Ev.port_a) annotation (Line(
      points={{-130,70},{-130,62}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(m_flow_Ev.port_b, T_Ev_in.port_a) annotation (Line(
      points={{-130,42},{-130,36}},
      color={0,127,255},
      smooth=Smooth.None));

  //fluid connections condenser
  connect(m_flow_Co.port_a, port_Co_in)
                                       annotation (Line(
      points={{130,-60},{130,-70}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(m_flow_Co.port_b, T_Co_in.port_a)
                                           annotation (Line(
      points={{130,-40},{130,-36}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(T_Co_in.port_b, Condenser.port_a1) annotation (Line(
      points={{130,-16},{130,-10}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(Condenser.port_b1, T_Co_out.port_a) annotation (Line(
      points={{130,10},{130,20}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(T_Co_out.port_b, port_Co_out)
   annotation (Line(
      points={{130,40},{130,70}},
      color={0,127,255},
      smooth=Smooth.None));
  // other connections
  connect(HeatFlow_Qdot_Co.port, Condenser.thermalPort) annotation (Line(
      points={{104,1},{104,0},{124,0},{124,3.67394e-016}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(HeatFlow_Qdot_Ev.port, Evaporator.thermalPort) annotation (Line(
      points={{-110,2},{-116.5,2},{-116.5,-1.10218e-015},{-124,
          -1.10218e-015}},
      color={191,0,0},
      smooth=Smooth.None));

  connect(OnOff_in, cycle.OnOff_in) annotation (Line(
      points={{-50,90},{-50,56},{-18,56},{-18,37}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(cycle.Qdot_Co_out,HeatFlow_Qdot_Co.Q_flow)  annotation (Line(
      points={{36,13},{84,13},{84,1},{86,1}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(T_Co_out.T, cycle.T_Co_out) annotation (Line(
      points={{119,30},{52,30},{52,25},{36,25}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(T_Co_in.T, cycle.T_Co_in) annotation (Line(
      points={{119,-26},{56,-26},{56,1},{36,1}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(m_flow_Co.m_flow, cycle.m_flow_Co) annotation (Line(
      points={{119,-50},{108,-50},{108,-48},{50,-48},{50,7},{36,7}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(m_flow_Ev.m_flow, cycle.m_flow_Ev) annotation (Line(
      points={{-119,52},{-76,52},{-76,19},{-42,19}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(cycle.CoP_out, CoP_out) annotation (Line(
      points={{-6,-17},{-6,-64},{-10,-64},{-10,-90}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(cycle.Pel_out, Pel_out) annotation (Line(
      points={{-18,-17},{-18,-58},{-50,-58},{-50,-90}},
      color={0,0,127},
      smooth=Smooth.None));

  connect(T_Ev_in.T, cycle.T_Ev_in) annotation (Line(
      points={{-119,26},{-80,26},{-80,1},{-42,1}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(T_Ev_out.T, cycle.T_Ev_out) annotation (Line(
      points={{-119,-30},{-62,-30},{-62,25},{-42,25}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(HeatFlow_Qdot_Ev.Q_flow, negative.y) annotation (Line(
      points={{-90,2},{-80,2},{-80,5},{-78.5,5}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(negative.u, cycle.Qdot_Ev_out) annotation (Line(
      points={{-67,5},{-64,5},{-64,6},{-62,6},{-62,13},{-42,13}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-150,
            -100},{150,100}}),
                         graphics), Icon(coordinateSystem(preserveAspectRatio=true,
          extent={{-150,-100},{150,100}}), graphics={
        Rectangle(
          extent={{-130,90},{130,-90}},
          fillColor={230,230,230},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Rectangle(
          extent={{-120,80},{-80,-80}},
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Rectangle(
          extent={{80,80},{120,-80}},
          fillColor={255,0,128},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Text(
          extent={{-80,2},{80,-40}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          textString="%name
"),     Ellipse(extent={{-80,80},{80,-80}}, lineColor={0,0,0}),
        Line(
          points={{-88,40},{-112,40},{-94,-2},{-112,-40},{-88,-40}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{88,40},{112,40},{94,-2},{112,-40},{88,-40}},
          color={0,0,0},
          smooth=Smooth.None)}),
             Documentation(info="<html>
<h4><span style=\"color:#008000\">Overview</span></h4>
<p>Heat pump black box model with two simple heat exchangers, no controllers included. </p>
<p>Works as on/off-controlled heat pump or heat pump with capacity control. The type of capacity and electrical power calculation can be chosen: </p>
<ol>
<li>Polynom<br>a) depending on evaporator input temperature, condenser output temperature and variable speed (via conditional speed connector) for capacity controlled heat pumps <br>b) depending on evaporator input temperature, condenser output temperature and nominal speed for on/off-controlled heat pump </li>
<li>Table data according for on/off-controlled heat pump, depending on evaporator input temperature, condenser output temperature </li>
</ol>
<h4><span style=\"color:#008000\">Level of Development</span></h4>
<p><img src=\"modelica://HVAC/Images/stars2.png\"/></p>
<h4><span style=\"color:#008000\">Assumptions</span></h4>
<p>Correction models of the calculation can be activated that effect the efficiency or the start-up and shut-off behavior of the heat pump. </p>
<ol>
<li>Icing and Defrosting: Simple model that use the evaporator inlet temperature and calculates a factor for CoP correction (according to Wetter and Afjei, 1996). Not enabled for table data, as usually already included (data according EN255 and EN14511). </li>
<li>Mass flow in condenser/evaporator: Model according to Pahud and Lachal, 2004, that corrects the temperatures used within table and polynomial. </li>
<li>First order behavior of heat pump capacity: Start-up and shut-off of heat pump can be modeled with a first order behavior. </li>
<li>Delay of heat pump capacity: Start-up and shut-off of heat pump can be modeled with a delay time. </li>
<li>Electric efficiency: The electric efficiency of the electric drive is implemented to calculate the evaporator heat flow </li>
<li>Scaling factor: A scaling facor is implemented for scaling of the heat pump power and capacity without effecting the heat pump efficiency which might not be physically correct but may be helpful for rough calculation.</li>
<li>Additional electric power: This is a constant value that is added to the power consumption. This may be helpful if e.g. an electric drive operates together with the compressor and shall be included in overall electric power and CoP calculation.</li>
<li>The smoothness of table interpolation can be chosen.</li>
<li>Allowed sink temperature: A maximum condenser outlet temperature limits the condenser heat flow through a PID controller. </li>
</ol>
<h4><span style=\"color:#008000\">Known Limitations</span></h4>
<ul>
<li>Allowed source temperature: No limits for source temperature is implemented. Though, usually this is not a problem if the heat pump is properly integrated into a system model. </li>
<li>Allowed sink temperature: No limits for sink temperature is implemented. Be careful when setting up the heat pump control. </li>
<li>Defrost: No direct implementation of dynamic defrost behavior. </li>
</ul>
<h4><span style=\"color:#008000\">Concept</span></h4>
<p>The heat pump speed is helt between the boundaries N_min and N_max even if the input speed is higher or lower. But no further controlling is implemented. The control logic is conciously not integrated into this model.</p>
<p>The calculation of the capacity and electric power does not represent any dynamic behavior of the refrigerant cycle as it occurs in real heat pumps. Therefor two possibilities exist, to add dynamic behavior: </p>
<ol>
<li>The condenser and evaporator can be parametized with a certain external fluid volume to represent their thermal inertia in the tab Evaporator/Condenser</li>
<li>A first order element can be added to the calculation in the tab Advanced if the check box PT1_cycle is enabled (see: <i>Correction models)</i></li>
</ol>
<h4><span style=\"color:#008000\">References</span></h4>
<p>Sources:</p>
<ul>
<li>Pahud, D. and Lachal, B.: <i>Mesure des performances thermiques d?une pompe &agrave; chaleur coupl&eacute;e sur des sondes g&eacute;othermiques &agrave; Lugano (TI)</i>. Office f&eacute;d&eacute;ral de l&apos;energie, Bern, Switzerland. 2004. </li>
<li>Wetter, M. and Afjei, T.: <i>TRNSYS TYPE 401 - Kompressionsw&auml;rmepumpe inklusiv Frost- und Taktverluste</i>. Zentralschweizerisches Technikum Luzern - Ingenieruschule HTL, Switzerland. 1996. </li>
</ul>
<h4><span style=\"color:#008000\">Example Results</span></h4>
<p>See <a href=\"HVAC.Examples.HeatPump\">HVAC.Examples.HeatPump</a> </p>
</html>",
      revisions="<html>
<p><ul>
<li><i>January 09, 2006&nbsp;</i> by Peter Matthes:<br/>V0.1: Initial configuration.</li>
<li><i>March 27, 2013</i> by Kristian Huchtemann:<br/>Corrected connection of evaporator inlet and outlet temperature connectors. Added maximum condenser temperature implementation.</li>
<li><i>December 10, 2013&nbsp;</i> by Ole Odendahl:<br/>Formatted documentation appropriately </li>
<li><i>April 23, 2013&nbsp;</i> by Kristian Huchtemann:<br/>implemented</li>
</ul></p>
</html>"));
end HeatPump;
