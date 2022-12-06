class Indication {
  final int id;
  final DateTime dateTime;
  final int charge;
  final bool isCharging;
  final bool haveWiFi;
  final bool haveInternet;

  Indication({
    this.id = -1,
    required this.dateTime,
    required this.charge,
    required this.isCharging,
    required this.haveWiFi,
    required this.haveInternet,
  });

  @override
  String toString() {
    return 'Indication: {id: $id, dateTime: $dateTime, charge: $charge,'
        ' isCharging: $isCharging, haveWiFi: $haveWiFi, haveInternet: $haveInternet}';
  }
}