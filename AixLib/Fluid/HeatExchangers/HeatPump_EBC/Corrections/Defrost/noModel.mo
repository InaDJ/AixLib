within AixLib.Fluid.HeatExchangers.HeatPump_EBC.Corrections.Defrost;
function noModel "No model"
  extends AixLib.Fluid.HeatExchangers.HeatPump_EBC.Corrections.Defrost.baseFct(
      T_ev);

algorithm
f_cop_icing:=1;

  annotation (Documentation(info="<html>
<p><h4><font color=\"#008000\">Overview</font></h4></p>
<p>
No correction factor for icing/defrosting: f_cop_icing=1.
</p>
<p><h4><font color=\"#008000\">Level of Development</font></h4></p>
<p><img src=\"modelica://HVAC/Images/stars2.png\"/></p>
</html>",
  revisions="<html>
<p><ul>
<li><i>December 10, 2013&nbsp;</i> by Ole Odendahl:<br/>Formatted documentation appropriately</li>
</ul></p>
</html>"));
end noModel;
