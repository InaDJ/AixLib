within AixLib.DataBase.HeatPump.EN255;
record AlphaInnotec_SW170I "Alpha Innotec SW 170 I"
  import HVAC;
  extends HeatPumpBaseDataDefinition(
    table_Pel=[0,-5.0,0.0,5.0; 35,3700,3600,3600; 50,5100,5100,5100],
    table_Qdot_Co=[0,-5.0,0.0,5.0; 35,14800,17200,19100; 50,14400,16400,18300],

    mFlow_Co_nom=17200/4180/10,
    mFlow_Ev_nom=13600/3600/3);

  annotation(preferedView="text", DymolaStoredErrors,
    Icon,
    Documentation(info="<html>
<p><h4><font color=\"#008000\">Overview</font></h4></p>
<p>
according to data from WPZ Buchs, Swiss
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
end AlphaInnotec_SW170I;
