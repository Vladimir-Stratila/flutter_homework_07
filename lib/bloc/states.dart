import '../model/indication.dart';


abstract class IndicationsState {}

class IndicationsInitState extends IndicationsState {}

class IndicationsLoadedState implements IndicationsState {
  final List<Indication> indications;

  IndicationsLoadedState(this.indications);
}