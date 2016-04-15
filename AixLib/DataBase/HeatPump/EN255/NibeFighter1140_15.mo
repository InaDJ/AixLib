within AixLib.DataBase.HeatPump.EN255;
record NibeFighter1140_15 "Nibe Fighter 1140-15"
  import HVAC;
  extends HeatPumpBaseDataDefinition(
    table_Pel=[0,-5.0,0.0,2,5.0,10; 35,3360,3380,3380,3390,3400; 55,4830,4910,
        4940,4990,5050],
    table_Qdot_Co=[0,-5.0,0.0,2,5.0,10; 35,13260,15420,16350,17730,19930; 55,
        12560,14490,15330,16590,18900],
    mFlow_Co_nom=15420/4180/10,
    mFlow_Ev_nom=(15420 - 3380)/3600/3);

  annotation(preferedView="text", DymolaStoredErrors,
    Icon,
    Documentation(info="<html>
<p><h4><font color=\"#008000\">Overview</font></h4></p>
<p>
According to manufacturer's data, EN 255.
</p>
<p><h4><font color=\"#008000\">Level of Development</font></h4></p>
<p><img src=\"modelica://HVAC/Images/stars3.png\"/></p>
<p><h4><font color=\"#008000\">References</font></h4></p>
<p>
EN 255
</p>
</html>",
      revisions="<html>
<p><ul>
<li><i>December 10, 2013&nbsp;</i> by Ole Odendahl:<br/>Formatted documentation appropriately</li>
</ul></p>
</html>
"));
end NibeFighter1140_15;
