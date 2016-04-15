within AixLib.DataBase.HeatPump.EN14511;
record Dimplex_LA11AS "Dimplex LA 11 AS"
  import HVAC;
  extends HeatPumpBaseDataDefinition(
    table_Pel=[0,-7,2,7,10; 35,2444,2839,3139,3103; 45,2783,2974,3097,3013],
    table_Qdot_Co=[0,-7,2,7,10; 35,6600,8800,11300,12100; 45,6400,7898,9600,
        10145],
    mFlow_Co_nom=11300/4180/5,
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
according to data from Dimplex data sheets
</p>
<p><h4><font color=\"#008000\">Level of Development</font></h4></p>
<p><img src=\"modelica://HVAC/Images/stars3.png\"/></p>
<p><h4><font color=\"#008000\">References</font></h4></p>
<p>
EN14511
</p>
</html>"));
end Dimplex_LA11AS;
