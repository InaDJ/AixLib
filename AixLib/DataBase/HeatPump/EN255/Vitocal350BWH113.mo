within AixLib.DataBase.HeatPump.EN255;
record Vitocal350BWH113 "Vitocal 350 BWH 113"
  import HVAC;
  extends HeatPumpBaseDataDefinition(
    table_Pel=[0,-5.0,0.0,5.0,10.0,15.0; 35,3750,3750,3750,3750,3833; 45,4833,
        4917,4958,5042,5125; 55,5583,5667,5750,5833,5958; 65,7000,7125,7250,
        7417,7583],
    table_Qdot_Co=[0,-5.0,0.0,5.0,10.0,15.0; 35,14500,16292,18042,19750,21583;
        45,15708,17167,18583,20083,21583; 55,15708,17167,18583,20083,21583; 65,
        15708,17167,18583,20083,21583],
    mFlow_Co_nom=16292/4180/10,
    mFlow_Ev_nom=12300/3600/3);

  annotation(preferedView="text", DymolaStoredErrors,
    Icon,
    Documentation(info="<html>
<p><h4><font color=\"#008000\">Overview</font></h4></p>
<p>
Data from manufacturer's data sheet (Viessmann). These curves are given in the data sheet for measurement procedure according to EN 255.
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
end Vitocal350BWH113;
