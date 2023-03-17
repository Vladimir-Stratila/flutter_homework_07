import 'package:flutter/material.dart';

enum Status {
  isCharging(0, Icon(Icons.battery_charging_full, color: Colors.blue)),
  lessThan9(
      9,
      Icon(
        Icons.battery_0_bar,
        color: Colors.red,
      )),
  lessThan24(
      24,
      Icon(
        Icons.battery_1_bar,
        color: Colors.deepOrange,
      )),
  lessThan39(
      39,
      Icon(
        Icons.battery_2_bar,
        color: Colors.deepOrangeAccent,
      )),
  lessThan54(54, Icon(Icons.battery_3_bar, color: Colors.orange)),
  lessThan69(
      69,
      Icon(
        Icons.battery_4_bar,
        color: Colors.orangeAccent,
      )),
  lessThan84(
      84,
      Icon(
        Icons.battery_5_bar,
        color: Colors.green,
      )),
  lessThan99(
      99,
      Icon(
        Icons.battery_6_bar,
        color: Colors.green,
      )),
  fullCharge(
      100,
      Icon(
        Icons.battery_full,
        color: Colors.green,
      )),
  ;

  final int charge;
  final Icon icon;

  const Status(this.charge, this.icon);

  static Icon getIcon(bool isCharging, int charge) {
    if (isCharging) return Status.isCharging.icon;
    for (Status status in Status.values) {
      if (status.charge >= charge) {
        return status.icon;
      }
    }
    return const Icon(Icons.battery_0_bar);
  }

  @override
  String toString() {
    return "$name($charge)";
  }
}
