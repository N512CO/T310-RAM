# Copyright 2018 Stuart Buchanan
# This file is part of FlightGear.
#
# FlightGear is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 2 of the License, or
# (at your option) any later version.
#
# FlightGear is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with FlightGear.  If not, see <http://www.gnu.org/licenses/>.
#
# EIS Driver using Emesary for a single engined aircraft, e.g. Cessna 172.
var GenericEISPublisher =
{

  new : func (period=0.25) {
    var obj = {
      parents : [
        GenericEISPublisher,
        PeriodicPropertyPublisher.new(notifications.PFDEventNotification.EngineData, period)
      ],
    };

    obj.addPropMap("RPM1", "/engines/engine[0]/rpm");
    obj.addPropMap("Man1", "/engines/engine[0]/mp-osi");
    obj.addPropMap("MBusVolts", "/systems/electrical/volts");
    obj.addPropMap("EBusVolts", "/systems/electrical/volts");
    obj.addPropMap("MBattAmps", "/systems/electrical/amps");
    obj.addPropMap("SBattAmps", "/systems/electrical/amps");
    obj.addPropMap("EngineHours1", "/sim/time/hobbs/engine");
    obj.addPropMap("FuelFlowGPH1", "/engines/engine[0]/fuel-flow-gph");
    obj.addPropMap("OilPressurePSI1", "/engines/engine[0]/oil-pressure-psi");
    obj.addPropMap("OilTemperatureF1", "/engines/engine/oil-temperature-degf");
    obj.addPropMap("EGTNorm1", "/engines/engine[0]/egt-degf");
    obj.addPropMap("CHTDegF1", "/engines/engine[0]/cht-degf");
    obj.addPropMap("VacuumSuctionInHG", "/systems/vacuum/suction-inhg");
    
    obj.addPropMap("RPM2", "/engines/engine[1]/rpm");
    obj.addPropMap("Man2", "/engines/engine[1]/mp-osi");
    obj.addPropMap("EngineHours2", "/sim/time/hobbs/engine");
    obj.addPropMap("FuelFlowGPH2", "/engines/engine[1]/fuel-flow-gph");
    obj.addPropMap("OilPressurePSI2", "/engines/engine[1]/oil-pressure-psi");
    obj.addPropMap("OilTemperatureF2", "/engines/engine[1]/oil-temperature-degf");
    obj.addPropMap("EGTNorm2", "/engines/engine[1]/egt-degf");
    obj.addPropMap("CHTDegF2", "/engines/engine[1]/cht-degf");

    return obj;
  },

  # Custom publish method as we package the values into an array of engines,
  # in this case, only one!
  publish : func() {
    var engineData0 = {};

    foreach (var propmap; me._propmaps) {
      var name = propmap.getName();
      engineData0[name] = propmap.getValue();
    }

    var engineData = [];
    append(engineData, engineData0);

    var notification = notifications.PFDEventNotification.new(
      "MFD",
      1,
      notifications.PFDEventNotification.EngineData,
      { Id: "EngineData", Value: engineData } );

    me._transmitter.NotifyAll(notification);
  },
};
