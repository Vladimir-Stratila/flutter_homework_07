import 'package:sqflite/sqflite.dart';
import '../model/indication.dart';
import '../database/indications_table.dart' as indications;


class IndicationsDatasource {
  final Database db;

  IndicationsDatasource(this.db);

  Future<void> saveIndication(Indication indication) async {
    Map<String, dynamic> row = {
      indications.columnDateTime: indication.dateTime.toIso8601String(),
      indications.columnCharge: indication.charge,
      indications.columnIsCharging: indication.isCharging ? 1 : 0,
      indications.columnWiFi: indication.haveWiFi ? 1 : 0,
      indications.columnInternet: indication.haveInternet ? 1 : 0,
    };
    db.insert(indications.tableName, row);
  }

  Future<List<Indication>> getIndications() async {
    final result = await db.query(indications.tableName);
    if (result.isEmpty) {
      return [];
    }
    return result
      .map((it) => Indication(
        id: it[indications.columnId] as int,
        dateTime: DateTime.parse(it[indications.columnDateTime] as String),
        charge: it[indications.columnCharge] as int,
        isCharging: (it[indications.columnIsCharging] as int) == 1 ? true : false,
        haveWiFi: (it[indications.columnWiFi] as int) == 1 ? true : false,
        haveInternet: (it[indications.columnInternet] as int) == 1 ? true : false,
      ))
      .toList();
  }

  Future<void> cleanAllIndications() async {
    await db.transaction((transaction) async {
      //await transaction.rawQuery('...');
      await transaction.delete(indications.tableName);
      // where: ...
    });
  }
}