within AixLib.DataBase.HeatPump.EN255;
record Vitocal350BWH110 "Vitocal 350 BWH 110"
  import HVAC;
  extends HeatPumpBaseDataDefinition(
    table_Pel=[0,-5.0,0.0,5.0,10.0,15.0; 35,2478,2522,2609,2696,2783; 45,3608,
        3652,3696,3739,3783; 55,4217,4261,4304,4348,4391; 65,5087,5130,5174,
        5217,5261],
    table_Qdot_Co=[0,-5.0,0.0,5.0,10.0,15.0; 35,9522,11000,12520,14000,15520;
        45,11610,12740,13910,15090,16220; 55,11610,12740,13910,15090,16220; 65,
        11610,12740,13910,15090,16220],
    mFlow_Co_nom=11000/4180/10,
    mFlow_Ev_nom=8400/3600/3);

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
end Vitocal350BWH110;
