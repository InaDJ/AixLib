within AixLib.Fluid.HeatExchangers.HeatPump_EBC.Characteristics;
function Danfoss_HRH029U2_hpc
  "Danfoss Compressor HRH029U2, heat pump cycle as described in Huchtemann, Clima2013"
  extends AixLib.Fluid.HeatExchangers.HeatPump_EBC.Characteristics.baseFct(
    N,
    T_co,
    T_ev);
    parameter Real c_Pcomp[9]={-121.895817742685,-6.69475222523586,-0.741398833535756,0.346695719860530,-0.0632496613484093,0.00248287211077431,0.308037814387774,0.287334958233450,8.50710902574777e-05};
    parameter Real c_QdotH[11]={1117.44824422168,181.821867823502,-10.8461898734631,2.28416043730728,-1.60609716381439,-0.0363018400478920,0.000671796531766114,-0.839529878910169,-0.0480748003407580,-0.000218851731308779,4.90318441751983e-05};
/*Huchtemann, K., Streblow, R., and Mueller, D. 2013.
Adaptive supply temperature control for domestic
heat pump systems. In Proceedings of Clima: 8th
International Conference on IAQVEC.*/
algorithm
Char:= { c_Pcomp[1]+c_Pcomp[2]*T_ev+c_Pcomp[3]*T_co+c_Pcomp[4]*N+c_Pcomp[5]*T_ev*T_co+
c_Pcomp[6]*T_ev*N+c_Pcomp[7]*T_ev^2+c_Pcomp[8]*T_co^2+c_Pcomp[9]*T_co^2*N,
c_QdotH[1]+c_QdotH[2]*T_ev+c_QdotH[3]*T_co+c_QdotH[4]*N+
c_QdotH[5]*T_ev*T_co+c_QdotH[6]*T_ev*N+c_QdotH[7]*T_ev*T_co*N+
c_QdotH[8]*T_ev^2+c_QdotH[9]*T_co^2+c_QdotH[10]*N^2+c_QdotH[11]*T_co^2*N};

  annotation (Documentation(info="<html>
<p><h4><font color=\"#008000\">Overview</font></h4></p>
<p>
Polynoms calculated using working cycle calculation procedure in Matlab. 
For a detailed description see Huchtemann2013a (BibTexKey)
</p>
<p><h4><font color=\"#008000\">Level of Development</font></h4></p>
<p><img src=\"modelica://HVAC/Images/stars2.png\"/></p>
</html>",
    revisions="<html>
<p><ul>
<li><i>December 10, 2013&nbsp;</i> by Ole Odendahl:<br/>Formatted documentation appropriately</li>
</ul></p>
</html>
"));
end Danfoss_HRH029U2_hpc;
