within AixLib.DataBase.HeatPump.EN14511;
record Ochsner_GMLW_19 "Ochsner GMLW 19"
  import HVAC;
  extends HeatPumpBaseDataDefinition(
    table_Pel=[0,-10,2,7; 35,4300,4400,4600; 50,6300,6400,6600],
    table_Qdot_Co=[0,-10,2,7; 35,11600,17000,20200; 50,10200,15600,18800],
    mFlow_Co_nom=20200/4180/5,
    mFlow_Ev_nom=1);

  annotation(preferedView="text", DymolaStoredErrors,
    Icon,
    Documentation(revisions="<html>
<p><ul>
<li><i>December 10, 2013&nbsp;</i> by Ole Odendahl:<br/>Formatted documentation appropriately</li>
</ul></p>
</html>
", info=
    "<html>
<p><h4><font color=\"#008000\">Overview</font></h4></p>
<p>
.according to data from Ochsner data sheets
</p>
<p><h4><font color=\"#008000\">Level of Development</font></h4></p>
<p><img src=\"modelica://HVAC/Images/stars3.png\"/></p>
<p><h4><font color=\"#008000\">References</font></h4></p>
<p>
EN14511
</p>
</html>"));
end Ochsner_GMLW_19;
