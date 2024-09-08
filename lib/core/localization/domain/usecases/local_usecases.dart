import 'package:mobile_store/core/localization/domain/repositories/local_repo.dart';

class GetLocal {
  final LocalRepo localRepo;

  GetLocal(this.localRepo);

  String execute() {
    return localRepo.getLocal();
  }
}

class ChangeLocal {
  final LocalRepo localRepo;

  ChangeLocal(this.localRepo);

  void execute(String local) {
    localRepo.changeLocal(local);
  }
}

class GetConvertedValue {
  final LocalRepo localRepo;

  GetConvertedValue(this.localRepo);

  Future<double> execute() {
    return localRepo.getConvertedValue();
  }
}
