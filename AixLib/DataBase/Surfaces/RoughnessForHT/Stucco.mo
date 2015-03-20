within AixLib.DataBase.Surfaces.RoughnessForHT;
record Stucco
  extends
    DataBase.Surfaces.RoughnessForHT.PolynomialCoefficients_ASHRAEHandbook(
    D=11.58,
    E=5.894,
    F=0.0);

  annotation (Documentation(info="<html>
<p><h4><font color=\"#008000\">Overview</font></h4></p>
<p>
Material: Stucco
</p>
<p><h4><font color=\"#008000\">Level of Development</font></h4></p>
<p><img src=\"modelica://HVAC/Images/stars5.png\"/></p>
<p><h4><font color=\"#008000\">References</font></h4></p>
<p>Record is used in model <a href=\"BaseLib.HeatTransfer.HeatTransfer_Outside\">BaseLib.HeatTransfer.HeatTransfer_Outside</a></p>
<p>Source</p>
<p><ul>
<li>Bibtexkey: ASHRAEHandbook1989</li>
<li>As cited in EnergyPlusRef2011 p.56</li>
</ul></p>
</html>", revisions="<html>
<p><ul>
<li><i>August 30, 2013&nbsp;</i> by Ole Odendahl:<br/>Added documentation and formatted appropriately</li>
<li><i>March 21, 2012&nbsp;</i> by Ana Constantin:<br/>Implemented.</li>
</ul></p>
</html>"));
end Stucco;