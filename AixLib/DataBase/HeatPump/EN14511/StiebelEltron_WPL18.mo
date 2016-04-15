within AixLib.DataBase.HeatPump.EN14511;
record StiebelEltron_WPL18 "Stiebel Eltron WPL 18"
  import HVAC;
  extends HeatPumpBaseDataDefinition(
    table_Pel=[0,-7,2,7,10,20; 35,3300,3400,3500,3700,3800; 50,4500,4400,4600,
        5000,5100],
    table_Qdot_Co=[0,-7,2,7,10,20; 35,9700,11600,13000,14800,16300; 50,10000,
        11200,12900,16700,17500],
    mFlow_Co_nom=13000/4180/5,
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
according to data from WPZ Buchs, Swiss
</p>
<p><h4><font color=\"#008000\">Level of Development</font></h4></p>
<p><img src=\"modelica://HVAC/Images/stars3.png\"/></p>
<p><h4><font color=\"#008000\">References</font></h4></p>
<p>
EN14511
</p>
</html>"));
end StiebelEltron_WPL18;
