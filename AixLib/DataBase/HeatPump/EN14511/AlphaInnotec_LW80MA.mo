within AixLib.DataBase.HeatPump.EN14511;
record AlphaInnotec_LW80MA "Alpha Innotec LW 80 M-A"
  import HVAC;
  extends HeatPumpBaseDataDefinition(
    table_Pel=[0,-7,2,7,10,15,20; 35,2625,2424,2410,2395,2347,2322; 45,3136,
        3053,3000,2970,2912,2889; 50,3486,3535,3451,3414,3365,3385],
    table_Qdot_Co=[0,-7,2,7,10,15,20; 35,6300,8000,9400,10300,11850,13190; 45,
        6167,7733,9000,9750,11017,11730; 50,6100,7600,8800,9475,10600,11000],
    mFlow_Co_nom=9400/4180/5,
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
according to manufacturer's data which was inter- and extrapolated linearly
</p>
<p><h4><font color=\"#008000\">Level of Development</font></h4></p>
<p><img src=\"modelica://HVAC/Images/stars3.png\"/></p>
<p><h4><font color=\"#008000\">References</font></h4></p>
<p>
EN14511
</p>
</html>"));
end AlphaInnotec_LW80MA;
