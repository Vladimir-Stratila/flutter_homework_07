import 'package:flutter_bloc/flutter_bloc.dart';
import '../database/database.dart';
import '../datasource/ds_indication.dart';
import 'states.dart';
import 'events.dart';


class IndicationsBloc extends Bloc<IndicationsEvent, IndicationsState> {
  IndicationsBloc() : super(IndicationsInitState()) {
    on<LoadIndicationsEvent>(onLoadIndicationsEvent);
    on<AddIndicationEvent>(onAddIndicationEvent);
  }

  Future<void> onLoadIndicationsEvent(
    LoadIndicationsEvent event, Emitter<IndicationsState> emit) async {
      final db = await provideDb();
      final indicationsDs = IndicationsDatasource(db);
      final indications = await indicationsDs.getIndications();
      emit(IndicationsLoadedState(indications));
    }

  Future<void> onAddIndicationEvent(
    AddIndicationEvent event, Emitter<IndicationsState> emit) async {
      final db = await provideDb();
      final indicationsDs = IndicationsDatasource(db);
      indicationsDs.saveIndication(event.indication);
    }
}