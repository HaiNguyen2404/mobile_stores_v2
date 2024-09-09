import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_store/core/localization/domain/usecases/local_usecases.dart';

part 'local_state.dart';

class LocalCubit extends Cubit<LocalState> {
  final GetLocal getLocal;
  final ChangeLocal changeLocal;
  final GetConvertedValue getConvertedValue;

  LocalCubit(
    this.getLocal,
    this.changeLocal,
    this.getConvertedValue,
  ) : super(InitialState('en'));

  checkLocalState() async {
    String local = getLocal.execute();

    double convertedValue = await getConvertedValue.execute();

    if (local == "en") {
      emit(English(local));
    } else {
      emit(Vietnamese(local, convertedValue));
    }
  }

  changeLocalState(String local) {
    changeLocal.execute(local);
    checkLocalState();
  }

  String checkLocal() {
    String local = getLocal.execute();
    return local;
  }
}
