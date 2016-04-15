within AixLib.Fluid.HeatExchangers.HeatPump_EBC.Characteristics;
function Ochsner_GMLW_19plus
  "Ochsner GMLW 19plus, defrost included, no dependency on speed"
  extends AixLib.Fluid.HeatExchangers.HeatPump_EBC.Characteristics.baseFct(
    N,
    T_co,
    T_ev);
    parameter Real c_Pcomp[7]={0.8818,0.00941,0.09351,0.001514,0.0004721,-2.576e-6,-1.234e-5};
    parameter Real c_QdotH[15]={18.1,0.2165,-0.05897, 0.01198,
    0.009865,6.728e-5,0.0002854,3.097e-5,-0.000109,-2.341e-5,
    -2.207e-5,-1.343e-6,6.815e-7,3.929e-8,2.388e-7};

algorithm
Char:= 1000*{
 c_Pcomp[1]+c_Pcomp[2]*T_ev+c_Pcomp[3]*T_co+c_Pcomp[4]*T_ev^2+
 c_Pcomp[5]*T_ev*T_co+c_Pcomp[6]*T_ev^3+c_Pcomp[7]*T_ev^2*T_co,
c_QdotH[1] +c_QdotH[2]*T_ev +c_QdotH[3]*T_co + c_QdotH[4]*T_ev^2 +
c_QdotH[5]*T_co*T_ev +c_QdotH[6]*T_co^2 +c_QdotH[7]*T_ev^3+
c_QdotH[8]*T_ev^2*T_co+ c_QdotH[9]*T_ev*T_co^2+ c_QdotH[10]*T_ev^4 +
c_QdotH[11]*T_ev^3*T_co +c_QdotH[12]*T_ev^2*T_co^2+
c_QdotH[13]*T_ev^5 +c_QdotH[14]*T_ev^4*T_co + c_QdotH[15]*T_ev^3*T_co^2};

  annotation (Documentation(info="<html>
<p><h4><font color=\"#008000\">Overview</font></h4></p>
<p>According to data from Ochsner data sheets (see references) and fitting in Matlab. The polynomials don&apos;t have any dependency on the speed N. It is not clear from the data according to which standartd the data is measured. </p>
<p><h4><font color=\"#008000\">Level of Development</font></h4></p>
<p><img src=\"modelica://HVAC/Images/stars2.png\"/></p>
<p><h4><font color=\"#008000\">References</font></h4></p>
<p><a href=\"http://www.tauschek.net/uploads/tx_sbdownloader/BA_GMLW_HEP_OTE__DE_20090218_Vers1.pdf\">http://www.tauschek.net/uploads/tx_sbdownloader/BA_GMLW_HEP_OTE__DE_20090218_Vers1.pdf</a> </p>
</html>",
    revisions="<html>
<p><ul>
<li><i>December 10, 2013&nbsp;</i> by Ole Odendahl:<br/>Formatted documentation appropriately</li>
</ul></p>
</html>
"));
end Ochsner_GMLW_19plus;
