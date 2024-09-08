import 'package:mobile_store/core/localization/data/local_data_sources/local_data.dart';
import 'package:mobile_store/core/localization/data/local_data_sources/remote_data.dart';
import 'package:mobile_store/core/localization/domain/repositories/local_repo.dart';

class LocalRepoImpl implements LocalRepo {
  final LocalData localData;
  final RemoteData remoteData;

  LocalRepoImpl(this.localData, this.remoteData);

  @override
  String getLocal() {
    return localData.getLocal();
  }

  @override
  void changeLocal(String local) {
    localData.changeLocal(local);
  }

  @override
  Future<double> getConvertedValue() async {
    String local = getLocal();
    double convertedValue = await remoteData.getConvertAmount(local);

    return convertedValue;
  }
}
