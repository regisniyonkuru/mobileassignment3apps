import 'package:battery_plus/battery_plus.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';

class BatteryService extends ChangeNotifier {
  final Battery _battery = Battery();

  BatteryService() {
    _battery.onBatteryStateChanged.listen((BatteryState state) {
      print('Battery status: $state');
      _battery.batteryLevel.then((level) {
        if (state == BatteryState.charging && level >= 90) {
          Fluttertoast.showToast(
            msg: "Battery level above 90% and charging",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.green,
            textColor: Colors.white,
          );
        }
        notifyListeners(); // Notify listeners of the battery status change
      });
    });
  }
}


