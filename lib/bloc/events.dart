import '../model/indication.dart';


abstract class IndicationsEvent {}

class LoadIndicationsEvent extends IndicationsEvent {}

class AddIndicationEvent extends IndicationsEvent {
  final Indication indication;

  AddIndicationEvent(this.indication);
}