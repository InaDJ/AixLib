within AixLib.Fluid.HeatExchangers.HeatPump_EBC.Partial;
model Cycle
  parameter Boolean HP_ctrl_type =  true "Capacity control type"
    annotation(Dialog(group = "Heat Pump cycle", compact = true, descriptionLabel = true), choices(choice=true
        "On/off heat pump",choice = false "Speed controlled heat pump",
                              radioButtons = true));
  parameter Integer Cap_calc_type = 1 "Type of capacity calculation"
    annotation(Dialog(group = "Heat Pump cycle", compact = true, descriptionLabel = true, enable=HP_ctrl_type), choices(choice=1
        "Polynomial", choice = 2 "Table (only on/off heat pump)",   radioButtons = true));

  parameter AixLib.DataBase.HeatPump.HeatPumpBaseDataDefinition data_table=
      AixLib.DataBase.HeatPump.EN255.Vitocal350BWH110()
    "Look-up table data for on/off heat pump according to EN255/EN14511"
    annotation (choicesAllMatching=true, Dialog(enable=HP_ctrl_type and (
          Cap_calc_type == 2), group="Capacity data"));
protected
  final parameter Real table_Qdot_Co[:,:]=data_table.table_Qdot_Co;
  final parameter Real table_Pel[:,:]= data_table.table_Pel;
public
  replaceable function data_poly =
  AixLib.Fluid.HeatExchangers.HeatPump_EBC.Characteristics.Danfoss_HRH029U2_hpc
    constrainedby
    AixLib.Fluid.HeatExchangers.HeatPump_EBC.Characteristics.baseFct
    "Polynomial heat pump characteristics for inverter heat pump"
   annotation(choicesAllMatching = true,Dialog(enable=(Cap_calc_type==1),group="Capacity data"));

  replaceable function Corr_icing =
  AixLib.Fluid.HeatExchangers.HeatPump_EBC.Corrections.Defrost.noModel
    constrainedby
    AixLib.Fluid.HeatExchangers.HeatPump_EBC.Corrections.Defrost.baseFct
    "Frost/Defrost model (only air-to-water heat pumps)"
   annotation(choicesAllMatching = true,Dialog(enable=(Cap_calc_type==1),group="Defrosting/Icing correction",tab="Advanced"));
parameter Modelica.SIunits.Temperature T_Co_max=338.15
    "Maximum condenser outlet temperature"                                        annotation(Dialog(group="Heat Pump cycle"));
  parameter Real N_max=4200 "Maximum speed of compressor in 1/min"  annotation(Dialog(enable=not
                                                                                            (HP_ctrl_type),group="Capacity data"));
  parameter Real N_min=1500 "Minimum speed of compressor in 1/min"  annotation(Dialog(enable=not
                                                                                            (HP_ctrl_type),group="Capacity data"));
  parameter Real N_nom=3600 "Nominal speed of compressor in 1/min"  annotation(Dialog(enable=HP_ctrl_type and (Cap_calc_type == 1),group="Capacity data"));
  parameter Boolean PT1_cycle=false "First Order model for capacity" annotation(Dialog(group = "Start/stop behavior",tab="Advanced"), choices(checkBox=true));
  parameter Modelica.SIunits.Time T_hp_cycle=1
    "Time constant for first order model"                                            annotation(Dialog(group = "Start/stop behavior",tab="Advanced", enable=PT1_cycle));
  /*parameter Boolean Pel_trapezoid=false "rising and falling of elctric power" annotation(Dialog(group = "Start/stop behavior",tab="Advanced"), choices(checkBox=true));
  parameter Modelica.SIunits.Time rising=0 "start-up of electric power"   annotation(Dialog(group = "Start/stop behavior",tab="Advanced", enable=Pel_trapezoid));
  parameter Modelica.SIunits.Time falling=0 "shut-off of electric power"   annotation(Dialog(group = "Start/stop behavior",tab="Advanced", enable=Pel_trapezoid));*/
  parameter Real eta_el=1
    "assumption of P_tech/P_el (for calculation of Evaporator load)"                         annotation(Dialog(group="Assumptions",tab="Advanced"));
  parameter Real factor_scale=1
    "scaling factor (Attention: not physically correct)"
     annotation(Dialog(group="Assumptions",tab="Advanced"));
  parameter Modelica.SIunits.Power Pel_add=0
    "additional electric power when heat pump is on (not influenced through scaling factor)"
     annotation(Dialog(group="Assumptions",tab="Advanced"));

  parameter Boolean CorrFlowCo=false
    "Correction of mass flow different from nominal flow in condenser"
    annotation(Dialog(group="Mass flow correction",tab="Advanced"), choices(checkBox=true));

  parameter Modelica.SIunits.MassFlowRate mFlow_Co_nominal=0.5
    "Nominal mass flow rate in condenser"
  annotation(Dialog(group="Mass flow correction",tab="Advanced", enable=(CorrFlowCo and Cap_calc_type==1)));

 // parameter Modelica.SIunits.TemperatureDifference deltaT_Co_nominal=5 "Nominal temperature spread in condenser"
 // annotation(Dialog(group="Mass flow correction",tab="Advanced", enable=(CorrFlowCo and Cap_calc_type==1)));

  parameter Boolean CorrFlowEv=false
    "Correction of mass flow different from nominal flow in evaporator"
    annotation(Dialog(group="Mass flow correction",tab="Advanced"), choices(checkBox=true));

  parameter Modelica.SIunits.MassFlowRate mFlow_Ev_nominal=0.5
    "Nominal mass flow rate in evaporator"
  annotation(Dialog(group="Mass flow correction",tab="Advanced",enable=(CorrFlowEv and Cap_calc_type==1)));

 // parameter Modelica.SIunits.TemperatureDifference deltaT_Ev_nominal=5 "Nominal temperature spread in evaporator"
 // annotation(Dialog(group="Mass flow correction",tab="Advanced", enable=(CorrFlowEv and Cap_calc_type==1)));

  Modelica.SIunits.Power Pel;
  Modelica.SIunits.Power Pel_char;
  Modelica.SIunits.HeatFlowRate Qdot_Ev;
  Modelica.SIunits.HeatFlowRate Qdot_Co;
  Modelica.SIunits.HeatFlowRate Qdot_Co_char;
  Real CoP;
  Real CoP_corr;
  Real CoP_char;
  Real N;
  Real f_cop_icing;
  //Real f_cop_spread;
  Real Char[2];
  Real T_Co_out_corr;
  Real T_Ev_in_corr;

  Modelica.Blocks.Interfaces.RealOutput Pel_out annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-50,-90})));
  Modelica.Blocks.Interfaces.BooleanInput OnOff_in annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-50,90})));
  Modelica.Blocks.Interfaces.RealOutput CoP_out annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-10,-90})));
  Modelica.Blocks.Interfaces.RealInput N_in  annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-10,90})));

protected
  Modelica.Blocks.Interfaces.RealInput firstOrder_out_internal
    "Needed to connect to conditional model";
  Modelica.Blocks.Interfaces.RealOutput firstOrder_in_internal
    "Needed to connect to conditional model";
  Modelica.Blocks.Interfaces.RealInput delay_out_internal
    "Needed to connect to conditional model";
  Modelica.Blocks.Interfaces.RealOutput delay_in_internal
    "Needed to connect to conditional model";
  Modelica.Blocks.Interfaces.RealInput Qdot_Co_table_internal
    "Needed to connect to conditional model";
  Modelica.Blocks.Interfaces.RealInput Pel_table_internal
    "Needed to connect to conditional model";
  /*Modelica.Blocks.Interfaces.RealInput Pel_trapezoid_internal 
    "Needed to connect to conditional model";*/
  Modelica.SIunits.MassFlowRate mFlCo_nom;
  Modelica.SIunits.MassFlowRate mFlEv_nom;

public
  Modelica.Blocks.Sources.RealExpression real_Qdot_Co(y=Qdot_Co)
    annotation (Placement(transformation(extent={{40,24},{60,44}},
          rotation=0)));
public
  Modelica.Blocks.Sources.RealExpression real_Qdot_Ev(y=Qdot_Ev)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
          rotation=180,
        origin={-110,-10})));
public
  Modelica.Blocks.Sources.RealExpression real_Pel(y=Pel)
    annotation (Placement(transformation(extent={{-92,-40},{-72,-20}},
          rotation=0)));
public
  Modelica.Blocks.Sources.RealExpression real_CoP(y=CoP)
    annotation (Placement(transformation(extent={{-32,-66},{-12,-46}},
          rotation=0)));

  Modelica.Blocks.Tables.CombiTable2D Qdot_Co_Table(
    tableName="NoName",
    fileName="NoName",
    table=table_Qdot_Co,
    smoothness=smoothness) if
                            not (Cap_calc_type == 1)
    annotation (extent=[-60,40; -40,60], Placement(transformation(extent={{-40,20},
            {-20,40}})));

  Modelica.Blocks.Tables.CombiTable2D Pel_Table(
    tableName="NoName",
    fileName="NoName",
    table=table_Pel,
    smoothness=smoothness) if
                        not (Cap_calc_type == 1) "Electrical power table"
                             annotation (extent=[-60,-20;
        -40,0], Placement(transformation(extent={{-40,-10},{-20,10}})));
public
  Modelica.Blocks.Sources.RealExpression real_T_Ev_in(y=T_Ev_in_corr)
                                                                    annotation (Placement(transformation(extent={{-94,26},
            {-74,46}},
          rotation=0)));
public
  Modelica.Blocks.Sources.RealExpression real_T_Co_out(y=T_Co_out_corr)
                                                                       annotation (Placement(transformation(extent={{-94,6},
            {-74,26}},
          rotation=0)));
  Modelica.Blocks.Continuous.FirstOrder firstOrder(T=T_hp_cycle) if PT1_cycle
    annotation (Placement(transformation(extent={{42,-6},{62,14}})));
public
  Modelica.Blocks.Math.Product product_Pel_CoP
    annotation (Placement(transformation(extent={{8,-46},{28,-26}},
          rotation=0)));
  Modelica.Blocks.Math.UnitConversions.To_degC t_Ev_in
    annotation (extent=[-88,38; -76,50], Placement(transformation(extent={{-68,30},
            {-56,42}})));
  Modelica.Blocks.Math.UnitConversions.To_degC t_Co_out
    annotation (extent=[-88,38; -76,50], Placement(transformation(extent={{-68,10},
            {-56,22}})));
public
  Modelica.Blocks.Sources.RealExpression dummy_zero(y=0)            annotation (Placement(transformation(extent={{40,-86},
            {60,-66}},
          rotation=0)));
public
  Modelica.Blocks.Sources.RealExpression real_CoP_corr(y=CoP_corr)
    annotation (Placement(transformation(extent={{-32,-50},{-12,-30}},
          rotation=0)));
  parameter Modelica.Blocks.Types.Smoothness smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments
    "smoothness of table interpolation" annotation(Dialog(group = "Assumptions",tab="Advanced", enable=not
                                                                                            (Cap_calc_type==1)));
public
  Modelica.Blocks.Logical.TriggeredTrapezoid real_Pel_add(amplitude=Pel_add)
    annotation (Placement(transformation(extent={{-72,-54},{-64,-46}},
          rotation=0)));
public
  Modelica.Blocks.Logical.GreaterThreshold real_Pel_add1
    annotation (Placement(transformation(extent={{-88,-54},{-80,-46}},
          rotation=0)));
  Modelica.Blocks.Math.Add add
    annotation (Placement(transformation(extent={{-56,-52},{-46,-42}})));
  Modelica.Blocks.Nonlinear.FixedDelay fixedDelay(delayTime=delayTime) if delay_Qdot_Co
    annotation (Placement(transformation(extent={{2,-6},{22,14}})));

  parameter Boolean delay_Qdot_Co=false "Delay model for capacity" annotation(Dialog(group = "Start/stop behavior",tab="Advanced"), choices(checkBox=true));
  parameter Modelica.SIunits.Time delayTime=0
    "Delay time of capacity to electric power"                                           annotation(Dialog(group = "Start/stop behavior",tab="Advanced", enable=delay_Qdot_Co));
/*  Modelica.Blocks.Logical.TriggeredTrapezoid trapezoid(
    amplitude=1,
    rising=rising,
    falling=falling,
    offset=0) if Pel_trapezoid annotation (Placement(transformation(extent={{-40,60},{-20,80}})));*/
public
  Modelica.Blocks.Sources.RealExpression dummy_one(y=1)             annotation (Placement(transformation(extent={{40,-70},
            {60,-50}},
          rotation=0)));
  //Modelica.Blocks.Sources.BooleanExpression trapezoid_boolean(y=if
   //     Pel_trapezoid then OnOff_in else false)                     annotation (Placement(transformation(extent={{-122,
   //         -64},{-102,-44}},
   //       rotation=0)));
public
  Modelica.Blocks.Interfaces.RealOutput Qdot_Co_out "Value of Real output"
    annotation (Placement(transformation(extent={{120,0},{140,20}})));
  Modelica.Blocks.Math.UnitConversions.To_degC t_Co_in
    annotation (extent=[-88,38; -76,50], Placement(transformation(extent={{116,-36},
            {104,-24}})));
  Modelica.Blocks.Interfaces.RealInput T_Co_in
    "Connector of Real input signal to be converted" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={130,-30})));
  Modelica.Blocks.Interfaces.RealInput T_Ev_in
    "Connector of Real input signal to be converted" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-130,-30})));
  Modelica.Blocks.Interfaces.RealOutput Qdot_Ev_out "Value of Real output"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-130,10})));
  Modelica.Blocks.Interfaces.RealInput T_Co_out
    "Connector of Real input signal to be converted" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={130,50})));
  Modelica.Blocks.Interfaces.RealInput T_Ev_out
    "Connector of Real input signal to be converted" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-130,50})));
  Modelica.Blocks.Interfaces.RealInput m_flow_Ev
    "Connector of Real input signal to be converted" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-130,30})));
  Modelica.Blocks.Interfaces.RealInput m_flow_Co
    "Connector of Real input signal to be converted" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={130,-10})));
public
  Modelica.Blocks.Sources.RealExpression max_temp_co(y=T_Co_max)    annotation (Placement(transformation(extent={{14,52},
            {34,72}},
          rotation=0)));
public
  Modelica.Blocks.Math.Product product_Pel_CoP1
    annotation (Placement(transformation(extent={{80,30},{100,50}},
          rotation=0)));
  Modelica.Blocks.Continuous.LimPID PID_max_Qdot_Co(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    Ti=1,
    yMax=1,
    yMin=0,
    y_start=1)
    annotation (Placement(transformation(extent={{46,52},{66,72}})));
equation
  // correction of temperatures used in the table/polynomial
  if Cap_calc_type==1 then
    mFlCo_nom= mFlow_Co_nominal;
    mFlEv_nom= mFlow_Ev_nominal;
  else
    mFlCo_nom=data_table.mFlow_Co_nom;
    mFlEv_nom=data_table.mFlow_Ev_nom;
  end if;

  if CorrFlowCo then
    T_Co_out_corr=1/2*(m_flow_Co/mFlCo_nom*(T_Co_out-T_Co_in)+T_Co_in+T_Co_out);
  else
    T_Co_out_corr=T_Co_out;
  end if;

  if CorrFlowEv then
    T_Ev_in_corr=1/2*(m_flow_Ev/mFlEv_nom*(T_Ev_in-T_Ev_out)+(T_Ev_in+T_Ev_out));
  else
    T_Ev_in_corr=T_Ev_in;
  end if;

  // determination of speed N
if HP_ctrl_type then
    N=N_nom;
else
  if N_in > N_max then
      N=N_max;
  else
    if N_in < N_min then
      N=N_min;
    else
      N=N_in;
    end if;
  end if;
end if;
  // determination of basic heat pump characteristics Qdot_Co_char and Pel_char and CoP_char
  if Cap_calc_type==1 then //polynom
    Char=data_poly(N,T_Co_out_corr-273.15, T_Ev_in_corr-273.15);
  else //table
    Char={Pel_table_internal,Qdot_Co_table_internal};
  end if;

  if OnOff_in then
    Qdot_Co_char=Char[2];
    Pel_char=Char[1];
    CoP_char=Qdot_Co_char/Pel_char;
  else
    Qdot_Co_char=0;
    Pel_char=0;
    CoP_char=0;
  end if;

  // determination of CoP-corrections
  if Cap_calc_type==1 then
    f_cop_icing=Corr_icing( T_Ev_in_corr-273.15);
  else
    f_cop_icing=1;
  end if;
  //f_cop_spread=Corr_spreadCo(t_Co_in.y,t_Co_out.y,Cap_calc_type==2);
  CoP_corr=CoP_char*f_cop_icing;//*f_cop_spread;

  //calculation of heat pump characteristics
//   if Pel_trapezoid then
//     Pel=Pel_char*factor_scale*Pel_trapezoid_internal;
//   else
    Pel=Pel_char*factor_scale;
//   end if;
  Qdot_Co=firstOrder_out_internal;
  if OnOff_in then
    if Qdot_Co-Pel*eta_el>0 then
      Qdot_Ev=Qdot_Co-Pel*eta_el;
    else
      Qdot_Ev=0;
    end if;
    CoP=Qdot_Co/(Pel+real_Pel_add.y);
  else
    Qdot_Ev=0;
    CoP=0;
  end if;
  //internal connections for conditional models

  connect(product_Pel_CoP.y,delay_in_internal);
  if delay_Qdot_Co then
    connect(delay_in_internal,fixedDelay.u);
    connect(fixedDelay.y,delay_out_internal);
  else
    connect(delay_in_internal,delay_out_internal);
  end if;
  connect(delay_out_internal,firstOrder_in_internal);
  if PT1_cycle then
    connect(firstOrder_in_internal,firstOrder.u);
    connect(firstOrder.y,firstOrder_out_internal);
  else
     connect(firstOrder_in_internal,firstOrder_out_internal);

  end if;

   if Cap_calc_type==1 then //polynom
     connect(Qdot_Co_table_internal,dummy_zero.y);
     connect(Pel_table_internal,dummy_zero.y);
   else
     connect(Qdot_Co_table_internal,Qdot_Co_Table.y);
     connect(Pel_table_internal,Pel_Table.y);
   end if;

 // if Pel_trapezoid then
 //   connect(Pel_trapezoid_internal,trapezoid.y);
 // else
  //  connect(Pel_trapezoid_internal,dummy_one.y);
  //end if;
//connect(Pel_trapezoid_internal,product_Pel_trapezoid.u2);
  //fluid connections evaporator
  //fluid connections condenser
  // connections to tables
  // other connections
  connect(real_Pel.y, product_Pel_CoP.u1) annotation (Line(
      points={{-71,-30},{6,-30}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(real_CoP.y, CoP_out) annotation (Line(
      points={{-11,-56},{-10,-56},{-10,-90}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(real_T_Ev_in.y, t_Ev_in.u)
                                   annotation (Line(
      points={{-73,36},{-69.2,36}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(real_T_Co_out.y,t_Co_out. u)
                                    annotation (Line(
      points={{-73,16},{-69.2,16}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(real_CoP_corr.y, product_Pel_CoP.u2) annotation (Line(
      points={{-11,-40},{-2,-40},{-2,-42},{6,-42}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(t_Ev_in.y, Qdot_Co_Table.u2) annotation (Line(
      points={{-55.4,36},{-50,36},{-50,24},{-42,24}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(t_Ev_in.y, Pel_Table.u2) annotation (Line(
      points={{-55.4,36},{-50,36},{-50,-6},{-42,-6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(t_Co_out.y, Qdot_Co_Table.u1) annotation (Line(
      points={{-55.4,16},{-48,16},{-48,36},{-42,36}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(t_Co_out.y, Pel_Table.u1) annotation (Line(
      points={{-55.4,16},{-48,16},{-48,6},{-42,6}},
      color={0,0,127},
      smooth=Smooth.None));

  connect(real_Pel_add1.y, real_Pel_add.u) annotation (Line(
      points={{-79.6,-50},{-78,-50},{-78,-48},{-76,-48},{-76,-50},{-72.8,-50}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(real_Pel.y, real_Pel_add1.u) annotation (Line(
      points={{-71,-30},{-66,-30},{-66,-40},{-92,-40},{-92,-50},{-88.8,-50}},
      color={0,0,127},
      smooth=Smooth.None));

  connect(real_Pel_add.y, add.u2) annotation (Line(
      points={{-63.6,-50},{-57,-50}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(real_Pel.y, add.u1) annotation (Line(
      points={{-71,-30},{-66,-30},{-66,-40},{-62,-40},{-62,-44},{-57,-44}},
      color={0,0,127},
      smooth=Smooth.None));

  connect(t_Co_in.u, T_Co_in) annotation (Line(
      points={{117.2,-30},{130,-30}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(real_Qdot_Ev.y, Qdot_Ev_out) annotation (Line(
      points={{-121,-10},{-130,-10},{-130,10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(add.y, Pel_out) annotation (Line(
      points={{-45.5,-47},{-40,-47},{-40,-66},{-50,-66},{-50,-90},{-50,-90}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(product_Pel_CoP1.y, Qdot_Co_out) annotation (Line(
      points={{101,40},{112,40},{112,10},{130,10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(real_Qdot_Co.y, product_Pel_CoP1.u2) annotation (Line(
      points={{61,34},{78,34}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(PID_max_Qdot_Co.u_s, max_temp_co.y) annotation (Line(
      points={{44,62},{35,62}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(PID_max_Qdot_Co.u_m, T_Co_out) annotation (Line(
      points={{56,50},{4,50},{4,80},{114,80},{114,50},{130,50}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(PID_max_Qdot_Co.y, product_Pel_CoP1.u1) annotation (Line(
      points={{67,62},{70,62},{70,46},{78,46}},
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
        Text(
          extent={{-80,2},{80,-40}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          textString="%name
"),     Ellipse(extent={{-80,80},{80,-80}}, lineColor={0,0,0})}),
             Documentation(info="<html>
<h4><span style=\"color:#008000\">Overview</span></h4>
<p>Heat pump refrigerant circuit black box model with two simple heat exchangers, no controllers included. It is used within the HeatPump model and delivers the basic functionality of the heat pump. The HeatPump model only adds the external heat exchangers and according connectors. </p>
<h4><span style=\"color:#008000\">Level of Development</span></h4>
<p><img src=\"modelica://HVAC/Images/stars2.png\"/></p>
<h4><span style=\"color:#008000\">Assumptions</span></h4>
<p>Correction models of the calculation can be activated that effect the efficiency or the start-up and shut-off behavior of the heat pump. </p>
<ol>
<li>Icing and Defrosting: Simple model that use the evaporator inlet temperature and calculates a factor for CoP correction (according to Wetter and Afjei, 1996). Not enabled for table data, as usually already included (data according EN255 and EN14511). </li>
<li>Mass flow in condenser/evaporator: Model according to Pahud and Lachal, 2004, that corrects the temperatures used within table and polynomial. </li>
<li>First order behavior of heat pump capacity: Start-up and shut-off of heat pump can be modeled with a first order behavior. </li>
<li>Start-up and shut-off: Pel_off is corrected by a trapezoid shape. </li>
<li>Delay of heat pump capacity: Start-up and shut-off of heat pump can be modeled with a delay time. </li>
<li>Electric efficiency: The electric efficiency of the electric drive is implemented to calculate the evaporator heat flow </li>
<li>Scaling factor: A scaling facor is implemented for scaling of the heat pump power and capacity without effecting the heat pump efficiency which is not physically correct but may be helpful for rough calculation. </li>
<li>Additional electric power: This is a constant value that is added to the power consumption. This may be helpful if e.g. an electric drive operates together with the compressor and shall be included in overall electric power and CoP calculation. </li>
<li>The smoothness of table interpolation can be chosen. </li>
<li>Allowed sink temperature: A maximum condenser outlet temperature limits the condenser heat flow through a PID controller. </li>
</ol>
<h4><span style=\"color:#008000\">Known Limitations</span></h4>
<ul>
<li>Allowed source temperature: No limits for source temperature is implemented. Though, usually this is not a problem if the heat pump is properly integrated into a system model. </li>
</ul>
<h4><span style=\"color:#008000\">Concept</span></h4>
<p>Works as on/off-controlled heat pump or heat pump with capacity control. The type of capacity and electrical power calculation can be chosen: </p>
<ol>
<li>Polynom <br>a) depending on evaporator input temperature, condenser output temperature and variable speed (via conditional speed connector) for capacity controlled heat pumps <br>b) depending on evaporator input temperature, condenser output temperature and nominal speed for on/off-controlled heat pump </li>
<li>Table data according for on/off-controlled heat pump, depending on evaporator input temperature, condenser output temperature </li>
</ol>
<p>The heat pump speed is helt between the boundaries N_min and N_max even if the input speed is higher or lower. But no further controlling is implemented! The control logic is conciously not integrated into this model! </p>
<p>The calculation of the capacity and electric power does not represent any dynamic behavior of the refrigerant cycle as it occurs in real heat pumps. Therefore two possibilities exist, to add dynamic behavior: </p>
<ol>
<li>The condenser and evaporator can be parametized with a certain external fluid volume to represent their thermal inertia in the tab Evaporator/Condenser</li>
<li>A first order element can be added to the calculation in the tab Advanced if the check box PT1_cycle is enabled (see: <i>Correction models)</i> </li>
</ol>
<h4><span style=\"color:#008000\">References</span></h4>
<p>Sources:</p>
<ul>
<li>Pahud, D. and Lachal, B.: <i>Mesure des performances thermiques d?une pompe &agrave; chaleur coupl&eacute;e sur des sondes g&eacute;othermiques &agrave; Lugano (TI)</i>. Office f&eacute;d&eacute;ral de l&apos;energie, Bern, Switzerland. 2004. </li>
<li>Wetter, M. and Afjei, T.: <i>TRNSYS TYPE 401 - Kompressionsw&auml;rmepumpe inklusiv Frost- und Taktverluste</i>. Zentralschweizerisches Technikum Luzern - Ingenieruschule HTL, Switzerland. 1996. </li>
</ul>
</html>",
      revisions="<html>
<p><ul>
<li><i>March 27, 2013</i> by Kristian Huchtemann:<br/>Added maximum condenser temperature implementation.</li>
<li><i>December 10, 2013&nbsp;</i> by Ole Odendahl:<br/>Formatted documentation appropriately </li>
<li><i>April 23, 2013&nbsp;</i> by Kristian Huchtemann:<br/>implemented</li>
</ul></p>
</html>"));
end Cycle;
