within AixLib.DataBase.Radiators.StandardOFD_EnEV2009;
record Kitchen
  "Standard OFD EnEV2009 Kitchen = ThermX2, Profil V (Kermi) Power=970W, L=2600, H=300, Typ=12, {55,45,20}"
  extends RadiatiorBaseDataDefinition(NominalPower = 970, T_flow_nom = 55, T_return_nom = 45, T_room_nom = 20, Exponent = 1.2731, VolumeWater = 9.36, MassSteel = 38.12, RadPercent = 0.3, length = 2.6, height = 3.0);
  annotation(Documentation(info = "<html>
 <h4><span style=\"color:#008000\">Overview</span></h4>
 <p>Kermi radiator: Flachheizkoerper ThermX2, Profil V</p>
 <h4><span style=\"color:#008000\">Level of Development</span></h4>
 <p><img src=\"modelica://AixLib/Resources/Images/Stars/stars3.png\" alt=\"stars: 3 out of 5\"/></p>
 <h4><span style=\"color:#008000\">Concept</span></h4>
 <p>The record contains information about the:</p>
 <ul>
 <li>Nominal&nbsp;power&nbsp;of&nbsp;radiator&nbsp;at&nbsp;nominal&nbsp;temperatures&nbsp;in&nbsp;W</li>
 <li>Nominal&nbsp;temperatures&nbsp;T_flow&nbsp;according&nbsp;to&nbsp;DIN-EN&nbsp;442 in degC</li>
 <li>Nominal&nbsp;temperatures&nbsp;T_return&nbsp;according&nbsp;to&nbsp;DIN-EN&nbsp;442 in degC</li>
 <li>Nominal&nbsp;temperatures&nbsp;T_room&nbsp;according&nbsp;to&nbsp;DIN-EN&nbsp;442 in degC</li>
 <li>Exponent</li>
 <li>Water&nbsp;volume&nbsp;inside&nbsp;radiator&nbsp;in&nbsp;l</li>
 <li>Material&nbsp;mass&nbsp;of&nbsp;radiator&nbsp;in&nbsp;kg</li>
 <li>Percent&nbsp;of&nbsp;radiative&nbsp;heat from total produced heat</li>
 <li>Length of radiator in m</li>
 <li>Height of radiator in m</li>
 </ul>
 <p><br/>Not all this information is used in the model, just the power, the temperatures, the exponent, the percentage and the volume.</p>
 <h4><span style=\"color:#008000\">References</span></h4>
 <p>Record is used in model <a href=\"AixLib.HVAC.Radiators.Radiator\">AixLib.HVAC.Radiators.Radiator</a></p>
 <p>Source:</p>
 <ul>
 <li>Manufacturer: Kermi</li>
 <li>Product: Flachheizkoerper ThermX2 Profil V</li>
 <li>Booklet: Flachheizkoerper, I/2010, Pages 44-52.</li>
 </ul>
 </html>", revisions = "<html>
 <p>13.11.2013, by <i>Ana Constantin</i>: implemented</p>
 </html>"));
end Kitchen;

