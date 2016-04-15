within AixLib.DataBase.HeatPump.EN14511;
record Ochsner_GMLW_19plus "Ochsner GMLW 19 plus"
  import HVAC;
  extends HeatPumpBaseDataDefinition(
    table_Pel=[0,-10,2,7; 35,4100,4300,4400; 50,5500,5700,5800; 60,6300,6500,
        6600],
    table_Qdot_Co=[0,-10,2,7; 35,12600,16800,19800; 50,11700,15900,18900; 60,
        11400,15600,18600],
    mFlow_Co_nom=19800/4180/5,
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
according to data from Ochsner data sheets
</p>
<p><h4><font color=\"#008000\">Level of Development</font></h4></p>
<p><img src=\"modelica://HVAC/Images/stars3.png\"/></p>
<p><h4><font color=\"#008000\">References</font></h4></p>
<p>
EN14511
</p>
</html>"));
end Ochsner_GMLW_19plus;
